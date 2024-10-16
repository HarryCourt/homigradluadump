-- "addons\\homigrad\\lua\\hinit\\weapons\\bt\\hg_second_rifle_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_bt_second_rifle","wep_m14")
if not SWEP then return end

SWEP.PrintName 				= "BT Second Rifle"
SWEP.Instructions           = "\n10 выстрелов в секунду\n45 Урона\n0.0025 Разброс"
SWEP.Category 				= "Оружие: BT"

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "rifle"
SWEP.Primary.AmmoDWR        = "ar2"
SWEP.Shell = "EjectBrass_556"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.0025
SWEP.Primary.Damage = 45
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 10

SWEP.Primary.Sound = "homigrad/bt_shotgun.wav"
SWEP.Primary.SoundFar = "arccw_go/ak47/ak47_distant.wav"

SWEP.ZoomInSound = "arccw_go/sg556/sg556_zoom_in.wav"
SWEP.ZoomOutSound = "arccw_go/sg556/sg556_zoom_out.wav"

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/homigrad/bt/secondrifle.mdl"

SWEP.vbwPos = Vector(-10,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-6,0,-3)
SWEP.dwsItemFOV = 5

SWEP.wmVector = Vector(2,2,1)
SWEP.wmAngle = Angle(-5,9,180)

SWEP.MuzzlePos = Vector(27,0,4.3)
SWEP.CameraPos = Vector(-25,0,2.3)
SWEP.CR_Scope = 1

SWEP.Reload1 = "arccw_go/sg556/sg556_clipout.wav"
SWEP.Reload2 = "arccw_go/sg556/sg556_clipin.wav"
SWEP.Reload3 = "arccw_go/sg556/sg556_boltback.wav"
SWEP.Reload4 = "arccw_go/sg556/sg556_boltforward.wav"

SWEP.BoltBone = false
SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(7,-13,-8)
SWEP.FakeVec2 = Vector(8,-4,0)

SWEP.DeploySound = "arccw_go/sg556/sg556_draw.wav"

SWEP.HSM = "models/weapons/arccw_go/atts/awp.mdl"
SWEP.HSMScale = Vector(0.5,1,1)

SWEP.HSP = "models/weapons/arccw_go/atts/awp_hsp.mdl"
SWEP.HSPScale = SWEP.HSMScale

SWEP.HSMat = Material("hud/scopes/ssr_go.png","mips smooth")

SWEP.HSSize = 20
SWEP.HSBone = "holosight"
SWEP.HSMagnification = 2

SWEP.HSVec = Vector(-20,0,1.1)
SWEP.HSAng = Angle()

SWEP.HSCameraVec = Vector(11,0,1.58597)
SWEP.HSCameraForward = -6
SWEP.HSZoom = 1

SWEP.HSDiffMul = 1