import sys
import os
from lib.ensure import (
    conditional_execution,
    execution,
    package_installed,
    aur_package_installed,
    system_service_active,
    user_service_active,
    file_content,
)
import lib.helpers as helpers
import module.options as options

blocks = []

# storage, enable TRIM for SSDs
blocks.append({ "ensure": system_service_active, "for": "fstrim.timer" })

# base
blocks.append({ "ensure": package_installed, "for": [
    'base-devel',
    'pacman-contrib',
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
    "ttf-iosevka-nerd",
    # privilege excalation
    "hyprpolkitagent",
    # a file manager
    "yazi",
    ] })

# network
blocks.append({ "ensure": package_installed, "for": [
    "networkmanager",
    "network-manager-applet",
    "nm-connection-editor",
    ] })
if options.config["vpn"]:
    blocks.append({ "ensure": package_installed, "for": [
        "networkmanager-openvpn",
        "networkmanager-pptp",
        "networkmanager-l2tp",
        "networkmanager-vpnc",
        ] })
blocks.append({ "ensure": system_service_active, "for": 'NetworkManager.service' })

if options.config["bluetooth"]:
    blocks = blocks + [
        { "ensure": package_installed, "for": [
            "bluez",
            "bluez-utils",
            "blueman", # tray `blueman-applet`, app `blueman-manager`
            ] },
        { "ensure": system_service_active, "for": "bluetooth.service" },
        ]

if options.config["backlight"]:
    blocks.append({ "ensure": package_installed, "for": "brightnessctl" })

# audio
blocks = blocks + [
    { "ensure": package_installed, "for": [
        "pipewire", # includes `pw-top` `pw-cli` `pw-dump`
        "pipewire-alsa",
        "pipewire-jack",
        "pipewire-pulse",
        "wireplumber",
        # CLI tools
        "alsa-utils", # includes `alsamixer`, `aplay` `alsa-info.sh`
        "pavucontrol",
        "helvum",
        "easyeffects",
        ] },
    { "ensure": user_service_active, "for": [
        "pipewire.service",
        "pipewire-pulse.service",
        "wireplumber",
        ] },
        # qjackctl
        # cadence (wireplumber conflict)
        # jack_capture
        # pasystray pulsemixer
        # ardor audacity carla calf zita-ajbridge
        # ###
        # Add your user to the audio group (not always required with PipeWire): sudo usermod -aG audio $USER
        # For low-latency, tune /etc/security/limits.d/99-audio.conf (usually handled by realtime-privileges package).
    ]

# desktop ui
blocks.append({ "ensure": package_installed, "for": [
    "hyprland",
    "hyprpaper",
    "waybar",
    "hicolor-icon-theme",
    "jq",
    "dunst",
    "rofi-wayland",
    # dark theme
    "xdg-desktop-portal-gtk",
    "xdg-desktop-portal-hyprland",
    #"adw-gtk-theme", # gtk3 theme
    "breeze-gtk", # gtk3 theme
    "libadwaita", # gtk4
    # kde dark theme
    "qt5ct",
    "qt6ct",
    "kvantum",
    "breeze-icons",
    ]})

blocks = blocks + [
    # development
    { "ensure": package_installed, "for": [
        "neovim", # laptop kb baaaaad
        "wl-clipboard", # neovim to linux and vice versa clipboard support
        ] },
    { "ensure": aur_package_installed, "for": "code" },

    # apps
    { "ensure": package_installed, "for": [
        #"obs-studio",
        #"goverlay",
        "discord",
        "firefox",
        ] },
]

# graphics

# multilib 32bit repository
blocks.append({ "ensure": file_content, "for": { "filename": "/etc/pacman.conf", "content": """
[multilib]
Include = /etc/pacman.d/mirrorlist
    """ } })

match options.config["gpu"]:
    case "amd":
        blocks = blocks + [
            { "ensure": package_installed, "for": [
                "mesa", "lib32-mesa",
                "vulkan-radeon", "lib32-vulkan-radeon",
                "vulkan-icd-loader", "lib32-vulkan-icd-loader",
                ] },
            { "ensure": aur_package_installed, "for": "lact" },
            { "ensure": system_service_active, "for": "lactd" },
        ]
    case "nvidia":
        blocks.append({ "ensure": package_installed, "for": [
            "nvidia",
            "nvidia-utils", "lib32-nvidia-utils",
            "nvidia-settings",
            "opencl-nvidia",
            ] })

ignored = [
    # gaming
    # launchers
    { "ensure": package_installed, "for": [
        "steam", "lutris", "gamescope",
        ] },
    # windows compatibility
    { "ensure": package_installed, "for": [
        "wine-staging", "winetricks",
        "proton-ge-custom-bin", "dxvk-bin",
        "vkd3d-proton-bin",
        ] },
    # low-level features or driver compatibility
    { "ensure": package_installed, "for": [
        "linux-headers", "solaar", "xwaylandvideobridge", "xone-dkms-git"
        ] },
    { "ensure": package_installed, "for": [
        # native and 32 bit compatibility libraries
        "giflib", "lib32-giflib",
        "libpng", "lib32-libpng",
        "libldap", "lib32-libldap",
        "gnutls", "lib32-gnutls",
        "mpg123", "lib32-mpg123",
        "openal", "lib32-openal",
        "v4l-utils", "lib32-v4l-utils",
        "libgpg-error", "lib32-libgpg-error",
        "alsa-plugins", "lib32-alsa-plugins",
        "sqlite", "lib32-sqlite",
        "alsa-lib", "lib32-alsa-lib",
        "libjpeg-turbo", "lib32-libjpeg-turbo",
        "libxcomposite", "lib32-libxcomposite",
        "libxinerama", "lib32-libxinerama",
        "ncurses", "lib32-ncurses",
        "opencl-icd-loader", "lib32-opencl-icd-loader",
        "libxslt", "lib32-libxslt",
        "libva", "lib32-libva",
        "gtk3", "lib32-gtk3",
        "gst-plugins-base-libs", "lib32-gst-plugins-base-libs",
        "vulkan-icd-loader", "lib32-vulkan-icd-loader",
        "libpulse", "lib32-libpulse",
        # performance
        "gamemode", "lib32-gamemode",
        "mangohud", "lib32-mangohud",
        "vkbasalt", "lib32-vkbasalt"
        ] },
]

root_module = { "title": "root", "for": blocks }

