-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_fireaxe_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_fireaxe","melee_base")
if not SWEP then return end

SWEP.PrintName = "Пожарный топор"
SWEP.Instructions = "Массивный топор для вскрытия и разборки конструкций при тушении пожара."

SWEP.WorldModel = "models/weapons/me_axe_fire_tracer/w_me_axe_fire.mdl"

SWEP.Primary.Damage = 30
SWEP.DamagePain = 35

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.2
SWEP.Primary.Force = 190

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = "weapons/shove_hit.wav"
SWEP.FlashHitSound = "snd_jack_hmcd_axehit.wav"
SWEP.ShouldDecal = true
SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_SLASH

function SWEP:Attack(ent,tr,dmgTab)
    if IsValid(ent:GetPhysicsObject()) and string.find(ent:GetPhysicsObject():GetMaterial(),"wood") then
        dmgTab.dmg = dmgTab.dmg * 2.5
        sound.Play("physics/wood/wood_crate_break" .. math.random(1,5) .. ".wav",tr.HitPos,75)
    end
end

SWEP.sndTwroh = {"weapons/melee/swing_light_blunt_01.wav","weapons/melee/swing_light_blunt_02.wav","weapons/melee/swing_light_blunt_03.wav"}

SWEP.dwsItemPos = Vector(-1,3,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = -1
