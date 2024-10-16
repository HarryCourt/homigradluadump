-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\level_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList = LevelList or {}

local empty = {}

function TableRound(name) return _G[name or roundActiveName] or empty end

if roundActiveName == nil then
    roundActiveName = "homicide"
    roundActiveNameNext = "homicide"
end