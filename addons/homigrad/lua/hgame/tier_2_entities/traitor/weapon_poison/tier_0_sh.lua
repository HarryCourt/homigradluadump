-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\traitor\\weapon_poison\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_poison","med_kit",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "Цианид"
SWEP.Author = "akurse"
SWEP.Instructions = "ЛКМ чтобы отравить предмет или игрока, лучше всего работает на политиков"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "Примочки убийцы"

SWEP.WorldModel = "models/weapons/w_models/w_jyringe_proj.mdl"

SWEP.ShouldDropOnDie = false
SWEP.Charges = 3

SWEP.HoldType = "normal"

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(4,2,-3)
SWEP.wmAngle = Angle(0,-90,0)

function SWEP:PreDrawViewModel(vm, wep, ply)
    vm:SetMaterial("models/weapons/v_models/v_syringe/v_syringe")
end
