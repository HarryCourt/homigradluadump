-- "addons\\homigrad\\lua\\hgame\\tier_0\\sh_admins.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
validUserGroupSuperAdmin = {
	superadmin = true,
	dsuperadmin = true,
	["curator"] = true,
}

validUserGroupOperator = {
	doperator = true,
}

validUserGroupAdmin = {
	admin = true,
	operator = true,

	dadmin = true,
}


validSponsorGroup = {
	megasponsor = true
}

local function Run()
	local PLAYER = FindMetaTable("Player")

	function PLAYER:IsAdmin()
		return validUserGroupOperator[self:GetUserGroup()] or validUserGroupAdmin[self:GetUserGroup()] or validUserGroupSuperAdmin[self:GetUserGroup()] and true or false
	end
end

hook.Add("Initialize","Admin",Run)

Run()
