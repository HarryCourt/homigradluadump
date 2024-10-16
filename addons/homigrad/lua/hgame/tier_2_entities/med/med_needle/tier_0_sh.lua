-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\med\\med_needle\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("med_needle","med_kit",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "Шприц"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Постепено востанаилвает ХП,\nПри получении урона регенерация отменяется."

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.WorldModel = "models/bloocobalt/l4d/items/w_eq_adrenaline.mdl"

SWEP.vbwPos = Vector(-2,-1.5,-7)
SWEP.vbwAng = Angle(-90,90,180)
SWEP.vbwModelScale = Vector(0.8,0.8,0.8)

SWEP.vbwPos2 = Vector(-3,0.2,-7)
SWEP.vbwAng2 = Angle(-90,90,180)

SWEP.dwsItemPos = Vector(0,-1.5,-0.7)
SWEP.dwsItemAng = Angle(90 - 45,-90,0)
SWEP.dwsItemFOV = -13

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end

SWEP.InvMoveSnd = InvMoveSnd

SWEP.wmVector = Vector(3.5,2,0)
SWEP.wmAngle = Angle(0,0,-90)