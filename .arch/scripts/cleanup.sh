#!/bin/bash

# package cache
sudo paccache -rk3

# orphaned packages
sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null

# user cache
rm -rf ~/.cache/thumbnails/*
rm -rf ~/.cache/mozilla/firefox/*/cache2/*

# logs
sudo journalctl --vacuum-time=2weeks

# trash
rm -rf ~/.local/share/Trash/*

