#!/bin/sh
# Read-only checks. Changes nothing, restarts nothing.
ok()   { printf '  [ok]   %s\n' "$1"; }
warn() { printf '  [warn] %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; FAIL=1; }
FAIL=0

echo "Hyprland"
if command -v hyprland >/dev/null 2>&1; then
    v="$(hyprland --version 2>/dev/null | sed -n 's/^Hyprland \([0-9.]*\).*/\1/p')"
    case "$v" in 0.56.*) ok "Hyprland $v (config targets 0.56.x)";; *) warn "Hyprland ${v:-unknown}: config targets 0.56.x";; esac
else bad "hyprland not found"; fi

echo "Display manager / session"
if [ "$(systemctl is-enabled sddm 2>/dev/null)" = enabled ]; then ok "sddm enabled"; else bad "sddm not enabled"; fi
for f in /usr/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions/hyprland-uwsm.desktop; do
    [ -f "$f" ] && ok "session entry: $f" || warn "missing session entry: $f"
done

echo "Programs used by the config"
for c in noctalia kitty yazi xdg-settings xdg-open pactl; do
    command -v "$c" >/dev/null 2>&1 && ok "$c" || bad "$c missing"
done
for c in wofi obsidian; do
    command -v "$c" >/dev/null 2>&1 && ok "$c (optional binding enabled)" || warn "$c not installed: its binding is skipped"
done
b="$(xdg-settings get default-web-browser 2>/dev/null)"
[ -n "$b" ] && ok "default browser: $b" || warn "no default browser set (Super+Shift+Return falls back to xdg-open)"

echo "Possible duplicates of what Noctalia provides (must not run together)"
for p in waybar swaync mako dunst hypridle hyprpaper hyprlock swww awww-daemon quickshell qs; do
    pgrep -x "$p" >/dev/null 2>&1 && warn "$p is running" || true
done
n="$(pgrep -cx noctalia 2>/dev/null || echo 0)"
[ "$n" -le 1 ] && ok "noctalia instances: $n" || bad "noctalia instances: $n"

[ "$FAIL" = 0 ] && echo "Preflight passed." || { echo "Preflight found problems."; exit 1; }
