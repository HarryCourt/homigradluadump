-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_2_construct\\modules\\physgun_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function Construct.PhysgunPickup(ply,ent)
    if not ply:GetNWBool("IgnoreQ") then
        if Construct.CantPhysgunByClass[ent:GetClass()] then return false end--sasi
        if ent:IsWeapon() or ent:IsRagdoll() then return false end
        if ent.CanPhysgun and ent:CanPhysgun() == false then return false end

        if ent.itemType then return false end
    end
    
    if SERVER then return Construct.PhysgunPickupSV(ply,ent) end
end

if SERVER then return end

function Construct.CanUseSpawnMenu() return true end