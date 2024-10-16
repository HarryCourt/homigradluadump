-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\pistol\\fiveseven_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_fiveseven","wep_glock")
if not SWEP then return end

SWEP.PrintName 				= "FiveSeven"
SWEP.Instructions           = "\n6 выстрелов в секунду\n35 Урона\n0.0075 Разброс"

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.075
SWEP.Primary.Damage = 34
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 8

SWEP.Primary.Sound = "pwb2/weapons/fiveseven/fire.wav"
SWEP.Primary.SoundFar = "arccw_go/fiveseven/fiveseven-1-distant.wav"

SWEP.WorldModel				= "models/weapons/arccw_go/v_pist_fiveseven.mdl"

SWEP.vbwPos = Vector(-5,12,2)
SWEP.vbwAng = Angle(-90,0,0)

SWEP.dwsItemPos = Vector(-18,4,2.6)

SWEP.wmVector = Vector(-13,5.4,-5)
SWEP.wmAngle = Angle(-5,3,180 + 7)

SWEP.MuzzlePos = Vector(2,-0.02,0)
SWEP.CameraPos = Vector(-20,0,0.75)
SWEP.CR_Scope = 4

SWEP.Reload1 = "arccw_go/fiveseven/fiveseven_clipout.wav"
SWEP.Reload2 = "arccw_go/fiveseven/fiveseven_clipin.wav"
SWEP.Reload3 = "arccw_go/fiveseven/fiveseven_slideback.wav"
SWEP.Reload4 = "arccw_go/fiveseven/fiveseven_sliderelease.wav"

SWEP.BoltBone = "v_weapon.fiveSeven_slide"
SWEP.BoltMul = 2

SWEP.ClipBone = "v_weapon.fiveSeven_magazine"

SWEP.FakeVec1 = Vector(4,-8,-11)

SWEP.DeploySound = "arccw_go/fiveseven/fiveseven_draw.wav"

SWEP.eyeSprayH = 4