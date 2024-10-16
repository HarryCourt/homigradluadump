-- "addons\\simfphys_base\\lua\\autorun\\simfphys_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
simfphys = istable( simfphys ) and simfphys or {}

FUELTYPE_NONE = -1
FUELTYPE_PETROL = 0
FUELTYPE_DIESEL = 1
FUELTYPE_ELECTRIC = 2

if SERVER then
	AddCSLuaFile("simfphys/client/fonts.lua")
	AddCSLuaFile("simfphys/client/tab.lua")
	AddCSLuaFile("simfphys/client/hud.lua")
	AddCSLuaFile("simfphys/client/lighting.lua")
	AddCSLuaFile("simfphys/client/damage.lua")
	AddCSLuaFile("simfphys/client/poseparameter.lua")
	AddCSLuaFile("simfphys/client/spawning.lua")
	AddCSLuaFile("simfphys/base_functions.lua")

	include("simfphys/server/spawner.lua")
	include("simfphys/server/poseparameter.lua")
	include("simfphys/server/joystick.lua")

	resource.AddWorkshop("771487490")

else
	killicon.Add( "gmod_sent_vehicle_fphysics_base", "HUD/killicons/simfphys_car", Color( 255, 80, 0, 255 ) )

	include("simfphys/client/fonts.lua")
	include("simfphys/client/tab.lua")
	include("simfphys/client/hud.lua")
	include("simfphys/client/lighting.lua")
	include("simfphys/client/damage.lua")
	include("simfphys/client/poseparameter.lua")
	include("simfphys/client/spawning.lua")
end

include("simfphys/base_functions.lua")

timer.Simple(0, function()
	hook.Run( "LVS:ARMED:Initialize" )
end)
