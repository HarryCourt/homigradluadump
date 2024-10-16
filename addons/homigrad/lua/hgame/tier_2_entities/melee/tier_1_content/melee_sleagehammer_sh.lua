-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_sleagehammer_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_sleagehammer","melee_metalbat")
if not SWEP then return end

SWEP.PrintName = "Кувалда"
SWEP.Instructions = "Ручной ударный инструмент, предназначенный для боя камня, нанесения исключительно сильных ударов при обработке металла, на демонтаже и монтаже конструкций."

SWEP.WorldModel = "models/weapons/me_sledge/w_me_sledge.mdl"

SWEP.Primary.Damage = 55
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.4
SWEP.Primary.Force = 150

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"
SWEP.HitSound = {"physics/metal/metal_box_impact_hard1.wav","physics/metal/metal_box_impact_hard2.wav","physics/metal/metal_box_impact_hard3.wav"}
SWEP.FlashHitSound = {"physics/flesh/flesh_strider_impact_bullet1.wav","physics/flesh/flesh_strider_impact_bullet2.wav","physics/flesh/flesh_strider_impact_bullet3.wav"}
SWEP.ShouldDecal = false
SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_CLUB

function SWEP:Attack(ent,tr,dmgTab)
    if ent:GetBoneName(ent:TranslatePhysBoneToBone(tr.PhysicsBone)) == "ValveBiped.Bip01_Head1" then
        ent:EmitSound("physics/metal/sawblade_stick" .. math.random(1,3) .. ".wav")

        dmgTab:AddKill("headExplode")
    end

    local ent = RagdollOwner(ent) or ent
    if not IsValid(ent) then return end

    if IsValid(ent:GetPhysicsObject()) and (string.find(ent:GetPhysicsObject():GetMaterial(),"flesh") or string.find(ent:GetPhysicsObject():GetMaterial(),"player")) then
        sound.Play("physics/body/body_medium_break" .. math.random(1,2) .. ".wav",tr.HitPos,75)
    end
end

SWEP.sndTwroh = {"weapons/melee/swing_heavy_blunt_01.wav","weapons/melee/swing_heavy_blunt_02.wav","weapons/melee/swing_heavy_blunt_03.wav"}

SWEP.dwsItemPos = Vector(-0.5,4,0)
SWEP.dwsItemAng = Angle(90 + 45,0,90)
SWEP.dwsItemFOV = 0