-- Environment (ML4W values; Quickshell-specific variables dropped).
local lib = require("config.lib")

-- PATH additions from ML4W
local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
hl.env("PATH", lib.home .. "/.local/bin:" .. lib.home .. "/.cargo/bin:" .. path)

hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("DESKTOP_SESSION", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- Only force qt6ct when it is actually installed.
if lib.have("qt6ct") then
    hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
end

hl.env("GDK_SCALE", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("SDL_VIDEODRIVER", "wayland")

-- Cursor (ML4W: Bibata-Modern-Ice). Theme is only set if it exists.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
local cursor = "Bibata-Modern-Ice"
if lib.exists(lib.home .. "/.local/share/icons/" .. cursor .. "/index.theme")
    or lib.exists("/usr/share/icons/" .. cursor .. "/index.theme") then
    hl.env("XCURSOR_THEME", cursor)
end
