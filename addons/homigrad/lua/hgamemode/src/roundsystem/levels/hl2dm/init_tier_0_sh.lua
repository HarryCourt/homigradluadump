-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\hl2dm\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.hl2dm = true

hl2dm = hl2dm or {}
hl2dm.Name = "HL2 TDM"

local models = {}
for i = 1,9 do table.insert(models,"models/player/group03/male_0" .. i .. ".mdl") end

hl2dm.red = {"hl2dm_rebels",Color(225,95,60),
	weapons = {"med_band","med_kit","med_painkiller","weapon_radio"},
	classes = {
		{
			"class_scout",
			main_weapon = {"wep_smg1","wep_mp7","wep_mp5"},
			armors = {
				{"Light-Vest",Color(255,255,255)},
				{"ent_jack_gmod_ezarmor_commandoblack",Color(255,255,255)}
			}
		},
		{
			"class_support",
			main_weapon = {"wep_870"},
			armors = {
				{"Light-Vest",Color(255,255,255)},
				{"Medium-Helmet",Color(255,255,255)},
				{"ent_jack_gmod_ezarmor_commandoblack",Color(255,255,255)}
			}
		}
	},
	secondary_weapon = {"wep_pistol"},
	models = models
}

hl2dm.blue = {"combine",Color(75,75,225),
	weapons = {"weapon_radio","med_band","med_kit","med_painkiller","wep_gnade_hl2"},	
	classes = {
		{
			"class_solder",
			main_weapon = {
				"wep_ar2"
			},
			models = {"models/player/combine_super_soldier.mdl"}
		},
		{
			"class_support",
			main_weapon = {
				"wep_stotgun"
			},
			models = {"models/player/combine_soldier_prisonguard.mdl"}
		}
	},
	secondary_weapon = {"wep_pistol"},
	models = {"models/player/combine_soldier.mdl"},
	armors = {{"Light-Vest",Color(0,0,0,0)}}
}

hl2dm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function hl2dm.StartRound()
	game.CleanUpMap(false)

	if CLIENT then return end

	hl2dm.StartRoundSV()
end

hl2dm.SupportCenter = true

if SERVER then return end

hl2dm.GetTeamName = tdm.GetTeamName

hl2dm.LoadScreenTime = 6

local cgreen = Color(155,155,155)
local cgray = Color(255,255,255)
local cname = Color(0,0,0)

local function DrawScreen(lply,k)
    local name,color = hl2dm.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

    cname.r = color.r
    cname.g = color.g
    cname.b = color.b
    cname.a = k * 255

	cgray.a = k * 255
	cgreen.a = k * 255

	draw.DrawText(L("you",L(lply:GetNWString("ClassName"))),"H.25",w / 2,h / 2 - h / 6,cname,TEXT_ALIGN_CENTER)
 
	draw.DrawText(L("you_team",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
	draw.DrawText("H2 DM","H.25",w / 2,h / 8,cgreen,TEXT_ALIGN_CENTER)

	draw.DrawText(L("hl2dm_loadscreen"),"H.25",w / 2,h/ 1.2,cgray,TEXT_ALIGN_CENTER)
end

function hl2dm.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = hl2dm.GetTeamName(lply)

	if homicide.DrawLoadScreen(DrawScreen,hl2dm.LoadScreenTime) then return end

	tdm.DrawRoundTime()
end