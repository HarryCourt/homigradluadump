-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\ammo_base\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ammo_base",{"base_entity","item_resource"},true)
if not ENT then return INCLUDE_BREAK end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "hg_ammo_base"
ENT.Category = "Патроны"

ENT.Spawnable = true

ENT.OverridePaintIcon = OverridePaintIcon

ENT.itemType = "ammo"

ENT.InvMoveSnd = InvMoveSndAmmo
ENT.SndPickup = "snd_jack_hmcd_ammobox.wav"
