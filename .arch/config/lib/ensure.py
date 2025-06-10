import os
import shlex
from pathlib import Path
from typing import List, Dict
from lib.helpers import run, sh, bcolors
import lib.helpers as helpers

log_prefix = f"{bcolors.DIM}lib.ensure:{bcolors.ENDC} "

def log_error(message: str):
    helpers.log_error(log_prefix, message)

def log_success(message: str):
    helpers.log_success(log_prefix, message)

def log_warning(message: str):
    helpers.log_warning(log_prefix, message)

def log_info(message: str):
    helpers.log_info(log_prefix, message)

def package_is_installed(package_name: str) -> bool:
    if 0 == run(['pacman', '-Q', package_name]).returncode:
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
            run(['rm', 'rf', str(package_dir)])
        clone_result = run(['git', 'clone', f'https://aur.archlinux.org/{package_name}.git'])
        if 0 != clone_result.returncode:
            log_error(f"Failed to clone AUR package '{package_name}': {clone_result.stderr}")
            return False
        os.chdir(str(package_dir))
        makepkg_result = run(['makepkg', '-si', '--noconfirm'])
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
            run(['rm', '-rf', str(package_dir)])

# Lambda: Callable[[], bool]
# Block: { "ensure": number, "for": <AnyFromBelow> | List[<AnyFromBelow>] }
module = 0 # { "title": str, "for": Block | List[Block] }
conditional_module = 1 # { "title": str, "condition": Lambda, "module": Module }
conditional_error = 2 # { "title": str, "condition": Lambda }
conditional_execution = 3 # { "title": str, "condition": Lambda, "function": Lambda }
package_installed = 4 # str
aur_package_installed = 5 # str
user_service_active = 6 # str
system_service_active = 7 # str
file_content = 8 # { "filename": str, "content": str }

operations = {}

def ensure_module(module: Dict) -> bool:
    """Main function to ensure all configurations are applied sequentially"""
    blocks = module["for"]
    ensure_aur_package_installed_raw("yay") # hard dependency
    if not isinstance(blocks, list):
        blocks = [blocks]
    for block in blocks:
        parameters = block["for"]
        if not isinstance(parameters, list):
            parameters = [ parameters, ]
        operation = operations[block["ensure"]]
        for parameter in parameters:
            if not operation(parameter):
                log_error(f"Error in module {module["title"]}")
                return False
    log_success("Module check success")
    return True

operations[module] = ensure_module

def ensure_conditional_module(block: Dict) -> bool:
    if block["condition"]():
        return ensure_module(block.module)
    return True

operations[conditional_module] = ensure_conditional_module

def ensure_conditional_error(block: Dict) -> bool:
    if not block["condition"]():
        log_error(f"Unexpected condition for '{block["title"]}'")
        return False
    return True

operations[conditional_error] = ensure_conditional_error

def ensure_conditional_execution(block: Dict):
    if not block["condition"]():
        return True
    if not block["function"]():
        log_error(f"Unexpected conditional result for '{block["title"]}'")
        return False
    return True

operations[conditional_execution] = ensure_conditional_execution

def ensure_package_installed(package_name: str) -> bool:
    """Ensure a package is installed using pacman"""
    if package_is_installed(package_name):
        return True
    install_result = run(['sudo', 'pacman', '-S', '--noconfirm', package_name])
    if 0 != install_result.returncode:
        log_error(f"Failed to install pacman package '{package_name}': {install_result.stderr}")
        return False
    log_success(f"Installed pacman package '{package_name}'")
    return True

operations[package_installed] = ensure_package_installed

def ensure_aur_package_installed(package_name: str) -> bool:
    """Ensure an AUR package is installed using yay"""
    if package_is_installed(package_name):
        return True
    install_result = run(['yay', '-S', '--noconfirm', package_name])
    if 0 != install_result.returncode:
        log_error(f"Failed to install AUR package '{package_name}': {install_result.stderr}")
        return False
    log_success(f"Installed AUR package '{package_name}'")
    return True

operations[aur_package_installed] = ensure_aur_package_installed

systemctl_prefixes = [
    [ "systemctl", "--user" ], # is_system = False or 0
    [ "sudo", "systemctl" ], # is_system = True or 1
]

def ensure_service_active(systemctl_prefix: List[str], service_name: str) -> bool:
    """Ensure a service is enabled and active"""
    if 'enabled' != run(systemctl_prefix + ['is-enabled', service_name]).stdout.strip():
        log_warning(f"Service '{service_name}' is not enabled")
        enable_result = run(systemctl_prefix + ['enable', service_name])
        if 0 != enable_result.returncode:
            log_error(f"Failed to enable service '{service_name}': {enable_result.stderr}")
            return False
        log_success(f"Service '{service_name}' is enabled")
    if 'active' != run(systemctl_prefix + ['is-active', service_name]).stdout.strip():
        log_warning(f"Service '{service_name}' is not started")
        start_result = run(systemctl_prefix + ['start', service_name])
        if 0 != start_result.returncode:
            print(f"Failed to start service '{service_name}': {start_result.stderr}")
            return False
        log_success(f"Service '{service_name}' is active")
    return True

def ensure_user_service_active(service_name: str) -> bool:
    return ensure_service_active(systemctl_prefixes[0], service_name)

operations[user_service_active] = ensure_user_service_active

def ensure_system_service_active(service_name: str) -> bool:
    return ensure_service_active(systemctl_prefixes[1], service_name)

operations[system_service_active] = ensure_system_service_active

def ensure_file_content(file_config: Dict) -> bool:
    """Ensure a file contains specified text"""
    filename = file_config["filename"]
    content = file_config["content"]
    grep_result = sh(
        f"sudo grep -Fq -- {shlex.quote(content)} {shlex.quote(filename)}")
    if 0 == grep_result.returncode:
        return True
    log_warning(f"File '{filename}' content missing")
    newline_result = sh( # 0a = newline
        f"sudo tail -c1 {shlex.quote(filename)} | od -An -t x1 | grep -q '0a'")
    if 0 != newline_result.returncode:
        content = "\n" + content
    write_result = sh(
        f"sudo echo {shlex.quote(content)} >> {shlex.quote(filename)}")
    if 0 != write_result.returncode:
        log_error(f"Error writing to '{filename}': {write_result.stderr}")
        return False
    log_success(f"File '{filename}' content written")
    return True

operations[file_content] = ensure_file_content

