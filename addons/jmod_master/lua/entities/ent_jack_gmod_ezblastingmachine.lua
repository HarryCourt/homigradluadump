-- "addons\\jmod_master\\lua\\entities\\ent_jack_gmod_ezblastingmachine.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿-- Jackarunda 2021
AddCSLuaFile()
ENT.Type = "anim"
ENT.Author = "TheOnly8Z"
ENT.PrintName = "EZ Satchel Charge Plunger"
ENT.Spawnable = false
ENT.NoSitAllowed = true
ENT.JModPreferredCarryAngles = Angle(0, 0, 0)

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Fired")
end

if SERVER then
	function ENT:Initialize()
		--self:SetModel("models/grenades/satchel_charge_plunger.mdl")
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.DieTime = nil
		self:SetFired(false)

		if self:GetPhysicsObject():IsValid() then
			self:GetPhysicsObject():SetMass(10)
			self:GetPhysicsObject():Wake()
		end

		if istable(WireLib) then
			--self.Inputs=WireLib.CreateInputs(self, {"Fire"}, {"Plunges the plunger"})
			self.Outputs = WireLib.CreateOutputs(self, {"State"}, {"Fired or not"})
		end
	end

	function ENT:InvInsertItem()
		return false
	end

	function ENT:TriggerInput(iname, value)
	end

	--if(iname == "Fire" and value > 0) then
	--	self:SetFired(true)
	--end

	ENT.BypassUse = true

	function ENT:Use(activator, caller, typ, val)
		if not IsValid(activator) or self:GetFired() then return end

		if IsValid(self:GetParent()) then
			self:GetParent():Use(activator, caller, typ, val)

			return
		end

		self.EZowner = activator

		if activator:KeyDown(JMod.Config.General.AltFunctionKey) then
			self:EmitSound("snds_jack_gmod/plunger.ogg")
			self:SetFired(true)
			activator:ViewPunch(Angle(-5,0,0))

			timer.Simple(.5, function()
				if IsValid(self.Satchel) then
					self.Satchel:Detonate(activator)
				end
			end)

			self.DieTime = CurTime() + 10
		elseif not self:GetFired() then
			activator:PickupObject(self)
		end
	end

	function ENT:Think()
		if istable(WireLib) then
			WireLib.TriggerOutput(self, "State", self:GetFired())
		end

		if not IsValid(self.Satchel) and self.DieTime == nil then
			self:Remove()
		elseif self.DieTime ~= nil and self.DieTime < CurTime() then
			self:Remove()
		end
	end

	function ENT:OnRemove()
		if IsValid(self.Satchel) then
			SafeRemoveEntity(self.Satchel)
		end
	end
elseif CLIENT then
	function ENT:Initialize()
		--self:SetBodygroup(2,1)
		self.Mdl = ClientsideModel("models/jmod/explosives/grenades/satchelcharge/satchel_charge_plunger.mdl")
		self.Mdl:SetModelScale(3, 0)
		self.Mdl:SetPos(self:GetPos())
		self.Mdl:SetParent(self)
		self.Mdl:SetNoDraw(true)
	end

	local white = Color(255,255,255)

	function ENT:HUDTarget(ply,k,w,h)
		white.a = 255 * k * (1 - InvOpenK)

		draw.SimpleText("Рычаг","HS.18",w / 2,h / 2 - 50 * (1 - k),white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	function ENT:Draw()
		//self:DrawModel()
		local parent = self:GetParent()

		if IsValid(parent) and parent:GetNoDraw() then return end

		self.Mdl:SetRenderOrigin(self:GetPos() + self:GetForward() * 30 + self:GetUp() * 1.5)
		self.Mdl:SetRenderAngles(self:GetAngles())

		if self:GetFired() then
			self.Mdl:SetBodygroup(2, 1)
		end

		self.Mdl:DrawModel()
	end

	language.Add("ent_jack_gmod_ezsatchelcharge_plunger", "EZ Satchel Charge Plunger")
end
