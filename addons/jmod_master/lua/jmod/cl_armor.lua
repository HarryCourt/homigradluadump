-- "addons\\jmod_master\\lua\\jmod\\cl_armor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿function JMod.CopyArmorTableToPlayer(ply)
	ply.JMod_ArmorTableCopy = table.FullCopy(JMod.ArmorTable)
	local plyMdl = ply:GetModel()

	if JMod.LuaConfig and JMod.LuaConfig.ArmorOffsets and JMod.LuaConfig.ArmorOffsets[plyMdl] then
		table.Merge(ply.JMod_ArmorTableCopy,JMod.LuaConfig.ArmorOffsets[plyMdl])
	end
end

concommand.Add("jmod_debug_countclientsidemodels", function()
	print("Entity count : ")
	local entite = {}
	local i = 0

	for k, v in pairs(ents.FindByClass("*C_BaseFlex")) do
		if v:GetModel() == nil then continue end

		if entite[v:GetModel()] == nil then
			entite[v:GetModel()] = 0
		end

		entite[v:GetModel()] = entite[v:GetModel()] + 1
		i = i + 1
	end

	print(i)
	print("-")
	print("- CLIENTSIDE STUFF START :")
	print("-")

	for k, v in pairs(entite) do
		print(v .. " : " .. k)
	end

	print("-")
	print("- CLIENTSIDE STUFF END ...")
	print("-")
end, nil, "Poluxtobee's CS model debug")

event.Add("Player Spawn","Armor",function(ply)
	ply:GetNWTable("Armor")
end)

FindMetaTable("Player").OnNWTable_Armor = function(self,tbl)
	self.EZarmor = tbl//dmem

	hook.Run("JMod_EZarmorSync",self,tbl)
end