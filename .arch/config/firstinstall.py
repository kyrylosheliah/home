#!/usr/bin/env python3

import sys
import os
from lib.ensure import (
    log_error,
    ensure_module,
)

if __name__ != '__main__':
    log_error("This script is not a library")
    sys.exit(1)

if os.getuid() == 0:
    log_error("This script should not be run as a root or with sudo")
    sys.exit(1)

#from module.software import software_module
#
#root_result = ensure_module(software_module)
#
#sys.exit(0 if root_result else 1)

