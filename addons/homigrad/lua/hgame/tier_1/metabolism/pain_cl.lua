-- "addons\\homigrad\\lua\\hgame\\tier_1\\metabolism\\pain_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local grtodown = Material( "vgui/gradient-u" )
local grtoup = Material( "vgui/gradient-d" )
local grtoright = Material( "vgui/gradient-l" )
local grtoleft = Material( "vgui/gradient-r" )

local ScrW,ScrH = ScrW,ScrH
local math_Clamp = math.Clamp
local k = 0
local k4 = 0
local time = 0

local old

local nigger = Color(0,0,0,255)

local pulseStart = 0

event.Add("DSP","Otrub",function()
    local ply = LocalPlayer()

    if ply:Alive() and ply:GetNWBool("Otrub") then return 16 end
end)

hook.Add("PreDrawHUD","PainEffect",function()
    local ply = LocalPlayer()
    if not ply:Alive() then return end
    
    local painlosing = ply:GetNWFloat("painlosing",0)

    if painlosing > 0 then
        DrawMotionBlur(0.8,painlosing / 3,0.016)
    end

    local active = ply:GetNWBool("Otrub")

    cam.Start2D()

    render.ClearStencil()

    if active then
        surface.SetDrawColor(0,0,0,255)
        surface.DrawRect(0,0,ScrW(),ScrH())

        local pulse = ply:GetNWFloat("pulse",0)

        if pulse ~= 0 and pulseStart + pulse * 60 < RealTime() then
            pulseStart = RealTime()

            surface.PlaySound("snd_jack_hmcd_heartpound.wav")
        end
    end

    local w,h = ScrW(),ScrH()
    k = Lerp(0.1,k,math_Clamp(ply:GetNWFloat("pain") / 100,0,15))

    surface.SetMaterial(grtodown)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(0,0,w,h * k)

    surface.SetMaterial(grtoup)
    surface.SetDrawColor(0, 0, 0, 255 )
    surface.DrawTexturedRect(0,h - h * k,w,h * k + 1)

    surface.SetMaterial(grtoright)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(0,0,w * k,h)

    surface.SetMaterial(grtoleft)
    surface.SetDrawColor(0,0,0,255)
    surface.DrawTexturedRect(w - w * k,0,w * k + 1,h)

    cam.End2D()
end)