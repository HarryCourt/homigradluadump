-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\ent_gnade_cianade_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_gnade_cianade","ent_gnade_base")
if not ENT then return end

ENT.PrintName = "Разрывной цианид"

ENT.Model = "models/mass_effect_3/weapons/misc/mods/pistols/barrela.mdl"
ENT.Material = "models/mats_jack_nades/smokescreen"
ENT.ModelScale=0.8
ENT.SpoonScale = 2

ENT.TimeSmoking = 10

ENT.delay = 0

if SERVER then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("weapons/pinpull.wav",60,100)
		self:SetBodygroup(3,1)
	end

	function ENT:Arm()
		self:SetBodygroup(2,1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()

		timer.Simple(2,function()
			if IsValid(self) then self:Detonate() end
		end)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true

		self:EmitSound("snd_jack_fragsplodeclose.wav",50,150)
		
		local time = CurTime()
		
		self:SetNWFloat("Start",time)
	end
	
	function ENT:CustomThink()
		if not self.Exploded then return end
		
		local time = CurTime()
		if self.delay > time then return end
		self.delay = time + 1

		local k = (self:GetNWFloat("Start") - time + self.TimeSmoking) / self.TimeSmoking

		if k <= 0 then self:Remove() return end

		local ent = ents.Create("ent_poisongas")
		ent:SetPos(self:GetPos())
		ent:Spawn()
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
