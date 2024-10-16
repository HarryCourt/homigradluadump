-- "addons\\homigrad_core\\lua\\shlib\\tier_1\\playerclass\\anim_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("CalcMainActivity","PlayerClass",function(ply,velocity)
	local tab = ply:GetPlayerClass()
	if not tab then return end

	local func = tab.CalcMainActivity 
	if not func then return end

	local ideal,override = func(ply,velocity)

	if ideal then return ideal,override end
end)

if SERVER then return end

/*local mat = Material("color")

concommand.Add("hg_getanim",function()
	if IsValid(hg_getanim) then hg_getanim:Remove() end 
	hg_getanim = vgui.Create("DFrame")
	local frame = hg_getanim
	frame:SetSize(700,700)
	frame:Center()
	frame:MakePopup()

	local hF = frame:GetTall() - 30
	local wF = frame:GetWide()
	
	local drawAttancments = true
	local drawBone = true

	local viewModel = vgui.Create("DModelPanel",frame)
	viewModel:SetSize(wF / 2,hF / 2)
	viewModel:SetPos(wF - viewModel:GetWide(),30)
	viewModel:SetModel("models/weapons/arccw_go/v_rif_ak47.mdl")
	viewModel:SetAnimated(true)
	local pos,ang = Vector(25,0,0),Angle(0,180,0)

	local mX,mY = gui.MouseX(),gui.MouseY()

	local vecPoint = Vector()

	function viewModel:Paint(w,h)
		local x,y = self:LocalToScreen(0,0)

		local mx,my = gui.MouseX(),gui.MouseY()
		local dx,dy = mX - mx,mY - my
		mX,mY = mx,my

		if self:IsHovered() then
			if input.IsMouseDown(MOUSE_LEFT) then
				ang[1] = ang[1] - dy
				ang[2] = ang[2] + dx

				local movePos = Vector()

				if input.IsButtonDown(KEY_W) then movePos[1] = movePos[1] + 1 end
				if input.IsButtonDown(KEY_S) then movePos[1] = movePos[1] - 1 end
				if input.IsButtonDown(KEY_A) then movePos[2] = movePos[2] + 1 end
				if input.IsButtonDown(KEY_D) then movePos[2] = movePos[2] - 1 end

				if input.IsButtonDown(KEY_SPACE) then movePos[3] = movePos[3] + 1 end
				if input.IsButtonDown(KEY_LCONTROL) then movePos[3] = movePos[3] - 1 end

				pos:Add(movePos:Rotate(ang))
			end
		end

		DrawModelInFrame(x,y,w,h,viewModel.Entity,75,pos,ang,Vector(),Angle(),true)

		render.SetMaterial(mat)
		render.DrawSphere(vecPoint,0.25,16,16)

		local lol = {}

		local ow,oh = ScrW(),ScrH()
		render.SetViewPort(x,y,w,h)

		if drawAttancments then
			for id,att in pairs(viewModel.Entity:GetAttachments()) do
				local pos = Vector():ToScreen()
				--pos.x = pos.x - x
				--pos.y = pos.y - y

				lol[#lol + 1] = {pos.x,pos.y,att.id .. "|" .. att.name}
				draw.SimpleText(att.id .. "|" .. att.name,"ChatFont",pos.x,pos.y,nil,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end

		render.SetViewPort(0,0,ow,oh)
		cam.End3D()

		cam.Start3D()
		cam.End3D()
	end

	function viewModel:OnMouseWheeled(value)

	end

	viewModel:OnMouseWheeled(0)

	local list = vgui.Create("DListView",frame)
	list:SetSize(wF / 2,hF)
	list:SetPos(0,30)

	function list:UpdateContent()
		list:Clear()
		list:SetMultiSelect(false)
		list:AddColumn("ID")
		list:AddColumn("Name")

		local ent = viewModel.Entity
		local count = viewModel.Entity:GetSequenceCount() - 1

		for i = 1,count do
			local info = ent:GetSequenceInfo(i)
			list:AddLine(i,info.label)
		end
	end

	function list:OnRowSelected(id,panel)
		local id = panel:GetColumnText(1)

		local ent = viewModel.Entity
		PrintTable(ent:GetSequenceInfo(id))
		ent:SetSequence(id)
	end

	local dTextEntry = vgui.Create("DTextEntry",frame)
	dTextEntry:SetPos(wF / 2,hF / 2 + 30)
	dTextEntry:SetSize(wF / 2,25)

	function dTextEntry:OnEnter(value)
		viewModel:SetModel(value)
		list:UpdateContent()
	end

	list:UpdateContent()

	local button = vgui.Create("DButton",frame)
	button:SetPos(wF / 2,hF / 2 + 60)
	button:SetSize(wF / 2,25)
	button:SetText("Get Materials")

	function button:DoClick() PrintTable(viewModel.Entity:GetMaterials()) end

	local dTextEntry = vgui.Create("DTextEntry",frame)
	dTextEntry:SetPos(wF / 2,hF / 2 + 90)
	dTextEntry:SetSize(wF / 2,25)

	function dTextEntry:OnChange()
		local value = self:GetValue()
		value = string.Split(value," ")
		vecPoint = Vector(tonumber(value[1] or 0),tonumber(value[2] or 0),tonumber(value[3] or 0))
	end
end)
*/