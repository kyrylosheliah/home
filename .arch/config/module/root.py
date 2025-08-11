import sys
import os
from lib.ensure import (
    conditional_error,
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
        "alsa-utils", # includes `alsamixer` `aplay` `alsa-info.sh`
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
    "kvantum",
    "kwrite",
    "okular",
    "partitionmanager",
    "xsettingsd",
    ]})

# keyring, credential manager
blocks = blocks + [
    { "ensure": package_installed, "for": [
        "kwallet",
        "kwalletmanager",
        "ksshaskpass",
        ]},
    # # auto-unlock the default non-gpg wallet (!) named kdewallet
    # { "ensure": conditional_error, "for": [
    #     { "title": "kwallet auto unlock", "condition": lambda: helpers.file_has_content(
    #         "/etc/pam.d/login",
    #         "auth       optional     pam_kwallet5.so",
    #         ) },
    #     { "title": "kwallet auto unlock", "condition": lambda: helpers.file_has_content(
    #         "/etc/pam.d/login",
    #         "session    optional     pam_kwallet5.so auto_start force_run",
    #         ) },
    #     ]},
    { "ensure": file_content, "for": [
        { "file": expanduser("~/.gitconfig"),
            "content": "[credential]\n\thelper = cache" },
        { "file": expanduser("~/.config/environment.d/git_askpass.conf"),
            "content": "GIT_ASKPASS=/usr/bin/ksshaskpass" },
        ]},
    ]

# Prevent things to autostart at this point
#blocks.append({ "ensure": conditional_error, "for": [
#    { "title": "prevent autostart for baloo_file.desktop",
#      "condition": lambda: not helpers.file_exists("/etc/xdg/autostart/baloo_file.desktop") },
#    { "title": "prevent autostart for kaccess.desktop",
#      "condition": lambda: not helpers.file_exists("/etc/xdg/autostart/kaccess.desktop") },
#    { "title": "prevent autostart for org.kde.discover.notifier.desktop",
#      "condition": lambda: not helpers.file_exists("/etc/xdg/autostart/org.kde.discover.notifier.desktop") },
#    { "title": "prevent autostart for org.kde.kdeconnect.daemon.desktop",
#      "condition": lambda: not helpers.file_exists("/etc/xdg/autostart/org.kde.kdeconnect.daemon.desktop") },
#    ]})

