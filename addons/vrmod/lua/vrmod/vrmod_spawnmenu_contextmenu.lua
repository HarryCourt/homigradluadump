-- "addons\\vrmod\\lua\\vrmod\\vrmod_spawnmenu_contextmenu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then return end

vrmod.AddInGameMenuItem("Spawn Menu", 2, 0, function()
	if not IsValid(g_SpawnMenu) then return end
	g_SpawnMenu:Open()
	hook.Add("VRMod_OpenQuickMenu","close_spawnmenu",function()
		hook.Remove("VRMod_OpenQuickMenu","close_spawnmenu")
		g_SpawnMenu:Close()
		return false
	end)
end)

vrmod.AddInGameMenuItem("Context Menu", 3, 0, function()
	if not IsValid(g_ContextMenu) then return end
	g_ContextMenu:Open()		
	hook.Add("VRMod_OpenQuickMenu","closecontextmenu",function()
		hook.Remove("VRMod_OpenQuickMenu","closecontextmenu")
		g_ContextMenu:Close()
		return false
	end)
end)

hook.Add("VRMod_Exit","restore_spawnmenu",function(ply)
	if ply ~= LocalPlayer() then return end
	timer.Simple(0.1,function()
		if IsValid(g_SpawnMenu) and g_SpawnMenu.HorizontalDivider ~= nil then
			g_SpawnMenu.HorizontalDivider:SetLeftWidth(ScrW())
		end
	end)
end)