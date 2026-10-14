-- Keybindings: Omarchy-inspired (verified against basecamp/omarchy
-- default/hypr/bindings/*.lua), actions implemented with Noctalia IPC
-- (`noctalia msg ...`) and verified Hyprland dispatchers.
-- Workspace keys use keycodes (code:10..19) like Omarchy, so they work on any layout.

local lib = require("config.lib")

local mod  = "SUPER"
local root = lib.root

local function bind(keys, desc, action, opts)
    opts = opts or {}
    opts.description = desc
    hl.bind(keys, action, opts)
end

local function run(cmd)   return hl.dsp.exec_cmd(cmd) end
local function noct(cmd)  return hl.dsp.exec_cmd("noctalia msg " .. cmd) end

---------------------------------------------------------------- Applications
bind(mod .. " + RETURN",         "Terminal (Kitty)",             run("kitty"))
bind(mod .. " + SHIFT + B", "Default web browser",          run(root .. "/scripts/browser.sh"))
bind(mod .. " + SHIFT + F", "File manager (Yazi in Kitty)", run(os.getenv("HOME") .. "/.config/scripts/yazi-open.sh"))
bind(mod .. " + SPACE",          "Application launcher (Noctalia)", noct("panel-toggle launcher"))

-- Only bound when the program exists (re-run `hyprctl reload` after installing).
if lib.have("obsidian") then
    bind(mod .. " + SHIFT + O", "Obsidian", run("obsidian"))
end
if lib.have("wofi") then
    bind(mod .. " + ALT + SPACE", "Secondary launcher (wofi)", run("pkill wofi || wofi --show drun"))
end

------------------------------------------------------------ Window management
bind(mod .. " + Q", "Close window", hl.dsp.window.close())
bind(mod .. " + W", "Close window", hl.dsp.window.close())
bind(mod .. " + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mod .. " + ALT + F", "Maximize (full width)", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mod .. " + V", "Clipboard history (Noctalia)", noct("panel-toggle clipboard"))
bind(mod .. " + T", "Toggle floating (Omarchy key)", hl.dsp.window.float({ action = "toggle" }))
bind(mod .. " + J", "Toggle split direction (dwindle)", hl.dsp.layout("togglesplit"))
bind(mod .. " + P", "Pseudo-tile window", hl.dsp.window.pseudo())
bind(mod .. " + I", "Noctalia settings", noct("settings-toggle"))
bind(mod .. " + L", "Lock session (Noctalia)", noct("session lock"))

-- Focus and move (Omarchy swaps windows with Shift+arrows)
bind(mod .. " + LEFT",  "Focus left",  hl.dsp.focus({ direction = "l" }))
bind(mod .. " + RIGHT", "Focus right", hl.dsp.focus({ direction = "r" }))
bind(mod .. " + UP",    "Focus up",    hl.dsp.focus({ direction = "u" }))
bind(mod .. " + DOWN",  "Focus down",  hl.dsp.focus({ direction = "d" }))

bind(mod .. " + SHIFT + LEFT",  "Swap window left",  hl.dsp.window.swap({ direction = "l" }))
bind(mod .. " + SHIFT + RIGHT", "Swap window right", hl.dsp.window.swap({ direction = "r" }))
bind(mod .. " + SHIFT + UP",    "Swap window up",    hl.dsp.window.swap({ direction = "u" }))
bind(mod .. " + SHIFT + DOWN",  "Swap window down",  hl.dsp.window.swap({ direction = "d" }))

-- Workspaces 1-10 (key "0" is workspace 10)
for i = 1, 10 do
    local key = "code:" .. tostring(i + 9)
    bind(mod .. " + " .. key,                 "Switch to workspace " .. i,
         hl.dsp.focus({ workspace = tostring(i) }))
    bind(mod .. " + SHIFT + " .. key,         "Move window to workspace " .. i,
         hl.dsp.window.move({ workspace = tostring(i) }))
    bind(mod .. " + SHIFT + ALT + " .. key,   "Move window silently to workspace " .. i,
         hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end

bind(mod .. " + TAB",         "Next workspace",     hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
bind(mod .. " + CTRL + TAB",  "Former workspace",   hl.dsp.focus({ workspace = "previous" }))
bind(mod .. " + mouse_down",  "Next workspace (scroll)",     hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + mouse_up",    "Previous workspace (scroll)", hl.dsp.focus({ workspace = "e-1" }))

bind("ALT + TAB", "Window switcher (Noctalia)", noct("window-switcher hold"))

-- Grouping (Omarchy)
bind(mod .. " + G",         "Toggle window group",              hl.dsp.group.toggle())
bind(mod .. " + ALT + G",   "Move window out of group",         hl.dsp.window.move({ out_of_group = true }))
bind(mod .. " + CTRL + LEFT",  "Previous window in group",      hl.dsp.group.prev())
bind(mod .. " + CTRL + RIGHT", "Next window in group",          hl.dsp.group.next())

-- Scratchpad (special workspace "scratchpad", as in Omarchy)
bind(mod .. " + S",       "Toggle scratchpad",         hl.dsp.workspace.toggle_special("scratchpad"))
bind(mod .. " + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Resize with the keyboard (Omarchy uses the - and = keys: code:20 / code:21)
bind(mod .. " + code:20",         "Resize window: wider left / narrower", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
bind(mod .. " + code:21",         "Resize window: wider right",           hl.dsp.window.resize({ x = 100,  y = 0, relative = true }), { repeating = true })
bind(mod .. " + SHIFT + code:20", "Resize window: shorter",               hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
bind(mod .. " + SHIFT + code:21", "Resize window: taller",                hl.dsp.window.resize({ x = 0, y = 100,  relative = true }), { repeating = true })

-- Mouse
bind(mod .. " + mouse:272", "Move window with mouse",   hl.dsp.window.drag(),   { mouse = true })
bind(mod .. " + mouse:273", "Resize window with mouse", hl.dsp.window.resize(), { mouse = true })

------------------------------------------------------------- System utilities
bind(mod .. " + CTRL + L",         "Lock session (Noctalia)",      noct("session lock"))
bind(mod .. " + ESCAPE",           "Session menu (Noctalia)",      noct("panel-toggle session"))
bind(mod .. " + CTRL + C",         "Screenshot: select region",    noct("screenshot-region"))
bind("PRINT",                      "Screenshot: select region",    noct("screenshot-region"))
bind("SHIFT + PRINT",              "Screenshot: focused monitor",  noct("screenshot-fullscreen"))
bind(mod .. " + SHIFT + W",        "Random wallpaper (Noctalia)",  noct("wallpaper-random"))
bind(mod .. " + CTRL + W",         "Wallpaper picker (Noctalia)",  noct("panel-toggle wallpaper"))
bind(mod .. " + CTRL + SPACE",     "Control center (Noctalia)",    noct("panel-toggle control-center"))
bind(mod .. " + SHIFT + SPACE",    "Toggle top bar (Noctalia)",    noct("bar-toggle"))
bind(mod .. " + CTRL + V",         "Clipboard history (Noctalia)", noct("panel-toggle clipboard"))
bind(mod .. " + comma",            "Noctalia settings",            noct("settings-toggle"))
bind(mod .. " + SHIFT + comma",    "Dismiss all notifications",    noct("notification-clear-active"))
bind(mod .. " + CTRL + comma",     "Toggle Do Not Disturb",        noct("notification-dnd-toggle"))
bind(mod .. " + SHIFT + R",        "Reload Hyprland config",       run("hyprctl reload"))

-------------------------------------------------------------------- Media keys
bind("XF86AudioRaiseVolume",  "Volume up",   noct("volume-up"),   { locked = true, repeating = true })
bind("XF86AudioLowerVolume",  "Volume down", noct("volume-down"), { locked = true, repeating = true })
bind("XF86AudioMute",         "Mute",        noct("volume-mute"), { locked = true })
bind("XF86AudioMicMute",      "Mute microphone", run("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
bind("XF86MonBrightnessUp",   "Brightness up",   noct("brightness-up"),   { locked = true, repeating = true })
bind("XF86MonBrightnessDown", "Brightness down", noct("brightness-down"), { locked = true, repeating = true })
bind("XF86AudioNext",  "Next track",     noct("media next"),   { locked = true })
bind("XF86AudioPrev",  "Previous track", noct("media previous"), { locked = true })
bind("XF86AudioPlay",  "Play/pause",     noct("media toggle"), { locked = true })
bind("XF86AudioPause", "Play/pause",     noct("media toggle"), { locked = true })
