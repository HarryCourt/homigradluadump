-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\pistol-rifle\\ump_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_ump","wep_mp5")
if not SWEP then return end

SWEP.PrintName 				= "UMP"
SWEP.Instructions           = "\n8 выстрелов в секунду\n35 Урона\n0.015 Разброс"

------------------------------------------

SWEP.Primary.ClipSize		= 18
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.015
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 9

SWEP.Primary.Sound = {"pwb2/weapons/p90/shot1.wav","pwb2/weapons/p90/shot2.wav","pwb2/weapons/p90/shot3.wav"}
SWEP.Primary.SoundFar = "arccw_go/ump45/ump45-1-distant.wav"

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/weapons/arccw_go/v_smg_ump45.mdl"

SWEP.vbwPos = Vector(-16,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-19.5,5,5.4)
SWEP.dwsItemFOV = -4

SWEP.wmVector = Vector(-16,6,-4.8)
SWEP.wmAngle = Angle(-1,7,180)

SWEP.MuzzlePos = Vector(2.2,-0.1,0.2)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.CameraPos = Vector(-25,0,2.6)
SWEP.CR_Scope = 4

SWEP.Reload1 = "weapons/ump45/handling/ump45_magout.wav"
SWEP.Reload2 = "weapons/ump45/handling/ump45_magin.wav"
SWEP.Reload3 = "weapons/ump45/handling/ump45_boltback.wav"
SWEP.Reload4 = "weapons/ump45/handling/ump45_boltrelease.wav"

SWEP.BoltBone = "v_weapon.ump45_Release"
SWEP.BoltMul = 2
SWEP.BoltMulX = 0

SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(4,-11,-13)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "arccw_go/ump45/ump45_draw.wav"

SWEP.eyeSprayH = 0.85
SWEP.eyeSprayW = 0.1
SWEP.eyeSpraySinW = 0.075

SWEP.eyeSprayHoldK = 0.5
