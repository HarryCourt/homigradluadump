-- "lua\\autorun\\death.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("PlayerDeathSound", "DeFlatline", function() return true end)
local noise = Sound("death.wav")
hook.Add("PlayerDeath", "NewSound", function(vic,unused1,unused2) vic:EmitSound(noise) end)