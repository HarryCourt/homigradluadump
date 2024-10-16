-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\tier_0\\net\\net_hooker_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Receivers = net.Receivers

local net_ReadHeader = net.ReadHeader
local util_NetworkIDToString = util.NetworkIDToString

local string_lower = string.lower

net.Incoming = function(len,ply)
	local strName = util_NetworkIDToString(net_ReadHeader())

	if strName then
		local func = Receivers[string_lower(strName)]
		if not func then return strName end

		len = len - 16

		func(len,ply)
	end
end//optimize