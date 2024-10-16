-- "lua\\entities\\lvs_wheeldrive_dodwillyjeep_mg\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Willys Jeep M1919"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Military"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/willys/willys_mg.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1200

ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(40,0,35)

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/willy/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/willy/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 0,
		Sprites = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-63.41,-20.49,21.1),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 7,
	},
	{
		Trigger = "high",
		Sprites = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{

		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(-63.41,20.49,21.1),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(61.03,14.6,28.6),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(61.03,-14.6,28.6),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(53.09,26.85,35.88),
				colorB = 200,
				colorA = 150,
			},
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-59.32,13.07,12.77),
		ang = Angle(0,180,0),
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
end

function ENT:InitWeapons()
	self:AddGunnerWeapons()
end

function ENT:GunnerInRange( Dir )
	local pod = self:GetGunnerSeat()

	if IsValid( pod ) and not pod:GetThirdPersonMode() then
		local ply = pod:GetDriver()

		if IsValid( ply ) and ply:lvsKeyDown( "ZOOM" ) then
			return true
		end
	end

	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 50
end

function ENT:AddGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.12
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not base:GunnerInRange( ent:GetAimVector() ) then

			if not IsValid( base.SNDTurretMGf ) then return true end

			base.SNDTurretMGf:Stop()
	
			return true
		end

		local Muzzle = base:GetAttachment( base:LookupAttachment( "muzzle" ) )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos

		local ply = ent:GetDriver()

		if IsValid( ply ) and ply:lvsKeyDown( "ZOOM" ) then
			local pod = ply:GetVehicle()

			if IsValid( pod ) and not pod:GetThirdPersonMode() then
				bullet.Dir 	= Muzzle.Ang:Up()
			else
				bullet.Dir 	= (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
			end
		else
			bullet.Dir 	= (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
		end

		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 30000
		bullet.Attacker 	= ply
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		if not IsValid( base.MgShot ) or not IsValid( base.SNDTurretMGf ) then return end

		base.MgShot:PlayOnce() -- shoot anim
		base.SNDTurretMGf:Play() -- sound
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Stop()
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not ent:GetAI() and not IsValid( ent:GetDriver() ) then
			base:SetPoseParameter("f_pitch",  15 )
			base:SetPoseParameter("f_yaw", 0 )

			return
		end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		base:SetPoseParameter("f_yaw", -Angles.y )
		base:SetPoseParameter("f_pitch",  -Angles.p )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local Col = base:GunnerInRange( ent:GetAimVector() ) and COLOR_WHITE or COLOR_RED

		local pod = ply:GetVehicle()

		if not IsValid( pod ) then return end

		if not ply:lvsKeyDown( "ZOOM" ) or pod:GetThirdPersonMode() then
			base:PaintCrosshairCenter( Pos2D, Col )
		end

		base:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	self:AddWeapon( weapon, 3 )
end


function ENT:CalcMainActivityPassenger( ply )
	local GunnerSeat = self:GetGunnerSeat()

	if not IsValid( GunnerSeat ) then return end

	if GunnerSeat:GetDriver() ~= ply then return end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "cwalk_revolver" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end

function ENT:UpdateAnimation( ply, velocity, maxseqgroundspeed )
	ply:SetPlaybackRate( 1 )

	if CLIENT then
		local GunnerSeat = self:GetGunnerSeat()

		if ply == self:GetDriver() then
			ply:SetPoseParameter( "vehicle_steer", self:GetSteer() /  self:GetMaxSteerAngle() )
			ply:InvalidateBoneCache()
		end

		if IsValid( GunnerSeat ) and GunnerSeat:GetDriver() == ply then
			local Pitch = math.Remap( self:GetPoseParameter( "f_pitch" ),0,1,-15,10)
			local Yaw = math.Remap( self:GetPoseParameter( "f_yaw" ),0,1,-5,5) 

			ply:SetPoseParameter( "aim_pitch", Pitch * 1.5 )
			ply:SetPoseParameter( "aim_yaw", Yaw * 1.5 )

			ply:SetPoseParameter( "head_pitch", -Pitch * 2 )
			ply:SetPoseParameter( "head_yaw", -Yaw * 3 )

			ply:SetPoseParameter( "move_x", 0 )
			ply:SetPoseParameter( "move_y", 0 )

			ply:InvalidateBoneCache()
		end

		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

	return false
end

