-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\pistol-rifle\\mac10_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_mac10","wep_mp5")
if not SWEP then return end

SWEP.PrintName 				= "MAC-10"
SWEP.Instructions           = "\n16 выстрелов в секунду\n16 Урона\n0.0015 Разброс"
SWEP.Category 				= "Оружие: Пистолеты-Пулемёты"

SWEP.Author                 = "akurse"

------------------------------------------

SWEP.ReloadTime = 1.5

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Shell = "EjectBrass_556"


SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.0015
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 19

SWEP.Primary.Sound = "pwb2/weapons/fiveseven/fire.wav"
SWEP.Primary.SoundPitch = 90

SWEP.Primary.SoundFar = "arccw_go/mac10/mac10-1-distant.wav"

SWEP.HoldType = "pistol"
SWEP.HoldTypeReload = "pistol"

SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.WorldModel				= "models/weapons/arccw_go/v_smg_mac10.mdl"

SWEP.vbwPos = Vector(-1.3,14,6)
SWEP.vbwAng = Angle(-90,0,0)

SWEP.dwsItemPos = Vector(-16.5,4,5)
SWEP.dwsItemFOV = -5.5

SWEP.wmVector = Vector(-16.5,7.3,-8.2)
SWEP.wmAngle = Angle(-0,-2.43,180 + 4)

SWEP.MuzzlePos = Vector(5,-0,1.2)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.CameraPos = Vector(-24,0,0.6)
SWEP.CR_Scope = 2.5

SWEP.Reload1 = "arccw_go/mac10/mac10_clipout.wav"
SWEP.Reload2 = "arccw_go/mac10/mac10_clipin.wav"
SWEP.Reload3 = "weapons/galil/handling/galil_boltback.wav"
SWEP.Reload4 = "arccw_go/mac10/mac10_boltback.wav"

SWEP.BoltBone = "v_weapon.mac10_bolt"
SWEP.BoltMul = 2
SWEP.BoltMulX = 0
SWEP.BoltEmpty = true

SWEP.ClipBone = "v_weapon.mac10_clip"

SWEP.FakeVec1 = Vector(5,-13.6,-13)

SWEP.DeploySound = "arccw_go/glock18/glock_draw.wav"

SWEP.CFightVec = Vector(2,4,-1)

SWEP.CHandUp = 0
SWEP.CHandRight = 0

SWEP.eyeSprayH = 9
SWEP.eyeSprayLSet = 1
SWEP.eyeSprayLReset = 1

function SWEP:GetCHandUp(value) return 0 end
function SWEP:GetCHandRight(value) return 0 end

