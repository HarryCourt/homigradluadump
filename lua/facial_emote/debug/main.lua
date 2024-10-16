-- "lua\\facial_emote\\debug\\main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
facialEmote.debug = {}
facialEmote.debug.msg = {}

if ( CLIENT ) then
	facialEmote.debug.print = function( text, col, tags, time )
		if ( not facialEmote.parameters.client.enableDebug:GetBool() ) then return end	
		local debugMsg = { 
			text = tostring( text ),
			col = col,
			bornTime = CurTime(),
			expireTime = ( time or 10 )
		}
			
		debugMsg.tags = tags
		surface.PlaySound( "facial_emote/debug.wav" )	
		table.insert( facialEmote.debug.msg, debugMsg )
		MsgC( Color( 255, 255, 0 ), "[DEBUG][Facial Emote] : " .. tostring( text ) .. "\n" )
	end
end

if ( SERVER ) then
	facialEmote.debug.print = function( text, col, tags, time )
		if ( not facialEmote.parameters.server.enableDebug:GetBool() ) then return end	
		MsgC( Color( 255, 255, 0 ), "[DEBUG][Facial Emote] : " .. tostring( text ) .. "\n" )
	end
end
 
facialEmote.debug.DrawOverlay = function()
	if ( not facialEmote.parameters.client.enableDebug:GetBool() ) then return end
	
	local yPos = ScrH() - 35
	for k , v in pairs ( facialEmote.debug.msg ) do
		surface.SetFont( "DermaDefaultBold" )
		local w = surface.GetTextSize( v.text )
		local sizeW = math.Clamp( w + 25, 100, 2000 )
		
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 5, yPos, sizeW, 30 )
		
		if ( v.col ) then
			surface.SetDrawColor( v.col )
			surface.DrawRect( 7, yPos + 2, 10, 21 )
			draw.SimpleText( v.text, "DermaDefaultBold", 23, yPos + 12, color_white, 0, 1 )
		else
			draw.SimpleText( v.text, "DermaDefaultBold", 10, yPos + 12, color_white, 0, 1 )
		end
		
		local timeAlive = CurTime() - v.bornTime 
		local timeLeftRatio = ( v.expireTime - timeAlive )/v.expireTime
	
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 5, yPos+25, sizeW, 5 )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 5, yPos+25, sizeW * timeLeftRatio, 5 )
		
		surface.SetDrawColor( Color( 115, 115, 115, 255 ) ) 
		surface.DrawOutlinedRect( 5, yPos, sizeW, 30 )
		
		if ( timeAlive > v.expireTime ) then
			facialEmote.debug.msg[k] = nil
		end
		 
		yPos = yPos - 32
	end
end