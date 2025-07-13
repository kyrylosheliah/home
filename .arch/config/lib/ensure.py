import os
from pathlib import Path
import shlex
import tempfile
from typing import List, Dict
import lib.helpers as helpers
import lib.kconfig as kconfig

log_prefix = f"{helpers.bcolors.DIM}lib.ensure:{helpers.bcolors.ENDC} "

def log_error(message: str):
    helpers.log_error(log_prefix, message)

def log_success(message: str):
    helpers.log_success(log_prefix, message)

def log_warning(message: str):
    helpers.log_warning(log_prefix, message)

def log_info(message: str):
    helpers.log_info(log_prefix, message)

def package_is_installed(package_name: str) -> bool:
    if 0 == helpers.run(['pacman', '-Q', package_name]).returncode:
        return True
    log_warning(f"Package '{package_name}' is not installed")
    return False

def ensure_aur_package_installed_raw(package_name):
    """Ensure some package is installed from AUR assuming yay isn't available"""
    if package_is_installed(package_name):
        return True
    original_cwd = os.getcwd()
    temp_dir = "/tmp"
    try:
        os.chdir(temp_dir)
        package_dir = Path(temp_dir) / package_name
        if package_dir.exists():
            helpers.run(['rm', 'rf', str(package_dir)])
        clone_result = helpers.run(['git', 'clone', f'https://aur.archlinux.org/{package_name}.git'])
        if 0 != clone_result.returncode:
            log_error(f"Failed to clone AUR package '{package_name}': {clone_result.stderr}")
            return False
        os.chdir(str(package_dir))
        makepkg_result = helpers.run(['makepkg', '-si', '--noconfirm'])
        if 0 != makepkg_result.returncode:
            log_error(f"Failed to build '{package_name}': {makepkg_result.stderr}")
            return False
        log_success(f"Installed AUR package '{package_name}'")
        return True
    except Exception as e:
        log_error(f"Error ensuring AUR package '{package_name}': {e}")
        return False
    finally:
        os.chdir(original_cwd)
        package_dir = Path(temp_dir) / package_name
        if package_dir.exists():
            helpers.run(['rm', '-rf', str(package_dir)])

dispatchers_count = 0
def inc():
    global dispatchers_count
    temp_count = dispatchers_count
    dispatchers_count = dispatchers_count + 1
    return temp_count

# Lambda: Callable[[], bool]
# Block: { "ensure": number, "for": List[<AnyFromBelow>] }
module = inc() # { "title": str, "for": List[Block] }
conditional_module = inc() # { "title": str, "condition": Lambda, "module": Module }
conditional_error = inc() # { "title": str, "condition": Lambda }
conditional_execution = inc() # { "title": str, "condition": Lambda, "function": Lambda }
execution = inc() # { "title": str, "function": Lambda }
package_installed = inc() # str
aur_package_installed = inc() # str
user_service_active = inc() # str
system_service_active = inc() # str
file_content = inc() # { "file": str, "content": str }
kconfig_content = inc() # { "file": str, "for": List[{ "group": str, "for": List[{ "key": str, "value": str }] }] }

dispatchers = [None] * dispatchers_count

def ensure_module(module: Dict) -> bool:
    """Main function to ensure all configurations are applied sequentially"""
    ensure_aur_package_installed_raw("yay") # hard dependency
    blocks = module["for"]
    if not isinstance(blocks, list):
        blocks = [ blocks, ]
    for block in blocks:
        parameters = block["for"]
        if not isinstance(parameters, list):
            parameters = [ parameters, ]
        operation = dispatchers[block["ensure"]]
        for parameter in parameters:
            if not operation(parameter):
                log_error(f"Error in module {module["title"]}")
                return False
    log_success(f"Module '{module['title']}' check success")
    return True

dispatchers[module] = ensure_module

def ensure_conditional_module(block: Dict) -> bool:
    if block["condition"]():
        return ensure_module(block.module)
    return True

dispatchers[conditional_module] = ensure_conditional_module

def ensure_conditional_error(block: Dict) -> bool:
    if not block["condition"]():
        log_error(f"Unexpected condition for '{block["title"]}'")
        return False
    return True

dispatchers[conditional_error] = ensure_conditional_error

def ensure_conditional_execution(block: Dict):
    if not block["condition"]():
        return True
    if not block["function"]():
        log_error(f"Unexpected conditional result for '{block["title"]}'")
        return False
    return True

dispatchers[conditional_execution] = ensure_conditional_execution

def ensure_execution(block: Dict):
    if not block["function"]():
        log_error(f"Unexpected conditional result for '{block["title"]}'")
        return False
    return True

dispatchers[execution] = ensure_execution

