-- "addons\\homigrad\\lua\\hgame\\tier_1\\fake\\ragdoll\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("fake_ragdoll","base_entity",true)
if not ENT then return INCLUDE_BREAK end

FindMetaTable("Player").GetEntity = function(self)
	local ent = self:GetNWEntity("Ragdoll")
	
	return IsValid(ent) and ent or self
end
