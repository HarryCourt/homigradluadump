-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\tier_0\\player\\init_protocol_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function Init(ply)
    ply.init = true

    event.Call("Player Create",ply)
end

net.Receive("ply spawn",function()
    if not InitNET then return end
    
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end--doesnt

    if not ply.init then Init(ply) end

    event.Call("Player Spawn",ply)

    if ply == LocalPlayer() then
        event.Call("LocalPlayer Spawn",ply)
    end
end)

hook.Add("InitPostEntity","Player Spawn",function()//1
    timer.Simple(0.001,function()
        net.Start("homigrad init")
        net.SendToServer()
    end)
end)

net.Receive("homigrad init",function()
    if InitNET == nil then//2
        InitNET = false
        
        event.Call("Send Data")//отсылаем данные

        net.Start("homigrad init")
        net.SendToServer()
    elseif InitNET == false then//3
        InitNET = true//теперь можно играть, лутче сделать чтоб никакой информации не приходило бы до этого (всякие звуки, кровь и т.п (emit event))

        for i,ply in pairs(player.GetAll()) do
            if not ply.init then Init(ply) end

            event.Call("Player Spawn",ply)
        end

        event.Call("Init NET")

        net.Start("homigrad init")
        net.SendToServer()
    end
end)

hook.Add("RenderScene","!NET Protocol",function()
    if InitNET then return end

    local w,h = ScrW(),ScrH()
    
	cam.Start2D()
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,w,h)

        draw.SimpleText("LOADING","H.45",w / 2,h / 2,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	cam.End2D()

    return true
end,-2)