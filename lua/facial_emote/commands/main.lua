-- "lua\\facial_emote\\commands\\main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if ( CLIENT ) then
	concommand.Add( "fe_requestData", function( ply, cmd, args )
		facialEmote.network.sendCommand( "requestEmoteData" )
	end )
	concommand.Add( "fe_openMenu", function()
		facialEmote.interface.openMenu()
	end )
end

if ( SERVER ) then
	concommand.Add( "fe_addAllowedGroup", function( ply, cmd, args )
		facialEmote.parameters.server.authorizedGroups[tostring(args[1])] = true
		facialEmote.data.write( "allowed_group", facialEmote.parameters.server.authorizedGroups )
	end )
	
	concommand.Add( "fe_removeAllowedGroup", function( ply, cmd, args )
		facialEmote.parameters.server.authorizedGroups[tostring(args[1])] = nil
		facialEmote.data.write( "allowed_group", facialEmote.parameters.server.authorizedGroups )
	end )
	
	concommand.Add( "fe_getAllowedGroup", function( ply, cmd, args )
		MsgC( Color( 255, 255, 0 ), "[Facial Emote] : The list of groups that are allowed to modify emote through editor\n" )
		for group in pairs ( facialEmote.parameters.server.authorizedGroups ) do
			local amountOfPlayers = 0
			for _, ply in pairs ( player.GetAll() ) do
				if ( ply:GetUserGroup() == group ) then
					amountOfPlayers = amountOfPlayers + 1
				end
			end
			MsgC( Color( 0, 255, 0 ), "-" .. group, Color( 255, 255, 255 ), " ( online : " .. amountOfPlayers .. " ) \n" )
		end
	end )
end

