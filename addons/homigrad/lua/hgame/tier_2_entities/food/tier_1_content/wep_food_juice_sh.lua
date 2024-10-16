-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_1_content\\wep_food_juice_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_juice","wep_food_base")
if not SWEP then return end

SWEP.PrintName = "Сок"

SWEP.WorldModel = "models/foodnhouseholditems/juice.mdl"

SWEP.wmVector = Vector(3,4,-6)
SWEP.wmAngle = Angle(0,180,0)

SWEP.HandBack = 20
SWEP.HandRight = 20

SWEP.ParticleColor = Color(255,125,75)
SWEP.SndEet = SndEatWater

SWEP.HungryAdd = 0.75

SWEP.dwsItemPos = Vector(0,0,3.6)
SWEP.dwsItemAng = Angle(0,90,0)
SWEP.dwsItemFOV = -9