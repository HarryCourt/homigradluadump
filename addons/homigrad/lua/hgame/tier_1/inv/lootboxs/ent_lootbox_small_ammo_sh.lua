-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_small_ammo_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_small_ammo","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Small Ammo"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/supply_crate01_static.mdl"
ENT.WorldSkin = 1

ENT.Name = "lootbox_small_ammo"
ENT.w = 3
ENT.h = 1

function ENT:GetRandom() return "" end
function ENT:GetRandomCount() return 0 end
