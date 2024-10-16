-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\flashbang_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_flashbang", "wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "Светошумовая Граната"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Специальное средство несмертельного действия, оказывающее на человека светозвуковое и осколочное воздействие."
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/jmod/explosives/grenades/flashbang/flashbang.mdl"

SWEP.Granade = "ent_gnade_flashbang"

SWEP.dwsItemFOV = -12
SWEP.dwsItemPos = Vector(0, 0, -1.5)

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(5, 2, 1)
SWEP.wmAngle = Angle(0, 180, 0)


function SWEP:PrimaryAttack()
    self:ThrowGrenade(1000)
end


function SWEP:SecondaryAttack()
    self:ThrowGrenade(500)
end


function SWEP:ThrowGrenade(velocity)
    if SERVER then
        local ply = self:GetOwner()
        if not IsValid(ply) then return end

        self:SetNextPrimaryFire(CurTime() + 1.5)
        self:SetNextSecondaryFire(CurTime() + 1.5)

        local ent = ents.Create(self.Granade)
        if not IsValid(ent) then return end

        local forward = ply:EyeAngles():Forward()
        local src = ply:GetPos() + Vector(0, 0, 60)
        local vel = forward * velocity

        ent:SetPos(src)
        ent:SetAngles(ply:EyeAngles())
        ent:SetOwner(ply)
        ent:Spawn()
        ent:Activate()
        ent:GetPhysicsObject():SetVelocity(vel)

        ent:Arm() 

        self:Remove()
    end
end

function SWEP:Deploy()
    return true
end

function SWEP:Holster()
    return true
end
