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
    kconfig_content,
)
import lib.helpers as helpers
import module.options as options

expanduser = os.path.expanduser
#hostname = socket.gethostname()

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
    "jq",
    # git and related
    'git',
    'less',
    # fonts
    "noto-fonts",
    "noto-fonts-emoji",
    "ttf-iosevka-nerd",
    ] })

# network
blocks.append({ "ensure": package_installed, "for": [
    "networkmanager",
    ] })
if options.config["vpn"]:
    blocks.append({ "ensure": package_installed, "for": [
        "networkmanager-openvpn",
        "networkmanager-openconnect",
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
            #"blueman", # tray `blueman-applet`, app `blueman-manager`
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
    "plasma-meta",
    "ark",
    "dolphin",
    "gwenview",
    "kcalc",
    "kdeconnect",
    "kinit",
    "konsole",
    #"krunner",
    "kvantum",
    "kwrite",
    "okular",
    "packagekit-qt5",
    "partitionmanager",
    "xsettingsd",
    # language switching via qdbus
    "qt5-tools",
    # keyring
    "kwallet",
    "kwalletmanager",
    ]})
# plasma plugins
blocks.append({ "ensure": aur_package_installed, "for": "plasma6-applets-window-title" })
# plasma configuration
blocks.append({ "ensure": kconfig_content, "for": [
    { "file": expanduser("~/.config/plasmashellrc"), "entries": [
        { "group": "PlasmaViews][Panel 2", "key": "alignment", "value": "132" },
        { "group": "PlasmaViews][Panel 2", "key": "floating", "value": "0" },
        { "group": "PlasmaViews][Panel 2", "key": "panelLengthMode", "value": "0" },
        { "group": "PlasmaViews][Panel 2", "key": "panelVisibility", "value": "1" },
        { "group": "PlasmaViews][Panel 2][Defaults", "key": "thickness", "value": "32" },
        ] },
    { "file": expanduser("~/.config/plasma-org.kde.plasma.desktop-appletsrc"), "entries": [
        { "group": "Containments][1", "key": "formfactor", "value": "0" },
        { "group": "Containments][1", "key": "immutability", "value": "1" },
        { "group": "Containments][1", "key": "location", "value": "0" },
        { "group": "Containments][1", "key": "plugin", "value": "org.kde.plasma.folder" },
        { "group": "Containments][1", "key": "wallpaperplugin", "value": "org.kde.image" },
        # ...
        { "group": "Containments][2", "key": "activityId", "value": "" },
        { "group": "Containments][2", "key": "formfactor", "value": "2" },
        { "group": "Containments][2", "key": "immutability", "value": "1" },
        { "group": "Containments][2", "key": "location", "value": "4" },
        { "group": "Containments][2", "key": "plugin", "value": "org.kde.panel" },
        { "group": "Containments][2", "key": "wallpaperplugin", "value": "org.kde.image" },
        { "group": "Containments][2][General", "key": "AppletOrder", "value": "29;42;40;26;7;15" },
        # ...
        { "group": "Containments][2][Applets][29", "key": "immutability", "value": "1" },
        { "group": "Containments][2][Applets][29", "key": "plugin", "value": "org.kde.plasma.kicker" },
        { "group": "Containments][2][Applets][29][Configuration][General", "key": "favoritesPortedToKAstats", "value": "true" },
        { "group": "Containments][2][Applets][29][Configuration][General", "key": "showRecentDocs", "value": "false" },
        # ...
        { "group": "Containments][2][Applets][42", "key": "immutability", "value": "1" },
        { "group": "Containments][2][Applets][42", "key": "plugin", "value": "org.kde.windowtitle" },
        { "group": "Containments][2][Applets][42][Configuration][Appearance", "key": "customSize", "value": "18" },
        # ...
        { "group": "Containments][2][Applets][40", "key": "immutability", "value": "1" },
        { "group": "Containments][2][Applets][40", "key": "plugin", "value": "org.kde.plasma.panelspacer" },
        # ...
        { "group": "Containments][2][Applets][26", "key": "immutability", "value": "1" },
        { "group": "Containments][2][Applets][26", "key": "plugin", "value": "org.kde.plasma.windowlist" },
        # ...
        { "group": "Containments][2][Applets][7", "key": "immutability", "value": "1" },
        { "group": "Containments][2][Applets][7", "key": "plugin", "value": "org.kde.plasma.systemtray" },
        { "group": "Containments][2][Applets][7][Configuration", "key": "SystrayContainmentId", "value": "8" },
        { "group": "Containments][8", "key": "activityId", "value": "" },
        { "group": "Containments][8", "key": "formfactor", "value": "2" },
        { "group": "Containments][8", "key": "immutability", "value": "1" },
        { "group": "Containments][8", "key": "location", "value": "4" },
        { "group": "Containments][8", "key": "plugin", "value": "org.kde.plasma.private.systemtray" },
        { "group": "Containments][8", "key": "wallpaperplugin", "value": "org.kde.image" },
        # ...
        { "group": "Containments][2][Applets][15", "key": "immutability", "value": "1" },
        { "group": "Containments][2][Applets][15", "key": "plugin", "value": "org.kde.plasma.digitalclock" },
        { "group": "Containments][2][Applets][15][Configuration][Appearance", "key": "dateDisplayFormat", "value": "BesideTime" },
        { "group": "Containments][2][Applets][15][Configuration][Appearance", "key": "dateFormat", "value": "isoDate" },
        { "group": "Containments][2][Applets][15][Configuration][Appearance", "key": "use24hFormat", "value": "2" },
        ] },
    { "file": expanduser("~/.config/kxkbrc"), "entries": [
        { "group": "Layout", "key": "DisplayNames", "value": ",," },
        { "group": "Layout", "key": "LayoutList", "value": "us,ua,ru" },
        { "group": "Layout", "key": "Use", "value": "true" },
        { "group": "Layout", "key": "VariantList", "value": ",," },
        ] },
    { "file": expanduser("~/.config/kwinrc"), "entries": [
        { "group": "Desktops", "key": "Number", "value": "5" },
        { "group": "Desktops", "key": "Rows", "value": "1" },
        ] },
    { "file": expanduser("~/.config/kdeglobals"), "entries": [
        { "group": "KDE", "key": "AnimationDurationFactor", "value": "0" },
        { "group": "KDE", "key": "LookAndFeelPackage", "value": "org.kde.breezedark.desktop" },
        ] },
    { "file": expanduser("~/.config/kcminputrc"), "entries": [
        { "group": "Keyboard", "key": "RepeatDelay", "value": "250" },
        { "group": "Keyboard", "key": "RepeatRate", "value": "30" },
        ] },
    ]})

blocks = blocks + [
    # development
    { "ensure": package_installed, "for": [
        "ghostty",
        "neovim",
        "wl-clipboard",
        "yazi",
        ] },
    { "ensure": aur_package_installed, "for": "code" },

    { "ensure": package_installed, "for": "docker" },
    { "ensure": system_service_active, "for": "docker.socket" },

    # apps
    { "ensure": package_installed, "for": [
        #"obs-studio",
        #"goverlay",
        "discord",
        "firefox",
        "vlc",
        ] },
    ]

# graphics

# multilib 32bit repository
blocks.append({ "ensure": file_content, "for": { "file": "/etc/pacman.conf", "content": """
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

