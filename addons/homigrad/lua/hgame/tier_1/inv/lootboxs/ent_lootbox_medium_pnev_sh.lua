-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_medium_pnev_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_medium_pnev","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Meduim Pnev"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/kali/props/cases/hard case c.mdl"
ENT.WorldSkin = 2

ENT.Name = "lootbox_medium_pnev"
ENT.w = 2
ENT.h = 1


function ENT:GetRandom() return "" end
function ENT:GetRandomCount() return 0 end