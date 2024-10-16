-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_medium_high_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_medium_high","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Meduim High"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/kali/props/cases/hard case c.mdl"
ENT.WorldSkin = 1

ENT.Name = "lootbox_medium_high"
ENT.w = 2
ENT.h = 1


function ENT:GetRandom() return "" end
function ENT:GetRandomCount() return 0 end