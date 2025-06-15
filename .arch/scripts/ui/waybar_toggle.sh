#!/bin/bash

if pgrep -x "waybar" > /dev/null; then
  # Waybar is running, kill it to hide
  killall waybar
else
  # Waybar not running, start it
  hyprctl dispatch exec waybar
fi

