-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_1_content\\wep_food_cannerfish_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_cannerfish","wep_food_base")
if not SWEP then return end

SWEP.PrintName = "Шпроты"

SWEP.WorldModel = "models/jordfood/atun.mdl"

SWEP.wmVector = Vector(4,1,-1)
SWEP.wmAngle = Angle(0,0,90)

SWEP.ParticleColor = Color(75,65,25)

SWEP.HungryAdd = 1

SWEP.dwsItemPos = Vector(0,0,-0.8)
SWEP.dwsItemAng = Angle(0,0,-25)
SWEP.dwsItemFOV = -17