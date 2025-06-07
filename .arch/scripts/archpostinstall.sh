#!/bin/bash
# Arch Linux post-install setup script
set -e # exit on any error

NC='\033[0m' # no color
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [ "$(id -u)" -eq 0 ]; then
    log_error "This script should not be run as root or with sudo"
    exit 1
fi

if ! command -v decman &> /dev/null; then
    log_info "Installing decman ..."
    git clone https://aur.archlinux.org/decman.git
    cd decman || exit
    makepkg -si --noconfirm
    cd .. && rm -rf decman
    log_success "Installed decman"
else
    log_warning "decman was already installed"
fi

log_info "Running decman for the first time ..."
sudo decman --souce ~/.arch/decman/source.py

