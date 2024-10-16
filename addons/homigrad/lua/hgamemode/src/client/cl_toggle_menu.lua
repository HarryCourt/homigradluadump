-- "addons\\homigrad\\lua\\hgamemode\\src\\client\\cl_toggle_menu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function ToggleMenu(toggle)
    if toggle then
        local w,h = ScrW(), ScrH()
        if IsValid(wepMenu) then wepMenu:Remove() end
        local lply = LocalPlayer()
        local wep = lply:GetActiveWeapon()
        if !IsValid(wep) then return end
        wepMenu = vgui.Create("DMenu")
        wepMenu:SetPos(w/3,h/2)
        wepMenu:MakePopup()
        wepMenu:SetKeyboardInputEnabled(false)

		/*if wep:GetClass()!="weapon_hands" then
			wepMenu:AddOption("Выкинуть",function()
				LocalPlayer():ConCommand("say *drop")
			end)
		end*/
        
		plyMenu = vgui.Create("DMenu")
        plyMenu:SetPos(w/1.7,h/2)
        plyMenu:MakePopup()
        plyMenu:SetKeyboardInputEnabled(false)

		/*plyMenu:AddOption("Меню Брони",function() RunConsoleCommand("say","*inv*") end)
		plyMenu:AddOption("Меню Аксесуаров",function() LocalPlayer():ConCommand("jmod_eft_inv") end)*/

		local EZarmor = LocalPlayer().EZarmor
		if JMod.GetItemInSlot(EZarmor, "eyes") then
			plyMenu:AddOption("Взаимодействие с маской",function()
				LocalPlayer():ConCommand("jmod_ez_toggleeyes")
			end)
		end
    else
		if IsValid(wepMenu) then
        	wepMenu:Remove()
		end
		if IsValid(plyMenu) then
        	plyMenu:Remove()
		end
    end
end

local active,oldValue
hook.Add("Think","Thinkhuyhuy",function()
	active = input.IsKeyDown(KEY_C)
	if oldValue ~= active then
		oldValue = active
		
		if active then
			ToggleMenu(true)
		else
			ToggleMenu(false)
		end
	end
end)