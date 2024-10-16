-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_knife_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_knife","melee_base")
if not SWEP then return end

SWEP.PrintName = "Складной Ножик"
SWEP.Instructions = "Маленький ножик складного типа, который удобно носить в кармане. Хорошее средство для самообороны, которое никто не сможет увидеть, пока вы не достанете его из кармана."

SWEP.WorldModel = "models/pwb/weapons/w_knife.mdl"

SWEP.HoldType = "melee"

SWEP.Primary.Damage = 4
SWEP.DamageBleed = 4

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.4
SWEP.Primary.Force = 150

SWEP.FlashHitSound = "snd_jack_hmcd_slash.wav"

function SWEP:Attack(ent,obj,tr,dmginfo)
    if ent.Blooded then ent.Blooded = ent.Blooded + 5 end
end

SWEP.sndTwroh = {"weapons/melee/swing_fists_01.wav","weapons/melee/swing_fists_02.wav","weapons/melee/swing_fists_03.wav"}
SWEP.sndTwrohPitch = 255

SWEP.dwsItemPos = Vector(9.5,0,-5)
SWEP.dwsItemAng = Angle(35 - 45,0,0)
SWEP.dwsItemFOV = -13