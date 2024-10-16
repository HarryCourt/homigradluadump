-- "addons\\homigrad\\lua\\hinit\\weapons\\halflife\\smg1_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_smg1","wep_ar2")
if not SWEP then return end

SWEP.PrintName 				= "SMG"
SWEP.Instructions           = ""
SWEP.Category = "Оружие: Half-Life"

------------------------------------------

SWEP.Primary.ClipSize		= 24
SWEP.Primary.DefaultClip	= 24
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.03
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 11

SWEP.Primary.Sound = "pwb2/weapons/pl14/shot-unsil.wav"
SWEP.Primary.SoundPitch = 110

SWEP.Primary.SoundFar = "arccw_go/mp7/mp7-1-distant.wav"

SWEP.HoldType = "smg"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/sirgibs/hl2/weapons/smg1.mdl"

SWEP.vbwPos = Vector(2,-4,2)
SWEP.vbwAng = Angle(-0,0,-25)

SWEP.dwsItemPos = Vector(-3,0,-2.5)
SWEP.dwsItemAng = Angle(0,0,0)
SWEP.dwsItemFOV = -9

SWEP.wmVector = Vector(6,2,-1.5)
SWEP.wmAngle = Angle(-1,7,180 + 2.5)

SWEP.MuzzlePos = Vector(0,-0.009,0.2)
SWEP.MuzzleAng = Angle(0,0,-94)
SWEP.CameraPos = Vector(-20,0,2.5)

SWEP.CR_Scope = 1.3

SWEP.Reload1 = "pwb2/weapons/pl14/magin.wav"
SWEP.Reload2 = "pwb2/weapons/pl14/magout.wav"
SWEP.Reload3 = "pwb2/weapons/m4super90/bolt.wav"
SWEP.Reload4 = false

SWEP.BoltBone = false
SWEP.BoltMul = 2
SWEP.BoltMulX = 0

SWEP.ClipBone = false

SWEP.FakeAng = Angle(0,0,180)
SWEP.FakeVec1 = Vector(4,-1,2)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "arccw_go/mp7/mp7_draw.wav"

SWEP.eyeSprayH = 3
SWEP.eyeSprayW = 0.2
SWEP.eyeSpraySinW = 0.2
SWEP.eyeSprayRandW = 0.1

SWEP.eyeSprayLSet = 0.9
SWEP.eyeSprayLReset = 0.85

SWEP.eyeSprayHoldK = 0.25

SWEP.HSVec = Vector(-16.5,0,0.72)
SWEP.HSAng = Angle(0,0,4.3)
SWEP.HSMScale = Vector(0.01,0.75,0.85)
SWEP.HSCameraVec = Vector(0,0,1.06)

SWEP.HSCameraForward = -5

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        gasTimeScale = 2.5,
        gasSideScale = 2.75,
        gasForwardScale = 3
    })
end

SWEP.EjectAng = Angle(80,180,0)