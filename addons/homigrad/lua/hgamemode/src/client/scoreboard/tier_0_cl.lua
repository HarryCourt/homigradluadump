-- "addons\\homigrad\\lua\\hgamemode\\src\\client\\scoreboard\\tier_0_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ScoreboardPages = ScoreboardPages or {}
ScoreboardPage = ScoreboardPage or 1

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

ScoreboardButtons = ScoreboardButtons or {}

local Update

local lerpY = 0

ScoreboardClose = 0

function OpenTab()
    RemoveTab()
    
    ScoreboardStatus = true
    gui.EnableScreenClicker(true)

    local frame = oop.CreatePanel("v_frame"):setDSize(1,1)
    frame:SetMouseInputEnabled(true)
    frame:SetZPos(-5)
    
    ScoreboardFrame = frame
    ScoreboardClose = 0
    ScoreboardButtons = {}
    
    local scrollPanel = oop.CreatePanel("v_panel",frame):setDSize(1,1)
    scrollPanel.lerpY = 0
    frame.scrollPanel = scrollPanel

    local panelButtons = oop.CreatePanel("v_panel",frame)
    ScoreboardPanelButtons = panelButtons
    panelButtons.Paint = nil

    function frame:UpdateButtons()
        for i,butt in pairs(ScoreboardButtons) do
            if IsValid(butt) then butt:Remove() end

            ScoreboardButtons[i] = nil
        end
        
        for i,page in pairs(ScoreboardPages) do
            if page.CanOpen and not page.CanOpen() then continue end

            local button = oop.CreatePanel("v_button",panelButtons)
            button.text = L(page.Name)
            button.i = #ScoreboardButtons
            button:ad(function(self) self:setSize(64 * ScreenSize,64 * ScreenSize):setPos(0,self.i * self:H()) end)
            
            function button:OnMouse(key,value)
                if not value then return end

                frame:SelectPage(i)
            end

            ScoreboardButtons[#ScoreboardButtons + 1] = button
            button.page = i
            page.number = #ScoreboardButtons
            
            local panelPage = oop.CreatePanel("v_panel",scrollPanel):ad(function(self) self:setSize(frame:W(),frame:H()):setPos(0,self:H() * button.i) end)

            page.Open(panelPage)
        end

        self:SelectPage(ScoreboardPage)
    end

    panelButtons:ad(function(self) self:setSize(self:ChildrenSize()):setPos(frame:W() - self:W(),frame:H() / 2 - self:H() / 2) end)

    function panelButtons:PaintOver(w,h)
        DisableClipping(true)
        
        SetDrawColor(255,255,255,25)
    
        local h = 64 * ScreenSize
        local corner = 2
    
        lerpY = math.Round(LerpFT(0.5,lerpY,-h * (1 - ScoreboardPages[ScoreboardPage].number)) * 10) / 10
    
        local x,y = -2 - corner,lerpY
        DrawRect(x,y,corner,h)
        
        SetDrawColor(75,75,75,15)
        draw.GradientRight(0,y,h,h)

        DisableClipping(false)
    end

    local old

    function frame:SelectPage(i)
        ScoreboardPage = i

        local page = ScoreboardPages[ScoreboardPage]
        
        if not page.CanOpen or page.CanOpen() then

        else
            ScoreboardPage = 1
        end

        if old ~= ScoreboardPage then
            local page = ScoreboardPages[old or 0]
            if page and page.Hovered then page.Hovered(false) end
            
            old = ScoreboardPage

            page = ScoreboardPages[ScoreboardPage]
            if page.Hovered then page.Hovered(true) end
        end
    end

    frame:UpdateButtons()
    scrollPanel:ad(function(self) self:setSize(frame:W(),frame:H() * #ScoreboardButtons) end)
    scrollPanel.lerpY = -frame:H() * (ScoreboardPages[ScoreboardPage].number - 1)
    frame:SelectPage(ScoreboardPage)

    if VRMODSELFENABLED then VRUIPopup(panelButtons) end
    if VRMODSELFENABLED then VRUIPopup(frame) end

    Update()
end

function RemoveTab()
    gui.EnableScreenClicker(false)
    ScoreboardStatus = nil

    local page = ScoreboardPages[ScoreboardPage]
    if page.Hovered then page.Hovered(false,true) end

    if IsValid(ScoreboardPanelButtons) then ScoreboardPanelButtons:Remove() end
    if IsValid(ScoreboardFrame) then ScoreboardFrame:Remove() end
end

function CloseTab()
    ScoreboardStatus = false

    gui.EnableScreenClicker(false)
end

Update = function()
    if not IsValid(ScoreboardPanelButtons) or ScoreboardStatus == nil then ScoreboardStatus = nil return end

    ScoreboardClose = LerpFT(0.5,ScoreboardClose,ScoreboardStatus == false and 0 or 1)
    
    if ScoreboardClose >= 0.95 then
        ScoreboardClose = 1
    elseif ScoreboardClose <= 0.05 then
        ScoreboardClose = 0
    end

    local scrw,scrh = VGUIScreenSize()
    
    local panelButtons = ScoreboardPanelButtons
    panelButtons.x = scrw - panelButtons:W() + panelButtons:W() * 2 * (1 - ScoreboardClose)

    local scrollPanel = ScoreboardFrame.scrollPanel
    
    scrollPanel:SetX(-scrw * 2 * (1 - ScoreboardClose))

    if ScoreboardPages[ScoreboardPage].number then
        scrollPanel.lerpY = LerpFT(0.5,scrollPanel.lerpY,-scrh * (ScoreboardPages[ScoreboardPage].number - 1))
        scrollPanel.y = scrollPanel.lerpY
    end

    if ScoreboardStatus == false then
        if ScoreboardClose == 0 then RemoveTab() end
    end

    if not IsValid(vgui.GetKeyboardFocus()) then
        for i = 1,5 do
            if input.IsButtonDown(_G["KEY_" .. i]) then if ScoreboardButtons[i] then ScoreboardFrame:SelectPage(ScoreboardButtons[i].page) end end
        end
    end
end

hook.Add("Think","Scoreboard",Update)

hook.Add("ScoreboardShow","HomigradOpenScoreboard",function()
    if ScoreboardStatus == true then
        CloseTab()
    elseif ScoreboardStatus == nil then
	    OpenTab()
    end

	return false
end)

hook.Add("ScoreboardHide","HomigradHideScoreboard",function()
    return false
end)

//if Initialize then OpenTab() end

local white = Color(255,255,255)

local graph = {}

hook.Add("HUDPaint","Scoreboard",function()
    SetDrawColor(0,0,0,200 * ScoreboardClose)
    DrawRect(0,0,scrw,scrh)

    white.a = 25 * ScoreboardClose

    draw.SimpleText("HOMIGRAD.COM","H.45",scrw / 2,scrh / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    if ScoreboardClose > 0 then
        showRoundInfo = RealTime() + 2.5
    end

    /*local sft = engine.ServerFrameTime()
    
    local tick = math.Round(1 / sft)
  
    local w = 512

    graph[#graph + 1] = tick

    if #graph > w then
        table.remove(graph,1)
    end

    surface.SetDrawColor(0,255,0)

    for i = 1,#graph do
        surface.DrawRect(i,scrh - graph[i],1,graph[i])
    end*/
end)
