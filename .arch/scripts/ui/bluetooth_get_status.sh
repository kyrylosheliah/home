#!/bin/bash

status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
connected=$(bluetoothctl info | grep "Connected: yes")

if [[ "$status" == "yes" ]]; then
    if [[ -n "$connected" ]]; then
        echo '{"text": "  ", "tooltip": "Bluetooth: Connected", "class": "connected"}'
    else
        echo '{"text": "  ", "tooltip": "Bluetooth: On", "class": "on"}'
    fi
else
    echo '{"text": " 󰂲 ", "tooltip": "Bluetooth: Off", "class": "off"}'
fi

