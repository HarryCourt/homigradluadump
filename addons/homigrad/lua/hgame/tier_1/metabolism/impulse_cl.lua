-- "addons\\homigrad\\lua\\hgame\\tier_1\\metabolism\\impulse_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
impulse = 0

net.Receive("impulse",function() impulse = net.ReadFloat() end)

event.Add("LocalPlayer Spawn","Impulse",function(ply) impulse = 0 end)

hook.Add("RenderScreenspaceEffects","Impulse",function()
    if not LocalPlayer():Alive() then return end

	DrawToyTown(math.Clamp(impulse * 2,0,10),ScrH())
    DrawToyTown(math.Clamp(impulse * 10,0,10),ScrH() / 12)
end)