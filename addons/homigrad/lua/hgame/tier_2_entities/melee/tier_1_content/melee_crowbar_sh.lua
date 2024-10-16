-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_crowbar_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_crowbar","melee_metalbat")
if not SWEP then return end

SWEP.PrintName = "Монтировка"
SWEP.Instructions = "Ручной ударный и рычажный инструмент, один из наиболее древних видов инструмента, известных человечеству, наряду с молотком, зубилом, топором, лопатой."

SWEP.WorldModel = "models/weapons/me_crowbar/w_me_crowbar.mdl"

SWEP.Primary.Damage = 27
SWEP.DamagePain = 5

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.3
SWEP.Primary.Force = 70

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = "snd_jack_hmcd_knifehit.wav"
SWEP.FlashHitSound = "weapons/melee/flesh_impact_blunt_04.wav"
SWEP.ShouldDecal = true
SWEP.HoldType = "melee"
SWEP.DamageType = DMG_CLUB

SWEP.dwsItemPos = Vector(0,3,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = -3

SWEP.SubStamina = 5