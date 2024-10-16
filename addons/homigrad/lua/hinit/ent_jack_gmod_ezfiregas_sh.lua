-- "addons\\homigrad\\lua\\hinit\\ent_jack_gmod_ezfiregas_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿local ENT = oop.Reg("ent_jack_gmod_ezfiregas","base_entity")
if not ENT then return end

ENT.PrintName = "EZ fire Gas"
ENT.Author = "Jackarunda"

ENT.NoSitAllowed = true
ENT.Editable = false
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.EZgasParticle = true

local max = math.max

if SERVER then
	function ENT:Initialize()
		local Time = CurTime()
		self.LifeTime = math.random(50, 100)
		self.DieTime = Time + self.LifeTime
		self:SetModel("models/dav0r/hoverball.mdl")
		self:SetMaterial("models/debug/debugwhite")
		self:RebuildPhysics()
		self:DrawShadow(false)
		self.NextDmg = Time + 3

		self:SetNWFloat("Size",200)
	end

	function ENT:ShouldDamage(ent)
		if not IsValid(ent) then return end

		if ent:IsPlayer() then
			if not ent:Alive() or ent.ProtectFireGas or ent:HasGodMode() then return false end
			
			for i,armor in pairs(ent.EZarmor.items) do
				if JMod.ArmorTable[armor.name].def[DMG_NERVEGAS] and not armor.tgl then return false end
			end

			return true
		end

		return false
	end

	function ENT:CanSee(ent,pos)
		local Tr = util.TraceLine({
			start = self:GetPos(),
			endpos = pos,
			filter = {self,ent},
			mask = MASK_SHOT
		})

		return not Tr.Hit
	end

	function ENT:Think()
		local Time, SelfPos = CurTime(), self:GetPos()

		if self.DieTime < Time then
			self:Remove()

			return
		end

		local Force = VectorRand() * 2

		for key, obj in pairs(ents.FindInSphere(SelfPos,self:GetNWFloat("Size"))) do
			if obj == self then continue end

			obj = RagdollOwner(obj) or obj

			if obj:IsPlayer() then
				if not self:CanSee(obj,obj:EyePos()) then continue end
			elseif not self:CanSee(obj,obj:GetPos()) then continue end 
			
			if obj.EZgasParticle then
				local Vec = obj:GetPos()
				Vec:Sub(SelfPos)
				Vec:Normalize()
				Vec:Mul(40)

				Force:Sub(Vec)
			elseif self:ShouldDamage(obj) then
				if IsValid(obj.fakeEnt) then
					if obj.Otrub or math.random(1,4) == 4 then
						if not obj.Otrub then JMod.TryCough(obj) end
						
						obj.o2 = max(obj.o2 - 0.15,0)
						obj.o2Stun = CurTime() + 3
					end
				else
					if not obj.Otrub then JMod.TryCough(obj) end

					obj.o2 = max(obj.o2 - 0.15,0)
					obj.o2Stun = CurTime() + 3
				end
			end
		end

		self:Extinguish()

		local Phys = self:GetPhysicsObject()
		Phys:SetVelocity(Phys:GetVelocity() * .3)
		Phys:ApplyForceCenter(Force + Vector(0,0,50))

		self:NextThink(Time + math.Rand(2,3))

		return true
	end

	function ENT:RebuildPhysics()
		local size = 1

		self:PhysicsInitSphere(size, "gmod_silent")
		self:SetCollisionBounds(Vector(-.1, -.1, -.1), Vector(.1, .1, .1))
		self:PhysWake()
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		local Phys = self:GetPhysicsObject()
		Phys:SetMass(1)
		Phys:EnableGravity(false)
		Phys:SetMaterial("gmod_silent")
	end

	local TraceLine = util.TraceLine
	
	function ENT:PhysicsCollide(data,physobj)
		if (self.delayHitSky or 0) < CurTime() then
			self.delayHitSky = CurTime() + 0.1

			local tr = {
				start = data.HitPos,
				endpos = data.HitPos
			}

			if TraceLine(tr).HitSky then timer.Simple(0,function() self:Remove() end) end
		end

		self:GetPhysicsObject():ApplyForceCenter(-data.HitNormal * 100)
	end

	function ENT:OnTakeDamage(dmginfo) end
	function ENT:Use(activator, caller) end
	function ENT:GravGunPickupAllowed(ply) return false end
