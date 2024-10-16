-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\buckshot\\pol870_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_pol870","wep_xm1014")
if not SWEP then return end

SWEP.PrintName 				= "Police Remington 870"
SWEP.Instructions           = "\n11 выстрелов в секунду\n125 Урона\n0.05 Разброс"
SWEP.Category 				= "Оружие: Дробовики"

------------------------------------------

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic		= false
SWEP.ChamberAuto = false
SWEP.Tracer = "none"

SWEP.Primary.Ammo			= "buckshot"

SWEP.NumBullet = 4

SWEP.Primary.Cone = 0.05
SWEP.Primary.Spread = 0
SWEP.Primary.Damage = 30
SWEP.Primary.DamageDisK = {
    {300,1},
    {750,0.5},
    {1900,0}
}

SWEP.Primary.Tracer = 0
SWEP.Primary.NoBlood = true

SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 11

SWEP.Primary.Sound = "arccw_go/mosin_suppressed_fp.wav"
SWEP.Primary.SoundFar = "arccw_go/m590_suppressed_fp.wav"

SWEP.WorldModel				= "models/pwb2/weapons/w_remington870police.mdl"

SWEP.vbwPos = Vector(-14,-3,-2)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-11.5,0,-3.5)
SWEP.dwsItemFOV = 11

SWEP.wmVector = Vector(2,1.4,0.8)
SWEP.wmAngle = Angle(-5,9,180 - 3)

SWEP.MuzzlePos = Vector(2,0,-0.1)
SWEP.MuzzleAng = Angle(-0.2,0,-90)
SWEP.CameraPos = Vector(-40,0.6,1.93)

SWEP.CR_Scope = 2

SWEP.Reload1 = "pwb2/weapons/ksg/pumpback.wav"
SWEP.Reload2 = {
    "arccw_go/sawedoff/sawedoff_insertshell_01.wav",
    "arccw_go/sawedoff/sawedoff_insertshell_02.wav",
    "arccw_go/sawedoff/sawedoff_insertshell_03.wav"
}

SWEP.FakeVec1 = Vector(5,-1.5,4)
SWEP.FakeVec2 = Vector(8,-4,0)

SWEP.DeploySound = "pwb2/weapons/ksg/pumpforward.wav"

SWEP.ClipBone = false
SWEP.BoltBone = false

SWEP.CameraFightVec = Vector(0,3,2)

SWEP.ReloadMode = true

SWEP.CHandUp = 1
SWEP.CHandHoldUp = 0.5

SWEP.MoveMul = 1
SWEP.eyeSprayH = 6

function SWEP:GetCHandUp(value) return math.ease.InCubic(value) end

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        flashScale = 0,
        gasTimeScale = 2.5,
        gasSideScale = 2.75,
        gasForwardScale = 3
    })
end

function SWEP:dmgTabPost(target,dmgTab)
    if target.pain then target.pain = target.pain + dmgTab.dmg / 3 * (target.armorMul or 1) end
    if target.impulse then target.impulse = target.impulse + dmgTab.dmg / 10 * (target.armorMul or 1) end
end