-- "addons\\advancedsentinelsystem\\lua\\effects\\eff_baku_rubbercer_sentinel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
//local lifetime = 0.2
//local inverse = 1 / lifetime

local len = 200
local len2 = 200

local lifetime2 = 1.5
local inv = 1 / lifetime2

local lastwizz = 0
local parttimer = 0

function EFFECT:Init(data)
	local ent = data:GetEntity() 
	local att = data:GetAttachment()
	self.StartPos = data:GetStart() or vector_origin
	self.Scale = 1

	if(IsValid(ent) && data:GetFlags() != 1) then
		if(ent:IsWeapon() && ent:IsCarriedByLocalPlayer()) then
			local ply = ent:GetOwner()

			if(!ply:ShouldDrawLocalPlayer()) then
				local vm = ply:GetViewModel()
				
				if(IsValid(vm)) then
					ent = vm
				end
			end
		end

		self.StartPos = ent:GetAttachment(att).Pos
	end

	self.EndPos = data:GetOrigin()
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)

	local _dist = self.StartPos:Distance(self.EndPos)

	local lifetime = _dist * 0.00007
	self.DieTime = CurTime() + lifetime
	self.Inverse = 1 / lifetime
	self.Direction = (self.EndPos - self.StartPos):GetNormalized()

	self.DieTime2 = CurTime() + lifetime2
	self.Dist = _dist

	self.StartAlpha = math.random(10, 50)

	if(lastwizz < CurTime()) then
		local _plypoint = LocalPlayer():EyePos()
		local _kyroshie

		local _ab = self.EndPos - self.StartPos
		local _be = _plypoint - self.EndPos
		local _ae = _plypoint - self.StartPos
		local _dotabbe = _ab:Dot(_be)
		local _dotabae = _ab:Dot(_ae)

		if(_dotabbe > 0) then
			_kyroshie = self.EndPos
		elseif(_dotabae < 0) then
			_kyroshie = self.StartPos
		else
			_kyroshie = self.StartPos + self.Direction * _dotabae / _dist

			sound.Play("weapons/physgun_off.wav", _kyroshie, 75, math.random(225, 255))
			sound.Play("weapons/fx/nearmiss/bulletLtoR0" .. math.random(3,9) .. ".wav", _kyroshie)
		end

		lastwizz = CurTime() + math.Rand(0.1, 0.5)
	end
end

local MRToFrance_beamSeanTyas = Material("sprites/baku_rubbercer")

local PulserPointofimpact_FractalStructure = Material("sprites/baku_burntcer_smoke")

local __KeepTheMixRocking = {}
__KeepTheMixRocking[1] = function(self, _x, size, start, color, len2)
		render.SetMaterial(MRToFrance_beamSeanTyas)
		render.DrawBeam(start - self.Direction * len2, start, size * 0.2, 0.2, 1, Color(195, 125, 255))
		render.DrawBeam(start - self.Direction * len2, start, size, 0.2, 1, Color(195, 155, 255))
	end
__KeepTheMixRocking[2] = function(self, _x, size, start, color, len2)

	end

local __UnrealLove = {}
__UnrealLove[1] = LerpVector
__UnrealLove[2] = function(x, y, z) return y end

function EFFECT:Render()
	local _x = (self.DieTime - CurTime()) * self.Inverse
	local size = Lerp( _x, 0, 12 * self.Scale )

	local color = Color(170, 150, 255)
	local __xyz = Either(self.DieTime > CurTime(), 1, 2)

	local len2 = len

	if(self.Dist < len) then
		len2 = self.Dist
	end

	local start = __UnrealLove[__xyz](_x, self.EndPos, self.StartPos + self.Direction * len2)

	__KeepTheMixRocking[__xyz](self, _x, size, start, color, len2)

	local _y = (self.DieTime2 - CurTime()) * inv
	local alpha = Lerp(_y, 0, self.StartAlpha)
	render.SetMaterial(PulserPointofimpact_FractalStructure)
	render.DrawBeam(self.StartPos, start, 3 + _y * 3, 0, self.Dist * 0.004, Color(255, 255, 255, alpha))
end

function EFFECT:Think()
	if(self.DieTime2 < CurTime() && self.DieTime < CurTime()) then
		return false
	end

	return true
end