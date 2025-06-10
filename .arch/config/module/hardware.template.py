import os
import socket

username = os.getlogin()
hostname = socket.gethostname()

hardware_config = {
    "gpu_manufacturer" = "", # "amd" | "nvidia"
    #"nvidia_generation" = "", # "" |
    "is_laptop" = False, # boolean
}

