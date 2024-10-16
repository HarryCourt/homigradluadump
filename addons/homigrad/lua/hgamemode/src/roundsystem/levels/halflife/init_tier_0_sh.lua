-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\halflife\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.halflife = true

halflife = halflife or {}
halflife.Name = "Half Life"
halflife.DontCreateNapalm = true
halflife.noTwo = true

local models = {}
for i = 1,9 do table.insert(models,"models/player/group03/male_0" .. i .. ".mdl") end

local modelsMedical = {}
for i = 1,9 do table.insert(modelsMedical,"models/player/group03m/male_0" .. i .. ".mdl") end

halflife.red = {"hl2dm_rebels",Color(255,255,255),
	weapons = {"med_band","med_kit","med_painkiller"},
	CLASS = {
		{
			"Солдат",
			main_weapon = {"wep_smg1"},
			secondary_weapon = {"wep_pistol"},
			weapons = {
				"med_kit","med_kit","med_band",	
				"weapon_radio",
				"melee_knife",
				"wep_gnade_hl2",
			},
			armors = {
				"ent_jack_gmod_ezarmor_achhcblack",
				"ent_jack_gmod_ezarmor_thorcrv",
				"ent_jack_gmod_ezarmor_slforearm",
				"ent_jack_gmod_ezarmor_srforearm",
				"ent_jack_gmod_ezarmor_gruppa99t30b",
				"ent_jack_gmod_ezarmor_commandoblack",
				"ent_jack_gmod_ezarmor_afglasses",
				"ent_jack_gmod_ezarmor_respirator"
			},
			backpack = {"wep_food_canner","wep_food_canner","wep_food_canner"}
		},
		{
			"Прорывник",
			main_weapon = {"wep_stotgun"},
			secondary_weapon = {"wep_pistol"},
			weapons = {
				"med_kit","med_kit","med_band",
				"weapon_radio",
				"melee_knife",
				"wep_gnade_smokenade",
			},
			armors = {
				"ent_jack_gmod_ezarmor_bastion",
				"ent_jack_gmod_ezarmor_korundvm",
				"ent_jack_gmod_ezarmor_slforearm",
				"ent_jack_gmod_ezarmor_srforearm",
				"ent_jack_gmod_ezarmor_pillboxbp",
				"ent_jack_gmod_ezarmor_balmask",
				"ent_jack_gmod_ezarmor_commandoblack",
				"ent_jack_gmod_ezarmor_roundglasses"
			},
			backpack = {"wep_food_canner","wep_food_canner","wep_food_canner"}
		},
		{
			"Медик",
			main_weapon = {"wep_smg1"},
			secondary_weapon = {"wep_pistol"},
			weapons = {
				"med_kit","med_kit","med_kit","med_kit","med_kit",
				"med_band","med_band","med_band",
				"med_adrenaline",
				"med_painkiller","med_painkiller",
				"med_needle",
				"weapon_radio",
				"melee_kitknife",
				"wep_gnade_hl2",
			},
			armors = {
				"ent_jack_gmod_ezarmor_6b47",
				"ent_jack_gmod_ezarmor_paca",
				"ent_jack_gmod_ezarmor_sfmp",
				"ent_jack_gmod_ezarmor_commandoblack",
				"ent_jack_gmod_ezarmor_mframe",
				"ent_jack_gmod_ezarmor_respirator"
			},
			backpack = {"wep_food_cannerburger","wep_food_cannerburger","wep_food_cannerburger","wep_food_cannerburger","wep_food_cannerburger"},
			models = modelsMedical
		}
	},
	secondary_weapon = false,
	models = models
}

halflife.teamEncoder = {
	[1] = "red"
}

function halflife.StartRound()
	game.CleanUpMap(false)

	if CLIENT then return end

	halflife.StartRoundSV()
end

halflife.SupportCenter = true

if SERVER then return end

halflife.GetTeamName = tdm.GetTeamName

halflife.LoadScreenTime = 6

local cgreen = Color(155,155,155)
local cgray = Color(255,255,255)
local cname = Color(0,0,0)

local colorText = Color(255,0,255)

local k = 0

function halflife.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = halflife.GetTeamName(lply)

	local text = GetGlobalVar("Text") or ""

	colorText.a = 255 * k

	if text ~= "" then
		k = LerpFT(0.1,k,1)
	else
		k = LerpFT(0.1,k,0)
	end

	if k <= 0.01 then return end

	if lply:GetNWBool("InSave") then
		surface.SetDrawColor(colorText.r,colorText.g,colorText.b,colorText.a * 0.05)
		
		local h = scrh / 6 * (1 - math.cos(RealTime()) / 4)

		draw.GradientDown(0,scrh - h,scrw,h)

		h = scrh / 12

		draw.GradientUp(0,0,scrw,h)
	end

	draw.SimpleText(text,"H.45",ScrW() / 2,75,colorText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
