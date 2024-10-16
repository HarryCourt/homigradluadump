-- "addons\\jmod_eft\\lua\\autorun\\eft_s_precache.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if true then return end

if ( SERVER ) then 

	game.AddParticles("particles/hs_impact_fx.pcf")
	PrecacheParticleSystem("impact_helmet_headshot_csgo")
	
end

if ( CLIENT ) then 

	game.AddParticles("particles/hs_impact_fx.pcf")
	PrecacheParticleSystem("impact_helmet_headshot_csgo")
	
end