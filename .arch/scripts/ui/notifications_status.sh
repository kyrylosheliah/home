#!/bin/bash

# Show DND icon or blank depending on status
if dunstctl is-paused | grep -q true; then
    echo '{"text":"󰪑 ","tooltip":"Do Not Disturb is ON","class":"dnd"}'
else
    echo '{"text":"󰂜 ","tooltip":"Do Not Disturb is OFF","class":"nodnd"}'
fi

