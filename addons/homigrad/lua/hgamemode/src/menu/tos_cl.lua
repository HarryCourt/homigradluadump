-- "addons\\homigrad\\lua\\hgamemode\\src\\menu\\tos_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local newVersion = 1

concommand.Add("hg_show_termsofservice",function()
	if IsValid(frametos) then frametos:Remove() end

	frametos = oop.CreatePanel("v_frame"):setDSize(1,1)
	frametos:MakePopup()

	function frametos:Draw(w,h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,w,h)

		RunConsoleCommand("stopsound")
	end

	local html = vgui.Create("DHTML",frametos)
	html:OpenURL("https://homigrad.com/tos?removewebm")

	function html:OnFinishLoadingDocument()
		html:QueueJavascript('document.querySelectorAll("video")[0].remove()')
	end

	function html:PaintOver(w,h)
		draw.Frame(0,0,w,h,cframe1,cframe2)
	end

	frametos:ad(function(self,w,h)
		html:SetSize(w,h)
		html:SetPos(0,0)
	end)

	local yes = oop.CreatePanel("v_button",frametos):ad(function(self,w,h) self:setSize(300,50):setPos(w / 2 - 300 - 10,h - 60) end)
	yes.text = "Я соглашаюсь"
	yes.font = "HS.25"
	yes:SetZPos(5)

	function yes:OnMouse()
		RunConsoleCommand("hg_termsofservice_accept",tostring(newVersion))

		frametos:Remove()
	end

	local no = oop.CreatePanel("v_button",frametos):ad(function(self,w,h) self:setSize(300,50):setPos(w / 2 + 10,h - 60) end)
	no.text = "Я отказываюсь"
	no.font = "HS.25"
	no:SetZPos(5)

	function no:OnMouse()
		net.Start("kick tos")
		net.SendToServer()
	end
end)

//if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:215196702" then
	
//end

local version = CreateClientConVar("hg_termsofservice_accept","0")

hook.Add("InitPostEntity","TOS",function()
	if version:GetInt() ~= newVersion then
		RunConsoleCommand("hg_show_termsofservice")
	end	
end)
