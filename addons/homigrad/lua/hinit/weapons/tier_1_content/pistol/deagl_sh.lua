-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\pistol\\deagl_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_deagl","wep_glock")
if not SWEP then return end

SWEP.PrintName 				= "Desert Eagle"
SWEP.Instructions           = "\n8 выстрелов в секунду\n30 Урона\n0.01 Разброс"
SWEP.Category 				= "Оружие: Пистолеты"
SWEP.Author                 = "akurse"

------------------------------------------

SWEP.ReloadTime = 1.5

SWEP.itemType = "weaponSecondary"

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Shell = "EjectBrass_556"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.01
SWEP.Primary.Damage = 45    
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 5

SWEP.Primary.Sound = {"arccw_go/deagle/deagle-1.wav","arccw_go/deagle/deagle-1.wav"}
SWEP.Primary.SoundFar = "weapons/m40a1/m40a1_dist.wav"

SWEP.HoldType = "revolver"
SWEP.HoldTypeReload = "pistol"

SWEP.WorldModel				= "models/weapons/arccw_go/v_pist_deagle.mdl"

SWEP.vbwPos = Vector(-4,12,2)
SWEP.vbwAng = Angle(-90,0,0)

SWEP.dwsItemPos = Vector(-17.5,4,3)
SWEP.dwsItemFOV = -13

SWEP.wmVector = Vector(-12,6.5,-4.1)
SWEP.wmAngle = Angle(-5,2.4,180 + 5)

SWEP.MuzzlePos = Vector(3,-0.05,0)
SWEP.CameraPos = Vector(-23,0.05,0.75)
SWEP.CR_Scope = 4

SWEP.Reload1 = "arccw_go/deagle/de_clipout.wav"
SWEP.Reload2 = "arccw_go/deagle/de_clipin.wav"
SWEP.Reload3 = "arccw_go/deagle/de_slideback.wav"
SWEP.Reload4 = "arccw_go/deagle/de_slideforward.wav"

SWEP.BoltBone = false
SWEP.BoltMul = 2
SWEP.BoltEmpty = false

SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(5,-9,-10)

SWEP.DeploySound = "arccw_go/glock18/glock_draw.wav"

SWEP.CFightVec = Vector(2,4,-1)

SWEP.CHandUp = 25 -- не трогай отдачу ебать
SWEP.CHandHoldUp = 0.5

SWEP.CHandRight = 5
SWEP.CHandHoldRight = 0.5

SWEP.eyeSprayH = 8
SWEP.eyeSprayLSet = 0.7
SWEP.eyeSprayLReset = 0.3

function SWEP:GetCHandUp(value) return math.ease.InCubic(value) end
function SWEP:GetCHandRight(value) return math.ease.InCubic(value) end

