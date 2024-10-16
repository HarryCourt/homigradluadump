-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_fun\\nextbot\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.nextbot = true

nextbot = nextbot or {}

nextbot.TimeLoadScreen = 6
nextbot.RoundRandomNext = 3

nextbot.red = {
	"NextBot",Color(255,0,0),
    models = tdm.models
}

nextbot.blue = {
	"Player",Color(0,255,0),
    models = tdm.models
}
function nextbot.GetMax2() return #PointsList.nextbot.list end

nextbot.teamEncoder = {
	[1] = "red",
    [2] = "blue",
}

nextbot.nextbots = {
    "npc_komeiji_fumo_enemy",
    "npc_yuyuko",
    "npc_flandrenextbot",
    "npc_sakuyanextbot"
}

nextbot.nextbotsStalk = {
    "npc_honda_mio",
}

nextbot.nextbotsScared = {
    "npc_kevin",
    "npc_kevin",
    "npc_kevin",
    "npc_youseemee",
    "npc_youseemee",
    "npc_car",
}

function nextbot.StartRound(data)
	game.CleanUpMap(false)

	if CLIENT then return end

	return nextbot.StartRoundSV()
end

nextbot.GetTeamName = tdm.GetTeamName

if SERVER then return end

local cgray = Color(125,125,125)
local smile = Material("homigrad/scp/scared/youseemee1.png")
local tofu = Material("npc_sakuyanextbot/sakuyanextbot")

local materials = {
    Material("npc_sakuyanextbot/sakuyanextbot"),
    Material("npc_flandrenextbot/flandrenextbot"),
    Material("fumo/npc_fumo.png", "smooth mips"),
    Material("npc_yuyuko/yuyuko"),
    Material("npc_komeiji_fumo_friendly/komeiji_fumo_friendly.png"),
    Material("npc_koishinextbot/koishinextbot")}

local function DrawScreen(lply,k)
    local name,color = dm.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

    local state = (GetGlobalBool("Scared") and 1) or 0
    local c = (state == 1 and Color(255,255,255)) or HSVToColor(CurTime() * 360 % 360,1,1)
    c.a = 255 * k

    if state == 1 then
        surface.SetMaterial(smile)
        surface.SetDrawColor(75,75,75,1 + math.random(1,5) * k)
        surface.DrawTexturedRect(0,0,ScrW(),ScrH())
    elseif state == 0 then
        surface.SetMaterial(materials[1 + math.floor(CurTime() % (#materials - 1))])
        surface.SetDrawColor(255,255,255,255 * k)
        surface.DrawTexturedRectRotated(
            ScrW() / 2,ScrH() / 1.45,
            128 + math.cos(CurTime() * 16) * 25,
            128 + math.sin(CurTime() * 16) * 25,
            math.cos(CurTime() * 14) * 25
        )
    end

    draw.DrawText(L("you",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
    draw.DrawText("NextBot" .. (state == 1 and "" or " with Touhou! ;3"),"H.25",w / 2,h / 8,c,TEXT_ALIGN_CENTER)
    draw.DrawText((state == 1 and "Беги что-бы остатся в живых.") or "Fumos","H.25",w / 2,h - h / 8,c,TEXT_ALIGN_CENTER)
end

function nextbot.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = tdm.GetTeamName(lply)

    if homicide.DrawLoadScreen(DrawScreen,nextbot.TimeLoadScreen) then return end

	tdm.DrawRoundTime()
end

function nextbot.ShouldViewCamera() return true end

local jumpLast = 0

function nextbot.Think()
    local ply = LocalPlayer()

    if not ply:Alive() or ply:GetMoveType() ~= MOVETYPE_WALK then return end
    
    if input.IsKeyDown(KEY_SPACE) then
        if ply:IsOnGround() then
            RunConsoleCommand("+jump")

            timer.Create("Bhop",0,0,function() RunConsoleCommand("-jump") end)

            if jumpLast + 0.25 <= CurTime() then
                jumpLast = CurTime()

                surface.PlaySound("homigrad/vgui/menu_back.wav")
            end
        end
    else
        RunConsoleCommand("-jump")
    end
end

function nextbot.DrawScreenspace() return false end

function nextbot.EyeDefault(ply)
    local wep = ply:GetActiveWeapon()

    if IsValid(wep) and wep:GetClass() == "weapon_hands" then return true end
end

function nextbot.SpectateNext(tbl)
    for ent in pairs(g_nextbots) do
        if not IsValid(ent) then g_nextbots[ent] = nil continue end
        
        tbl[#tbl + 1] = ent
    end
end