-- "gamemodes\\base\\entities\\entities\\base_ai\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

include( "shared.lua" )

--[[---------------------------------------------------------
	Name: Draw
	Desc: Draw it!
-----------------------------------------------------------]]
function ENT:Draw()
	self:DrawModel()
end

--[[---------------------------------------------------------
	Name: DrawTranslucent
	Desc: Draw translucent
-----------------------------------------------------------]]
function ENT:DrawTranslucent()

	-- This is here just to make it backwards compatible.
	-- You shouldn't really be drawing your model here unless it's translucent

	self:Draw()

end
