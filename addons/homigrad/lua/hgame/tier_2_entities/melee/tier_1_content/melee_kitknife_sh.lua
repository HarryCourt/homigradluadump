-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_kitknife_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_kitknife","melee_base")
if not SWEP then return end

SWEP.PrintName = "Кухонный ножик"
SWEP.Instructions = "Колющий, а также рубящий, режущий инструмент, рабочей частью которого является клинок — полоса, выполненная из твёрдого материала."

SWEP.WorldModel = "models/weapons/me_kitknife/w_me_kitknife.mdl"

SWEP.Primary.Damage = 15
SWEP.DamageBleed = 15

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.7
SWEP.Primary.Force = 60

SWEP.DrawSound = "snd_jack_hmcd_knifedraw.wav"
SWEP.HitSound = "snd_jack_hmcd_knifehit.wav"
SWEP.FlashHitSound = "snd_jack_hmcd_slash.wav"
SWEP.ShouldDecal = true
SWEP.HoldType = "knife"
SWEP.DamageType = DMG_SLASH

SWEP.dwsItemPos = Vector(0,4,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = -12