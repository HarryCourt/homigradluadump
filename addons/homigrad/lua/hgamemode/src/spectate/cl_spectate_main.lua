-- "addons\\homigrad\\lua\\hgamemode\\src\\spectate\\cl_spectate_main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local view = {}

local old

local vecFull = Vector(1,1,1)

local lerpVec = EyePos()

local outdistance = 75
local outface,forwardface = 0,0

local watchFace

event.Add("PreCalcView","spectate",function(ply,view)
	ply = LocalPlayer()

	if ply:Alive() then outdistance = 75 return end

	local func = TableRound().DisableSpectate
	if func and func(ply,view) ~= false then return end

	local vec,ang = view.vec,view.ang
	local spec = SpecEnt

	lerpVec:LerpFT(0.9,ply:GetPos())

	view.mulSide = 0.5
	
	if not IsValid(spec) then
		view.vec = lerpVec
		view.ang = ang

		return view
	end

	local ent = IsValid(spec:GetNWEntity("Ragdoll")) and spec:GetNWEntity("Ragdoll") or spec

	local dir = Vector(1,0,0):Rotate(ang)
	
	if not LocalPlayer():KeyDown(IN_WALK) and not LocalPlayer():KeyDown(IN_SPEED) then
		outdistance = math.max(outdistance - wheel * 5,0)
	end

	if IsSpectate == 1 then
		if outdistance == 0 then
			if not watchFace then
				watchFace = true
				
				ply:ChatPrint(L("spectate_wathface"))
			end

			if BodyCamMode then
				local ent = SpecEnt
		
				ent = ent:GetEntity()
				local headBone = ent:LookupBone("ValveBiped.Bip01_Head1")
				local head = headBone and ent:GetBoneMatrix(headBone)
			
				if head then
					local ang = head:GetAngles()
					ang:RotateAroundAxis(ang:Right(),90)
					ang:RotateAroundAxis(ang:Up(),-90)
					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Forward(),90)
	
					view.vec = head:GetTranslation():Add(Vector(5,-5,9):Rotate(ang))
					view.ang = ang
				end
			else
				old = ent
	
				local func = ent.Spectate2
	
				if func then
					return func(ent,ply,view)
				else
					if not spec.Eye then return end
	
					local pos,ang = spec:Eye()
	
					view.vec = pos
					view.ang = ang
	
					if not override then
						override = true
						event.Run("PreCalcView",spec,view)
						override = nil
					end
	
					return view
				end
			end
		else
			if watchFace then
				watchFace = nil
				ply:ChatPrint(L("spectate_wath"))
			end

			if outdistance <= 10 then
				if LocalPlayer():KeyDown(IN_SPEED) then outface = outface + wheel / 4 end
				if LocalPlayer():KeyDown(IN_WALK) then forwardface = forwardface + wheel / 4 end

				local tr = {}

				local head = ent:LookupBone("ValveBiped.Bip01_Head1")
				head = head and  ent:GetBoneMatrix(head)
		
				tr.start = (head and head:GetTranslation() or (ent:GetPos() + ent:OBBCenter())) + Vector(0,0,5 + forwardface)
				tr.endpos = tr.start + Vector(0,-12 + outface,0):Rotate(head:GetAngles())
				tr.filter = {ply,ent,ent.GetVehicle and ent:GetVehicle()}

				view.vec = util.TraceLine(tr).HitPos
				view.ang = view.ang + (tr.start - tr.endpos):Angle()
				view.fov = 150
				view.znear = 0.1
			else
				local tr = {}

				local func = ent.Spectate1

				if func then
					return func(ent,ply,view)
				else
					local head = ent:LookupBone("ValveBiped.Bip01_Head1")
					head = head and  ent:GetBoneMatrix(head)
			
					tr.start = head and head:GetTranslation() or (ent:GetPos() + ent:OBBCenter())
					tr.endpos = tr.start - dir * (outdistance)
					tr.filter = {ply,ent,ent.GetVehicle and ent:GetVehicle()}

					if ent.SpectateFunc then ent:SpectateFunc(view) end

					view.vec = util.TraceLine(tr).HitPos
					view.ang = ang
				end

				return view
			end
		end
	else
		if IsValid(old) then
			if head then ent:ManipulateBoneScale(head,vecFull) end

			old = nil
		end
	end
end)

--

local oldKeyWalk

local oldNext
local oldBack

local function SetSpectate(ply)
	SpecEnt = ply

	if IsSpectate == 2 then
		ViewEntity = ply
	else
		ViewEntity = nil
	end

	if ply then
		if IsValid(ply) then
			RunConsoleCommand("hg_spectate",tostring(ply:EntIndex()))
		end
	else
		ViewEntity = nil
		
		RunConsoleCommand("hg_spectate")
	end
end

IsSpectate = 1

hook.Add("Think","Spectate",function()
	local ply = LocalPlayer()
	if ply:Alive() then return end

	if (InWindowTime or 0) + 0.25 > CurTime() then return end

	local key = ply:KeyDown(IN_RELOAD)

	if hook.Run("Lock R Spectate") == nil then
		if key ~= oldKeyWalk and key then
			if IsSpectate == 1 then
				IsSpectate = 2//свободный полёт
				SetSpectate()

				ply:ChatPrint(L("spectate_fly"))
			else
				IsSpectate = 1//наблюдение за игроком
				outdistance = 75
		
			end
			
			
		end
	end
	
	oldKeyWalk = key

	local tbl = {}

	for i,ply in pairs(player.GetAll()) do
		if not ply:Alive() then continue end

		tbl[#tbl + 1] = ply
	end

	if IsSpectate == 1 then
		local func = TableRound().SpectateNext
		if func and func(tbl) == false then return end
		
		if #tbl == 0 then SpecEnt = nil return end

		if not IsValid(SpecEnt) or (SpecEnt.Alive and not SpecEnt:Alive()) then
			SetSpectate(table.Random(tbl))
		end

		local next,back = ply:KeyDown(IN_ATTACK),ply:KeyDown(IN_ATTACK2)

		if oldNext ~= next and next then
			for i,ply in pairs(tbl) do
				if ply == SpecEnt then
					SetSpectate(tbl[(i + 1 > #tbl and 1) or (i + 1)])

					break
				end
			end
		end

		if oldBack ~= back and back then
			for i,ply in pairs(tbl) do
				if ply == SpecEnt then
					SetSpectate(tbl[(i - 1 < 0 and #tbl) or (i - 1)])

					break
				end
			end
		end

		oldNext = next
		oldBack = back
	end
end)

hook.Add("PrePlayerDraw","SpectateFace",function(ply)
	if IsSpectate == 2 and ply == SpecEnt and SpecEnt:EyeMode() then return true end
end)