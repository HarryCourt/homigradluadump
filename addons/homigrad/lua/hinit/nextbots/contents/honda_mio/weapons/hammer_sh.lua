-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\honda_mio\\weapons\\hammer_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Get("npc_honda_mio")
if not ENT then return end

local Hammer = {}
ENT.Weapons.Hammer = Hammer

function Hammer.Attack(ent)

end

local hammer_up1 = Material("homigrad/scp/honda_mio/hammer_up.png")
local hammer_up2 = Material("homigrad/scp/honda_mio/hammer_up2.png")
local hammer = Material("homigrad/scp/honda_mio/hammer.png")
local hammer_down = Material("homigrad/scp/honda_mio/hammer_down.png")

local patternPos = {
    Vector(0,5,-5),
    Vector(0,10,-30),
    Vector(0,-0,0),
    Vector(0,-10,-25)
}

local patternRot = {
    45,
    -25,
    90 - 45,
    90 + 25
}

local pattern = {
    1,
    1,
    -1,
    -1
}

function Hammer.Draw(self,pos,normal,size,color,rot)
    render.SetMaterial(self.Frame > 2 and hammer_up2 or hammer_up1)
    local k = self.FrameL

    local side = pattern[self.Frame]

    size = size * 0.7

    local k = math.Clamp(self:GetNWFloat("AttackPre",0) - CurTime() + 0.25,0,1) / 0.25

    render.DrawQuadEasy(pos - normal * 15 + patternPos[self.Frame]:Clone():Add(Vector(0,0,25 * k)):Rotate(normal:Angle()),normal,size,size,color,rot - 45 + patternRot[self.Frame] + math.cos(CurTime() * 15) * 5 + k * 125 * side)
end

Hammer.AttackDelay = 0.3

function Hammer.AttackEntPre(self,ent)
    local path = "homigrad/scp/honda_mio/twroh" .. math.random(1,3) .. ".wav"
    for i = 1,3 do self:PlaySND(path,ent) end
end

function Hammer.AttackEnt(self,ent)
    local pos = ent:GetPos()

    blood_Explode(pos,pos + Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
    
    local path = "homigrad/scp/honda_mio/hammer_hit" .. math.random(1,2) .. ".wav"
    for i = 1,3 do self:PlaySND(path,ent) end

    net.Start("kevin impact")
    net.WriteVector(pos)
    net.Broadcast()
end