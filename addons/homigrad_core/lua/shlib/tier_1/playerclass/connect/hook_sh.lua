-- "addons\\homigrad_core\\lua\\shlib\\tier_1\\playerclass\\connect\\hook_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local classList = player.classList

event.Add("Footstep","PlayerClass",function(ply,...) return ply:PlayerClassEvent("PlayerFootstep",...) end)
event.Add("Move","PlayerClass",function(ply,mv) return ply:PlayerClassEvent("Move",mv) end)

if SERVER then return end

net.Receive("setupclass",function()
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end--lol

    ply.PlayerClassName = net.ReadString()
    ply.PlayerClassNameOld = net.ReadString()

    old = classList[ply.PlayerClassNameOld]
    if old and old.Off then old.Off(ply) end
    
    ply:PlayerClassEvent("On")
end)

event.Add("PreCalcView","PlayerClass",function(ply,vec,ang,fov,znear,zfar)
    return ply:PlayerClassEvent("CalcView",vec,ang,fov,znear,zfar)
end)

hook.Add("PreDrawPlayer","PlayerClass",function(ply,flag) return ply:PlayerClassEvent("PlayerDraw",flag) end)

hook.Add("HUDPaint","PlayerClass",function() LocalPlayer():PlayerClassEvent("HUDPaint") end)
hook.Add("PlayerStartVoice","PlayerClass",function() LocalPlayer():PlayerClassEvent("PlayerStartVoice") end,-2)
hook.Add("PlayerEndVoice","PlayerClass",function() LocalPlayer():PlayerClassEvent("PlayerEndVoice") end,-2)

event.Add("Footstep","PlayerClass",function(ply,pos,foot,snd,volume,filter) ply:PlayerClassEvent("PlayerFootstep",pos,foot,snd,volume,filter) end,-2)

hook.Add("Suppress","PlayerClass",function(k) LocalPlayer():PlayerClassEvent("Suppress",k) end)
hook.Add("Camera Shake Damage","PlayerClass",function(addAng) LocalPlayer():PlayerClassEvent("CameraShakeDamage",addAng) end)