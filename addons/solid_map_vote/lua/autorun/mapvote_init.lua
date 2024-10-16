-- "addons\\solid_map_vote\\lua\\autorun\\mapvote_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

SolidMapVote = SolidMapVote or {}
SolidMapVote[ 'Config' ] = SolidMapVote[ 'Config' ] or {}

if DONTSOLIDMAPVOTE then return end

if SERVER then
	AddCSLuaFile("core/init.lua")

	include("core/init.lua")
else
	include("core/init.lua")
end