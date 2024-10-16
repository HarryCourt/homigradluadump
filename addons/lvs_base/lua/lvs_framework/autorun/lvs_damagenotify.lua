-- "addons\\lvs_base\\lua\\lvs_framework\\autorun\\lvs_damagenotify.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if CLIENT then 
	net.Receive( "lvs_hurtmarker", function( len )
		if not LVS.ShowHitMarker then return end

		local ply = LocalPlayer()

		local vehicle = ply:lvsGetVehicle()

		if not IsValid( vehicle ) then return end

		vehicle:HurtMarker( net.ReadFloat() )
	end )

	net.Receive( "lvs_hitmarker", function( len )
		if not LVS.ShowHitMarker then return end

		local ply = LocalPlayer()

		local vehicle = ply:lvsGetVehicle()
		if not IsValid( vehicle ) then return end

		if net.ReadBool() then
			vehicle:CritMarker()
		else
			vehicle:HitMarker()
		end
	end )

	net.Receive( "lvs_killmarker", function( len )
		if not LVS.ShowHitMarker then return end

		local ply = LocalPlayer()

		local vehicle = ply:lvsGetVehicle()

		if not IsValid( vehicle ) then return end

		vehicle:KillMarker()
	end )

	return
end

util.AddNetworkString( "lvs_hitmarker" )
util.AddNetworkString( "lvs_hurtmarker" )
util.AddNetworkString( "lvs_killmarker" )