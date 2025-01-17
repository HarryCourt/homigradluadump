-- "lua\\entities\\lvs_wheeldrive_pz3f\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")
include("cl_attached_playermodels.lua")

ENT.TrackLeftSubMaterialID = 11
ENT.TrackRightSubMaterialID = 12

ENT.OpticsProjectileSize = 5

function ENT:TankGunnerViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetTopGunnerSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "topmg_eye" )

		local EyeAttach = self:GetAttachment( ID )

		if EyeAttach then
			--EyeAttach.Pos + EyeAttach.Ang:Right() * -0.4 + EyeAttach.Ang:Forward() * -5) * Zoom
			pos = EyeAttach.Pos + EyeAttach.Ang:Up() * -0.8 + EyeAttach.Ang:Forward() * -15 + EyeAttach.Ang:Right() * -1.9
		end
	end

	return pos, angles, fov
end
