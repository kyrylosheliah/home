#!/bin/bash

# Get focused window info from hyprctl
focused_json=$(hyprctl activewindow -j)

# If no focused window, try scratchpad or fallback
if [[ -z "$focused_json" || "$focused_json" == "{}" ]]; then
  # Try to get scratchpad window title (or any window from hyprctl clients)
  # You can customize this as needed
  focused_json=$(hyprctl clients -j | jq -r '.[] | select(.workspace=="special") | {title: .title} | @json' | head -n1)
  # If still empty, fallback
  if [[ -z "$focused_json" || "$focused_json" == "null" ]]; then
    echo "No active window"
    exit 0
  fi
fi

# Parse title with jq
title=$(echo "$focused_json" | jq -r '.title // "No title"')

echo "$title"

