-- "addons\\jmod_master\\lua\\entities\\ent_jack_gmod_ezflashbang.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿-- Jackarunda 2021
AddCSLuaFile()
ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, TheOnly8Z"
ENT.PrintName = "EZ Flashbang"
ENT.Category = "JMod - EZ Misc."
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, 140, 0)
ENT.Model = "models/jmod/explosives/grenades/flashbang/flashbang.mdl"
--ENT.ModelScale=1.5
ENT.SpoonScale = 2
ENT.PinBodygroup = nil
ENT.SpoonBodygroup = {2, 1}
ENT.DetDelay = 2

if SERVER then
	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos, Time = self:GetPos() + Vector(0, 0, 10), CurTime()
		JMod.Sploom(self.EZowner, self:GetPos(), 20)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
		self:EmitSound("snd_jack_fragsplodeclose.wav", 90, 140)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(1)
		util.Effect("eff_jack_gmod_flashbang", plooie, true, true)
		util.ScreenShake(SelfPos, 20, 20, .2, 1000)

		for k, v in pairs(ents.FindInSphere(SelfPos, 200)) do
			if v:IsNPC() then
				v.EZNPCincapacitate = Time + math.Rand(3, 5)
			end
		end

		self:SetColor(Color(0, 0, 0))

		timer.Simple(.1, function()
			if not IsValid(self) then return end
			util.BlastDamage(self, JMod.GetEZowner(self), SelfPos, 1000, 2)
		end)

		SafeRemoveEntityDelayed(self, 10)
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_ezflashbang", "EZ Flashbang Grenade")
end
