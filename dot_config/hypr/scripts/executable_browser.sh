#!/bin/sh
# Open the default web browser (as set by xdg-settings), without a URL.
desktop="$(xdg-settings get default-web-browser 2>/dev/null)"

if [ -n "$desktop" ]; then
    if command -v gtk-launch >/dev/null 2>&1; then
        exec gtk-launch "$desktop"
    fi
    for dir in "${XDG_DATA_HOME:-$HOME/.local/share}/applications" /usr/local/share/applications /usr/share/applications; do
        if [ -f "$dir/$desktop" ] && command -v gio >/dev/null 2>&1; then
            exec gio launch "$dir/$desktop"
        fi
    done
fi

exec xdg-open "https://"
