#!/usr/bin/env bash
# fedora-update-notify.sh
# Checks for Fedora updates, shows a desktop notification, and on click opens
# kitty with the update command already typed (press Enter to run it).

set -u

UPDATE_CMD="sudo dnf upgrade --refresh"
LOCK="${XDG_RUNTIME_DIR:-/tmp}/fedora-update-notify.lock"

# Only one instance at a time (the notification waits for a click).
exec 9>"$LOCK"
flock -n 9 || exit 0

# Exit codes for `dnf check-update`: 0 = none, 100 = updates available, 1 = error.
output=$(dnf check-update --refresh --quiet 2>/dev/null)
status=$?

if [ "$status" -ne 100 ]; then
    exit 0
fi

# Count package lines (name.arch  version  repo)
count=$(printf '%s\n' "$output" | grep -cE '^[^[:space:]]+\.[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+$')
[ "$count" -gt 0 ] || count="Some"

open_terminal() {
    local sock="unix:@kitty-update-$$"
    kitty --title "Fedora Update" \
          -o allow_remote_control=socket-only \
          --listen-on "$sock" &
    # Wait for kitty to start listening, then type the command (without Enter).
    for _ in $(seq 1 50); do
        if kitty @ --to "$sock" send-text "$UPDATE_CMD" 2>/dev/null; then
            return 0
        fi
        sleep 0.1
    done
}

# --wait makes notify-send block and print the action name when clicked.
action=$(notify-send \
    --app-name="Fedora Updates" \
    --icon=system-software-update \
    --urgency=normal \
    --action="default=Open terminal" \
    --wait \
    "Updates available" \
    "$count package updates are ready. Click to open a terminal.")

if [ "$action" = "default" ]; then
    open_terminal
fi
