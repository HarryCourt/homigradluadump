-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\level_hook_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function hooked(name,nameFunc)
	hook.Add(name,"level",function(...)
		local func = TableRound()[nameFunc]
		if func then return func(...) end
	end)
end

local function evented(name,nameFunc)
	event.Add(name,"level",function(...)
		local func = TableRound()[nameFunc]
		if func then return func(...) end
	end)
end

evented("PlayerSpawn","PlayerSpawn")
evented("Player Death","PlayerDeath")
evented("PreCalcView","PreCalcView")
evented("Move","Move")

hooked("PlayerSwitchWeapon","PlayerSwitchWeapon")
hooked("OnContextMenuOpen","OnContextMenuOpen")
hooked("OnContextMenuClose","OnContextMenuClose")
hooked("CanUseSpectateHUD","CanUseSpectateHUD")

hooked("Think","Think")

hooked("OnPhysgunFreeze","OnPhysgunFreeze")
hooked("PhysgunDrop","PhysgunDrop")
hooked("PhysgunPickup","PhysgunPickup")
hooked("PostDrawTranslucentRenderables","PostDrawTranslucentRenderables")
hooked("Paint Content Icon","PaintContentIcon")
hooked("Scoreboard DMenu","ScoreboardDMenu")

hooked("Should Draw Screenspace","DrawScreenspace")

hooked("BodyCam","BodyCam")
hooked("SetupFog","SetupFog")