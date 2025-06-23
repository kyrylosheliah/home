# TODO: detect DE changes programmatically

# issue: kreadconfig and kwriteconfig sanitize `Containments][2` group name to
# sanitize '[' and ']' and input key code sequence instead
# ? custom config parser and writer script ?
# ? give up dynamic properties ?

# # helpers:
# kreadconfig6
# kwriteconfig6 and set flag
# qdbus-qt5 org.kde.KWin /KWin reloadConfig
# qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell
# qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.reloadConfig
# qdbus-qt5 org.kde.kglobalaccel /component/khotkeys org.kde.kglobalaccel.Hotkeys.reloadConfiguration

# `plasma-org.kde.plasma.desktop-appletsrc`:
#[Containments][2][General]
#AppletOrder=29;42;40;26;6;7;15

# 29: org.kde.plasma.kicker
# 42: org.kde.windowtitle
# 40: org.kde.plasma.panelspacer
# 26: 
# 6: org.kde.plasma.marginsseparator
# 7: org.kde.plasma.systemtray
# 15: org.kde.plasma.digitalcl

# `plasma-org.kde.plasma.desktop-appletsrc`:
#[Containments][2][Shortcuts]
#global=Meta+;

# `plasma-org.kde.plasma.desktop-appletsrc`:
#[Containments][2][Applets][15][Configuration][Appearance]
#dateDisplayFormat=BesideTime
#dateFormat=isoDate
#fontFamily=Iosevka Nerd Font
#fontWeight=400
#use24hFormat=2

# `plasma-org.kde.plasma.desktop-appletsrc`:
#[Containments][8][General]
#extraItems=org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.clipboard,org.kde.plasma.manage-inputmethod,org.kde.plasma.keyboardlayout,org.kde.plasma.brightness,org.kde.plasma.battery,org.kde.plasma.cameraindicator,org.kde.plasma.devicenotifier,org.kde.plasma.keyboardindicator,org.kde.kdeconnect,org.kde.plasma.vault,org.kde.plasma.bluetooth,org.kde.plasma.volume,org.kde.plasma.printmanager,org.kde.plasma.networkmanagement,org.kde.kscreen
#knownItems=org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.clipboard,org.kde.plasma.manage-inputmethod,org.kde.plasma.keyboardlayout,org.kde.plasma.brightness,org.kde.plasma.battery,org.kde.plasma.cameraindicator,org.kde.plasma.devicenotifier,org.kde.plasma.keyboardindicator,org.kde.kdeconnect,org.kde.plasma.vault,org.kde.plasma.bluetooth,org.kde.plasma.volume,org.kde.plasma.printmanager,org.kde.plasma.networkmanagement,org.kde.kscreen

# `kxkbrc`
#[Layout]
#DisplayNames=,,
#LayoutList=us,ua,ru
#Use=true
#VariantList=,,

# `kwinrc`
#[Desktops]
#Id_1=0c142458-aa96-4cb7-b378-3cec70663a96
#Id_10=e4114174-d5f7-4b24-8470-a07a7922b4e8
#Id_11=834e4ed2-1cfb-4417-b052-caba15272315
#Id_12=a146c545-01f3-491d-9f6b-682d906f0903
#Id_2=96d6f361-0c81-4397-b028-07e47a3f6bf7
#Id_3=68ab5bbd-76f8-48cb-ac89-57071c9cbade
#Id_4=280bfcb5-daef-4992-80f7-f61dd0d243fa
#Id_5=95cb8594-b78a-47ce-a108-5ce98c17783e
#Id_6=4b6effe2-6f48-4c55-8e28-797ee9ffead8
#Id_7=79744478-9bfb-432b-9970-44cbc227c1f4
#Id_8=d3959d73-3608-4aa5-95e0-376b340d0913
#Id_9=8f325959-da01-4777-af65-2df45969028b
#Number=12
#Rows=1

# `kdeglobals`
#[KDE]
#AnimationDurationFactor=0
#LookAndFeelPackage=org.kde.breezedark.desktop

# `kcminputrc`
#[Keyboard]
#RepeatDelay=250
#RepeatRate=30

# `kcminputrc`
#[Libinput][2][7][SynPS/2 Synaptics TouchPad]
#NaturalScroll=true
#PointerAccelerationProfile=1
#TapToClick=false

# ??? fonts ??? ::: `Trolltech.conf`

# `plasmashellrc`
#[PlasmaViews][Panel 2]
#alignment=132
#floating=0
#panelLengthMode=0
#panelVisibility=1

# `plasmashellrc`
#[PlasmaViews][Panel 2][Defaults]
#thickness=32



#!/bin/bash

# --- CONFIG PATHS ---
CONFIG_DIR="$HOME/.config"
PLASMA_APPLETSRC="$CONFIG_DIR/plasma-org.kde.plasma.desktop-appletsrc"
KXKBRC="$CONFIG_DIR/kxkbrc"
KWINRC="$CONFIG_DIR/kwinrc"
KDEGLOBALS="$CONFIG_DIR/kdeglobals"
KCMINPUTRC="$CONFIG_DIR/kcminputrc"
PLASMASHELLRC="$CONFIG_DIR/plasmashellrc"

changed=false

