-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_explosive_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_explosive","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Explosive"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/static_crate_64.mdl"
ENT.WorldSkin = 1

ENT.Name = "lootbox_explosive"
ENT.w = 1
ENT.h = 1

local random = {
    "ent_jack_gmod_eztimebomb","ent_jack_gmod_ezsatchelcharge","ent_jack_gmod_ezdetpack",
    
    "ent_jack_gmod_ezminimore","ent_jack_gmod_ezwarmine","ent_jack_gmod_ezatmine"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return 1 end