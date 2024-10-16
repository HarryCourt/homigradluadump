-- "addons\\advancedsentinelsystem\\lua\\effects\\eff_baku_combinecannon_tracer_sentinel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local lifetime = 0.3
local inverse = 1 / 0.3

function EFFECT:Init(data)
	self.DieTime = CurTime() + lifetime

	self.Entity = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = data:GetStart() or Vector(0, 0, 0)

	if(IsValid(self.Entity)) then
		self.StartPos = self.Entity:GetAttachment(self.Attachment).Pos
	end

	self.EndPos = data:GetOrigin()

	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
end

local beam = Material("sprites/bluelaser1")

function EFFECT:Render()
	local size = Lerp( (self.DieTime - CurTime()) * inverse, 0, 32 )

	render.SetMaterial(beam)
	render.DrawBeam(self.StartPos, self.EndPos, size, 0, 1, Color(100, 100, 255))
end

function EFFECT:Think()
	return self.DieTime > CurTime()
end