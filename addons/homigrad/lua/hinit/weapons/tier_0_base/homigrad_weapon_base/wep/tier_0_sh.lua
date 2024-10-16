-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_0_base\\homigrad_weapon_base\\wep\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("wep","base_entity",true)
if not ENT then return INCLUDE_BREAK end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "wep"

ENT.Spawnable = false
DEFINE_BASECLASS( "base_anim" )


