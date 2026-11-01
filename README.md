# twixxty's dotfiles

> ricing setups nobody asked for

running on fedora linux with niri (if it doesn't work on your machine that's your problem)

---

## what is this

my personal niri + material you rice. it has:

- a scrollable tiling compositor because normal tiling is boring
- dynamic material you theming so everything re-colors itself when i change my wallpaper
- a vertical waybar on the left with rotating album art because why not
- custom zen browser css hacks so my browser actually matches my desktop
- vesktop theming so discord doesn't flashbang me
- random shell scripts i glued together at 2 am
- other cool stuff

---

## stack

- **niri** — scrollable tiling compositor because traditional workspaces give me claustrophobia
- **matugen** — extracts colors from my wallpaper and forcefully injects them into like 15 different config files every time i switch images
- **waybar** — vertical pill dock on the left. has rotating vinyl album art for mpris because i felt like it
- **kitty / alacritty** — terminals that actually render fast without electron eating all my ram
- **zen browser (userChrome)** — custom css theme driven by matugen CSS variables. zero cookies or tokens here, don't even try :P
- **vesktop** — discord client with midnight/walcord themes because default discord ui hurts my soul
- **vyom** — control center (`kendra`) and notifications (`suchana`) because gnome settings is bloated
- **swayosd & mako** — volume/brightness popups and notifications with matching borders and zero border radius
- **fuzzel & vicinae** — launchers so i don't have to touch my mouse
- **fish / bash** — minimal prompt with `> ` because i don't need my entire file path taking up half the terminal
- **qs-bgselector** — wallpaper carousel for when i get bored of looking at the same background for 10 minutes

---

## installing it

```bash
git clone https://github.com/twixxty/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

if you're scared of breaking things, run it with `--dry-run` first:

```bash
./install.sh --dry-run
```

it automatically backs up your existing stuff to `~/.config.bak-<timestamp>`. if it still breaks your setup, that's (again) your problem.

---

## keybinds i actually use

| keybind | what it does |
| :--- | :--- |
| `Mod + Return` | open terminal (kitty) |
| `Alt + Space` | app launcher (vicinae) |
| `Mod + W` | open wallpaper carousel (`qs-bgselector`) |
| `Mod + Shift + W` | open rofi wallpaper grid (`bgselector.sh`) |
| `Mod + E` | file manager (nautilus) |
| `Mod + B` | main browser |
| `Mod + Alt + B` | zen browser |
| `Mod + V` | vesktop |
| `Mod + N` | notification history (`suchana`) |
| `Mod + Shift + N` | control center (`kendra`) |
| `Mod + L` | lock screen (`hyprlock`) |
| `Mod + Q` | close active window |
| `Mod + Left / Right` | scroll through columns |
| `Mod + Tab` | toggle workspace overview |
| `Mod + Shift + /` | show niri hotkey overlay (shows the rest of the binds so i don't have to type them all) |

---

## project structure

```text
.config/
  alacritty/     # backup terminal for when kitty misbehaves
  btop/          # system monitor config
  cava/          # audio visualizer and shaders
  fastfetch/     # ascii fetch config
  fish/          # config.fish with a tiny > prompt
  formalmusic/   # music player config
  fuzzel/        # minimal dmenu-like launcher colors
  gtk-3.0/       # adw-gtk3-dark settings and matugen colors
  gtk-4.0/       # gtk4 colors
  htop/          # htoprc
  hypr/          # hypridle, hyprlock, and hyprpaper configs
  i3/            # x11 backup config in case wayland dies
  kitty/         # kitty.conf with jetbrains mono and matugen include
  kopuz/         # music player settings (databases excluded, obviously)
  Kvantum/       # qt matugen theme svg and config
  mako/          # notification daemon styling
  matugen/       # templates for 20 apps so they don't look mismatched
  niri/          # config.kdl, the holy grail of scrollable tiling
  qs-bgselector/ # wallpaper carousel config
  rofi/          # applets and launchers i borrowed from adi1090x
  scripts/       # battery, brightness, volume scripts held together by tape
  sunsetr/       # color temperature daemon
  swayosd/       # volume and brightness pill popups
  vesktop/       # discord without 4gb of memory leaks (no session tokens)
  vicinae/       # spotlight-style launcher config
  vyom/          # control center + notification drawer
  waybar/        # vertical pill dock + circle album art script
  wlogout/       # power menu layout and icon tinting script
.local/bin/      # caffeinate, matugen-lightdm-sync, qs-bgselector
zen/chrome/      # userChrome.css + userContent.css (no tokens/cookies)
home/            # .bashrc and .bash_profile with sanitized paths
assets/          # wlogout icons and wallpapers so it's not empty
install.sh       # script that links everything so you don't have to do it by hand
```

---

## credits

- compositor: [niri](https://github.com/YaLTeR/niri)
- colors: [matugen](https://github.com/InioX/matugen)
- bar: [waybar](https://github.com/Alexays/Waybar)
- rofi collection: [adi1090x](https://github.com/adi1090x/rofi)
- made by [twixxty](https://github.com/twixxty)
- inspiration: i was bored and hated default desktop environments

---

## license

do whatever you want with it. if it breaks something that's still your problem.
