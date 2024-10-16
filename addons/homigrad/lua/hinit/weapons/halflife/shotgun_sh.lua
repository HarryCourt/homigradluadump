-- "addons\\homigrad\\lua\\hinit\\weapons\\halflife\\shotgun_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_stotgun","wep_xm1014")
if not SWEP then return end

SWEP.PrintName 				= "SPAS12"
SWEP.Instructions           = ""
SWEP.Category 				= "Оружие: Half-Life"

------------------------------------------

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
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

SWEP.WorldModel				= "models/sirgibs/hl2/weapons/shotgun.mdl"

SWEP.vbwPos = Vector(-8,-2,-8)
SWEP.vbwAng = Angle(0,0,25)

SWEP.dwsItemPos = Vector(-15,0,0)
SWEP.dwsItemFOV = 0

SWEP.wmVector = Vector(0,1,1)
SWEP.wmAngle = Angle(-4,8,180)

SWEP.MuzzlePos = Vector(0,-0.04,0)
SWEP.MuzzleAng = Angle(0,0,-90)

SWEP.CameraPos = Vector(-35,0,1.2)
SWEP.CR_Scope = 2

SWEP.Reload1 = "weapons/shotgun/shotgun_cock_back.wav"
SWEP.Reload2 = {
    "weapons/shotgun/shotgun_reload4.wav",
    "weapons/shotgun/shotgun_reload5.wav",
    "weapons/shotgun/shotgun_reload6.wav"
}

SWEP.FakeAng = Angle(0,0,180)
SWEP.FakeVec1 = Vector(7,-3,0)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "weapons/shotgun/shotgun_cock_forward.wav"

SWEP.CameraFightVec = Vector(0,3,2)

SWEP.ReloadMode = true

SWEP.EjectAng = Angle(90,180,0)

function SWEP:GetCHandUp(value) return math.ease.InSine(value) + math.max(math.ease.InElastic(value) - 0.3,0) end

SWEP.CHandUp = 15
SWEP.CHandHoldUp = 0.5

SWEP.CHandRight = -7
SWEP.CHandHoldRight = 0.25