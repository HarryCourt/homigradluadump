-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\sh_step.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local mul = 1
local FrameTime,TickInterval = engine.AbsoluteFrameTime,engine.TickInterval

TickInterval = 1 / 60

local CurTime = CurTime
local delay1,delay025,delay01 = 0,0,0
local Run = hook.Run

hook.Add("Think","SHLib",function()
	mul = FrameTime() / TickInterval

	local time = CurTime()

	CTime = time

	if delay1 <= CTime then
		delay1 = CTime + 1
		
		Run("Think 1",time,mul)
	end

	if delay025 <= CTime then
		delay025 = CTime + 0.25

		Run("Think 0.25",time,mul)
	end

	if delay01 <= CTime then
		delay01 = CTime + 0.1

		Run("Think 0.1",time,mul)
	end
	
end,-2)--mdam

function GetFT() return mul end

local Lerp,LerpVector,LerpAngle = Lerp,LerpVector,LerpAngle
local math_min = math.min

function LerpFT(lerp,source,set)
	return Lerp(math_min(lerp * mul,1),source,set)
end

function LerpVectorFT(lerp,source,set)
	return LerpVector(math_min(lerp * mul,1),source,set)
end

function LerpAngleFT(lerp,source,set)
	return LerpAngle(math_min(lerp * mul,1),source,set)
end

local abs = math.abs

function LerpFTLess(lerp,source,set,less)
	local v = LerpFT(lerp,source,set)
	
	if abs(set - source) <= (less or 1) then v = set end
	
	return v
end
