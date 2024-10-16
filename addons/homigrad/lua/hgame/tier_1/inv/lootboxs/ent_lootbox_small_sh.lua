-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_lootbox_small_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_small","ent_lootbox_low")
if not ENT then return end

ENT.PrintName = "LootBox Small"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/supply_crate01_static.mdl"

ENT.Name = "lootbox_small"
ENT.w = 3
ENT.h = 1

local random = {
    "ent_drop_flashlight","ent_drop_flashlight",
    "med_band","med_band",

    "ent_jack_gmod_ezarmor_fastmtblackslaap","ent_jack_gmod_ezarmor_ulachcoyote","ent_jack_gmod_ezarmor_hjelm","ent_jack_gmod_ezarmor_weldingkill","ent_jack_gmod_ezarmor_deathknight",

    "ent_jack_gmod_ezarmor_hockeybrawler","ent_jack_gmod_ezarmor_faceless",
    
    "weapon_handcuffs","weapon_radio","weapon_per4ik",

    "wep_food_juice","wep_food_water","wep_food_pepsi"
}

function ENT:GetRandom() return random[math.random(1,#random)] end
function ENT:GetRandomCount() return math.random(2,3) end