-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_fun\\bhop\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.bhop = true

bhop = bhop or {}
bhop.Name = "Bhop"
bhop.LoadScreenTime = 5.5
bhop.CantFight = 1

bhop.RoundRandomDefalut = 1
bhop.NoSelectRandom = false

function bhop.EyeDefault() return true end

local red = Color(255,0,0)

bhop.red = {
    "Игрок",red,
    models = tdm.models
}

bhop.teamEncoder = {
    [1] = "red"
}

function bhop.GetTeamName(ply)
    local teamID = ply:Team()

     if teamID == 1 then return "Bhoper",red end
end

function bhop.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    if CLIENT then
        return
    end

    return bhop.StartRoundSV()
end

if SERVER then return end

local nigger = Color(0,0,0)
local red = Color(255,0,0)

local kill = 4

local white,red = Color(255,255,255),Color(255,0,0)

local fuck,fuckLerp = 0,0

function bhop.Think()
    /*if LocalPlayer():Alive() then
        local active = roundTimeStart + bhop.LoadScreenTime < CurTime() and LocalPlayer():IsOnGround()

        if active then
            fuck = fuck + 1 * FrameTime()
        else
            fuck = 0
        end

        if fuck >= kill then RunConsoleCommand("kill") end
    else
        fuck = 0
    end

    fuckLerp = LerpFT(0.1,fuckLerp,fuck)*/
end

local cursor_color = Color(255,0,0)
local size = 4

function bhop.HUDPaint(white2)
    local ply = LocalPlayer()

    if ply:Alive() and ply:GetMoveType() == MOVETYPE_WALK then 
        if input.IsKeyDown(KEY_SPACE) then
            if ply:IsOnGround() then
                RunConsoleCommand("+jump")

                timer.Create("Bhop",0,0,function() RunConsoleCommand("-jump") end)

                if jumpLast + 0.25 <= CurTime() then
                    surface.PlaySound("homigrad/vgui/menu_back.wav")

                    if jump >= jumpLimit then
                        timer.Remove("Bhop")

                        jumpDead = CurTime() + jumpDelay

                        surface.PlaySound("homigrad/vgui/armsrace_kill_03.wav")
                    end
                end
            end
        else
            RunConsoleCommand("-jump")
        end
    end

    draw.RoundedBox(0,ScrW() / 2 - size / 2,ScrH() / 2 - size / 2,size,size,cursor_color)

    local anim_pos = math.max(roundTimeStart + bhop.LoadScreenTime - CurTime(),0) / 3
    anim_pos = math.min(anim_pos / 0.25,1)

    if anim_pos > 0 then
        nigger.a = 255 * anim_pos
        --draw.RoundedBox(0,0,0,ScrW(),ScrH(),nigger)

        red.a = nigger.a
        draw.DrawText(L("bhop"),"H.25",ScrW() / 2,ScrH() / 5,red,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        draw.DrawText(L("bhop_loadscreen"), "H.25",ScrW() / 2,ScrH() / 1.2,red,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.DrawText(L("bhop_loadscreen2"), "H.25",ScrW() / 2,ScrH() / 1.2 + 50,red,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    tdm.DrawRoundTime()

    if LocalPlayer():Alive() and (timeStartAnyDeath or 0) + 15 < CurTime() then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = acurcetime

        draw.SimpleText("can use alt","H.18",ScrW() / 2,ScrH() - 50,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    bhop.DrawGodMod()

    local k = math.min(fuckLerp / kill,1)
    local k2 = 1 - k

    local color = Color(255,255 * k2,255 * k2)
    color.a = 255 * math.min(k / 0.25,1)

    local k3 = math.max(k - 0.25,0) / 0.25
    local x,y = math.random(-12,12) * k3,math.random(-4,4) * k3

    local w = ScrW() / 4 * k
    draw.RoundedBox(0,ScrW() / 2 + y - w / 2,ScrH() - 125,w,5,color)

    draw.SimpleText("JUMP" .. string.rep("!",(CurTime() * math.max(10 * k,1)) % 4),"ChatFont",ScrW() / 2,ScrH() - 100,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function bhop.PlayerDeath()
    timeStartAnyDeath = CurTime()
end

function bhop.CanUseSpectateHUD()
    return (timeStartAnyDeath or 0) + 15 < CurTime()
end

function bhop.DrawGodMod()
    local time = math.ceil((GetGlobalFloat("GodTime") or 0) - CurTime())

    if time > 0 then
        draw.SimpleText(time,"H.25",scrw / 2,100,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end