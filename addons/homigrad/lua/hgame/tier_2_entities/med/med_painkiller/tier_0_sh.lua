-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\med\\med_painkiller\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("med_painkiller","med_kit",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "Обезболивающее"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Повышает скорость понижения боли"

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.WorldModel = "models/w_models/weapons/w_eq_painpills.mdl"

SWEP.vbwPos = Vector(-5,6,-7)
SWEP.vbwAng = Angle(90,0,0)
SWEP.vbwModelScale = Vector(0.8,0.8,0.8)

SWEP.vbwPos2 = Vector(-2.2,5,-7)
SWEP.vbwAng2 = Angle(90,0,0)

SWEP.dwsItemPos = Vector(0,0,-3)
SWEP.dwsItemAng = Angle(0,-90,0)
SWEP.dwsItemFOV = -15

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end

SWEP.InvMoveSnd = InvMoveSnd

SWEP.wmVector = Vector(3,2,0)
SWEP.wmAngle = Angle(0,0,180)