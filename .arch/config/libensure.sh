if [ "$(id -u)" -eq 0 ]; then
    log_error "This script should not be run as root or with sudo"
    exit 1
fi

set -e # exit on any error

NC='\033[0m'
BOLD='\033[0;1m'
DIM='\033[0;2m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

log_info() {
    echo -e "${DIM}${BOLD}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}${BOLD}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

package_exists() {
    pacman -Q "$1" &>/dev/null
}

ensure_aur_package_installed_raw() {
    local package_name="$1"
    if package_exists "$package_name"; then
        return 0
    fi
    log_info "Installing $package_name raw from AUR"
    local temp_dir="/tmp"
    local package_dir="${temp_dir}/${package_name}"

    pushd "$temp_dir" >/dev/null || return 1

    if [[ -d "$package_dir" ]]; then
        rm -rf "$package_dir"
    fi

    git clone "https://aur.archlinux.org/${package_name}.git"
    if [[ $? -ne 0 ]]; then
        log_error "Failed to clone '${package_name}'"
        popd >/dev/null
        return 1
    fi

    cd "$package_dir" || return 1
    makepkg -si --noconfirm
    if [[ $? -ne 0 ]]; then
        log_error "Failed to build '${package_name}'"
        popd >/dev/null
        return 1
    fi

    popd >/dev/null
    rm -rf "$package_dir"
    return 0
}

ensure_packages_installed() {
    for package_name in "$@"; do
        if package_exists "$package_name"; then
            continue
        fi
        log_info "Installing pacman package '${package_name}'"
        sudo pacman -S --noconfirm "$package_name" || {
            log_error "Failed to install pacman package '${package_name}'"
            return 1
        }
    done
    return 0
}

ensure_aur_packages_installed() {
    for package_name in "$@"; do
        if package_exists "$package_name"; then
            continue
        fi
        log_info "Installing AUR package '${package_name}'"
        yay -S --noconfirm "$package_name" || {
            log_error "Failed to install AUR package '${package_name}'"
            return 1
        }
    done
    return 0
}

ensure_system_services_enabled() {
    for service_name in "$@"; do
        [[ "$service_name" == *.service ]] || service_name="${service_name}.service"

        if ! sudo systemctl is-enabled "$service_name" | grep -q enabled; then
            sudo systemctl enable "$service_name" || {
                log_error "Failed to enable service '${service_name}'"
                return 1
            }
        fi

        if ! sudo systemctl is-active "$service_name" | grep -q active; then
            sudo systemctl start "$service_name" || {
                log_error "Failed to start service '${service_name}'"
                return 1
            }
        fi
    done
    return 0
}

ensure_user_services_enabled() {
    for service_name in "$@"; do
        [[ "$service_name" == *.service ]] || service_name="${service_name}.service"

        if ! systemctl --user is-enabled "$service_name" | grep -q enabled; then
            systemctl --user enable "$service_name" || {
                log_error "Failed to enable service '${service_name}'"
                return 1
            }
        fi

        if ! systemctl --user is-active "$service_name" | grep -q active; then
            systemctl --user start "$service_name" || {
                log_error "Failed to start service '${service_name}'"
                return 1
            }
        fi
    done
    return 0
}

ensure_files_contents() {
    local -n entries=$1  # Pass by name
    local i=0
    while (( i < ${#entries[@]} )); do
        local filename="${entries[i]}"
        local contents="${entries[i+1]}"
        i=$((i + 2))
    #for file_config in "$@"; do
        #local filename contents
        ##filename=$(echo "$file_config" | cut -d: -f1)
        ##contents=$(echo "$file_config" | cut -d: -f2-)
        #filename="${item%%||||*}"
        #contents="${item#*||||}"

        grep -Fq -- "$contents" "$filename" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            continue
        fi

        log_info "Appending content to '${filename}'"

        tail -c1 "$filename" | od -An -t x1 | grep -q '0a'
        if [[ $? -ne 0 ]]; then
            contents=$'\n'"$contents"
        fi

        echo "$contents" | sudo tee -a "$filename" >/dev/null || {
            log_error "Error writing to '${filename}'"
            return 1
        }
    done
    return 0
}

