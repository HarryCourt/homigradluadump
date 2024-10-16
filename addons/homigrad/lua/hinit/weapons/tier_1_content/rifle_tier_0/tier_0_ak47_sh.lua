-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\rifle_tier_0\\tier_0_ak47_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_ak47","hg_wep")
if not SWEP then return end

SWEP.PrintName 				= "AK-47"
SWEP.Instructions           = "\n10 выстрелов в секунду\n45 Урона\n0.0025 Разброс"
SWEP.Category 				= "Оружие: Винтовки"

------------------------------------------

SWEP.CR3 = 4
SWEP.CHandHoldUp = 0.1
SWEP.CHandUp = 0.01

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "rifle"
SWEP.Primary.AmmoDWR        = "ar2"
SWEP.Shell = "EjectBrass_556"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.0025
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 10

SWEP.Primary.Sound = "pwb/weapons/rpk/shoot.wav"
SWEP.Primary.SoundPitch = 95
SWEP.Primary.SoundFar = "arccw_go/ak47/ak47_distant.wav"

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/weapons/arccw_go/v_rif_ak47.mdl"

SWEP.vbwPos = Vector(-10,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-20,5,5)

SWEP.wmVector = Vector(-9,6,-5)
SWEP.wmAngle = Angle(-1,8,180 - 3)

SWEP.MuzzlePos = Vector(0,0.04,0)
SWEP.MuzzleAng = Angle(0,0.6,0)
SWEP.CameraPos = Vector(-25,0,2.3)
SWEP.CR_Scope = 4

SWEP.Reload1 = "pwb/weapons/akm/clipout.wav"
SWEP.Reload2 = "pwb/weapons/akm/clipin.wav"
SWEP.Reload3 = "pwb/weapons/akm/boltpull.wav"
SWEP.Reload4 = false

SWEP.BoltBone = "v_weapon.AK47_bolt"
SWEP.BoltMul = 5.5

SWEP.ClipBone = "v_weapon.AK47_clip"

SWEP.FakeVec1 = Vector(7,-13,-8)
SWEP.FakeVec2 = Vector(8,-4,0)

SWEP.DeploySound = "arccw_go/ak47/ak47_draw.wav"

SWEP.MoveMulEquip = 0.95