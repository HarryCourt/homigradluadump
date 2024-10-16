-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_1_content\\wep_food_canner_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_canner","wep_food_base")
if not SWEP then return end

SWEP.PrintName = "Консерва"

SWEP.WorldModel = "models/jordfood/can.mdl"

SWEP.wmVector = Vector(3,2,-5)
SWEP.wmAngle = Angle(180,0,0)

SWEP.ParticleColor = Color(75,65,25)

SWEP.HungryAdd = 2

SWEP.dwsItemAng = Angle(3.7,0,0)