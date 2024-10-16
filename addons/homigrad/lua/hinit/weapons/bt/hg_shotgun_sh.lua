-- "addons\\homigrad\\lua\\hinit\\weapons\\bt\\hg_shotgun_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_bt_shotgun","wep_xm1014")
if not SWEP then return end

SWEP.PrintName 				= "BT Shotgun Rifle"
SWEP.Instructions           = "\n10 выстрелов в секунду\n45 Урона\n0.0025 Разброс"
SWEP.Category 				= "Оружие: BT"

------------------------------------------

SWEP.Primary.Sound = "homigrad/bt_second_gun.wav"

SWEP.HoldType = "ar2"

SWEP.WorldModel				= "models/homigrad/bt/shotgun.mdl"

SWEP.vbwPos = Vector(-10,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-1,0,-1)
SWEP.dwsItemFOV = 7

SWEP.wmVector = Vector(6,1,-2.8)
SWEP.wmAngle = Angle(-6,8,180)

SWEP.MuzzlePos = Vector(27,0,0)
SWEP.CameraPos = Vector(-35,0,2.9)
SWEP.CR_Scope = 4

SWEP.BoltBone = false
SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(7,-3,-3)
SWEP.FakeVec2 = Vector(8,-4,0)

SWEP.RejectAng = Angle(80,0,0)