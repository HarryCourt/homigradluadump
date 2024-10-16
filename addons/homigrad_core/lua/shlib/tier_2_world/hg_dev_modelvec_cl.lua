-- "addons\\homigrad_core\\lua\\shlib\\tier_2_world\\hg_dev_modelvec_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local white = Color(255,255,255)
local yellow = Color(255,255,0)

concommand.Add("hg_dev_modelvec",function(ply,cmd,args)
    if IsValid(hg_dev_modelvec) then hg_dev_modelvec:Remove() end

    hg_dev_modelvec = oop.CreatePanel("v_panel"):setDSize(1,1)
    hg_dev_modelvec:Center()
    hg_dev_modelvec:MakePopup()

    local butt = oop.CreatePanel("v_button",hg_dev_modelvec):setSize(25,25):setPos(hg_dev_modelvec:W() - 25,0)
    butt.text = "X"
    function butt:OnMouse(key,value) if value then hg_dev_modelvec:Remove() end end
    butt:SetZPos(10)

    function hg_dev_modelvec:Draw(w,h)
        surface.SetDrawColor(0,0,0)
        surface.DrawRect(0,0,w,h)
    end

    local scene = oop.CreatePanel("v_sceneworld",hg_dev_modelvec):ad(function(self,w,h) self:setSize(w - 300,h) end)

    local ent = ClientsideModel(args[1] or "models/weapons/arccw_go/v_rif_ak47.mdl")
    ent:SetupBones()
    ent.DrawAtt = true
    ent.DrawBones = true
    
    ent:DrawModel()
    
    scene:InsertInScene(ent)

    function scene:IsHover(x,y,dis)
        local mousex,mousey = self:GetMousePos()
        return math.Distance(x,y,mousex,mousey) <= dis
    end

    function scene:DrawPoint(x,y,name,hovered)
        local hovered = hovered or self:IsHover(x,y,8)

        if hovered then
            draw.SimpleText(tostring(name),"ChatFont",x,y,white,nil,TEXT_ALIGN_BOTTOM)
            
            s = 8
        else
            s = 4
        end

        draw.RoundedBox(4,x - s / 2,y - s / 2,s,s,white)

        return hovered
    end

    local hoveredEnt

    local selectBone

    function scene:DrawObject(ent)
        ent:DrawModel()
        
        local lines = {}
        local mousex,mousey = self:GetMousePos()

        cam.Start2D()
            if ent.DrawAtt then
                for i,att in pairs(ent:GetAttachments()) do
                    local att = ent:GetAttachment(att.id)

                    local pos = att.Pos:ToScreen2()

                    self:DrawPoint(pos.x,pos.y,tostring(att.name))

                    lines[#lines + 1] = {att.Pos,att.Pos + Vector(1,0,0):Rotate(att.Ang),white}
                end
            end

            if ent.DrawBones then
                for i = 0,ent:GetBoneCount() - 1 do
                    local pos,ang = ent:GetBonePosition(i)
                    if not pos then continue end

                    lines[#lines + 1] = {pos,pos + Vector(1,0,0):Rotate(ang),white}

                    local name = ent:GetBoneName(i)
                    local pos2 = pos:ToScreen2()

                    ent:ManipulateBoneScale(i,Vector(1,1,1))

                    if selectBone == i or self:DrawPoint(pos2.x,pos2.y,tostring(name)) then
                        if selectBone == i then self:DrawPoint(pos2.x,pos2.y,tostring(name),true) end

                        local t = 1 + math.abs(math.cos(CurTime() * 10)) / 10

                        ent:ManipulateBoneScale(i,Vector(t,t,t))
                    end
                end
            end

            selectBone = nil

            local pos = ent:GetPos():ToScreen2()
            local s = 4

            local color = hoveredEnt == ent and yellow or white
            
            if self:IsHover(pos.x,pos.y,8) then
                draw.SimpleText(tostring(ent),"ChatFont",pos.x,pos.y,color,nil,TEXT_ALIGN_BOTTOM)

                if input.IsButtonDown(MOUSE_LEFT) then
                    hoveredEnt = ent
                end
            end

            draw.RoundedBox(s,pos.x - s / 2,pos.y - s / 2,s,s,color)
        cam.End2D()

        for i = 1,#lines do
            local line = lines[i]

            render.DrawLine(line[1],line[2],line[3])
        end
    end

    function scene:Draw(w,h)
        surface.SetDrawColor(25,25,25)
        surface.DrawRect(0,0,w,h)

        local isControl = input.IsButtonDown(KEY_LCONTROL)

        if isControl then
            if input.IsButtonDown(KEY_D) then
                hoveredEnt = nil
            end
        end

        self:ThinkTransform()

        self:OpenScene(w,h)
        self:DrawObjects()
        self:CloseScene()
    end

    local browser = oop.CreatePanel("v_scrollpanel",hg_dev_modelvec):ad(function(self,w,h) self:setSize(300,h):setPos(w - 300,butt:H()) end)

    function browser:Draw(w,h)
        surface.SetDrawColor(20,20,20)
        surface.DrawRect(0,0,w,h)
    end
    
    local panelAnim = oop.CreatePanel("v_scrollpanel",browser):ad(function(self,w,h) self:setSize(browser:W(),browser:H() / 2):setPos(0,0) end)

    function panelAnim:Draw(w,h)
        surface.SetDrawColor(10,10,10)
        surface.DrawRect(0,0,w,h)
    end

    function panelAnim:Update()
        self:Clear()

		local count = ent:GetSequenceCount() - 1

		for id = 1,count do
			local info = ent:GetSequenceInfo(id)

			local butt = oop.CreatePanel("v_button",self):ad(function(self,w,h) self:setSize(browser:W(),20):setPos(0,(id - 1) * self:H()) end)

            function butt:OnClick()
                PrintTable(ent:GetSequenceInfo(id))
                ent:SetSequence(id)
            end

            function butt:DrawText(w,h)
                draw.SimpleText(info.label,"H.12",w / 2,h / 2,self.textColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                draw.SimpleText(id,"H.12",16,h / 2,self.textColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
		end
    end

    panelAnim:Update()
    
    local panel = oop.CreatePanel("v_scrollpanel",browser):ad(function(self,w,h) self:setSize(browser:W(),browser:H() / 2):setPos(0,self:H()) end)

    function panel:Draw(w,h)
        surface.SetDrawColor(10,10,10)
        surface.DrawRect(0,0,w,h)
    end

    ent:SetupBones()

    function panel:Update()
        self:Clear()

		for id = 0,ent:GetBoneCount() - 1 do
			local butt = oop.CreatePanel("v_button",self):ad(function(self,w,h) self:setSize(browser:W(),20):setPos(0,(id - 1) * self:H()) end)

            function butt:OnClick()
                local name = ent:GetBoneName(id)
                
                print(name)
                SetClipboardText(name)
            end

            function butt:DrawText(w,h)
                if self:IsHovered() then selectBone = id end

                draw.SimpleText(ent:GetBoneName(id),"H.12",w / 2,h / 2,self.textColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                draw.SimpleText(id,"H.12",16,h / 2,self.textColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
		end
    end

    panel:Update()
end)

concommand.Add("hg_dev_getbones_wep",function(ply)
    local wep = ply:GetActiveWeapon()
    local wep = wep.GetGun and wep:GetGun() or wep

    for i = 0,wep:GetBoneCount() - 1 do
        print(i,wep:GetBoneName(i))
    end
end)