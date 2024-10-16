-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_destroy_storage_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_destroy_storage","base_entity")
if not ENT then return end

ENT.Type = "anim"
ENT.Author = "0oa"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "lootbox_destroy"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/supply_crate01_static.mdl"
ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon
ENT.dwsPos = Vector(75,75,45)
ENT.dwsItemPos = Vector(0,0,0)

ENT.Name = "lootbox_destroy"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.WorldModel)
    
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end
    
    function ENT:Use(ply)
        if not ply:IsLookOn(self) or self.isGhost then return end

        self.inv:Open(ply)
    end
    
    function InvDestroy(inv)
        if #inv:GetAllItems() == 0 then return end
        
        local ent = ents.Create("ent_destroy_storage")
        ent:SetPos(inv.parent:GetPos() + inv.parent:OBBCenter())
        ent:SetAngles(inv.parent:GetAngles())
        ent:Spawn()
    
        ent.inv = inv
        inv:SetParent(ent,"storage")
    
        inv.CanInsertItem = function() return false end
        inv.PopItem = function() if #inv:GetAllItems() == 0 then ent:Remove() end end
    
        inv.OnOpen = function() ent:EmitSound("physics/cardboard/cardboard_box_impact_hard3.wav") end
        inv.OnClose = function() ent:EmitSound("physics/cardboard/cardboard_box_impact_soft3.wav") end

        ent:PhysWake()
    end

    return
else
    ENT.HUDTarget = oop.listClass.ent_lootbox_low[1].HUDTarget
end