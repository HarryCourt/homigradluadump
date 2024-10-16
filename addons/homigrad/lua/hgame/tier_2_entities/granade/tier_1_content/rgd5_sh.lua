-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\rgd5_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_rgd5","wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "RGD-5"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Наступательная ручная граната, относится к противопехотным осколочным ручным гранатам дистанционного действия наступательного типа."
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/pwb/weapons/w_rgd5.mdl"

SWEP.Granade = "ent_gnade_rgd5"

SWEP.dwsItemPos = Vector(9.2,0,-5)
SWEP.dwsItemAng = Angle(32,0,0)
SWEP.dwsItemFOV = -15