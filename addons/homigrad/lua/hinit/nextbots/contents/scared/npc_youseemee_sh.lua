-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\scared\\npc_youseemee_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_youseemee","npc_kevin")
if not ENT then return end

ENT.Music = Sound("homigrad/scp/youseemee/scp2.wav")
ENT.SpriteMat = Material("homigrad/scp/scared/youseemee1.png")
ENT.FootStep = false

ENT.PrintName = "youseemee?"

function ENT:DrawSprite(pos,normal,size,color,rot)
	local follow = self:GetNWString("State") == "Follow"
	if LocalPlayer():Alive() and not follow then return end

	if self:GetNWString("State") == "Crounch" then
		surface.SetDrawColor(255,255,255,math.random(0,25))

		render.DrawQuadEasy(pos,normal,size * 1 + math.Rand(-25,25) * 75,follow and size * 1 + math.Rand(-25,25) * 75 or size,color,rot + math.sin(CurTime() * 1000 + math.Rand(-1,1)) * 2)
		render.DrawQuadEasy(pos,normal,size * 1 + math.Rand(-10,10) * 75,follow and size * 1 + math.Rand(-10,10) * 75 or size,color,rot + math.sin(CurTime() * 1000 + math.Rand(-1,1)) * 2)
	else
		surface.SetDrawColor(255,255,255,math.random(125,255))

		render.DrawQuadEasy(pos,normal,size * 1 + math.Rand(-2,2) * 75,follow and size * 1 + math.Rand(-2,2) * 75 or size,color,rot + math.sin(CurTime() * 1000 + math.Rand(-1,1)) * 2)
	end
end