-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_2_construct\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.Construct = true

Construct = Construct or {}
Construct.Name = "Construct"

Construct.JModNoTeams = true
Construct.enableDamageSpawnEnt = true
Construct.CanPlayerOne = true
Construct.noTwo = true

Construct.UseConstruct = true
Construct.DisableGib = true
Construct.DisableWH = true
Construct.DisableCenter = true

Construct.DelayDeadLootBox = 60

CupboardDistance = 400

Construct.red = {"Construct",Color(255,255,255),
    models = tdm.models
}

Construct.teamEncoder = {
    "red"
}

function Construct.StartRound(data)
	if CLIENT then
        game.CleanUpMap(true)

        roundTime = data.roundTime
        
        return
    end

    return Construct.StartRoundSV()
end

function Construct.CanUseContextMenu() return true end

if SERVER then return end

local gray = Color(122,122,122,255)

function Construct.GetTeamName(ply)
    local teamID = ply:Team()

    if ply:Team() == 1 then
        return "Constructer",gray
    end
end

local staticWhite = Color(255,255,255)

local white = Color(255,255,255)

function Construct.HUDPaint(white2)
    /*local time = math.Round((wait or 0) - CurTime())

    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = "До окончания строительства : " .. acurcetime

        draw.SimpleText(acurcetime,"H.18",ScrW() / 2,ScrH() - 25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end*/

    local lply = LocalPlayer()

    local time = math.Round(roundTime - CurTime())
    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")

        draw.SimpleText(acurcetime,"H.18",ScrW() / 2,ScrH() - 25,white2,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    else
        time = time + 5
        white.a = 255 * math.Clamp(time,0,1)

        draw.SimpleText(L("construct_timetokill1"),"H.45",ScrW() / 2,ScrH() / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(L("construct_timetokill2"),"H.25",ScrW() / 2,ScrH() / 2 + 40,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        if time < 0 then
            draw.SimpleText(L("construct_timetokill2"),"H.18",ScrW() / 2,ScrH() - 25,staticWhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    if lply:Team() == 1002 or lply:Alive() then return end

    local time = lply:GetNWFloat("DeathWait",0) - CurTime()

    /*if Construct.DisableSpectate(LocalPlayer()) then
        local k = math.Clamp(CurTime() - (DeathStartTime or 0),0,1)

        surface.SetDrawColor(0,0,0,250 * k)
        surface.DrawRect(0,0,ScrW(),ScrH())

        local dmgTab = DeathDmgTab

        if dmgTab then
            local att = dmgTab.att

            if IsValid(att) then
                local boneName = ""
            
                if dmgTab.bone and dmgTab.bone ~= 0 then
                    boneName = " в " .. tostring(ReasonsDeathBoneMsg[lply:GetBoneName(dmgTab.bone)])
                end

                draw.SimpleText("Тебя убил '" .. tostring(att) .. "'" .. boneName,"ChatFont",ScrW() / 2,75,staticWhite,TEXT_ALIGN_CENTER)
            end

            local wep = dmgTab.wep

            if IsValid(wep) and wep ~= att then
                draw.SimpleText("Из " .. (wep.PrintName or tostring(wep)),"ChatFont",ScrW() - 75,75,staticWhite,TEXT_ALIGN_RIGHT)
            end

            for i,reason in pairs(dmgTab.reasons) do
                draw.SimpleText(ReasonsDeathMsg[reason] or reason,"ChatFont",75,75 + 25 * i,staticWhite)
            end
        end
    end*/

    if roundTime < CurTime() or GetGlobalVar("StopGame") then return end
    
    if time > 0 then
        draw.SimpleText(L("spawn_from_second",math.Round(time)),"ChatFont",ScrW() / 2,ScrH() / 2 - 250,staticWhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    elseif not IsValid(lply:GetNWEntity("HeSpectateOn")) then
        if input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT) then
            net.Start("Construct respawn")
            net.SendToServer()
        end

        draw.SimpleText(L("click_for_spawn"),"ChatFont",ScrW() / 2,ScrH() / 2 - 250,staticWhite,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end

function Construct.PaintContentIcon(self,w,h)
    if LocalPlayer():GetNWBool("IgnoreQ") or Construct.ValidList[self:GetSpawnName()] then return end

    surface.SetDrawColor(0,0,0,125)
    surface.DrawRect(4,4,w - 8,h - 8)
end

net.Receive("Construct global chat",function()
    local ply = net.ReadEntity()
    local text = net.ReadString()

    chat.AddText(Color(255,125,0),"[//] ",Color(255,255,255),ply:Nick(),": " ..text)
end)

net.Receive("Construct team chat",function()
    local ply = net.ReadEntity()
    local text = net.ReadString()

    chat.AddText(Color(0,255,0),"[**] ",Color(255,255,255),ply:Nick(),": " ..text)
end)

local vecZero = Vector(0.01,0.01,0.01)

Construct.DisableSpectate = function(ply,view)
    /*if roundTime <= CurTime() or GetGlobalBool("Stopgame") or not GetGlobalBool("DisableSpectate") or ply:Team() == 1002 then return false end

    if not view then return true end

    local rag = ply:GetNWEntity("RagdollDeath")
    if not IsValid(rag) then return end

    local headBone = rag:LookupBone("ValveBiped.Bip01_Head1")
    local head = headBone and rag:GetBoneMatrix(headBone)

    if head then
        view.vec = head:GetTranslation()
        local ang = head:GetAngles()
        ang:Add(Angle(0,0,-90))

        view.vec:Add(Vector(2.5,0,-3):Rotate(ang))
        rag:ManipulateBoneScale(headBone,vecZero)

        view.ang = ang
    else

    end--wtf?*/

    return false
end
