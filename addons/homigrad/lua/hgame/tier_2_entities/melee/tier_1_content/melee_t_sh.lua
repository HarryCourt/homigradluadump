-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_1_content\\melee_t_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_t","melee_base")
if not SWEP then return end

SWEP.PrintName = "Томагавк"
SWEP.Instructions = "Находится на вооружении кораблей и подводных лодок ВМС США, использовалась во всех значительных военных конфликтах с участием США с момента её принятия на вооружение в 1983 году."

SWEP.WorldModel = "models/pwb/weapons/w_tomahawk.mdl"
SWEP.HoldType = "melee"

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_Knife.Single" )
SWEP.Primary.Damage = 38
SWEP.DamageBleed = 60

SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1
SWEP.Primary.Force = 1000

SWEP.HitSound = "snd_jack_hmcd_axehit.wav"

SWEP.dwsItemPos = Vector(8.7,0,-8)
SWEP.dwsItemAng = Angle(15 - 45,0,0)
SWEP.dwsItemFOV = -6