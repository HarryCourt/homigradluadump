-- "addons\\homigrad\\lua\\hgame\\tier_1\\metabolism\\underwater_seat_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function uragmodlibutorganisomfa()
    local tbl = {
        ["Ballon O2"] = {
            PrintName = "Ballon O2",
            mdl = "models/props_junk/propanecanister001a.mdl",
            slots = {
                back = 0.25,
            },
            def = {},
            bon = "ValveBiped.Bip01_Spine2",
            siz = Vector(0.6,0.6,1.4),
            pos = Vector(4,1,0),
            ang = Angle(90,0,0),
            wgt = 10,
            dur = 75,
            ent = "ent_jack_gmod_ezarmor_ballon_o2",
            gayPhysics = true,
            Category = "Homigrad"
        }
    }
    
    table.Merge(JMod.ArmorTable,tbl)
    
    JMod.GenerateArmorEntities(tbl)
end

if JMod then uragmodlibutorganisomfa() end

hook.Add("Initialize","JMOD uragmodlibutorganisomfa",function()
    uragmodlibutorganisomfa()
end)

if SERVER then return end

local black = Color(0,0,0)


hook.Add("RenderScreenspaceEffects","Impulse",function()
    if not LocalPlayer():Alive() then return end

    if LocalPlayer():GetNWBool("HeadInWater")  then
	    DrawToyTown(1,ScrH())
    end
end)

event.Add("DSP","Water",function()
    local ply = LocalPlayer()
    if ply:Alive() and ply:GetNWBool("HeadInWater") then return 14,false end
end)

hook.Add("HUDPaint","O2",function()
    local ply = LocalPlayer()
    
    if not ply:Alive() then
        return
    end

    black.a = (1 - LocalPlayer():GetNWFloat("o2",1)) * 255
    
    draw.RoundedBox(0,0,0,ScrW(),ScrH(),black)
end)