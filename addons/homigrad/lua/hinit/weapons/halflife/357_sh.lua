-- "addons\\homigrad\\lua\\hinit\\weapons\\halflife\\357_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_357","wep_glock")
if not SWEP then return end

SWEP.PrintName 				= "Colt.357"
SWEP.Instructions           = ""
SWEP.Category 				= "Оружие: Half-Life"

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Shell = false

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.001
SWEP.Primary.Damage = 50
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 8

SWEP.Primary.Sound = "arccw_go/revolver/revolver-1_01.wav"
SWEP.Primary.SoundFar = "arccw_go/revolver/revolver-1_distant.wav"
SWEP.EmptySound = "arccw_go/revolver/revolver_hammer.wav"

SWEP.WorldModel				=  "models/weapons/w_jmod_shotrevolver.mdl"                                             

SWEP.HoldTypeReload = "revolver"

SWEP.vbwPos = Vector(-8,2,-3)
SWEP.vbwAng = Angle(-90,0,0)

SWEP.dwsItemPos = Vector(-1,4,-4.2)

SWEP.wmVector = Vector(4,2.5,3.2)
SWEP.wmAngle = Angle(-290   ,3,180 + 7)

SWEP.dwsItemFOV = -13.5

SWEP.MuzzlePos = Vector(3,-0.02,-0.15)
SWEP.MuzzleAng = Angle(-0.5,0.1,180)    

SWEP.CameraPos = Vector(-18,-0.3,1)
SWEP.CR_Scope = 4

SWEP.Reload1 = "arccw_go/glock18/glock_clipout.wav"
SWEP.Reload2 = "arccw_go/glock18/glock_clipin.wav"
SWEP.Reload3 = "arccw_go/glock18/glock_slideback.wav"
SWEP.Reload4 = "arccw_go/glock18/glock_sliderelease.wav"

SWEP.FakeVec1 = Vector(-10,-4,-6)

SWEP.DeploySound = "arccw_go/revolver/revolver_draw.wav"

SWEP.BoltBone = "CSEntity [class C_BaseFlex]"
SWEP.BoltMul = 2

SWEP.ClipBone = false

SWEP.eyeSprayH = 8
SWEP.eyeSprayLerp = 0.9

SWEP.CHandUp = 28
SWEP.CHandHoldUp = 0.7

SWEP.CHandRight = 1
SWEP.CHandHoldRight = 0.5

function SWEP:GetCHandUp(value) return math.ease.InSine(value) end

function SWEP:PrimaryCustomAttack()
    if self.attackStart then return end

    self.attackStart = CurTime() + 0.1

    local ply = self:GetOwner()

    if SERVER then
        sound.EmitNET(ply:EntIndex(),"arccw_go/revolver/revolver_prepare.wav")
        net.SendOmit(ply)
    else
        sound.Emit(ply:EntIndex(),"arccw_go/revolver/revolver_prepare.wav")
    end
end

SWEP.HammerBone = "v_weapon.hammer"

SWEP:Event_Add("Init","Attack Pre",function(self)
    self.lerpHammer = 0
    self.lerpCylinder = 0
end)

if CLIENT then
    net.Receive("r8 shoot",function()
        local wep = LocalPlayer():GetActiveWeapon()

        if IsValid(wep) and not wep.attackWas then
            wep:Attack()
        end

        wep.attackWas = nil--;c;c;c
    end)
else
    util.AddNetworkString("r8 shoot")
end

SWEP:Event_Add("Step","Attack Pre",function(self)
    if self.attackStart then
        if self:GetOwner():KeyDown(IN_ATTACK) then
            if self.attackStart < CurTime() then
                self.attackStart = nil

                /*if SERVER then
                    net.Start("r8 shoot")
                    net.Send(self:GetOwner())
                end*/

                self.attackWas = true

                self:Attack()
            end
        else
            self.attackStart = nil
        end
    end

    if self:IsLocal() then
        local gun = self:GetGun()

        local k = math.max((self.attackStart or 0) - CurTime(),0) / 0.1

        self.lerpHammer = LerpFT(k > 0 and 0.25 or 0.95,self.lerpHammer,k > 0 and 1 or 0)

        --gun:ManipulateBoneAngles(gun:LookupBone(self.HammerBone),Angle(0,0,-45 * self.lerpHammer))
    end
end)

SWEP.ReloadMatrix = nil

SWEP.ReloadMatrix = {
	[0] = function(self)
		local owner = self:GetOwner()
		owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,owner:IsFlagSet(FL_ANIMDUCKING) and ACT_MP_RELOAD_CROUCH or ACT_MP_RELOAD_STAND,true)
	end,
	[1] = function(self)
	end
}

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        flashScale = 3,
        gasTimeScale = 3.5,
        gasSideScale = 1.5,
        gasForwardScale = 2
    })
end