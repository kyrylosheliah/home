import sys
import os
sys.path.append('../lib')
from lib.ensure import (
    conditional_execution,
    package_installed,
    aur_package_installed,
    system_service_active,
    user_service_active,
    file_content,
)
from lib.helpers import (
    file_exists,
    sh,
)

blocks = [
    # network
    { "ensure": package_installed, "for": 'networkmanager' },
    { "ensure": system_service_active, "for": 'NetworkManager.service' },

    # bluetooth
    { "ensure": package_installed, "for": [
        "bluez", "bluez-utils"
        ] },
    { "ensure": system_service_active, "for": "bluetooth.service" },

    # audio
    { "ensure": package_installed, "for": [
        "pipewire",
        "pipewire-alsa",
        "pipewire-jack",
        "pipewire-pulse",
        ] },
    { "ensure": user_service_active, "for": 'pipewire-pulse.service' },

    # storage
    # Enable TRIM for SSDs
    { "ensure": system_service_active, "for": "fstrim.timer" },

    # base
    { "ensure": package_installed, "for": [
        'base-devel',
        'htop',
        'wget',
        'curl',
        'unzip',
        'man-db',
        # git and related
        'git',
        'less',
        # fonts
        "noto-fonts",
        "noto-fonts-emoji",
        ] },

    # desktop ui
    { "ensure": package_installed, "for": [
        "ttf-iosevka-nerd",
        "hyprland",
        "hyprpaper",
        "waybar",
        "rofi-wayland",
        ]},

    # development
    { "ensure": package_installed, "for": [
        #"python",
        "neovim", # laptop kb baaaaad
        "wl-clipboard", # neovim to linux and vice versa clipboard support
        ] },
    { "ensure": aur_package_installed, "for": [
        "code",
        ] },

    # graphics
    # multilib repository
    { "ensure": file_content, "for": { "filename": "/etc/pacman.conf", "content": """
[multilib]
Include = /etc/pacman.d/mirrorlist
        """ }, },
    # amd graphics
    { "ensure": package_installed, "for": [
        "mesa", "lib32-mesa",
        "vulkan-radeon", "lib32-vulkan-radeon",
        "vulkan-icd-loader", "lib32-vulkan-icd-loader",
        ] },
    { "ensure": aur_package_installed, "for": "lact" },
    # nvidia graphics
    #{ "ensure": package_installed, "for": [
    #    "nvidia", "nvidia-utils", "lib32-nvidia-utils", "nvidia-settings",
    #    "opencl-nvidia",
    #    ] },

    ## gaming
    ## launchers
    #{ "ensure": package_installed, "for": [
    #    "steam", "lutris", "gamescope",
    #    ] },
    ## windows compatibility
    #{ "ensure": package_installed, "for": [
    #    "wine-staging", "winetricks",
    #    "proton-ge-custom-bin", "dxvk-bin",
    #    "vkd3d-proton-bin",
    #    ] },
    ## low-level features or driver compatibility
    #{ "ensure": package_installed, "for": [
    #    "linux-headers", "solaar", "xwaylandvideobridge", "xone-dkms-git"
    #    ] },
    #{ "ensure": package_installed, "for": [
    #    # native and 32 bit compatibility libraries
    #    "giflib", "lib32-giflib",
    #    "libpng", "lib32-libpng",
    #    "libldap", "lib32-libldap",
    #    "gnutls", "lib32-gnutls",
    #    "mpg123", "lib32-mpg123",
    #    "openal", "lib32-openal",
    #    "v4l-utils", "lib32-v4l-utils",
    #    "libgpg-error", "lib32-libgpg-error",
    #    "alsa-plugins", "lib32-alsa-plugins",
    #    "sqlite", "lib32-sqlite",
    #    "alsa-lib", "lib32-alsa-lib",
    #    "libjpeg-turbo", "lib32-libjpeg-turbo",
    #    "libxcomposite", "lib32-libxcomposite",
    #    "libxinerama", "lib32-libxinerama",
    #    "ncurses", "lib32-ncurses",
    #    "opencl-icd-loader", "lib32-opencl-icd-loader",
    #    "libxslt", "lib32-libxslt",
    #    "libva", "lib32-libva",
    #    "gtk3", "lib32-gtk3",
    #    "gst-plugins-base-libs", "lib32-gst-plugins-base-libs",
    #    "vulkan-icd-loader", "lib32-vulkan-icd-loader",
    #    "libpulse", "lib32-libpulse",
    #    # performance
    #    "gamemode", "lib32-gamemode",
    #    "mangohud", "lib32-mangohud",
    #    "vkbasalt", "lib32-vkbasalt"
    #    ] },

    # apps
    { "ensure": package_installed, "for": [
        #"obs-studio",
        #"goverlay",

        "discord",
        "firefox",
        ] },
]

software_module = { "title": "Root software", "for": blocks }
