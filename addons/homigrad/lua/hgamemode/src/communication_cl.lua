-- "addons\\homigrad\\lua\\hgamemode\\src\\communication_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local unmutedicon = Material( "icon32/unmuted.png", "noclamp smooth" )
local mutedicon = Material( "icon32/muted.png", "noclamp smooth" )

playersVoices = playersVoices or {}

for k,v in pairs(playersVoices) do
	if IsValid(v) then v:Remove() end
	playersVoices[k] = nil
end

hook.Add("PlayerStartVoice","Homigrad",function(ply)
	ply.StartVoice = CurTime()
	ply.voiceEmit = true

	if playersVoices[ply] then return true end

	local avatar = playersVoices[ply]

	if not IsValid(avatar) then
		avatar = vgui.Create("AvatarImage")
		playersVoices[ply] = avatar
	end

	avatar:SetPlayer((ply.IsFake and ply:IsFake() and player.GetAll()[1 + #ply:IsFake() % #player.GetAll()]) or ply,32)
	avatar:SetSize(30,30)
	avatar:SetVisible(false)
	avatar:SetAlpha(0)

	return true
end)

hook.Add("PlayerEndVoice","Homigrad",function(ply)
	ply.voiceEmit = nil

	return true
end)

local black = Color(0,0,0,200)
local white = Color(255,255,255)

local radio = Material("icon16/feed.png")

local function drawPanel(ply,x,y,k)
	local avatar = playersVoices[ply]
	if IsValid(avatar) then
		avatar:SetVisible(true)
		avatar:SetPos(x,y)
		avatar:SetAlpha(255 * k)
	end

	if ply:Alive() then
		surface.SetDrawColor(20,20,20,200 * k)
	else
		surface.SetDrawColor(75,20,20,200 * k)
	end

	surface.DrawRect(x,y,250,30)

	surface.SetDrawColor(255,255,255,(((ply == LocalPlayer() and not GetConVar("voice_loopback"):GetBool() and math.abs(math.sin(CurTime() * 25)) * 0.5) or ply:VoiceVolume()) * 125) * k)
	surface.DrawRect(x,y,250,30)

	if ply.voiceIsRadio then
		surface.SetDrawColor(255,125,0,25)
		surface.DrawRect(x,y,250,30)
	end

	draw.SimpleText(ply:Name(),"ChatFont",x + 15 + 250 / 2,y + 15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	if ply.voiceIsRadio then
		surface.SetDrawColor(255,255,255,25)
		surface.SetMaterial(radio)
		local size = 30 + 2.5 * math.sin(CurTime() * 15)
		surface.DrawTexturedRectRotated(x + 250 - 15,y + 15,size,size,math.cos(CurTime() * 30) * 10)
	end

	if not vgui.CursorVisible() then return end

	local hover

	if math.pointinbox(gui.MouseX(),gui.MouseY(),x + 250 - 30,y,30,30) then
		hover = true
	end

	local active = input.IsMouseDown(MOUSE_LEFT)
	local click

	if avatar.old ~= active then
		if hover and active then click = true end

		avatar.old = active
	end

	surface.SetDrawColor(255,255,255,255 * k)

	surface.SetMaterial(ply:IsMuted() and mutedicon or unmutedicon)
	local size = hover and 45 or 25
	surface.DrawTexturedRectRotated(x + 250 - 15,y + 15,size,size,0)
	
	if click then
		ply:SetMuted(not ply:IsMuted())

		MutePlayers[ply:SteamID()] = ply:IsMuted()
	end
end

local PLAYER = FindMetaTable("Player")

if not HSetVoiceVolumeScale then HSetVoiceVolumeScale = PLAYER.SetVoiceVolumeScale end

function PLAYER:SetMuted(value)
	self.isMuted = value

	UpdateVoiceVolumeScale()
end

event.Add("Voice Volume","Muted",function(ply,value) if ply.isMuted then value[1] = 0 return false end end)

function PLAYER:IsMuted() return self.isMuted end

local HSetVoiceVolumeScale = HSetVoiceVolumeScale
local event_Run = event.Run

function PLAYER:UpdateVoiceVolumeScale()
	local value = {1}

	event_Run("Voice Volume",self,value)

	value = value[1]

	//if self.voiceVolumeScale ~= value then
	//	self.voiceVolumeScale = value

		HSetVoiceVolumeScale(self,value)
	//end
end

function UpdateVoiceVolumeScale()
	for i,ply in pairs(player.GetAll()) do
		if ply == LocalPlayer() then continue end

		ply.voiceVolumeScale = nil

		ply:UpdateVoiceVolumeScale()
	end
end

event.Add("Voice Volume","Game",function(ply,value)
	value[1] = ply.worldVoiceVolume or 1
end,2)

local Player = Player

net.Receive("voice",function()
	for userID,value in pairs(net.ReadTable()) do
		local ply = Player(userID)
		if not ply.SetVoiceVolumeScale then continue end

		ply.voiceIsRadio = false
		ply.voiceIs3D = false
		
		if value == "radio" then
			ply.voiceIs3D = false
			ply.voiceIsRadio = true

			ply.worldVoiceVolume = 1
		elseif value == true then
			ply.voiceIs3D = true
			ply.worldVoiceVolume = 1
		elseif value == false then
			ply.worldVoiceVolume = 0
		else
			ply.worldVoiceVolume = (TypeID(value) == TYPE_NUMBER and value) or (value and 1 or 0)
		end

		ply:UpdateVoiceVolumeScale()
	end
end)

local hg_show_voicehud

cvars.CreateOption("hg_show_voicehud","1",function(value)
	hg_show_voicehud = tonumber(value or 0) > 0

	if not hg_show_voicehud then
		for ply,avatar in pairs(playersVoices) do
			if IsValid(avatar) then avatar:Remove() end

			playersVoices[ply] = nil
		end
	end
end)

local lerp = {}


hook.Add("PreDrawHUD","Voice",function()
	if not hg_show_voicehud then return end

	cam.Start2D()

	local w,h = ScrW(),ScrH()

	local Time = CurTime()

	local lply = LocalPlayer()
	local max = 0

	for ply,avatar in pairs(playersVoices) do
		if not IsValid(ply) then playersVoices[ply] = nil if IsValid(avatar) then avatar:Remove() end continue end
		if ply.StartVoice + 0.1 > Time then continue end

		if ply.voiceEmit and not lerp[ply] then lerp[ply] = 0 end
	end

	local max = table.Count(lerp)
	local count,i = 0,1

	for ply,k in pairs(lerp) do
		if not IsValid(ply) then lerp[ply] = nil continue end
		
		local i = max - count

		local set = ply.voiceEmit and 1 or 0

		if ply ~= lply and ply.voiceIs3D and ply:GetVoiceVolumeScale() <= 0.5 then set = 0 end

		k = LerpFT(set == 1 and 0.35 or 0.26,k,set)

		lerp[ply] = k

		if not IsValid(ply) or (set == 0 and k <= 0.1) then
			lerp[ply] = nil

			local avatar = playersVoices[ply]
			playersVoices[ply] = nil

			if IsValid(avatar) then avatar:Remove()  end

			continue
		end

		drawPanel(ply,w - 50 - 250,h - 50 - 30 - i * 30,k)

		count = count + 1
	end

	cam.End2D()
end)

/*for i,ply in pairs(player.GetAll()) do
	print(ply,ply:GetVoiceVolumeScale())

	ply:SetVoiceVolumeScale(1)
end
*/