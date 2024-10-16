-- "addons\\jmod_eft\\lua\\jmod\\sh_eftarmor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()	

local Class1 = {
	[DMG_BUCKSHOT] = .2,
	[DMG_BLAST] = .05,
	[DMG_BULLET] = .15,
	[DMG_SNIPER] = .01,
	[DMG_AIRBOAT] = .1,
	[DMG_CLUB] = .1,
	[DMG_SLASH] = .3,
	[DMG_CRUSH] = .1,
	[DMG_VEHICLE] = .1,
	[DMG_BURN] = .1,
	[DMG_PLASMA] = .1,
	[DMG_ACID] = .1
}
local Class2 = {
	[DMG_BUCKSHOT] = .35,
	[DMG_BLAST] = .2,
	[DMG_BULLET] = .25,
	[DMG_SNIPER] = .1,
	[DMG_AIRBOAT] = .25,
	[DMG_CLUB] = .25,
	[DMG_SLASH] = .35,
	[DMG_CRUSH] = .35,
	[DMG_VEHICLE] = .25,
	[DMG_BURN] = .25,
	[DMG_PLASMA] = .25,
	[DMG_ACID] = .25
}
local Class3 = {
	[DMG_BUCKSHOT] = .45,
	[DMG_BLAST] = .35,
	[DMG_BULLET] = .55,
	[DMG_SNIPER] = .2,
	[DMG_AIRBOAT] = .45,
	[DMG_CLUB] = .5,
	[DMG_SLASH] = .5,
	[DMG_CRUSH] = .5,
	[DMG_VEHICLE] = .25,
	[DMG_BURN] = .25,
	[DMG_PLASMA] = .45,
	[DMG_ACID] = .45
}
local Class4 = {
	[DMG_BUCKSHOT] = .65,
	[DMG_BLAST] = .5,
	[DMG_BULLET] = .7,
	[DMG_SNIPER] = .35,
	[DMG_AIRBOAT] = .6,
	[DMG_CLUB] = .6,
	[DMG_SLASH] = .6,
	[DMG_CRUSH] = .6,
	[DMG_VEHICLE] = .3,
	[DMG_BURN] = .35,
	[DMG_PLASMA] = .6,
	[DMG_ACID] = .6
}
local Class5 = {
	[DMG_BUCKSHOT] = .9,
	[DMG_BLAST] = .7,
	[DMG_BULLET] = .8,
	[DMG_SNIPER] = .5,
	[DMG_AIRBOAT] = .75,
	[DMG_CLUB] = .75,
	[DMG_SLASH] = .8,
	[DMG_CRUSH] = .75,
	[DMG_VEHICLE] = .4,
	[DMG_BURN] = .35,
	[DMG_PLASMA] = .75,
	[DMG_ACID] = .75
}
local Class6 = {
	[DMG_BUCKSHOT] = .95,
	[DMG_BLAST] = .8,
	[DMG_BULLET] = .9,
	[DMG_SNIPER] = .75,
	[DMG_AIRBOAT] = .9,
	[DMG_CLUB] = .9,
	[DMG_SLASH] = 0.95,
	[DMG_CRUSH] = .9,
	[DMG_VEHICLE] = .6,
	[DMG_BURN] = .45,
	[DMG_PLASMA] = .9,
	[DMG_ACID] = .9
}

local NonArmorProtectionProfile = {
	[DMG_BUCKSHOT] = .1,
	[DMG_BLAST] = .05,
	[DMG_BULLET] = .05,
	[DMG_SNIPER] = .05,
	[DMG_AIRBOAT] = .05,
	[DMG_CLUB] = .05,
	[DMG_SLASH] = .05,
	[DMG_CRUSH] = .05,
	[DMG_VEHICLE] = .05,
	[DMG_BURN] = .05,
	[DMG_PLASMA] = .05,
	[DMG_ACID] = .05
}

local durmult = 1//GetConVarNumber( "jmod_eft_durmult" )
local wgtmult = 1//GetConVarNumber( "jmod_eft_wghtmult" )

local ArmorSounds = {
eq = "eft_gear_sounds/gear_armor_use.wav",
uneq = "eft_gear_sounds/gear_armor_drop.wav"
}
local BackpackSounds = {
eq = "eft_gear_sounds/gear_backpack_use.wav",
uneq = "eft_gear_sounds/gear_backpack_drop.wav"
}
local GenericSounds = {
eq = "eft_gear_sounds/gear_generic_use.wav",
uneq = "eft_gear_sounds/gear_generic_drop.wav"
}
local GogglesSounds = {
eq = "eft_gear_sounds/gear_goggles_use.wav",
uneq = "eft_gear_sounds/gear_goggles_drop.wav"
}
local HelmetSounds = {
eq = "eft_gear_sounds/gear_helmet_use.wav",
uneq = "eft_gear_sounds/gear_helmet_drop.wav"
}
local FShieldSounds = {
eq = "eft_gear_sounds/glassshield_on.wav",
uneq = "eft_gear_sounds/glassshield_off.wav"
}

-- this was configured for male 07

local size_bdy =  Vector(0.9,0.9,0.9)
local pos_bdy =   Vector(-2.7,-0.2,0)
local ang_bdy =   Angle(-93,0,90)

local size_head = Vector(0.95,0.95,0.95)
local pos_head =  Vector(0.5,2.2,0.15)
local ang_head =  Angle(-80,0,-90)

local size_eye =  Vector(0.95,0.95,0.95)
local pos_eye =   Vector(0.45,2.1,0.12)
local ang_eye =   Angle(-80,0,-90)

local size_arms = Vector(0.9,0.9,0.9)

local pos_rarm =  Vector(0,6.7,0.8)
local ang_rarm =  Angle(180,90,5)

local pos_larm =  Vector(0,6.7,-0.8)
local ang_larm =  Angle(0,-90,-5)

--[[
            _          
           (_)         
  _ __ ___  _ ___  ___ 
 | '_ ` _ \| / __|/ __|
 | | | | | | \__ \ (__ 
 |_| |_| |_|_|___/\___|
                                              
]]--

JMod.ArmorTable["White Catphones"] = {
	PrintName = "[HS] Catears [W]",
	mdl = "models/maku/catearheadphones_white.mdl", -- sci fi lt
	snds = GeneralSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = Vector(1, 1, 1),
	pos = Vector(.75, -.5, 0),
	ang = Angle(-80, 0, -90),
	wgt = wgtmult * .5,
	dur = durmult * 200,
	chrg = {
		power = 10
	},
	ent = "ent_jack_gmod_ezarmor_catphonewhite",
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	bon = "ValveBiped.Bip01_Head1",
		eff = {},
		slots = {
			acc_ears = 0
		},
		pos = Vector(.75, -.5, 0),
		ang = Angle(-80, 0, -90),
	}
}

JMod.ArmorTable["Black Catphones"] = {
	PrintName = "[HS] Catears [B]",
	mdl = "models/maku/catearheadphones_black.mdl", -- sci fi lt
	snds = GeneralSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = Vector(1, 1, 1),
	pos = Vector(.75, -.5, 0),
	ang = Angle(-80, 0, -90),
	wgt = wgtmult * .5,
	dur = durmult * 200,
	chrg = {
		power = 10
	},
	ent = "ent_jack_gmod_ezarmor_catphoneblack",
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	bon = "ValveBiped.Bip01_Head1",
		eff = {},
		slots = {
			acc_ears = 0
		},
		pos = Vector(.75, -.5, 0),
		ang = Angle(-80, 0, -90),
	}
}

	JMod.ArmorTable["SC Alpha"] = {
		PrintName = "[SC] Alpha",
		mdl = "models/eft_props/secureconts/alpha.mdl",
		slots = {
			waist = .5
		},
		snds = GenericSounds,
		storage = 4,
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Pelvis",
		siz = Vector(0.6, 0.6, 0.6),
		pos = Vector(4, -5, -4),
		ang = Angle(-100, 230, 90),
		wgt = 0.6,
		dur = 9999,
		ent = "ent_jack_gmod_ezarmor_sc_alpha"
	}

	JMod.ArmorTable["SC Beta"] = {
		PrintName = "[SC] Beta",
		mdl = "models/eft_props/secureconts/beta.mdl",
		slots = {
			waist = .5
		},
		snds = GenericSounds,
		storage = 6,
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Pelvis",
		siz = Vector(0.6, 0.6, 0.6),
		pos = Vector(4, -5, -4),
		ang = Angle(100, 40, 90),
		wgt = 0.8,
		dur = 9999,
		ent = "ent_jack_gmod_ezarmor_sc_beta"
	}

	JMod.ArmorTable["SC Epsilon"] = {
		PrintName = "[SC] Epsilon",
		mdl = "models/eft_props/secureconts/epsilon.mdl",
		slots = {
			waist = .5
		},
		snds = GenericSounds,
		storage = 8,
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Pelvis",
		siz = Vector(0.65, 0.65, 0.65),
		pos = Vector(4, -5, -4),
		ang = Angle(-100, 230, 90),
		wgt = 1.1,
		dur = 9999,
		ent = "ent_jack_gmod_ezarmor_sc_epsilon"
	}

	JMod.ArmorTable["SC Gamma"] = {
		PrintName = "[SC] Gamma",
		mdl = "models/eft_props/secureconts/gamma.mdl",
		slots = {
			waist = .5
		},
		snds = GenericSounds,
		storage = 9,
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Pelvis",
		siz = Vector(0.8, 0.8, 0.8),
		pos = Vector(4, -5, -4),
		ang = Angle(100, 40, 90),
		wgt = 1.2,
		dur = 9999,
		ent = "ent_jack_gmod_ezarmor_sc_gamma"
	}

	JMod.ArmorTable["SC Kappa"] = {
		PrintName = "[SC] Kappa",
		mdl = "models/eft_props/secureconts/kappa.mdl",
		slots = {
			waist = .5
		},
		snds = GenericSounds,
		storage = 6,
		def = NonArmorProtectionProfile,
		clr = { r = 255, g = 255, b = 255 },
		clrForced = true,
		bon = "ValveBiped.Bip01_Pelvis",
		siz = Vector(1, 1, 1),
		pos = Vector(4, -5, -4),
		ang = Angle(-100, 230, 90),
		wgt = 2,
		dur = 9999,
		ent = "ent_jack_gmod_ezarmor_sc_kappa"
	}

