-- "addons\\homigrad_core\\lua\\shlib\\tier_1\\sh_fixgodmode.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then
    event.Add("Player Think 1","HasGodMode Rep",function(ply) ply:SetNWBool("HasGodMode",ply:HasGodMode()) end)
else
    FindMetaTable("Player").HasGodMode = function(self) return self:GetNWBool("HasGodMode") end
end