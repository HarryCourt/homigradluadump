-- "lua\\facial_emote\\network\\init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
facialEmote.network.commands = {}

if ( CLIENT ) then
	facialEmote.network.addCommand = function( key, func )
		facialEmote.network.commands[key] = func
	end
	
	facialEmote.network.receiveCommand = function( len )
		local nTab = net.ReadTable()
		
		if ( not nTab.command ) then 
			facialEmote.debug.print( "Server attempt to send a command but is nil", Color( 255, 0, 0 ) )
			return 
		end
		if ( not facialEmote.network.commands[nTab.command] ) then
			facialEmote.debug.print( "Server send the command (" .. nTab.command .. ") but it don't exist", Color( 255, 0, 0 ) )
			return
		end
		
		facialEmote.network.commands[nTab.command]( unpack( nTab.args ) )
		facialEmote.debug.print( "Receive the command (" .. nTab.command .. ") !", Color( 0, 255, 0 ) )
	end

	facialEmote.network.sendCommand = function( command, ... )
		local nTab = { command = command, args = { ... } }
		net.Start( "facialEmote_sendCommand" )
			net.WriteTable( nTab )
		net.SendToServer()
		facialEmote.debug.print( "Sending command (" .. nTab.command .. ") to the server !", Color( 0, 255, 0 ) )
	end
	
	net.Receive( "facialEmote_sendCommand", facialEmote.network.receiveCommand )
end 

if ( SERVER ) then
	facialEmote.network.netID = util.AddNetworkString( "facialEmote_sendCommand" )
	
	facialEmote.network.sendCommand = function( ply, command, ... )
		local nTab = { command = command, args = { ... } }
		net.Start( "facialEmote_sendCommand" )
			net.WriteTable( nTab )
		net.Send( ply )
	end
	
	facialEmote.network.addCommand = function( key, func )
		facialEmote.network.commands[key] = func
	end

	facialEmote.network.receiveCommand = function( len, ply )
		local nTab = net.ReadTable()
		facialEmote.debug.print( "Received the command (" .. ( nTab.command or "NULL" ) .. ") from player " .. tostring( ply ) )
		if ( not nTab.command ) then return end
		if ( not facialEmote.network.commands[nTab.command] ) then return end
		facialEmote.network.commands[nTab.command]( ply, unpack( nTab.args ) )
	end
	
	net.Receive( "facialEmote_sendCommand", facialEmote.network.receiveCommand )
end