# Plasma configuration files
# - is equivalent to calling kreadconfig6 and kwriteconfig6, but with compound
# nested sections support (such as `[section1][section2][section3]`)
# - probably, could automatically reload configured DE subsystems with:
# qdbus-qt5 org.kde.KWin /KWin reloadConfig
# qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell
# qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.reloadConfig
# qdbus-qt5 org.kde.kglobalaccel /component/khotkeys org.kde.kglobalaccel.Hotkeys.reloadConfiguration
blocks.append({ "ensure": kconfig_content, "for": [
    # balooctl6 suspend, balooctl6 disable, balooctl6 purge
    { "file": expanduser("~/.config/baloofilerc"), "for": [
        { "group": "[Basic Settings]", "for": [
            { "key": "Indexing-Enabled", "value": "false" },
            ] },
        ] },
    # expect `[Panel 2]` identifier on fresh install, regeneration requires
    # `~/.config/plasmashellrc` and
    # `~/.config/plasma-org.kde.plasma.desktop-appletsrc`
    # files deletion
    { "file": expanduser("~/.config/plasmashellrc"), "for": [
        { "group": "[PlasmaViews][Panel 2]", "for": [
            { "key": "floating", "value": "0" },
            { "key": "panelLengthMode", "value": "0" },
            { "key": "panelOpacity", "value": "1" },
            { "key": "panelVisibility", "value": "1" },
            ] },
        ] },
    { "file": expanduser("~/.config/ksmserverrc"), "for": [
        { "group": "[General]", "for": [
            { "key": "loginMode", "value": "emptySession" },
            ] },
        ] },
    { "file": expanduser("~/.config/kxkbrc"), "for": [
        { "group": "[Layout]", "for": [
            { "key": "DisplayNames", "value": ",," },
            { "key": "LayoutList", "value": "us,ua,ru" },
            { "key": "Use", "value": "true" },
            { "key": "VariantList", "value": ",," },
            ] },
        ] },
    { "file": expanduser("~/.config/kwinrc"), "for": [
        { "group": "[Desktops]", "for": [
            { "key": "Number", "value": "5" },
            { "key": "Rows", "value": "1" },
            ] },
        ] },
    { "file": expanduser("~/.config/kdeglobals"), "for": [
        { "group": "[KDE]", "for": [
            { "key": "AnimationDurationFactor", "value": "0" },
            { "key": "LookAndFeelPackage", "value": "org.kde.breezedark.desktop" },
            ] },
        ] },
    { "file": expanduser("~/.config/kcminputrc"), "for": [
        { "group": "[Keyboard]", "for": [
            { "key": "RepeatDelay", "value": "250" },
            { "key": "RepeatRate", "value": "30" },
            ] },
        ] },
    { "file": expanduser("~/.config/kglobalshortcutsrc"), "for": [
        { "group": "[KDE Keyboard Layout Switcher]", "for": [
            { "key": "Switch to Next Keyboard Layout", "value": "Meta+Space,Meta+Alt+K,Switch to Next Keyboard Layout" },
            ] },
        { "group": "[kwin]", "for": [
            { "key": "Overview", "value": "Meta+W,Meta+W,Toggle Overview" },
            { "key": "Show Desktop", "value": "Meta+D,Meta+D,Peek at Desktop" },
            { "key": "Switch One Desktop Down", "value": "Meta+Ctrl+Down,Meta+Ctrl+Down,Switch One Desktop Down" },
            { "key": "Switch One Desktop Up", "value": "Meta+Ctrl+Up,Meta+Ctrl+Up,Switch One Desktop Up" },
            { "key": "Switch One Desktop to the Left", "value": "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left" },
            { "key": "Switch One Desktop to the Right", "value": "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right" },
            { "key": "Switch Window Down", "value": "Meta+Alt+Down,Meta+Alt+Down,Switch to Window Below" },
            { "key": "Switch Window Left", "value": "Meta+Alt+Left,Meta+Alt+Left,Switch to Window to the Left" },
            { "key": "Switch Window Right", "value": "Meta+Alt+Right,Meta+Alt+Right,Switch to Window to the Right" },
            { "key": "Switch Window Up", "value": "Meta+Alt+Up,Meta+Alt+Up,Switch to Window Above" },
            { "key": "Switch to Desktop 1", "value": r"Ctrl+F1\tMeta+1,Ctrl+F1,Switch to Desktop 1" },
            { "key": "Switch to Desktop 2", "value": r"Ctrl+F2\tMeta+2,Ctrl+F2,Switch to Desktop 2" },
            { "key": "Switch to Desktop 3", "value": r"Ctrl+F3\tMeta+3,Ctrl+F3,Switch to Desktop 3" },
            { "key": "Switch to Desktop 4", "value": r"Ctrl+F4\tMeta+4,Ctrl+F4,Switch to Desktop 4" },
            { "key": "Switch to Desktop 5", "value": "Meta+5,,Switch to Desktop 5" },
            { "key": "Window Maximize", "value": "Meta+PgUp,Meta+PgUp,Maximize Window" },
            { "key": "Window Minimize", "value": "Meta+PgDown,Meta+PgDown,Minimize Window" },
            { "key": "Window to Desktop 1", "value": "Meta+!,,Window to Desktop 1" },
            { "key": "Window to Desktop 2", "value": "Meta+@,,Window to Desktop 2" },
            { "key": "Window to Desktop 3", "value": "Meta+#,,Window to Desktop 3" },
            { "key": "Window to Desktop 4", "value": "Meta+$,,Window to Desktop 4" },
            { "key": "Window to Desktop 5", "value": "Meta+%,,Window to Desktop 5" },
            ] },
        { "group": "[plasmashell]", "for": [
            { "key": "cycle-panels", "value": "Meta+Alt+P,Meta+Alt+P,Move keyboard focus between panels" },
            ] },
        { "group": "[services][org.kde.krunner.desktop]", "for": [
            #{ "key": "_launch", "value": r"Search\tAlt+F2\tAlt+Space" },
            # disable krunner, so it won't spawn a process at startup
            { "key": "RunClipboard", "value": "none" },
            { "key": "_launch", "value": "none" },
            ] },
        ] },
    ]})

blocks = blocks + [
    # development
    { "ensure": package_installed, "for": [
        "foot",
        "tmux",
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
blocks.append({ "ensure": file_content, "for": [
    { "file": "/etc/pacman.conf",
      "content": "[multilib]\nInclude = /etc/pacman.d/mirrorlist" },
    ] })

#match options.config["gpu"]:
#    case "amd":
#        blocks = blocks + [
#            { "ensure": package_installed, "for": [
#                "mesa", "lib32-mesa",
#                "vulkan-radeon", "lib32-vulkan-radeon",
#                "vulkan-icd-loader", "lib32-vulkan-icd-loader",
#                ] },
#            { "ensure": aur_package_installed, "for": "lact" },
#            { "ensure": system_service_active, "for": "lactd" },
#            ]
#    case "nvidia":
#        blocks.append({ "ensure": package_installed, "for": [
#            "nvidia",
#            "nvidia-utils", "lib32-nvidia-utils",
#            "nvidia-settings",
#            "opencl-nvidia",
#            ] })

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
