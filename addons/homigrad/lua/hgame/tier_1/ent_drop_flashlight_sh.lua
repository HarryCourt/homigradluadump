-- "addons\\homigrad\\lua\\hgame\\tier_1\\ent_drop_flashlight_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_drop_flashlight","base_entity")
if not ENT then return end

ENT.Type = "anim"
ENT.Author = "0oa"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Фонарик"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/maxofs2d/lamp_flashlight.mdl"
ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon

ENT.dwsItemPos = Vector(3,0,0)
ENT.dwsItemAng = Angle(0,0,0)
ENT.dwsItemFOV = -4

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/plates/plate025.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        self:PhysWake()
        self:DrawShadow(false)
    end

    function ENT:Use(ply)
        ply:AddEnt(self)
    end

    function ENT:InvInsertItem(slot,item)
        local parent = slot.inv.parent
        if IsValid(parent) and parent:IsPlayer() then parent.allowFlashlights = true end

        //if slot.inv ~= item.inv then self:InvPopItem(slot,item) end
    end

    function ENT:InvPopItem(slot,item)
        parent = slot.inv.parent

        if parent:IsPlayer() then
            for i,item in pairs(slot.inv:GetAllItems()) do
                if item.ent == self then continue end
                if item.ent:GetClass() == self:GetClass() then return end
            end

            parent.allowFlashlights = false
            parent:Flashlight(false)
        end
    end 
else
    local rot = Angle(90,0,0)
    
    function ENT:Draw()
        local ent,create = GetClientSideModelID("models/maxofs2d/lamp_flashlight.mdl",tostring(ent))

        if create then
            local mat = Matrix()
            mat:Scale(Vector(0.5,0.5,0.5))
            ent:EnableMatrix("RenderMultiply",mat)
        end

        ent:SetRenderOrigin(self:GetPos())
        ent:SetRenderAngles(self:GetAngles():Rotate(rot))
        ent:DrawModel()
    end

    local white = Color(255,255,255)

    function ENT:HUDTarget(ply,k,w,h)
        white.a = 255 * k * (1 - InvOpenK)

        draw.SimpleText(L(self.PrintName),"H.18",w / 2,h / 2 - 50 * (1 - k),white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end