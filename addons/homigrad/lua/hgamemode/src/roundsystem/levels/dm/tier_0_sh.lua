-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\dm\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.dm = true

dm = dm or {}

local models = {}

for i = 1,9 do table.insert(models,"models/furious/player/policeint/policeint_male_0" .. i .. ".mdl") end

dm.red = {
	"Operator",Color(125,125,125),
	weapons = {"weapon_radio","weapon_hands","med_band","med_band","med_kit","med_painkiller","melee_kabar"},
    classes = {
        {
            "class_solder",
            main_weapon = {"wep_m4a1","wep_ak47","wep_val"}
        },
        {
            "class_scout",
            main_weapon = {"wep_mp7","wep_mp5","wep_mac10"}
        },
        {
            "class_support",
            main_weapon = {"wep_xm1014","wep_neg"}
        }
    },
	secondary_weapon = {"wep_fiveseven","wep_glock","wep_deagl"},
	models = tdm.models,
    armors = {
        {
            {"ent_jack_gmod_ezarmor_thorcrv",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_kora_kulon_b",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_korundvm",Color(255,255,255)}
        },
        {
            {"ent_jack_gmod_ezarmor_pillboxbp",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_lolkek3f",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_dufflebag",Color(255,255,255)}
        },
        {
            {"ent_jack_gmod_ezarmor_azimutb",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_bankrobber",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_thunderbolt",Color(255,255,255)}
        },
        {
            {"ent_jack_gmod_ezarmor_gascan",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_aviators",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_roundglasses",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_mframe",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_crossbow",Color(255,255,255)},
        },
        {
            {"ent_jack_gmod_ezarmor_razor",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_tacticalsport",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_xcel",Color(255,255,255)},
        },
        {
            {"ent_jack_gmod_ezarmor_bomber",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_leathercap",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_kotton",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_zryachiyhat",Color(255,255,255)},

            {"ent_jack_gmod_ezarmor_smokebalacvlava",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_zryachiibalacvlava",Color(255,255,255)},
            {"ent_jack_gmod_ezarmor_spookyskull",Color(255,255,255)},
        }
    }
}

dm.teamEncoder = {
	[1] = "red",
}

function dm.StartRound(data)
	game.CleanUpMap(false)

	if CLIENT then return end

	return dm.StartRoundSV()
end

dm.GetTeamName = tdm.GetTeamName
dm.LoadScreenTime = 6

if SERVER then return end

local cgray = Color(125,125,125)

local function DrawScreen(lply,k)
    local name,color = dm.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

    draw.DrawText(L("you",L(lply:GetNWString("ClassName"))),"H.25",w / 2,h / 2 - h / 6,cname,TEXT_ALIGN_CENTER)
 
    draw.DrawText(L("you",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
    draw.DrawText("Death Match" .. (GetGlobalBool("BodyCam") and "[BodyCam]" or ""),"H.25",w / 2,h / 8,cgray,TEXT_ALIGN_CENTER)
    draw.DrawText("Убей всех, останься в живых.","H.25",w / 2,h - h / 8,cgray,TEXT_ALIGN_CENTER)
end

function dm.BodyCam() return LocalPlayer():Alive() and LocalPlayer():Team() ~= 1002 and GetGlobalBool("BodyCam") end

function dm.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = tdm.GetTeamName(lply)

    if homicide.DrawLoadScreen(DrawScreen,dm.LoadScreenTime) then return end

	tdm.DrawRoundTime()

    bhop.DrawGodMod()

    homicide.DrawTTTButtons()
end