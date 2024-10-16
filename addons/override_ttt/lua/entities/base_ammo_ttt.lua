-- "addons\\override_ttt\\lua\\entities\\base_ammo_ttt.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
ENT.Type = "anim"
function ENT:Initialize() if SERVER then self:Remove() end end
function ENT:SetupDataTables() end