-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\cl_view_ragdoll.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local vecZero = Vector()

hook.Add("PreCalcView","Ragdoll",function(ply,vec,ang,fov,znear,zfar)
	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))

	local ragdoll = ply:GetNWEntity("Ragdoll")

	if ply:Alive() and IsValid(ragdoll) then
		ragdoll:ManipulateBoneScale(6,vecZero)

        local pos,ang = ply:Eye()

		local view = {
			origin = pos,
			angles = ang,
			fov = fov,
			drawviewer = true
		}

		return view
	end
end)