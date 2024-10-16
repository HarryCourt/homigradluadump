-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\molotov_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_molotov","wep_gnade_base")
if not SWEP then return end

SWEP.PrintName = "Коктейль Молотова"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Стеклянная бутылка, содержащая горючую жидкость и запал"
SWEP.Category = "Гранаты"

SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Spawnable = true

SWEP.WorldModel = "models/w_models/weapons/w_eq_molotov.mdl"

SWEP.Granade = "ent_gnade_molotov"

SWEP.dwsItemFOV = -9
SWEP.dwsItemPos = Vector(0,0,-2)

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(5,2,0)
SWEP.wmAngle = Angle(0,180,0)

