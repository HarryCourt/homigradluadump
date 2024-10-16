-- "addons\\advancedsentinelsystem\\lua\\effects\\eff_minigun_nozzleflash.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local lifetime = 0.1
local lifetimeinv = 1/lifetime

function EFFECT:Init(data)
	local ent = data:GetEntity()
	local att = data:GetAttachment()
	self.LifeTime = CurTime() + lifetime
	
	if(!IsValid(ent)) then self:Remove() return end

	if(ent:IsWeapon() && ent:IsCarriedByLocalPlayer()) then
		local ply = ent:GetOwner()

		if(!ply:ShouldDrawLocalPlayer()) then
			local vm = ply:GetViewModel()
			
			if(IsValid(vm)) then
				ent = vm
			end
		end
	end
	
	
	if !IsValid(ent) then self:Remove() return end
	self.Rozgrzanie = data:GetMagnitude()

	self.Ent = ent
	self.Att = att

	self:SetPos(self:GetGoodPos())
	self:SetRenderBounds(Vector(-32,-32,-32), Vector(32,32,32))

	self.Size = math.Rand(0.8, 2)

	local emitter = ParticleEmitter(self:GetPos(), false)

	if emitter then
		local frwd = ent:GetAttachment(att).Ang:Forward()
		for i = 1, self.Size do
			local particle = emitter:Add("sprites/baku_impactor_smoke", self:GetPos())
			particle:SetVelocity( vector_up * 20 + VectorRand() * 10 + frwd * 40)
			particle:SetDieTime( 0.2 * self.Size + 0.3 * self.Rozgrzanie )
			particle:SetStartAlpha( 2 * self.Size + 3 * self.Rozgrzanie )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 4 * self.Size + 3 * self.Rozgrzanie)
			particle:SetEndSize( 0 )
			//particle:SetColor(self.Colore:Unpack())
			particle:SetGravity( Vector( 0, 0, 100 ) )
			particle:SetCollide( true )
			particle:SetRoll(20)
		end

		if self.Rozgrzanie > 0.5 then
			for i = 1, math.random(1, (self.Rozgrzanie - 0.5) * 4) do
				local particle = emitter:Add("sprites/bakuglow", self:GetPos() + VectorRand() * 3)
				particle:SetVelocity( frwd * 200 + VectorRand() * 40)
				particle:SetDieTime( 0.2 * self.Size + 0.3 * self.Rozgrzanie )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 0.4 * self.Size + 0.3 * self.Rozgrzanie)
				particle:SetEndSize( 0 )
				particle:SetColor(255,151,0,255)
				particle:SetGravity( Vector( 0, 0, -300 * (i-1) ) )
				particle:SetCollide( true )
				particle:SetRoll(20)
			end
		end
		emitter:Finish()
	end
end

function EFFECT:GetGoodPos()
	return self.Ent:GetAttachment(self.Att).Pos
end

function EFFECT:Think()
	return self.LifeTime > CurTime()
end

local mat1 = Material("sprites/bakuglow")
local mat2 = Material("sprites/baku_burntcer")
local mat3 = Material("sprites/baku_impactor")
local color1 = Vector(0.7, 0.8, 0.7)
local color2 = Vector(1, 0.8, 0.3)

function EFFECT:Render()
	if !IsValid(self.Ent) then return end

	local x = (self.LifeTime - CurTime()) * lifetimeinv
	local y = math.sin(x * 3.14) * 0.5 + 0.5
	local z = (1 - x) * (1 - x)
	local s = x * self.Size * 10
	local frwd = self.Ent:GetAttachment(self.Att).Ang:Forward()
	local pos = self:GetGoodPos()

	render.SetMaterial(mat1)
	render.DrawSprite(pos, s, s, color2:ToColor())

	render.SetMaterial(mat2)
	render.DrawBeam(pos, pos + frwd * 60 * y * self.Size, 15 * z * self.Size, 1, 0, color1:ToColor())

	render.SetMaterial(mat3)
	render.DrawBeam(pos, pos + frwd * 40 * y * self.Size, 10 * y * self.Size, 0, 1, color1:ToColor())

end