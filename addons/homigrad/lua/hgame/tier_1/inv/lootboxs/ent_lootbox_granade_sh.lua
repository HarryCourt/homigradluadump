-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_granade_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_granade","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Granade"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/kali/props/cases/hard case b.mdl"

ENT.Name = "lootbox_granade"
ENT.w = 4
ENT.h = 1

local random = {
    "wep_gnade_f1",
    "wep_gnade_rgd5",
    "wep_gnade_f1",
    "wep_gnade_rgd5",
    "wep_gnade_f1",
    "wep_gnade_rgd5",
    "wep_gnade_f1",
    "wep_gnade_rgd5",
    "wep_gnade_molotov"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return math.random(1,4) end