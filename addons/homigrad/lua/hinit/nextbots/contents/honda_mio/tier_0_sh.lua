-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\honda_mio\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_honda_mio","npc_alternate",true)
if not ENT then return INCLUDE_BREAK end

ENT.PrintName = "Honda Mio"
ENT.Music = "homigrad/scp/honda_mio/pain.mp3"
ENT.MusicDistance = 99999
ENT.ScanTargetDistance = 9999
ENT.MusicHide = false

ENT.Speed = 800
ENT.Acceleration = 800
ENT.Deceleration = 800

ENT.AttackDelay = 0

ENT.Weapons = {}

function ENT:Init()
    if CLIENT then
        self:SetNWVarProxy("Weapon",function(_,_,old,new)
            self:WeaponChange(old,new)--uf
        end)
    else
        self.StartTime = CurTime()
    end
end

function ENT:WeaponChange(old,new)
    if old == new then return end--;c;c;c

    local wep = self.Weapons[old or ""]
    if wep and wep.Off then wep.Off(self) end

    wep = self.Weapons[new]
    if wep and wep.On then wep.On(self) end
end

function ENT:SetWeapon(name)
    local old = self:GetNWString("Weapon")
    self:SetNWString("Weapon",name)

    self:WeaponChange(old,name)
end

function ENT:GetWeapon() return self:GetNWString("Weapon") end