-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_hatchet_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_hatchet","melee_metalbat")
if not SWEP then return end

SWEP.PrintName = "Топорик"
SWEP.Instructions = "Одноручный ударный инструмент с острым лезвием с одной стороны, используемым для рубки и колки дерева, и наконечником молота с другой стороны."

SWEP.WorldModel = "models/weapons/me_hatchet/w_me_hatchet.mdl"

SWEP.Primary.Damage = 25
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.9
SWEP.Primary.Force = 120

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = "snd_jack_hmcd_knifehit.wav"
SWEP.FlashHitSound = "snd_jack_hmcd_axehit.wav"
SWEP.ShouldDecal = true
SWEP.HoldType = "melee"
SWEP.DamageType = DMG_SLASH

SWEP.sndTwrohPitch = 125

SWEP.dwsItemPos = Vector(0,1,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = -7