-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\tier_0_object\\cl\\ui_slot_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = oop.Reg("v_inv_slot","v_panel")
if not PANEL then return end

local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect

local mat_load = Material("homigrad/vgui/loading.png")

hook.Add("Screen Size","Fonts Inv",function(mul)
    surface.CreateFont("InvFont",{
        font = "Arial",
        size = 12 * mul,
        weight = 0,
        outline = true,
        shadow = true,
        antialias = false,
        additive = true,
    })
end)

local black = Color(0,0,0)

local isWeaponTable = {isWeapon = true}

local empty = {}

PANEL:Event_Add("Init","Main",function(self)
    self.hovered = 0
end)

function PANEL:SetItem(spawnname,count)
    if spawnname == false then
        self.setItem = false
    else
        self.setItem = {spawnname = spawnname,count = count}
    end
end

function PANEL:GetItem()
    if self.setItem ~= nil then return self.setItem end

    local slots = self.inv
    slots = slots and slots.slots[self.slotX]
    slots = slots and slots[self.slotY]

    for item in pairs(slots or empty) do return item end
end

function PANEL:GetCount()
    if self.setItem ~= nil then return self.setItem and self.setItem.count or 0 end

    local count = 0
    local slots = self.inv
    slots = slots and slots.slots[self.slotX]
    slots = slots and slots[self.slotY]

    for first in pairs(slots or empty) do
        item = first
        count = count + 1
    end

    return count
end

function PANEL:GetItemTable(name,y)
    if not name then
        name = self:GetItem()
        name = name and name.spawnname

        if not name then return end
    end

    if y then
        local x,y = name,y
        name = nil

        for item in pairs(self.inv.slots[x][y]) do
            name = item.spawnname
        end

        if not name then return end
    end

    local tbl = scripted_ents.Get(name)
    if tbl then return tbl end

    tbl = weapons.Get(name)

    if tbl then
        tbl.isWeapon = true

        return tbl
    end

    if IsValid(name.ent) and name.ent:IsWeapon() then return isWeaponTable end

    return empty
end

function PANEL:Draw(w,h)
    SetDrawColor(25,25,25,255)
    DrawRect(0,0,w,h)

    local isDown = self:IsDown() or InvSlotGrab == self
    local isHovered = self:IsHovered()

    if isDown then
        SetDrawColor(0,0,0,125)
        DrawRect(0,0,w,h)
    elseif isHovered then
        SetDrawColor(255,255,255,5)
        DrawRect(0,0,w,h)
    end

    self.hovered = LerpFT(0.5,self.hovered,(isHovered or self.isDown or InvSlotGrab == self) and 1 or 0)

    self:DrawItem(w,h)

    --

    local k = math.max((self.shake or 0) - CurTime(),0) / 0.5

    SetDrawColor(255,0,0,k * 255)
    DrawRect(0,0,w,h)

    SetDrawColor(255,255,255,5)
    DrawRect(0,0,w,1)
    DrawRect(0,0,1,h)

    SetDrawColor(0,0,0,255)
    DrawRect(0,h - 1,w,1)
    DrawRect(w - 1,0,1,h)
end

