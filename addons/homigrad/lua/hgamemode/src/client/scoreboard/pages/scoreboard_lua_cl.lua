-- "addons\\homigrad\\lua\\hgamemode\\src\\client\\scoreboard\\pages\\scoreboard_lua_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local unmutedicon = Material( "icon32/unmuted.png", "noclamp smooth" )
local mutedicon = Material( "icon32/muted.png", "noclamp smooth" )

local mat_loading = Material("homigrad/vgui/loading.png")

local SetDrawColor,DrawRect = surface.SetDrawColor,surface.DrawRect

function ScoreboardBuildOnLua(self,scroll)
    local panel = self//ваще похуй

    for i,ply in pairs(self.sort) do
        i = i - 1

        local panel = oop.CreatePanel("v_panel",scroll):ad(function(self)
            self:setSize(panel:W(),50 * ScreenSize):setPos(0,self:H() * i)
        end)

        panel = oop.CreatePanel("v_panel",panel):setDSize(1,1)

        local alive
        local alivecol
        local colorAdd

        function panel:Draw(w,h)
            if not IsValid(ply) then return end

            SetDrawColor(0,0,0,100)
            DrawRect(0,0,w,h)

            if self:IsHovered() then
                SetDrawColor(125,125,125,5)
                DrawRect(0,0,w,h)
            end

            local func = TableRound().Scoreboard_Status
            
            if func then
                alive,alivecol,colorAdd = func(ply)
            end

            if not func or (not alive) then
                if ply:Alive() then
                    alive = "scoreboard_live"
                    alivecol = ScoreboardGreen
                elseif ply:Team() == 1002 then
                    alive = "scoreboard_spectate"
                    alivecol = ScoreboardSpec
                else
                    alive = "scoreboard_dead"
                    alivecol = ScoreboardRed
                    colorAdd = ScoreboardRed
                end
            end

            if colorAdd then
                SetDrawColor(colorAdd.r,colorAdd.g,colorAdd.b,5)
                DrawRect(0,0,w,h)
            end

            if ply == LocalPlayer() then
                SetDrawColor(255,255,255,1)
                DrawRect(0,0,w,h)
            end

            local color,mat = ply:GetNameColor()

            if mat then
                surface.SetDrawColor(255,255,255)
                surface.SetMaterial(mat)
                surface.DrawTexturedRectRotated(w  / 2 / 2,h / 2,16,16,0)
            end

            draw.SimpleText(L(alive),"H.18",125,h / 2,alivecol,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText(ply:Name(),"H.18",w / 2,h / 2,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            
            local time = (ply:IsBot() and 0) or ply:GetNWInt("Time",-1)

            if time == -1 then
                surface.SetMaterial(mat_loading)
                surface.SetDrawColor(255,255,255,125)
                surface.DrawTexturedRectRotated(w - 350,h / 2,h * 0.5,h * 0.5,CurTime() * 360)
            else
                time = math.floor(time + (CurTime() - ply:GetNWFloat("TimeStart",0)))
                local dTime,hTime,mTime = math.floor(time / 60 / 60 / 24),tostring(math.floor(time / 60 / 60) % 24),tostring(math.floor(time / 60) % 60)

                draw.SimpleText(dTime .. "d","H.18",w - 350 - 25,h / 2,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
                draw.SimpleText(hTime .. "h","H.18",w - 350,h / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                draw.SimpleText(mTime .. "m","H.18",w - 350 + 25,h / 2,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            
            draw.SimpleText(ply:Ping(),"H.18",w - 250,h / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

            local name,color = ply:PlayerClassEvent("TeamName")

            if not name then
                name,color = TableRound().GetTeamName(ply)
                name = name or "spectate"
                color = color or ScoreboardSpec
            end

            draw.SimpleText(L(name),"H.18",w - 125,h / 2,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        local avatar = vgui.Create("AvatarImage",panel)
        avatar:SetPlayer(ply,128)--govno fuuu

        function avatar:PaintOver(w,h) draw.Frame(0,0,w,h,cframe1,cframe2) end

        panel:ad(function(self) avatar:SetSize(panel:H(),panel:H()) end)

        if ply ~= LocalPlayer() then
            local butt = oop.CreatePanel("v_button",panel):ad(function(self) self:setSize(panel:H() * 0.75,panel:H() * 0.75):setPos(panel:W() - self:H() * 1.25,panel:H() / 2 - self:H() / 2) end)

            function butt:Draw(w,h)
                surface.SetMaterial(ply:IsMuted() and mutedicon or unmutedicon)
                surface.SetDrawColor(255,255,255,255)

                DisableClipping(true)
                local s = (self:IsHovered() and h + 8) or (self:IsDown() and h - 8) or h
                surface.DrawTexturedRectRotated(w / 2,h / 2,s,s,0)
                DisableClipping(false)
            end

            function butt:OnMouse(key,value)
                if not value then return end

                ply:SetMuted(not ply:IsMuted())
                SaveMuteStatusPlayer(ply,ply:IsMuted())
            end
        end

        function panel:OnMouse(key,value)
            if not value or key ~= MOUSE_RIGHT then return end

            OpenDermaPlayer(ply)
        end
    end
end