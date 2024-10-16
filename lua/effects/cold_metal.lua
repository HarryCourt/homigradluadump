-- "lua\\effects\\cold_metal.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function EFFECT:Init( data )
	
	self.StartPos = data:GetOrigin()
	
	self.Dir = data:GetNormal()
	
	self.LifeTime 	= 1
	
	self.DieTime 	= CurTime() + self.LifeTime
	
	self.Mult = 0.2
	
	self.Gravity 	= Vector(0, 0, -GetConVarNumber("sv_gravity",800))
	
	self.FleckLife = 3
	
	local emitter = ParticleEmitter(self.StartPos)

	for i = 1, 15 do
	
		local particle = emitter:Add("particle/smokesprites_0004", self.StartPos)
		
		particle:SetVelocity((self.Dir + VectorRand(-50,50) * 0.5) * math.Rand(0, 1)*30)
		particle:SetDieTime(math.Rand(0.25, 1))
		particle:SetStartAlpha(25)
		particle:SetStartSize(math.Rand(5, 30))
		particle:SetEndSize(math.Rand(5,30))
		particle:SetRoll(math.random(-1,1))
        particle:SetRollDelta(math.random(0,1))
		particle:SetGravity(-self.Gravity)
		particle:SetColor(190, 190, 255)
		particle:SetCollide(true)
		particle:SetAirResistance(600)
		particle:SetVelocityScale(true)
		particle:SetCollide(true)
	end

    local particle = emitter:Add("sprites/heatwave", self.StartPos)
		
		particle:SetVelocity((self.Dir + VectorRand() * 0.5) * 10)
		particle:SetDieTime(math.Rand(0.25, 1))
		particle:SetStartAlpha(math.random(1,10))
		particle:SetStartSize(20)
		particle:SetEndSize(1)
        particle:SetRoll(math.Rand(-360,360))
        particle:SetRollDelta(math.Rand(-1,1))
		particle:SetAirResistance(600)
		particle:SetVelocityScale(true)
		particle:SetCollide(false)
				
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
	return false
end

effects.Register( EFFECT, "cold_metal" )