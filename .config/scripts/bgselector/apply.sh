#!/usr/bin/env bash
selected_path="$1"

if [ -f "$selected_path" ]; then
    awww img "$selected_path" -t fade --transition-duration 1.5 --transition-fps 60 --transition-bezier .4,0,.2,1 &
    ln -sf "$selected_path" "$HOME/.cache/current-wallpaper"

    # Wait for the picker window to exit cleanly
    sleep 0.4
    matugen image "$selected_path" --source-color-index 0 -t scheme-smart
    hypryouctl wallpaper "$selected_path" >/dev/null 2>&1 || true
fi