-- "addons\\simfphys_base\\lua\\entities\\gmod_sent_vehicle_fphysics_attachment.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Think()
	return false
end

if SERVER then 
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetNotSolid( true )
		self.DoNotDuplicate = true
	end
end

if CLIENT then
	function ENT:Draw( flags )
		self:DrawModel( flags )
	end

	function ENT:DrawTranslucent( flags )
		self:DrawModel( flags )
	end
end