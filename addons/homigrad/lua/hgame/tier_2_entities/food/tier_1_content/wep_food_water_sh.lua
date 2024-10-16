-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_1_content\\wep_food_water_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_water","wep_food_base")
if not SWEP then return end

SWEP.PrintName = "Вода"

SWEP.WorldModel = "models/jorddrink/the_bottle_of_water.mdl"

SWEP.wmVector = Vector(3,2,-1)
SWEP.wmAngle = Angle(0,0,180)

SWEP.ParticleColor = Color(255,255,255)
SWEP.SndEet = SndEatWater

SWEP.HungryAdd = 0.25

SWEP.dwsItemPos = Vector(0,0,-0.2)
SWEP.dwsItemAng = Angle(0,90,0)
SWEP.dwsItemFOV = -12