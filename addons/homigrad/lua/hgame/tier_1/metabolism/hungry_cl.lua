-- "addons\\homigrad\\lua\\hgame\\tier_1\\metabolism\\hungry_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("RenderScreenspaceEffects","Hungry",function()
	local ply = LocalPlayer()
	if not ply:Alive() then return end

	if hook.Run("Should Draw Screenspace") == false then return end

    local k = 1 - ply:GetNWFloat("hungry") / 10
    k = math.Clamp(math.max(k - 0.25,0) * 5,0,1)

    if k <= 0 then return end

    k = k / 3

    DrawMotionBlur(0.4 - k / 10,0.1 + k,0.15)
end)

hook.Add("RenderScreenspaceEffects","Experiment",function()
    //DrawMotionBlur(0.4,0.15,0.01)
end)