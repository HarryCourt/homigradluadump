-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\lootboxs\\tier_0_ent_lootbox_low_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_lootbox_low","base_entity")
if not ENT then return end

ENT.Type = "anim"
ENT.Author = "0oa"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "LootBox Low"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_crates/static_crate_40.mdl"
ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon

ENT.dwsPos = Vector(205,205,75)
ENT.dwsItemPos = Vector(0,0,-20)

ENT.Name = "lootbox_low"
ENT.w = 4
ENT.h = 1

local random = {
    "med_kit","adrenaline","med_band","med_painkiller",

    "melee_bat","melee_kitknife","melee_crowbar",
    "melee_hatchet","melee_knife","melee_fireaxe","melee_t","melee_pipe","melee_shovel",

    "ent_drop_flashlight","ent_drop_flashlight",

    "ent_jack_gmod_ezarmor_gruppa99t30m","ent_jack_gmod_ezarmor_dufflebag",

    "ent_jack_gmod_ezarmor_eaimbss","ent_jack_gmod_ezarmor_rbavaf",

    "weapon_handcuffs","weapon_radio","weapon_per4ik",

    "wep_food_juice","wep_food_water","wep_food_pepsi",

    "wep_food_canner","wep_food_cannerfish","wep_food_cannerburger",
    "wep_food_canner","wep_food_cannerfish","wep_food_surst"
}

function ENT:GetRandom()
    local random = self.lootList or random
    
    return random[math.random(2,#random)]
end

function ENT:GetRandomCount() return math.random(2,4) end

LootBoxEnts = LootBoxEnts or {}

if SERVER then
    function ENT:SpawnFunction(ply,tr,name)
        if not tr.Hit then return end
    
        local ent = ents.Create(name)
        ent:SetPos(tr.HitPos + tr.HitNormal * 16)
        ent:SetAngles(Angle(0,ply:GetAngles()[2],0))
        ent.spawned = true
        ent:Spawn()
        ent:Activate()
    
        return ent
    end

    function ENT:Initialize()
        self:SetModel(self.WorldModel)
        self:SetMaterial(self.WorldMaterial or "")
        self:SetSkin(self.WorldSkin or 0)
        
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SOLID_VPHYSICS)
        self:PhysWake()

        self:GetPhysicsObject():SetMass(50)

        self:AddEFlags(EFL_NO_THINK_FUNCTION)

        local max = self:GetRandomCount()
        
        local inv = InvCreate(self.w,self.h):SetParent(self,"storage")
        self.inv = inv

        inv.Think = InvThinkStorage

        inv.name = self.Name
        inv.OnOpen = function(_,ply)
            if not inv.CreateLoot then
                inv.CreateLoot = true

                if not event.Call("LootBox Open",self,inv,ply) then
                    for i = 1,max do
                        local ent = ents.Create(self:GetRandom())
                        if not IsValid(ent) then continue end
            
                        ent:SetPos(self:GetPos())
                        ent:Spawn()
            
                        if not inv:AddEnt(ent) then ent:Remove() end
                    end
                end
                
                inv.ShouldInsertItem = function() return false end
            end
            
            sound.Emit(self:EntIndex(),"homigrad/vgui/item_drop.wav",75,0.75,100,nil,nil,self)
        end

        inv.OnClose = function()
            sound.Emit(self:EntIndex(),"homigrad/vgui/item_drop.wav",75,0.75,80,nil,nil,self)

            if #inv:GetAllItems() == 0 then self:Remove() end
        end

        LootBoxEnts[self] = true

        event.Call("LootBox Create",self)
    end

    ENT.UsePreStop = true
    
    function ENT:Use(ply)
        if not ply:IsLookOn(self) or self.isGhost then return end

        self.inv:Open(ply)
    end

    function ENT:OnRemove()
        LootBoxEnts[self] = nil
    end

    return
else
    function ENT:Initialize()
        LootBoxEnts[self] = true
    end

    function ENT:OnRemove()
        LootBoxEnts[self] = nil
    end

    local white = Color(255,255,255)

    function ENT:HUDTarget(ply,k,w,h)
        white.a = 255 * k * (1 - InvOpenK)

        draw.SimpleText(L(self:GetNWString("OverrideName",self.Name)),"HS.18",w / 2,h / 2 - 50 * (1 - k),white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end