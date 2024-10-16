-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\pistol\\pnev_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_pnev","wep_glock")
if not SWEP then return end

SWEP.PrintName 				= "Пневматический пистолет"
SWEP.Instructions           = "\n14 выстрелов в секунду\n5 Урона\n0.0075 Разброс"
SWEP.Author = akurse

------------------------------------------

SWEP.Primary.ClipSize		= 9
SWEP.Primary.DefaultClip	= 9
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Tracer = "none"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.075
SWEP.Primary.Damage = 25
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 10
SWEP.Primary.Tracer = 0
SWEP.Primary.NoBlood = true

SWEP.Primary.Sound = "arccw_go/mosin_suppressed_fp.wav"
SWEP.Primary.SoundFar = "weapons/mini14/mini14_dist.wav"

SWEP.WorldModel				= "models/weapons/insurgency/w_makarov.mdl"

SWEP.vbwPos = Vector(-8,2,-3)
SWEP.vbwAng = Angle(-90,0,0)

SWEP.dwsItemPos = Vector(-1,4,-4.2)

SWEP.wmVector = Vector(4,2.5,3.2)
SWEP.wmAngle = Angle(-5,3,180 + 7)

SWEP.dwsItemFOV = -13.5

SWEP.MuzzlePos = Vector(3,-0.02,-0.15)
SWEP.MuzzleAng = Angle(-0.5,0.1,270)

SWEP.CameraPos = Vector(-18,-0.3,1)
SWEP.CR_Scope = 3

SWEP.Reload1 = "arccw_go/fiveseven/fiveseven_clipout.wav"
SWEP.Reload2 = "arccw_go/fiveseven/fiveseven_clipin.wav"
SWEP.Reload3 = "arccw_go/fiveseven/fiveseven_slideback.wav"
SWEP.Reload4 = "arccw_go/fiveseven/fiveseven_sliderelease.wav"

SWEP.BoltBone = "CSEntity [class C_BaseFlex]"
SWEP.BoltMul = 2

SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(6, -2,4)

SWEP.DeploySound = "arccw_go/fiveseven/fiveseven_draw.wav"

SWEP.eyeSprayH = 0.4
SWEP.eyeSprayLerp = 0

SWEP.CHandUp = 0
SWEP.CHandHoldUp = 0.05
SWEP.CHandRight = 0.2
SWEP.CHandHoldRight = 2

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        flashScale = 0,
        gasTimeScale = 1,
        gasSideScale = 1,
        gasForwardScale = 1
    })
end

SWEP.Shell = false

function SWEP:dmgTabPost(target,dmgTab)
    if target.pain then target.pain = target.pain + dmgTab.dmg / 4 * (target.armorMul or 1) end
    if target.impulse then target.impulse = target.impulse + dmgTab.dmg / 20 * (target.armorMul or 1) end
end