#!/usr/bin/env python3

import sys
import os
import socket
from libensure import (
    ensure,
    packages_installed,
    aur_packages_installed,
    system_services_enabled,
    user_services_enabled,
    files_contents,
    log_error,
    log_success,
)

def main():
    username = os.getlogin()
    hostname = socket.gethostname()

    ensurance_result = ensure([

        # network
        { "ensure": packages_installed, "for": [
            'networkmanager',
            ] },
        { "ensure": system_services_enabled, "for": [
            'NetworkManager.service',
            ] },

        # sound
        { "ensure": packages_installed, "for": [
            "pipewire",
            "pipewire-alsa",
            "pipewire-jack",
            "pipewire-pulse",
            ] },
        { "ensure": user_services_enabled, "for": [
            'pipewire-pulse.service',
            ] },

        # base
        { "ensure": packages_installed, "for": [
            'base-devel',
            'htop',
            'wget',
            'curl',
            'unzip',
            'man-db',
            ] },

        # git
        { "ensure": packages_installed, "for": [
            'git',
            'less',
            ] },

        # desktop
        { "ensure": packages_installed, "for": [
            # fonts
            "noto-fonts",
            "noto-fonts-emoji",
            "ttf-iosevka-nerd",
            # ui
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
            { "filename": "/etc/pacman.conf", "contents": """
[multilib]
Include = /etc/pacman.d/mirrorlist
                """ },
            ] },
        # amd graphics
        { "ensure": packages_installed, "for": [
                "mesa", "lib32-mesa", "vulkan-radeon", "lib32-vulkan-radeon",
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
        # TODO: EITHER dispatch accumulation per hostname OR make an addtional
        # detailed hardware configuration `*.py` imported interface

        # gaming
        { "ensure": system_services_enabled, "for": [
            "bluetooth.service",
            "fstrim.timer", # Enable TRIM for SSDs
            ] },
        { "ensure": packages_installed, "for": [
            "steam", "lutris", "wine-staging", "winetricks", "gamemode",
            "lib32-gamemode", "giflib", "lib32-giflib", "libpng",
            "lib32-libpng", "libldap", "lib32-libldap", "gnutls",
            "lib32-gnutls", "mpg123", "lib32-mpg123", "openal", "lib32-openal",
            "v4l-utils", "lib32-v4l-utils", "libgpg-error",
            "lib32-libgpg-error", "alsa-plugins", "lib32-alsa-plugins",
            "alsa-lib", "lib32-alsa-lib", "libjpeg-turbo",
            "lib32-libjpeg-turbo", "sqlite", "lib32-sqlite", "libxcomposite",
            "lib32-libxcomposite", "libxinerama", "lib32-libxinerama",
            "ncurses", "lib32-ncurses", "opencl-icd-loader",
            "lib32-opencl-icd-loader", "libxslt", "lib32-libxslt", "libva",
            "lib32-libva", "gtk3", "lib32-gtk3", "gst-plugins-base-libs",
            "lib32-gst-plugins-base-libs", "vulkan-icd-loader",
            "lib32-vulkan-icd-loader", "obs-studio", "discord", "mangohud",
            "lib32-mangohud", "goverlay", "gamescope", "solaar", "bluez",
            "bluez-utils", "lib32-libpulse", "pipewire", "pipewire-pulse",
            "pipewire-alsa", "linux-headers", "xwaylandvideobridge",
            ] },
        { "ensure": aur_packages_installed, "for": [
            "vkbasalt", "lib32-vkbasalt", "proton-ge-custom-bin",
            "xone-dkms-git", "dxvk-bin", "vkd3d-proton-bin",
            ] },

        ]) # END ensure()

    if ensurance_result == False:
        log_error("An error occurred during configuration check, exiting")
        sys.exit(1)
    log_success("Configuration check success")

if __name__ == '__main__':
    if os.getuid() == 0:
        log_error("This script should not be run as a root or with sudo")
        sys.exit(1)
    main()

