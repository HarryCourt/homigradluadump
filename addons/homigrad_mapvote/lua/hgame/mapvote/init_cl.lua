-- "addons\\homigrad_mapvote\\lua\\hgame\\mapvote\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
net.Receive("rtv",function()
    if net.ReadBool() then
        MapsForVote = net.ReadTable()
        APIHTTPRTV = net.ReadString()

        RTVOpenMenu(MapsForVote)
    else
        if IsValid(RTVFrame) then RTVFrame:Remove() end
    end
end)

net.Receive("rtv vote result",function()
    VoteResult = net.ReadTable()
    
    VoteCount = math.max(#VoteResult,#player.GetAll())
    VoteExtend = 0
    VoteRandom = 0
    VoteMap = {}

    for steamid,vote in pairs(VoteResult) do
        if vote == "extend" then
            VoteExtend = VoteExtend + 1
        elseif vote == "random" then
            VoteRandom = VoteRandom + 1
        else
            VoteMap[vote] = (VoteMap[vote] or 0) + 1
        end
    end
end)//я чо долбаёб чтоб хуйню всякую делать

local max = math.max

local developer = GetConVar("developer")

function RTVOpenMenu()
    local steamid = LocalPlayer():SteamID()

    if IsValid(RTVFrame) then RTVFrame:Remove() end

    RTVFrame = oop.CreatePanel("v_frame"):setDSize(1,1)

    local start = RealTime() + 0
    local k = 0

    function RTVFrame:Paint(w,h)
        k = (1 - max(start - RealTime(),0))

        surface.SetDrawColor(0,0,0,225 * k)
        surface.DrawRect(0,0,w,h)

        draw.GradientUp(0,0,w,h * 0.25)
        
        surface.SetDrawColor(0,0,0,25 * k)

        draw.GradientDown(0,h - h * 0.25,w,h * 0.25)

        draw.SimpleText("Выбераем следущею карту","HS.45",w * 0.5,h * 0.25 / 3,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    RTVFrame:MakePopup()
    RTVFrame:SetKeyboardInputEnabled(false)

    local listMaps = oop.CreatePanel("v_scrollpanel",RTVFrame):ad(function(self,w,h)
        self:setW(w - 600 - 128):setPos(w / 2 - self:W() / 2,h * 0.25 / 2 + 64):setH(h - self.y - 128)
    end)

    listMaps.scrolling = 128
    listMaps.scrollLerp = 0.5

    function listMaps:Paint(w,h)
        surface.SetDrawColor(0,0,0,225)
        surface.DrawRect(0,0,w,h)
    end

    function listMaps:PaintOver(w,h) self:DrawScoreBar() end

    local white2 = Color(255,255,255,128 )
    local abs = math.abs

    function RTVFrame:Update()
        listMaps:Clear()

        local iterations = 0

        for map,info in pairs(MapsForVote) do
            iterations = iterations + 1
            local iterations = iterations

            local workshopID,title = info[1],info[2]
            local previewImage,screenshoots,desc
            screenshoots = {}

            local select = oop.CreatePanel("v_button",listMaps):ad(function(self,w,h) self:setSize(listMaps:W(),128):setPos(0,(iterations - 1) * self:H()) end)
            
            local hover = 0
            
            local aviable = {}
            local first,firstK
            local second,secondK

            local needChange = 0
            local start,delayChange = 0,0.5
            local mode

            function select:Step()
                if #screenshoots > 1 then
                    if #aviable == 0 then
                        for k,v in pairs(screenshoots) do aviable[k] = v end
                    end

                    if needChange < RealTime() then
                        start = RealTime() + delayChange
                        needChange = start + 2

                        local screenshoot,key = table.Random(aviable)
                        if key then aviable[key] = nil end

                        mode = not mode

                        if not first then
                            first = screenshoot

                            local screenshoot,key = table.Random(aviable)
                            if key then aviable[key] = nil end

                            second = screenshoot or first
                        else
                            if mode then
                                first = screenshoot
                            else
                                second = screenshoot
                            end
                        end
                    end
                end
            end

            function select:Paint(w,h)
                if #screenshoots > 1 then
                    local k = max(start - RealTime(),0) / delayChange

                    surface.SetDrawColor(255,255,255,255 * (not mode and k or (1 - k)))

                    local mat = GetHTTPMaterial(first)
                    if mat then
                        local matH = mat:Height() * (w / mat:Width())

                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(0,(-matH + h) * 0.5,w,matH,first)
                    end

                    surface.SetDrawColor(255,255,255,255 * (mode and k or (1 - k)))

                    local mat = GetHTTPMaterial(second)
                    if mat then
                        local matH = mat:Height() * (w / mat:Width())

                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(0,(-matH + h) * 0.5,w,matH)
                    end
                else
                    local mat = GetHTTPMaterial((#screenshoots == 1 and screenshoots[1]) or previewImage)

                    if mat then
                        local matH = mat:Height() * (w / mat:Width())

                        surface.SetDrawColor(125,125,125,255)
                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(0,(-matH + h) * 0.5,w,matH)

                        surface.SetDrawColor(15,15,15,125)
                        surface.SetBG("lines_dense_d_r")
                        draw.BG2(0,0,w,h)
                    end
                end

                hover = LerpFTLess(0.5,hover,self:IsDown() and -1 or (self:IsHovered() and 1) or 0,0.001)
                
                if hover > 0 then
                    surface.SetDrawColor(125,125,125,75 * hover)
                    draw.GradientLeft(0,0,w * hover,h)
                elseif hover < 0 then
                    surface.SetDrawColor(15,15,15,255 * abs(hover))
                    draw.GradientLeft(0,0,w * abs(hover),h)
                end

                surface.SetDrawColor(255,255,255,255)
                
                DrawHTTPMaterial(0,0,h,h,previewImage)
                draw.Frame(0,0,h,h,cframe1,cframe2)

                draw.SimpleText(title,"HS.25",128 + 16,31,nil,nil,TEXT_ALIGN_CENTER)
                draw.SimpleText(map,"HS.12",128 + 16,32 + 16 + 4,white2,nil,TEXT_ALIGN_CENTER)

                local number = VoteMap[tostring(id)]
                if number then
                    draw.SimpleText(math.Round(100 * number / VoteCount) .. "%","HS.25",w - h / 3,h / 2,nil,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                end

                draw.Frame(0,0,w,h,cframe1,cframe2)
            end
            
            function select:OnClick()
                net.Start("map vote")
                net.WriteString("map")
                net.WriteString(id)
                net.SendToServer()
            end
        end
    end

    local randommap = oop.CreatePanel("v_button",RTVFrame):ad(function(self,w,h)
        self:setSize(300,50):setPos(listMaps.x,h - 80 - self:H() / 2)
    end)

    local white = Color(255,255,255,128)

    local down = 0

    function randommap:Paint(w,h)
        down = LerpFT(0.5,down,self:IsDown() and 1 or 0)

        surface.SetDrawColor(0,0,0,164 + 100 * down)
        surface.DrawRect(64,0,w - 128,h)

        draw.GradientRight(0,0,64,64)
        draw.GradientLeft(w - 64,0,64,64)

        draw.SimpleText("Random Map","HS.25",w / 2,h / 2,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        DisableClipping(true)
        if VoteResult[steamid] == "random" then
            surface.SetDrawColor(255,255,255,125)
            surface.DrawRect(0,h + 1,w,1)
        end
        draw.SimpleText(math.Round(100 * VoteRandom / VoteCount) .. "%","HS.25",w / 2,h + 32,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        DisableClipping(false)
    end

    function randommap:OnClick()
        net.Start("map vote")
        net.WriteString("random")
        net.SendToServer()
    end

    local extend = oop.CreatePanel("v_button",RTVFrame):ad(function(self,w,h)
        self:setSize(300,50):setPos(listMaps.x + listMaps:W() - self:W(),h - 80 - self:H() / 2)
    end)

    local down = 0

    function extend:Paint(w,h)
        down = LerpFT(0.5,down,self:IsDown() and 1 or 0)

        surface.SetDrawColor(0,0,0,164 + 100 * down)
        surface.DrawRect(64,0,w - 128,h)

        draw.GradientRight(0,0,64,64)
        draw.GradientLeft(w - 64,0,64,64)

        draw.SimpleText("Extend","HS.25",w / 2,h / 2,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        DisableClipping(true)
        if VoteResult[steamid] == "extend" then
            surface.SetDrawColor(255,255,255,125)
            surface.DrawRect(0,h + 1,w,1)
        end
        draw.SimpleText(math.Round(100 * VoteExtend / VoteCount) .. "%","HS.25",w / 2,h + 32,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        DisableClipping(false)
    end

    function extend:OnClick()
        net.Start("map vote")
        net.WriteString("extend")
        net.SendToServer()
    end

    RTVFrame:Update(maps)
end

//как же я хочу спать