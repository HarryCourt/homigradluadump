-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\med\\tier_0_med_kit\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("med_kit","hg_wep_base",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "weapon_medkit"
SWEP.Author = "0oa"
SWEP.Instructions = "weapon_medkit_desc"

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"

SWEP.DrawCrosshair = false

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsItemPos = Vector(0,0,-4)
SWEP.dwsItemAng = Angle(0,-90,0)
SWEP.dwsItemFOV = -12

SWEP.vbw = false
SWEP.vbwPos = Vector(0,-1,-7)
SWEP.vbwAng = Angle(-90,90,180)
SWEP.vbwModelScale = Vector(0.8,0.8,0.8)

SWEP.InvMoveSnd = InvMoveSndBody
SWEP.InvCount = 3
SWEP.itemType = "medical"

SWEP.HoldType = "slam"

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(5,7,-2)
SWEP.wmAngle = Angle(0,0,-90)