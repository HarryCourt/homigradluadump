-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_2_construct\\entities\\ent_spawnpoint\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_spawnpoint","base_entity",true)
if not ENT then return INCLUDE_BREAK end

ENT.Type = "anim"
ENT.Author = "0oa"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Spawn Point"
ENT.Category = "Homigrad"

ENT.WorldModel = "models/props_c17/FurnitureMattress001a.mdl"
ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon

for i = 1,7 do Sound("homigrad/physics/shield/bullet_hit_shield_0" .. i .. ".wav") end

function ENT:CanPhysgun() if self:GetNWBool("Uses",false) then return false end end

if SERVER then return end

local white = Color(255,255,255)

function ENT:HUDTarget(ent,k,w,h)
    white.a = 255 * k

    local anim =  (50 * (1 - k))
    local use = ent:GetNWEntity("Use")

    draw.SimpleText(tostring(IsValid(use) and use:Nick() or L("spawnpoint_free")),"ChatFont",ScrW() / 2,ScrH() / 2 - anim,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
