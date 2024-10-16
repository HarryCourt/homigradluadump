-- "addons\\homigrad_core\\lua\\shlib\\tier_2_world\\render\\particles_settings_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ParticleGravity = Vector(0,0,-400)

ParticleMatSmoke = {}
for i = 1,6 do ParticleMatSmoke[i] = Material("particle/smokesprites_000" .. i) end
