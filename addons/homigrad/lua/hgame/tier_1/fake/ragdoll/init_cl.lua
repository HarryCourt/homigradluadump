-- "addons\\homigrad\\lua\\hgame\\tier_1\\fake\\ragdoll\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Get("fake_ragdoll")
if not ENT then return end

function ENT:Initialize()
    self.armors = {}
    self.renderOrder = {}

    self:GetNWTable("Armor")

    self:AddEFlags(EFL_NO_THINK_FUNCTION)
	self:DrawShadow(false)
end

function ENT:OnNWTable_Armor(tbl)
    self.armors = tbl
    
    local list = {}

    for id,data in pairs(tbl) do
        list[#list + 1] = {
            name = data[1],
            col = data[2]
        }
    end

    local parent = self:GetParent()    
    self.renderOrder = JMod_ArmorSetupRender(list,IsValid(parent) and parent:GetNWEntity("RagdollController") == LocalPlayer() or false)//lox
end

local empty = {}

local hg_draw_armor

cvars.Hook("hg_draw_armor",function(value) hg_draw_armor = tonumber(value) > 0 end,"hg_draw_armor")

local DrawArmorOnEntity = JMod.DrawArmorOnEntity

function ENT:Draw()
    local rag = self:GetParent()
    if not IsValid(rag) then return end--wtf?

    local ply = LocalPlayer()
    
    if hg_draw_armor then
        rag:SetupBones()
        
        local EZarmorRender = self.renderOrder
        local i = 0

        ::start::
        
        i = i + 1

        local pkg = EZarmorRender[i]
        if not pkg then return end

        DrawArmorOnEntity(rag,pkg[1],pkg[2],pkg[3])

        goto start
    end

    ply:DrawFlashlight()
end

concommand.Add("hg_ragdoll_get_armors",function(ply,cmd)
    local tr = ply:EyeTrace()

    local ent

    for i,ent2 in pairs(ents.FindInSphere(tr.HitPos,15)) do
        if ent2:GetClass() == "fake_ragdoll" then ent = ent2 break end
    end

    for i = 1,10 do
        print(i,ent:GetNWString("Armor" .. i,""))
    end
end)