elseif CLIENT then
	local Mat = Material("particle/smokestack")

	HomigradGas = HomigradGas or {}

	function ENT:Initialize()
		self.delayEmit = RealTime()
		
		HomigradGas[#HomigradGas + 1] = self
		self.ID = #HomigradGas
	end

	function ENT:OnRemove()
		table.remove(HomigradGas,self.ID)
	end

	local SetMaterial = render.SetMaterial
	local DrawSprite = render.DrawSprite

	local angZero = Angle(0,0,0)
	local size = Vector(3,3,3)

	local developer = GetConVar("developer")

	local cos = math.cos
	local sin = math.sin
	
	local vecChange = Vector()
	local SetDrawColor = surface.SetDrawColor

	local random,Rand = math.random,math.Rand

	local tr = {}
	local TraceLine = util.TraceLine

	function ENT:DrawTranslucent()
		if developer:GetFloat() == 33 then
			local size = self:GetNWFloat("Size",10) / 10

			render.DrawWireframeBox(self:GetPos(),angZero,-Vector(size,size,size),Vector(size,size,size))
		end

		local time = RealTime()
		if self.delayEmit > time then return end
		self.delayEmit = time + Rand(0.9,1.25)

		local pos = self:GetPos()

		tr.start = pos

		local pos2 = pos:Clone()
		pos2[3] = pos2[3] - 500

		tr.endpos = pos2

		tr = TraceLine(tr)

		local k = 1 - tr.Fraction / 2
		if k <= 0 then return end

		local size = self:GetNWFloat("Size",10)
		local emitter = ParticleEmitter(pos)
		local gravity = ParticleGravity / 6

		for i = 1,random(2,3) do
			local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
			if not part then continue end
	
			local dir = Vector(1,0,0):Rotate(Angle(Rand(-75,75),Rand(-180,180),0)):Mul((size * 5 + Rand(-125,125)) * k)
			dir:Rotate(Angle(Rand(-75,75),Rand(-125,125),0))
	
			part:SetDieTime(Rand(8,9))
			local r = Rand(20,30)
			part:SetColor(r,r,r)
	
			part:SetStartAlpha(random(125,222) * k) part:SetEndAlpha(0)
			part:SetStartSize(Rand(size / 3,size / 2)) part:SetEndSize(size * 1.5 + Rand(-50,50))
	
			part:SetCollide(true)
			part:SetLighting(true)
	
			part:SetRoll(Rand(-6000,6000))
			part:SetVelocity(dir) part:SetAirResistance(Rand(275,300) * k)
			part:SetBounce(0.5)
			part:SetGravity(gravity)
			part:SetPos(pos)
		end

		emitter:Finish()
	end

	local NextThink = 0
	local SetDis,Dis = 0,0

	local TraceLine = util.TraceLine
	local tr = {mask = MASK_SHOT,filter = {}}
	local id

	local min = math.min

	local Max = 400

    local GradientUp,GradientDown = draw.GradientUp,draw.GradientDown
    local SetBG,BGScale = surface.SetBG,draw.BGScale
	local random,Rand = math.random,math.Rand
	local abs,cos,sin = math.abs,math.cos,math.sin
	local Clamp = math.Clamp

	hook.Add("HUDPaint","Gas",function()
		local Time = CurTime()

		if not id and NextThink < Time then
			NextThink = Time + 0.25

			id = 1
			SetDis = Max
		end

		if id then
			local pos = LocalPlayer():GetPos()

			tr.start = pos
			tr.filter[1] = LocalPlayer()

			local start = SysTime()

			while true do
				if start - SysTime() > 1 / 10 then break end

				local ent = HomigradGas[id]
				if ent and not IsValid(ent) then table.remove(HomigradGas,id) continue end

				if not ent then
					id = nil
					SetDis = 1 - (SetDis / Max)

					break
				end

				local posEnt = ent:GetPos()
				tr.endpos = posEnt
				tr.filter[2] = ent

				if not TraceLine(tr).Hit then
					local dis = posEnt:Distance(pos)

					if SetDis > dis then SetDis = dis end
				end

				id = id + 1
			end
		end
		
		Dis = LerpFT(0.25,Dis,math.min(SetDis * 2,1))

		local w,h = ScrW(),ScrH()

		surface.SetDrawColor(25,25,25,150 * Dis)
		surface.DrawRect(0,0,w,h)

		for i = 4,5 do
			SetBG("points" .. i .. "0")
	
			BGScale(0,0,w,h,Clamp(abs(cos(Time + Rand(-1,1))) * 25,10,25))
		end

		local size = h / 2

		surface.SetDrawColor(0,0,0,255 * Dis)

        GradientUp(0,0,w,size)
        GradientDown(0,h - size,w,size + 1)
	end)
end