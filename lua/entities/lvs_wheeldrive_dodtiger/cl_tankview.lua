-- "lua\\entities\\lvs_wheeldrive_dodtiger\\cl_tankview.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "muzzle" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * 130 + Muzzle.Ang:Forward() * 15 - Muzzle.Ang:Right() * 8
		end

	end

	return pos, angles, fov
end
