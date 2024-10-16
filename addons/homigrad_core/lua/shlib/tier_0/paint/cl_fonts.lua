-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\paint\\cl_fonts.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local hg_screensize = CreateClientConVar("hg_screensize","1",true,false,"",0.25,2)

ScreenSize = hg_screensize:GetFloat()

cvars.AddChangeCallback("hg_screensize",function(_,_,new)
	ScreenSize = tonumber(new or 1) or 1

    hook.Run("Screen Size",ScreenSize)
end,"main")

hook.Add("Screen Size","Fonts",function(mul)
	surface.CreateFont("H.18",{
		font = "Arial",
		size = math.ceil(18 * mul),
		weight = 1100
	})

	surface.CreateFont("HO.18",{
		font = "Arial",
		size = math.ceil(18 * mul),
		weight = 1100
	})

	surface.CreateFont("H.25",{
		font = "Arial",
		size = math.ceil(25 * mul),
		weight = 1100
	})

	surface.CreateFont("H.45",{
		font = "Arial",
		size = math.ceil(45 * mul),
		weight = 1100
	})

	surface.CreateFont("H.12",{
		font = "Arial",
		size = math.ceil(12 * mul),
		weight = 1000,
	})

	--

	surface.CreateFont("HS.18",{
		font = "Arial",
		size = math.ceil(18 * mul),
		weight = 1100,
		shadow = true
	})

	surface.CreateFont("HOS.18",{
		font = "Arial",
		size = math.ceil(18 * mul),
		weight = 1100,
		shadow = true
	})

	surface.CreateFont("HS.25",{
		font = "Arial",
		size = math.ceil(25 * mul),
		weight = 1100,
		shadow = true
	})

	surface.CreateFont("HS.45",{
		font = "Arial",
		size = math.ceil(45 * mul),
		weight = 1100,
		shadow = true
	})

	surface.CreateFont("HS.12",{
		font = "Arial",
		size = math.ceil(12 * mul),
		weight = 1000,
		shadow = true
	})
	
	surface.ClearFontCache()
end)

hook.Add("InitPostEntity","Screen Size",function()
	ScreenSize = hg_screensize:GetFloat()

	hook.Run("Screen Size",ScreenSize)
end)