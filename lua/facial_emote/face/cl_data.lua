-- "lua\\facial_emote\\face\\cl_data.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

facialEmote.face.data = ( facialEmote.face.data or {} )

facialEmote.face.saveEmote = function( mdl, index, data, name, image )
	if ( not mdl ) or ( not index ) or ( not data ) then return end
	-- Create the table for the model
	if ( not facialEmote.face.data[mdl] ) then
		facialEmote.face.data[mdl] = {}
	end
	 
	facialEmote.face.data[mdl][tonumber(index)] = {
		data = data,
		name = ( name or "?" ),
		image = ( image or "?" )
	}
	
	facialEmote.debug.print( "New emote [" .. index .. "] for the model " .. mdl .. " saved !", Color( 0, 255, 0 ) )
	
	local editorPanel = facialEmote.interface.editorPanel
	if ( IsValid( editorPanel ) ) then
		facialEmote.interface.editorPanel.OnEmoteAdded( editorPanel, mdl, index )
	end
end

facialEmote.face.removeEmote = function( mdl, index )
	if ( not mdl ) or ( not index ) then return end
	if ( not facialEmote.face.data[mdl] ) then return end
	if ( not facialEmote.face.data[mdl][index] ) then return end
	
	facialEmote.face.data[mdl][index] = nil
	facialEmote.debug.print( "The emote [" .. index .. "] for the model (" .. mdl .. ") has been removed !", Color( 0, 255, 0 ) )
	
	if ( table.IsEmpty( facialEmote.face.data[mdl] ) ) then
		facialEmote.face.data[mdl] = nil
		facialEmote.debug.print( "The model (" .. mdl .. ") has been removed from the data !", Color( 0, 255, 0 ) )
	end
	
	local editorPanel = facialEmote.interface.editorPanel
	if ( IsValid( editorPanel ) ) then
		facialEmote.interface.editorPanel.OnEmoteRemoved( editorPanel, mdl, index )
	end
end

