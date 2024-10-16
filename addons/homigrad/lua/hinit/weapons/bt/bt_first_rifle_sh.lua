-- "addons\\homigrad\\lua\\hinit\\weapons\\bt\\bt_first_rifle_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_bt_first_rifle","wep_m14")
if not SWEP then return end

SWEP.PrintName 				= "BT First Rifle"
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

SWEP.Primary.Sound = "homigrad/bt_first_gun.wav"
SWEP.Primary.SoundFar = "arccw_go/ak47/ak47_distant.wav"

SWEP.HoldType = "smg"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/homigrad/bt/firstrifle.mdl"

SWEP.vbwPos = Vector(-10,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-6,0,-3)
SWEP.dwsItemFOV = 5

SWEP.wmVector = Vector(-2.5,2,1.5)
SWEP.wmAngle = Angle(-5,9,180)

SWEP.MuzzlePos = Vector(27,-0.17,4)
SWEP.CameraPos = Vector(-30,0,2.5)
SWEP.CR_Scope = 2

SWEP.Reload1 = "pwb/weapons/akm/clipout.wav"
SWEP.Reload2 = "pwb/weapons/akm/clipin.wav"
SWEP.Reload3 = "pwb/weapons/akm/boltpull.wav"
SWEP.Reload4 = false

SWEP.BoltBone = false
SWEP.ClipBone = false

SWEP.FakeVec1 = Vector(7,-13,-8)
SWEP.FakeVec2 = Vector(8,-4,0)

SWEP.DeploySound = "arccw_go/ak47/ak47_draw.wav"

/*function SWEP:DrawHUD()
    local pos,ang = self:GetMuzzlePos()

    debugoverlay.Sphere(pos,1,0.1)
end*/

SWEP.HSM = "models/weapons/arccw_go/atts/barska.mdl"
SWEP.HSMScale = Vector(1,0.8,1)
SWEP.HSP = false

SWEP.HSSize = 20
SWEP.HSBone = "holosight"
SWEP.HSMagnification = 2

SWEP.HSVec = Vector(-20.1,0,1.3)
SWEP.HSAng = Angle(0,0,0)

SWEP.HSCameraVec = Vector(0,0,1.2)
SWEP.HSCameraForward = -7
SWEP.HSZoom = false

SWEP.ScopeSetToMuzzlePos = false
SWEP.ScopeImersiveView = 0.9
SWEP.ScopeSensitivity = 1

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color)
end

local circle = Material("mat_jack_smallarmstracer_front")
local circle2 = Material("mat_jack_gmod_shinesprite")

local glow = Material("particle/particle_glow_03_additive")

function SWEP:DrawHS()
    surface.SetAlphaMultiplier(math.Clamp(ScopeLerp * 2,0,1))

    local pos = self.hsm:GetPos():Add(self.HSCameraVec:Clone():Rotate(self.hsm:GetAngles())):ToScreen()

    local cx,cy = scrw / 2,scrh / 2 + 4

    local dx,dy = cx - pos.x,cy - pos.y
    dx = dx * Lerp(math.abs(dx) / 200,0,1)
    dy = dy * Lerp(math.abs(dy) / 200,0,1)

    local x,y = cx + dx,cy + dy

    local len = math.Distance(cx,cy,x,y)

    local hss = math.min(scrw,scrh) / 40
    hss = hss - len / 2

    hss = hss * (BodyCamMode and 0.40 or 1)--criiiiiiiiiing

    local r = math.cos((x + y) * 75)
    len = len / 2

    local lenx = math.Distance(cx,0,x,0) * 2
    local leny = math.Distance(cy,0,y,0) * 2

    surface.SetMaterial(circle2)
    surface.SetDrawColor(255,0,0,15 + r * 25 + len * 75)

    surface.DrawTexturedRectRotated(x,y,hss * (2 + r * 2 + len),hss * 0.2,r * 360)
    surface.DrawTexturedRectRotated(x,y,hss * (2 + r * 2 + len),hss * 0.2,r + r * 360 * 2)

    surface.SetMaterial(glow)
    surface.SetDrawColor(255,0,0,25)
    surface.DrawTexturedRectRotated(x,y,hss / 2,hss / 2,0)
    surface.SetDrawColor(255,0,0,5)
    surface.DrawTexturedRectRotated(x,y,hss * 3,hss * 3,0)

    surface.SetDrawColor(255,0,0,1)
    surface.DrawTexturedRectRotated(x,y,hss * 12,hss * 12,math.Rand(-360,360))

    hss = hss / 2

    surface.SetMaterial(circle)
    surface.SetDrawColor(255,0,0)
    surface.DrawTexturedRectRotated(x,y,hss - lenx,hss - leny,0,0,0)

    surface.SetAlphaMultiplier(1)
end
