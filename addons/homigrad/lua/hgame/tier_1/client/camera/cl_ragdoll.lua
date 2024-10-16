-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\camera\\cl_ragdoll.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local vecZero = Vector(0.01,0.01,0.01)
local vecFull = Vector(1,1,1)

event.Add("PreCalcView","Ragdoll",function(ply,view)
	local rag = ply:GetNWEntity("Ragdoll")

	if ply:Alive() and IsValid(rag) then
		rag:ManipulateBoneScale(6,DRAWMODEL and vecZero or vecFull)

		view.noSmooth = true

		local pos,ang = ply:Eye()

		local head = rag:LookupBone("ValveBiped.Bip01_Head1")
		rag:SetupBones()--ну с богом

        head = head and rag:GetBoneMatrix(head)

		if head then
			local headAng = head:GetAngles()
			headAng:Add(Angle(0,0,-90))

			ang:Lerp(math.min(math.max(rag:GetVelocity():Length() / 512 - 0.25,0) / 0.75,1),headAng)
		end

		view.vec = pos
		view.ang = ang
	end
end)