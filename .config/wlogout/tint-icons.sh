#!/usr/bin/env bash
# Recolors wlogout icons to the current matugen accent color,
# plus a second "hover" set tinted to on_accent.
# Run automatically as a matugen post_hook after colors.css regenerates.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$HOME/.cache/wlogout-icons/tint.log"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
echo "---- $(date) ----"

set -e

COLORS_CSS="$DIR/colors.css"
[ -f "$COLORS_CSS" ] || COLORS_CSS="$HOME/.config/wlogout/colors.css"

# Look for source icons in local icons/src or ~/Pictures/wlogout
if [ -d "$DIR/icons/src" ]; then
    SRC_DIR="$DIR/icons/src"
elif [ -d "$HOME/.config/assets/wlogout" ]; then
    SRC_DIR="$HOME/.config/assets/wlogout"
else
    SRC_DIR="$HOME/Pictures/wlogout"
fi

OUT_DIR="$DIR/icons"
HOVER_DIR="$OUT_DIR/hover"
CACHE_OUT="$HOME/.cache/wlogout-icons"
CACHE_HOVER="$CACHE_OUT/hover"

mkdir -p "$OUT_DIR" "$HOVER_DIR" "$CACHE_OUT" "$CACHE_HOVER"

if [ ! -f "$COLORS_CSS" ]; then
    echo "ERROR: $COLORS_CSS not found"
    exit 1
fi

ACCENT=$(grep '@define-color accent ' "$COLORS_CSS" | sed -E 's/@define-color accent +([^;]+);//')
ON_ACCENT=$(grep '@define-color on_accent ' "$COLORS_CSS" | sed -E 's/@define-color on_accent +([^;]+);//')

if ! command -v magick >/dev/null 2>&1; then
    echo "ERROR: magick not found on PATH"
    exit 1
fi

for name in hibernate lock logout power retsart suspend; do
    src="$SRC_DIR/${name}.png"
    if [ ! -f "$src" ]; then
        echo "SKIP: $src missing"
        continue
    fi
    magick "$src" -fill "$ACCENT" -colorize 100 "$OUT_DIR/${name}.png"
    magick "$src" -fill "$ON_ACCENT" -colorize 100 "$HOVER_DIR/${name}.png"
    cp -f "$OUT_DIR/${name}.png" "$CACHE_OUT/${name}.png" 2>/dev/null || true
    cp -f "$HOVER_DIR/${name}.png" "$CACHE_HOVER/${name}.png" 2>/dev/null || true
    echo "OK: $name.png (+ hover variant)"
done

echo "done"
