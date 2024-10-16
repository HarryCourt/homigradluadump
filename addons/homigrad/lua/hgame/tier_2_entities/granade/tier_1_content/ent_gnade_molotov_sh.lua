-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\ent_gnade_molotov_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_gnade_molotov","ent_gnade_base")
if not ENT then return end

ENT.PrintName = "Molotov"

ENT.Material = ""
ENT.MiniNadeDamage = 35
ENT.Model = "models/w_models/weapons/w_eq_molotov.mdl"

if SERVER then
	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 and data.Speed > 40 and self:IsOnFire() then
			self:Detonate()
		else
			if data.DeltaTime > 0.2 and data.Speed > 30 then
				self:EmitSound("physics/glass/glass_bottle_impact_hard" .. math.random(1,3) .. ".wav")
			end
		end
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMING)
		self:SetBodygroup(2,1)

		timer.Simple(.3,function()
			if IsValid(self) then
				self:SetState(JMod.EZ_STATE_ARMED)
			end
		end)

		self:EmitSound("ambient/fire/mtov_flame2.wav")
		self:Ignite(15)
	end

	function ENT:CustomThink(state, tim)
		if state == JMod.EZ_STATE_ARMED then
			if IsValid(self.AttachedBomb) then
				if self.AttachedBomb:IsPlayerHolding() then
					self.NextDet = tim + .5
				end

				local CurVel = self.AttachedBomb:GetPhysicsObject():GetVelocity()
				local Change = CurVel:Distance(self.LastVel)
				self.LastVel = CurVel

				if Change > 300 then
					if self.NextDet < tim then
						self:Detonate()
					end

					return
				end

				self:NextThink(tim + .3)

				return true
			end
		end
	end
	
	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true

		self:OutputEffect()

		local vec = self:GetPos()

		local Boom = ents.Create("env_explosion")
		Boom:SetPos(vec)
		Boom:SetKeyValue("imagnitude","50")
		Boom:SetOwner(self:GetOwner())
		Boom:Spawn()
		Boom:Fire("explode",0)

		local att = self:GetOwner()

		for i = 1,5 do
			local FireVec = (VectorRand() * 0.3 + Vector(0,0,0.3)):GetNormalized()
			FireVec.z = FireVec.z / 2

			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(vec + Vector(0,0,30))
			Flame:SetAngles(FireVec:Angle())
			//Flame:SetOwner(Flame,att)
			JMod.SetEZowner(Flame,att)
			
			Flame.SpeedMul = 0.2
			Flame.Creator = att
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end
		
		self:Remove()
	end
elseif CLIENT then
    local vector_up = Vector(1,0,0)
    local angle_up = vector_up:Angle()

	function ENT:InputEffect(vec,ent)
		sound.Emit(nil,"ambient/fire/mtov_flame2.wav",90,1,100,vec)
		sound.Emit(nil,"physics/glass/glass_largesheet_break" .. math.random(1,3) .. ".wav",90,1,200,vec)
    end
end
