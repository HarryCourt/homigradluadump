-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\event\\sh_tier_0.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.eventt = true

eventt = eventt or {}
eventt.Name = "EVENT"

local red,blue,green = Color(255,75,75),Color(75,75,255),Color(75,255,75)

eventt.red = {
    "RED",red,
    models = tdm.models
}

eventt.blue = {
    "BLUE",blue,
    models = tdm.models
}

eventt.green = {
    "GREEN",green,
    models = tdm.models
}

eventt.teamEncoder = {
    [1] = "red",
    [2] = "blue",
    [3] = "green"
}

function eventt.GetTeamName(ply)
    local teamID = ply:Team()

    if teamID == 2 then return "Команда 1",red end
    if teamID == 2 then return "Команда 2",blue end
    if teamID == 3 then return "Команда 3",green end
end

function eventt.StartRound(data)
    team.SetColor(1,red)
    team.SetColor(2,blue)
    team.SetColor(1,green)

    game.CleanUpMap(false)

    if CLIENT then return end

    return eventt.StartRoundSV()
end

if SERVER then return end

function eventt.HUDPaint(white2)

end