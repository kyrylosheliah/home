#!/bin/bash

layouts=("us" "ua" "ru")

# Make sure an index was passed
if [ -z "$1" ]; then
    echo "Usage: $0 <index>"
    exit 1
fi

index="$1"

# Validate index
if (( index < 0 || index >= ${#layouts[@]} )); then
    echo "Invalid index: $index"
    exit 1
fi

# Build new layout string: selected layout first, then the rest
selected="${layouts[$index]}"
reordered=("$selected")

for (( i=0; i<${#layouts[@]}; i++ )); do
    [[ $i -ne $index ]] && reordered+=("${layouts[$i]}")
done

# Convert array to comma-separated string
layout_string=$(IFS=, ; echo "${reordered[*]}")

# Apply it via hyprctl
hyprctl keyword input:kb_layout "$layout_string"
