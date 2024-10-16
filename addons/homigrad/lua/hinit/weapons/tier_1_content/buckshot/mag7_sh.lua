-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\buckshot\\mag7_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_mag7","wep_ak47")
if not SWEP then return end

SWEP.PrintName 				= "M1014"
SWEP.Instructions           = "\n11 выстрелов в секунду\n190 Урона\n0.15 Разброс"
SWEP.Category 				= "Оружие: Дробовики"

------------------------------------------

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.ChamberAuto = false

SWEP.Primary.Ammo			= "buckshot"
SWEP.Shell = "ShotgunShellEject"
SWEP.NumBullet = 16

SWEP.Primary.Cone = 0.05
SWEP.Primary.Spread = 0
SWEP.Primary.Damage = 225
SWEP.Primary.DamageDisK = {
    {250,1},
    {1000,0}
}

SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 11

SWEP.Primary.Sound = "pwb2/weapons/m4super90/xm1014-1.wav"
SWEP.Primary.SoundFar = "arccw_go/mag7/mag7-1-distant.wav"

SWEP.WorldModel				= "models/weapons/arccw_go/v_shot_mag7.mdl"

SWEP.vbwPos = Vector(-20,2,7)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-26.8,5,5.6)
SWEP.dwsItemFOV = -4
SWEP.wmVector = Vector(-17,7.7,-8)
SWEP.wmAngle = Angle(-1,5,180)

SWEP.MuzzlePos = Vector(0,0,0)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.CameraPos = Vector(-30,-0.03,1.6)
SWEP.CR_Scope = 2

SWEP.Reload1 = "arccw_go/mag7/mag7_clipout.wav"
SWEP.Reload2 = "arccw_go/mag7/mag7_clipin.wav"
SWEP.Reload3 = "arccw_go/mag7/mag7_pump_back.wav"
SWEP.Reload4 = "arccw_go/mag7/mag7_pump_forward.wav"

SWEP.FakeVec1 = Vector(7,-15,-15)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "arccw_go/mag7/mag7_draw.wav"

SWEP.CameraFightVec = Vector(0,3,2)

SWEP.ClipBone = "v_weapon.magazine"
SWEP.BoltBone = "v_weapon.pump"

SWEP.CHandUp = 15
SWEP.eyeSprayH = 7

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        flashScale = 3,
        gasSideScale = 4,
        gasForwardScale = 3
    })
end