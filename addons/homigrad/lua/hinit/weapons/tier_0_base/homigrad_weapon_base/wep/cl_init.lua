-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_0_base\\homigrad_weapon_base\\wep\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Get("wep")
if not ENT then return end

function ENT:Draw()
	local ent = self:GetNWEntity("LinkDraw")

	if IsValid(ent) then ent:DrawWorldModel() end
end