-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\deadrun\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.deadrun = true

deadrun = deadrun or {}
deadrun.Name = "Death Run"
deadrun.LoadScreenTime = 5.5
deadrun.CantFight = bhop.LoadScreenTime
deadrun.noDelayJump = true

deadrun.NoSelectRandom = true
deadrun.CantUseFootkick = true
deadrun.CantUseRagdollE = true

deadrun.red = {"Red",Color(255,0,0),
    models = tdm.models
}

deadrun.blue = {"Blue",Color(0,0,255),
    models = tdm.models
}

deadrun.teamEncoder = {
    [1] = "red",
    [2] = "blue"
}

deadrun.SprintTime = 3
deadrun.SprintTimeout = 2
deadrun.SprintPower = 600

deadrun.TimeBeforeYouDeadInRagdollsBigBobs = 10

function deadrun.StartRound(data)
    game.CleanUpMap(false)

    team.SetColor(1,deadrun.red[2])
	team.SetColor(2,deadrun.blue[2])

    if CLIENT then
        return
    end

    return deadrun.StartRoundSV()
end

deadrun.GetTeamName = tdm.GetTeamName

function deadrun.EyeDefault(ply)
    local wep = ply:GetActiveWeapon()

    if IsValid(wep) and wep:GetClass() == "weapon_hands" then return true end
end

if SERVER then return end

local jump = 0
local jumpLimit = 25
local jumpDelay = 5

local jumpLast = 0

local white = Color(255,255,255)

function deadrun.HUDPaint()
    local ply = LocalPlayer()
    local time = ply:GetNWFloat("RagTimeDie",0)

    /*for i,ent in pairs(ents.FindInSphere(ply:GetPos(),300)) do
        local pos = ent:GetPos():ToScreen()

        draw.SimpleText(tostring(ent),"ChatFont",pos.x,pos.y,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end*/

    if not ply:Alive() then return end

    local w,h = ScrW(),ScrH()
    
    draw.SimpleText(ply:Health(),"H.25",30,h - 30,nil,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
    draw.SimpleText(math.Round(ply:GetVelocity():Length()),"H.18",w / 2,h - 30,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)


    if ply:GetNWBool("fake") and time ~= 0 then
        time = time - CurTime()

        if time <= 0 then
            draw.SimpleText("Ты вмер. ;c;c; грустно ;c","H.25",w / 2,h / 2 + 250,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(L("deadrun_die_in_ragdoll",math.Round(time,3)),"H.25",w / 2,h/ 2 + 250,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        return
    end

    local k = jumpLast + 1 - CurTime()

    white.a = 255 * k
    
    if k > 0 then
        draw.SimpleText(L("deadrun_bhop",jumpLimit - jump),"H.25",w / 2,h - 150,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    if jumpDead then
        draw.SimpleText("bhop","H.25",w / 2 - 250,h - 50,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(math.Round((jumpDead or 0) - CurTime(),3) .. "s","H.25",w / 2 + 250,h - 50,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    --local sprint = math.Clamp((ply:GetNWFloat("SprintTime",0) + deadrun.SprintTime - CurTime()) / deadrun.SprintTime,0,1)

    /*if sprint > 0 then
        draw.SimpleText("sprint","H.25",w / 2 - 250,h - 100,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(math.Round(sprint - CurTime(),3) .. "s","H.25",w / 2 + 250,h - 100,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end*/
end

function deadrun.Scoreboard_Status(ply)

end

function deadrun.ShouldViewCamera() return true end

jumpDead = nil

function deadrun.Think()
    if jumpDead then
        if jumpDead <= CurTime() then
            jumpDead = nil
            jump = 0
        end

        return
    end

    if jumpLast + 1 <= CurTime() then jump = 0 end

    local ply = LocalPlayer()

    if not ply:Alive() or ply:GetMoveType() ~= MOVETYPE_WALK then return end
    
    if input.IsKeyDown(KEY_SPACE) then
        if ply:IsOnGround() then
            RunConsoleCommand("+jump")

            timer.Create("Bhop",0,0,function() RunConsoleCommand("-jump") end)

            if jumpLast + 0.25 <= CurTime() then
                jump = jump + 1

                jumpLast = CurTime()

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

function deadrun.DrawScreenspace() return false end