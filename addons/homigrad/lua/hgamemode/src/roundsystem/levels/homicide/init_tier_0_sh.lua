-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\homicide\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.homicide = true

homicide = homicide or {}

homicide.red = {"innocent",Color(125,125,125),
    models = tdm.models
}

homicide.teamEncoder = {
    [1] = "red"
}

homicide.RoundRandomDefalut = 3

local roundTypes = {
    [1] = {
        name = "State of Emergency",
        playsnd = "snd_jack_hmcd_disaster.mp3"
    },
    [2] = {
        name = "Standard",
        playsnd = "snd_jack_hmcd_shining.mp3"
    },
    [3] = {
        name = "Gun-Free-Zone",
        playsnd = "snd_jack_hmcd_panic.mp3"
    },
    [4] = {
        name = "Wild West",
        playsnd = "snd_jack_hmcd_wildwest.mp3"
    },
}

local empty = {}

function homicide.StartRound(data)
    game.CleanUpMap(false)

    if CLIENT then
        roundTimeLoot = data.roundTimeLoot
        roundType = data.roundType

        if GetConVar("hg_sound_round"):GetBool() then
            local snd = roundTypes[roundType].playsnd
            if snd then surface.PlaySound(snd) end
        end
        
        return
    end

    return homicide.StartRoundSV()
end

function homicide.InputData(data)
    for i,ply in pairs(player.GetAll()) do
        ply.roleT = false
        ply.roleCT = false
    end

    for i,ply in pairs(data.t or empty) do ply.roleT = true end
    for i,ply in pairs(data.ct or empty) do ply.roleCT = true end
end

homicide.SupportCenter = false

if SERVER then return end

local red,blue = Color(200,0,10),Color(75,75,255)
local gray = Color(122,122,122,255)

function homicide.GetTeamName(ply)
    if ply.roleT then return "traitor",red end
    if ply.roleCT then return "innocent",blue end

    local teamID = ply:Team()

    if teamID <= 3 then
        return "innocent",ScoreboardSpec
    end
end

local black = Color(0,0,0,255)


function homicide.HUDPaint_Spectate(spec)
    --local name,color = homicide.GetTeamName(spec)
    --draw.SimpleText(name,"H.25",ScrW() / 2,ScrH() - 150,color,TEXT_ALIGN_CENTER)
end

function homicide.Scoreboard_Status(ply)
    local lply = LocalPlayer()
    if lply.roleT or not lply:Alive() then return end

    return "unknown",ScoreboardSpec
end

local red,blue = Color(200,0,10),Color(75,75,255)

homicide.LoadScreenTime = 6

cblue = Color(75,75,255)
cred = Color(255,75,75)
cgray = Color(255,255,255)
cgreen = Color(75,255,75)
cname = Color(0,0,0)

function homicide.DrawLoadScreen(func,loadTime)
    local lply = LocalPlayer()
    if not lply:Alive() or lply:Team() == 1002 then return end
    
    local startRound = roundTimeStart + loadTime - CurTime()
    
    if startRound <= 0 then return end
    
    local k = math.Clamp(startRound - 0.5,0,1)

    local name,color = TableRound().GetTeamName(lply)

    cname.r = color.r
    cname.g = color.g
    cname.b = color.b
    cname.a = k * 255

	cred.a = k * 255
	cgray.a = k * 255
    cgreen.a = k * 255

    surface.SetDrawColor(0,0,0,k * 245)
    surface.DrawRect(0,0,scrw,scrh)

    func(lply,k)

    return true
end

