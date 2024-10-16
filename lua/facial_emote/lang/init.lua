-- "lua\\facial_emote\\lang\\init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
facialEmote.lang.data = {}

facialEmote.lang.getText = function( index )
	return ( facialEmote.lang.data["FR"][index] or "missing text" )
end

facialEmote.lang.data["FR"] = {}
facialEmote.lang.data["EN"] = {}