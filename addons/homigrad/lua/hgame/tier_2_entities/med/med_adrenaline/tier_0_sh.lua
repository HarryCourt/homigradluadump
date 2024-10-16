-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\med\\med_adrenaline\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("med_adrenaline","med_kit",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "Адреналин"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Гормон сужает сосуды, особенно брюшной полости. Объём крови в организме перераспределяется, из печени и селезёнки она оттекает в сосуды тела, пополняя объём циркулирующей в них крови, вследствие чего сосуды, ведущие к сердцу и мозгу, расширяются, кровоснабжение органов улучшается"

SWEP.Spawnable = true
SWEP.Category = "Медицина"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.WorldModel = "models/weapons/w_models/w_jyringe_jroj.mdl"

SWEP.vbwPos = Vector(0,-1,-12)
SWEP.vbwAng = Angle(0,0,0)
SWEP.vbwModelScale = Vector(1,1,1)

SWEP.dwmModeScale = 1
SWEP.dwmForward = 4
SWEP.dwmRight = 1
SWEP.dwmUp = 0

SWEP.dwmAUp = 0
SWEP.dwmARight = 90
SWEP.dwmAForward = 0

SWEP.InvMoveSnd = InvMoveSnd

SWEP.dwsItemPos = Vector(2.5,0,0)
SWEP.dwsItemAng = Angle(90 - 45,0,0)
SWEP.dwsItemFOV = -15

SWEP.wmVector = Vector(4,1,2)
SWEP.wmAngle = Angle(0,90,0)