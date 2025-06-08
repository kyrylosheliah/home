#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    log_error "This script should not be run as root or with sudo"
    exit 1
fi

source ./libensure.sh

set -e # exit on any error

#username = os.getlogin()
#hostname = socket.gethostname()

# assume no yay helper yet
ensure_aur_package_installed_raw \
	'yay' &&

# network
ensure_packages_installed \
	'networkmanager' &&
ensure_system_services_enabled \
	'NetworkManager.service' &&

# sound
ensure_packages_installed \
	'pipewire' \
	'pipewire-alsa' \
	'pipewire-jack' \
	'pipewire-pulse' &&
ensure_user_services_enabled \
	'pipewire-pulse.service' &&

# base
ensure_packages_installed \
	'base-devel' \
	'htop' \
	'wget' \
	'curl' \
	'unzip' \
	'man-db' &&

# git
ensure_packages_installed \
	'git' \
	'less' &&

# desktop
ensure_packages_installed \
	'noto-fonts' \
	'noto-fonts-emoji' \
	'ttf-iosevka-nerd' \
	'hyprland' \
	'hyprpaper' \
	'waybar' \
	'rofi-wayland' &&

# development
ensure_packages_installed \
	'neovim' \
	'wl-clipboard' &&
ensure_aur_packages_installed \
	'code' &&

# graphics
declare -a file_entries=(
	# multilib repository
	"/etc/pacman.conf"
	$'[multilib]\nInclude = /etc/pacman.d/mirrorlist' )
ensure_files_contents file_entries
# amd graphics
ensure_packages_installed \
	'mesa' 'lib32-mesa' 'vulkan-radeon' 'lib32-vulkan-radeon' \
	'vulkan-icd-loader' 'lib32-vulkan-icd-loader' &&
ensure_aur_packages_installed \
	'lact' #&&
# nvidia graphics
#{ "ensure": packages_installed, "for": [
#    "nvidia", "nvidia-utils", "lib32-nvidia-utils", "nvidia-settings",
#    "opencl-nvidia",
#    ] },
# TODO: EITHER dispatch accumulation per hostname OR make an addtional
# detailed hardware configuration `*.py` imported interface

# gaming
#{ "ensure": system_services_enabled, "for": [
#    "bluetooth.service",
#    "fstrim.timer", # Enable TRIM for SSDs
#    ] },
#{ "ensure": packages_installed, "for": [
#    "steam", "lutris", "wine-staging", "winetricks", "gamemode",
#    "lib32-gamemode", "giflib", "lib32-giflib", "libpng",
#    "lib32-libpng", "libldap", "lib32-libldap", "gnutls",
#    "lib32-gnutls", "mpg123", "lib32-mpg123", "openal", "lib32-openal",
#    "v4l-utils", "lib32-v4l-utils", "libgpg-error",
#    "lib32-libgpg-error", "alsa-plugins", "lib32-alsa-plugins",
#    "alsa-lib", "lib32-alsa-lib", "libjpeg-turbo",
#    "lib32-libjpeg-turbo", "sqlite", "lib32-sqlite", "libxcomposite",
#    "lib32-libxcomposite", "libxinerama", "lib32-libxinerama",
#    "ncurses", "lib32-ncurses", "opencl-icd-loader",
#    "lib32-opencl-icd-loader", "libxslt", "lib32-libxslt", "libva",
#    "lib32-libva", "gtk3", "lib32-gtk3", "gst-plugins-base-libs",
#    "lib32-gst-plugins-base-libs", "vulkan-icd-loader",
#    "lib32-vulkan-icd-loader", "obs-studio", "discord", "mangohud",
#    "lib32-mangohud", "goverlay", "gamescope", "solaar", "bluez",
#    "bluez-utils", "lib32-libpulse", "pipewire", "pipewire-pulse",
#    "pipewire-alsa", "linux-headers", "xwaylandvideobridge",
#    ] },
#{ "ensure": aur_packages_installed, "for": [
#    "vkbasalt", "lib32-vkbasalt", "proton-ge-custom-bin",
#    "xone-dkms-git", "dxvk-bin", "vkd3d-proton-bin",
#    ] },

log_success 'Configuration check success'

