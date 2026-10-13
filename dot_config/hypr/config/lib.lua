-- Small helpers shared by the other modules (plain Lua, no Hyprland API).
local M = {}

M.home = os.getenv("HOME") or ""

-- Directory this configuration lives in (parent of config/).
do
    local src = debug.getinfo(1, "S").source or ""
    local dir = src:match("^@(.*)/config/lib%.lua$")
    M.root = dir or (M.home .. "/.config/hypr")
end

function M.exists(path)
    local f = io.open(path, "r")
    if f then f:close() return true end
    return false
end

-- True when an executable name is found on PATH (no shell is spawned).
function M.have(cmd)
    local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
    for dir in path:gmatch("[^:]+") do
        if M.exists(dir .. "/" .. cmd) then return true end
    end
    return M.exists(M.home .. "/.local/bin/" .. cmd)
end

return M
