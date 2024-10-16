-- "lua\\facial_emote\\interface\\cl_fonts.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local function createFont( size, bold )
	local fontName =  "Coolvetica" .. size .. ( bold and "_bold" or "" )
	surface.CreateFont( fontName, {
		font = "Coolvetica Rg",
		size = ( size or 18 ),
		weight = ( bold and 2000 or 0 ),
		scanlines = 0,
		antialias = true
	} )
end

for i = 16, 30, 2 do
	createFont( i )
	createFont( i, true )
end

for i = 35, 60, 5 do
	createFont( i )
	createFont( i, true )
end








 
