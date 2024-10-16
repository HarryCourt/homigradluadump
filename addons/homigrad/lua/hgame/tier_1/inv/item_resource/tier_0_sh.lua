-- "addons\\homigrad\\lua\\hgame\\tier_1\\inv\\item_resource\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("item_resource",{"lib_event","lib_duplicate"},true)
if not ENT then return INCLUDE_BREAK end

ENT.invMax = 10

function ENT:InvMax() return self.InvMax end
function ENT:GetInvCount() return self:GetNWInt("count") end
function ENT:SetInvCount(value) return self:SetNWInt("count",value) end

if SERVER then return end

function ENT:DrawInv(item,w,h,butt)
    draw.SimpleText("x" .. (item.count or 1),"InvFont",4,2)

    return true
end

local white = Color(255,255,255)

function ENT:HUDTarget(ply,k,w,h)
    white.a = 255 * k * (1 - InvOpenK)

    draw.SimpleText(L(self.PrintName),"H.18",w / 2,h / 2 - 50 * (1 - k),white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end
