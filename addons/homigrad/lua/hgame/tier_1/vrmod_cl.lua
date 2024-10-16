-- "addons\\homigrad\\lua\\hgame\\tier_1\\vrmod_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
vrmod = vrmod or {}
vrmod.hooksSelf = vrmod.hooksSelf or {}

if not vrmod.IsPlayerInVR then
    vrmod.IsPlayerInVR = function() return false end
end

g_VR = g_VR or {}

local empty = function() end

local function checkSelf()
    if g_VR.active then
        VRMODSELFENABLED = true

        for name,hook in pairs(vrmod.hooksSelf) do hook[1]() end
    else
        VRMODSELFENABLED = nil

        for name,hook in pairs(vrmod.hooksSelf) do hook[2]() end
    end
end

function vrmod.hookSelf(name,enable,disable)
    vrmod.hooksSelf[name] = {enable or empty,disable or empty}

    checkSelf()
end

vrmod.hooks = vrmod.hooks or {}

local function check()
    VRMODENABLED = nil

    for i,ply in pairs(player.GetAll()) do
        if vrmod.IsPlayerInVR(ply) then
            VRMODENABLED = true
        end
    end

    if VRMODENABLED then
        for name,hook in pairs(vrmod.hooks) do hook[1]() end
    else
        for name,hook in pairs(vrmod.hooks) do hook[2]() end
    end
end

function vrmod.hook(name,enable,disable)
    vrmod.hooks[name] = {enable or empty,disable or empty}

    check()
end

event.Add("Init NET","VRMOD",function() check() end)

if Initialize then
    check()
    checkSelf()
end

hook.Add("VRMOD Enable","Hooks Homigrad",function(ply)
    for name,hook in pairs(vrmod.hooksSelf) do hook[1]() end

    VRMODSELFENABLED = true

    check()
end)

hook.Add("VRMOD Disable","Hooks Homigrad",function(ply)
    for name,hook in pairs(vrmod.hooksSelf) do hook[2]() end

    VRMODSELFENABLED = nil

    check()
end)

//

function VRUIOpen(id,w,h,scale)//наврятле буду юзать.... // VRUIPopup
    local tmp = Angle(0,g_VR.tracking.hmd.ang.yaw-90,45)
    local pos, ang = WorldToLocal(g_VR.tracking.pose_righthand.pos + tmp:Forward()*-9 + tmp:Right()*-11 + tmp:Up()*-7, tmp, g_VR.origin, g_VR.originAngle)
    
    if IsValid(VRPANEL) then VRPANEL:Remove() end
    
    VRPANEL = oop.CreatePanel("v_panel")
    VRPANEL:SetSize(w,h)

    /*function VRPANEL:Draw(w,h)
        surface.SetDrawColor(255,0,0)
        surface.DrawRect(0,0,w,h)
    end*/
    
    VRUtilMenuClose(id)//мать трахал твою
    VRUtilMenuOpen(id,w,h,VRPANEL,4,pos,ang,scale,true,function()
    
    end)

    return VRPANEL
end

/*if IsValid(VRPANEL) then VRPANEL:Remove() end
    
VRPANEL = oop.CreatePanel("v_frame"):setSize(512,125):ad(function(self,w,h) self:setPos(w / 2 - self:W() / 2,h / 2 - self:H() / 2) end)

function VRPANEL:Draw(w,h)
    surface.SetDrawColor(60,60,60)
    surface.DrawRect(0,0,w,h)
end*/
