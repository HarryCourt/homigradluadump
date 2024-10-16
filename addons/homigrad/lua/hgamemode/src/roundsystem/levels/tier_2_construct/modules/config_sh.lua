-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\tier_2_construct\\modules\\config_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
Construct.limits = {
    prop = 10,
    sent = 10,
    vehicle = false,
    swep = false,
    tool = true
}

Construct.cooldownTypes = {
    prop = 1,
    sent = 2.5,
    swep = 5
}

Construct.blacklistModel = {
    ["models/props_c17/oildrum001_explosive.mdl"] = true,
    ["models/props_junk/gascan001a.mdl"] = true,
    ["models/props_junk/propane_tank001a.mdl"] = true,

    ["models/props_phx/torpedo.mdl"] = true,
    ["models/props_phx/mk-82.mdl"] = true,
    ["models/props_phx/ww2bomb.mdl"] = true,
    ["models/props_phx/oildrum001_explosive.mdl"] = true,
    ["models/props_phx/ball.mdl"] = true,
    ["models/props_phx/amraam.mdl"] = true,
    ["models/props_c17/canister02a.mdl"] = true,
    ["models/props_junk/metalgascan.mdl"] = true,
    ["models/props_c17/canister01a.mdl"] = true
}

Construct.CantPhysgunByClass = {
    "ent_jack_gmod_eztimebomb"
}

Construct.tool = {
    ["colour"] = true,
    ["remover"] = true,
    ["keypad_willox"] = true,
    ["fading_door"] = true
}