-- "addons\\homigrad_core\\lua\\shlib\\tier_2_world\\render\\particles_light_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local min,max = math.min,math.max

local calculateLightMin,calculateLightMax
cvars.CreateOption("hg_particle_calculatelight_min","0.4",function(value) calculateLightMin = tonumber(value) end,0,1)
cvars.CreateOption("hg_particle_calculatelight_max","0.5",function(value) calculateLightMax = tonumber(value) end,0,1)

local changeColorMin,changeColorMax
cvars.CreateOption("hg_particle_changecolor_min","0.1",function(value) changeColorMin = tonumber(value) end,0,1)
cvars.CreateOption("hg_particle_changecolor_max","0.25",function(value) changeColorMax = tonumber(value) end,0,1)

local Rand,random = math.Rand,math.random

local clamp = math.Clamp

local t = 0.75

ParticleLight_Slow = function(self)
    local Time = CurTime()//ВААААУ ОН РАБОТАЕТ ПО CURTIME СИГМА ЕБАНЫЙ ДОЛБАЁБ ГОРИ В АДУ НАХУЙ

    if (self.nextCL or 0) <= Time then//nextCalculateLight
        self.nextCLD = Rand(calculateLightMin,calculateLightMax)//nextCalculateLightDelay
        self.nextCL = Time + self.nextCLD

        local r,g,b = self.r,self.g,self.b

        if not r then
            r,g,b = self:GetColor()

            self.r = r
            self.g = g
            self.b = b
        end

        local t = self:GetLifeTime() / self:GetDieTime()
        local matrix = LightCalculate(self:GetPos(),Lerp(t,self:GetStartSize(),self:GetEndSize()) / 2)
        local r,g,b = LightApply(matrix,r,g,b,Lerp(t,self:GetStartAlpha(),self:GetEndAlpha()) / 255 * self.LightFlashMul)

        self.sR = r
        self.sG = g
        self.sB = b
    end

    local r,g,b = self:GetColor()

    local t = t
    if not self.firstColorTime then t = 1 self.firstColorTime = true end//чтоб при спавне сразу сетать ему цвет

    self:SetColor(Lerp(t,r,self.sR),Lerp(t,g,self.sG),Lerp(t,b,self.sB))
    
    self:SetNextThink(Time + Rand(changeColorMin,changeColorMax))
end

ParticleLight_Fast = function(self)
    local Time = CurTime()

    local r,g,b = self.r,self.g,self.b

    if not r then
        r,g,b = self:GetColor()

        self.r = r
        self.g = g
        self.b = b
    end

    local t = self:GetLifeTime() / self:GetDieTime()
    local matrix = LightCalculate(self:GetPos(),Lerp(t,self:GetStartSize(),self:GetEndSize()) / 2)
    local r,g,b = LightApply(matrix,r,g,b,Lerp(t,self:GetStartAlpha(),self:GetEndAlpha()) / 255 * self.LightFlashMul)

    self.sR = r
    self.sG = g
    self.sB = b

    local r,g,b = self:GetColor()
    
    local t = t
    if not self.firstColorTime then t = 1 self.firstColorTime = true end//чтоб при спавне сразу сетать ему цвет

    self:SetColor(Lerp(t,r,self.sR),Lerp(t,g,self.sG),Lerp(t,b,self.sB))

    self:SetNextThink(Time)
end