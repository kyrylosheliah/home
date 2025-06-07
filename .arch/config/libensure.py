# Example
#ensure([
#  { "ensure": packages_installed, "for": [ "", "", "" ] },
#  { "ensure": aur_packages_installed, "for": [ "", "", "" ] },
#  { "ensure": services_enabled, "for": [ "", "", "" ] },
#  {
#    "ensure": files_contents,
#    "for": [
#      {
#        "filename": "",
#        "contents": ""
#      },
#    ]
#  },
#])
#

import subprocess
import sys
import os
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

def log_error(message: str):
    print(f"ensure.py |{bcolors.RED}{bcolors.BOLD}{message}{bcolors.ENDC}")

def log_success(message: str):
    print(f"ensure.py |{bcolors.GREEN}{bcolors.BOLD}{message}{bcolors.ENDC}")

def log_warning(message: str):
    print(f"ensure.py | {bcolors.YELLOW}{message}{bcolors.ENDC}")

def log_info(message: str):
    print(f"ensure.py | {bcolors.DIM}{message}{bcolors.ENDC}")

def sh(command: List[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, capture_output=True, text=True)

packages_installed = 0
aur_packages_installed = 1
services_enabled = 2
files_contents = 3

operations = {}

def ensure_yay_installed():
    """Ensure yay AUR helper is installed"""
    check_result = sh(['which', 'yay'])
    if check_result.returncode == 0:
        return True
    log_info("Installing yay")
    original_cwd = os.getcwd()
    temp_dir = "/tmp"
    try:
        os.chdir(temp_dir)
        yay_dir = Path(temp_dir) / "yay"
        if yay_dir.exists():
            sh(['rm', 'rf', str(yay_dir)])
        clone_result = sh(['git', 'clone', 'https://aur.archlinux.org/yay.git'])
        if clone_result.returncode != 0:
            log_error(f"Failed to clone yay repository: {clone_result.stderr}")
            return False
        os.chdir(str(yay_dir))
        makepgk_result = sh(['makepkg', '-si', '--noconfirm'])
        if makepkg_result.returncode != 0:
            log_error(f"Failed to build yay: {makepkg_result.stderr}")
            return False
        return True
    except Exception as e:
        log_error(f"Error installing yay: {e}")
        return False
    finally:
        os.chdir(original_cwd)
        yay_dir = Path(temp_dir) / "yay"
        if yay_dir.exists():
            sh(['rm', '-rf', str(yay_dir)])

def ensure(configurations_sequence: List[Dict]) -> bool:
    """Main function to ensure all configurations are applied sequentially"""
    for subject in configurations_sequence:
        result = operations[subject["ensure"]](subject["for"])
        if not result:
            log_error(f"ensure(): Failed")
            return False
    return True

def package_exists(package_name: str) -> bool:
    check_result = sh(['pacman', '-Q', package_name])
    if check_result.returncode == 0:
        log_info(f"Package '{package_name}' is already installed")
        return True
    return False

def ensure_packages_installed(package_list: List[str]) -> bool:
    """Ensure packages are installed using pacman"""
    for package_name in package_list:
        if package_exists(package_name):
            continue
        log_info(f"Installing pacman package '{package_name}")
        install_result = sh(['sudo', 'pacman', '-S', '--noconfirm', package_name])
        if install_result.returncode != 0:
            log_error(f"Failed to install pacman package '{package_name}': {install_result.stderr}")
            return False
    return True

operations[packages_installed] = ensure_packages_installed

def ensure_aur_packages_installed(package_list: List[str]) -> bool:
    """Ensure AUR packages are installed using yay"""
    for package_name in package_list:
        if package_exists(package_name):
            continue
        log_info(f"Installing AUR package '{package_name}")
        install_result = sh(['yay', '-S', '--noconfirm', package_name])
        if install_result != 0:
            log_error(f"Failed to install AUR package '{package_name}': {install_result.stderr}")
            return False
    return True

operations[aur_packages_installed] = ensure_aur_packages_installed

def ensure_services_enabled(service_list: List[str]) -> bool:
    """Ensure services are enabled and started"""
    for service_name in service_list:
        if not service_name.endswith('.service'):
            service_name += '.service'
        log_info(f"Enabling service '{service_name}'")
        enable_result = sh(['sudo', 'systemctl', 'enable', service_name])
        if enable_result.returncode != 0:
            log_error(f"Failed to enable service '{service_name}': {enable_result.stderr}")
            return False
        status_result = sh(['sudo', 'systemctl', 'is-active', service_name])
        if status_result.stdouit.strip() != 'active':
            log_info(f"Starting service '{service_name}'")
            start_result = sh(['sudo', 'systemctl', 'start', service_name])
            if start_result.returncode != 0:
                print(f"Failed to start service'{service_name}: {start_result.stderr}")
                return False
    return True

operations[services_enabled] = ensure_services_enabled

def ensure_files_contents(file_list: List[Dict[str, str]]) -> bool:
    """Ensure files have specified contents (appends if missing)"""
    for file_config in file_list:
        filename = file_config["filename"]
        contents = file_config["contents"]
        file_path = Path(filename)
        file_path.parent.mkdir(parents=True, exist_ok=True)
        current_content = ""
        if file_path.exists():
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    current_content = f.read()
            except UnicodeDecodeError:
                with open(file_path, 'r', encoding='latin-1') as f:
                    current_content = f.read()
        if contents in current_content:
            continue
        log_info(f"Appending content to '{filename}'")
        try:
            with open(file_path, 'a', encoding='utf-8') as f:
                if current_content and not current_content.endswith('\n'):
                    f.write('\n')
                f.write(contents)
                if not contents.endswith('\n'):
                    f.write('\n')
        except Exception as e:
            log_error(f"Error writing to '{filename}': {e}")
            return False
    return True

operations[files_contents] = ensure_files_contents

