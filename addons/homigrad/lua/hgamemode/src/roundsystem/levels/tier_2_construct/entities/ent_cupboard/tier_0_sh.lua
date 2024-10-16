-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_2_construct\\entities\\ent_cupboard\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_cupboard","base_entity",true)
if not ENT then return INCLUDE_BREAK end

ENT.Type = "anim"
ENT.Author = "0oa"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Cupboard"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_c17/FurnitureDresser001a.mdl"
ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon

function ENT:CanPhysgun() if self:GetNWBool("Uses",false) then return false end end

if SERVER then return end

local white = Color(255,255,255)

function ENT:HUDTarget(ent,k,w,h)
    white.a = 255 * k
    
    local anim =  (50 * (1 - k))

    local use = self:GetNWEntity("Use")
    draw.SimpleText(tostring(IsValid(use) and use:Nick() or L("spawnpoint_free")),"ChatFont",w / 2,h / 2 - anim,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
