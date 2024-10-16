-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\riot\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.riot = true

riot = riot or {}
riot.Name = "RIOT"

riot.red = {"riot_rebels",Color(75,45,45),
	weapons = {"wep_food_cannerburger","med_band_small","med_band","med_band"},
	main_weapon = {"wep_gnade_molotov","weapon_per4ik","wep_pnev"},
	secondary_weapon = {"melee_metalbat", "melee_bat","melee_pipe"},
	models = {"models/player/Group01/male_04.mdl","models/player/Group01/male_01.mdl","models/player/Group01/male_02.mdl","models/player/Group01/male_08.mdl"},
}

riot.blue = {"police",Color(55,55,150),
	weapons = {"wep_food_cannerburger","melee_police_bat","med_band","med_band","weapon_taser","weapon_handcuffs","weapon_radio"},
	main_weapon = {"wep_pol870","med_kit","weapon_gnade_flashbang"},
	models = {"models/monolithservers/mpd/male_04.mdl","models/monolithservers/mpd/male_03.mdl","models/monolithservers/mpd/male_05.mdl","models/monolithservers/mpd/male_02.mdl"},
	armors = {
		{"Riot-Helmet",Color(65,65,65)},
		{{{"ent_jack_gmod_ezarmor_kora_kulon_b",Color(65,65,65)},{"ent_jack_gmod_ezarmor_thorcrv",Color(65,65,65)}}}
	}
}

riot.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function riot.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,riot.red[2])
	team.SetColor(2,riot.blue[2])

	if CLIENT then
		return
	end

	riot.StartRoundSV()
end

riot.SupportCenter = true

if SERVER then return end

riot.GetTeamName = tdm.GetTeamName
riot.LoadScreenTime = 6

local function DrawScreen(lply,k)
    local name,color = riot.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

	draw.DrawText(L("you_team",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
	draw.DrawText("RIOT","H.25",w / 2,h / 8,cpurple,TEXT_ALIGN_CENTER)

	if lply:Team() == 2 then
		draw.DrawText(L("riot_loadscreen_team2"),"H.25",w / 2,h/ 1.2,cgray,TEXT_ALIGN_CENTER)
	else
		draw.DrawText(L("riot_loadscreen_team1"),"H.25",w/ 2,h / 1.2,cgray,TEXT_ALIGN_CENTER)
	end
end

function riot.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = riot.GetTeamName(lply)

	if homicide.DrawLoadScreen(DrawScreen,riot.LoadScreenTime) then return end

	tdm.DrawRoundTime()
end