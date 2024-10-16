-- "addons\\homigrad\\lua\\hgamemode\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("HUDShouldDraw","HideHUD_ammo",function(name)
	if name == "CHudAmmo" then return false end
end)

hook.Add("DrawDeathNotice","no",function() return false end)
hook.Add("HUDDrawTargetID","no",function() return false end)

concommand.Add("hg_getentity",function()
	local ent = LocalPlayer():GetEyeTrace().Entity
	print(ent)
	if not IsValid(ent) then return end
	print(ent:GetModel())
	print(ent:GetClass())
end)

hook.Add("InitPostEntity","Max Decals",function() RunConsoleCommand("r_decals","4096") end)

local w = Color(255,255,255,125)

hook.Add("HUDPaint","Version",function()
	w.a = 255 * ScoreboardClose

	draw.SimpleText("homigrad.com v.4.8.8","ChatFont",0,ScrH(),w,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
	draw.SimpleText(LocalPlayer():SteamID(),"ChatFont",ScrW(),ScrH(),w,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
end,2)

event.Add("Player Spawn","HullSize",function(ply)
	local hullmin,hull,hullduck = Vector(-DEFAULT_HULLSIZE,-DEFAULT_HULLSIZE,0),Vector(DEFAULT_HULLSIZE,DEFAULT_HULLSIZE,DEFAULT_VIEW_OFFSET[3]),Vector(DEFAULT_HULLSIZE,DEFAULT_HULLSIZE,DEFAULT_VIEW_OFFSET_DUCKED[3])
	
	ply:SetHull(hullmin,hull)
	ply:SetHullDuck(hullmin,hullduck)

	ply:SetViewOffset(DEFAULT_VIEW_OFFSET)
	ply:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)
end)