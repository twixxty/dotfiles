# ✨ Niri + Matugen Material You Dotfiles

<p align="center">
  <img src="https://img.shields.io/badge/Compositor-Niri-4A154B?style=for-the-badge&logo=wayland&logoColor=white" />
  <img src="https://img.shields.io/badge/Theming-Matugen%20Material%20You-6750A4?style=for-the-badge&logo=materialdesign&logoColor=white" />
  <img src="https://img.shields.io/badge/Status%20Bar-Waybar-2B2D42?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Shell-Fish%20%7C%20Bash-4E9A06?style=for-the-badge&logo=gnubash&logoColor=white" />
  <img src="https://img.shields.io/badge/Terminal-Kitty%20%7C%20Alacritty-FF5C57?style=for-the-badge&logo=alacritty&logoColor=white" />
</p>

A clean, production-ready, dynamic **Material You (M3)** dotfiles setup for Linux Wayland. Built around the **Niri** scrollable-tiling compositor and orchestrated by **Matugen**, every component—from the vertical Waybar and Zen Browser to the terminals and lockscreen—adapts seamlessly to the dominant color palette of your wallpaper.

---

## 📸 Overview & Features

- **🎨 Dynamic Material You Theming**: Change your wallpaper with `qs-bgselector` or `bgselector.sh`, and Matugen rethemes Kitty, Alacritty, Waybar, Zen Browser, Vesktop (Discord), Mako, SwayOSD, Rofi, GTK3/4, and Kvantum in real time.
- **🪟 Scrollable Tiling Compositor (Niri)**: Endless horizontal scrolling workspaces, spring physics animations, custom window rules, and floating drop shadows.
- **📊 Minimal Vertical Waybar**: Left-aligned pill dock featuring rotating circular album art, expandable MPRIS music drawer, system tray, and status indicators.
- **🦊 Zen Browser Custom Chrome**: Tailored `userChrome.css` and `userContent.css` theme that reads Matugen color variables without storing or tracking any browser tokens, cookies, or databases.
- **🎛️ Unified Control & Notification Center**: Integrated Vyom (`kendra` control panel and `suchana` notification history) with caffeine toggle, volume/brightness controls, and quick settings.
- **🚀 Portable & Production Ready**: Free from hardcoded usernames, personal Bluetooth MACs, local virtual environments, and bloat.

---

## 📦 Rice Components

