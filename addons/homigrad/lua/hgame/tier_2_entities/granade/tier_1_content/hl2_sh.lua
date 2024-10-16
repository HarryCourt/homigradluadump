-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\hl2_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_hl2","wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "Осколочная Граната"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Оснваная граната комбайнов, имеет очень убойную силу."
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/weapons/w_grenade.mdl"

SWEP.Granade = "ent_gnade_hl2"

SWEP.dwsItemFOV = -12
SWEP.dwsItemPos = Vector(0,0,-5)

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(5,2,2)
SWEP.wmAngle = Angle(0,180,0)