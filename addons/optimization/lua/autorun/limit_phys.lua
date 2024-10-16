-- "addons\\optimization\\lua\\autorun\\limit_phys.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local GetPerformanceSettings = physenv.GetPerformanceSettings
local SetPerformanceSettings = physenv.SetPerformanceSettings

hook.Add("InitPostEntity","RemoveShittyHooks",function()
	local phys_settings = GetPerformanceSettings()

	phys_settings.LookAheadTimeObjectsVsObject = 0 -- 0.5
	phys_settings.LookAheadTimeObjectsVsWorld = 0.1 -- 1
	phys_settings.MaxAngularVelocity = 3600 -- 7272.7275390625
	phys_settings.MaxCollisionChecksPerTimestep = 100 -- 50000
	phys_settings.MaxCollisionsPerObjectPerTimestep = 1 -- 10
	phys_settings.MaxFrictionMass = 2500 -- 2500
	phys_settings.MaxVelocity = 768 -- 4000
	phys_settings.MinFrictionMass = 100 -- 10

	SetPerformanceSettings(phys_settings)
end )