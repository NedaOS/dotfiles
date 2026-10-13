#!/bin/sh
# Restore the most recent (or given) backup made by activate.sh.
# Usage: rollback.sh [~/.config/hypr.backup-STAMP]
set -eu
DST="$HOME/.config/hypr"
BK="${1:-$(ls -d "$HOME"/.config/hypr.backup-* 2>/dev/null | sort | tail -n 1)}"
[ -n "$BK" ] && [ -d "$BK" ] || { echo "No backup found."; exit 1; }
echo "Restoring from $BK"
# Copy the old files back, its hyprland.lua last. Files of the new setup that
# are not part of the backup stay on disk but are no longer loaded.
for f in "$BK"/*; do
    [ "$(basename "$f")" = hyprland.lua ] && continue
    cp -a "$f" "$DST/"
done
[ -f "$BK/hyprland.lua" ] && cp -a "$BK/hyprland.lua" "$DST/hyprland.lua"
echo "Restored. Check: hyprctl configerrors"
