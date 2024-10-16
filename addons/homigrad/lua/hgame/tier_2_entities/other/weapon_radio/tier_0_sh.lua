-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\weapon_radio\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_radio","hg_wep_base",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName 				= "Рация"
SWEP.Author 				= "0oa"
SWEP.Instructions			= "Общение со своей командой"
SWEP.Category 				= "Предметы"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 0
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.wmVector = Vector(5.3,-6,41)
SWEP.wmAngle = Angle(0,180,0)

SWEP.dwsItemPos = Vector(-0.3,7,-44.5)
SWEP.dwsItemAng = Angle(6,180,0)
SWEP.dwsItemFOV = -12

SWEP.EnableTransformModel = true

SWEP.vbw = true
SWEP.vbwPistol = true
SWEP.vbwPos = Vector(0.5,-44,-0.5)
SWEP.vbwAng = Angle(-90,0,-90)
SWEP.vbwModelScale = Vector(1,1,1)

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

SWEP.HoldType = "normal"

SWEP:Event_Add("Step","Anim",function(self,ply)
    if ply:GetNWBool("Voice") then
        if CLIENT and self:IsLocal() and DRAWMODEL then
            ply.rupperarm:Add(Angle(0,-25,20))
            ply.rforearm:Add(Angle(-24,-120,20))
            ply.rhand:Add(Angle(-20,0,70))
        else
            ply.rupperarm:Add(Angle(0,-25,20))
            ply.rforearm:Add(Angle(-30,-120,0))
            ply.rhand:Add(Angle(-0,0,90))
        end
    end
end)