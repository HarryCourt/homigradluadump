-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\cl_view_armor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local table_GetKeys = table.GetKeys

local models_female = {
	["models/player/group01/female_01.mdl"] = true,
	["models/player/group01/female_02.mdl"] = true,
	["models/player/group01/female_03.mdl"] = true,
	["models/player/group01/female_04.mdl"] = true,
	["models/player/group01/female_05.mdl"] = true,
	["models/player/group01/female_06.mdl"] = true,

	["models/player/group03/female_01.mdl"] = true,
	["models/player/group03/female_02.mdl"] = true,
	["models/player/group03/female_03.mdl"] = true,
	["models/player/group03/female_04.mdl"] = true,
	["models/player/group03/female_05.mdl"] = true,
	["models/player/group03/police_fem.mdl"] = true
}

for i = 1,6 do
	models_female["models/monolithservers/mpd/female_0"..i..".mdl"] = true
end

for i = 1,6 do
	models_female["models/monolithservers/mpd/female_0"..i.."_2.mdl"] = true
end

local vecFull = Vector(1,1,1)
local ArmorTable = JMod.ArmorTable
local plyboneedit

local tostring = tostring

function JMod_ArmorIsFace(slots)
	return slots.mouthnose or slots.eyes or slots.head or slots.acc_ears or slots.acc_head or slots.acc_eyes or slots.ears
end

function JMod_ArmorSetupRender(list,isClient)
	local renderOrder = {}

	for id,armorData in pairs(list) do
		local spec = ArmorTable[armorData.name]
		local mdl = spec.mdl

		if isClient and JMod_ArmorIsFace(spec.slots) then continue end

		if armorData.tgl and spec.tgl then
			local podstava = {}

			for k,v in pairs(spec) do podstava[k] = v end
			for k,v in pairs(spec.tgl) do podstava[k] = v end

			for k,v in pairs(podstava.tgl) do
				if TypeID(v) ~= TYPE_TABLE then continue end
				
				if #table_GetKeys(v) == 0 then spec[k] = {} end
			end

			spec = podstava
		end

		renderOrder[#renderOrder + 1] = {mdl,spec,armorData.col}
	end

	return renderOrder
end

hook.Add("JMod_EZarmorSync","!SetupRender",function(ply,tbl)
	ply.EZarmorRender = JMod_ArmorSetupRender(tbl.items,ply == LocalPlayer())
end)

local function GetPos(ent,spec)
	local bon = spec.bon 
	if not bon then return end

	local Index = ent:LookupBone(bon)
	if not Index then return end
	
	local matrix = ent:GetBoneMatrix(Index)
	if not matrix then return end--lol

	local Pos,Ang = matrix:GetTranslation(),matrix:GetAngles()

	if Pos and Ang then
		local Right,Forward,Up = Ang:Right(),Ang:Forward(),Ang:Up()

		local pos = spec.pos
		Pos:Add(Right * pos.x)
		Pos:Add(Forward * (pos.y + ((models_female[ent:GetModel()] and bon == "ValveBiped.Bip01_Spine2") and -3 or 0)))
		Pos:Add(Up * pos.z)

		local ang = spec.ang
		Ang:RotateAroundAxis(Right,ang.p)
		Ang:RotateAroundAxis(Up,ang.y)
		Ang:RotateAroundAxis(Forward,ang.r)

        return Pos,Ang
    end
end

local render_SetColorModulation = render.SetColorModulation

function JMod.DrawArmorOnEntity(ent,mdl,spec,col)
	local mdl,nowCreate = GetClientSideModelID(mdl,tostring(ent) .. (ent.id or "") .. mdl)
	if not mdl then return end

    if nowCreate then
		mdl:SetMaterial(spec.mat or "")
	
		local Mat = Matrix()
		Mat:Scale(spec.siz or vecFull)
		mdl:EnableMatrix("RenderMultiply",Mat)

		if spec.skin then mdl:SetSkin(spec.skin) end
	end

    local Pos,Ang = GetPos(ent,spec)
    if not Pos then return end

    mdl:SetRenderOrigin(Pos)
    mdl:SetRenderAngles(Ang)
	mdl:SetupBones()

	render_SetColorModulation(col.r / 255,col.g / 255,col.b / 255)
	mdl:SetColor(col)
	mdl:DrawModel()
end

local DrawArmorOnEntity = JMod.DrawArmorOnEntity

local i,EZarmorRender,pkg

function JMod.ArmorPlayerModelDraw(ply,ent,isClient)
	EZarmorRender = ply.EZarmorRender
	if not EZarmorRender then return end

	i = 0

	::start::
	
	i = i + 1

	pkg = EZarmorRender[i]
	if not pkg then return end

	DrawArmorOnEntity(ent,pkg[1],pkg[2],pkg[3])

	goto start
end

local function initialize()
	hook.Add("PostPlayerDraw","JModArmor",function(ply)
		JMod.ArmorPlayerModelDraw(ply,ply)

		render_SetColorModulation(1,1,1)
	end)
end

cvars.CreateOption("hg_draw_armor","1",function(value)
	if tonumber(value) > 0 then
		initialize()
	else
		hook.Remove("PostPlayerDraw","JModArmor")
	end
end)

hook.Add("PostPlayerDraw VGUI","JModArmor",function(ply,ent)
	JMod.ArmorPlayerModelDraw(ent,ent)
end)

hook.Add("JMod_EZarmorSync","VGUI Players",function(ply,tbl)
	for panel in pairs(VGUIPlayerModel) do
		if not IsValid(panel) then VGUIPlayerModel[panel] = nil continue end//govno cod пошёл
		if panel.ply ~= ply then continue end

		local mdl = panel.mdl
		//if not IsValid(mdl) then continue end--LOL

		mdl.EZarmorRender = JMod_ArmorSetupRender(tbl.items)
	end
end)

hook.Add("VGUIPlayerModel Set Player","Armor",function(panel,ply)
	panel.mdl.EZarmorRender = JMod_ArmorSetupRender(ply:GetNWTable("Armor").items)
end)