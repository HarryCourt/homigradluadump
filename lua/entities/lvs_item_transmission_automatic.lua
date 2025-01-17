-- "lua\\entities\\lvs_item_transmission_automatic.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Transmission - Automatic"
ENT.Author = "Luna"
ENT.Category = "[LVS]"

ENT.Spawnable		= true
ENT.AdminOnly		= false

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()	
		self:SetModel( "models/diggercars/auto.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysWake()
	end

	function ENT:Think()
		return false
	end

	function ENT:PhysicsCollide( data )
		if self.MarkForRemove then return end

		local ent = data.HitEntity

		if not IsValid( ent ) or not ent.LVS or not isfunction( ent.DisableManualTransmission ) then return end

		if isfunction( ent.IsManualTransmission ) and not ent:IsManualTransmission() then return end

		if ent:DisableManualTransmission() ~= false then
			ent:EmitSound("npc/dog/dog_rollover_servos1.wav")

			self.MarkForRemove = true

			ent:DisableManualTransmission()

			SafeRemoveEntityDelayed( self, 0 )
		end
	end

	function ENT:OnTakeDamage( dmginfo )
	end

else
	function ENT:Draw( flags )
		self:DrawModel( flags )
	end
end
