-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\serverside_model_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("serverside_model",{"base_entity"})
if not ENT then return end

function ENT:Initialize()
    self:AddEFlags(EFL_SERVER_ONLY)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)

    self:SetNoDraw(true)
    self:DrawShadow(false)
end

//вааау нельзя создать только серверные объекту юхууу нахуй этот енжин флаг вообще нахуй