-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\rifle_tier_0\\val_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_val","wep_ak47")
if not SWEP then return end

SWEP.PrintName 				= "АС Вал"
SWEP.Instructions           = "\n16 выстрелов в секунду\n32 Урона\n0.001 Разброс"
SWEP.Category 				= "Оружие: Винтовки"
SWEP.Author                 =  akurse

------------------------------------------

SWEP.Primary.ClipSize		= 21
SWEP.Primary.DefaultClip	= 21
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo			= "rifle"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.001
SWEP.Primary.Damage = 30
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 14

SWEP.Primary.Sound = {"weapons/fnfal/fnfal_suppressed_fp.wav" , "weapons/fnfal/fnfal_suppressed_tp.wav"}
SWEP.Primary.SoundFar = {"weapons/sterling/sterling_dist.wav"}

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.WorldModel				= "models/pwb2/weapons/w_asval.mdl"

SWEP.vbwPos = Vector(-10,-5,-4)
SWEP.vbwAng = Angle(5,0,0)

SWEP.dwsItemPos = Vector(-7.5,6,-4)

SWEP.dwsItemFOV = 5

SWEP.wmVector = Vector(2,0.4,0.8)
SWEP.wmAngle = Angle(-0,8,180 - 3)

SWEP.MuzzlePos = Vector(5,0,-0.1)
SWEP.MuzzleAng = Angle(-0.2,0,-90)
SWEP.CameraPos = Vector(-34,0.4,2)
SWEP.CR_Scope = 4

SWEP.Reload1 = "arccw_go/m4a1/m4a1_clipout.wav"
SWEP.Reload2 = "pwb2/weapons/m4a1/ru-556 clip in 2.wav"
SWEP.Reload3 = "pwb2/weapons/m4a1/ru-556 bolt back.wav"
SWEP.Reload4 = "pwb2/weapons/m4a1/ru-556 bolt release.wav"

SWEP.BoltBone = "CSEntity [class C_BaseFlex]"
SWEP.BoltMul = 2

SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(10,-2,0)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "arccw_go/m4a1/m4a1_draw.wav"

SWEP.eyeSprayH = 0.3

SWEP.eyeSpraySinAddW = 0.5

SWEP.eyeSprayLSet = 0.7
SWEP.eyeSprayLReset = 0.15