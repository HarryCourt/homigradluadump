-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\slender\\note_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("slender_note","base_entity",true)
if not ENT then return end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "slender_note"
ENT.Category = "Homigrad"

ENT.Spawnable = true

ENT.OverridePaintIcon = OverridePaintIcon

ENT.WorldModel = "models/props_lab/clipboard.mdl"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.WorldModel)
        
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Use(ply)
        if not ply:IsLookOn(self) then return end

        TableRound().SlenderNotePickUp(self)
    end

    function ENT:SpawnFunction(ply,tr,ClassName)
        if !tr.Hit then return end
    
        local ent = ents.Create(ClassName)
        ent:SetPos(tr.HitPos + tr.HitNormal * 0)
        local ang = tr.HitNormal:Angle()
        ang:RotateAroundAxis(ang:Right(),90)
        ang:RotateAroundAxis(ang:Up(),180)
        ang:RotateAroundAxis(ang:Forward(),180)

        ent:SetAngles(ang)
        ent:Spawn()
        ent:GetPhysicsObject():EnableMotion(false)
    
        return ent
    end
else
    local white = Color(255,255,255)

    function ENT:HUDTarget(ply,k,w,h)
        white.a = 255 * k * (1 - InvOpenK)

        draw.SimpleText("Записка","H.18",w / 2,h / 2 - 50 * (1 - k),white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end