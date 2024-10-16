-- "lua\\facial_emote\\data\\main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
facialEmote.data = {}

file.CreateDir( "facial_emote" )

facialEmote.data.write = function( path, value )
	if ( type( value ) == "table" ) then
		file.Write( "facial_emote/" .. path .. ".json", util.TableToJSON( value ) )
	else
		file.Write( "facial_emote/" .. path .. ".txt", value )
	end
end

facialEmote.data.load = function( path, value )
	local finalPath = "facial_emote/" .. path
	if ( file.Exists( finalPath, "DATA" ) ) then
		if ( string.EndsWith( path, "json" ) ) then
			return util.JSONToTable( file.Read( finalPath, "DATA" ) )
		else
			return file.Read( finalPath, "DATA" )
		end
	end
end

