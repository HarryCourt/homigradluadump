-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_bat_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_bat","melee_base")
if not SWEP then return end

SWEP.PrintName = "Деревянная бита"
SWEP.Instructions = "Часть спортивного инвентаря, предназначенная для нанесения ударов по мячу. Также популярно как холодное оружие благодаря своему удобству. Особенности конструкции биты позволяют наносить ею тяжёлые и мощные удары."

SWEP.WorldModel = "models/weapons/w_knije_t.mdl"

SWEP.HoldType = "melee2"

SWEP.Primary.Damage = 25
SWEP.DamagePain = 10

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0

SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 150
SWEP.DamageType = DMG_CLUB

SWEP.HitSound = {"physics/wood/wood_plank_impact_hard1.wav","physics/wood/wood_plank_impact_hard2.wav","physics/wood/wood_plank_impact_hard3.wav"}
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}

SWEP.sndTwroh = {"weapons/melee/swing_fists_01.wav","weapons/melee/swing_fists_02.wav","weapons/melee/swing_fists_03.wav"}

SWEP.dwsItemPos = Vector(-5,1,-2)
SWEP.dwsItemAng = Angle(27 - 45,0,0)
SWEP.dwsItemFOV = -6