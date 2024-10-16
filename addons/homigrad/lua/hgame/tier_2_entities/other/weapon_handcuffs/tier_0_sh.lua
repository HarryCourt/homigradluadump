-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\weapon_handcuffs\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_handcuffs","hg_wep_base",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "Стяжки"
SWEP.Author = "0oa"
SWEP.Instructions = "Связать человека"
SWEP.Category 				= "Предметы"

SWEP.Slot = 5
SWEP.SlotPos = 3
SWEP.Spawnable = true

SWEP.WorldModel = "models/freeman/flexcuffs.mdl"
SWEP.WorldBodygroups = {
    [1] = 1
}

SWEP.wmAngle = Angle(0,0,-90)
SWEP.wmVector = Vector(3,2,-1)

SWEP.dwsItemAng = Angle(0,90,0)
SWEP.dwsItemPos = Vector(0,0,0)
SWEP.dwsItemFOV = -14

SWEP.dwmForward = 3.5
SWEP.dwmRight = 1
SWEP.dwmUp = -1

SWEP.itemType = "other"
SWEP.InvCount = 4
SWEP.InvCountIgnoreLimit = true

SWEP.invNoDrawClip = true

SWEP.InvMoveSnd = InvMoveSndWeapon

SWEP.EnableTransformModel = true

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

if SERVER then
    util.AddNetworkString("cuff")
else
    net.Receive("cuff",function(len)
        local self = net.ReadEntity()
        self.CuffPly = net.ReadEntity()
        self.CuffTime = net.ReadFloat()
    end)
end

local function GetPly(tr)
    local ent = tr.Entity
    if not IsValid(ent) then return end

    local ent = RagdollOwner(ent) or ent
    
    if ent:GetNWBool("Cuffs",false) then return end
    if not ent:IsPlayer() then return ent:GetClass() == "prop_ragdoll" and ent end
    if not ent:GetNWBool("fake") or ent:HasGodMode() then return end

    return ent
end

local cuffTime = 2

if SERVER then
    event.Add("Player Spawn","Cuffs",function(ply)
        ply:SetNWBool("Cuffs",false)
    end)

    hook.Add("PlayerSwitchWeapon","!Cuffs",function(ply,old,new)
        if ply:GetNWBool("Cuffs",false) then return true end
    end)

    function SWEP:PrimaryAttack()
        if IsValid(self.CuffPly) then return end

        local owner = self:GetOwner()

        local tr = owner:EyeTrace(75)
        if not tr then return end

        local ply = GetPly(tr)

        if ply then
            owner:EmitSound("weapons/pinpull.wav")

            self.CuffPly = ply
            self.CuffTime = CurTime()

            self:SendCuff()
        end
    end
    
    SWEP.SecondaryAttack = SWEP.PrimaryAttack
    
    function SWEP:SendCuff()
        net.Start("cuff")
        net.WriteEntity(self)
        net.WriteEntity(self.CuffPly or Entity(-1))
        net.WriteFloat(self.CuffTime)
        net.Send(self:GetOwner())
    end

    function SWEP:Think()
        local cuffPly = self.CuffPly
        if not IsValid(cuffPly) then return end

        local owner = self:GetOwner()

        local tr = owner:EyeTrace(75)
        if not tr then return end
        
        local ply = GetPly(tr)

        if ply ~= cuffPly then
            self.CuffPly = nil
            
            self:SendCuff()

            return
        end

        if self.CuffTime + cuffTime <= CurTime() then
            if ply:IsPlayer() then ply = ply.fakeEnt end

            self:Cuff(ply)
        end
    end
end

if SERVER then return end

function SWEP:DrawHUD()
    local tr = self:GetOwner():EyeTrace(75)
    if not tr then return end
    
    local ply = GetPly(tr)

    local hit = tr.Hit and 1 or 0

    local pos = tr.HitPos:ToScreen()
    local x,y = pos.x,pos.y
    
    local frac = tr.Fraction * 100

    if ply then
        surface.SetDrawColor(Color(255, 255, 255, 255))
        draw.NoTexture()
        Circle(x, y, 5 / frac, 32)

        draw.DrawText("Связать", "TargetID",x,y - 40,color_white,TEXT_ALIGN_CENTER)

        if IsValid(self.CuffPly) then
            local anim_pos = 1 - math.Clamp((self.CuffTime + cuffTime - CurTime()) / cuffTime,0,1)

            surface.DrawRect(x - 50,y + 50,anim_pos * 100,25)
        end
    else
        surface.SetDrawColor(Color(255, 255, 255, 255 * hit))
        draw.NoTexture()
        Circle(x, y, 5 / frac, 32)
    end
end