| Component | Software | Description |
| :--- | :--- | :--- |
| **Compositor** | [Niri](https://github.com/YaLTeR/niri) | Scrollable-tiling Wayland compositor |
| **Alternative WM** | [i3](https://i3wm.org/) | X11 tiling window manager port included |
| **Theming Engine** | [Matugen](https://github.com/InioX/matugen) | Material Design 3 color generator |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Vertical left pill bar with custom MPRIS cover art |
| **Launcher** | [Vicinae](https://github.com/vicinaehq/vicinae) / [Fuzzel](https://codeberg.org/dnkl/fuzzel) / [Rofi](https://github.com/davatorium/rofi) | App launchers and menus |
| **Terminals** | [Kitty](https://sw.kovidgoyal.net/kitty/) & [Alacritty](https://alacritty.org/) | GPU-accelerated terminal emulators |
| **Shells** | [Fish](https://fishshell.com/) & [Bash](https://www.gnu.org/software/bash/) | Interactive shell prompt and profile configs |
| **Notifications** | [Mako](https://github.com/emersion/mako) | Lightweight Wayland notification daemon |
| **On-Screen Display** | [SwayOSD](https://github.com/ErikReider/SwayOSD) | Modern volume and brightness popups |
| **Lockscreen & Idle** | [Hyprlock](https://github.com/hyprwm/hyprlock) & [Hypridle](https://github.com/hyprwm/hypridle) | Screen locking and power management |
| **Logout Menu** | [Wlogout](https://github.com/ArtsyMacaw/wlogout) | Styled power/logout menu with auto-tinted icons |
| **Wallpaper Picker** | `qs-bgselector` / `bgselector.sh` | Interactive carousel (Quickshell) & parallel Rofi picker |
| **Audio Visualizer** | [Cava](https://github.com/karlstav/cava) | Console audio visualizer |
| **System Monitor** | [Btop](https://github.com/aristocratos/btop) & [Htop](https://htop.dev/) | Process and system monitor |

---

## 📂 Repository Structure

```text
dotfiles/
├── .config/
│   ├── alacritty/       # Alacritty terminal configuration & colors
│   ├── btop/            # Btop system monitor theme
│   ├── cava/            # Cava audio visualizer & shaders
│   ├── fastfetch/       # System fetch config and ASCII art
│   ├── fish/            # Fish shell prompt & functions
│   ├── formalmusic/     # Formalmusic player config & theme
│   ├── fuzzel/          # Fuzzel launcher theme
│   ├── gtk-3.0/         # GTK 3 settings, colors, bookmarks
│   ├── gtk-4.0/         # GTK 4 colors & style
│   ├── htop/            # Htop preferences
│   ├── hypr/            # Hypridle, Hyprlock, Hyprpaper configs
│   ├── hypryou/         # HyprYou settings
│   ├── i3/              # i3 tiling window manager config
│   ├── kitty/           # Kitty terminal & colors
│   ├── kopuz/           # Kopuz audio player settings (no databases)
│   ├── Kvantum/         # Kvantum Qt theming & SVG assets
│   ├── mako/            # Mako notification daemon configuration
│   ├── matugen/         # Matugen orchestrator, templates & papirus hook
│   ├── mimeapps.list    # Default application associations
│   ├── niri/            # Main Niri compositor configuration (config.kdl)
│   ├── qs-bgselector/   # Wallpaper carousel config & templates
│   ├── quickshell/      # Quickshell theme definition
│   ├── rofi/            # Rofi applets, launchers, scripts & themes
│   ├── scripts/         # Rice utility scripts (battery, brightness, volume, etc.)
│   ├── sunsetr/         # Night light / color temperature daemon
│   ├── swayosd/         # Volume & brightness OSD styling
│   ├── systemd/         # User systemd units (vyom.service)
│   ├── vesktop/         # Vesktop (Discord) settings & CSS themes (no tokens)
│   ├── vicinae/         # Vicinae launcher settings
│   ├── vyom/            # Control center & notification center styling
│   ├── waybar/          # Vertical status bar layout, styling & circle album art
│   ├── wireplumber/     # WirePlumber device configuration rules
│   └── wlogout/         # Logout menu layout, styling & icon tinting
├── .local/bin/          # User helper scripts (caffeinate, qs-bgselector, etc.)
├── zen/chrome/          # Zen Browser userChrome & userContent CSS (no profile/tokens)
├── home/                # Home directory dotfiles (.bashrc, .bash_profile, .fehbg)
├── assets/              # Default wallpapers, wlogout icons, and avatar templates
├── install.sh           # Safe automated installer & symlinker
└── README.md            # Documentation & setup guide
```

---

## 🚀 Installation

### Prerequisites

Ensure the following core tools are installed on your distribution:

**Fedora:**
```bash
sudo dnf install niri waybar kitty alacritty fuzzel rofi mako ImageMagick \
                 playerctl brightnessctl wireplumber python3-pillow
```

**Arch Linux:**
```bash
sudo pacman -S niri waybar kitty alacritty fuzzel rofi mako imagemagick \
               playerctl brightnessctl wireplumber python-pillow
```

**Install Matugen (Material You Engine):**
```bash
cargo install matugen
```

### Quick Install (Automated)

1. Clone this repository into your home directory:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Check dependencies and preview changes:
   ```bash
   ./install.sh --dry-run
   ```

3. Run the installer:
   ```bash
   ./install.sh
   ```

> [!NOTE]
> The installer automatically creates timestamped backups of existing configurations in `~/.config.bak-<timestamp>` before symlinking. It also auto-detects existing Zen Browser profiles and installs the `chrome` theme into them.

---

## ⌨️ Keybindings Cheatsheet

### Applications & Menus
| Keybinding | Action |
| :--- | :--- |
| <kbd>Mod</kbd> + <kbd>Return</kbd> | Open Terminal (`kitty`) |
| <kbd>Mod</kbd> + <kbd>Alt</kbd> + <kbd>Return</kbd> | Open Alternative Terminal (`alacritty`) |
| <kbd>Alt</kbd> + <kbd>Space</kbd> | Open App Launcher (`vicinae`) |
| <kbd>Mod</kbd> + <kbd>W</kbd> | Open Wallpaper Carousel (`qs-bgselector`) |
| <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | Open Rofi Wallpaper Picker (`bgselector.sh`) |
| <kbd>Mod</kbd> + <kbd>E</kbd> | Open File Manager (`nautilus`) |
| <kbd>Mod</kbd> + <kbd>B</kbd> | Open Primary Web Browser |
| <kbd>Mod</kbd> + <kbd>Alt</kbd> + <kbd>B</kbd> | Open Secondary Browser (`zen`) |
| <kbd>Mod</kbd> + <kbd>V</kbd> | Open Discord (`vesktop`) |
| <kbd>Mod</kbd> + <kbd>N</kbd> | Open Notification History (`suchana`) |
| <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> | Open Quick Settings Control Center (`kendra`) |
| <kbd>Mod</kbd> + <kbd>L</kbd> | Lock Screen (`hyprlock`) |
| <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>?</kbd> | Show Niri Hotkey Overlay |

### Window Management & Navigation
| Keybinding | Action |
| :--- | :--- |
| <kbd>Mod</kbd> + <kbd>Q</kbd> | Close Active Window |
| <kbd>Mod</kbd> + <kbd>Left</kbd> / <kbd>Right</kbd> | Focus Column Left / Right |
| <kbd>Mod</kbd> + <kbd>Up</kbd> / <kbd>Down</kbd> | Focus Window Up / Down |
| <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>Left</kbd> / <kbd>Right</kbd> | Move Column Left / Right |
| <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>Up</kbd> / <kbd>Down</kbd> | Move Window Up / Down |
| <kbd>Mod</kbd> + <kbd>F</kbd> | Toggle Maximize Column |
| <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> | Toggle Fullscreen Window |
| <kbd>Mod</kbd> + <kbd>Space</kbd> | Toggle Floating Window |
| <kbd>Mod</kbd> + <kbd>Tab</kbd> | Toggle Workspace Overview |

---

## 🎨 Wallpaper & Dynamic Theming

To switch your wallpaper and automatically regenerate colors across all desktop components:

1. **Interactive Carousel:**
   Press <kbd>Mod</kbd> + <kbd>W</kbd> or run `qs-bgselector`.
2. **Fast Rofi Grid:**
   Press <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> or run `~/.config/scripts/bgselector.sh`.
3. **Manual Command Line:**
   ```bash
   awww img ~/Pictures/Wallpapers/your-image.jpg
   matugen image ~/Pictures/Wallpapers/your-image.jpg -t scheme-smart
   ```

All configuration files in `.config/matugen/templates/` are compiled and injected directly into running applications.

---

## 🔒 Security & Privacy Notice

This repository has been audited and prepared for public distribution:
- **Zero Browser Secrets**: No cookies, session databases, passwords, history, or tokens from Zen, Firefox, Chrome, or Helium are included.
- **Zero Discord Credentials**: All Vesktop `sessionData`, `IndexedDB`, and state tokens are excluded.
- **No Private Keys or Passwords**: Kopuz and system SQLite databases, `.bash_history`, and private keys are removed.
- **Universal Paths**: All paths utilize `$HOME` or XDG specification variables (`$XDG_CONFIG_HOME`) instead of hardcoded user folders.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
Feel free to customize, fork, and adapt it to your own desktop workflow!
