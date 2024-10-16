-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\cianade_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_cianade","wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "Разрывной цианид"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Пиротехническое средство для пуска дыма, предназначенное для подачи сигналов, указания места посадки, маскировки объектов при выполнении манёвров (в том числе в ходе уличных беспорядков)"
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/mass_effect_3/weapons/misc/mods/pistols/barrela.mdl"

SWEP.Granade = "ent_gnade_cianade"

SWEP.dwsItemFOV = -10

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(5,1,2)
SWEP.wmAngle = Angle(0,90,0)