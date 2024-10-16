-- "lua\\entities\\lvs_wheeldrive_wespe\\sh_turret.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretAimRate = 15

ENT.TurretRotationSound = "common/null.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -45
ENT.TurretPitchMax = 5
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMin = -30
ENT.TurretYawMax = 30
ENT.TurretYawMul = -1
ENT.TurretYawOffset = 0