--[[
__ _ _ __ _ __ ___   ___  _ __ 
/ _` | '__| '_ ` _ \ / _ \| '__|
| (_| | |  | | | | | | (_) | |   
\__,_|_|  |_| |_| |_|\___/|_|    

]]--

JMod.ArmorTable["Module 3M"] = {
	PrintName = "[AR-2] Module 3M",
	mdl = "models/eft_props/gear/armor/ar_module3m.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 6,
	dur = durmult * 160,
	ent = "ent_jack_gmod_ezarmor_module3m"
}

JMod.ArmorTable["PACA"] = {
	PrintName = "[AR-2] PACA",
	mdl = "models/eft_props/gear/armor/ar_paca.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 3.5,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_paca"
}

JMod.ArmorTable["6B2"] = {
	PrintName = "[AR-2] 6B2",
	mdl = "models/eft_props/gear/armor/ar_6b2.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 5.4,
	dur = durmult * 145,
	ent = "ent_jack_gmod_ezarmor_6b2"
}

JMod.ArmorTable["Untar Vest"] = {
	PrintName = "[AR-3] Untar Vest",
	mdl = "models/eft_props/gear/armor/ar_untar.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 5.4,
	dur = durmult * 145,
	ent = "ent_jack_gmod_ezarmor_untar"
}

JMod.ArmorTable["Kora-Kulon"] = {
	PrintName = "[AR-2] Kora-Kulon",
	mdl = "models/eft_props/gear/armor/ar_kirasa_black.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 5.4,
	dur = durmult * 145,
	ent = "ent_jack_gmod_ezarmor_kora_kulon_b"
}

JMod.ArmorTable["Kora-Kulon DFL"] = {
	PrintName = "[AR-2] Kora-Kulon DFL",
	mdl = "models/eft_props/gear/armor/ar_kirasa_camo.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 5.4,
	dur = durmult * 145,
	ent = "ent_jack_gmod_ezarmor_kora_kulon_dfl"
}

JMod.ArmorTable["Zhuk3 Press"] = {
	PrintName = "[AR-3] Zhuk3 Press",
	mdl = "models/eft_props/gear/armor/ar_beetle3.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 5.2,
	dur = durmult * 111,
	ent = "ent_jack_gmod_ezarmor_zhukpress"
}

JMod.ArmorTable["6B23"] = {
	PrintName = "[AR-3] 6B23-1",
	mdl = "models/eft_props/gear/armor/ar_6b23-1.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.9,
	dur = durmult * 86,
	ent = "ent_jack_gmod_ezarmor_6b23"
}

JMod.ArmorTable["Kirasa-N"] = {
	PrintName = "[AR-3] BNTI Kirasa-N",
	mdl = "models/eft_props/gear/armor/ar_kirasa_n.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.1,
	dur = durmult * 140,
	ent = "ent_jack_gmod_ezarmor_kirasan"
}

JMod.ArmorTable["Trooper TFO"] = {
	PrintName = "[AR-4] Trooper TFO",
	mdl = "models/eft_props/gear/armor/ar_trooper.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 6.8,
	dur = durmult * 189,
	ent = "ent_jack_gmod_ezarmor_trooper"
}

JMod.ArmorTable["NFM THOR CRV"] = {
	PrintName = "[AR-4] NFM THOR CRV",
	mdl = "models/eft_props/gear/armor/ar_thor_crv.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9,
	dur = durmult * 70,
	ent = "ent_jack_gmod_ezarmor_thorcrv"
}

JMod.ArmorTable["6B13"] = {
	PrintName = "[AR-4] 6B13 (Digi)",
	mdl = "models/eft_props/gear/armor/ar_6b13_digi.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 10.5,
	dur = durmult * 59,
	ent = "ent_jack_gmod_ezarmor_6b13"
}

JMod.ArmorTable["6B13 Flora"] = {
	PrintName = "[AR-4] 6B13 (Flora)",
	mdl = "models/eft_props/gear/armor/ar_6b13_flora.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 10.5,
	dur = durmult * 59,
	ent = "ent_jack_gmod_ezarmor_6b13flora"
}

JMod.ArmorTable["6B232"] = {
	PrintName = "[AR-4] 6B23-2",
	mdl = "models/eft_props/gear/armor/ar_6b23-2.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.2,
	dur = durmult * 69,
	ent = "ent_jack_gmod_ezarmor_6b232"
}

JMod.ArmorTable["OTV"] = {
	PrintName = "[AR-4] OTV (UCP)",
	mdl = "models/eft_props/gear/armor/ar_otv_ucp.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.4,
	dur = durmult * 75,
	ent = "ent_jack_gmod_ezarmor_interceptor"
}

JMod.ArmorTable["HPC"] = {
	PrintName = "[AR-5] Hexatac HPC",
	mdl = "models/eft_props/gear/armor/ar_hexatac.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.5,
	dur = durmult * 111,
	ent = "ent_jack_gmod_ezarmor_hexatachpc"
}

JMod.ArmorTable["Korund"] = {
	PrintName = "[AR-5] Korund-VM",
	mdl = "models/eft_props/gear/armor/ar_korundvm.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.8,
	dur = durmult * 64,
	ent = "ent_jack_gmod_ezarmor_korundvm"
}

JMod.ArmorTable["Redut-M"] = {
	PrintName = "[AR-5] Redut-M",
	mdl = "models/eft_props/gear/armor/ar_redut_m.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 10,
	dur = durmult * 140,
	ent = "ent_jack_gmod_ezarmor_redutm"
}

JMod.ArmorTable["Redut-M Neck"] = {
	PrintName = "[AR-5] Redut-M Neck",
	mdl = "models/eft_props/gear/armor/ar_redut_m_neck.mdl", 
	snds = ArmorSounds,
	slots = {
		acc_neck = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 1.5,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_redutm_neck"
}

JMod.ArmorTable["Redut-M Pelvis"] = {
	PrintName = "[AR-5] Redut-M Pelvis",
	mdl = "models/eft_props/gear/armor/ar_redut_m_pelvis.mdl", 
	snds = ArmorSounds,
	slots = {
		pelvis = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 2,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_redutm_pelvis"
}

JMod.ArmorTable["6B13 M"] = {
	PrintName = "[AR-5] 6B13M (Killa)",
	mdl = "models/eft_props/gear/armor/ar_6b13_killa.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.5,
	dur = durmult * 133,
	ent = "ent_jack_gmod_ezarmor_6b13m"
}

JMod.ArmorTable["Gzhel-K"] = {
	PrintName = "[AR-5] Gzhel-K",
	mdl = "models/eft_props/gear/armor/ar_gjel.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.9,
	dur = durmult * 81,
	ent = "ent_jack_gmod_ezarmor_gzhelk"
}

JMod.ArmorTable["Defender-2"] = {
	PrintName = "[AR-5] Defender-2",
	mdl = "models/eft_props/gear/armor/ar_defender2.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 11.5,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_defender2"
}

JMod.ArmorTable["IOTV Gen4 Vest"] = {
	PrintName = "[AR-5] IOTV Gen4 Vest",
	mdl = "models/eft_props/gear/armor/ar_iotv.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 13,
	dur = durmult * 85,
	ent = "ent_jack_gmod_ezarmor_iotvvest",
	gayPhysics = true
}

JMod.ArmorTable["IOTV Gen4 Pelvis"] = {
	PrintName = "[AR-5] IOTV Gen4 Pelvis",
	mdl = "models/eft_props/gear/armor/ar_iotv_lower.mdl", -- csgo misc
	snds = ArmorSounds,
	slots = {
		pelvis = 1
	},
	bdg = {
		[1] = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 1.5,
	dur = durmult * 90,
	ent = "ent_jack_gmod_ezarmor_iotvpelvis"
}

JMod.ArmorTable["IOTV Gen4 Left Shoulder"] = {
	PrintName = "[AR-5] IOTV Gen4 L.Shoulder",
	mdl = "models/eft_props/gear/armor/ar_iotv_shoulder_l.mdl", -- csgo hydra
	snds = ArmorSounds,
	slots = {
		leftshoulder = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_L_UpperArm",
	siz = size_arms,
	pos = pos_larm,
	ang = ang_larm,
	wgt = wgtmult * 1.5,
	dur = durmult * 95,
	ent = "ent_jack_gmod_ezarmor_iotvlshoulder"
}

JMod.ArmorTable["IOTV Gen4 RightShoulder"] = {
	PrintName = "[AR-5] IOTV Gen4 R.Shoulder",
	mdl = "models/eft_props/gear/armor/ar_iotv_shoulder_r.mdl", -- csgo hydra
	snds = ArmorSounds,
	slots = {
		rightshoulder = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_R_UpperArm",
	siz = size_arms,
	pos = pos_rarm,
	ang = ang_rarm,
	wgt = wgtmult * 1.5,
	dur = durmult * 95,
	ent = "ent_jack_gmod_ezarmor_iotvrhoulder"
}

JMod.ArmorTable["Redut-T5 Vest"] = {
	PrintName = "[AR-5] Redut-T5 Vest",
	mdl = "models/eft_props/gear/armor/ar_redut_t5.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9,
	dur = durmult * 180,
	ent = "ent_jack_gmod_ezarmor_redutt5vest"
}

JMod.ArmorTable["Redut-T5 Neck"] = {
	PrintName = "[AR-5] Redut-T5 Neck",
	mdl = "models/eft_props/gear/armor/ar_redut_t5_neck.mdl", 
	snds = ArmorSounds,
	slots = {
		acc_neck = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 2.5,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_redutt5_neck"
}

JMod.ArmorTable["Redut-T5 Pelvis"] = {
	PrintName = "[AR-5] Redut-T5 Pelvis",
	mdl = "models/eft_props/gear/armor/ar_redut_t5_lower.mdl", 
	snds = ArmorSounds,
	slots = {
		pelvis = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 3.5,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_redutt5pelvis"
}

JMod.ArmorTable["Redut-T5 L. Brassard"] = {
	PrintName = "[AR-5] Redut-T5 L. Brassard",
	mdl = "models/eft_props/gear/armor/ar_redut_t5_shoulder_l.mdl", -- csgo hydra
	snds = ArmorSounds,
	slots = {
		leftshoulder = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_L_UpperArm",
	siz = size_arms,
	pos = pos_larm,
	ang = ang_larm,
	wgt = wgtmult * 1.5,
	dur = durmult * 170,
	ent = "ent_jack_gmod_ezarmor_redutt5lshoulder"
}

JMod.ArmorTable["Redut-T5 R. Brassard"] = {
	PrintName = "[AR-5] Redut-T5 R. Brassard",
	mdl = "models/eft_props/gear/armor/ar_redut_t5_shoulder_r.mdl", -- csgo hydra
	snds = ArmorSounds,
	slots = {
		rightshoulder = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_R_UpperArm",
	siz = size_arms,
	pos = pos_rarm,
	ang = ang_rarm,
	wgt = wgtmult * 1.5,
	dur = durmult * 170,
	ent = "ent_jack_gmod_ezarmor_redutt5rshoulder"
}

JMod.ArmorTable["Hexgrid"] = {
	PrintName = "[AR-6] 5.11 Hexgrid",
	mdl = "models/eft_props/gear/armor/ar_custom_hexgrid.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.7,
	dur = durmult * 111,
	ent = "ent_jack_gmod_ezarmor_hexgrid"
}

JMod.ArmorTable["Slick Black"] = {
	PrintName = "[AR-6] Slick Black",
	mdl = "models/eft_props/gear/armor/ar_slick_b.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.7,
	dur = durmult * 114,
	ent = "ent_jack_gmod_ezarmor_slickblack"
}

	JMod.ArmorTable["Slick Tan"] = {
	PrintName = "[AR-6] Slick Tan",
	mdl = "models/eft_props/gear/armor/ar_slick_t.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.7,
	dur = durmult * 114,
	ent = "ent_jack_gmod_ezarmor_slicktan"
}

JMod.ArmorTable["Slick Olive"] = {
	PrintName = "[AR-6] Slick Olive",
	mdl = "models/eft_props/gear/armor/ar_slick_o.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.7,
	dur = durmult * 114,
	ent = "ent_jack_gmod_ezarmor_slickolive"
}

JMod.ArmorTable["BNTI Zhuk-6a"] = {
	PrintName = "[AR-6] Zhuk-6a",
	mdl = "models/eft_props/gear/armor/ar_beetle6a.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9,
	dur = durmult * 94,
	ent = "ent_jack_gmod_ezarmor_zhuk6a"
}

JMod.ArmorTable["THOR IC Vest"] = {
	PrintName = "[AR-6] NFM THOR IC Vest",
	mdl = "models/eft_props/gear/armor/ar_thor_intcar.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 10.0,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_thoricvest"
}

JMod.ArmorTable["THOR IC Pelvis"] = {
	PrintName = "[AR-6] NFM THOR IC Pelvis",
	mdl = "models/eft_props/gear/armor/ar_thor_intcar_pelvis.mdl", -- csgo misc
	snds = ArmorSounds,
	slots = {
		pelvis = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 2.0,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_thoricpelvis"
}

JMod.ArmorTable["THOR IC Neck"] = {
	PrintName = "[AR-6] NFM THOR IC Neck",
	mdl = "models/eft_props/gear/armor/ar_thor_intcar_neck.mdl", -- csgo misc
	snds = ArmorSounds,
	slots = {
		acc_neck = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 2.0,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_thoricneck"
}

JMod.ArmorTable["NFM THOR IC Left Shoulder"] = {
	PrintName = "[AR-6] NFM THOR IC Left Shoulder",
	mdl = "models/eft_props/gear/armor/ar_thor_intcar_shoulder_l.mdl", -- csgo hydra
	snds = ArmorSounds,
	slots = {
		leftshoulder = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_L_UpperArm",
	siz = size_arms,
	pos = pos_larm,
	ang = ang_larm,
	wgt = wgtmult * 2.0,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_thoriclshoulder"
}

JMod.ArmorTable["NFM THOR IC Right Shoulder"] = {
	PrintName = "[AR-6] NFM THOR IC Right Shoulder",
	mdl = "models/eft_props/gear/armor/ar_thor_intcar_shoulder_r.mdl", -- csgo hydra
	snds = ArmorSounds,
	slots = {
		rightshoulder = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_R_UpperArm",
	siz = size_arms,
	pos = pos_rarm,
	ang = ang_rarm,
	wgt = wgtmult * 2.0,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_thoricrhoulder"
}

JMod.ArmorTable["6B43 Vest"] = {
	PrintName = "[AR-6] 6B43 Vest",
	mdl = "models/eft_props/gear/armor/ar_6b43_body.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 13.0,
	dur = durmult * 150,
	ent = "ent_jack_gmod_ezarmor_6b43vest",
	gayPhysics = true
}

JMod.ArmorTable["6B43 Pelvis"] = {
	PrintName = "[AR-6] 6B43 Pelvis",
	mdl = "models/eft_props/gear/armor/ar_6b43_pelvis.mdl", 
	snds = ArmorSounds,
	slots = {
		pelvis = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 1.5,
	dur = durmult * 120,
	ent = "ent_jack_gmod_ezarmor_6b43pelvis"
}

JMod.ArmorTable["6B43 Neck"] = {
	PrintName = "[AR-6] 6B43 Neck",
	mdl = "models/eft_props/gear/armor/ar_6b43_neck.mdl", 
	snds = ArmorSounds,
	slots = {
		acc_neck = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 2.0,
	dur = durmult * 120,
	ent = "ent_jack_gmod_ezarmor_6b43neck"
}

JMod.ArmorTable["6B43 Left Shoulder"] = {
	PrintName = "[AR-6] 6B43 L.Sh",
	mdl = "models/eft_props/gear/armor/ar_6b43_shoulder_l.mdl", 
	snds = ArmorSounds,
	slots = {
		leftshoulder = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_L_UpperArm",
	siz = size_arms,
	pos = pos_larm,
	ang = ang_larm,
	wgt = wgtmult * 1.75,
	dur = durmult * 120,
	ent = "ent_jack_gmod_ezarmor_6b43lshoulder"
}

JMod.ArmorTable["6B43 RightShoulder"] = {
	PrintName = "[AR-6] 6B43 R.Sh",
	mdl = "models/eft_props/gear/armor/ar_6b43_shoulder_r.mdl", 
	snds = ArmorSounds,
	slots = {
		rightshoulder = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_R_UpperArm",
	siz = size_arms,
	pos = pos_rarm,
	ang = ang_rarm,
	wgt = wgtmult * 1.75,
	dur = durmult * 120,
	ent = "ent_jack_gmod_ezarmor_6b43rhoulder"
}

--[[
										_        _               _        _           
										| |      | |             | |      (_)          
__ _ _ __ _ __ ___   ___  _ __ ___  __| |   ___| |__   ___  ___| |_ _ __ _  __ _ ___ 
/ _` | '__| '_ ` _ \ / _ \| '__/ _ \/ _` |  / __| '_ \ / _ \/ __| __| '__| |/ _` / __|
| (_| | |  | | | | | | (_) | | |  __/ (_| | | (__| | | |  __/\__ \ |_| |  | | (_| \__ \
\__,_|_|  |_| |_| |_|\___/|_|  \___|\__,_|  \___|_| |_|\___||___/\__|_|  |_|\__, |___/
																			__/ |    
																			|___/     
]]--

JMod.ArmorTable["6B516"] = {
	PrintName = "[ACR-3] 6B5-16",
	mdl = "models/eft_props/gear/armor/cr/cr_6b5_16.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.1,
	dur = durmult * 145,
	storage = 10,
	ent = "ent_jack_gmod_ezarmor_6b516"
}

JMod.ArmorTable["TV115"] = {
	PrintName = "[ACR-3] WT TV-115",
	mdl = "models/eft_props/gear/armor/cr/cr_tv115.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 4.5,
	dur = durmult * 144,
	storage = 13,
	ent = "ent_jack_gmod_ezarmor_tv115"
}

JMod.ArmorTable["EAI MBSS"] = {
	PrintName = "[ACR-3] MBSS",
	mdl = "models/eft_props/gear/armor/cr/cr_mbss.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 5.2,
	dur = durmult * 155,
	storage = 12,
	ent = "ent_jack_gmod_ezarmor_eaimbss"
}

JMod.ArmorTable["Eagle Industries MMAC"] = {
	PrintName = "[ACR-4] MMAC",
	mdl = "models/eft_props/gear/armor/cr/cr_mmac.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,

	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.2,
	dur = durmult * 89,
	storage	= 14,
	ent = "ent_jack_gmod_ezarmor_mmac"
}

JMod.ArmorTable["Banshee"] = {
	PrintName = "[ACR-4] Banshee",
	mdl = "models/eft_props/gear/armor/cr/cr_shellback_tactical_banshee.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 6.9,
	dur = durmult * 100,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_banshee"
}

JMod.ArmorTable["Ars Arma A18"] = {
	PrintName = "[ACR-4] A18 Skanda",
	mdl = "models/eft_props/gear/armor/cr/cr_ars_arma_18.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.2,
	dur = durmult * 160,
	storage = 25,
	ent = "ent_jack_gmod_ezarmor_arsarmaa18"
}

JMod.ArmorTable["TV110"] = {
	PrintName = "[ACR-4] WT TV-110",
	mdl = "models/eft_props/gear/armor/cr/cr_tv110.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 10.3,
	dur = durmult * 121,
	storage = 23,
	ent = "ent_jack_gmod_ezarmor_tv110"
}

JMod.ArmorTable["Strandhogg"] = {
	PrintName = "[ACR-4] Strandhogg",
	mdl = "models/eft_props/gear/armor/cr/cr_strandhogg.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 6.5,
	dur = durmult * 75,
	storage = 17,
	ent = "ent_jack_gmod_ezarmor_strandhogg"
}

JMod.ArmorTable["RBAV-AF"] = {
	PrintName = "[ACR-4] RBAV-AF",
	mdl = "models/eft_props/gear/armor/cr/cr_bae_rbav_af.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.5,
	dur = durmult * 82,
	storage = 19,
	ent = "ent_jack_gmod_ezarmor_rbavaf"
}

JMod.ArmorTable["Osprey MK4A A"] = {
	PrintName = "[ACR-4] Osprey MK4A A",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_assault.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.7,
	dur = durmult * 100,
	storage = 25,
	ent = "ent_jack_gmod_ezarmor_ospreyass"
}

JMod.ArmorTable["MK4A Neck"] = {
	PrintName = "[AGC-0] MK4A Neck",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_neck.mdl", 
	snds = ArmorSounds,
	slots = {
		acc_neck = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.7,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_ospreyassneck"
}

JMod.ArmorTable["MK4A L.SH.Guard"] = {
	PrintName = "[AGC-0] MK4A L.Sh.Guard",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_brassard_l.mdl", 
	snds = ArmorSounds,
	slots = {
		acc_lshoulder = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * .5,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_ospreylshguard"
}

JMod.ArmorTable["MK4A R.SH.Guard"] = {
	PrintName = "[AGC-0] MK4A R.Sh.Guard",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_brassard_r.mdl", 
	snds = ArmorSounds,
	slots = {
		acc_rshoulder = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * .5,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_ospreyrshguard"
}

JMod.ArmorTable["MK4A A L.Brassard"] = {
	PrintName = "[ACR-4] MK4A A L.Brassard",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_l.mdl", 
	snds = ArmorSounds,
	slots = {
		leftshoulder = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_L_UpperArm",
	siz = size_arms,
	pos = pos_larm,
	ang = ang_larm,
	wgt = wgtmult * 1.0,
	dur = durmult * 75,
	ent = "ent_jack_gmod_ezarmor_mk4aalbrassard"
}

JMod.ArmorTable["MK4A A R.Brassard"] = {
	PrintName = "[ACR-4] MK4A A R.Brassard",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_r.mdl", 
	snds = ArmorSounds,
	slots = {
		rightshoulder = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_R_UpperArm",
	siz = size_arms,
	pos = pos_rarm,
	ang = ang_rarm,
	wgt = wgtmult * 1.0,
	dur = durmult * 75,
	ent = "ent_jack_gmod_ezarmor_mk4aarbrassard"
}

JMod.ArmorTable["6B3TM"] = {
	PrintName = "[ACR-4] 6B3TM-01M",
	mdl = "models/eft_props/gear/armor/cr/cr_6b3.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.2,
	dur = durmult * 73,
	storage = 12,
	ent = "ent_jack_gmod_ezarmor_6b3tm"
}	

JMod.ArmorTable["6B515"] = {
	PrintName = "[ACR-4] 6B5-15",
	mdl = "models/eft_props/gear/armor/cr/cr_6b5_15.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 12.2,
	dur = durmult * 63,
	storage = 10,
	ent = "ent_jack_gmod_ezarmor_6b515"
}

JMod.ArmorTable["M2"] = {
	PrintName = "[ACR-4] M2",
	mdl = "models/eft_props/gear/armor/cr/cr_m2.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.0,
	dur = durmult * 109,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_m2"
}

JMod.ArmorTable["M1"] = {
	PrintName = "[ACR-4] M1",
	mdl = "models/eft_props/gear/armor/cr/cr_m1.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.3,
	dur = durmult * 93,
	storage = 20,
	ent = "ent_jack_gmod_ezarmor_m1"
}

JMod.ArmorTable["Crye Precision AVS"] = {
	PrintName = "[ACR-4] CRYE AVS",
	mdl = "models/eft_props/gear/armor/cr/cr_crye_avs.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		pelvis = 1,
		acc_chestrig = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.7,
	dur = durmult * 140,
	storage = 23,
	ent = "ent_jack_gmod_ezarmor_cryeavs",
}

JMod.ArmorTable["TacTec"] = {
	PrintName = "[ACR-5] 5.11 TacTec",
	mdl = "models/eft_props/gear/armor/cr/cr_carrier_tactec.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.5,
	dur = durmult * 111,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_tactec"
}

JMod.ArmorTable["AACPC"] = {
	PrintName = "[ACR-5] Ars Arma CPC MOD.2",
	mdl = "models/eft_props/gear/armor/cr/cr_arscpc.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 8.5,
	dur = durmult * 133,
	storage = 23,
	ent = "ent_jack_gmod_ezarmor_aacpc"
}

JMod.ArmorTable["CPC GE"] = {
	PrintName = "[ACR-5] CPC GE",
	mdl = "models/eft_props/gear/armor/cr/cr_black_knight.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 9.6,
	dur = durmult * 150,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_cpcge"
}

JMod.ArmorTable["PlateFrame GE"] = {
	PrintName = "[ACR-5] PlateFrame GE",
	mdl = "models/eft_props/gear/armor/cr/cr_precision_bigpipe.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 6.4,
	dur = durmult * 189,
	storage = 10,
	ent = "ent_jack_gmod_ezarmor_plateframege"
}


JMod.ArmorTable["Osprey MK4A P"] = {
	PrintName = "[ACR-5] Osprey MK4A P",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_defence.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 10.5,
	dur = durmult * 100,
	storage = 24,
	ent = "ent_jack_gmod_ezarmor_ospreyprotec"
}

JMod.ArmorTable["MK4A P L.Brassard"] = {
	PrintName = "[ACR-5] MK4A P L.Brassard",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_l.mdl", 
	snds = ArmorSounds,
	slots = {
		leftshoulder = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_L_UpperArm",
	siz = size_arms,
	pos = pos_larm,
	ang = ang_larm,
	wgt = wgtmult * 1.0,
	dur = durmult * 75,
	ent = "ent_jack_gmod_ezarmor_mk4aplbrassard"
}

JMod.ArmorTable["MK4A P R.Brassard"] = {
	PrintName = "[ACR-5] MK4A P R.Brassard",
	mdl = "models/eft_props/gear/armor/cr/cr_osprey_shoulder_r.mdl", 
	snds = ArmorSounds,
	slots = {
		rightshoulder = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_R_UpperArm",
	siz = size_arms,
	pos = pos_rarm,
	ang = ang_rarm,
	wgt = wgtmult * 1.0,
	dur = durmult * 75,
	ent = "ent_jack_gmod_ezarmor_mk4aprbrassard"
}

JMod.ArmorTable["Bagariy"] = {
	PrintName = "[ACR-5] Bagariy",
	mdl = "models/eft_props/gear/armor/cr/cr_bagarii.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		abdomen = 1,
		acc_chestrig = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 13.0,
	dur = durmult * 79,
	storage = 25,
	ent = "ent_jack_gmod_ezarmor_bagariy"
}

JMod.ArmorTable["TT SK"] = {
	PrintName = "[ACR-6] TT SK",
	mdl = "models/eft_props/gear/armor/cr/cr_tt_plate_carrier.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.5,
	dur = durmult * 50,
	storage = 8,
	ent = "ent_jack_gmod_ezarmor_ttsk"
}

JMod.ArmorTable["MBAV Tagilla"] = {
	PrintName = "[ACR-6] AVS MBAV",
	mdl = "models/eft_props/gear/armor/cr/cr_tagilla.mdl", 
	snds = ArmorSounds,
	slots = {
		chest = 1,
		acc_chestrig = 1,
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	wgt = wgtmult * 7.8,
	dur = durmult * 109,
	storage = 12,
	ent = "ent_jack_gmod_ezarmor_tagilla"
}

--[[
_                _                     _        
| |              | |                   | |       
| |__   __ _  ___| | ___ __   __ _  ___| | _____ 
| '_ \ / _` |/ __| |/ / '_ \ / _` |/ __| |/ / __|
| |_) | (_| | (__|   <| |_) | (_| | (__|   <\__ \
|_.__/ \__,_|\___|_|\_\ .__/ \__,_|\___|_|\_\___/
					| |                        
					|_|                        
]]--

JMod.ArmorTable["6Sh118"] = {
	PrintName = "[BP] 6Sh118",
	mdl = "models/eft_props/gear/backpacks/bp_6sh118.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 3.5,
	dur = durmult * 999,
	storage	= 48,
	ent = "ent_jack_gmod_ezarmor_6sh118",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["LBT-2670 SFMP"] = {
	PrintName = "[BP] LBT-2670 SFMP",
	mdl = "models/eft_props/gear/backpacks/bp_medpack.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.92,
	dur = durmult * 999,
	storage	= 48,
	ent = "ent_jack_gmod_ezarmor_sfmp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Blackjack"] = {
	PrintName = "[BP] Blackjack",
	mdl = "models/eft_props/gear/backpacks/bp_blackjack.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 3.265,
	dur = durmult * 999,
	storage	= 42,
	ent = "ent_jack_gmod_ezarmor_blackjack",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["F4 Terminator"] = {
	PrintName = "[BP] F4 Terminator",
	mdl = "models/eft_props/gear/backpacks/bp_f4terminator.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 4.194,
	dur = durmult * 999,
	storage	= 40,
	ent = "ent_jack_gmod_ezarmor_f4terminator",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["SSO Attack 2"] = {
	PrintName = "[BP] SSO Attack 2",
	mdl = "models/eft_props/gear/backpacks/bp_s_so.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.8,
	dur = durmult * 999,
	storage	= 35,
	ent = "ent_jack_gmod_ezarmor_attack2",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["TT Trooper 35"] = {
	PrintName = "[BP] Trooper 35",
	mdl = "models/eft_props/gear/backpacks/bp_trooper_35.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.004,
	dur = durmult * 999,
	storage	= 35,
	ent = "ent_jack_gmod_ezarmor_tttrooper35",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Pilgrim"] = {
	PrintName = "[BP] Pilgrim",
	mdl = "models/eft_props/gear/backpacks/bp_piligrimm.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 3.48,
	dur = durmult * 999,
	storage	= 35,
	ent = "ent_jack_gmod_ezarmor_piligrim",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Paratus 3-Day"] = {
	PrintName = "[BP] Paratus 3-Day",
	mdl = "models/eft_props/gear/backpacks/bp_paratus_3_day.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.01,
	dur = durmult * 999,
	storage	= 35,
	ent = "ent_jack_gmod_ezarmor_paratus",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Gunslinger"] = {
	PrintName = "[BP] G2 Gunslinger II",
	mdl = "models/eft_props/gear/backpacks/bp_g2_gunslinger.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.948,
	dur = durmult * 999,
	storage	= 35,
	ent = "ent_jack_gmod_ezarmor_gunslinger",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Mechanism"] = {
	PrintName = "[BP] Mechanism",
	mdl = "models/eft_props/gear/backpacks/bp_oakley_mechanism.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 0.997,
	dur = durmult * 999,
	storage	= 32,
	ent = "ent_jack_gmod_ezarmor_mechanismbp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Beta 2 Battle BP"] = {
	PrintName = "[BP] Beta 2 Battle BP",
	mdl = "models/eft_props/gear/backpacks/bp_anatactical_beta.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.0,
	dur = durmult * 999,
	storage	= 30,
	ent = "ent_jack_gmod_ezarmor_beta2bp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Gruppa 99 T30 (B)"] = {
	PrintName = "[BP] Gruppa 99 T30 (B)",
	mdl = "models/eft_props/gear/backpacks/bp_gr99_t30_b.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.4,
	dur = durmult * 999,
	storage	= 30,
	ent = "ent_jack_gmod_ezarmor_gruppa99t30b",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Gruppa 99 T30 (M)"] = {
	PrintName = "[BP] Gruppa 99 T30 (M)",
	mdl = "models/eft_props/gear/backpacks/bp_gr99_t30_m.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.4,
	dur = durmult * 999,
	storage	= 30,
	ent = "ent_jack_gmod_ezarmor_gruppa99t30m",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["F5 Switchblade"] = {
	PrintName = "[BP] F5 Switchblade",
	mdl = "models/eft_props/gear/backpacks/bp_f5switchblade.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.632,
	dur = durmult * 999,
	storage	= 30,
	ent = "ent_jack_gmod_ezarmor_switchblade",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Tri-Zip"] = {
	PrintName = "[BP] Tri-Zip",
	mdl = "models/eft_props/gear/backpacks/bp_trizip.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.2,
	dur = durmult * 999,
	storage	= 30,
	ent = "ent_jack_gmod_ezarmor_trizip",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["LBT-1476A"] = {
	PrintName = "[BP] LBT-1476A",
	mdl = "models/eft_props/gear/backpacks/bp_lbt1476a.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.133,
	dur = durmult * 999,
	storage	= 25,
	ent = "ent_jack_gmod_ezarmor_lbt1476a",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Gruppa 99 T20 (T)"] = {
	PrintName = "[BP] Gruppa 99 T20 (T)",
	mdl = "models/eft_props/gear/backpacks/bp_gr99t20_o.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.25,
	dur = durmult * 999,
	storage	= 25,
	ent = "ent_jack_gmod_ezarmor_gruppa99t20t",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Gruppa 99 T20 (M)"] = {
	PrintName = "[BP] Gruppa 99 T20 (M)",
	mdl = "models/eft_props/gear/backpacks/bp_gr99t20_m.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.25,
	dur = durmult * 999,
	storage	= 25,
	ent = "ent_jack_gmod_ezarmor_gruppa99t20m",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Drawbridge"] = {
	PrintName = "[BP] Drawbridge",
	mdl = "models/eft_props/gear/backpacks/bp_drawbridge.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.67,
	dur = durmult * 999,
	storage	= 25,
	ent = "ent_jack_gmod_ezarmor_drawbridge",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Takedown Black"] = {
	PrintName = "[BP] Takedown",
	mdl = "models/eft_props/gear/backpacks/bp_takedown_sling.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.58,
	dur = durmult * 999,
	storage	= 24,
	ent = "ent_jack_gmod_ezarmor_takedownbbp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Takedown Multicam"] = {
	PrintName = "[BP] Takedown",
	mdl = "models/eft_props/gear/backpacks/bp_takedown_sling_m.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.58,
	dur = durmult * 999,
	storage	= 24,
	ent = "ent_jack_gmod_ezarmor_takedownmbp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Pillbox"] = {
	PrintName = "[BP] Pillbox",
	mdl = "models/eft_props/gear/backpacks/bp_pillbox.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.338,
	dur = durmult * 999,
	storage	= 20,
	ent = "ent_jack_gmod_ezarmor_pillboxbp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Scav Backpack"] = {
	PrintName = "[BP] Scav Backpack",
	mdl = "models/eft_props/gear/backpacks/bp_scav_backpack.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 2.214,
	dur = durmult * 999,
	storage	= 20,
	ent = "ent_jack_gmod_ezarmor_scavbackpack",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Berkut BP"] = {
	PrintName = "[BP] WT Berkut",
	mdl = "models/eft_props/gear/backpacks/bp_wartech.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.0,
	dur = durmult * 999,
	storage	= 20,
	ent = "ent_jack_gmod_ezarmor_berkutbp",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["LBT-8005A Day Pack"] = {
	PrintName = "[BP] LBT-8005A Day Pack",
	mdl = "models/eft_props/gear/backpacks/bp_daypack.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 0.57,
	dur = durmult * 999,
	storage	= 20,
	ent = "ent_jack_gmod_ezarmor_daypack",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Sanitar's Bag"] = {
	PrintName = "[BP] Sanitar's Bag",
	mdl = "models/eft_props/gear/backpacks/bp_med_bag.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.44,
	dur = durmult * 999,
	storage	= 16,
	ent = "ent_jack_gmod_ezarmor_sanitarbag",
}

JMod.ArmorTable["Flyye MBSS"] = {
	PrintName = "[BP] Flyye MBSS",
	mdl = "models/eft_props/gear/backpacks/bp_mbss.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.1,
	dur = durmult * 999,
	storage	= 16,
	ent = "ent_jack_gmod_ezarmor_flyyembss",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["NICE COMM 3 BVS"] = {
	PrintName = "[BP] NICE COMM 3 BVS",
	mdl = "models/eft_props/gear/backpacks/bp_mystery_ranch.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 15,
	dur = durmult * 999,
	storage	= 14,
	ent = "ent_jack_gmod_ezarmor_birdeyebackpack",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Duffle Bag"] = {
	PrintName = "[BP] Duffle Bag",
	mdl = "models/eft_props/gear/backpacks/bp_forward.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 1.08,
	dur = durmult * 999,
	storage	= 12,
	ent = "ent_jack_gmod_ezarmor_dufflebag",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["LolKek 3F"] = {
	PrintName = "[BP] LolKek 3F",
	mdl = "models/eft_props/gear/backpacks/bp_redfox.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 0.984,
	dur = durmult * 999,
	storage	= 12,
	ent = "ent_jack_gmod_ezarmor_lolkek3f",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Tactical Sling Bag"] = {
	PrintName = "[BP] Tactical Sling Bag",
	mdl = "models/eft_props/gear/backpacks/bp_tactical_backpack.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 0.84,
	dur = durmult * 999,
	storage	= 9,
	ent = "ent_jack_gmod_ezarmor_tacticalslingb",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["VKBO Army Bag"] = {
	PrintName = "[BP] VKBO Army Bag",
	mdl = "models/eft_props/gear/backpacks/bp_vkbo.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 0.96,
	dur = durmult * 999,
	storage	= 8,
	ent = "ent_jack_gmod_ezarmor_vkboarmybag",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

JMod.ArmorTable["Transformer Bag"] = {
	PrintName = "[BP] Transformer Bag",
	mdl = "models/eft_props/gear/backpacks/bp_max_fuchs.mdl",
	snds = BackpackSounds,
	slots = {
		acc_backpack = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 1
	},
	wgt = wgtmult * 0.48,
	dur = durmult * 999,
	storage	= 6,
	ent = "ent_jack_gmod_ezarmor_transformerbag",
	tgl = {
		bdg = {
			[0] = 2
		},
		slots = {
			acc_backpack = 1,
		}
	}
}

--[[
	_               _          _           
	| |             | |        (_)          
___| |__   ___  ___| |_   _ __ _  __ _ ___ 
/ __| '_ \ / _ \/ __| __| | '__| |/ _` / __|
| (__| | | |  __/\__ \ |_  | |  | | (_| \__ \
\___|_| |_|\___||___/\__| |_|  |_|\__, |___/
									__/ |    
								|___/     
]]--

JMod.ArmorTable["Scav Vest"] = {
	PrintName = "[CR] Scav Vest",
	mdl = "models/eft_props/gear/chestrigs/cr_vestwild.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.4,
	dur = durmult * 999,
	storage = 6,
	ent = "ent_jack_gmod_ezarmor_scavvest",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Security Vest"] = {
	PrintName = "[CR] Security Vest",
	mdl = "models/eft_props/gear/chestrigs/cr_ctacticall.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.51,
	dur = durmult * 999,
	storage = 6,
	ent = "ent_jack_gmod_ezarmor_securityvest",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["M4 RSCR"] = {
	PrintName = "[CR] M4 RSCR",
	mdl = "models/eft_props/gear/chestrigs/cr_rscr_zulu.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.521,
	dur = durmult * 999,
	storage = 6,
	ent = "ent_jack_gmod_ezarmor_m4rscr",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["DIY IDEA CR"] = {
	PrintName = "[CR] IDEA CR",
	mdl = "models/eft_props/gear/chestrigs/cr_razgruz_ikea.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.22,
	dur = durmult * 999,
	storage = 8,
	ent = "ent_jack_gmod_ezarmor_ideacr",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Bank Robber"] = {
	PrintName = "[CR] Bank Robber",
	mdl = "models/eft_props/gear/chestrigs/cr_bank_robber.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.4,
	dur = durmult * 999,
	storage = 8,
	ent = "ent_jack_gmod_ezarmor_bankrobber",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["MRig"] = {
	PrintName = "[CR] Micro Rig",
	mdl = "models/eft_props/gear/chestrigs/cr_micro_rig_series.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.8,
	dur = durmult * 999,
	storage = 8,
	ent = "ent_jack_gmod_ezarmor_microrig",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Chicom"] = {
	PrintName = "[CR] Type 56 Chicom",
	mdl = "models/eft_props/gear/chestrigs/cr_chicom.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.65,
	dur = durmult * 999,
	storage = 10,
	ent = "ent_jack_gmod_ezarmor_chicomcr",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["TV-109"] = {
	PrintName = "[CR] WT TV-109",
	mdl = "models/eft_props/gear/chestrigs/cr_tv109.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.8,
	dur = durmult * 999,
	storage = 10,
	ent = "ent_jack_gmod_ezarmor_wtrig",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["CSA"] = {
	PrintName = "[CR] CSA CR",
	mdl = "models/eft_props/gear/chestrigs/cr_cs_assault.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.75,
	dur = durmult * 999,
	storage = 10,
	ent = "ent_jack_gmod_ezarmor_csa",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["UMTBS 6sh112"] = {
	PrintName = "[CR] UMTBS 6sh112",
	mdl = "models/eft_props/gear/chestrigs/cr_6h112.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.7,
	dur = durmult * 999,
	storage = 12,
	ent = "ent_jack_gmod_ezarmor_6h112",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Khamelion"] = {
	PrintName = "[CR] Khamelion",
	mdl = "models/eft_props/gear/chestrigs/cr_zryachii.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.7,
	dur = durmult * 999,
	storage = 12,
	ent = "ent_jack_gmod_ezarmor_khamelion",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Tarzan"] = {
	PrintName = "[CR] Tarzan",
	mdl = "models/eft_props/gear/chestrigs/cr_tarzan.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.45,
	dur = durmult * 999,
	storage = 14,
	ent = "ent_jack_gmod_ezarmor_tarzan",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["D3CRX"] = {
	PrintName = "[CR] D3CRX",
	mdl = "models/eft_props/gear/chestrigs/cr_d3crx.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.9,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_d3crx",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Triton"] = {
	PrintName = "[CR] Triton",
	mdl = "models/eft_props/gear/chestrigs/cr_triton.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.3,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_triton",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Commando Black"] = {
	PrintName = "[CR] Commando B",
	mdl = "models/eft_props/gear/chestrigs/cr_commando_b.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.34,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_commandoblack",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Commando Tan"] = {
	PrintName = "[CR] Commando T",
	mdl = "models/eft_props/gear/chestrigs/cr_commando_t.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.34,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_commandotan",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Thunderbolt"] = {
	PrintName = "[CR] Thunderbolt",
	mdl = "models/eft_props/gear/chestrigs/cr_thunderbolt.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 0.62,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_thunderbolt",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["BSS-MK1"] = {
	PrintName = "[CR] BSS-MK1",
	mdl = "models/eft_props/gear/chestrigs/cr_bssmk1.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.0,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_bssmk1",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Umka"] = {
	PrintName = "[CR] Umka M33-SET1",
	mdl = "models/eft_props/gear/chestrigs/cr_umka_m33.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.2,
	dur = durmult * 999,
	storage = 16,
	ent = "ent_jack_gmod_ezarmor_umka",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["LBT-1961A"] = {
	PrintName = "[CR] LBT-1961A",
	mdl = "models/eft_props/gear/chestrigs/cr_bearing.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.36,
	dur = durmult * 999,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_bearing",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["LBCR GE"] = {
	PrintName = "[CR] LBT-1961A GE",
	mdl = "models/eft_props/gear/chestrigs/cr_lbt_1961_boss.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.36,
	dur = durmult * 999,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_birdeyerig",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["SProfi MK2 R"] = {
	PrintName = "[CR] SProfi MK2 (R)",
	mdl = "models/eft_props/gear/chestrigs/cr_sprofi_mk2_smg.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.4,
	dur = durmult * 999,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_sprofirecon",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["SProfi MK2 A"] = {
	PrintName = "[CR] SProfi MK2 (A)",
	mdl = "models/eft_props/gear/chestrigs/cr_sprofi_mk2_ak.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.75,
	dur = durmult * 999,
	storage = 18,
	ent = "ent_jack_gmod_ezarmor_sprofiass",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["BlackRock"] = {
	PrintName = "[CR] BlackRock",
	mdl = "models/eft_props/gear/chestrigs/cr_blackrock.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.8,
	dur = durmult * 999,
	storage = 20,
	ent = "ent_jack_gmod_ezarmor_blackrock",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["MK3 Chest Rig"] = {
	PrintName = "[CR] WT MK3 TV-104",
	mdl = "models/eft_props/gear/chestrigs/cr_mk3.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.65,
	dur = durmult * 999,
	storage = 20,
	ent = "ent_jack_gmod_ezarmor_mk3chestrig",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Alpha CR"] = {
	PrintName = "[CR] Alpha CR",
	mdl = "models/eft_props/gear/chestrigs/cr_alpha.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.7,
	dur = durmult * 999,
	storage = 20,
	ent = "ent_jack_gmod_ezarmor_alphacr",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Azimut B"] = {
	PrintName = "[CR] Azimut",
	mdl = "models/eft_props/gear/chestrigs/cr_azimut_b.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.6,
	dur = durmult * 999,
	storage = 20,
	ent = "ent_jack_gmod_ezarmor_azimutb",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["Azimut S"] = {
	PrintName = "[CR] Azimut",
	mdl = "models/eft_props/gear/chestrigs/cr_azimut_s.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.6,
	dur = durmult * 999,
	storage = 20,
	ent = "ent_jack_gmod_ezarmor_azimuts",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["MPPV"] = {
	PrintName = "[CR] MPPV",
	mdl = "models/eft_props/gear/chestrigs/cr_patrol.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.6,
	dur = durmult * 999,
	storage = 24,
	ent = "ent_jack_gmod_ezarmor_mppv",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

JMod.ArmorTable["BeltAB"] = {
	PrintName = "[CR] Belt-A+B",
	mdl = "models/eft_props/gear/chestrigs/cr_beld_ab.mdl",
	snds = GenericSounds,
	slots = {
		acc_chestrig = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Spine2",
	siz = size_bdy,
	pos = pos_bdy,
	ang = ang_bdy,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.7,
	dur = durmult * 999,
	storage = 25,
	ent = "ent_jack_gmod_ezarmor_beltab",
	tgl = {
		bdg = {
			[0] = 1
		},
		slots = {
			acc_chestrig = 1,
		}
	}
}

--[[
_                    _          _       
| |                  | |        | |      
| |__   ___  __ _  __| |___  ___| |_ ___ 
| '_ \ / _ \/ _` |/ _` / __|/ _ \ __/ __|
| | | |  __/ (_| | (_| \__ \  __/ |_\__ \
|_| |_|\___|\__,_|\__,_|___/\___|\__|___/
										
]]--

JMod.ArmorTable["FAST RAC Headset"] = {
	PrintName = "[HS] FAST RAC Headset",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_rac_headset.mdl", -- sci fi lt
	snds = GenericSounds,
	slots = {
		ears = 1,
		acc_ears = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.6,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_fastracheadset",
	chrg = {
		power = 10
	},
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	slots = {
		ears = 0,
		acc_ears = 0,
	},
		eff = {},
	}
}

JMod.ArmorTable["GSSh-01"] = {
	PrintName = "[HS] GSSh-01",
	mdl = "models/eft_props/gear/headsets/headset_gsh01.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.5,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_gssh01",
}

JMod.ArmorTable["Sordin"] = {
	PrintName = "[HS] Sordin Supreme PRO-X/L",
	mdl = "models/eft_props/gear/headsets/headset_msa.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 6.5,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_sordin",
}

JMod.ArmorTable["M32"] = {
	PrintName = "[HS] M32",
	mdl = "models/eft_props/gear/headsets/headset_m32.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .7,
	dur = durmult * 200,
	chrg = {
		power = 10
	},
	ent = "ent_jack_gmod_ezarmor_m32",
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	bon = "ValveBiped.Bip01_Head1",
		eff = {},
		slots = {
			acc_ears = 0
		},
	}
}

JMod.ArmorTable["ComTac"] = {
	PrintName = "[HS] Peltor ComTac 2",
	mdl = "models/eft_props/gear/headsets/headset_comtacii.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .7,
	dur = durmult * 200,
	chrg = {
		power = 10
	},
	ent = "ent_jack_gmod_ezarmor_comtac",
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	bon = "ValveBiped.Bip01_Head1",
		eff = {},
		slots = {
			acc_ears = 0
		},
	}
}

JMod.ArmorTable["Tactical Sport"] = {
	PrintName = "[HS] Tactical Sport",
	mdl = "models/eft_props/gear/headsets/headset_tactical_sport.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 6.5,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_tacticalsport",
}

JMod.ArmorTable["Razor"] = {
	PrintName = "[HS] Razor",
	mdl = "models/eft_props/gear/headsets/headset_razor.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 6.5,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_razor",
}

JMod.ArmorTable["XCEL"] = {
	PrintName = "[HS] XCEL 500BT",
	mdl = "models/eft_props/gear/headsets/headset_xcel.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 6.5,
	dur = durmult * 200,
	ent = "ent_jack_gmod_ezarmor_xcel",
}

JMod.ArmorTable["ComTac 4"] = {
	PrintName = "[HS] Peltor ComTac 4",
	mdl = "models/eft_props/gear/headsets/headset_comtaciv.mdl",
	snds = GenericSounds,
	slots = {
		acc_ears = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .6,
	dur = durmult * 200,
	chrg = {
		power = 10
	},
	ent = "ent_jack_gmod_ezarmor_comtac4",
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	bon = "ValveBiped.Bip01_Head1",
		eff = {},
		slots = {
			acc_ears = 0
		},
	}
}

--[[
___ _   _  _____      _____  __ _ _ __ 
/ _ \ | | |/ _ \ \ /\ / / _ \/ _` | '__|
|  __/ |_| |  __/\ V  V /  __/ (_| | |   
\___|\__, |\___| \_/\_/ \___|\__,_|_|   
	__/ |                             
	|___/                              
]]--

JMod.ArmorTable["Tactical Glasses"] = {
	PrintName = "[EW] Tactical",
	mdl = "models/eft_props/gear/eyewear/glasses_tactical.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.05,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_tactical",
}

JMod.ArmorTable["AF Glasses"] = {
	PrintName = "[EW] AF Glasses",
	mdl = "models/eft_props/gear/eyewear/glasses_afg.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.11,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_afglasses",

}

JMod.ArmorTable["6B34"] = {
	PrintName = "[EW] 6B34",
	mdl = "models/eft_props/gear/eyewear/glasses_6b34.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.12,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_6b34",

}

JMod.ArmorTable["Dundukk sunglasses"] = {
	PrintName = "[EW] Dundukk",
	mdl = "models/eft_props/gear/eyewear/glasses_duduma.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.05,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_dundukglass",

}

JMod.ArmorTable["M Frame Glasses"] = {
	PrintName = "[EW] M Frame",
	mdl = "models/eft_props/gear/eyewear/glasses_m_frame.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.032,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_mframe",

}

JMod.ArmorTable["Pyramex Proximity"] = {
	PrintName = "[EW] Proximity",
	mdl = "models/eft_props/gear/eyewear/glasses_proximity.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.026,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_proximityglasses",

}

JMod.ArmorTable["Gascan Glasses"] = {
	PrintName = "[EW] Gascan",
	mdl = "models/eft_props/gear/eyewear/glasses_gascan.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.034,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_gascan",

}

JMod.ArmorTable["Round Sunglasses"] = {
	PrintName = "[EW] Round",
	mdl = "models/eft_props/gear/eyewear/glasses_aoron.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.04,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_roundglasses",

}

JMod.ArmorTable["RayBench Glasses"] = {
	PrintName = "[EW] RayBench",
	mdl = "models/eft_props/gear/eyewear/glasses_rayban.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.08,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_raybench",

}

JMod.ArmorTable["Aviator Glasses"] = {
	PrintName = "[EW] Aviator",
	mdl = "models/eft_props/gear/eyewear/glasses_aviator.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.027,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_aviators",

}

JMod.ArmorTable["JohnB Glasses"] = {
	PrintName = "[EW] JohnB Liquid DNB",
	mdl = "models/eft_props/gear/eyewear/glasses_johnb.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.06,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_johnb",

}

JMod.ArmorTable["Crossbow Glasses"] = {
	PrintName = "[EW] Crossbow",
	mdl = "models/eft_props/gear/eyewear/glasses_ess.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.03,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_crossbow",

}

JMod.ArmorTable["Gas Welder Glasses"] = {
	PrintName = "[EW] Gas Welder",
	mdl = "models/eft_props/gear/eyewear/glasses_welder.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = NonArmorProtectionProfile		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.45,
	dur = durmult * 999,
	ent = "ent_jack_gmod_ezarmor_gaswelderglass",

}

JMod.ArmorTable["Batwolf Glasses"] = {
	PrintName = "[EW] Batwolf",
	mdl = "models/eft_props/gear/eyewear/glasses_oakley.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = Class1		,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.5,
	dur = durmult * 25,
	ent = "ent_jack_gmod_ezarmor_batwolf",

}

JMod.ArmorTable["Condor Glasses"] = {
	PrintName = "[EW] NPP KlASS Condor",
	mdl = "models/eft_props/gear/eyewear/glasses_npp.mdl", 
	snds = GogglesSounds,
	slots = {
		acc_eyes = 1,
	},

	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_eye,
	pos = pos_eye,
	ang = ang_eye,
	wgt = wgtmult * 0.03,
	dur = durmult * 31,
	ent = "ent_jack_gmod_ezarmor_condorglass",

}


--[[
_ ____   ____ _ ___ 
| '_ \ \ / / _` / __|
| | | \ V / (_| \__ \
|_| |_|\_/ \__, |___/
			__/ |    
		|___/     
]]--

JMod.ArmorTable["PVS-14 NVM"] = {
	PrintName = "[HGC] PVS-14 NVM",
	mdl = "models/eft_props/gear/nvgs/nvg_pvs14.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	slots = {
		eyes = 1
	},
	bdg = {
		[0] = 1,
		[1] = 0,
		[2] = 1,
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = 0.79,
	dur = 20,
	chrg = {
		power = 80
	},
	mskmat = "mask_overlays/mask_old_monocular.png",
	eqsnd = "snds_jack_gmod/tinycapcharge.wav",
	ent = "ent_jack_gmod_ezarmor_pvs14nvm",
	eff = {
		nightVision = true
	},
	blackvisionwhendead=true,
	tgl = {
		bdg = {
		[0] = 2,
		[1] = 1,
		[2] = 1,
	},
		blackvisionwhendead=false,
		mskmat = "",
		eff = {},
		slots = {
			eyes = 0
		}
	}
}

JMod.ArmorTable["PNV-10T NVG"] = {
	PrintName = "[HGC] PNV-10T NVG",
	mdl = "models/eft_props/gear/nvgs/nvg_alpha_pnv_10t.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	slots = {
		eyes = 1
	},
	bdg = {
		[0] = 1,
		[1] = 0,
		[2] = 1,
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = 0.95,
	dur = 20,
	chrg = {
		power = 80
	},
	mskmat = "mask_overlays/mask_binocular.png",
	eqsnd = "snds_jack_gmod/tinycapcharge.wav",
	ent = "ent_jack_gmod_ezarmor_pnv10t",
	eff = {
		nightVision = true
	},
	blackvisionwhendead=true,
	tgl = {
		bdg = {
		[0] = 2,
		[1] = 1,
		[2] = 1,
	},
		blackvisionwhendead=false,
		mskmat = "",
		eff = {},
		slots = {
			eyes = 0
		}
	}
}

JMod.ArmorTable["N-15 NVG"] = {
	PrintName = "[HGC] N-15 NVG + Strap",
	mdl = "models/eft_props/gear/nvgs/nvg_armasight_n15.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	slots = {
		eyes = 1
	},
	bdg = {
		[1] = 0,
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = 1.115,
	dur = 20,
	chrg = {
		power = 80
	},
	mskmat = "mask_overlays/mask_binocular.png",
	eqsnd = "snds_jack_gmod/tinycapcharge.wav",
	ent = "ent_jack_gmod_ezarmor_n15nvg",
	eff = {
		nightVisionWP = true
	},
	blackvisionwhendead=true,
	tgl = {
		bdg = {
		[1] = 1,
	},
		blackvisionwhendead=false,
		mskmat = "",
		eff = {},
		slots = {
			eyes = 0
		}
	}
}

JMod.ArmorTable["GPNVG-18"] = {
	PrintName = "[HGC] GPNVG-18",
	mdl = "models/eft_props/gear/nvgs/nvg_l3_gpnvg_18_anvis.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	slots = {
		eyes = 1
	},
	bdg = {
		[0] = 1,
		[1] = 0,
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = 0.88,
	dur = 20,
	chrg = {
		power = 80
	},
	mskmat = "mask_overlays/mask_anvis.png",
	eqsnd = "snds_jack_gmod/tinycapcharge.wav",
	ent = "ent_jack_gmod_ezarmor_gpnvg18",
	eff = {
		nightVision = true
	},
	blackvisionwhendead=true,
	tgl = {
		bdg = {
		[0] = 1,
		[1] = 1,
	},
		blackvisionwhendead=false,
		mskmat = "",
		eff = {},
		slots = {
			eyes = 0
		}
	}
}

JMod.ArmorTable["T-7 Thermal Goggles"] = {
	PrintName = "[HGC] T-7 Thermal",
	mdl = "models/eft_props/gear/nvgs/nvg_spi_t7.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	slots = {
		eyes = 1
	},
	bdg = {
		[0] = 1,
		[1] = 0,
		[2] = 1,
	},
	def = NonArmorProtectionProfile,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = 1,
	dur = 20,
	chrg = {
		power = 80
	},
	mskmat = "mask_overlays/thermal.png",
	eqsnd = "snds_jack_gmod/tinycapcharge.wav",
	ent = "ent_jack_gmod_ezarmor_t7thermal",
	eff = {
		thermalVision = true
	},
	blackvisionwhendead=true,
	tgl = {
		bdg = {
	[0] = 2,
	[1] = 1,
	[2] = 1,
	},
		blackvisionwhendead=false,
		mskmat = "",
		eff = {},
		slots = {
			eyes = 0
		}
	}
}

JMod.ArmorTable["Skull Lock"] = {
	PrintName = "[HW] Skull Lock",
	mdl = "models/eft_props/gear/nvgs/nvg_wilcox_skull_lock.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.5,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_slock",
}

--[[
_           _       
| |         | |      
| |__   __ _| |_ ___ 
| '_ \ / _` | __/ __|
| | | | (_| | |_\__ \
|_| |_|\__,_|\__|___/
					
]]--

JMod.ArmorTable["Bomber"] = { --IDK IF I SHOULD PUT THIS IN HELMETS OR HATS 
	PrintName = "[HW-1] Bomber Beanie",
	mdl = "models/eft_props/gear/headwear/head_bomber.mdl",
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 600,
	ent = "ent_jack_gmod_ezarmor_bomber",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.5, 1, 0),

	}
}

JMod.ArmorTable["LLCS"] = {
	PrintName = "[HW] LLCS",
	mdl = "models/eft_props/gear/headwear/head_panama_jackpyke.mdl",
	snds = GenericSounds,
	slots = {
		head = 1,
		acc_head = 1,
		acc_ears = 1,
		acc_eyes = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.18,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_jackpyke",
	tgl = {
		slots = {
			head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.1, 1, 0),

	}
}

JMod.ArmorTable["Chimera"] = {
	PrintName = "[HW] Chimera",
	mdl = "models/eft_props/gear/headwear/head_panama_stichprofi.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.15,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_chimera",
	tgl = {
		slots = {
			head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.1, 1, 0),

	}
}

JMod.ArmorTable["Cowboy"] = {
	PrintName = "[HW] Cowboy",
	mdl = "models/eft_props/gear/headwear/head_cowboy.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .2,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_cowboy",
	tgl = {
		slots = {
			head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.8, 0),

	}
}

JMod.ArmorTable["Ushanka"] = {
	PrintName = "[HW] Ushanka",
	mdl = "models/eft_props/gear/headwear/head_ushanka.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_ushanka",
	tgl = {
		slots = {
			head = 1
		},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Panama"] = {
	PrintName = "[HW] Panama",
	mdl = "models/eft_props/gear/headwear/head_panama.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_panama",
	tgl = {
		slots = {
			head = 1
		},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Door Kicker"] = {
	PrintName = "[HW] Door Kicker",
	mdl = "models/eft_props/gear/headwear/head_doorkicker.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_doorkicker",
	tgl = {
		slots = {
			head = 1
		},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Beanie"] = {
	PrintName = "[HW] Beanie",
	mdl = "models/eft_props/gear/headwear/head_knitcap.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_scavbeanie",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Kotton"] = {
	PrintName = "[HW] Kotton",
	mdl = "models/eft_props/gear/headwear/head_kotton.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .2,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_kotton",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap"] = {
	PrintName = "[HW] Army Cap",
	mdl = "models/eft_props/gear/headwear/head_military_hat.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycap",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap Black"] = {
	PrintName = "[HW] Army Cap (Black)",
	mdl = "models/eft_props/gear/headwear/head_military2_black.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycapblack",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap Brown"] = {
	PrintName = "[HW] Army Cap (Brown)",
	mdl = "models/eft_props/gear/headwear/head_military2_brown.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycapbrown",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap CADPAT"] = {
	PrintName = "[HW] Army Cap (CADPAT)",
	mdl = "models/eft_props/gear/headwear/head_military2_cadpat.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycapcadpat",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap Flora"] = {
	PrintName = "[HW] Army Cap (Flora)",
	mdl = "models/eft_props/gear/headwear/head_military2_flora.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycapflora",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap Sand"] = {
	PrintName = "[HW] Army Cap (Sand)",
	mdl = "models/eft_props/gear/headwear/head_military2_sand.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycapsand",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Army Cap UCP"] = {
	PrintName = "[HW] Army Cap (UCP)",
	mdl = "models/eft_props/gear/headwear/head_military_hat.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_armycapucp",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Baseball cap"] = {
	PrintName = "[HW] Baseball cap",
	mdl = "models/eft_props/gear/headwear/cap_scav.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_scavcap",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Santa hat"] = {
	PrintName = "[HW] Santa hat",
	mdl = "models/eft_props/gear/headwear/head_claus.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_santahat",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}	

JMod.ArmorTable["Ded Moroz hat"] = {
	PrintName = "[HW] Ded Moroz",
	mdl = "models/eft_props/gear/headwear/head_dedmoroz.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_dedmorozhat",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Police"] = {
	PrintName = "[HW] Police",
	mdl = "models/eft_props/gear/headwear/cap_police.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_police",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Fleece"] = {
	PrintName = "[HW] Fleece",
	mdl = "models/eft_props/gear/headwear/head_fleece.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_fleece",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["UX PRO"] = {
	PrintName = "[HW] UX PRO",
	mdl = "models/eft_props/gear/headwear/head_uf_pro.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_uxpro",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["USEC cap black"] = {
	PrintName = "[HW] USEC cap (Black)",
	mdl = "models/eft_props/gear/headwear/cap_usec_black.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_useccapblack",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["USEC cap tan"] = {
	PrintName = "[HW] USEC cap (Tan)",
	mdl = "models/eft_props/gear/headwear/cap_usec_tan.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_useccaptan",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["BEAR cap black"] = {
	PrintName = "[HW] BEAR cap (Black)",
	mdl = "models/eft_props/gear/headwear/cap_bear_black.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bearcapblack",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["BEAR cap green"] = {
	PrintName = "[HW] BEAR cap (Green)",
	mdl = "models/eft_props/gear/headwear/cap_bear_green.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bearcapgreen",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["EMERCOM"] = {
	PrintName = "[HW] EMERCOM",
	mdl = "models/eft_props/gear/headwear/cap_mhs.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_emercom",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Pompon"] = {
	PrintName = "[HW] Pompon",
	mdl = "models/eft_props/gear/headwear/head_pompon.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_pompon",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Bandana"] = {
	PrintName = "[HW] Bandana",
	mdl = "models/eft_props/gear/headwear/head_bandana.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bandana",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Ski Hat"] = {
	PrintName = "[HW] Ski Hat",
	mdl = "models/eft_props/gear/headwear/head_slots.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_skihat",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Beret Olive"] = {
	PrintName = "[HW] Beret (Olive)",
	mdl = "models/eft_props/gear/headwear/head_beret_od.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_beretolive",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Beret Blue"] = {
	PrintName = "[HW] Beret (Blue)",
	mdl = "models/eft_props/gear/headwear/head_beret_blue.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_beretblue",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),
	}
}

JMod.ArmorTable["Beret Black"] = {
	PrintName = "[HW] Beret (Black)",
	mdl = "models/eft_props/gear/headwear/head_beret_blk.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_beretblack",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Leather cap"] = {
	PrintName = "[HW] Leather cap",
	mdl = "models/eft_props/gear/headwear/head_leather_cap.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .15,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_leathercap",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Tagilla Cap"] = {
	PrintName = "[HW] BOSS Cap",
	mdl = "models/eft_props/gear/headwear/cap_boss_tagillacap.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bosscap",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Big Pipe's Bandana"] = {
	PrintName = "[HW] Big Pipe's Bandana",
	mdl = "models/eft_props/gear/headwear/head_bandana_boxx_big_pipe.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bossbandana",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

JMod.ArmorTable["Zryachiy Mask"] = {
	PrintName = "[HW] Zryachiy's Mask",
	mdl = "models/eft_props/gear/headwear/head_boss_zryachii_balaklava_copen.mdl", 
	snds = GenericSounds,
	slots = {
		head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_zryachiyhat",
	tgl = {
	slots = {
		head = 1
	},
		siz = size_head * Vector(1.05, 1.05, 1.05),
		pos = pos_head + Vector(-0.4, 0.4, 0),

	}
}

--[[
__                                       
/ _|                                      
| |_ __ _  ___ ___  ___ _____   _____ _ __ 
|  _/ _` |/ __/ _ \/ __/ _ \ \ / / _ \ '__|
| || (_| | (_|  __/ (_| (_) \ V /  __/ |   
|_| \__,_|\___\___|\___\___/ \_/ \___|_|   
										
]]--

JMod.ArmorTable["Glorious"] = {
	PrintName = "[FW-1] Glorious",
	mdl = "models/eft_props/gear/facecover/facecover_glorious.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
		head = 1,
		acc_eyes = 1,
		eyes = 1,
		mouthnose = 1,
	},
	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.28,
	dur = durmult * 160,
	ent = "ent_jack_gmod_ezarmor_glorious"
}

JMod.ArmorTable["Shattered"] = {
	PrintName = "[FW-1] Shattered",
	mdl = "models/eft_props/gear/facecover/facecover_shatteredmask.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_ears = 1,
		eyes = 1,
		mouthnose = 1,
	},
	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.3,
	dur = durmult * 160,
	ent = "ent_jack_gmod_ezarmor_shattered"
}

JMod.ArmorTable["Death Knight"] = {
	PrintName = "[FW-1] Death Knight",
	mdl = "models/eft_props/gear/facecover/facecover_boss_black_knight.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		eyes = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			head = 1,
			eyes = 1,
		},
	},
	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.78,
	dur = durmult * 220,
	ent = "ent_jack_gmod_ezarmor_deathknight"
}

JMod.ArmorTable["UBEY"] = {
	PrintName = "[FW-5] Welding Mask",
	mdl = "models/eft_props/gear/facecover/facecover_boss_welding_ubey.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
		eyes = 1,
		mouthnose = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.5,
	dur = durmult * 57,
	mskmat = "mask_overlays/altyn.png",
	ent = "ent_jack_gmod_ezarmor_weldingkill"
}

JMod.ArmorTable["GORILLA"] = {
	PrintName = "[FW-5] Welding Mask",
	mdl = "models/eft_props/gear/facecover/facecover_boss_welding_gorilla.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
		eyes = 1,
		mouthnose = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.5,
	dur = durmult * 57,
	mskmat = "mask_overlays/altyn.png",
	ent = "ent_jack_gmod_ezarmor_weldinggorilla"
}

JMod.ArmorTable["Hockey Captain"] = {
	PrintName = "[FW] Hockey Captain",
	mdl = "models/eft_props/gear/facecover/facecover_hockey_01.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_hockeycaptain"
}

JMod.ArmorTable["Hockey Brawler"] = {
	PrintName = "[FW] Hockey Brawler",
	mdl = "models/eft_props/gear/facecover/facecover_hockey_02.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_hockeybrawler"
}

JMod.ArmorTable["Hockey Quiet"] = {
	PrintName = "[FW] Hockey Quiet",
	mdl = "models/eft_props/gear/facecover/facecover_hockey_03.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_hockeyquiet"
}

JMod.ArmorTable["GP-5"] = {
	PrintName = "[FW] GP-5",
	mdl = "models/eft_props/gear/facecover/facecover_gasmask_gp5.mdl", -- kf2
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	snds = GenericSounds,
	slots = {
		head = 1,
		acc_head = 1,
		acc_eyes = 1,
		eyes = 1,
		mouthnose = 1
	},
	def = table.Inherit({
		[DMG_NERVEGAS] = 1,
		[DMG_RADIATION] = .85
	}, NonArmorProtectionProfile),
	dur = durmult * 2,
	chrg = {
		chemicals = 25
	},
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .45,
	sndlop = "eft/bear2_breath_ok.wav",
	mskmat = "mask_overlays/mask_anvis.png",
	ent = "ent_jack_gmod_ezarmor_gp5"
}

JMod.ArmorTable["GP-7"] = {
	PrintName = "[FW] GP-7",
	mdl = "models/eft_props/gear/facecover/facecover_gasmask_gp7.mdl", -- kf2
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	snds = GenericSounds,
	slots = {
		acc_eyes = 1,
		eyes = 1,
		mouthnose = 1
	},
	def = table.Inherit({
		[DMG_NERVEGAS] = 1,
		[DMG_RADIATION] = .75
	}, NonArmorProtectionProfile),
	dur = durmult * 2,
	chrg = {
		chemicals = 25
	},
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .6,
	sndlop = "eft/bear2_breath_ok.wav",
	mskmat = "mask_overlays/mask_anvis.png",
	ent = "ent_jack_gmod_ezarmor_gp7"
}

JMod.ArmorTable["Deadly Skull"] = {
	PrintName = "[FW] Deadly Skull",
	mdl = "models/eft_props/gear/facecover/facecover_skullmask.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .2,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_deadlyskull"
}

JMod.ArmorTable["Respirator 3M"] = {
	PrintName = "[FW] Respirator",
	mdl = "models/eft_props/gear/facecover/facecover_respirator_3m.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	snds = GenericSounds,
	slots = {
		mouthnose = 1
	},
	def = table.Inherit({
		[DMG_NERVEGAS] = .35,
		[DMG_RADIATION] = .75
	}, NonArmorProtectionProfile),
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	chrg = {
		chemicals = 10
	},
	wgt = wgtmult * .1,
	dur = durmult * 2,
	sndlop = "eft/bear2_breath_ok.wav",
	ent = "ent_jack_gmod_ezarmor_3m",
}

JMod.ArmorTable["SOTR"] = {
	PrintName = "[FW] Ops-Core SOTR",
	mdl = "models/eft_props/gear/facecover/facecover_ops_core_sotr_respirator.mdl",
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	snds = GenericSounds,
	slots = {
		mouthnose = 1
	},
	def = table.Inherit({
		[DMG_NERVEGAS] = .35,
		[DMG_RADIATION] = .75
	}, NonArmorProtectionProfile),
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	chrg = {
		chemicals = 10
	},
	wgt = wgtmult * .1,
	dur = durmult * 2,
	sndlop = "eft/bear2_breath_ok.wav",
	ent = "ent_jack_gmod_ezarmor_sotr",
}

JMod.ArmorTable["Pestily"] = {
	PrintName = "[FW] Pestily",
	mdl = "models/eft_props/gear/facecover/facecover_pestily.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
		eyes = 1,
		mouthnose = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .18,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_pestily"
}

JMod.ArmorTable["Spooky Skull Mask"] = {
	PrintName = "[FW] Spooky Skull",
	mdl = "models/eft_props/gear/facecover/facecover_halloween_skull.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
		eyes = 1,
		mouthnose = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1,
			eyes = 1,
			mouthnose = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .2,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_spookyskull"
}

JMod.ArmorTable["Slender"] = {
	PrintName = "[FW] Slender",
	mdl = "models/eft_props/gear/facecover/facecover_halloween_slander.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_slender"
}

JMod.ArmorTable["Misha Mayorov"] = {
	PrintName = "[FW] Misha Mayorov",
	mdl = "models/eft_props/gear/facecover/facecover_halloween_micheal.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		acc_head = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_misha"
}

JMod.ArmorTable["Ghoul"] = {
	PrintName = "[FW] Ghoul",
	mdl = "models/eft_props/gear/facecover/facecover_halloween_vampire.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		eyes = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .15,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_ghoul"
}

JMod.ArmorTable["Faceless"] = {
	PrintName = "[FW] Faceless",
	mdl = "models/eft_props/gear/facecover/facecover_halloween_kaonasi.mdl", 
	snds = HelmetSounds,
	slots = {
		head = 1,
		acc_head = 1,
		eyes = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			head = 1,
			acc_head = 1,
			eyes = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .2,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_faceless"
}

JMod.ArmorTable["Jason"] = {
	PrintName = "[FW] Jason",
	mdl = "models/eft_props/gear/facecover/facecover_halloween_jason.mdl", 
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_jason"
}

JMod.ArmorTable["Balaclava"] = {
	PrintName = "[FW] Balaclava",
	mdl = "models/eft_props/gear/facecover/facecover_scavbalaclava.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_balaclava"
}

JMod.ArmorTable["Balaclava (Black)"] = {
	PrintName = "[FW] Balaclava (B)",
	mdl = "models/eft_props/gear/facecover/facecover_scavbalaclava_black.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_balaclavablack"
}

JMod.ArmorTable["Cold Fear"] = {
	PrintName = "[FW] Cold Fear",
	mdl = "models/eft_props/gear/facecover/facecover_coldgear.mdl", 
	snds = GenericSounds,
	slots = {
		acc_head = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head + Vector(0.1,0.1,0),
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_coldfear"
}

JMod.ArmorTable["Ghost Balaclava"] = {
	PrintName = "[FW] Ghost Balaclava",
	mdl = "models/eft_props/gear/facecover/facecover_mask_skull.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_ghostbalacvlava"
}

JMod.ArmorTable["Nomex Balaclava"] = {
	PrintName = "[FW] Nomex Balaclava",
	mdl = "models/eft_props/gear/facecover/facecover_nomex.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_nomexbalacvlava"
}

JMod.ArmorTable["Smoke Balaclava"] = {
	PrintName = "[FW] Smoke Balaclava",
	mdl = "models/eft_props/gear/facecover/facecover_smoke.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_smokebalacvlava"
}

JMod.ArmorTable["Shemagh (Green)"] = {
	PrintName = "[FW] Shemagh (Green)",
	mdl = "models/eft_props/gear/facecover/facecover_arafat.mdl", 
	snds = GenericSounds,
	slots = {
		acc_head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_shemaghgreen"
}

JMod.ArmorTable["Shemagh (Tan)"] = {
	PrintName = "[FW] Shemagh (Tan)",
	mdl = "models/eft_props/gear/facecover/facecover_shemagh.mdl", 
	snds = GenericSounds,
	slots = {
		acc_head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_shemaghtan",
}

JMod.ArmorTable["Lower Half-Mask"] = {
	PrintName = "[FW] Lower Half-Mask",
	mdl = "models/eft_props/gear/facecover/facecover_mask.mdl",
	snds = GenericSounds,
	slots = {
		acc_head = 1
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_halfmask"
}

JMod.ArmorTable["Neoprene Mask"] = {
	PrintName = "[FW] Neoprene Mask",
	mdl = "models/eft_props/gear/facecover/facecover_redflame.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_neoprenemask"
}

JMod.ArmorTable["Mustache"] = {
	PrintName = "[FW] Mustache",
	mdl = "models/eft_props/gear/facecover/facecover_mustache.mdl",
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head - Vector(0,0.4,0),
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_mustache"
}

JMod.ArmorTable["Santa"] = {
	PrintName = "[FW] B. Santa",
	mdl = "models/eft_props/gear/facecover/facecover_beard_santa.mdl",
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head * 0.9,
	pos = pos_head - Vector(-0.45,0.6,0),
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_santa"
}

JMod.ArmorTable["Baddie"] = {
	PrintName = "[FW] B. Baddie",
	mdl = "models/eft_props/gear/facecover/facecover_beard_red.mdl",
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head * 0.9,
	pos = pos_head - Vector(-0.45,0.6,0),
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_baddie"
}

JMod.ArmorTable["Pipe"] = {
	PrintName = "[FW] Pipe",
	mdl = "models/eft_props/gear/facecover/facecover_pipe.mdl",
	snds = HelmetSounds,
	slots = {
		acc_head = 1,
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head - Vector(0,0.6,0),
	ang = ang_head,
	wgt = wgtmult * .1,
	dur = durmult * 222,
	ent = "ent_jack_gmod_ezarmor_pipe"
}

JMod.ArmorTable["Zryachiy's Balaclava"] = {
	PrintName = "[FW] Zryachiy's Balaclava",
	mdl = "models/eft_props/gear/facecover/facecover_zryachii_closed.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		acc_head = 1,
	},
	bdg = {
		[0] = 1
	},
	tgl = {
		bdg = {
			[0] = 0
		},
		slots = {
			acc_head = 1,
		},
	},
	def = NonArmorProtectionProfile,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.1,
	dur = durmult * 9999,
	ent = "ent_jack_gmod_ezarmor_zryachiibalacvlava"
}

--[[
_          _                _       
| |        | |              | |      
| |__   ___| |_ __ ___   ___| |_ ___ 
| '_ \ / _ \ | '_ ` _ \ / _ \ __/ __|
| | | |  __/ | | | | | |  __/ |_\__ \
|_| |_|\___|_|_| |_| |_|\___|\__|___/
									
]]--

JMod.ArmorTable["Tac-Kek FAST MT"] = {
	PrintName = "[HLM-1] Tac-Kek FAST MT",
	mdl = "models/eft_props/gear/helmets/helmet_hops_core_fast.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .45,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_tackekfastmt"
}

JMod.ArmorTable["TSh-4M-L"] = {
	PrintName = "[HLM-1] TSh-4M-L",
	mdl = "models/eft_props/gear/helmets/helmet_tsh_4m2.mdl",
	snds = GenericSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class1,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .9,
	dur = durmult * 400,
	ent = "ent_jack_gmod_ezarmor_shlemofon",
	chrg = {
		power = 60
	},
	eff = {
		teamComms = true,
		earPro = true
	},
	tgl = {
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
		eff = {},
	},
}

JMod.ArmorTable["Kolpak-1S"] = {
	PrintName = "[HLM-2] Kolpak-1S",
	mdl = "models/eft_props/gear/helmets/helmet_k1c.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.9,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_kolpak1s"
}

JMod.ArmorTable["SHPM Firefighter Helmet"] = {
	PrintName = "[HLM-2] SHPM Firefighter",
	mdl = "models/eft_props/gear/helmets/helmet_shpm.mdl",
	snds = HelmetSounds,
	mskmat = "mask_overlays/dirty_glass",
	bdg = {
		[0] = 0,
		[1] = 0
	},
	slots = {
		head = .9,
		ears = .8,
		acc_ears = .8,
		eyes = .1,
		mouthnose = .1,
	},
	tgl = {
		mskmat = "",
		slots = {
			head = .9,
			ears = .8,
			acc_ears = .8,
			eyes = 0,
			mouthnose = 0
		},
		bdg = {
		[0] = 0,
		[1] = 1
		}
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.5,
	dur = durmult * 160,
	ent = "ent_jack_gmod_ezarmor_shpmhelm"
}

JMod.ArmorTable["PSh-97 DJETA"] = {
	PrintName = "[HLM-2] PSh-97 DJETA",
	mdl = "models/eft_props/gear/helmets/helmet_psh97_jeta.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		eyes = .2,
		acc_ears = 1,
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.3,
	dur = durmult * 260,
	mskmat = "mask_overlays/dirty_glass",
	ent = "ent_jack_gmod_ezarmor_djeta",
	bdg = {
	[1] = 0
	},
	tgl = {
	slots = {
			head = 1,
			ears = 1,
			eyes = 0,
			acc_ears = 1,
		},
	bdg = {
		[1] = 1
	},
	mskmat = "",
	}
}

JMod.ArmorTable["LShZ"] = {
	PrintName = "[HLM-3] LShZ L. Helm",
	mdl = "models/eft_props/gear/helmets/helmet_lshz.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.95,
	dur = durmult * 120,
	ent = "ent_jack_gmod_ezarmor_lshz"
}

JMod.ArmorTable["SSh-68"] = {
	PrintName = "[HLM-3] SSh-68 Steel Helmet",
	mdl = "models/eft_props/gear/helmets/helmet_s_sh_68.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.5,
	dur = durmult * 43,
	ent = "ent_jack_gmod_ezarmor_ssh68"
}

JMod.ArmorTable["Galvion Caiman"] = {
	PrintName = "[HLM-3] Caiman",
	mdl = "models/eft_props/gear/helmets/helmet_galvion_caiman.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.12,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_caiman"
}

JMod.ArmorTable["Galvion Caiman Applique"] = {
	PrintName = "[HLM-4] Caiman + Applique",
	mdl = "models/eft_props/gear/helmets/helmet_galvion_applique.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.8,
	dur = durmult * 129,
	ent = "ent_jack_gmod_ezarmor_caimanapplique"
}

JMod.ArmorTable["HJELM"] = {
	PrintName = "[HLM-3] HJELM",
	mdl = "models/eft_props/gear/helmets/helmet_nfm_hjelm.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .8,
	dur = durmult * 130,
	ent = "ent_jack_gmod_ezarmor_hjelm"
}

JMod.ArmorTable["Untar Helmet"] = {
	PrintName = "[HLM-3] Untar Helmet",
	mdl = "models/eft_props/gear/helmets/helmet_un.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 2.2,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_untarhelm"
}

JMod.ArmorTable["6B47"] = {
	PrintName = "[HLM-3] 6B47",
	mdl = "models/eft_props/gear/helmets/helmet_6b47.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.3,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_6b47"
}

JMod.ArmorTable["6B47 Cover"] = {
	PrintName = "[HLM-3] 6B47 (Cover)",
	mdl = "models/eft_props/gear/helmets/helmet_6b47_cover.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.3,
	dur = durmult * 100,
	ent = "ent_jack_gmod_ezarmor_6b47chehol"
}

JMod.ArmorTable["KiverM"] = {
	PrintName = "[HLM-3] Kiver-M",
	mdl = "models/eft_props/gear/helmets/helmet_kiverm.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 78,
	ent = "ent_jack_gmod_ezarmor_kiverm"
}

JMod.ArmorTable["SFERA-S"] = {
	PrintName = "[HLM-3] SFERA-S",
	mdl = "models/eft_props/gear/helmets/helmet_sphera_c.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 3.5,
	dur = durmult * 143,
	ent = "ent_jack_gmod_ezarmor_sferas"
}

JMod.ArmorTable["DevTac Ronin"] = {
	PrintName = "[HLM-3] DevTac Ronin",
	mdl = "models/eft_props/gear/helmets/helmet_devtac.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
		eyes = 1,
		mouthnose = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.6,
	dur = durmult * 240,
	mskmat = "mask_overlays/mask_anvis.png",
	ent = "ent_jack_gmod_ezarmor_devtacronin"
}

JMod.ArmorTable["MSA ACH TC-2001"] = {
	PrintName = "[HLM-4] TC-2001",
	mdl = "models/eft_props/gear/helmets/helmet_mich2001.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.4,
	dur = durmult * 50,
	ent = "ent_jack_gmod_ezarmor_mich2001"
}

JMod.ArmorTable["MSA ACH TC-2002"] = {
	PrintName = "[HLM-4] TC-2002",
	mdl = "models/eft_props/gear/helmets/helmet_mich2002.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.45,
	dur = durmult * 54,
	ent = "ent_jack_gmod_ezarmor_mich2002"
}

JMod.ArmorTable["ACHHC Black"] = {
	PrintName = "[HLM-4] ACHHC Black",
	mdl = "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_achhcblack"
}

JMod.ArmorTable["ACHHC Olive"] = {
	PrintName = "[HLM-4] ACHHC Olive",
	mdl = "models/eft_props/gear/helmets/helmet_achhc_g.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 120,
	ent = "ent_jack_gmod_ezarmor_achhcolive"
}

JMod.ArmorTable["TC 800"] = {
	PrintName = "[HLM-4] Gallet TC 800",
	mdl = "models/eft_props/gear/helmets/helmet_msa_gallet.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.17,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_tc800"
}

JMod.ArmorTable["Bastion"] = {
	PrintName = "[HLM-4] Bastion",
	mdl = "models/eft_props/gear/helmets/helmet_diamond_age_bastion.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.96,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bastion"
}

JMod.ArmorTable["Bastion Shield"] = {
	PrintName = "[HLM-6] Bastion + Plate",
	mdl = "models/eft_props/gear/helmets/helmet_diamond_age_bastion_shield.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.95,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_bastionshield"
}

JMod.ArmorTable["Fast MT Black"] = {
	PrintName = "[HLM-4] FAST MT Black",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_black.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.9,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_fastmtblack"
}

JMod.ArmorTable["Fast MT Black SLAAP"] = {
	PrintName = "[HLM-5] FAST MT Black SLAAP",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_black_slaap.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 2.4,
	dur = durmult * 67,
	ent = "ent_jack_gmod_ezarmor_fastmtblackslaap"
}

JMod.ArmorTable["Fast MT Tan"] = {
	PrintName = "[HLM-4] FAST MT Tan",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_tan.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.9,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_fastmttan"
}

JMod.ArmorTable["Fast MT Tan SLAAP"] = {
	PrintName = "[HLM-5] FAST MT Tan SLAAP",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_tan_slaap.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 2.4,
	dur = durmult * 67,
	ent = "ent_jack_gmod_ezarmor_fastmttanslaap"
}

JMod.ArmorTable["TW EXFIL B"] = {
	PrintName = "[HLM-4] TW EXFIL",
	mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_black.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.18,
	dur = durmult * 90,
	ent = "ent_jack_gmod_ezarmor_twexfilb"
}

JMod.ArmorTable["TW EXFIL C"] = {
	PrintName = "[HLM-4] TW EXFIL",
	mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_coyote.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.18,
	dur = durmult * 90,
	ent = "ent_jack_gmod_ezarmor_twexfilc"
}

JMod.ArmorTable["ZSH-1-2M"] = {
	PrintName = "[HLM-4] ZSH-1-2M",
	mdl = "models/eft_props/gear/helmets/helmet_zsh_1_2m_v1.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 3.7,
	dur = durmult * 70,
	ent = "ent_jack_gmod_ezarmor_zshhelm"
}

JMod.ArmorTable["ZSH-1-2M v2"] = {
	PrintName = "[HLM-4] ZSH-1-2M v2",
	mdl = "models/eft_props/gear/helmets/helmet_zsh_1_2m_v2.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 3.7,
	dur = durmult * 70,
	ent = "ent_jack_gmod_ezarmor_zshhelmv2"
}

JMod.ArmorTable["ULACH B"] = {
	PrintName = "[HLM-4] ULACH B",
	mdl = "models/eft_props/gear/helmets/helmet_ulach_b.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.9,
	dur = durmult * 84,
	ent = "ent_jack_gmod_ezarmor_ulach"
}

JMod.ArmorTable["ULACH C"] = {
	PrintName = "[HLM-4] ULACH C",
	mdl = "models/eft_props/gear/helmets/helmet_ulach_c.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.9,
	dur = durmult * 84,
	ent = "ent_jack_gmod_ezarmor_ulachcoyote"
}


JMod.ArmorTable["LShZ-2DTM"] = {
	PrintName = "[HLM-4] LShZ-2DTM",
	mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 3.4,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_lshz2dtm"
}

JMod.ArmorTable["LShZ-2DTM Cover"] = {
	PrintName = "[HLM-4] LShZ-2DTM (w/Cover)",
	mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm_damper.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 3.5,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_lshz2dtmcovered"
}

JMod.ArmorTable["Shlem Maska 1SH"] = {
	PrintName = "[HLM-4] ShMaska",
	mdl = "models/eft_props/gear/helmets/helmet_maska_1sh.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 2.6,
	dur = durmult * 86,
	ent = "ent_jack_gmod_ezarmor_maska1sh",
}

JMod.ArmorTable["Shlem Maska 1SH (Killa)"] = {
	PrintName = "[HLM-4] ShMaska (K)",
	mdl = "models/eft_props/gear/helmets/helmet_maska_1sh_killa.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 2.6,
	dur = durmult * 86,
	ent = "ent_jack_gmod_ezarmor_maska1shkilla",
}

JMod.ArmorTable["Altyn"] = {
	PrintName = "[HLM-5] Altyn",
	mdl = "models/eft_props/gear/helmets/helmet_altyn.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 4.0,
	dur = durmult * 64,
	ent = "ent_jack_gmod_ezarmor_altyn"
}

JMod.ArmorTable["Rys-T"] = {
	PrintName = "[HLM-5] Rys-T",
	mdl = "models/eft_props/gear/helmets/helmet_rys_t.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1,
		ears = 1,
		acc_ears = 1,
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 4.5,
	dur = durmult * 64,
	ent = "ent_jack_gmod_ezarmor_ryst"
}

JMod.ArmorTable["Vulkan-5"] = {
	PrintName = "[HLM-6] Vulkan-5",
	mdl = "models/eft_props/gear/helmets/helmet_vulkan_5.mdl",
	snds = HelmetSounds,
	slots = {
		head = 1
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 4.5,
	dur = durmult * 110,
	ent = "ent_jack_gmod_ezarmor_vulkan5"
}

--[[
					_                    
				(_)                   
__ _  ___  __   ___ ___  ___  _ __ ___ 
/ _` |/ __| \ \ / / / __|/ _ \| '__/ __|
| (_| | (__   \ V /| \__ \ (_) | |  \__ \
\__, |\___|   \_/ |_|___/\___/|_|  |___/
__/ |                                  
|___/                                   

]]--

JMod.ArmorTable["FAST Visor"] = {
	PrintName = "[HGC-2] FAST MT Visor",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_visor.mdl",
	snds = FShieldSounds,
	slots = {
		eyes = 1,
	},

	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * .32,
	dur = durmult * 25,
	ent = "ent_jack_gmod_ezarmor_fastmtvisor",
	bdg = {
		[0] = 0,
		[1] = 1
	},
	tgl = {
		slots = {
			eyes= 0,
		},
		bdg = {
			[0] = 1,
			[1] = 1
		},
		mskmat = ""
	}

}

JMod.ArmorTable["Caiman FA Visor"] = {
	PrintName = "[HGC-2] Caiman FA Visor",
	mdl = "models/eft_props/gear/helmets/helmet_galvioned_arm_visor.mdl",
	snds = FShieldSounds,
	slots = {
		eyes = 1,
	},

	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.27,
	dur = durmult * 38,
	ent = "ent_jack_gmod_ezarmor_caimanvisor",

}

JMod.ArmorTable["Kolpak-1S Visor"] = {
	PrintName = "[HGC-2] Kolpak-1S Visor",
	mdl = "models/eft_props/gear/helmets/helmet_k1c_shield.mdl",
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.0,
	dur = durmult * 38,
	bdg = {
	[0] = 0
	},
	mskmat = "mask_overlays/dirty_glass",
	ent = "ent_jack_gmod_ezarmor_koplak1svisor",
	tgl = {
		bdg = {
		[0] = 1
		},
		mskmat = "",
		slots = {
			eyes = 0,
			mouthnose = 0
		}
	}
}

JMod.ArmorTable["Tac-Kek Heavy Trooper"] = {
	PrintName = "[HGC-2] Tac-Kek Heavy Trooper",
	mdl = "models/eft_props/gear/helmets/helmet_galactac_heavy_gunner.mdl", -- tarkov
	snds = HelmetSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.4,
	dur = durmult * 180,
	ent = "ent_jack_gmod_ezarmor_tackekhtrooper"
}

JMod.ArmorTable["Fast MT Shield"] = {
	PrintName = "[HGC-3] FAST MT Face Shield",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_handgun_face_shield.mdl", -- tarkov
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},

	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 50,
	ent = "ent_jack_gmod_ezarmor_fastmtshield",
	bdg = {
		[0] = 0,
		[1] = 1
	},
	tgl = {
		slots = {
			eyes=0,
			mouthnose = 0,
		},
		bdg = {
			[0] = 1,
			[1] = 1
		},
		mskmat = ""
	}

}

JMod.ArmorTable["Kiver Shield"] = {
	PrintName = "[HGC-3] Kiver-M FShield",
	mdl = "models/eft_props/gear/helmets/helmet_kiverm_shield.mdl", -- tarkov
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},

	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 50,
	ent = "ent_jack_gmod_ezarmor_kivermshield",
	bdg = {
		[0] = 0,
		[1] = 1
	},
	tgl = {
		slots = {
			eyes= 0,
			mouthnose= 0
		},
		bdg = {
			[0] = 1,
			[1] = 1
		},
		mskmat = ""
	}

}

JMod.ArmorTable["TW EXFIL Shield B"] = {
	PrintName = "[HGC-3] TW EXFIL FS",
	mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_face_shield_black.mdl", -- tarkov
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},

	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.8,
	dur = durmult * 56,
	ent = "ent_jack_gmod_ezarmor_twexfilshieldb",
	bdg = {
		[0] = 0,
		[1] = 1
	},
	tgl = {
		slots = {
			eyes = 0,
			mouthnose = 0,
		},
		bdg = {
			[0] = 1,
			[1] = 1
		},
		mskmat = ""
	}

}

JMod.ArmorTable["TW EXFIL Shield C"] = {
	PrintName = "[HGC-3] TW EXFIL FS",
	mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_face_shield_coyo.mdl", -- tarkov
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},

	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.8,
	dur = durmult * 56,
	ent = "ent_jack_gmod_ezarmor_twexfilshieldc",
	bdg = {
		[0] = 0,
		[1] = 1
	},
	tgl = {
		slots = {
			eyes = 0,
			mouthnose = 0,
		},
		bdg = {
			[0] = 1,
			[1] = 1
		},
		mskmat = ""
	}

}

JMod.ArmorTable["ZSH-1-2M Face Shield"] = {
	PrintName = "[HGC-3] ZSH-1-2M FShield",
	mdl = "models/eft_props/gear/helmets/helmet_zsh_1_2m_face_shield.mdl",
	snds = FShieldSounds,
	slots = {
		eyes = .85,
		mouthnose = .85
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	bdg = {
		[0] = 0
	},
	wgt = wgtmult * 1.0,
	dur = durmult * 63,
	mskmat = "mask_overlays/dirty_glass",
	ent = "ent_jack_gmod_ezarmor_zshface",
	tgl = {
		bdg = {
			[0] = 1
		},
		mskmat = "",
		slots = {
			eyes = 0,
			mouthnose = 0
		}
	}
}


JMod.ArmorTable["LShZ-2DTM Shield"] = {
	PrintName = "[HGC-4] LShZ-2DTM FShield",
	mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm_shield.mdl", -- tarkov
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},

	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.0,
	dur = durmult * 63,
	ent = "ent_jack_gmod_ezarmor_lshz2dtmshield",
	bdg = {
		[0] = 0
	},
	tgl = {
		slots = {
			eyes = 0,
			mouthnose = 0,
		},
		bdg = {
			[0] = 1
		},
		mskmat = ""
	}
}

JMod.ArmorTable["Vulkan-5 Shield"] = {
	PrintName = "[HGC-4] Vulkan-5 Shield",
	mdl = "models/eft_props/gear/helmets/helmet_vulkan_shield.mdl", -- tarkov
	snds = FShieldSounds,
	slots = {
		eyes = 1,
		mouthnose = 1,
	},

	def = Class4,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	mskmat = "mask_overlays/dirty_glass",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.8,
	dur = durmult * 106,
	ent = "ent_jack_gmod_ezarmor_vulkan5shield",
	bdg = {
		[0] = 0,
		[1] = 1
	},
	tgl = {
		slots = {
			eyes = 0,
			mouthnose = 0,
		},
		bdg = {
			[0] = 1,
			[1] = 1
		},
		mskmat = ""
	}
}

JMod.ArmorTable["Altyn Face Shield"] = {
	PrintName = "[HGC-5] Altyn Face Shield",
	mdl = "models/eft_props/gear/helmets/helmet_altyn_face_shield.mdl",
	snds = GenericSounds,
	slots = {
		eyes = 1,
		mouthnose = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	bdg = {
		[0] = 0
	},
	tgl = {
		mskmat = "",
		bdg = {
			[0] = 1
		},
		slots = {
			eyes = 0,
			mouthnose = 0
		}
	},
	wgt = wgtmult * 1.4,
	dur = durmult * 100,
	mskmat = "mask_overlays/altyn.png",
	ent = "ent_jack_gmod_ezarmor_altynface",

}

JMod.ArmorTable["Rys-T Face Shield"] = {
	PrintName = "[HGC-5] Rys-T FShield",
	mdl = "models/eft_props/gear/helmets/helmet_rys_t_shield.mdl",
	snds = GenericSounds,
	slots = {
		eyes = 1,
		mouthnose = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	bdg = {
		[0] = 0
	},
	tgl = {
		mskmat = "",
		bdg = {
			[0] = 1
		},
		slots = {
			eyes = 0,
			mouthnose = 0
		}
	},
	wgt = wgtmult * 1.2,
	dur = durmult * 110,
	mskmat = "mask_overlays/altyn.png",
	ent = "ent_jack_gmod_ezarmor_rystface",
}

JMod.ArmorTable["Shmaska 1SH Shield"] = {
	PrintName = "[HGC-6] ShMaska FS",
	mdl = "models/eft_props/gear/helmets/helmet_maska_1sh_shield.mdl", -- csgo misc
	snds = GenericSounds,
	slots = {
		eyes = .9,
		mouthnose = .9
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	bdg = {
		[0] = 0
	},
	tgl = {
		bdg = {
			[0] = 1
		},
		mskmat = "",
		slots = {
			eyes = 0,
			mouthnose = 0
		}
	},
	wgt = wgtmult * 1.1,
	dur = durmult * 71,
	mskmat = "mats_jack_gmod_sprites/slit_vignette.png",
	ent = "ent_jack_gmod_ezarmor_shlemmask"
}

JMod.ArmorTable["Shmaska 1SH Shield (Killa)"] = {
	PrintName = "[HGC-6] ShMaska FS (K)",
	mdl = "models/eft_props/gear/helmets/helmet_maska_1sh_shield_killa.mdl", -- csgo misc
	snds = GenericSounds,
	slots = {
		eyes = .9,
		mouthnose = .9
	},
	def = Class6,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	bdg = {
		[0] = 0
	},
	tgl = {
		bdg = {
			[0] = 1
		},
		mskmat = "",
		slots = {
			eyes = 0,
			mouthnose = 0
		}
	},
	wgt = wgtmult * 1.1,
	dur = durmult * 71,
	mskmat = "mats_jack_gmod_sprites/slit_vignette.png",
	ent = "ent_jack_gmod_ezarmor_shlemmaskkilla"
}

--[[
__ _  ___    __ _ _ __ _ __ ___   ___  _ __ ___ 
/ _` |/ __|  / _` | '__| '_ ` _ \ / _ \| '__/ __|
| (_| | (__  | (_| | |  | | | | | | (_) | |  \__ \
\__, |\___|  \__,_|_|  |_| |_| |_|\___/|_|  |___/
__/ |                                           
|___/                                            

]]--

JMod.ArmorTable["Fast Mandible"] = {
	PrintName = "[HGC-2] FAST Gunsight Mandible",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_gunsight_mandible.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		mouthnose = 1,
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	bdg ={
		[0] = 1,
		[1] = 1,
	},
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_fastmandible"
}

JMod.ArmorTable["Caiman Mandible"] = {
	PrintName = "[HGC-2] Caiman Mandible",
	mdl = "models/eft_props/gear/helmets/helmet_galvion_mandible.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		mouthnose = 1,
	},
	def = Class2,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.1,
	dur = durmult * 80,
	ent = "ent_jack_gmod_ezarmor_caimanmandible"
}

JMod.ArmorTable["Fast Side Armor Black"] = {
	PrintName = "[HGC-3] FAST Side Armor Black",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_side_armor_b.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		ears = 1,
		acc_ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 42,
	ent = "ent_jack_gmod_ezarmor_fastsidearmorblack"
}

JMod.ArmorTable["Fast Side Armor Tan"] = {
	PrintName = "[HGC-3] FAST Side Armor Tan",
	mdl = "models/eft_props/gear/helmets/helmet_ops_core_fast_side_armor_t.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		ears = 1,
		acc_ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 42,
	ent = "ent_jack_gmod_ezarmor_fastsidearmortan"
}

JMod.ArmorTable["Crye AirFrame Ears"] = {
	PrintName = "[HGC-3] Crye AirFrame Ears",
	mdl = "models/eft_props/gear/helmets/helmet_crye_airframe_ears.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		ears = 1,
		acc_ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 45,
	ent = "ent_jack_gmod_ezarmor_cryeairframeears"
}

JMod.ArmorTable["TW EXFIL Ears B"] = {
	PrintName = "[HGC-3] TW EXFIL EC",
	mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_ear_covers_b.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.172,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_twexfilearb"
}

JMod.ArmorTable["TW EXFIL Ears C"] = {
	PrintName = "[HGC-3] TW EXFIL EC",
	mdl = "models/eft_props/gear/helmets/helmet_team_wendy_exfil_ear_covers_c.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 0.172,
	dur = durmult * 60,
	ent = "ent_jack_gmod_ezarmor_twexfilearc"
}

JMod.ArmorTable["Crye AirFrame Chops"] = {
	PrintName = "[HGC-3] Crye AirFrame Chops",
	mdl = "models/eft_props/gear/helmets/helmet_crye_airframe_chops.mdl", -- tarkov
	snds = GenericSounds,
	slots = {
		mouthnose = .9,
		ears = .9,
		acc_ears = 1,
	},
	def = Class3,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.45,
	dur = durmult * 50,
	ent = "ent_jack_gmod_ezarmor_cryeairframechops"
}

JMod.ArmorTable["LShZ-2DTM Aventail"] = {
	PrintName = "[HGC] LShZ-2DTM Aventail",
	mdl = "models/eft_props/gear/helmets/helmet_lshz2dtm_aventail.mdl", -- tarkov
	snds = HelmetSounds,
	slots = {
		aventail = 1
	},
	def = Class5,
	clr = { r = 255, g = 255, b = 255 },
	clrForced = true,
	bon = "ValveBiped.Bip01_Head1",
	siz = size_head,
	pos = pos_head,
	ang = ang_head,
	wgt = wgtmult * 1.2,
	dur = durmult * 70,
	ent = "ent_jack_gmod_ezarmor_lshz2dtmaventail"
}


if Initialize then JModArmorGenerate() end
