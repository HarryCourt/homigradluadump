-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\smokenade_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_smokenade","wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "Дымовая граната"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Пиротехническое средство для пуска дыма, предназначенное для подачи сигналов, указания места посадки, маскировки объектов при выполнении манёвров (в том числе в ходе уличных беспорядков)"
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/jmod/explosives/grenades/firenade/incendiary_grenade.mdl"

SWEP.Granade = "ent_gnade_smoke"

SWEP.dwsItemFOV = -10

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(5,2,0)
SWEP.wmAngle = Angle(0,180,0)