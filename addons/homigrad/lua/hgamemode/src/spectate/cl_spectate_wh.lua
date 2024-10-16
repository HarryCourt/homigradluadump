-- "addons\\homigrad\\lua\\hgamemode\\src\\spectate\\cl_spectate_wh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SpectateHideNick = SpectateHideNick or false

local keyOld,keyOld2
local lply
flashlight = flashlight or nil
flashlightOn = flashlightOn or false

local gradient_d = Material("vgui/gradient-d")

function DrawWHEnt(ent,pos)
	local pos2 = pos:ToScreen()
	local x,y = pos2.x, pos2.y

	local teamColor = ent.GetPlayerColor and ent:GetPlayerColor():ToColor() or ent:GetColor()
	local distance = EyePos():Distance(pos)

	local factor = 1 - math.Clamp(distance / 1024, 0, 1)
	local size = math.max(10,32 * factor)
	local alpha = math.max(255 * factor,80)

	local text = ent.Name and ent:Name() or ent.PrintName
	surface.SetFont("Trebuchet18")
	local tw, th = surface.GetTextSize(text)

	surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha * 0.5)
	surface.SetMaterial(gradient_d)
	surface.DrawTexturedRect(x - size / 2 - tw / 2, y - th / 2, size + tw, th)

	surface.SetTextColor(255, 255, 255, alpha)
	surface.SetTextPos(x - tw / 2, y - th / 2)
	surface.DrawText(text)

	local barWidth = math.Clamp((ent:Health() / ent:GetMaxHealth()) * (size + tw), 0,size + tw)
	local healthcolor = ent:Health() / ent:GetMaxHealth() * 255

	surface.SetDrawColor(255, healthcolor, healthcolor, alpha)
	surface.DrawRect(x - barWidth / 2, y + th / 1.5, barWidth, ScreenScale(1))
end

local hg_show_hudspectate

cvars.CreateOption("hg_show_hudspectate","1",function(value) hg_show_hudspectate = tonumber(value or 0) > 0 end)

hook.Add("HUDPaint","spectate",function()
	local lply = LocalPlayer()

	local w,h = ScrW(),ScrH()

	local spec = SpecEnt

	if lply:Alive() then
		if IsValid(flashlight) then
			flashlight:Remove()
			flashlight = nil
		end
	end
	
	WH = (not lply:Alive() or lply:Team() == 1002 or (not lply:Alive() and spec))
	WH = WH or (lply:GetMoveType() == MOVETYPE_NOCLIP and not lply:InVehicle())
	WH = WH or result
	WH = WH or lply:PlayerClassEvent("CanUseSpectateHUD") or (TableRound().CanUseSpectateHUD and TableRound().CanUseSpectateHUD())

	if WH then
		local func = TableRound().DisableSpectate
		if not lply:Alive() and func and func(lply) == true then return end

		local ent = spec

		if hg_show_hudspectate and not lply:Alive() and IsValid(ent) then
			surface.SetFont("H.25")

			local text = ent.GetName and ent:GetName() or ent.PrintName
			local tw,th = surface.GetTextSize(text)

			local x,y = w / 2,h - 80

			local vec = ent.GetPlayerColor and ent:GetPlayerColor() or ent:GetColor():ToVector()

			surface.SetDrawColor(vec[1] * 255,vec[2] * 255,vec[3] * 255,25)

			tw = tw * 1.5 + math.sin(CurTime() * 2.5) * 15

			draw.GradientLeft(x,y - th / 2,tw / 2,th)
			draw.GradientRight(x - math.floor(tw / 2),y - th / 2,tw / 2,th)

			draw.SimpleText(text,"H.25",x,y,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
			draw.SimpleText(L("spectate_health",ent:Health()),"H.12",w / 2,y + 25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
			local spectates = ent:GetNWInt("Spectates",0) - 1

			if spectates > 0 then
				draw.SimpleText(L("spectate_waths",spectates),"H.12",w/ 2,y + 25 + 15,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end

			local func = TableRound().HUDPaint_Spectate
			if func then func(ent) end
		end

		local key = lply:KeyDown(IN_WALK)
		if keyOld ~= key and key then
			SpectateHideNick = not SpectateHideNick

			chat.AddText("Ники игроков: " .. tostring(not SpectateHideNick))
		end
		keyOld = key

		--draw.SimpleText("Отключение / Включение отображение ников на ALT","H.18",15,ScrH() - 15,showRoundInfoColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)

		local key = input.IsButtonDown(KEY_F)
		if not lply:Alive() and keyOld2 ~= key and key then
			flashlightOn = not flashlightOn

			if flashlightOn then
				if not IsValid(flashlight) then
					flashlight = ProjectedTexture()
					flashlight:SetTexture("effects/flashlight001")
					flashlight:SetFarZ(900)
					flashlight:SetFOV(150)
					flashlight:SetBrightness(0.35)
					flashlight:SetEnableShadows( false )
				end
			else
				if IsValid(flashlight) then
					flashlight:Remove()
					flashlight = nil
				end
			end
		end
		keyOld2 = key

		if flashlight then
			flashlight:SetPos(EyePos())
			flashlight:SetAngles(EyeAngles())
			flashlight:Update()
		end

		if not SpectateHideNick then
			local func = TableRound().HUDPaint_ESP
			if func then func() end

			for _, v in ipairs(player.GetAll()) do --ESP
				if not v:Alive() or v == ent then continue end

				DrawWHEnt(v,v:GetEntity():GetPos())
			end
		end
	end
end)