function PANEL:DrawItem(w,h,r,g,b)
    local item = self:GetItem()
    local count = self:GetCount()
    
    if item then
        local isbroke = false

        --if item.ent == game.GetWorld() then isbroke = true end

        local tbl = self:GetItemTable(item.spawnname)
        if not tbl.invNoDrawClip and item.clip then count = item.clip end
        
        local col = InvColorTypes[tbl.itemType] or tbl.itemColor or black
        SetDrawColor(col.r,col.g,col.b,10)

        draw.GradientDown(0,0,w,h)

        local success = true

        if not isbroke and tbl.DrawInv then
            success = tbl:DrawInv(item,w,h,self)
        else
            if tbl.WorldModel then
                local x,y = self:LocalToScreen()
                
                DrawWeaponSelectionEX(tbl,x,y,w,h - 13,true,-self.hovered * 1)
            else
                surface.SetMaterial(EntityIcon(item.spawnname))
                local size = h - 14 + self.hovered * 5
            
                surface.SetDrawColor(r or 255,g or 255,b or 255)
                surface.DrawTexturedRect(w / 2 - size / 2 + 1,h / 2 - size / 2 + 1,size,size)

                if count > 1 then
                    draw.SimpleText("x" .. count,"InvFont",4,2)
                end
                
                success = false
            end
        end

        if success then
            if IsColor(success) then col = success end
            
            SetDrawColor(col.r,col.g,col.b,180)
            DrawRect(0,h - 13,w,13)

            SetDrawColor(255,255,255,5)
            DrawRect(0,h - 13,w,1)

            draw.SimpleText(L(tostring(tbl.PrintName or item.spawnname)),"InvFont",w / 2,h - 5,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

            if count > 1 then
                draw.SimpleText("x" .. count,"InvFont",4,2)
            end
        end

        local parent = self:GetParent()

        if self:IsHovered() and not (self.wait or self.waitQueue) and (input.IsButtonDown(KEY_LSHIFT) or input.IsButtonDown(KEY_H)) and parent.InputLSHIFT then parent:InputLSHIFT(self) end--RUST RUST RUST1!1
    end

    if self.wait or self.waitQueue then
        SetDrawColor(255,255,255,75)
        surface.SetMaterial(mat_load)
        surface.DrawTexturedRectRotated(w / 2,h / 2,h / 2,h / 2,(CurTime() * 1000) % 360)
    end
end

function PANEL:OnMouse(key,value)
    if not value or (self.donotpressright and key == MOUSE_RIGHT) then return end--shit

    local item = self:GetItemTable()
    if not item then return end

    timer.Simple(math.Rand(0,0.01),function()
        InvPlaySnd(item,"InvGrabSnd","InvMoveSnd",InvMoveSnd,50,-0.2)
    end)

    InvSlotGrab = self
end

function PANEL:OnMouseOut(key,outside)
    local grab = InvSlotGrab
    InvSlotGrab = nil

    if not grab then return end

    if outside then
        grab.wait = true

        self:InvDrop(self.inv and self.inv.id,self.slotX,self.slotY,not input.IsButtonDown(KEY_LCONTROL) and 1)
    elseif grab ~= self then
        grab.wait = true

        local itemGrab = grab:GetItemTable()

        timer.Simple(math.Rand(0,0.01),function()
            InvPlaySnd(itemGrab,"InvMoveSnd","InvMoveSnd",InvMoveSnd)
        end)

        local itemto = self:GetItemTable()

        timer.Simple(math.Rand(0.025,0.04),function()
            InvPlaySnd(itemto,"InvMoveSnd","InvMoveSnd",InvMoveSnd)
        end)

        count = (input.IsButtonDown(KEY_LCONTROL) or key == MOUSE_MIDDLE) and 1

        if key == MOUSE_MIDDLE and input.IsButtonDown(KEY_LSHIFT) then count = 2 end

        grab:InvMove(grab.inv and grab.inv.id,self.inv and self.inv.id,grab.slotX,grab.slotY,self.slotX,self.slotY,count)
        self:InvMove2(grab.inv and grab.inv.id,self.inv and self.inv.id,grab.slotX,grab.slotY,self.slotX,self.slotY,count)
        if grab.InvInsert then grab:InvInsert(self) end
    end
end

function PANEL:UpdateInv() self.wait = nil end

--concommand

function PANEL:InvDrop(id,x,y,count) RunConsoleCommand("hg_inv_drop",id,x,y,count) end
function PANEL:InvMove(inv1,inv2,x1,y1,x2,y2,count) RunConsoleCommand("hg_inv_move",inv1,inv2,x1,y1,x2,y2,count) end
function PANEL:InvMove2() end