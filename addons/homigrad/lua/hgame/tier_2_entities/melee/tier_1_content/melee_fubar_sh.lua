-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_fubar_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_fubar","melee_metalbat")
if not SWEP then return end

SWEP.PrintName = "Фубар"
SWEP.Instructions = "Ручное рычажно-клиновое приспособление для вытаскивания (выдирания) вбитых в материал (дерево, пластик и др.) гвоздей."

SWEP.WorldModel = "models/weapons/me_fubar/w_me_fubar.mdl"

SWEP.Primary.Damage = 45
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 100

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = "physics/metal/metal_sheet_impact_hard2.wav"
SWEP.FlashHitSound = "weapons/melee/flesh_impact_blunt_03.wav"
SWEP.ShouldDecal = false
SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_CLUB

SWEP.sndTwroh = {"weapons/melee/swing_heavy_blunt_01.wav","weapons/melee/swing_heavy_blunt_02.wav","weapons/melee/swing_heavy_blunt_03.wav"}

SWEP.dwsItemPos = Vector(0.5,5,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = 2
