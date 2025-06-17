import os
import socket

username = os.getlogin()
hostname = socket.gethostname()

config = {
    "vpn": False,
    "bluetooth": False,
    "backlight": False,
    "gpu": "", # "amd" | "nvidia"
    #"nvidia_generation": "", # "aa000" | "bb111"
}

