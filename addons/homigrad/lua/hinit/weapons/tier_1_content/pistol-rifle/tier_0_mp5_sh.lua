-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\pistol-rifle\\tier_0_mp5_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_mp5","hg_wep")
if not SWEP then return end

SWEP.PrintName 				= "MP5"
SWEP.Instructions           = "\n12 выстрелов в секунду\n30 Урона\n0.03 Разброс"
SWEP.Category 				= "Оружие: Пистолеты-Пулемёты"

------------------------------------------

SWEP.Primary.ClipSize		= 24
SWEP.Primary.DefaultClip	= 24
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Shell = "EjectBrass_556"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.03
SWEP.Primary.Damage = 30
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 12

SWEP.Primary.Sound = "pwb/weapons/mp7/shoot.wav"
SWEP.Primary.SoundPitch = 125
SWEP.Primary.SoundFar = "weapons/mp5k/mp5k_dist.wav"

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/weapons/arccw_go/v_smg_mp5.mdl"

SWEP.vbwPos = Vector(-16,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-20,5,5.8)
SWEP.dwsItemFOV = -2

SWEP.wmVector = Vector(-13,6.4,-6)
SWEP.wmAngle = Angle(-2,7,180 + 7)

SWEP.MuzzlePos = Vector(0,-0.01,-0.25)
SWEP.MuzzleAng = Angle(0,-0.8,0)
SWEP.CameraPos = Vector(-30,0,2.6)
SWEP.CR_Scope = 3

SWEP.Reload1 = "pwb2/weapons/mp5a3/kry_mp5_magout.wav"
SWEP.Reload2 = "pwb2/weapons/mp5a3/kry_mp5_magin.wav"
SWEP.Reload3 = "pwb2/weapons/mp5a3/kry_mp5_boltpull.wav"
SWEP.Reload4 = "pwb2/weapons/mp5a3/kry_mp5_bolt_slap.wav"

SWEP.BoltBone = "v_weapon.bolt"
SWEP.BoltMul = 0
SWEP.BoltMulX = -4

SWEP.ClipBone = "v_weapon.mag"

SWEP.FakeVec1 = Vector(4,-11,-13)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "arccw_go/mp5/mp5_draw.wav"