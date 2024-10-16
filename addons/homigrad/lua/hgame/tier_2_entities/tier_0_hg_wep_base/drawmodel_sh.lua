-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\tier_0_hg_wep_base\\drawmodel_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Get("hg_wep_base")
if not SWEP then return end

SWEP.EnableTransformModel = false

SWEP.wmScale = 1
SWEP.wmVector = Vector(0,0,0)
SWEP.wmAngle = Angle(0,0,0)

/*SWEP.wmVectorAdd = Vector(0,0,0)
SWEP.wmAngleAdd = Angle(0,0,0)*/

SWEP.wmBone = "ValveBiped.Bip01_R_Hand"

SWEP.DrawCrosshair = false

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon


function SWEP:GetTransformWorldModel()
    local owner = self:GetOwner()

    if CLIENT then owner:SetupBones() end

    local bone = owner:LookupBone(self.wmBone)
    if not bone then return Vector(),Angle() end
    
    local matrix = owner:GetBoneMatrix(bone)
    if not matrix then return end--;c;;c;c;c
    
    local Pos,Ang = matrix:GetTranslation(),matrix:GetAngles()
    if not Pos then return end

    local Forward,Right,Up = Ang:Forward(),Ang:Right(),Ang:Up()
    local ang = self.wmAngle

    Ang:RotateAroundAxis(Up,ang[1])
    Ang:RotateAroundAxis(Right,ang[2])
    Ang:RotateAroundAxis(Forward,ang[3])

    local vec = self.wmVector
    Forward:Mul(vec[1]) Right:Mul(vec[2]) Up:Mul(vec[3])

    Pos:Add(Forward)
    Pos:Add(Right)
    Pos:Add(Up)

    return Pos,Ang
end

function SWEP:GetWorldModelName() return self.WorldModelHands or self.WorldModel end

function SWEP:GetWorldModel()
	return self.EnableTransformModel and self.wm or self
end

if SERVER then return end

SWEP:Event_Add("Init","WorldModel",function(self)
    if not self.EnableTransformModel then return end

    self:InitWorldModel()
end,-1)

local empty = {}

function SWEP:InitWorldModel()
    local wm = self:GetWorldModelName()
    local wm,isCreate = GetClientSideModelID(wm,wm .. tostring(self))

    if isCreate then
        self.wm = wm

        wm:SetModelScale(self.wmScale)

        for id,value in pairs(self.WorldBodygroups or empty) do
            wm:SetBodygroup(id,value)
        end
    end

    return wm
end

SWEP.wmVectorDrop = Vector(0,0,0)

function SWEP:ShouldRender() end

function SWEP:DrawWorldModel()
    if self:ShouldRender() == false then return end

    self.DrawOrder = true

    self:DrawWorld()
end

function SWEP:DrawWorld()
    local gun = self
    local owner = self:GetOwner()

    if IsValid(owner) then
        if self.EnableTransformModel then
            gun = self:InitWorldModel()

            local Pos,Ang = self:GetTransformWorldModel()
            if not Pos then return end--;c;;cc
            
            gun:SetRenderOrigin(Pos)
            gun:SetRenderAngles(Ang)
        end
    else
        if self.EnableTransformModel then
            gun = self:InitWorldModel()
            
            gun:SetRenderOrigin(self:GetPos():Add(self.wmVectorDrop:Clone():Rotate(self:GetAngles())))
            gun:SetRenderAngles(self:GetAngles())
        end
    end

    self:Render(gun)
end

function SWEP:Render(gun)
    gun:SetupBones()
    gun:DrawModel()

    self:DrawWorldModelPost(gun)
end

function SWEP:DrawWorldModelPost() end