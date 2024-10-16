-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_weapons_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_weapons","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Weapons"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/static_crate_64.mdl"

ENT.Name = "lootbox_weapons"
ENT.w = 1
ENT.h = 1

local random = {
    "wep_bizon","wep_mp5","wep_ump",
    "wep_870","wep_mag7","wep_xm1014",

    "ent_jack_gmod_ezammo"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return 1 end