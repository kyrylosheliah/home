import shlex
import subprocess
from pathlib import Path
from typing import List

# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
class bcolors:
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'

def log_error(prefix: str, message: str):
    print(f"{prefix}{bcolors.RED}{bcolors.BOLD}{message}{bcolors.ENDC}")

def log_success(prefix: str, message: str):
    print(f"{prefix}{bcolors.GREEN}{bcolors.BOLD}{message}{bcolors.ENDC}")

def log_warning(prefix: str, message: str):
    print(f"{prefix}{bcolors.YELLOW}{message}{bcolors.ENDC}")

def log_info(prefix: str, message: str):
    print(f"{prefix}{bcolors.DIM}{message}{bcolors.ENDC}")

def run(command: List[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, capture_output=True, text=True)

def sh(command: List[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, shell=True, capture_output=True, text=True)

def file_exists(path: str) -> bool:
    return Path(path).is_file()

def touch_file(filename: str) -> str:
    filepath = Path(filename)
    if filepath.is_file():
        return ""
    parent = filepath.parent
    try:
        # touching the file as current user
        parent.mkdir(parents=True, exist_ok=True)
        filepath.touch(exist_ok=True)
        return ""
    except (PermissionError, OSError):
        # fallback to sudo
        parent = parent.as_posix()
        filepath = filepath.as_posix()
        touch_result = sh(
            f"sudo mkdir -p {shlex.quote(parent)} && sudo touch -a {shlex.quote(filepath)}")
        if touch_result.returncode != 0:
            return touch_result.stderr
        return ""

def file_has_content(path: str, content: str) -> bool:
    if not file_exists(path):
        return False
    grep_result = sh(
        f"sudo grep -Fq -- {shlex.quote(content)} {shlex.quote(path)}")
    return 0 == grep_result.returncode

