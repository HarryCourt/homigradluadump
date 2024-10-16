-- "addons\\homigrad\\lua\\hinit\\weapons\\halflife\\melee_crowbar_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_crowbar_halflife","melee_metalbat")
if not SWEP then return end

SWEP.PrintName = "Монтировка"
SWEP.Instructions = ""
SWEP.Category = "Оружие: Half-Life"

SWEP.WorldModel = "models/sirgibs/hl2/weapons/crowbar.mdl"

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(3.5,3,0)
SWEP.wmAngle = Angle(70,0,180)

SWEP.Primary.Damage = 27
SWEP.DamagePain = 35

SWEP.dwsItemPos = Vector(0,3,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = -3

SWEP.HoldType = "melee"