def ensure_package_installed(package_name: str) -> bool:
    """Ensure a package is installed using pacman"""
    if package_is_installed(package_name):
        return True
    install_result = helpers.run(['sudo', 'pacman', '-S', '--noconfirm', package_name])
    if 0 != install_result.returncode:
        log_error(f"Failed to install pacman package '{package_name}': {install_result.stderr}")
        return False
    log_success(f"Installed pacman package '{package_name}'")
    return True

dispatchers[package_installed] = ensure_package_installed

def ensure_aur_package_installed(package_name: str) -> bool:
    """Ensure an AUR package is installed using yay"""
    if package_is_installed(package_name):
        return True
    install_result = helpers.run(['yay', '-S', '--noconfirm', package_name])
    if 0 != install_result.returncode:
        log_error(f"Failed to install AUR package '{package_name}': {install_result.stderr}")
        return False
    log_success(f"Installed AUR package '{package_name}'")
    return True

dispatchers[aur_package_installed] = ensure_aur_package_installed

def ensure_service_active(systemctl_prefix: List[str], service_name: str) -> bool:
    """Ensure a service is enabled and active"""
    if 'enabled' != helpers.run(systemctl_prefix + ['is-enabled', service_name]).stdout.strip():
        log_warning(f"Service '{service_name}' is not enabled")
        enable_result = helpers.run(systemctl_prefix + ['enable', service_name])
        if 0 != enable_result.returncode:
            log_error(f"Failed to enable service '{service_name}': {enable_result.stderr}")
            return False
        log_success(f"Service '{service_name}' is enabled")
    if 'active' != helpers.run(systemctl_prefix + ['is-active', service_name]).stdout.strip():
        log_warning(f"Service '{service_name}' is not started")
        start_result = helpers.run(systemctl_prefix + ['start', service_name])
        if 0 != start_result.returncode:
            log_error(f"Failed to start service '{service_name}': {start_result.stderr}")
            return False
        log_success(f"Service '{service_name}' is active")
    return True

systemctl_prefixes = [
    [ "systemctl", "--user" ], # is_system = False or 0
    [ "sudo", "systemctl" ], # is_system = True or 1
]

def ensure_user_service_active(service_name: str) -> bool:
    return ensure_service_active(systemctl_prefixes[0], service_name)

dispatchers[user_service_active] = ensure_user_service_active

def ensure_system_service_active(service_name: str) -> bool:
    return ensure_service_active(systemctl_prefixes[1], service_name)

dispatchers[system_service_active] = ensure_system_service_active

def ensure_file_content(file_config: Dict) -> bool:
    """Ensure a file contains specified text"""
    filename = file_config["file"]
    touch_err = helpers.touch_file(filename)
    if len(touch_err):
        log_error(f"Error ensuring '{filename}' exists if FS: {touch_err}")
        return False
    content = file_config["content"]
    if helpers.file_has_content(filename, content):
        return True
    path = Path(filename).parent
    touch_result = helpers.sh(f"sudo mkdir -p {path} && sudo touch -a {filename}")
    if 0 != touch_result.returncode:
        log_error(f"Error ensuring '{filename}' exists if FS: {touch_result.stderr}")
        return False
    newline_result = helpers.sh( # 0a = newline
        f"sudo tail -c1 {shlex.quote(filename)} | od -An -t x1 | grep -q '0a'")
    if 0 != newline_result.returncode:
        content = "\n" + content
    write_result = helpers.sh(
        f"sudo echo {shlex.quote(content)} >> {shlex.quote(filename)}")
    if 0 != write_result.returncode:
        log_error(f"Error writing to '{filename}': {write_result.stderr}")
        return False
    log_success(f"Wrote '{filename}' content")
    return True

dispatchers[file_content] = ensure_file_content

def ensure_kconfig_content(file_config: Dict) -> bool:
    """Ensure a KDE config file has the keys and the values under the specified groups"""
    filename = file_config["file"]
    groups = file_config["for"]
    touch_err = helpers.touch_file(filename)
    if len(touch_err):
        log_error(f"Error ensuring '{filename}' exists if FS: {touch_err}")
        return False
    lines = []
    with open(filename, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    missing_groups = kconfig.filter_groups_to_apply(lines, groups)
    if not len(missing_groups):
        return True
    output = kconfig.write_config_groups(lines, missing_groups)
    tmp = tempfile.NamedTemporaryFile('w', delete=False, encoding='utf-8')
    tmp.write(output)
    tmp_filename = tmp.name
    tmp.close()
    copy_result = helpers.sh(
        f"sudo cp {shlex.quote(tmp_filename)} {shlex.quote(filename)}")
    os.remove(tmp_filename)
    if 0 != copy_result.returncode:
        log_error(f"Error copying the modified KDE config file '{filename}': {copy_result.stderr}")
        return False
    log_success(f"Wrote the KDE config in '{filename}'")
    return True

dispatchers[kconfig_content] = ensure_kconfig_content

