-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\game\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
InvOpenK = 0
InvCloseK = 1

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect

local Update

local valid = {
    ["player"] = true,
    dumping = true,
    backpack = true
}

InvTime = 0.25

InvMoveQueueDelay = 0
InvMoveQueue = {}
local queueMove = InvMoveQueue

function InvMoveQueueAdd(tbl)
    if InvMoveQueueDelay < CurTime() then InvMoveQueueDelay = CurTime() + InvTime end
    queueMove[#queueMove + 1] = tbl
end

function InvPlaySndDecay(table,name1,name2,default,pitch,volume)
    InvPlaySnd(table,name1,name2,default,pitch,volume)

    if 1 + volume <= 0 then return end

    timer.Simple(math.Rand(0.05,0.1) * math.Rand(0.8,1.25),function()
        InvPlaySndDecay(table,name1,name2,default,pitch - 1,volume - 0.15)
    end)
end

local white = Color(255,255,255)

local function Create(inv,anchor)
    local panel = InvCreate_Panel(inv)

    function panel:InputLSHIFT(butt)
        if not IsValid(InvPanelOther) then return end

        butt.waitQueue = true

        InvPlaySndDecay(butt:GetItemTable(),"InvMoveSnd","InvMoveSnd",InvMoveSnd,-20,-0.3)
        InvMoveQueueAdd({butt,"hg_inv_move",self.inv.id,InvPanelOther.inv.id,butt.slotX,butt.slotY})
    end

    if not anchor then return panel end

    return panel
end

hook.Add("Inv Create","Main",function(inv,class,type)
    if inv.parent ~= LocalPlayer() then return end

    local panel

    if class == "player" then
        panel = Create(inv,true)
        
        if IsValid(InvPanelPlayer) then InvPanelPlayer:Remove() end--MDAM
        InvPanelPlayer = panel
        
        function panel:Update()
            local success = CHATOPEN or INVOPEN or self.anchor or (IsValid(InvPanelOther) and not InvPanelOther.closed)

            if not LocalPlayer():Alive() then success = false end
        
            InvOpenK = LerpFT(0.26,InvOpenK,success and 1 or 0) * InvCloseK
        
            local dump = InvPanelDumping

            self:SetPos(scrw / 2 - self:W() / 2 - 8,scrh + 64 - (self:H() + 64) * InvOpenK)
        end
    elseif class == "dumping" then
        panel = Create(inv)
        panel.k = 0
        
        function panel:Update()
            self.k = LerpFT(0.26,self.k,not self.closed and 1 or 0)
            if self.closed and self.k <= 0.1 then self:Remove() end
            
            local x,y = scrw / 2 + InvPanelPlayer:W() / 2 - 16 + 64,scrh + 64 - (self:H() + 64) * self.k * InvOpenK

            local panel = InvPanelBackpack
            
            if IsValid(panel) then
                local d = math.max(x + self:W() + 4 - panel.x,0)

                self:SetPos(x - d,y)
            else
                self:SetPos(x,y)
            end
        end
    elseif class == "backpack" then
        panel = Create(inv)
        panel.k = 0

        function panel:Update()
            self.k = LerpFT(0.26,self.k,not self.closed and 1 or 0)
            if self.closed and self.k <= 0.1 then self:Remove() end

            self:SetPos(scrw + 64 - (self:W() + 64) * self.k * InvOpenK,scrh - self:H())
        end

        InvPanelBackpack = panel
    end

    return panel
end)

local white = Color(255,255,255)

hook.Add("Inv Create","Other",function(inv,class,type)
    if inv.parent == LocalPlayer() then return end

    local frame = InvPanelOther
    if not IsValid(frame) then
        frame = oop.CreatePanel("v_scrollpanel")
        InvPanelOther = frame

        frame.k = 0
        frame:SetMouseInputEnabled(true)
        frame:SetKeyboardInputEnabled(true)
        frame:MakePopup()
    end

    function frame:Close()
        self.closed = true
                
        self:SetMouseInputEnabled(false)
        self:SetKeyboardInputEnabled(false)

        ScoreboardInvClose()

        for id,panel in pairs(self.canvasPanel:GetChildren()) do
            RunConsoleCommand("hg_inv_close",panel.inv.id)
        end
    end

    function frame:Think()
        self.k = LerpFT(self.k > 0.5 and 0.26 or 0.5,self.k,not self.closed and 1 or 0) * InvCloseK
        if self.closed and self.k <= 0.1 then self:Remove() end

        if self.k >= 0.95 then self.k = 1 end

        self:InvalidateLayout()
    end

    function frame:OnKeyCodePressed(key)
        if not (key == KEY_W or key == KEY_A or key == KEY_S or key == KEY_D) then return end

        self:Close()
    end

    function frame:Select(id)
        self:ad(function(self)
            local panel = self.canvasPanel:GetChildren()[id]
            if not IsValid(panel) then return end--lox
            
            local y = 0

            for i,child in pairs(self.canvasPanel:GetChildren()) do
                child.y = y
                y = y + child:H()
            end

            local w,h = self.canvasPanel:ChildrenSize()
            self:setSize(w * self.k,h)
            self:setPos(scrw / 2 - self:W() / 2,scrh / 2 - self:H() / 2)

            self.inv = panel.inv
        end)
    end

    function frame:PaintOver(w,h)
        white.a = 255 * self.k

        DisableClipping(true)
        draw.SimpleText(L(tostring(self.inv.name)),"ChatFont",w / 2,h + 25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        DisableClipping(false)
    end

    frame.Draw = function(_,w,h)
        SetDrawColor(0,0,0,125)
        DrawRect(0,0,w,h)
    end

    local panel = InvCreate_Panel(inv)
    panel:SetParent(frame)

    function panel:InputLSHIFT(butt)
        butt.waitQueue = true

        InvPlaySndDecay(butt:GetItemTable(),"InvMoveSnd","InvMoveSnd",InvMoveSnd,-20,-0.3)
        InvMoveQueueAdd({butt,"hg_inv_move_me",panel.inv.id,butt.slotX,butt.slotY})
    end

    panel.k = 0

    function panel:Update()
        self.k = LerpFT(0.26,self.k,not self.closed and 1 or 0) * InvCloseK
        if self.closed and self.k <= 0.1 then self:Remove() end

        --self:SetPos(ScrW() / 2 - self.W / 2 - 8,-self:GetTall()  - 128 + (self:GetTall() + 128 + 64) * self.k)
    end

    ScoreboardInvOpen()

    InvPanelOther:Select(1)

    return panel
end)

hook.Add("StartChat","Start",function() CHATOPEN = true end)
hook.Add("FinishChat","Start",function() CHATOPEN = nil end)

concommand.Add("hg_inv_print_cl",function() PrintTable(Inv.list) end)

local panels = Inv.panels

for id,inv in pairs(Inv.list) do
    if IsValid(panels[id]) then panels[id]:Remove() end

    panels[id] = hook.Run("Inv Create",inv,inv.class,inv.type)
end

hook.Add("Think","Inv Queue Move",function()
    local Time = CurTime()
    if InvMoveQueueDelay > Time then return end

    while true do
        local cmd = queueMove[1]
        if not cmd then break end

        table.remove(queueMove,1)

        InvMoveQueueDelay = Time + InvTime

        local butt = cmd[1]
        if IsValid(butt) then
            butt.waitQueue = nil
            butt.wait = true

            InvPlaySndDecay(butt:GetItemTable(),"InvMoveSnd","InvMoveSnd",InvMoveSnd,0,-0.2)

            RunConsoleCommand(cmd[2],cmd[3],cmd[4],cmd[5],cmd[6])
        end
        
        break
    end
end)

hook.Add("Inv Close","Inv Queue Move",function(id)
    local i = 1

    for id,panel in pairs(Inv.panels) do
        for i,child in pairs(panel:GetChildren()) do
            child.wait = nil
            child.waitQueue = nil
        end
    end
end)