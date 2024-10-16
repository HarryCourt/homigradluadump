-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\med\\med_band\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("med_band","med_kit",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "Бинт"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Лечит мелкую кровопотерю"

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.WorldModel = "models/bandages.mdl"

SWEP.vbwPos = Vector(2,6,-8)
SWEP.vbwAng = Angle(0,0,0)
SWEP.vbwModelScale = Vector(0.25,0.25,0.25)

SWEP.vbwPos2 = Vector(0,3,-8)
SWEP.vbwAng2 = Angle(0,0,0)

SWEP.dwsItemPos = Vector(0,0,0)
SWEP.dwsItemAng = Angle(45,-0,-90)
SWEP.dwsItemFOV = -13

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end

SWEP.InvCount = 6

SWEP.wmVector = Vector(8,3,-1)
SWEP.wmAngle = Angle(0,90,0)