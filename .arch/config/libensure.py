# Example
#ensure([
#    { "ensure": packages_installed, "for": [
#        "",
#        "",
#        "",
#        ] },
#    { "ensure": files_contents, "for": [
#        {
#          "filename": "",
#          "contents": ""
#        },
#        ] },
#    { "ensure": files_contents, "for": [
#        { "filename": "", "contents": """
#[abcd]
#efgh
#            """ },
#        ] },
#])

import subprocess
import sys
import os
import shlex
from pathlib import Path
from typing import List, Dict, Union

# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
class bcolors:
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'

log_prefix = f"{bcolors.DIM}ensure:{bcolors.ENDC} "

def log_error(message: str):
    print(f"{log_prefix}{bcolors.RED}{bcolors.BOLD}{message}{bcolors.ENDC}")

def log_success(message: str):
    print(f"{log_prefix}{bcolors.GREEN}{bcolors.BOLD}{message}{bcolors.ENDC}")

def log_warning(message: str):
    print(f"{log_prefix}{bcolors.YELLOW}{message}{bcolors.ENDC}")

def log_info(message: str):
    print(f"{log_prefix}{bcolors.DIM}{message}{bcolors.ENDC}")

def run(command: List[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, capture_output=True, text=True)

def sh(command: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, shell=True)

packages_installed = 0
aur_packages_installed = 1
user_services_enabled = 2
system_services_enabled = 3
files_contents = 4

operations = {}

def package_is_installed(package_name: str) -> bool:
    if 0 == run(['pacman', '-Q', package_name]).returncode:
        log_info(f"Package '{package_name}' is already installed")
        return True
    log_warning(f"Package '{package_name}' is not installed")
    return False

def ensure_aur_package_installed_raw(package_name):
    """Ensure some package is installed from AUR assuming yay isn't available"""
    if package_is_installed(package_name): # run(['which', 'yay'])
        return True
    log_warning(f"Installing '{package_name}' raw from AUR")
    original_cwd = os.getcwd()
    temp_dir = "/tmp"
    try:
        os.chdir(temp_dir)
        package_dir = Path(temp_dir) / package_name
        if package_dir.exists():
            run(['rm', 'rf', str(package_dir)])
        clone_result = run(['git', 'clone', f'https://aur.archlinux.org/{package_name}.git'])
        if 0 != clone_result.returncode:
            log_error(f"Failed to clone '{package_name}' from AUR repository: {clone_result.stderr}")
            return False
        os.chdir(str(package_dir))
        makepkg_result = run(['makepkg', '-si', '--noconfirm'])
        if 0 != makepkg_result.returncode:
            log_error(f"Failed to build '{package_name}': {makepkg_result.stderr}")
            return False
        return True
    except Exception as e:
        log_error(f"Error ensuring '{package_name}' from AUR: {e}")
        return False
    finally:
        os.chdir(original_cwd)
        package_dir = Path(temp_dir) / package_name
        if package_dir.exists():
            run(['rm', '-rf', str(package_dir)])

def ensure(configurations_sequence: List[Dict]) -> bool:
    """Main function to ensure all configurations are applied sequentially"""
    ensure_aur_package_installed_raw("yay") # hard dependency
    for subject in configurations_sequence:
        result = operations[subject["ensure"]](subject["for"])
        if not result:
            log_error("An error occurred during configuration check")
            return False
    log_success("Configuration check success")
    return True

def ensure_packages_installed(package_list: List[str]) -> bool:
    """Ensure packages are installed using pacman"""
    for package_name in package_list:
        if package_is_installed(package_name):
            continue
        log_info(f"Installing pacman package '{package_name}'")
        install_result = run(['sudo', 'pacman', '-S', '--noconfirm', package_name])
        if 0 != install_result.returncode:
            log_error(f"Failed to install pacman package '{package_name}': {install_result.stderr}")
            return False
    return True

operations[packages_installed] = ensure_packages_installed

def ensure_aur_packages_installed(package_list: List[str]) -> bool:
    """Ensure AUR packages are installed using yay"""
    for package_name in package_list:
        if package_is_installed(package_name):
            continue
        log_info(f"Installing AUR package '{package_name}'")
        install_result = run(['yay', '-S', '--noconfirm', package_name])
        if 0 != install_result.returncode:
            log_error(f"Failed to install AUR package '{package_name}': {install_result.stderr}")
            return False
    return True

operations[aur_packages_installed] = ensure_aur_packages_installed

systemctl_prefixes = [
    [ "systemctl", "--user" ], # is_system = False or 0
    [ "sudo", "systemctl" ], # is_system = True or 1
]

def ensure_services_enabled(systemctl_prefix: List[str], service_list: List[str]) -> bool:
    """Ensure services are enabled and started"""
    for service_name in service_list:
        #if not service_name.endswith('.service'):
        #    service_name += '.service'
        if 'enabled' != run(systemctl_prefix + ['is-enabled', service_name]).stdout.strip():
            log_info(f"Enabling service '{service_name}'")
            enable_result = run(systemctl_prefix + ['enable', service_name])
            if 0 != enable_result.returncode:
                log_error(f"Failed to enable service '{service_name}': {enable_result.stderr}")
                return False
        if 'active' != run(systemctl_prefix + ['is-active', service_name]).stdout.strip():
            log_info(f"Starting service '{service_name}'")
            start_result = run(systemctl_prefix + ['start', service_name])
            if 0 != start_result.returncode:
                print(f"Failed to start service '{service_name}': {start_result.stderr}")
                return False
    return True

def ensure_user_services_enabled(service_list: List[str]) -> bool:
    return ensure_services_enabled(systemctl_prefixes[0], service_list)

operations[user_services_enabled] = ensure_user_services_enabled

def ensure_system_services_enabled(service_list: List[str]) -> bool:
    return ensure_services_enabled(systemctl_prefixes[1], service_list)

operations[system_services_enabled] = ensure_system_services_enabled

def ensure_files_contents(file_list):
    for file_config in file_list:
        filename = file_config["filename"]
        contents = file_config["contents"]
        grep_result = sh(
            f"sudo grep -Fq -- {shlex.quote(contents)} {shlex.quote(filename)}")
        if 0 == grep_result.returncode:
            continue
        log_info(f"Appending content to '{filename}'")
        newline_result = sh( # 0a = newline
            f"sudo tail -c1 {shlex.quote(filename)} | od -An -t x1 | grep -q '0a'")
        if 0 != newline_result.returncode:
            contents = "\n" + contents
        write_result = sh(
            f"sudo echo {shlex.quote(contents)} >> {shlex.quote(filename)}")
        if 0 != write_result.returncode:
            log_error(f"Error writing to '{filename}': {write_result.stderr}")
            return False
    return True

operations[files_contents] = ensure_files_contents