local function DrawScreen(lply,k)
    local name,color = homicide.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

    draw.DrawText(L("you",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.DrawText(L("homicide"),"H.25",w / 2,h / 8,cblue,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.DrawText(roundTypes[roundType].name,"H.25",w / 2,h / 5,cblue,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    if lply.roleT then
        draw.DrawText(L("homicide_loadscreen_roleT"),"H.25",w / 2,h / 1.2,cred,TEXT_ALIGN_CENTER)
    elseif lply.roleCT then
        if roundType == 2 then 
            draw.DrawText(L("homicide_loadscreen_roleCT2"),"H.25",w / 2,h / 1.2,cblue,TEXT_ALIGN_CENTER)
        else
            draw.DrawText(L("homicide_loadscreen_roleCT"),"H.25",w / 2,h / 1.2,cblue,TEXT_ALIGN_CENTER)
        end
    else
        draw.DrawText(L("homicide_loadscreen"),"H.25",w / 2,h / 1.2,cgray,TEXT_ALIGN_CENTER)
    end
end

local focus_ent
local focus_stick = 0
local size = 16

TTTButtons = TTTButtons or {}

hook.Add("PostCleanupMap","TTTButtons",function()
    timer.Simple(1,function()
        TTTButtons = {}

        for _, ent in ipairs(ents.FindByClass("ttt_traitor_button")) do
            if IsValid(ent) then
                TTTButtons[ent:EntIndex()] = ent
            end
        end
    end)
end)

local tbut_normal = Material("icon16/clock.png")
local tbut_focus = Material("icon16/clock_red.png")

local focus_range = 25

local abs = math.abs

function homicide.HUDPaint(white2)
    local lply = LocalPlayer()
    local name,color = homicide.GetTeamName(lply)

    if homicide.DrawLoadScreen(DrawScreen,homicide.LoadScreenTime) then return end
  
    local time = math.Round(roundTimeStart + roundTime - CurTime())
    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = L("police_come",acurcetime)

        draw.SimpleText(acurcetime,"H.18",ScrW() / 2,ScrH() - 25,white2,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local lply_pos = lply:GetPos()

    for i,ply in pairs(player.GetAll()) do
        local color = ply.roleT and red or ply.roleCT and blue
        if not color or ply == lply or not ply:Alive() then continue end

        local pos = ply:GetPos() + ply:OBBCenter()
        local dis = lply_pos:Distance(pos)
        if dis > 800 then continue end

        local pos = pos:ToScreen()
        if not pos.visible then continue end

        color.a = 255 * (1 - dis / 800)

        draw.SimpleText(ply:Nick(),"H.18",pos.x,pos.y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    --

    if not lply.roleT or (lply:Alive() and lply:GetNWBool("Otrub")) then return end

    homicide.DrawTTTButtons()
end

function homicide.DrawTTTButtons()
    local lply = LocalPlayer()
    
    local size = 16

    if table.Count(TTTButtons) > 0 then
        local plypos = LocalPlayer():GetPos()
        local midscreen_x = ScrW() / 2
        local midscreen_y = ScrH() / 2
        local pos, scrpos, d
        local focus_ent = nil
        local focus_d, focus_scrpos_x, focus_scrpos_y = 0, midscreen_x, midscreen_y
  
        for k,but in pairs(TTTButtons) do
            if not IsValid(but) or not but.IsUsable then continue end
            if but:GetDelay() == 0 then continue end

            pos = but:GetPos()
            scrpos = pos:ToScreen()
  
            if not scrpos.visible or not but:IsUsable() then continue end
            
            d = pos - plypos
            d = d:Dot(d) / (but:GetUsableRange() ^ 2)

            if d > 1 then continue end

            surface.SetMaterial(but:GetDelay() < 0 and tbut_normal or tbut_focus)

            surface.SetDrawColor(255,255,255,200 * (1 - d))
            surface.DrawTexturedRect(scrpos.x - size / 2,scrpos.y - size / 2,size,size)

            if d >= focus_d then
                local x = abs(scrpos.x - midscreen_x)
                local y = abs(scrpos.y - midscreen_y)

                if (x < focus_range and y < focus_range and x < focus_scrpos_x and y < focus_scrpos_y) then
                    focus_ent = but
                end
            end
        end
  
        if IsValid(focus_ent) then
            size = size * 2

            focus_ent = focus_ent
            focus_stick = CurTime() + 0.1

            local scrpos = focus_ent:GetPos():ToScreen()
            local sz = 16

            surface.SetMaterial(tbut_focus)
            surface.SetDrawColor(255,255,255,200)
            surface.DrawTexturedRect(scrpos.x - size / 2,scrpos.y - size / 2,size,size)

            surface.SetTextColor(255,255,255,255)
            surface.SetFont("H.18")

            local x = scrpos.x + sz + 10
            local y = scrpos.y - sz - 3
            surface.SetTextPos(x,y)
            surface.DrawText(focus_ent:GetDescription())

            y = y + 12

            surface.SetTextPos(x,y)

            if focus_ent:GetDelay() < 0 then
                surface.DrawText(L("tbut_single"))
            elseif focus_ent:GetDelay() == 0 then
                surface.DrawText(L("tbut_reuse"))
            else
                surface.DrawText(L("tbut_retime",focus_ent:GetDelay()))
            end

            if lply:KeyDown(IN_USE) then
                RunConsoleCommand("ttt_use_tbutton",tostring(focus_ent:EntIndex()))
            end
        end
    end
end

function homicide.VBWHide(ply,list)
    if ply:Team() == 1002 then return end

    local blad = {}

    for i = 1,#list do
        local wep = list[i]
        if not wep.TwoHands then continue end

        blad[#blad + 1] = wep
    end--ufff

    return blad
end

function homicide.Scoreboard_DrawLast(ply)
    if LocalPlayer():Team() ~= 1002 and LocalPlayer():Alive() then return false end
end