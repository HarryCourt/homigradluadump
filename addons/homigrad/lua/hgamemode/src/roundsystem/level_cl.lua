-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\level_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function err(err) ErrorNoHaltWithStack(err) end

cvars.CreateOption("hg_sound_round","1")

net.Receive("round_state",function()
	roundActive = net.ReadBool()
	local data = net.ReadTable()
	local dataEnd = net.ReadTable()
	local noemit = net.ReadBool()

	local func = TableRound().InputData
	if func then func(data) end
	
	if roundActive == true then
        RoundData = data

		if noemit then return end

		if not system.HasFocus() then system.FlashWindow() end

		local func = TableRound().StartRound
		if func then xpcall(func,err,data) end
	else
        RoundDataEnd = dataEnd

		if noemit then return end
		
		local func = TableRound().EndRound
		if func then func(data.lastWinner,data) end
	end
end)

net.Receive("round_time",function()
	roundTimeStart = net.ReadFloat()
	roundTime = net.ReadFloat()
end)

showRoundInfo = RealTime() + 3
roundActiveName = roundActiveName or "tdm"
roundActiveNameNext = roundActiveNameNext or "tdm"

net.Receive("round",function()
	roundActiveName = net.ReadString()
	showRoundInfo = RealTime() + 10

	system.FlashWindow()

	chat.AddText(L("chat_level_active",L(roundActiveName)))
end)


net.Receive("loadscreen",function()
	roundScreenName = net.ReadString()
	roundScreenName2 = net.ReadString()

	roundStart = true
end)

net.Receive("loadscreen_end",function()
	roundStart = false
end)

local white = Color(255,255,255)

hook.Add("PostDrawHUD","Start Round",function()
	if not roundStart then return end

	local w,h = ScrW(),ScrH()
	surface.SetDrawColor(0,0,0,225)
	surface.DrawRect(0,0,w,h)

	draw.SimpleText(L(roundScreenName,L(roundScreenName2)),"H.45",w / 2,h / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end)

net.Receive("round_next",function()
	roundActiveNameNext = net.ReadString()
	showRoundInfo = RealTime() + 10

	chat.AddText(L("chat_level_next",L(roundActiveNameNext)))
end)

local white = Color(255,255,255)
showRoundInfoColor = Color(255,255,255)
local yellow = Color(255,255,0)


hook.Add("HUDPaint","homigrad-roundstate",function()
	if roundActive then
		local func = TableRound().HUDPaint

		if func then
			func(showRoundInfoColor)
		else
			local time = math.Round(roundTime - CurTime())
			local acurcetime = string.FormattedTime(time,"%02i:%02i")
			if time < 0 then acurcetime = "акедумадекосай;3" end

			draw.SimpleText(acurcetime,"H.18",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	else
		draw.SimpleText(L("round_end"),"H.18",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	local k = showRoundInfo - RealTime()

	k = math.max(k,0)

	showRoundInfoColor.a = k * 255
	yellow.a = showRoundInfoColor.a

	local name,nextName = TableRound().Name,TableRound(roundActiveName).Name
	draw.SimpleText(L("hud_level_active",L(roundActiveName)),"H.18",ScrW() - 15,15,showRoundInfoColor,TEXT_ALIGN_RIGHT)
	draw.SimpleText(L("hud_level_next",L(roundActiveNameNext)),"H.18",ScrW() - 15,35,name ~= nextName and yellow or showRoundInfoColor,TEXT_ALIGN_RIGHT)

	local err = GetGlobalString("Game Error") or ""
	if err == "" then return end

	if err == "Game Stop" and LocalPlayer():Alive() then return end

	draw.SimpleText(err,"H.18",ScrW() / 2,35,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end)