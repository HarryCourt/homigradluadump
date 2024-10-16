-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_1_content\\wep_food_cannerburger_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_cannerburger","wep_food_base")
if not SWEP then return end

SWEP.PrintName = "Законсервированый бургер"

SWEP.WorldModel = "models/jordfood/canned_burger.mdl"

SWEP.wmVector = Vector(3,5,-2.5)
SWEP.wmAngle = Angle(180,0,0)

SWEP.HandBack = 20
SWEP.HandRight = 20

SWEP.ParticleColor = Color(75,65,25)

SWEP.HungryAdd = 4

SWEP.dwsItemPos = Vector(0,0,-1.3)
SWEP.dwsItemAng = Angle(0,45,-45)
SWEP.dwsItemFOV = -13