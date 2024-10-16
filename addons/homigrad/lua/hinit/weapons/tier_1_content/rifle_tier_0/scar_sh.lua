-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\rifle_tier_0\\scar_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_scar","wep_ak47")
if not SWEP then return end

SWEP.PrintName 				= "SCAR"
SWEP.Instructions           = "\n7 выстрелов в секунду\n52 Урона\n0.0005 Разброс"
SWEP.Category 				= "Оружие: Винтовки"

------------------------------------------

SWEP.CHandUp = 0.2
SWEP.CHandHoldUp = 0.15

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "rifle"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.0005
SWEP.Primary.Damage = 52
SWEP.Primary.DamageDisK = {
    {8000,1},
    {16000,0.75}
}

SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 7

SWEP.Primary.Sound = {"pwb/weapons/hk416/shoot.wav"}
SWEP.Primary.SoundFar = {"arccw_go/scar20/scar20_distant_01.wav","arccw_go/scar20/scar20_distant_02.wav","arccw_go/scar20/scar20_distant_03.wav"}

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/weapons/arccw_go/v_rif_scar.mdl"

SWEP.vbwPos = Vector(-10,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-20,6,5)

SWEP.wmVector = Vector(-13,7.3,-7)
SWEP.wmAngle = Angle(-3.3,5,180 - 2)

SWEP.MuzzlePos = Vector(0,-0.03,0)
SWEP.MuzzleAng = Angle(0,0,0)
SWEP.CameraPos = Vector(-35,0,4)
SWEP.CR_Scope = 2.5

SWEP.Reload1 = "pwb/weapons/hk416/clipout.wav"
SWEP.Reload2 = "pwb/weapons/hk416/clipin.wav"
SWEP.Reload3 = "pwb/weapons/hk416/boltpull.wav"
SWEP.Reload4 = false--;c;c;

SWEP.BoltBone = "v_weapon.SCAR_Bolt"
SWEP.BoltMul = 2

SWEP.ClipBone = "v_weapon.SCAR_Clip"

SWEP.FakeVec1 = Vector(7,-13,-12)
SWEP.FakeVec2 = Vector(8,-4,0)

SWEP.DeploySound = "arccw_go/scar20/scar20_draw.wav"

SWEP.eyeSprayH = 3
SWEP.eyeSpraySinW = 0.5

SWEP.eyeSprayLSet = 0.9
SWEP.eyeSprayLReset = 0.75

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        flashScale = 2,
        gasSideScale = 4,
        gasForwardScale = 3
    })
end

SWEP.MoveMul = 0.9