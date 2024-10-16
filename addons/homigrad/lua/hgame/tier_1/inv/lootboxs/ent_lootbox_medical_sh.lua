-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_medical_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_medical","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Medical"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/kali/props/cases/hard case b.mdl"
ENT.WorldMaterial = "phoenix_storms/gear"

ENT.Name = "lootbox_medical"
ENT.w = 2
ENT.h = 1

local random = {
    "med_painkiller","med_kit","med_needle","med_band"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return math.random(1,2) end