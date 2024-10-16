-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_medium_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_medium","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Meduim"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/kali/props/cases/hard case c.mdl"

ENT.Name = "lootbox_medium"
ENT.w = 2
ENT.h = 1

local random = {
    "melee_metalbat","melee_sleagehammer",
    "wep_fiveseven","wep_r8","wep_glock",

    "ent_jack_gmod_ezarmor_balmask"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return math.random(1,2) end