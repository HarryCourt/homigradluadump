-- "addons\\homigrad\\lua\\hinit\\ent_jack_gmod_ezfirehazard_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿local ENT = oop.Reg("ent_jack_gmod_ezfirehazard","base_entity")
if not ENT then return end

ENT.PrintName = "Fire Hazard"
ENT.KillName = "Fire Hazard"
ENT.NoSitAllowed = true
ENT.IsRemoteKiller = true
local ThinkRate = 22 --Hz

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "HighVisuals")
end

if SERVER then
	function ENT:Initialize()
		self.Ptype = 1

		self.TypeInfo = {
			"Napalm", {Sound("snds_jack_gmod/fire1.wav"), Sound("snds_jack_gmod/fire2.wav")},
			"eff_jack_gmod_heavyfire", 20, 30, 200
		}

		----
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(false)
		self:SetCollisionBounds(Vector(-20, -20, -10), Vector(20, 20, 10))
		self:PhysicsInitBox(Vector(-20, -20, -10), Vector(20, 20, 10))
		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableCollisions(false)
		end

		self:SetNotSolid(true)

		local Time = CurTime()
		self.NextFizz = 0
		self.DamageMul = (self.DamageMul or 1) * math.Rand(.9, 1.1)
		self.DieTime = Time + math.Rand(self.TypeInfo[4], self.TypeInfo[5])
		self.NextSound = 0
		self.NextEffect = 0
		self.NextEnvThink = Time + 5
		self.Range = self.TypeInfo[6]
		self.Power = 3

		if self.HighVisuals then
			self:SetHighVisuals(true)
		end
	
		local gas = ents.Create("ent_jack_gmod_ezfiregas")
		gas:SetPos(self:GetPos() + Vector(0,0,50))
		gas:SetAngles(self:GetAngles())
		gas:SetOwner(self:GetOwner())

		gas.Creator = self:GetOwner()
		gas:Spawn()
		gas:Activate()
	end

	local function Inflictor(ent)
		if not IsValid(ent) then return game.GetWorld() end
		local Infl = ent:GetDTEntity(0)
		if IsValid(Infl) then return Infl end

		return ent
	end

	local DamageBlacklist = {
		["vfire_ball"] = true,
		["ent_jack_gmod_ezfirehazard"] = true,
		["ent_jack_gmod_eznapalm"] = true
	}

	function ENT:Think()
		local Time, Pos, Dir = CurTime(), self:GetPos(), self:GetForward()

		--print(self:WaterLevel())
		if self.NextFizz < Time then
			self.NextFizz = Time + .5

			if math.random(1, 2) == 2 or self.HighVisuals then
				local Zap = EffectData()
				Zap:SetOrigin(Pos)
				Zap:SetStart(self:GetVelocity())
				util.Effect(self.TypeInfo[3], Zap, true, true)
			end
		end

		if self.NextSound < Time then
			self.NextSound = Time + 1
			self:EmitSound(table.Random(self.TypeInfo[2]), 65, math.random(90, 110))
			if (math.random(1,2) == 1) then JMod.EmitAIsound(self:GetPos(), 300, .5, 8) end
		end

		if self.NextEffect < Time then
			self.NextEffect = Time + 0.5
			local Par, Att, Infl = self:GetParent(), self.EZowner or self, Inflictor(self)

			if not IsValid(Att) then
				Att = Infl
			end

			if IsValid(Par) and Par:IsPlayer() and not Par:Alive() then
				self:Remove()

				return
			end

			for k, v in pairs(ents.FindInSphere(Pos, self.Range)) do

				if not DamageBlacklist[v:GetClass()] and IsValid(v:GetPhysicsObject()) and util.QuickTrace(self:GetPos(), v:GetPos() - self:GetPos(), selfg).Entity == v then
					local Dam = DamageInfo()
					Dam:SetDamage(self.Power * math.Rand(.75, 1.25))
					Dam:SetDamageType(DMG_BURN)
					Dam:SetDamagePosition(Pos)
					Dam:SetAttacker(Att)
					Dam:SetInflictor(Infl)
					v:TakeDamageInfo(Dam)

					if vFireInstalled then
						CreateVFireEntFires(v, math.random(1, 3))
					elseif (v:IsOnFire() == false) and (math.random(1, 15) == 1) then
						v:Ignite(math.random(8, 12))
					end
				end
			end

			if vFireInstalled and (math.random(1, 100) == 1) then
				CreateVFireBall(math.random(20, 30), math.random(10, 20), self:GetPos(), VectorRand() * math.random(200, 400), self:GetOwner())
			end

			if math.random(1, 50) == 1 then
				local Tr = util.QuickTrace(Pos, VectorRand() * self.Range, {self})

				if Tr.Hit then
					util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
				end
			end
		end

		if (self.NextEnvThink < Time) then
			self.NextEnvThink = Time + 5
			if (State == STATE_ON) then
				local Tr = util.QuickTrace(self:GetPos(), Vector(0, 0, 9e9), self)
				if not (Tr.HitSky) then
					if (math.random(1, 15) == 1) then
						local Gas = ents.Create("ent_jack_gmod_ezgasparticle")
						Gas:SetPos(self:GetPos() + Vector(0, 0, 100))
						JMod.SetEZowner(Gas, self.EZowner)
						Gas:SetDTBool(0, false)
						Gas:Spawn()
						Gas:Activate()
						Gas.CurVel = (Vector(0, 0, 100) + VectorRand() * 50)
					end
				end
			end
		end

		if self.DieTime < Time then
			self:Remove()

			return
		end

		self:NextThink(Time + (1 / ThinkRate))

		return true
	end
elseif CLIENT then
	function ENT:Initialize()
		local HighVisuals = self:GetHighVisuals()
		self.Ptype = 1

		self.TypeInfo = {
			"Napalm", {Sound("snds_jack_gmod/fire1.wav"), Sound("snds_jack_gmod/fire2.wav")},
			"eff_jack_gmod_heavyfire", 15, 14, 100
		}

		self.CastLight = (HighVisuals and (math.random(1, 4) == 1))
		self.Size = self.TypeInfo[6]
		--self.FlameSprite=Material("mats_jack_halo_sprites/flamelet"..math.random(1,5))
		
		self.Offset = Vector(0, 0, 0)
		self.SizeX = 1
		self.SizeY = 1
		self.NextRandomize = 0
	end

	local GlowSprite = Material("mat_jack_gmod_glowsprite")
	local Col = Color(255, 255, 255, 255)

	function ENT:Draw()
		local Time, Pos = CurTime(), self:GetPos()
		render.SetMaterial(GlowSprite)
		render.DrawSprite(Pos + self.Offset, self.SizeX, self.SizeY, Col)

		if (self.NextRandomize < Time) then
			self.Offset = VectorRand() * self.Size * math.Rand(0, .25)
			self.SizeX = self.Size * math.Rand(.75, 1.25)
			self.SizeY = self.Size * math.Rand(.75, 1.25)
			self.NextRandomize = Time + .2
		end

		if self.CastLight and not GAMEMODE.Lagging then
			local dlight = DynamicLight(self:EntIndex())

			if dlight then
				dlight.pos = Pos
				dlight.r = 255
				dlight.g = 175
				dlight.b = 100
				dlight.brightness = 3
				dlight.Decay = 200
				dlight.Size = 400
				dlight.DieTime = CurTime() + 1
			end
		end
	end
end
