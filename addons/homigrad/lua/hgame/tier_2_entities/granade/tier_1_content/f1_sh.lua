-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\f1_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_f1","wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "F1"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Ручная граната дистанционного действия, предназначена для поражения живой силы противника в оборонительном бою."
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Granade = "ent_gnade_f1"

SWEP.dwsItemPos = Vector(9.2,0,-5)
SWEP.dwsItemAng = Angle(20,0,0)
SWEP.dwsItemFOV = -15