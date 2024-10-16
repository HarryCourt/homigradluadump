-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_high_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_high","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox High"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/kali/props/cases/rifle case b.mdl"

ENT.Name = "lootbox_high"
ENT.w = 1
ENT.h = 1

local random = {
    "wep_m4a1","wep_ak47","wep_scar"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return 1 end