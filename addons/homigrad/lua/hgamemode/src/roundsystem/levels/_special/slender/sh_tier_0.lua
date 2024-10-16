-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\slender\\sh_tier_0.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.slender = true

slender = slender or {}
slender.Name = "slender"
slender.RoundRandomNext = 3

local red = Color(255,255,255)
local green = Color(125,125,125)

slender.green = {
    "Игрок",green,
    models = tdm.models
}

slender.teamEncoder = {
    [2] = "green"
}

function slender.GetTeamName(ply)
    local teamID = ply:Team()

    if teamID == 1 then return "Slender",red end
    if teamID == 2 then return "Игрок",green end  
end

function slender.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    SetGlobalVar("Slender Note",0)

    slendernote = 0

    if CLIENT then return end

    return slender.StartRoundSV()
end

if SERVER then return end

local cred = Color(155,155,55)

local function DrawScreen(lply,k)
    local name,color = homicide.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

    cred.a = k * 255

    draw.DrawText(L("slender"),"H.25",w / 2,h / 5,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    if GetGlobalBool("Weapons") then
        draw.DrawText(L("run_loadscreen_withgun"),"H.25",w / 2,h/ 5 + 15,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    draw.DrawText(L("slender_loadscreen1"),"H.25",w / 2,h / 1.2,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.DrawText(L("slender_loadscreen2"), "H.25",w/ 2,h / 1.2 + 50,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end


local white,red,purple = Color(255,255,255),Color(255,0,0),Color(125,0,125)

local old

function slender.HUDPaint(white2)
    --if homicide.DrawLoadScreen(DrawScreen,run.LoadScreenTime) then return end

    local time = math.Round(roundTime - CurTime())
    
    tdm.DrawRoundTime()

    if GetGlobalVar("Slender Note") >= GetGlobalVar("Slender Note Max") then
        for i,point in pairs(PointsList.exit.list or {}) do
            local pos = point.pos:ToScreen()
            
            draw.SimpleText("exit","H.25",pos.x,pos.y,showRoundInfoColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    local ply = LocalPlayer()

    if not ply:Alive() or ply.PlayerClassName == "slender" then return end

    local k = ply:Health() / ply:GetMaxHealth()

    if k ~= old then
        showHP = RealTime() + 6
    end

    old = k

    local w,h = 200 * ScreenSize,60 * ScreenSize
    local x,y = 25,25

    surface.SetDrawColor(255,255,255,255 * (math.Clamp(showHP - RealTime(),0,1) + math.Clamp(showRoundInfo - CurTime(),0,1)))
    surface.DrawRect(x,y,w,2)
    surface.DrawRect(x,y,2,h)

    surface.DrawRect(x,y + h - 2,w,2)
    surface.DrawRect(x + w - 2,y,2,h)
    surface.DrawRect(x + w - 2,y + h / 1.25 / 2 / 4,13 * ScreenSize,h / 1.25)

    surface.DrawRect(x + 4,y + 4,w * k - 8,h - 8)

    if k > 0.75 then

    elseif k >= 0.45 then

    else

    end
end

function slender.SetupFog()
    return 750,Vector(0,0,0)
end

local snd

local function playMusic(path,restartTime)
    if not IsValid(snd) or snd.sndPath ~= path then
        if IsValid(snd) then snd:Remove() end
        snd = sound.CreatePoint(LocalPlayer(),path)
    end

    snd.restartTime = restartTime
    snd:Play()
end

function slender.Think()
    local note,max = GetGlobalVar("Slender Note"),GetGlobalVar("Slender Note Max")

    if note >= max then
        playMusic("threefour.wav",24)
    elseif note >= max / 2 then
        playMusic("onetwo.wav",4)
    else
        if IsValid(snd) then snd:Remove() end
    end
end

net.Receive("slender note",function()
    local count = tonumber(net.ReadString())
    local max = GetGlobalVar("Slender Note Max")

    LocalPlayer():PrintMessage(4,count .. "/" .. max)

    if count >= max then
        LocalPlayer():PrintMessage(4,"Выход открыт")
    end

    for i = 1,3 do surface.PlaySound("camera_static/single3.wav") end

    showRoundInfo = RealTime() + 10
end)