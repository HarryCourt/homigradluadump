-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\tier_0_hg_wep_base\\deploy_holster_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Get("hg_wep_base")
if not SWEP then return end

SWEP.HolsterTime = 0.25
SWEP.DeployTime = 0.25

SWEP.HoldType = "pistol"

function SWEP:IsGhostWalk()
    local owner = self:GetOwner()
    if not IsValid(owner) or owner:IsNPC() then return end

    return owner:KeyDown(IN_DUCK) or owner:KeyDown(IN_WALK)
end

if CLIENT then
    net.Receive("wep holster",function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        ent:HolsterCan(net.ReadEntity())
    end)

    net.Receive("wep deployed",function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        ent:Deployed()
    end)
    
    net.Receive("wep holstered",function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        ent:Holstered()
    end)
    
    net.Receive("wep holstered end",function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        ent:HolsteredEnd()
    end)
end

SWEP:Event_Add("Init","HoldType",function(self)
    self:SetupStandType()

    if CLIENT then
        self:SetNWVarProxy("HoldType",function(_,key,old,new)
            if not self.SetupStandType then return end--wtf
            
            self:SetupStandType()
        end)
    end

    timer.Simple(0,function() if IsValid(self) then self:SetupStandType() end end)
end)

function SWEP:Deployed()
    if self.deployed then return end--ura

    self.deployed = true
    self:SetNWFloat("DeployStart",CurTime())
    self.DeployStart = RealTime()

    local owner = self:GetOwner()

    if self.HoldType then self:SetStandType(self.HoldType) end
    self:Event_Call("Deploy",owner)

    if SERVER then
        if owner:IsNPC() then return end

        net.Start("wep deployed")
        net.WriteEntity(self)
        net.Send(owner)

        timer.Simple(0.001,function()//отправляем клиенту инфу о том что он достал оружие, при создании баг такой есть
            if not IsValid(self) then return end

            net.Start("wep deployed")
            net.WriteEntity(self)
            net.Send(owner)
        end)
    end
end

function SWEP:Holstered()
    self:SetNWFloat("HolsterTime",CurTime())
    self.HolsterStart = RealTime()
    
    local owner = self:GetOwner()

    self:SetStandType("normal")
    self:Event_Call("Holster",owner)

    if SERVER and owner:IsNPC() then self:HolsteredEnd() return end

    if SERVER then
        net.Start("wep holstered")
        net.WriteEntity(self)
        net.Send(owner)
    end
end

function SWEP:HolsteredEnd()
    local owner = self:GetOwner()
    self.deployed = nil
    self:Event_Call("Holster End",owner)

    if SERVER and not owner:IsNPC() then
        net.Start("wep holstered end")
        net.WriteEntity(self)
        net.Send(owner)
    end
end

function SWEP:Deploy() self:SetNWFloat("DeployStart",CurTime() + 10) end//костыли ебаные, бывает моменты когда он достаёт и не пришло ничоо,

function SWEP:IsDeployed() return self:GetNWFloat("DeployStart",0) + self.DeployTime < CurTime() end//true если оружие он достал
function SWEP:IsHolstered() return self:GetNWFloat("HolsterTime",0) + self.HolsterTime + 0.5 >= CurTime() end//true если убирает оружие

function SWEP:GetStandAnim()
    local time = CurTime()
    
    local k = 1 - math.Clamp((self:GetNWFloat("DeployStart",0) + self.DeployTime - time) / self.DeployTime,0,1)
    k = k - math.Clamp((self:GetNWFloat("HolsterTime",0) + self.HolsterTime - time) / self.HolsterTime,0,1)

    return k
end
 
SWEP:Event_Add("Step Local","Is Deployed",function(self)
    if not self.deployed then return false end--lol
end,-5)

SWEP:Event_Add("Deploy","HoldType",function(self) self:SetupStandType() end,-1)

function SWEP:SetStandType(value)
    value = value or "normal"
    
    self:SetNWString("HoldType",value)

    self:SetupStandType()
end

function SWEP:SetupStandType()
    self:SetWeaponHoldType(self:GetNWString("HoldType","normal"))--боже какая эта игра залупа ебаная
    --убить нахуй кто за неты отвечал
end

hook.Add("DoAnimationEvent","homigrad-weapons",function(ply,event,data)
    local wep = ply:GetActiveWeapon()

    if IsValid(wep) and wep.DoAnimationEvent then return wep:DoAnimationEvent(ply,event,data) end
end)

SWEP:Event_Add("Holster End","Off",function(self) self:Event_Call("Off") end)
SWEP:Event_Add("Owner Changed","Off",function(self) self:Event_Call("Off") end)
SWEP:Event_Add("Remove","Off",function(self) self:Event_Call("Off") end)

function SWEP:OwnerChanged()
    self.deployed = nil
    
    self:Event_Call("Owner Changed")
end

if SERVER then return end

function SWEP:HolsterCan(nextWep)--receive
    self.holsterCan = true

    if IsValid(nextWep) then
        input.SelectWeapon(nextWep)
    else
        self:Holster(nextWep)
    end
end

function SWEP:CanHolster() return self.holsterCan end

function SWEP:Holster(newWep)
    if not self:CanHolster() then self:SetNWFloat("HolsterTime",CurTime() + 10) return false end

    self.holsterCan = nil

    self:HolsteredEnd()

    return true
end