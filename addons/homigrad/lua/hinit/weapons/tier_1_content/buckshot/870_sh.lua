-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\buckshot\\870_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_870","wep_xm1014")
if not SWEP then return end

SWEP.PrintName 				= "Remington 870"
SWEP.Instructions           = "\n11 выстрелов в секунду\n125 Урона\n0.05 Разброс"
SWEP.Category 				= "Оружие: Дробовики"

------------------------------------------

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic		= false
SWEP.ChamberAuto = false

SWEP.Primary.Ammo			= "buckshot"

SWEP.NumBullet = 16

SWEP.Primary.Cone = 0.05
SWEP.Primary.Spread = 0
SWEP.Primary.Damage = 100
SWEP.Primary.DamageDisK = {
    {500,1},
    {1000,0.75},
    {3000,0}
}

SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 11

SWEP.Primary.Sound = {"pwb2/weapons/ksg/shot1.wav","pwb2/weapons/ksg/shot2.wav","pwb2/weapons/ksg/shot3.wav","pwb2/weapons/ksg/shot4.wav"}
SWEP.Primary.SoundFar = "arccw_go/sawedoff/sawedoff-1-distant.wav"

SWEP.WorldModel				= "models/weapons/arccw_go/v_shot_870.mdl"

SWEP.vbwPos = Vector(-16,1,4)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-20.5,5,4)

SWEP.wmVector = Vector(-12,5.5,-4)
SWEP.wmAngle = Angle(-1.5,10,180 + 3)

SWEP.MuzzlePos = Vector(1,-0.04,0)
SWEP.CameraPos = Vector(-25,0,0.8)
SWEP.CR_Scope = 2

SWEP.Reload1 = "pwb2/weapons/ksg/pumpback.wav"
SWEP.Reload2 = {
    "arccw_go/sawedoff/sawedoff_insertshell_01.wav",
    "arccw_go/sawedoff/sawedoff_insertshell_02.wav",
    "arccw_go/sawedoff/sawedoff_insertshell_03.wav"
}



SWEP.FakeVec1 = Vector(12,-10,-8)
SWEP.FakeVec2 = Vector(15,-3,0)

SWEP.DeploySound = "pwb2/weapons/ksg/pumpforward.wav"

SWEP.CameraFightVec = Vector(0,3,2)

SWEP.ReloadMode = true

SWEP.MoveMul = 0.9