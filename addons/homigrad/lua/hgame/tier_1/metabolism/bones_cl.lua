-- "addons\\homigrad\\lua\\hgame\\tier_1\\metabolism\\bones_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*hook.Add("Think", "CheckInjuryMessages", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local message = ply:GetNWString("InjuryMessage", "")
    if message ~= "" then
        chat.AddText(Color(255, 0, 0), message)
        ply:SetNWString("InjuryMessage", "") 
    end
end)
