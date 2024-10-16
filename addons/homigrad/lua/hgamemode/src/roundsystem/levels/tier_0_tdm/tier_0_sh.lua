-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_0_tdm\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.tdm = true

tdm = tdm or {}
tdm.Name = "Team Death Match"

local models = {}

for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end
for i = 1,6 do table.insert(models,"models/player/group01/female_0" .. i .. ".mdl") end

--table.insert(models,"models/player/group02/male_02.mdl")
--table.insert(models,"models/player/group02/male_06.mdl")
--table.insert(models,"models/player/group02/male_08.mdl")

--for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

tdm.models = models

tdm.red = {
	"terrorist",Color(255,75,75),
	weapons = {"weapon_radio","weapon_hands","med_band","med_band","med_kit","med_painkiller"},
	classes = {
		{
			"class_solder",
			main_weapon = {"wep_ak47","wep_m4a1","wep_scar","wep_val"},
			armors = {
				"ent_jack_gmod_ezarmor_zshhelm",
				"Medium-Vest",
				"ent_jack_gmod_ezarmor_thunderbolt"
			}
		},
		{
			"class_scout",
			main_weapon = {"wep_bizon","wep_mp5","wep_mac10"},
			armors = {
				"Medium-Helmet",
				"Light-Vest",
				"ent_jack_gmod_ezarmor_commandoblack"
			}
		},
		{
			"class_support",
			main_weapon = {"wep_870","wep_xm1014","wep_mag7","wep_neg"},
			armors = {
				"ent_jack_gmod_ezarmor_6b47chehol",
				"Medium-Vest",
				"ent_jack_gmod_ezarmor_thunderbolt",
				"ent_jack_gmod_ezarmor_llshoulder",
				"ent_jack_gmod_ezarmor_lrshoulder",
				"ent_jack_gmod_ezarmor_slforearm",
				"ent_jack_gmod_ezarmor_srforearm",
				"ent_jack_gmod_ezarmor_redutt5pelvis",
				"ent_jack_gmod_ezarmor_twexfilshieldb"
			}
		}
	},
	selectLink = 1,
	secondary_weapon = {"wep_fiveseven","wep_glock" , "wep_deagl"},
	models = models
}

tdm.blue = {
	"contr_terrorist",Color(75,75,255),
	weapons = tdm.red.weapons,
	classes = tdm.red.classes,
	selectLink = 1,
	secondary_weapon = tdm.red.secondary_weapon,
	models = models,
	armors = tdm.red.armors
}

tdm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function tdm.StartRound(data)
	game.CleanUpMap(false)

	team.SetColor(1,red)
	team.SetColor(2,blue)

	if CLIENT then
		return
	end

	return tdm.StartRoundSV()
end

function tdm.GetArmor(armor,col)
	if TypeID(armor) == TYPE_TABLE then
		if not IsColor(armor[2]) then--pizdes cring
			armor = armor[math.random(1,#armor)]
			
			if TypeID(armor) == TYPE_TABLE then
				if not IsColor(armor[2]) then
					armor = armor[math.random(1,#armor)]

					col = armor[2]
					armor = armor[1]
				else
					col = armor[2]
					armor = armor[1]
				end
			end
		else
			col = armor[2]
			armor = armor[1]
		end
	end

	return armor,col
end

function tdm.GetModel(model)
	local model = model[math.random(1,#model)]
	local bodygroup = {}

	if TypeID(model) == TYPE_TABLE then
		for i,value in pairs(model[2]) do
			bodygroup[i] = (TypeID(value) == TYPE_TABLE and math.random(value[1],value[2])) or value
		end

		model = model[1]
	end

	return model,bodygroup
end

if SERVER then return end

local colorRed = Color(255,0,0)

function tdm.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function tdm.ChangeValue(oldName,value)
	local oldValue = tdm[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function tdm.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end

tdm.LoadScreenTime = 6

local function DrawScreen(lply,k)
    local name,color = riot.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

	draw.DrawText(L("you",L(lply:GetNWString("ClassName"))),"H.25",w / 2,h / 2 - h / 6,cname,TEXT_ALIGN_CENTER)
 
    draw.DrawText(L("you_team",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
    draw.DrawText(L("tdm"),"H.25",w / 2,h / 8,cblue,TEXT_ALIGN_CENTER)

    draw.DrawText(L("tdm_loadscreen"), "H.25",w / 2,h / 1.2,cgray,TEXT_ALIGN_CENTER)
end

function tdm.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = tdm.GetTeamName(lply)

    if homicide.DrawLoadScreen(DrawScreen,tdm.LoadScreenTime) then return end

	tdm.DrawRoundTime()
end

function tdm.DrawRoundTime()
	if not roundTimeStart or not roundTime then return end
	
    local time = math.Round(roundTimeStart + roundTime - CurTime())

    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = acurcetime

        draw.SimpleText(acurcetime,"H.18",ScrW() / 2,ScrH() - 25,showRoundInfoColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end