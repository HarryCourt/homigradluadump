-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\ent_gnade_rgd5_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_gnade_rgd5","ent_gnade_base")
if not ENT then return end

ENT.PrintName = "RGD5"

ENT.JModPreferredCarryAngles = Angle(0, -140, 0)
ENT.Model = "models/pwb/weapons/w_rgd5_thrown.mdl"
ENT.SpoonScale = 2

if SERVER then
	function ENT:Arm()
		self:SetBodygroup(2,1)
		self:SetState(JMod.EZ_STATE_ARMED)
		self:SpoonEffect()

		local time = math.random(3.2,4.2)

		timer.Simple(time - 1,function()
			player.EventPoint(self:GetPos(),"fragnade pre detonate",1024,self)
		end)

		timer.Simple(time,function()
			if IsValid(self) then self:Detonate() end
		end)
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		
		self:OutputEffect()

		local vec = self:GetPos()
		JMod.Sploom(self.Owner,vec,math.random(10, 20))

		vec[3] = vec[3] + 20
		JMod.FragSplosion(self,vec,2500,35,6000,self.Owner or game.GetWorld())

		self:Remove()
	end

	PrecacheParticleSystem("pcf_jack_groundsplode_small")
elseif CLIENT then
    local vector_up = Vector(1,0,0)
    local angle_up = vector_up:Angle()

	function ENT:InputEffect(vec,ent)
		sound.Emit(nil,"weapons/m67/m67_detonate_0" .. math.random(1,3) .. ".wav",511,1,100,vec)
		sound.Emit(nil,"snd_jack_fragsplodeclose.wav",125,1,100,vec)
		
		DWR_PlayReverb(vec,"explosions",false,{})

		local plooie = EffectData()
		plooie:SetOrigin(vec)
		plooie:SetScale(.2)
		plooie:SetRadius(1)
		plooie:SetNormal(vector_up)

		ParticleEffect("pcf_jack_groundsplode_small",vec,angle_up)

		timer.Simple(0,function()
			ParticleEffect("pcf_jack_groundsplode_small",vec,angle_up)

			sound.Emit(nil,"snd_jack_fragsplodeclose.wav",125,1,100,vec)
		end)

		util.ScreenShake(vec,20,20,1,1000)
    end
end
