#!/usr/bin/env bash
# ==============================================================================
#  Dotfiles Installer & Deployment Script
#  Rice: Niri + Matugen (Material You dynamic theming)
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config.bak-$(date +%Y%m%d-%H%M%S)"
MODE="link" # link or copy
DRY_RUN=0
VERBOSE=0

# Colors
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_RED="\033[31m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_BLUE="\033[34m"
C_MAGENTA="\033[35m"
C_CYAN="\033[36m"

info()    { printf "${C_CYAN}${C_BOLD}[INFO]${C_RESET} %s\n" "$*"; }
success() { printf "${C_GREEN}${C_BOLD}[OK]${C_RESET} %s\n" "$*"; }
warn()    { printf "${C_YELLOW}${C_BOLD}[WARN]${C_RESET} %s\n" "$*"; }
error()   { printf "${C_RED}${C_BOLD}[ERROR]${C_RESET} %s\n" "$*"; }

show_help() {
    cat <<EOF
${C_BOLD}Usage:${C_RESET} ./install.sh [options]

${C_BOLD}Options:${C_RESET}
  -l, --link       Symlink dotfiles to destination (default, recommended)
  -c, --copy       Copy dotfiles instead of symlinking
  -d, --dry-run    Show what would be installed without making changes
  -v, --verbose    Show detailed log for every file processed
  --check          Only check system dependencies and exit
  -h, --help       Show this help message

${C_BOLD}Description:${C_RESET}
  Safely installs Niri + Matugen rice dotfiles:
    - ~/.config/* configs
    - ~/.local/bin/* scripts
    - Zen Browser userChrome & userContent CSS themes
    - System shell profiles and wallpaper assets
  Existing configurations are backed up to ~/.config.bak-<timestamp>
EOF
}

# Parse flags
CHECK_ONLY=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--link)    MODE="link"; shift ;;
        -c|--copy)    MODE="copy"; shift ;;
        -d|--dry-run) DRY_RUN=1; shift ;;
        -v|--verbose) VERBOSE=1; shift ;;
        --check)      CHECK_ONLY=1; shift ;;
        -h|--help)    show_help; exit 0 ;;
        *) error "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

banner() {
    printf "${C_MAGENTA}${C_BOLD}"
    cat << 'EOF'
     __     __  _ ___ _          
 ___/ /__  / /_/ / _ (_)__ ___  
/ _  / _ \/ __/ / _/ / / -_|_-< 
\_,_/\___/\__/_/_//_/_/\__/___/ 
Niri + Matugen Dynamic Rice
EOF
    printf "${C_RESET}\n"
}

check_dependencies() {
    info "Checking system dependencies..."
    local deps=(
        "niri:Scrollable Tiling Compositor"
        "waybar:Status Bar"
        "matugen:Material You Theming Engine"
        "awww:Wallpaper Daemon (or swww/hyprpaper)"
        "fuzzel:App Launcher"
        "rofi:Application & Menu Launcher"
        "kitty:Terminal Emulator"
        "alacritty:Fallback Terminal"
        "mako:Notification Daemon"
        "swayosd-server:Volume/Brightness OSD"
        "hypridle:Idle Management Daemon"
        "hyprlock:Screen Locker"
        "wlogout:Power/Logout Menu"
        "fish:Fish Shell (optional)"
        "brightnessctl:Display Brightness Control"
        "wpctl:WirePlumber Audio Control"
        "playerctl:Media Player Control"
        "magick:ImageMagick (for icon recoloring)"
    )

    local missing=0
    for entry in "${deps[@]}"; do
        local cmd="${entry%%:*}"
        local desc="${entry#*:}"
        if command -v "$cmd" >/dev/null 2>&1; then
            printf "  ${C_GREEN}✓${C_RESET} %-18s %s\n" "$cmd" "($desc)"
        else
            printf "  ${C_YELLOW}✗${C_RESET} %-18s %s ${C_YELLOW}(missing)${C_RESET}\n" "$cmd" "($desc)"
            ((missing++)) || true
        fi
    done

    echo ""
    if [ "$missing" -eq 0 ]; then
        success "All core dependencies are installed!"
    else
        warn "$missing dependency(ies) missing. Some features may require installing them."
        info "On Fedora: sudo dnf install niri waybar kitty alacritty fuzzel rofi mako ImageMagick playerctl brightnessctl"
        info "Matugen can be installed via cargo: cargo install matugen"
    fi
}

backup_target() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            [ "$VERBOSE" -eq 1 ] && info "[Dry-Run] Would backup: $target"
            return
        fi
        mkdir -p "$BACKUP_DIR"
        local rel="${target#$HOME/}"
        local dest_bak="$BACKUP_DIR/$rel"
        mkdir -p "$(dirname "$dest_bak")"
        mv "$target" "$dest_bak"
        [ "$VERBOSE" -eq 1 ] && info "Backed up $target -> $dest_bak"
    fi
}

install_item() {
    local src="$1"
    local dst="$2"

    if [ "$DRY_RUN" -eq 1 ]; then
        info "[Dry-Run] $MODE: $src -> $dst"
        return
    fi

    mkdir -p "$(dirname "$dst")"
    backup_target "$dst"

    if [ "$MODE" = "link" ]; then
        ln -sf "$src" "$dst"
    else
        if [ -d "$src" ]; then
            cp -r "$src" "$dst"
        else
            cp "$src" "$dst"
        fi
    fi
    [ "$VERBOSE" -eq 1 ] && success "Installed: $dst"
}

setup_zen_browser() {
    info "Configuring Zen Browser chrome theme..."
    local zen_dirs=(
        "$HOME/.zen"
        "$HOME/.config/zen"
    )
    local found_profile=0

    for zdir in "${zen_dirs[@]}"; do
        if [ -d "$zdir" ]; then
            for prof in "$zdir"/*; do
                if [ -d "$prof" ] && [[ "$(basename "$prof")" == *"Default"* || "$(basename "$prof")" == *"release"* ]]; then
                    local chrome_dir="$prof/chrome"
                    info "Found Zen profile at: $prof"
                    install_item "$DOTFILES_DIR/zen/chrome" "$chrome_dir"
                    found_profile=1
                fi
            done
        fi
    done

    if [ "$found_profile" -eq 0 ]; then
        warn "No existing Zen Browser profile found."
        info "To use the Zen theme later, copy or link '$DOTFILES_DIR/zen/chrome' into your Zen profile's 'chrome' folder."
    else
        success "Zen Browser theme installed into active profile(s)!"
        info "Note: Enable toolkit.legacyUserProfileCustomizations.stylesheets in about:config if needed."
    fi
}

main() {
    banner

    if [ "$CHECK_ONLY" -eq 1 ]; then
        check_dependencies
        exit 0
    fi

    check_dependencies
    echo ""
    info "Starting installation in ${C_BOLD}$MODE${C_RESET} mode..."
    [ "$DRY_RUN" -eq 1 ] && warn "Running in DRY-RUN mode. No changes will be applied."

    # 1. ~/.config directories
    info "Installing .config components..."
    for item in "$DOTFILES_DIR/.config"/*; do
        [ -e "$item" ] || continue
        local name="$(basename "$item")"
        install_item "$item" "$HOME/.config/$name"
    done

    # 2. ~/.local/bin scripts
    info "Installing user scripts into ~/.local/bin..."
    mkdir -p "$HOME/.local/bin"
    for item in "$DOTFILES_DIR/.local/bin"/*; do
        [ -e "$item" ] || continue
        local name="$(basename "$item")"
        install_item "$item" "$HOME/.local/bin/$name"
        [ "$DRY_RUN" -eq 0 ] && chmod +x "$HOME/.local/bin/$name" 2>/dev/null || true
    done

    # 3. Ensure ~/.config/scripts are executable
    if [ "$DRY_RUN" -eq 0 ] && [ -d "$HOME/.config/scripts" ]; then
        chmod +x "$HOME/.config/scripts"/*.sh 2>/dev/null || true
        chmod +x "$HOME/.config/scripts"/fuzzel-* 2>/dev/null || true
        [ -d "$HOME/.config/scripts/bgselector" ] && chmod +x "$HOME/.config/scripts/bgselector"/*.sh 2>/dev/null || true
    fi

    # 4. Waybar scripts executable
    if [ "$DRY_RUN" -eq 0 ] && [ -d "$HOME/.config/waybar/scripts" ]; then
        chmod +x "$HOME/.config/waybar/scripts"/* 2>/dev/null || true
    fi

    # 5. Assets & Wallpapers
    info "Setting up assets and default wallpapers..."
    mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Pictures/wlogout" "$HOME/.config/assets"
    for wlicon in "$DOTFILES_DIR/assets/wlogout"/*; do
        [ -e "$wlicon" ] || continue
        local iname="$(basename "$wlicon")"
        [ -f "$HOME/Pictures/wlogout/$iname" ] || cp "$wlicon" "$HOME/Pictures/wlogout/$iname"
    done
    for wp in "$DOTFILES_DIR/assets/wallpapers"/*; do
        [ -e "$wp" ] || continue
        local wpname="$(basename "$wp")"
        [ -f "$HOME/Pictures/Wallpapers/$wpname" ] || cp "$wp" "$HOME/Pictures/Wallpapers/$wpname"
    done
    if [ -f "$DOTFILES_DIR/assets/avatars/avatar.jpg" ] && [ ! -f "$HOME/.config/assets/avatar.jpg" ]; then
        cp "$DOTFILES_DIR/assets/avatars/avatar.jpg" "$HOME/.config/assets/avatar.jpg"
    fi

    # 6. Zen Browser
    setup_zen_browser

    # 7. Shell rc files (only installed if user confirms or copies)
    info "Home shell profiles are stored in '$DOTFILES_DIR/home/'."
    info "To link them: ln -sf '$DOTFILES_DIR/home/.bashrc' ~/.bashrc"

    echo ""
    if [ -d "$BACKUP_DIR" ]; then
        success "Any replaced files were saved safely to: $BACKUP_DIR"
    fi

    success "Installation complete!"
    info "To apply theme dynamically to your current wallpaper, run:"
    printf "  ${C_BOLD}qs-bgselector${C_RESET} or ${C_BOLD}matugen image ~/Pictures/Wallpapers/wallpaper.jpg${C_RESET}\n\n"
}

main "$@"
