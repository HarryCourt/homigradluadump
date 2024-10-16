-- "addons\\homigrad\\lua\\hinit\\weapons\\halflife\\pistol_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_pistol","wep_glock")
if not SWEP then return end

SWEP.PrintName 				= "USP"
SWEP.Instructions           = ""
SWEP.Category 				= "Оружие: Half-Life"

------------------------------------------

SWEP.Primary.ClipSize		= 18
SWEP.Primary.DefaultClip	= 18

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.01
SWEP.Primary.Damage = 33
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 7

SWEP.Primary.Sound = {"weapons/pistol/player_pistol_fire1.wav","weapons/pistol/player_pistol_fire2.wav","weapons/pistol/player_pistol_fire3.wav"}
SWEP.Primary.SoundFar = "arccw_go/glock18/glock18-1-distant.wav"

SWEP.WorldModel				= "models/sirgibs/hl2/weapons/9mmpistol.mdl"

SWEP.vbwPos = Vector(-7.5,2,-1.5)
SWEP.vbwAng = Angle(-90,0,0)

SWEP.dwsItemPos = Vector(-3.2,0,-2)
SWEP.dwsItemFOV = -13.5

SWEP.wmVector = Vector(3,2.1,0)
SWEP.wmAngle = Angle(-5,2.4,180 + 3)

SWEP.MuzzlePos = Vector(0,-0.02,0)
SWEP.MuzzleAng = Angle(0,0,-90)
SWEP.CameraPos = Vector(-25,0,0.75)
SWEP.CR_Scope = 4

SWEP.Reload1 = "weapons/pistol/pistol_clipout.wav"
SWEP.Reload2 = "weapons/pistol/pistol_clipin.wav"
SWEP.Reload3 = "weapons/pistol/pistol_slidepull.wav"
SWEP.Reload4 = "weapons/pistol/pistol_sliderelease.wav"

SWEP.BoltBone = "SlideCharger"
SWEP.BoltMul = 1.25
SWEP.BoltMulY = 0
SWEP.BoltEmpty = true

SWEP.ClipBone = "Clipazine"

SWEP.FakeVec1 = Vector(4,-1.5,1)

SWEP.DeploySound = "weapons/pistol/pistol_deploy.wav"

SWEP.CFightVec = Vector(2,4,-1)

SWEP.CHandUp = 5
SWEP.CHandHoldUp = 1 / 6

SWEP.eyeSprayH = 2
SWEP.eyeSprayLSet = 0.9
SWEP.eyeSprayLReset = 0.7
