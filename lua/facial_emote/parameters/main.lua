-- "lua\\facial_emote\\parameters\\main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal


if ( CLIENT ) then
	facialEmote.parameters.client = {}
	facialEmote.parameters.client.enableDebug = ( GetConVar( "fe_debug_enabled" ) or CreateClientConVar( "fe_debug_enabled", "0" ) )
	facialEmote.parameters.client.hotkeyWheel = ( GetConVar("fe_wheelbind") or CreateClientConVar( "fe_wheelbind", "18" ) )
	facialEmote.parameters.client.authorizedGroups = {}
end

if ( SERVER ) then
	facialEmote.parameters.server = {}
	facialEmote.parameters.server.authorizedGroups = ( facialEmote.data.load( "allowed_group.json" ) or { ["admin"] = true, ["superadmin"] = true } )
	facialEmote.parameters.server.enableDebug = ( GetConVar( "fe_debug_enabled" ) or CreateClientConVar( "fe_debug_enabled", "0" ) )
	facialEmote.parameters.server.calcServerSide = true	-- don't touch it yet
end