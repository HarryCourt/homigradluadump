-- "addons\\optimization\\lua\\autorun\\widgets_disabler_cpu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "PreGamemodeLoaded", "widgets_disabler_cpu", function()
	function widgets.PlayerTick()
		-- empty
	end

	if timer.Exists("HostnameThink") then timer.Remove("HostnameThink") end
	if timer.Exists("CheckHookTimes") then timer.Remove("CheckHookTimes") end

	hook.Remove( "PlayerTick", "TickWidgets" )

	if SERVER then
		hook.Add("MouthMoveAnimation", "Optimization", function() return nil end)
		hook.Add("GrabEarAnimation", "Optimization", function() return nil end)
	end
end )