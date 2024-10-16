-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\ent_storage_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_storage","base_entity")
if not ENT then return end

ENT.Type = "anim"
ENT.Author = "0oa"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Контейнер"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/static_crate_48.mdl"
ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon
ENT.dwsPos = Vector(75,75,45)
ENT.dwsItemPos = Vector(0,0,0)

ENT.Name = "storage"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.WorldModel)
    
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local inv = InvCreate(8,2):SetParent(self,"storage")
        self.inv = inv

        inv.name = self.Name

        inv.OnOpen = function() self:EmitSound("homigrad/vgui/item_drop.wav") end
        inv.OnClose = function() self:EmitSound("homigrad/vgui/item_drop.wav",75,80) end
        inv.Think = InvThinkStorage

        self.health = 500
    end

    function ENT:Use(ply)
        if not ply:IsLookOn(self) or self.isGhost then return end

        self.inv:Open(ply)
    end

    function ENT:OnTakeDamage(dmg)
        self.health = self.health - dmg:GetDamage()
        if self.health <= 0 then self:Remove() end
    end

    function ENT:OnRemove() InvDestroy(self.inv) end

    return
else
    ENT.HUDTarget = oop.listClass.ent_lootbox_low[1].HUDTarget
end
