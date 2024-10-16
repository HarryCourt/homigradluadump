-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\tier_0_melee_metalbat_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_metalbat","melee_base")
if not SWEP then return end

SWEP.PrintName = "Металическая Бита"
SWEP.Instructions = "Часть спортивного инвентаря, предназначенная для нанесения ударов по мячу, выполненная из металлического материала, благодаря чему урон от данной биты будет в разы сильнее, чем от её деревянного аналога. Особенности конструкции биты позволяют наносить ею тяжёлые и мощные удары, но отличается от деревянной битой тем."

SWEP.WorldModel = "models/weapons/me_bat_metal_tracer/w_me_bat_metal.mdl"

SWEP.Primary.Damage = 35
SWEP.DamagePain = 40
SWEP.SubStamina = 10

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 100

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = "physics/metal/metal_canister_impact_hard3.wav"
SWEP.HitSound = {"physics/metal/metal_solid_impact_hard3.wav","physics/metal/metal_solid_impact_hard4.wav","physics/metal/metal_solid_impact_hard5.wav"}
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}
SWEP.ShouldDecal = false
SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_CLUB

function SWEP:dmgTabPost(ent,dmgTab)
    if dmgTab.hitgroup == HITGROUP_HEAD then
        dmgTab.explodeHead = true

        for i = 1,3 do
            sound.Emit(nil,"physics/metal/metal_solid_impact_bullet" .. math.random(1,4) .. ".wav",95,1,100,dmgTab.pos)
        end

        ent = RagdollOwner(ent) or ent
        if IsValid(ent) and ent:IsPlayer() then FakeDown(ent) end
    end
end

SWEP.dwsItemPos = Vector(-0.5,4,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = -1