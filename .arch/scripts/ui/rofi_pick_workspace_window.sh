#!/bin/bash

# Get current workspace ID
ws_id=$(hyprctl activeworkspace -j | jq '.id')

# Get all clients and filter by current workspace
clients=$(hyprctl clients -j)

# Prepare list of windows on current workspace
windows=$(echo "$clients" | jq -r --arg ws "$ws_id" '
  .[] | select(.workspace.id == ($ws | tonumber)) | 
  "\(.title) [\(.class)]␞\(.address)"
')

# Show the list in rofi (title only)
selection=$(echo "$windows" | awk -F '␞' '{ print $1 }' | rofi -dmenu -p "$ws_id: focus: ")

# Exit if nothing selected
[ -z "$selection" ] && exit 0

# Find the matching address
address=$(echo "$windows" | awk -F '␞' -v sel="$selection" '$1 == sel { print $2 }')

# Focus the selected window
[ -n "$address" ] && hyprctl dispatch focuswindow address:$address
