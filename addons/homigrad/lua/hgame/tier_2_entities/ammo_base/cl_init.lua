-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\ammo_base\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Get("ammo_base")
if not ENT then return end

function ENT:DrawInv(item,w,h,butt)
	if not self.Icon then
		local x,y = butt:LocalToScreen()
                
		DrawWeaponSelectionEX(self,x,y,w,h - 13,true,-butt.hovered * 1)
	else
		local size = h - 14 + butt.hovered * 5

		surface.SetMaterial(self.Icon)

		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(w / 2 - size / 2 + 1,h / 2 - size / 2 + 1,size,size)	
	end

	draw.SimpleText("x" .. item.count,"InvFont",4,2)
end