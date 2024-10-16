-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\ent_gnade_smoke_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_gnade_smoke","ent_gnade_base")
if not ENT then return end

ENT.PrintName = "Smokenade"

ENT.Model = "models/jmod/explosives/grenades/firenade/incendiary_grenade.mdl"
ENT.Material = "models/mats_jack_nades/smokescreen"
ENT.ModelScale=0.8
ENT.SpoonScale = 2

ENT.TimeSmoking = 60

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
		local time = CurTime()
		if self:GetNWFloat("Start",0) + self.TimeSmoking < time or (self.delay or 0) > time then return end
		self.delay = time + 0.25

		local pos = self:GetPos()

		for i,ent in pairs(ents.FindByClass("ent_jack_gmod_ezfirehazard")) do
			local pos2 = ent:GetPos()
			if pos2:Distance(pos) > 250 then continue end

			local tr = {
				start = pos,
				endpos = pos2,
				mask = MASK_SHOT,
				filter = self
			}

			if util.TraceLine(tr).HitPos:Distance(pos2) <= 6 then ent.DieTime = ent.DieTime - 0.25 end
		end
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Initialize()
		self.smokes = {}
	end

	function ENT:AddSmoke(emitter)
		if #self.smokes > 23 then
			local part = self.smokes[1]
			if IsValid(part) then part:SetDieTime(5) end

			table.remove(self.smokes,1)
		end--epiiii

		local part = emitter:Add(ParticleMatSmoke[math.random(1,#ParticleMatSmoke)],self:GetPos():Add(self:GetAngles():Up():Mul(1)))

		self.smokes[#self.smokes + 1] = part

		return part
	end

	local Rand = math.Rand

	local function Think(part)
		local pos = part:GetPos()

		local vel = Vector(Rand(-1,1),Rand(-1,1),Rand(-1,1))

		for i,part2 in pairs(part.smokes) do
			local pos2 = part2:GetPos()
			local diff = (pos - pos2):GetNormalized()
			diff = diff:Mul(1 - math.min(pos:Distance(pos2) / 512,1)):Mul(0.5)

			vel:Add(diff:Rotate(Angle(math.Rand(-90,90),math.Rand(-90,90),0)))
		end

		part:SetVelocity(part:GetVelocity():Add(vel))
		part:SetNextThink(CurTime() + Rand(0.2,0.4))

		return false
	end

	function ENT:Think()
		local time = CurTime()
		if (self.delay or 0) > time then return end
		self.delay = time + 0.25

		local anim_pos = (self:GetNWFloat("Start",0) - time + self.TimeSmoking) / self.TimeSmoking
		if anim_pos <= 0 then return end

		anim_pos = 1 - anim_pos
		anim_pos = math.Clamp(anim_pos * 2,0.75,1)

		local emitter = ParticleEmit(self:GetPos())
		local part = self:AddSmoke(emitter)

		if part then
			part:SetDieTime(Rand(5,8))
	
			part:SetStartAlpha(200)
			part:SetEndAlpha(0)
			part:SetLighting(false)

			part:SetStartSize(75 * anim_pos)
			part:SetEndSize(700 * anim_pos)
	
			part:SetGravity(Vector(0,0,-50))
			part:SetVelocity(self:GetAngles():Up():Mul(100):Add(Vector(Rand(-55,55) * Rand(0.5,2),Rand(-55,55) * Rand(0.5,2),Rand(-5,5)):Rotate(self:GetAngles())))
			--part.Think = Think
			part.smokes = self.smokes
			part.parent = self

			part:SetCollide(true)
			part:SetBounce(0.75)

			sound.Emit(self:EntIndex(),"snd_jack_sss.wav",75,0.1,math.random(90,110))
		end

		emitter:Finish()
	end
end
