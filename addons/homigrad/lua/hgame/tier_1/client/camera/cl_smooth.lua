-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\camera\\cl_smooth.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local forwardPos = Vector()
local forwardPos2 = Vector()

local oldAng = Angle()

local imersiveAng = Angle()
local imersiveAngSet = Angle()

local hg_camera_smooth = true// CreateClientConVar("hg_camera_smooth","1",)

function BounceLerp(t,t2,to,from,vel,tt)
    local ft = math.Clamp(FrameTime(),0,0.25) * tt
    local apply = (from - to):Mul(t)

    vel:Add(apply)
    to:Add(vel * ft)
    vel:Sub(apply * t2)
end

event.Add("PreCalcView","Smooth",function(ply,view)
    view.imersiveSetL = 0.8
    view.imersiveL = 0.2
    
    view.forwardL = 0.5
    view.forwardSubL = 0.4
    view.forwardMul = 6
    view.forwardSubMul = 3
end,-4)

event.Add("PreCalcView","Smooth",function(ply,view)
    if VRMODSELFENABLED or not view.forceSmooth and view.noSmooth then return end

    local angStart = view.ang:Clone()
    local diff = angStart:Forward() - oldAng:Forward()

    view.forwardDiff = diff

	forwardPos:Add(diff):LerpFT(view.forwardL)
    forwardPos2:Add(diff):LerpFT(view.forwardSubL)

    local vec = view.vec
    vec:Add(forwardPos * view.forwardMul)
    vec:Sub(forwardPos2 * view.forwardSubMul)

    view.fov = view.fov + forwardPos:Length()
    local ang = view.ang

    ang[3] = ang[3] + forwardPos2:Dot(ang:Right()) * 5

    local diff = angStart - oldAng
    diff:Normalize()

    view.angDiff = diff

    imersiveAngSet:Add(diff)
    local len = imersiveAngSet:Length()

    imersiveAngSet:LerpFT(view.imersiveSetL * math.max((len - 8),1) * (LocalPlayer():IsSprinting() and 5 or 1))
    imersiveAng:LerpFT(view.imersiveL,imersiveAngSet)

    ang:Sub(imersiveAng)

    oldAng = angStart
end,2)