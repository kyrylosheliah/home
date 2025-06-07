#!/usr/bin/env python3

import os
import socket
import ensure_yay_installed,
       ensure,
       packages_installed,
       aur_packages_installed,
       services_enabled,
       files_contents,
       log_error,
       log_success from libensure

def main():

    username = os.getlogin()
    hostname = socket.gethostname()
    if ensure_yay_installed() != 0:
        log_error("Error occurred ensuring yay installation, exiting ...")
        return 1
    ensurance_result = ensure([
        # network
        { "ensure": packages_installed, "for": [ 'networkmanager' ] },
        { "ensure": services_enabled, "for": [ 'NetworkManager.service' ] },
        # sound
        {
            "ensure": packages_installed,
            "for": [
                "pipewire",
                "pipewire-alsa",
                "pipewire-jack",
                "pipewire-pulse",
                ]
            },
        { "ensure": services_enabled, "for": [ 'pipewire-pulse.service' ] },
        # git
        {
            "ensure": packages_installed,
            "for": [
                'git',
                'less',
                ]
            },
        # base
        {
            "ensure": packages_installed,
            "for": [
                'base-devel',
                'htop',
                'wget',
                'curl',
                'unzip',
                'man-db',
                ]
            },
        # development
        {
            "ensure": packages_installed,
            "for": [
                #"python",
                "neovim",
                ]
            },
        { "ensure": aur_packages_installed, "for": [ "code", ] },
        # desktop features
        {
            "ensure": packages_installed,
            "for": [
                # fonts
                "noto-fonts",
                "noto-fonts-emoji",
                "ttf-iosevka-nerd",
                # ui
                "hyprland",
                "hyprpaper",
                "waybar",
                "rofi-wayland",
                ]
            },
        # gaming
        {
            "ensure": files_contents,
            "for": [
                {
                    "filename": "/etc/pacman.conf",
                    "contents": """
[multilib]
Include = /etc/pacman.d/mirrorlist
            """,
                    },
                ]
            },
        ])
    if ensurance_result == False:
        log_error("Error occurred ensuring yay installation, exiting ...")
        return 1
    else:
        log_success("Configuration check success")

if __name__ == '__main__':
    main()

