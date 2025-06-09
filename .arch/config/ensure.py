#!/usr/bin/env python3

import sys
import os
from libensure import log_error

if __name__ != '__main__':
    log_error("This script is not a library")
    sys.exit(1)

if os.getuid() == 0:
    log_error("This script should not be run as a root or with sudo")
    sys.exit(1)

import socket
from libensure import (
    ensure,
    packages_installed,
    aur_packages_installed,
    system_services_active,
    user_services_active,
    files_contents,
)

username = os.getlogin()
hostname = socket.gethostname()

sys.exit(1 if False == ensure([

    # network
    { "ensure": packages_installed, "for": [
        'networkmanager',
        ] },
    { "ensure": system_services_active, "for": [
        'NetworkManager.service',
        ] },

    # bluetooth
    { "ensure": packages_installed, "for": [
        "bluez", "bluez-utils"
        ] },
    { "ensure": system_services_active, "for": [
        "bluetooth.service",
        ] },

    # audio
    { "ensure": packages_installed, "for": [
        "pipewire",
        "pipewire-alsa",
        "pipewire-jack",
        "pipewire-pulse",
        ] },
    { "ensure": user_services_active, "for": [
        'pipewire-pulse.service',
        ] },

    # storage
    { "ensure": system_services_active, "for": [
        "fstrim.timer", # Enable TRIM for SSDs
        ] },

    # base
    { "ensure": packages_installed, "for": [
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
        "ttf-iosevka-nerd",
        # desktop ui
        "hyprland",
        "hyprpaper",
        "waybar",
        "rofi-wayland",
        ] },

    # development
    { "ensure": packages_installed, "for": [
        #"python",
        "neovim", # laptop kb baaaaad
        "wl-clipboard", # neovim to linux and vice versa clipboard support
        ] },
    { "ensure": aur_packages_installed, "for": [
        "code",
        ] },

    # graphics
    { "ensure": files_contents, "for": [
        # multilib repository
        { "filename": "/etc/pacman.conf", "content": """
[multilib]
Include = /etc/pacman.d/mirrorlist
            """ },
        ] },
    # amd graphics
    { "ensure": packages_installed, "for": [
        "mesa", "lib32-mesa",
        "vulkan-radeon", "lib32-vulkan-radeon",
        "vulkan-icd-loader", "lib32-vulkan-icd-loader",
        ] },
    { "ensure": aur_packages_installed, "for": [
        "lact",
        ] },
    # nvidia graphics
    #{ "ensure": packages_installed, "for": [
    #    "nvidia", "nvidia-utils", "lib32-nvidia-utils", "nvidia-settings",
    #    "opencl-nvidia",
    #    ] },

    ## gaming
    ## launchers
    #{ "ensure": packages_installed, "for": [
    #    "steam", "lutris", "gamescope",
    #    ] },
    ## windows compatibility
    #{ "ensure": packages_installed, "for": [
    #    "wine-staging", "winetricks",
    #    "proton-ge-custom-bin", "dxvk-bin",
    #    "vkd3d-proton-bin",
    #    ] },
    ## low-level features or driver compatibility
    #{ "ensure": packages_installed, "for": [
    #    "linux-headers", "solaar", "xwaylandvideobridge", "xone-dkms-git"
    #    ] },
    #{ "ensure": packages_installed, "for": [
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
    { "ensure": packages_installed, "for": [
        # recording
        #"obs-studio", "goverlay"
        # apps
        "discord",
        "firefox",
        ] },

]) else 0) # END ensure()

