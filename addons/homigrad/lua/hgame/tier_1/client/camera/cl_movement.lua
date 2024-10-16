-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\camera\\cl_movement.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local footPos = Vector()
local footPosSet = Vector()

local footPos2 = Vector()
local footPosSet2 = Vector()

local foott = 1

local velSet = Vector()
local vel = Vector()
local sideLerp = 0

local limit = 1
local land,landSet = Vector(),Vector()

local hg_camera_movement = CreateClientConVar("hg_camera_movement","1",true)

event.Add("PreCalcView","Movement",function(ply,view)
    if VRMODSELFENABLED or not view.forceMovement and (not ply:Alive()) then return end

    local vec = view.vec
    local ang = view.ang

    footPos:LerpFT(0.1,footPosSet)
    footPosSet:LerpFT(0.05)

    footPos2:LerpFT(0.1,footPosSet2)
    footPosSet2:LerpFT(0.25)

    local k = 1 - ScopeLerp * 0.95

    vec:Add(footPos * k):Add(footPos2 * k)

    local rot = Vector(0,0,0):Rotate(ang + Angle(-footPos:Length() * ScopeLerp * 4 + footPosSet2:Length() * ScopeLerp,0,0))
    vec:Add(rot)

    ang[1] = ang[1] - footPos2:Length() / 2
    ang[3] = ang[3] + footPos2:Length() * -foott * (ply:IsSprinting() and 0.35 or 0.5)

    local diff = (ply:GetVelocity():Angle() - ang)
    diff:Normalize()

    local v = CalcSideK(diff[2])

    v = v * math.Clamp(ply:GetVelocity():Length() / (512 * (1 - ScopeLerp * 0.25) * (view.mulSide or 1)),0,1)

    sideLerp = LerpFT(0.25,sideLerp,v)

    ang[3] = ang[3] - 15 * sideLerp

    velSet:LerpFT(0.25, ply:GetVelocity():Div(55))
    vel:LerpFT(0.1,velSet)
    vel:Clamp(-limit,limit,-limit,limit,-limit,limit)
    
    vec:Add(vel:Mul(1 - ScopeLerp * 0.95))

    vel[3] = 0--fuck you!
    
    view.fov = view.fov + 1 * (vel:Length() / limit)

    vec:Add(land:Clone():Clamp(-10,10,-10,10,-10,10))

    ang[1] = ang[1] + land:Length() / 3

    land:LerpFT(0.25,landSet)
    landSet:LerpFT(0.5)
end,1)

local Rand = math.Rand

event.Add("Footstep","Camera",function(ply,pos,foot)
    if ply ~= LocalPlayer() then return end

    if foot == 0 then foot = -1 end

    foott = foot

    footPosSet = EyeAngles():Right() * (-foot * Rand(0.9,1.25)) - Vector(0,0,Rand(2,3)) - EyeAngles():Forward() * (Rand(1,2) * -foot)
    footPosSet:Mul(ply:IsSprinting() and 4 or 1)

    footPosSet2 = Vector(0,0,-Rand(1,2))
    footPosSet2:Mul(ply:IsSprinting() and 4 or 1)
end,-1)


event.Add("Landing","Camera",function(ply,inWater,onFloat,speed)
    if ply ~= LocalPlayer() then return end

    landSet:Add(ply:GetVelocity():Div(25))
end,-1)