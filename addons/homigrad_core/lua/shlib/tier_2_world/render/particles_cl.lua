-- "addons\\homigrad_core\\lua\\shlib\\tier_2_world\\render\\particles_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ParticlesList = ParticlesList or {}
local ParticlesList = ParticlesList

local meta = FindMetaTable("CLuaEmitter")
local meta_Add = meta.Add
local meta_Finish = meta.Finish

local example = {}

function example:Remove()
    if self.removed then return end
    self.removed = true

    ParticlesList[self] = nil

    if self.OnRemove then self:OnRemove() end
    
    self:SetDieTime(0)
end

function example:ThinkFunction()
    self:Think()
    self:LightFunc()
end

function example:Think() end

function example:IsValid()
    return self:GetDieTime() < CurTime()
end

example.MulLight = 1
local empty = function() end

function example:SetLight(value)
    if value == 1 then
        self.LightFunc = ParticleLight_Slow
    elseif value == 2 then
        self.LightFunc = ParticleLight_Fast
    else
        self.LightFunc = empty
 
        self.NoLight = true//х3 зачем
    end
end

local exampleEmit = {}

function exampleEmit:Add(mat,pos)
    local part = meta_Add(self.original,mat,pos)
    ParticlesList[part] = true
    
    part.create = CTime
    
    for k,v in pairs(example) do part[k] = v end
    part:SetNextThink(CTime)
    part:SetThinkFunction(part.ThinkFunction)

    part:SetLight(self.light)
    part.LightFlashMul = 1

    return part
end

function exampleEmit:Finish() meta_Finish(self.original) end
function exampleEmit:SetLight(value) self.light = value end

function ParticleEmit(pos)
    local obj = {}
    obj.original = ParticleEmitter(pos)

    for k,v in pairs(exampleEmit) do obj[k] = v end

    obj:SetLight(1)

    return obj
end

local random,Rand = math.random,math.Rand

concommand.Add("hg_particle",function(ply,cmd,args)
    local tr =  LocalPlayer():GetEyeTrace()
    local pos = tr.HitPos + tr.HitNormal * 25
    
    local emitter = ParticleEmit(pos)
    
    for i = 1,((args[1] and tonumber(args[1])) or 750) do
        local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)

        if part then
            part:SetDieTime(Rand(9,11))
    
            part:SetStartAlpha(200)
            part:SetEndAlpha(0)
    
            part:SetStartSize(125)
            part:SetEndSize(100)
    
            part:SetGravity(Vector(0,0,0))
            part:SetVelocity(Vector(Rand(-75,75) * Rand(0.5,2),Rand(-75,75) * Rand(0.5,2),Rand(-5,5)))
            part:SetCollide(true)
            part:SetBounce(0.25)
        end
    end
    
    emitter:Finish()
end)

local delay = 0

hook.Add("Think","ParticlesList",function()
    local time = CTime
    if delay > time then return end
    delay = time + 0.25

    for part in pairs(ParticlesList) do--меня убъют на районе за такое блядь
        if not IsValid(part) then part:Remove() end
    end
end)

hook.Add("PostCleanupMap","ParticlesList",function()
    for part in pairs(ParticlesList) do part:Remove() end
end)