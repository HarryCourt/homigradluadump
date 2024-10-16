-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_2_construct\\modules\\list_valid_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
Construct.ValidList = {}

Construct.weapons_list = {}
local weapons_list = Construct.weapons_list

local function unpack(v,bool)
    if TypeID(v) == TYPE_TABLE then
        Construct.ValidList[v[1]] = v
        weapons_list[v[1]] = bool
    else
        Construct.ValidList[v] = true
        weapons_list[v] = bool
    end
end

for i,v in pairs({
    {"weapon_binokle","0"},
    {"weapon_radio","0"},
    {"weapon_molotok","60"},
    {"weapon_handcuffs",35},
    "weapon_per4ik",
    "weapon_taser",
    "weapon_handcuffs",

    --"weapon_gredammo",
    --"weapon_gredmimomet",

    "med_kit",
    {"megamed_kit",120},

    "med_band_big",
    "med_band_small",

    "med_painkiller",
    "med_needle",

    "med_adrenaline",

    {"food_fishcan","5"},
    {"food_spongebob_home","5"},
    {"food_lays","5"},
    {"food_monster","30"},

    {"ent_jack_gmod_ezarmor_ballon_o2",0},

    "ent_jack_gmod_ezammo"
}) do unpack(v,true) end

/*for i,v in pairs({
    "weapon_kabar",
    "weapon_bat",
    "weapon_hg_sleagehammer",
    "weapon_hg_kitknife",
    "weapon_hg_crowbar",
    "weapon_hg_metalbat",
    "weapon_hg_shovel",
    "weapon_hg_fireaxe",
    "weapon_police_bat",
    "melee_knife",
    "weapon_t",
    "weapon_hg_hatchet",
    "weapon_pipe",
    "weapon_hg_fubar"
}) do unpack(v,true) end*/

for i,v in pairs({
    "gmod_camera",
    "gmod_physgin",
    "gmod_toolgun",

    {"ent_spawnpoint",nil,2},
    "ent_storage",
    "keypad",

    {"ent_cupboard",nil,1},

    "gmod_sent_vehicle_fphysics_gaspump_diesel",
    "gmod_sent_vehicle_fphysics_gaspump_electric",
    "gmod_sent_vehicle_fphysics_gaspump",

    /*{"ent_jack_gmod_ezteleportradio",nil,1},
    {"ent_jack_gmod_ezaidradio",nil,1},

    "ent_jack_gmod_ezsolargenerator",
    "ent_jack_gmod_ezfuellantern"*/
}) do unpack(v) end

for class,ent in pairs(scripted_ents.GetList()) do
    if ArmorTableDEF[ent.t.ArmorName] then continue end

    if string.find(class,"ent_jack_gmod_ezarmor_") then unpack({class,0},true) end
end

/*for i,v in pairs({
    "sim_fphys_pwtrabant",
    "sim_fphys_pwtrabant02",
    "sim_fphys_pwvan",
    "sim_fphys_pwvolga",
    "sim_fphys_pwzaz",
    "sim_fphys_pwavia",
    "sim_fphys_pwgaz52",
    "sim_fphys_pwhatchback",
    "sim_fphys_pwliaz",
    "sim_fphys_pwmoskvich",
    "sim_fphys_conscriptapc",
    "sim_fphys_van"
}) do unpack(v) end*/

for i,v in pairs({
    "remover",
    "camera",
    "colour",
    "material",
    "shareprops",
    "precision",
    "keypad_willox",
    "fading_door",
    "prop_door",
    "weld",
    "button",
    --"light",
   -- "lamp",

    "streamradio",
    "prtcamera",
    "textscreen",
    "ledscreen",
}) do unpack(v) end

hook.Add("Content Icon Paint","Construct",function(panel,w,h)
    if not TableRound().UseConstruct or LocalPlayer():GetNWBool("IgnoreQ") then return end

    if not TableRound().ValidList[panel:GetSpawnName()] or (GetGlobalBool("lootbox") and weapons_list[panel:GetSpawnName()]) then
        surface.SetDrawColor(0,0,0,125)
        surface.DrawRect(5,5,w - 10,h - 10)

        draw.SimpleText("Запрещено","ChatFont",w / 2,h / 2,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end,2)