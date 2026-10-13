-- Window, layer and workspace rules.
-- Generic floating dialogs come from ML4W's rule set; Noctalia rules come from
-- Noctalia's Hyprland documentation.

local function float_center(name, match, size)
    hl.window_rule({
        name   = name,
        match  = match,
        float  = true,
        center = true,
        size   = size,
    })
end

float_center("pavucontrol",       { class = ".*org.pulseaudio.pavucontrol.*" }, "700 600")
float_center("blueman-manager",   { class = "blueman-manager" },                "800 600")
float_center("nm-connection-editor", { class = "nm-connection-editor" },        "800 700")
float_center("gnome-calculator",  { class = "org.gnome.Calculator" },           "700 600")
float_center("nwg-look",          { class = "nwg-look" },                       "700 600")
float_center("nwg-displays",      { class = "nwg-displays" },                   "900 600")
float_center("missioncenter",     { class = "io.missioncenter.MissionCenter" }, "900 600")

hl.window_rule({
    name   = "hyprland-share-picker",
    match  = { class = "hyprland-share-picker" },
    float  = true,
    pin    = true,
    center = true,
    size   = "600 400",
})

hl.window_rule({
    name   = "xdg-desktop-portal-gtk",
    match  = { class = "xdg-desktop-portal-gtk" },
    float  = true,
    size   = "800 600",
})

hl.window_rule({
    name  = "picture-in-picture",
    match = { title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]] },
    float = true,
    pin   = true,
    focus_on_activate = false,
    no_initial_focus  = true,
    suppress_event    = "activate",
})

-- Ignore maximize requests from apps (from Hyprland's example config).
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Noctalia settings window (documented by Noctalia).
hl.window_rule({
    name  = "noctalia-settings",
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size  = "1080 920",
})

-- Blur and no Hyprland layer animation for Noctalia surfaces (documented by Noctalia).
hl.layer_rule({
    name  = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    no_anim      = true,
    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

-- Persistent workspaces 1-5 so Noctalia's workspace indicator always shows them.
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
