#!/bin/bash

LAYOUT_INDEX=$1

# Get device names of all keyboards
devices=$(hyprctl devices | awk '
  /Keyboard at/ {getline; print $1}
')

for device in $devices; do
    # Switch layout on each device
    hyprctl switchxkblayout "$device" "$LAYOUT_INDEX"
done

