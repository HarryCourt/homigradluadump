-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_1_jailbreak\\init_tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.jailbreak = true

jailbreak = jailbreak or {}
jailbreak.Name = "Jailbreak"

jailbreak.ranksList = {
    {"jailbreak_rank_1",Color(125,125,255),
        armors = {"Light-Helmet","ent_jack_gmod_ezarmor_azimutb","ent_jack_gmod_ezarmor_gruppa99t30b"}
    },
    {"jailbreak_rank_2",Color(75,75,255),
        armors = {"Light-Helmet","Light-Vest","ent_jack_gmod_ezarmor_azimutb","ent_jack_gmod_ezarmor_gruppa99t30b"}
    },
    {"jailbreak_rank_3",Color(25,25,25,255),
        armors = {"Riot-Helmet","Light-Vest","ent_jack_gmod_ezarmor_azimutb","ent_jack_gmod_ezarmor_gruppa99t30b"}
    },
    {"jailbreak_rank_4",Color(25,25,125),
        armors = {"Medium-Helmet","Medium-Light-Vest","ent_jack_gmod_ezarmor_azimutb","ent_jack_gmod_ezarmor_gruppa99t30b"}
    }
}

jailbreak.rankGeneral = {
    "jailbreak_rank_4",Color(55,0,200),
    armors = {"Ultra-Heavy-Helmet","Medium-Light-Vest","ent_jack_gmod_ezarmor_azimutb","ent_jack_gmod_ezarmor_gruppa99t30b"}
}

function jailbreak.GetRank(ply)
    local rankID = ply:GetNWInt("JailBreakRank",0)
    local rank = jailbreak.ranksList[rankID]

    if not rank and ply:IsAdmin() then return jailbreak.rankGeneral,true end

    return rank,rankID
end

jailbreak.red = {"jailbreak_red",Color(255,55,55),
    models = tdm.models
}

jailbreak.blue = {"jailbreak_blue",Color(55,55,255),
    weapons = {
        "weapon_radio",

        "met_band","met_band","met_band",
        "med_kit","med_kit","med_kit",
        "med_painkiller","med_painkiller","med_painkiller",
        "weapon_handcuffs","weapon_handcuffs","weapon_handcuffs",
        "weapon_taser",

        "weapon_gnade_flashbang"
    },
    main_weapon = {
        "wep_ak47",
        "wep_m4a1",
        "wep_scar"
    },
    secondary_weapon = {
        "wep_fiveseven",
        "wep_glock"
    },
    models = tdm.models
}

jailbreak.teamEncoder = {
    [1] = "red",
    [2] = "blue"
}

function jailbreak.GetMaxBlue()
    return math.max(math.floor(#team.GetPlayers(1) / 4),1)
end

function jailbreak.StartRound()
    team.SetColor(1,jailbreak.red[2])
    team.SetColor(2,jailbreak.blue[2])

    game.CleanUpMap(false)

    if CLIENT then return end

    jailbreak.StartRoundSV()
end

function jailbreak.CanUseSpawnMenu(ply)
    if ply:Team() == 2 and ply:Alive() then
        local rank,rankID = jailbreak.GetRank(ply)

        return rankID == true or rankID >= 4
    end
end

function jailbreak.CantUseFootkick() return false end

function jailbreak.TeamTab_Team(id,team)
    if id ~= 2 then return end

    local rank = jailbreak.GetRank(LocalPlayer())
    local col = rank[2]

    for i,armor in pairs(rank.armors or empty) do
        local armor,col = tdm.GetArmor(armor,col)

        team.armors[#team.armors + 1] = {JMod.ArmorValidName(armor),col}
    end
end

function jailbreak.DrawScreenspace() return false end