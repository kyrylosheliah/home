#!/bin/bash

# Toggle Dunst pause status
DUNSTCTL=$(command -v dunstctl)

if [[ -z "$DUNSTCTL" ]]; then
  echo "dunstctl not found"
  exit 1
fi

STATUS="$($DUNSTCTL is-paused)"

if [[ "$STATUS" == "true" ]]; then
  $DUNSTCTL set-paused false
else
  $DUNSTCTL set-paused true
fi

