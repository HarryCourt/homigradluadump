-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\scp\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.scp = true

scp = scp or {}
scp.Name = "SCP"

scp.red = {"skibiti toylet",Color(125,125,125),
    models = tdm.models
}

scp.teamEncoder = {
    [1] = "red"
}

function scp.CanRandomNext()
    return false
end

function scp.CanRandomForce()
    if #PointsList.scp096.list == 0 or #PointsList.scp173.list == 0 then return end

    return true
end

function scp.StartRound(data)
    game.CleanUpMap(false)

    if CLIENT then
        spawnMOG = data.spawnMOG

        return
    end

    return scp.StartRoundSV()
end

scp.roles = {}

local mdl = {}
for i = 1,4 do mdl[i] = "models/player/hostage/hostage_0" .. i.. ".mdl" end

local models = {}

for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end
for i = 1,6 do table.insert(models,"models/player/group01/female_0" .. i .. ".mdl") end

scp.roles[0] = {
    "D-Класс",
    Color(255,125,0),
    models = models,
}

scp.roles[1] = {
    "Учённый",
    Color(200,200,200),
    models = models,
    main_weapons = {
        "med_needle",
        "med_kit",
        "megamed_kit",
        "med_band_small",
        "med_painkiller",
        "bandage"
    }
}

scp.roles[2] = {
    "Охрана",
    Color(75,75,255),
    models = models,
    main_weapon = {"wep_mp5","wep_ump","wep_mp7"},
    secondary_weapon = {"wep_fiveseven"},
    weapons = {
        "weapon_radio"
    },
    armors = {
        "Riot-Helmet",
        "Light-Vest",
        
        "ent_jack_gmod_ezarmor_thunderbolt"
    }
}

scp.roles[3] = {
    "МОГ",
    Color(75,75,222),
    models = models,
    main_weapon = {"wep_m4a1","wep_scar"},
    secondary_weapon = {"wep_glock"},

    weapons = {
        "weapon_radio",

        "med_kit",
        "med_needle",
        "darkrp_doom_ram",

        "weapon_c4"
    }
}

local orange = Color(255,125,0)

function scp.GetTeamName(ply)
    if ply:Team() == 1002 then return end

    local role = ply:GetNWInt("Role")
    role = scp.roles[role]
    if not role then return end

    return role[1],role[2]
end
function scp.Scoreboard_Status(ply)
    local lply = LocalPlayer()
    if not lply:Alive() or lply:Team() == 1002 then return true end

    return "Неизвестно",ScoreboardSpec
end

function scp.HUDPaint(white2,time)
	local time = math.Round((spawnMOG or 0) - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")

	if time > 0 then
		draw.SimpleText("До прибытия МОГ : ","H.18",ScrW() / 2 - 200,ScrH()-25,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(acurcetime,"H.18",ScrW() / 2 + 200,ScrH()-25,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
end

