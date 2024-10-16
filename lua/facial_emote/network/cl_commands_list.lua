-- "lua\\facial_emote\\network\\cl_commands_list.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local function receiveAllEmote( data )
	facialEmote.face.data = ( data or  {} )
end	

local function resetFlex( ply )
	facialEmote.flexModification.initFlex( ply )
end

local function sendAllowedUsergroup( tab )
	if ( not tab ) then return end
	facialEmote.parameters.client.authorizedGroups = tab
end

facialEmote.network.addCommand( "sendEmote", facialEmote.face.saveEmote )
facialEmote.network.addCommand( "sendAllowedUsergroup", sendAllowedUsergroup )
facialEmote.network.addCommand( "removeEmote", facialEmote.face.removeEmote )
facialEmote.network.addCommand( "sendAllEmote", receiveAllEmote )
facialEmote.network.addCommand( "resetFlex", resetFlex )