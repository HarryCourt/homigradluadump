-- "lua\\weapons\\wep_jack_gmod_ezshovel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿-- AdventureBoots 2023
AddCSLuaFile()
SWEP.Base = "wep_jack_gmod_ezmeleebase"
SWEP.PrintName = "EZ Shovel"
SWEP.Author = "Jackarunda"
SWEP.Purpose = ""
JMod.SetWepSelectIcon(SWEP, "entities/ent_jack_gmod_ezshovel")
SWEP.ViewModel = "models/weapons/hl2meleepack/v_shovel.mdl"
SWEP.WorldModel = "models/props_junk/shovel01a.mdl"
SWEP.BodyHolsterModel = "models/props_junk/shovel01a.mdl"
SWEP.BodyHolsterSlot = "back"
SWEP.BodyHolsterAng = Angle(-85, 0, 90)
SWEP.BodyHolsterAngL = Angle(-93, 0, 90)
SWEP.BodyHolsterPos = Vector(3, -10, -3)
SWEP.BodyHolsterPosL = Vector(4, -10, 3)
SWEP.BodyHolsterScale = .75
SWEP.ViewModelFOV = 50
SWEP.Slot = 1
SWEP.SlotPos = 6

SWEP.VElements = {
}

SWEP.WElements = {
	["shovel"] = {
		type = "Model",
		model = "models/props_junk/shovel01a.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(5, 2.3, -12),
		angle = Angle(0, 180, 5),
		size = Vector(1, 1, 1),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

--
SWEP.DropEnt = "ent_jack_gmod_ezshovel"
SWEP.HitDistance		= 64
SWEP.HitInclination		= 0.4
SWEP.HitPushback		= 500
SWEP.MaxSwingAngle		= 120
SWEP.SwingSpeed 		= 1
SWEP.SwingPullback 		= 70
SWEP.PrimaryAttackSpeed = 1
SWEP.SecondaryAttackSpeed 	= 1
SWEP.DoorBreachPower 	= 1
--
SWEP.SprintCancel 	= true
SWEP.StrongSwing 	= true
--
SWEP.SwingSound 	= Sound( "Weapon_Crowbar.Single" )
SWEP.HitSoundWorld 	= Sound( "Canister.ImpactHard" )
SWEP.HitSoundBody 	= Sound( "Flesh.ImpactHard" )
SWEP.PushSoundBody 	= Sound( "Flesh.ImpactSoft" )
--
SWEP.IdleHoldType 	= "melee2"
SWEP.SprintHoldType = "melee2"
--
SWEP.WhitelistedResources = {JMod.EZ_RESOURCE_TYPES.SAND, JMod.EZ_RESOURCE_TYPES.CLAY, JMod.EZ_RESOURCE_TYPES.WATER}

function SWEP:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "TaskProgress")
	self:NetworkVar("String", 0, "ResourceType")
end

function SWEP:CustomInit()
	self:SetHoldType("melee2")
	self:SetTaskProgress(0)
	self:SetResourceType("")
	self.NextTaskTime = 0
end

function SWEP:CustomThink()
	local Time = CurTime()
	if self.NextTaskTime < Time then
		self:SetTaskProgress(0)
		self.NextTaskTime = Time + 1.5
	end

	if CLIENT then
		if self.ScanResults then
			self.LastScanTime = self.LastScanTime or Time
			if self.LastScanTime < (Time - 30) then
				self.ScanResults = nil
				self.LastScanTime = nil
			end
		end
	end
end

local DirtTypes = {
	MAT_DIRT,
	MAT_SAND
}

function SWEP:OnHit(swingProgress, tr)
	local Owner = self:GetOwner()
	--local SwingCos = math.cos(math.rad(swingProgress))
	--local SwingSin = math.sin(math.rad(swingProgress))
	local SwingAng = Owner:EyeAngles()
	local SwingPos = Owner:GetShootPos()
	local StrikeVector = tr.HitNormal
	local StrikePos = (SwingPos - (SwingAng:Up() * 15))

	if IsValid(tr.Entity) then
		local PickDam = DamageInfo()
		PickDam:SetAttacker(self.Owner)
		PickDam:SetInflictor(self)
		PickDam:SetDamagePosition(StrikePos)
		PickDam:SetDamageType(DMG_CLUB)
		PickDam:SetDamage(math.random(30, 50))
		PickDam:SetDamageForce(StrikeVector:GetNormalized() * 30)
		tr.Entity:TakeDamageInfo(PickDam)
	end

	if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or string.find(tr.Entity:GetClass(),"prop_ragdoll") then
		tr.Entity:SetVelocity( self.Owner:GetAimVector() * Vector( 1, 1, 0 ) * self.HitPushback )
		self:SetTaskProgress(0)
		if tr.Entity.IsEZcorpse then
			local GravePos = util.QuickTrace(tr.HitPos, Vector(0, 0, -9e9), {tr.Entity}).HitPos
			timer.Simple(0.2, function()
				--if IsValid(tr.Entity) then
					local GraveStone = ents.Create("prop_physics")
					GraveStone:SetModel("models/props_c17/gravestone002a.mdl")
					GraveStone:SetPos(GravePos)
					GraveStone:SetAngles(Angle(0, 0, 0))
					GraveStone:Spawn()
					GraveStone:Activate()
					local WeldTr = util.QuickTrace(GravePos + Vector(0, 0, 20), Vector(0, 0, -40), {GraveStone, tr.Entity, self.Owner})
					if WeldTr.Hit then
						GraveStone:SetPos(WeldTr.HitPos)
						local StoneAng = WeldTr.HitNormal:Angle()
						StoneAng:RotateAroundAxis(StoneAng:Right(), -90)
						GraveStone:SetAngles(StoneAng)
						GraveStone:SetPos(GravePos + StoneAng:Up() * 25)
						constraint.Weld(WeldTr.Entity, GraveStone, 0, 0, 10000, false, false)
					end
				--end
			end)
			SafeRemoveEntityDelayed(tr.Entity, 0.1)
		end
	elseif tr.Entity:IsWorld() and (table.HasValue(DirtTypes, util.GetSurfaceData(tr.SurfaceProps).material)) then
		local Message = JMod.EZprogressTask(self, tr.HitPos, self.Owner, "mining", JMod.GetPlayerStrength(self.Owner) ^ .25)

		if Message then
			if (tr.MatType == MAT_SAND) or (tr.MatType == MAT_DIRT) then
				self:SetResourceType(JMod.EZ_RESOURCE_TYPES.SAND)
				self:SetTaskProgress(100)
				JMod.MachineSpawnResource(self, JMod.EZ_RESOURCE_TYPES.SAND, math.random(5, 10), self:WorldToLocal(tr.HitPos + Vector(0, 0, 8)), Angle(0, 0, 0), nil, 200)
			else
				self:Msg(Message)
				self:SetTaskProgress(0)
				self:SetResourceType("")
			end
		else
			sound.Play("Dirt.Impact", tr.HitPos + VectorRand(), 75, math.random(50, 70))
			self:SetTaskProgress(self:GetNW2Float("EZminingProgress", 0))
		end

		if (math.random(1, 1000) == 1) then 
			local Deposit = JMod.GetDepositAtPos(nil, tr.HitPos, 1.5) 
			if ((tr.MatType == MAT_SAND) or (JMod.NaturalResourceTable[Deposit] and JMod.NaturalResourceTable[Deposit].typ == JMod.EZ_RESOURCE_TYPES.SAND)) then
				timer.Simple(math.Rand(1, 2), function() 
					local npc = ents.Create("npc_antlion")
					npc:SetPos(tr.HitPos + Vector(0, 0, 30))
					npc:SetAngles(Angle(0, math.random(0, 360), 0))
					npc:SetKeyValue("startburrowed","1")
					npc:Spawn()
					npc:Activate()
					npc:Fire("unburrow", "", 0)
				end)
			end
		end
	else
		sound.Play("Canister.ImpactHard", tr.HitPos, 10, math.random(75, 100), 1)
		self:SetTaskProgress(0)
	end
end

function SWEP:FinishSwing(swingProgress)
	if swingProgress >= self.MaxSwingAngle then
		self:SetTaskProgress(0)
	else
		self.NextTaskTime = CurTime() + self.PrimaryAttackSpeed + 1
	end
end

if CLIENT then
	local LastProg = 0

	function SWEP:DrawHUD()
		if GetConVar("cl_drawhud"):GetBool() == false then return end
		local Ply = self.Owner
		if Ply:ShouldDrawLocalPlayer() then return end
		local W, H = ScrW(), ScrH()

		local Prog = self:GetTaskProgress()

		if Prog > 0 then
			draw.SimpleTextOutlined("Digging... "..self:GetResourceType(), "Trebuchet24", W * .5, H * .45, Color(255, 255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 50))
			draw.RoundedBox(10, W * .3, H * .5, W * .4, H * .05, Color(0, 0, 0, 100))
			draw.RoundedBox(10, W * .3 + 5, H * .5 + 5, W * .4 * LastProg / 100 - 10, H * .05 - 10, Color(255, 255, 255, 100))
		end

		LastProg = Lerp(FrameTime() * 5, LastProg, Prog)
	end
end