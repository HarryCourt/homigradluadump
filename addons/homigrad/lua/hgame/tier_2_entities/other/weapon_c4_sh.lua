-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\weapon_c4_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_c4","base_weapon")
if not SWEP then return end

SWEP.Base                   = "weapon_base"

SWEP.PrintName 				= "Установка C4"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Сачелька"
SWEP.Category 				= "Предметы"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 5
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/jmod/explosives/bombs/c4/w_c4_planted.mdl"
SWEP.WorldModel				= "models/jmod/explosives/bombs/c4/w_c4_planted.mdl"

SWEP.ViewBack = true

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsItemAng = Angle(90,0,-90)
SWEP.dwsItemPos = Vector(-3,2,0)
SWEP.dwsItemFOV = 0

SWEP.InvMoveSnd = InvMoveSndPlastic

local function getPos(ply,ent)
    local tr = {}
    tr.start = ply:EyePos()
    local dir = Vector(75,0,0)
    dir:Rotate(ply:EyeAngles())
    tr.endpos = tr.start + dir
    tr.filter = ply

    tr = util.TraceLine(tr)

    local ang = tr.HitNormal:Angle()
    ang:RotateAroundAxis(ang:Right(),-90)
    ang:RotateAroundAxis(ang:Up(),180)
    --ang:RotateAroundAxis(ang:Up(),ply:EyeAngles()[2])

    return tr.HitPos + Vector(0,0,15),tr.Hit,ang
end

homigrad_weapons = homigrad_weapons or {}

function SWEP:Initialize()
    homigrad_weapons[self] = true
end

if SERVER then
    function SWEP:PrimaryAttack()
        local owner = self:GetOwner()
        local pos,hit,ang = getPos(owner)

        if not hit then return end

        local ent = ents.Create("ent_jack_gmod_eztimebomb")
        ent:SetPos(pos)
        ent:SetAngles(ang)
        ent:Spawn()
        ent:SetPos(pos)
        --ent:GetPhysicsObject():EnableMotion(false)

        owner:EmitSound("garrysmod/balloon_pop_cute.wav")

        self:Remove()
    end
else
    function SWEP:PrimaryAttack() end

    function SWEP:OnRemove()
        if IsValid(self.model) then self.model:Remove() end
        if IsValid(self.model2) then self.model2:Remove() end
    end

    function SWEP:DrawWorldModel()
        self:SetWeaponHoldType("normal")

        local owner = self.Owner
        if not IsValid(owner) then self:DrawModel() return end

        local mdl = self.worldModel
        if not IsValid(mdl) then
            mdl = ClientsideModel(self.WorldModel)
            mdl:SetNoDraw(true)

            self.worldModel = mdl
        end
        self:CallOnRemove("huyhuy",function() mdl:Remove() end)

        local matrix = self.Owner:GetBoneMatrix(11)
        if not matrix then return end

        mdl:SetRenderOrigin(matrix:GetTranslation())
        mdl:SetRenderAngles(matrix:GetAngles() + Angle(90,180,0))
        mdl:SetModelScale(0.25)
        mdl:DrawModel()
    end

    local green = Color(0,255,0)
    local red = Color(255,0,0)

    function SWEP:Step()
        local owner = self:GetOwner()

        local model = self.model
        if not IsValid(model) then
            model = ClientsideModel("models/jmod/explosives/bombs/c4/w_c4_planted.mdl")
            self.model = model
        end

        local pos,hit,ang = getPos(owner)
        model:SetPos(pos)
        model:SetAngles(ang)

        model:SetColor(hit and green or red)
    end

    function SWEP:Holster()
        if IsValid(self.model) then self.model:Remove() end
    end

    function SWEP:OwnerChanged()
        self:Holster()
    end
end