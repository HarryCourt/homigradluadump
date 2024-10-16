-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_machines_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_machine","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Machine"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props/props_crates/wooden_crate_64x64.mdl"
ENT.WorldMaterial = "phoenix_storms/gear"

ENT.Name = "lootbox_machine"
ENT.w = 1
ENT.h = 1

local random = {
    "ent_jack_gmod_ezsentry","ent_jack_gmod_ezbattery","ent_jack_gmod_ezammo","weapon_lvsrepair","ent_jack_gmod_ezbasicparts"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return 1 end
