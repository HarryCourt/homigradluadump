-- "lua\\facial_emote\\interface\\cl_materials.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Storage of all materials for the interface

facialEmote.interface.materials = {}
facialEmote.interface.emojis = {}

facialEmote.interface.createMaterial = function( index, path )
	local matClass, calcTime = Material( "facial_emote/" .. path, "smooth 1" )
	
	-- Check if the material as been succesfully loaded
	if ( matClass:GetName() ~= "___error" ) then
		if ( facialEmote.interface.materials[index] ) then
			facialEmote.debug.print( "Overwriting material " .. index .. " because it already exist.", Color( 255, 255, 0 ) )
		end
		facialEmote.debug.print( "Material " .. index .. " is succesfully created (" .. path .. ").", Color( 0, 255, 0 ) )
	else
		facialEmote.debug.print( "Failed to create material " .. index .. " (" .. path .. ").", Color( 255, 0, 0 ) )
	end
	facialEmote.interface.materials[index] = matClass
end 

facialEmote.interface.isMaterialValid = function( index )
	return ( facialEmote.interface.materials[index] and facialEmote.interface.materials[index]:GetName() ~= "___error" )
end 

facialEmote.interface.getMaterial = function( index )
	return facialEmote.interface.materials[index]
end 

facialEmote.interface.emojis["angel"] 		= Material( "emojis/angel.png" )
facialEmote.interface.emojis["angry"] 		= Material( "emojis/angry.png" )
facialEmote.interface.emojis["angry-1"] 	= Material( "emojis/angry-1.png" )
facialEmote.interface.emojis["arrogant"] 	= Material( "emojis/arrogant.png" )
facialEmote.interface.emojis["bored"] 		= Material( "emojis/bored.png" )
facialEmote.interface.emojis["confused"]	= Material( "emojis/confused.png" )
facialEmote.interface.emojis["cool"] 		= Material( "emojis/cool.png" )
facialEmote.interface.emojis["cool-1"] 		= Material( "emojis/cool-1.png" )
facialEmote.interface.emojis["crying"] 		= Material( "emojis/crying.png" )
facialEmote.interface.emojis["crying-1"]	= Material( "emojis/crying-1.png" )
facialEmote.interface.emojis["crying-2"]	= Material( "emojis/crying-2.png" )
facialEmote.interface.emojis["cute"] 		= Material( "emojis/cute.png" )
facialEmote.interface.emojis["embarrassed"]	= Material( "emojis/embarrassed.png" )
facialEmote.interface.emojis["greed"] 		= Material( "emojis/greed.png" )
facialEmote.interface.emojis["happy"] 		= Material( "emojis/happy.png" )
facialEmote.interface.emojis["happy-1"] 	= Material( "emojis/happy-1.png" )
facialEmote.interface.emojis["happy-2"] 	= Material( "emojis/happy-2.png" )
facialEmote.interface.emojis["happy-3"] 	= Material( "emojis/happy-3.png" )
facialEmote.interface.emojis["happy-4"] 	= Material( "emojis/happy-4.png" )
facialEmote.interface.emojis["happy-5"] 	= Material( "emojis/happy-5.png" )
facialEmote.interface.emojis["happy-6"] 	= Material( "emojis/happy-6.png" )
facialEmote.interface.emojis["happy-7"] 	= Material( "emojis/happy-7.png" )
facialEmote.interface.emojis["in-love"] 	= Material( "emojis/in-love.png" )
facialEmote.interface.emojis["kiss"] 		= Material( "emojis/kiss.png" )
facialEmote.interface.emojis["kiss-1"] 		= Material( "emojis/kiss-1.png" )
facialEmote.interface.emojis["laughing"] 	= Material( "emojis/laughing.png" )
facialEmote.interface.emojis["laughing-1"] 	= Material( "emojis/laughing-1.png" )
facialEmote.interface.emojis["laughing-2"] 	= Material( "emojis/laughing-2.png" )
facialEmote.interface.emojis["muted"] 		= Material( "emojis/muted.png" )
facialEmote.interface.emojis["nerd"] 		= Material( "emojis/nerd.png" )
facialEmote.interface.emojis["sad"] 		= Material( "emojis/sad.png" )
facialEmote.interface.emojis["sad-1"] 		= Material( "emojis/sad-1.png" )
facialEmote.interface.emojis["sad-2"] 		= Material( "emojis/sad-2.png" )
facialEmote.interface.emojis["scare"] 		= Material( "emojis/scare.png" )
facialEmote.interface.emojis["serious"] 	= Material( "emojis/serious.png" )
facialEmote.interface.emojis["shocked"] 	= Material( "emojis/shocked.png" )
facialEmote.interface.emojis["sick"] 		= Material( "emojis/sick.png" )
facialEmote.interface.emojis["sleepy"] 		= Material( "emojis/sleepy.png" )
facialEmote.interface.emojis["smart"] 		= Material( "emojis/smart.png" )
facialEmote.interface.emojis["surprised"] 	= Material( "emojis/surprised.png" )
facialEmote.interface.emojis["surprised-1"] = Material( "emojis/surprised-1.png" )
facialEmote.interface.emojis["surprised-2"] = Material( "emojis/surprised-2.png" )
facialEmote.interface.emojis["surprised-3"] = Material( "emojis/surprised-3.png" )
facialEmote.interface.emojis["surprised-4"] = Material( "emojis/surprised-4.png" )
facialEmote.interface.emojis["suspicious"] 	= Material( "emojis/suspicious.png" )
facialEmote.interface.emojis["tongue"] 		= Material( "emojis/tongue.png" )
facialEmote.interface.emojis["vain"] 		= Material( "emojis/vain.png" ) 
facialEmote.interface.emojis["wink_1"] 		= Material( "emojis/wink_1.png" ) 
facialEmote.interface.emojis["wink_2"] 		= Material( "emojis/wink_2.png" ) 
facialEmote.interface.emojis["wtf"] 		= Material( "emojis/wtf.png" ) 

facialEmote.interface.createMaterial( "add", "ui/add.png" )
facialEmote.interface.createMaterial( "bin", "ui/bin.png" )
facialEmote.interface.createMaterial( "valid", "ui/valid.png" )
facialEmote.interface.createMaterial( "cancel", "ui/cross.png" )
facialEmote.interface.createMaterial( "load", "ui/load.png" )
facialEmote.interface.createMaterial( "playermodel", "ui/user.png" )
facialEmote.interface.createMaterial( "information", "ui/information.png" )
facialEmote.interface.createMaterial( "parameter", "ui/parameters_2.png" )
facialEmote.interface.createMaterial( "out", "ui/out.png" )
facialEmote.interface.createMaterial( "circle", "ui/circle.png" )
facialEmote.interface.createMaterial( "icon_search_playermodel", "ui/search_playermodel.png" )


facialEmote.interface.createMaterial( "gradient_right_clear", "gradients/right_1024_clear.png" )
facialEmote.interface.createMaterial( "gradient_right_soft", "gradients/right_1024_soft.png" )
facialEmote.interface.createMaterial( "gradient_right_hard", "gradients/right_1024_hard.png" )
facialEmote.interface.createMaterial( "gradient_outline", "gradients_outline/1024_normal.png" )
facialEmote.interface.createMaterial( "left_corner", "gradients/left_corner_1.png" )
 

