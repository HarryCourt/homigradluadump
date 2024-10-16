-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_fun\\run\\sh_tier_0.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.run = true

run = run or {}
run.Name = "Картошка"
run.LoadScreenTime = 5.5
run.RoundRandomNext = 1
function run.EyeDefault()
    if CLIENT and LocalPlayer():Alive() and not LocalPlayer():GetNWBool("fake") then return true end
end

local red = Color(255,0,0)
local green = Color(0,255,0)

run.green = {
    "Игрок",green,
    models = tdm.models
}

run.teamEncoder = {
    [2] = "green"
}

function run.GetTeamName(ply)
    local teamID = ply:Team()

    if teamID == 1 then return "Водитель",red end
    if teamID == 2 then return "Пасажир",green end  
end

function run.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    if CLIENT then
        return
    end

    return run.StartRoundSV()
end

function run.Move(ply,mv)
    if not ply:Alive() then return end
    
    local wep = ply:GetActiveWeapon()

    if IsValid(wep) and (wep.itemType == "weapon" or wep.itemType == "weaponSecondary") then
        local maxspeed = mv:GetMaxSpeed() / 1.25

        mv:SetMaxSpeed(maxspeed)
        mv:SetMaxClientSpeed(maxspeed)

        return
    end
end

function run.TraitorButtonUse(ply,ent) return true end

if SERVER then return end

local cred = Color(155,255,55)

local function DrawScreen(lply,k)
    local name,color = homicide.GetTeamName(lply)

    local w,h = ScrW(),ScrH()


    cred.a = k * 255

    draw.DrawText(L("run"),"H.25",w / 2,h / 5,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    if GetGlobalBool("Weapons") then
        draw.DrawText(L("run_loadscreen_withgun"),"H.25",w / 2,h/ 5 + 45,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    draw.DrawText(L("run_loadscreen1"),"H.25",w / 2,h / 1.2,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.DrawText(L("run_loadscreen2"), "H.25",w/ 2,h / 1.2 + 50,cred,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

local kill = 4

local white,red,purple = Color(255,255,255),Color(255,0,0),Color(125,0,125)

local fuck,fuckLerp = 0,0

function run.HUDPaint(white2)
    if homicide.DrawLoadScreen(DrawScreen,run.LoadScreenTime) then return end

    local time = math.Round(roundTime - CurTime())
    
    tdm.DrawRoundTime()

    if LocalPlayer():Alive() and (timeStartAnyDeath or 0) + 15 < CurTime() then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = acurcetime

        draw.SimpleText("can use alt","H.18",ScrW() / 2,ScrH() - 25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    homicide.DrawTTTButtons()
end

function run.PlayerDeath()
    timeStartAnyDeath = CurTime()
end

function run.CanUseSpectateHUD()
    return true--(timeStartAnyDeath or 0) + 15 < CurTime()
end

function run.DrawScreenspace() return false end