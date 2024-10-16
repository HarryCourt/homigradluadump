-- "lua\\entities\\lvs_wheeldrive_pz3e\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")

ENT.TrackLeftSubMaterialID = 7
ENT.TrackRightSubMaterialID = 8

ENT.OpticsProjectileSize = 3.7

function ENT:TankGunnerViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetTopGunnerSeat() and not pod:GetThirdPersonMode() then
		pod:SetThirdPersonMode( true )
	end

	return pos, angles, fov
end
