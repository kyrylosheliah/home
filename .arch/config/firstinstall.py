#!/usr/bin/env python3

import sys
import os
import pwd
import lib.helpers as helpers
from lib.helpers import (
    log_error,
    log_info,
)
from lib.ensure import (
    ensure_module,
    execution,
    conditional_error,
    conditional_execution,
    choise,
    package_installed,
)

if __name__ != '__main__':
    log_error("This script is not a library")
    sys.exit(1)

if os.getuid() == 0:
    log_error("This script should not be run as a root or with sudo")
    sys.exit(1)

def setup_secure_boot(microsoft: bool = False, uki: bool = False):
    result = helpers.sh("sudo sbctl create-keys")
    if 0 != result.returncode:
        log_error(f"Error creating secure boot keys: {result.stderr}")
        return False
    # ...
    result = helpers.sh("sudo sbctl enroll-keys" + (" --microsoft" if microsoft else ""))
    if 0 != result.returncode:
        log_error(f"Error enrolling secure boot keys: {result.stderr}")
        return False
    # ...
    if uki:
        target = "/efi/EFI/Linux/arch-linux.efi"
        result = helpers.sh(f"sudo sbctl sign -s {target}")
        if 0 != result.returncode:
            log_error(f"Error signing '{target}': {result.stderr}")
            return False
    else:
        target = "/boot/vmlinuz-linux"
        result = helpers.sh(f"sudo sbctl sign -s {target}")
        if 0 != result.returncode:
            log_error(f"Error signing '{target}': {result.stderr}")
            return False
    # ...
    target = "/usr/lib/systemd/boot/efi/systemd-bootx64.efi"
    result = helpers.sh(f"sudo sbctl sign -s -o {target}.signed {target}")
    if 0 != result.returncode:
        log_error(f"Error signing '{target}': {result.stderr}")
        return False
    # ...
    result = helpers.sh("sudo bootctl install")
    if 0 != result.returncode:
        log_error(f"Error : {result.stderr}")
        return False
    # ...
    result = helpers.sh("sudo sbctl verify")
    if 0 != result.returncode:
        log_error(f"Error : {result.stderr}")
        return False
    # ...
    helpers.execute_and_prompt_any_key("sudo sbctl status")
    return True

blocks = [
    { "ensure": conditional_execution, "for": [
        # lock root user, undo with `sudo passwd -u root`
        { "title": "root user locked",
          "condition": lambda: 0 != helpers.sh("sudo passwd -S root | grep -q ^root L").returncode,
          "function": lambda: helpers.sh("sudo passwd -l root") },
        ] },
    { "ensure": package_installed, "for": [
        "networkmanager",
        ] },
    { "ensure": package_installed, "for": [
        "kwallet",
        "gnupg",
        ] },
    { "ensure": conditional_error, "for": [
        { "title": "wallet named 'kdewallet' is present",
          "condition": lambda: 0 != helpers.sh("kwallet-query -l -d '' kdewallet").returncode },
        ] },
    { "ensure": conditional_execution, "for": [
        { "title": "gpg key generated",
          "condition": lambda: 0 != helpers.sh("gpg --list-secret-keys --with-colons | grep -q '^sec'").returncode,
          "function": lambda: helpers.sh("gpg --gen-key") },
        ] },
    { "ensure": package_installed, "for": [
        "ufw",
        ] },
    { "ensure": conditional_execution, "for": [
        { "title": "firewall helper enabled",
          "condition": lambda: 0 != helpers.sh("sudo ufw status | grep -q '^Status:active'").returncode,
          "function": lambda: helpers.sh("sudo ufw enable && sudo ufw default allow outgoing && sudo ufw default deny incoming") },
        ] },
    { "ensure": execution, "for": [
        { "title": "firewall status",
          "function": lambda: helpers.execute_and_prompt_any_key("sudo ufw status verbose", "Firewall:") },
        ] },
    { "ensure": package_installed, "for": [
        "sbctl", "sbsigntools",
        ] },
    { "ensure": execution, "for": [
        { "title": "secure boot status",
          "function": lambda: helpers.execute_and_prompt_any_key("sudo sbctl status", "Secure boot:") },
        ] },
    { "ensure": choise, "for": [
        { "title": "Secure boot setup", "options": [
            { "name": "default",
              "description": "",
              "function": lambda: setup_secure_boot() },
            { "name": "uki",
              "description": "Unified Kernel Image",
              "function": lambda: setup_secure_boot(uki=True) },
            { "name": "microsoft",
              "description": "to allow dualboot",
              "function": lambda: setup_secure_boot(microsoft=True) },
            { "name": "uki",
              "description": "Unified Kernel Image",
              "function": lambda: setup_secure_boot(uki=True) },
            { "name": "microsoft+uki",
              "description": "",
              "function": lambda: setup_secure_boot(microsoft=True, uki=True) },
            ] },
        ] },
    ]

root_module = { "title": "root", "for": blocks }

root_result = ensure_module(root_module)

sys.exit(0 if root_result else 1)

