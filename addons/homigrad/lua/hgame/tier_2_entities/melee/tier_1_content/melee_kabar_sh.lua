-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_kabar_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_kabar","melee_base")
if not SWEP then return end

SWEP.PrintName = "Байонет"
SWEP.Instructions = "Армейский штык-нож. Клинок штыка M9 — однолезвийный с пилой на обухе."

SWEP.WorldModel = "models/weapons/insurgency/w_marinebayonet.mdl"

SWEP.HoldType = "knife"

SWEP.Primary.Damage = 30
SWEP.DamageBleed = -30

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.65
SWEP.Primary.Force = 240

function SWEP:dmgTabPost(ent,dmgTab)
    if ent:IsPlayer() then FakeDown(ent) end
end

SWEP.sndTwroh = {"weapons/melee/swing_fists_01.wav","weapons/melee/swing_fists_02.wav","weapons/melee/swing_fists_03.wav"}