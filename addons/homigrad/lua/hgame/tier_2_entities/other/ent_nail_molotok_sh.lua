-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\ent_nail_molotok_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_nail_molotok",{"base_entity","item_resource"})
if not ENT then return end

ENT.PrintName = "Гвоздь"
ENT.WorldModel = "models/hunter/plates/plate05.mdl"
ENT.WorldMaterial = "models/props_foliage/tree_deciduous_01a_trunk"

ENT.dwsItemAng = Angle(-45,0,-90)
ENT.dwsItemFOV = -5

ENT.Category = "Ресурсы"
ENT.Spawnable = true

function ENT:InvMax() return 6 end

if CLIENT then return end

function ENT:Parent(ent1,ent2,physbone1,physbone2)
    self.WeldTwoEnts = constraint.Weld(ent1,ent2,physbone1 or 0,physbone2 or 0,0,false,false)

    constraint.Weld(self,ent1,0,physbone1 or 0,0,false,false)
    constraint.Weld(self,ent2,0,physbone2 or 0,0,false,false)

    local world = game.GetWorld()

    if ent1 ~= world then ent1:GetPhysicsObject():EnableMotion(false) end
    if ent2 ~= world then ent2:GetPhysicsObject():EnableMotion(false) end
    
    self.Ent1 = ent1
    self.Ent2 = ent2
end

function ENT:UnParent()
    if IsValid(self.WeldTwoEnts) then self.WeldTwoEnts:Remove() end

    constraint.RemoveAll(self)

    local ent1 = self.Ent1
    local ent2 = self.Ent2

    if ent1 ~= world then ent1:GetPhysicsObject():EnableMotion(true) end
    if ent2 ~= world then ent2:GetPhysicsObject():EnableMotion(true) end

    sound.Emit(self:EntIndex(),"snd_jack_hmcd_hammerhit.wav",75,1,150,nil,nil,{ent1,ent2})
end

function ENT:OnTakeDamage(dmg) self:UnParent() end