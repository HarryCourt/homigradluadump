-- "addons\\homigrad\\lua\\hgamemode\\src\\afk_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
afkStart = CurTime()

local time
hook.Add("CreateMove","afk",function(moveData)
	/*local ply = LocalPlayer()
	if ply:IsAdmin() then return end

	local time = CurTime()
	
	if moveData:GetButtons() > 0 or not ply:Alive() then afkStart = time end

	if afkStart + 120 < time then
		if not ply:Alive() or ply:Team() == 1002 then return end

		net.Start("afk")
		net.SendToServer()
		RunConsoleCommand("say","афк 9999999")
	end*/
end)