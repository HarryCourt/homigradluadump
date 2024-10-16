-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_pipe_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_pipe","melee_base")
if not SWEP then return end

SWEP.PrintName = "Труба"
SWEP.Instructions = "Вырванная из чьей-то канализационной системы труба"

SWEP.WorldModel = "models/props_canal/mattpipe.mdl"

SWEP.HoldType = "melee"

SWEP.Primary.Sound = Sound( "Weapon_Knife.Single" )
SWEP.Primary.Damage = 15
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 400
SWEP.DamageType = DMG_CLUB

SWEP.HitSound = "physics/metal/metal_canister_impact_hard2.wav"
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}

SWEP.dwsItemPos = Vector(-0.5,0,2)
SWEP.dwsItemAng = Angle(-45,0,180)
SWEP.dwsItemFOV = -2