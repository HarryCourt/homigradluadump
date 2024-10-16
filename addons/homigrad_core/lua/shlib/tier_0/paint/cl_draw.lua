-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\paint\\cl_draw.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local gradient_left = Material("homigrad/vgui/gradient_left.png")
local gradient_right = Material("homigrad/vgui/gradient_right.png")
local gradient_up = Material("homigrad/vgui/gradient_up.png")
local gradient_down = Material("homigrad/vgui/gradient_down.png")

local SetMaterial = surface.SetMaterial
local DrawTexturedRect = surface.DrawTexturedRect

function draw.GradientDown(x,y,w,h)
    SetMaterial(gradient_down)
    DrawTexturedRect(x,y,w,h)
end

function draw.GradientUp(x,y,w,h)
    SetMaterial(gradient_up)
    DrawTexturedRect(x,y,w,h)
end

function draw.GradientRight(x,y,w,h)
    SetMaterial(gradient_right)
    DrawTexturedRect(x,y,w,h)
end

function draw.GradientLeft(x,y,w,h)
    SetMaterial(gradient_left)
    DrawTexturedRect(x,y,w,h)
end

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect

cframe1 = Color(255,255,255,15)
cframe2 = Color(0,0,0,125)

function draw.Frame(x,y,w,h,color1,color2,corner)
    corner = corner or 1
    
    if color1 then
        SetDrawColor(color1.r,color1.g,color1.b,color1.a)


        DrawRect(x,y,w,corner)
        DrawRect(x,y,corner,h)
    end

    if color2 then
        SetDrawColor(color2.r,color2.g,color2.b,color2.a)

        DrawRect(x,y + h - corner,w,corner)
        DrawRect(x + w - corner,y,corner,h)
    end
end

hook.Add("HUDPaint","Homigrad",function()
    event.Call("HUDPaint",LocalPlayer(),CurTime())
end)

hook.Add("Initialize","ScrWscrH",function()
    scrw = ScrW()
    scrh = ScrH()
end)

scrw = ScrW()
scrh = ScrH()

ScreenR = ScrW() / ScrH()

hook.Add("OnScreenSizeChanged","Fuck",function(oldw,oldh,w,h)
    scrw = ScrW()
    scrh = ScrH()

    ScreenR = ScrW() / ScrH()
end)

concommand.Add("hg_fakescreenwh",function(ply,cmd,args)
    scrw = tonumber(args[1] or ScrW()) or ScrW()
    scrh = tonumber(args[2] or ScrH()) or ScrH()
end)

FindMetaTable("Vector").ToScreen2 = function(self)
    local pos = self:ToScreen()

    pos.x = pos.x * (ScrW() / scrw)
    pos.y = pos.y * (ScrH() / scrh)

    return pos
end

local oldX,oldY = gui.MouseX(),gui.MouseY()
local oldFocus = false
local delay = 0

mousedx = 0
mousedy = 0

mousex = 0
mousey = 0

wheel = 0

hook.Add("Think","!!!!SHLib Interface",function()
    IsWindow = not system.HasFocus()

    local x,y = gui.MouseX(),gui.MouseY()
    local focus = system.HasFocus()
    local time = CurTime()

    if oldFocus ~= focus then
        if focus then delay = time + 0.25 end

        InWindowTime = time
        InWindow = focus
        
        hook.Run("Window",focus)

        oldFocus = focus
    end

    if focus and delay < time then
        mousedx = oldX - x
        mousedy = oldY - y

        mousex = x
        mousey = y
    end

    oldX = x
    oldY = y

    wheel = 0
end,-2)

hook.Add("StartCommand","Wheel",function(ply,cmd)
    local _wheel = cmd:GetMouseWheel()
    
    if wheel == 0 then wheel = _wheel end
end)

EntityIconChache = EntityIconChache or {}

function EntityIcon(name)
    local mat = EntityIconChache[name]

	if not mat then
        mat = Material("entities/" .. tostring(name) .. ".png","GAME")

        EntityIconChache[name] = mat
	end

	return mat
end