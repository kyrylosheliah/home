#!/bin/bash

# Get all client windows with title, class, and address
clients=$(hyprctl clients -j)

# Prepare a list with format: "title [class]" address
# We'll pass both fields through awk separately
windows=$(echo "$clients" | jq -r '
  .[] | select(.title != "") |
  "\(.title) [\(.class)]␞\(.address)"
')

# Launch rofi with the first part (title + class)
selection=$(echo "$windows" | awk -F '␞' '{ print $1 }' | rofi -dmenu -p "Window")

# Exit if nothing selected
[ -z "$selection" ] && exit 0

# Find the address that matches the selected title line
address=$(echo "$windows" | awk -F '␞' -v sel="$selection" '$1 == sel { print $2 }')

# Focus the selected window
[ -n "$address" ] && hyprctl dispatch focuswindow address:$address

