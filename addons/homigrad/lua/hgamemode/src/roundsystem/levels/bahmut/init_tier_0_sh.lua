-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\bahmut\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.bahmut = true

bahmut = bahmut or {}
bahmut.Name = "bahmut"

local bodygroup = {}
for i = 0,24 do bodygroup[i] = 1 end
bodygroup[8] = 0
bodygroup[12] = 0
bodygroup[7] = 0

bahmut.red = {"bahmut_red",Color(225,45,60),
	weapons = {
		"weapon_binokle","weapon_radio",
		"weapon_handcuffs","weapon_handcuffs","weapon_handcuffs",
		
		"med_kit","med_kit",
		"med_painkiller",

		"wep_gnade_rgd5"
	},
	classes = {
		 {
			"class_solder",
			main_weapon = {"wep_ak47" , "wep_val"}
		},
		{
			"class_sniper",
			main_weapon = {"wep_m14"}
		}
	},
	selectLink = true,
	secondary_weapon = {"wep_fiveseven", "wep_glock"},
	models = {{"models/wagner/wagner_soldier.mdl",bodygroup}},
	armors = {
		{"ent_jack_gmod_ezarmor_mmac",Color(255,255,255)},
		{"ent_jack_gmod_ezarmor_tackekfastmt",Color(255,255,255)},
		{"ent_jack_gmod_ezarmor_m32",Color(255,255,255)}
	}
}

local models = {}
for i = 1,9 do table.insert(models,"models/player/rusty/natguard/male_0" .. i .. ".mdl") end

local bodygroup = {}
for i = 1,5 do bodygroup[i] = 1 end

bahmut.blue = {"bahmut_blue",Color(225,225,60),
	weapons = {
		"weapon_binokle","weapon_radio",
		"weapon_handcuffs","weapon_handcuffs","weapon_handcuffs",
		
		"med_kit","med_kit",
		"med_painkiller",
		
		"wep_gnade_rgd5"
	},
	classes = {
		{
			"class_solder",
			main_weapon = {"wep_m4a1","wep_scar"}
		},
		{
			"class_sniper",
			main_weapon = {"wep_m14"}
		}
	},
	selectLink = true,
	secondary_weapon = {"wep_fiveseven", "wep_glock"},
	models = {{"models/dejtriyev/mm14/ukrainian_soldier.mdl",bodygroup}},
	armors = {
		{"ent_jack_gmod_ezarmor_achhcolive",Color(255,255,255)},
		{"ent_jack_gmod_ezarmor_cpcge",Color(255,255,255)},
		{"ent_jack_gmod_ezarmor_redutt5pelvis",Color(255,255,255)},
		{"ent_jack_gmod_ezarmor_afglasses",Color(255,255,255)},
		{"ent_jack_gmod_ezarmor_sordin",Color(255,255,255)}
	}
}

bahmut.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function bahmut.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,bahmut.red[2])
	team.SetColor(2,bahmut.blue[2])

	if CLIENT then
		return
	end

	bahmut.StartRoundSV()
end

bahmut.SupportCenter = true
bahmut.LoadScreenTime = 6

if SERVER then return end

local cblue = Color(55,55,155)
local cred = Color(155,155,55)
local cgray = Color(255,255,255)
local cname = Color(0,0,0)

local function DrawScreen(lply,k)
    local name,color = bahmut.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

    cname.r = color.r
    cname.g = color.g
    cname.b = color.b
    cname.a = k * 255

	cred.a = k * 255
	cgray.a = k * 255

	draw.DrawText(L("you",L(lply:GetNWString("ClassName"))),"H.25",w / 2,h / 2 - h / 6,cname,TEXT_ALIGN_CENTER)
 
	draw.DrawText(L("you_team",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
	draw.DrawText(L(roundActiveName),"H.25",w / 2,h / 8,cred,TEXT_ALIGN_CENTER)

	draw.DrawText(L("bahmut_loadscreen"),"H.25",w / 2,h/ 1.2,cgray,TEXT_ALIGN_CENTER)
end

bahmut.GetTeamName = tdm.GetTeamName

function bahmut.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = bahmut.GetTeamName(lply)

	if homicide.DrawLoadScreen(DrawScreen,bahmut.LoadScreenTime) then return end

	tdm.DrawRoundTime()
end