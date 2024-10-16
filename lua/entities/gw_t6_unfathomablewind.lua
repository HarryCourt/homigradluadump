-- "lua\\entities\\gw_t6_unfathomablewind.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

DEFINE_BASECLASS( "gw_base" )

ENT.Spawnable = false        
ENT.AdminSpawnable = false 

ENT.PrintName = "Unfathomable Wind"
ENT.Author = "Jimmywells"

function ENT:Initialize()			
	BaseClass.Initialize(self)

	if (CLIENT) then

	end

	if (SERVER) then
		gWeather:SetWind(math.random(350,400),nil,80) -- 350-400 kmh

	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	return BaseClass.SpawnFunction( scripted_ents.GetStored("gw_base"), ply, tr, ClassName )
end

--[[

function ENT:Think()
	if (CLIENT) then
	
	end

	if (SERVER) then

		local i = ( FrameTime() / 0.015 ) * .01
	
		self:NextThink(CurTime() + i)
		return true
	end
end

--]]

function ENT:OnRemove()

	if (CLIENT) then
	
	end

	if (SERVER) then	
	
		gWeather:WindReset()
		
	end
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end






