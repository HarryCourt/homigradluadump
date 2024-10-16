-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_0_base\\ent_gnade_base\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_gnade_base","base_entity",true)
if not ENT then return INCLUDE_BREAK end

ENT.Category = "Homigrad - GNade"
ENT.PrintName = "Grenade Base"
ENT.NoSitAllowed = true
ENT.Spawnable = true

ENT.Model = "models/weapons/w_grenade.mdl"

ENT.Material = nil
ENT.ModelScale = nil
ENT.HardThrowStr = 500
ENT.SoftThrowStr = 250
ENT.Mass = 10

ENT.ImpactSound = "Grenade.ImpactHard"

ENT.SpoonEnt = "ent_jack_spoon"
ENT.SpoonModel = nil
ENT.SpoonScale = nil
ENT.SpoonSound = nil

ENT.PinBodygroup = {1,1}
ENT.SpoonBodygroup = {2,1}

ENT.DetDelay = nil
ENT.JModPreferredCarryAngles = Angle(0,0,0)
ENT.JModEZstorable = true

ENT.DrawWeaponSelection = DrawWeaponSelection
ENT.OverridePaintIcon = OverridePaintIcon

ENT.itemType = "granade"
ENT.InvMoveSnd = InvMoveSndGranade
ENT.InvCount = 3

function ENT:SetupDataTables() self:NetworkVar("Int",0,"State") end

if SERVER then return end

net.Receive("granade effect",function()
    local ent = scripted_ents.Get(net.ReadString())
    
    ent:InputEffect(net.ReadVector(),net.ReadEntity())
end)