# --- FUNCTION TO WRITE A CONFIG VALUE IF DIFFERENT ---
function set_config_value() {
    local file="$1"
    local group="$2"
    local key="$3"
    local new_value="$4"

    current_value=$(kreadconfig5 --file "$file" --group "$group" --key "$key")

    if [[ "$current_value" != "$new_value" ]]; then
        echo "Updating [$group] $key: $current_value -> $new_value"
        kwriteconfig5 --file "$file" --group "$group" --key "$key" "$new_value"
        changed=true
    fi
}

# 1. plasma-org.kde.plasma.desktop-appletsrc
set_config_value "$PLASMA_APPLETSRC" "Containments][2][General" "AppletOrder" "29;42;40;26;6;7;15"
set_config_value "$PLASMA_APPLETSRC" "Containments][2][Shortcuts" "global" "Meta+;"
set_config_value "$PLASMA_APPLETSRC" "Containments][2][Applets][15][Configuration][Appearance" "dateDisplayFormat" "BesideTime"
set_config_value "$PLASMA_APPLETSRC" "Containments][2][Applets][15][Configuration][Appearance" "dateFormat" "isoDate"
set_config_value "$PLASMA_APPLETSRC" "Containments][2][Applets][15][Configuration][Appearance" "fontFamily" "Iosevka Nerd Font"
set_config_value "$PLASMA_APPLETSRC" "Containments][2][Applets][15][Configuration][Appearance" "fontWeight" "400"
set_config_value "$PLASMA_APPLETSRC" "Containments][2][Applets][15][Configuration][Appearance" "use24hFormat" "2"
set_config_value "$PLASMA_APPLETSRC" "Containments][8][General" "extraItems" "org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.clipboard,org.kde.plasma.manage-inputmethod,org.kde.plasma.keyboardlayout,org.kde.plasma.brightness,org.kde.plasma.battery,org.kde.plasma.cameraindicator,org.kde.plasma.devicenotifier,org.kde.plasma.keyboardindicator,org.kde.kdeconnect,org.kde.plasma.vault,org.kde.plasma.bluetooth,org.kde.plasma.volume,org.kde.plasma.printmanager,org.kde.plasma.networkmanagement,org.kde.kscreen"
set_config_value "$PLASMA_APPLETSRC" "Containments][8][General" "knownItems" "org.kde.plasma.mediacontroller,org.kde.plasma.notifications,org.kde.plasma.clipboard,org.kde.plasma.manage-inputmethod,org.kde.plasma.keyboardlayout,org.kde.plasma.brightness,org.kde.plasma.battery,org.kde.plasma.cameraindicator,org.kde.plasma.devicenotifier,org.kde.plasma.keyboardindicator,org.kde.kdeconnect,org.kde.plasma.vault,org.kde.plasma.bluetooth,org.kde.plasma.volume,org.kde.plasma.printmanager,org.kde.plasma.networkmanagement,org.kde.kscreen"

# 2. kxkbrc
set_config_value "$KXKBRC" "Layout" "DisplayNames" ",,"
set_config_value "$KXKBRC" "Layout" "LayoutList" "us,ua,ru"
set_config_value "$KXKBRC" "Layout" "Use" "true"
set_config_value "$KXKBRC" "Layout" "VariantList" ",,"

# 3. kwinrc
set_config_value "$KWINRC" "Desktops" "Number" "12"
set_config_value "$KWINRC" "Desktops" "Rows" "1"
# Ids not checked for brevity; assume already present

# 4. kdeglobals
set_config_value "$KDEGLOBALS" "KDE" "AnimationDurationFactor" "0"
set_config_value "$KDEGLOBALS" "KDE" "LookAndFeelPackage" "org.kde.breezedark.desktop"

# 5. kcminputrc
set_config_value "$KCMINPUTRC" "Keyboard" "RepeatDelay" "250"
set_config_value "$KCMINPUTRC" "Keyboard" "RepeatRate" "30"
set_config_value "$KCMINPUTRC" "Libinput][2][7][SynPS/2 Synaptics TouchPad" "NaturalScroll" "true"
set_config_value "$KCMINPUTRC" "Libinput][2][7][SynPS/2 Synaptics TouchPad" "PointerAccelerationProfile" "1"
set_config_value "$KCMINPUTRC" "Libinput][2][7][SynPS/2 Synaptics TouchPad" "TapToClick" "false"

# 6. plasmashellrc
set_config_value "$PLASMASHELLRC" "PlasmaViews][Panel 2" "alignment" "132"
set_config_value "$PLASMASHELLRC" "PlasmaViews][Panel 2" "floating" "0"
set_config_value "$PLASMASHELLRC" "PlasmaViews][Panel 2" "panelLengthMode" "0"
set_config_value "$PLASMASHELLRC" "PlasmaViews][Panel 2" "panelVisibility" "1"
set_config_value "$PLASMASHELLRC" "PlasmaViews][Panel 2][Defaults" "thickness" "32"

# --- RELOAD KDE COMPONENTS IF NEEDED ---
if $changed; then
    echo "Changes made. Reloading KDE Plasma settings..."
    qdbus-qt5 org.kde.KWin /KWin reloadConfig
    qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.reloadConfig
    qdbus-qt5 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell
    qdbus-qt5 org.kde.kglobalaccel /component/khotkeys org.kde.kglobalaccel.Hotkeys.reloadConfiguration
else
    echo "No changes detected."
fi

