-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\weapon_taser_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_taser","hg_wep_base")
if not SWEP then return end

SWEP.PrintName = "Электрошокер"
SWEP.Author = "Homigrad"
SWEP.Instructions = "Электрическое возбуждение передается нервным клеткам, вызывая в основном болевой шок, а также кратковременные судороги и состояние «ошарашенности», дезориентации."
SWEP.Slot = 2
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.Category 				= "Предметы"

SWEP.WorldModel = "models/realistic_police/taser/w_taser.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "AR2AltFire"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsItemAng = Angle(0,-10,0)
SWEP.dwsItemPos = Vector(-3.5,0,-1.8)
SWEP.dwsItemFOV = -14

SWEP.dwmUp = 0.5
SWEP.dwmRight = 0
SWEP.dwmForward = 0

SWEP.dwmARight = 180
SWEP.dwmAUp = 200
SWEP.dwmAForward = 0
SWEP.HoldType = "revolver"

SWEP.itemType = "other"

SWEP.EnableTransformModel = true

SWEP.wmVector = Vector(0,0,0)
SWEP.wmAngle = Angle(-20,0,185)


local hull = Vector(10,10,10)

function SWEP:PrimaryAttack()
	if CLIENT then return end

	if self:Clip1() <= 0 then return nil end
	self:TakePrimaryAmmo(1)

	local ply = self.Owner
	local att = self:GetWorldModel():GetAttachment(1)
	
	ply:EmitSound("ambient/energy/zap3.wav")

	local dir = ply:EyeAngles():Forward()

	local tr = {
		start = att.Pos,
		endpos = att.Pos + dir * 250,
		filter = ply,
		mins = -hull,
		maxs = hull,
		mask = MASK_SHOT_HULL
	}

	local trResult = util.TraceHull(tr)

	local effectdata = EffectData()
	effectdata:SetOrigin(tr.start)
	effectdata:SetMagnitude(5)
	effectdata:SetNormal(dir * 50)
	util.Effect("Sparks",effectdata)

	local ent = trResult.Entity
	ent = (ent:IsPlayer() and ent) or RagdollOwner(ent)

	if ent and ent:Alive() then
		ent:EmitSound("hostage/hpain/hpain" .. math.random(1,6) .. ".wav")

		Stun(ent)
	end
end

function SWEP:Reload()
if timer.Exists("reload"..self:EntIndex()) or self:Clip1()>=self:GetMaxClip1() or self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )<=0 then return nil end
	if self.Owner:IsSprinting() then return nil end
	self:GetOwner():SetAnimation(PLAYER_RELOAD)
	--self:EmitSound(self.ReloadSound,60,100,0.8,CHAN_AUTO)
	timer.Create( "reload"..self:EntIndex(), 1.5, 1, function()
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetActiveWeapon()==self then
			local oldclip = self:Clip1()
			self:SetClip1(math.Clamp(self:Clip1()+self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ),0,self:GetMaxClip1()))
			local needed = self:Clip1()-oldclip
			self.Owner:SetAmmo(self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )-needed, self:GetPrimaryAmmoType())
		end
	end)
end

function SWEP:SecondaryAttack()
end

if CLIENT then return end

function Stun(Entity)
	if Entity:HasGodMode() then return end

	if Entity:IsPlayer() then
		FakeDown(Entity)
		timer.Create("StunTime"..Entity:EntIndex(), 8, 1, function() end)
		local fake = Entity:GetNWEntity("Ragdoll")
		timer.Create( "StunEffect"..Entity:EntIndex(), 0.1, 80, function()
			local rand = math.random(1,50)
			if rand == 50 then
			RagdollOwner(fake):Say("drop")
			end
			RagdollOwner(fake).pain = RagdollOwner(fake).pain + 1
			fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
			fake:EmitSound("ambient/energy/spark2.wav")
		end)
	elseif Entity:IsRagdoll() then
		if RagdollOwner(Entity) then
			RagdollOwner(Entity):Say("drop")
			timer.Create("StunTime"..RagdollOwner(Entity):EntIndex(), 8, 1, function() end)
			local fake = Entity
			timer.Create( "StunEffect"..RagdollOwner(Entity):EntIndex(), 0.1, 80, function()
				if rand == 50 then
					RagdollOwner(fake):Say("drop")
				end
				RagdollOwner(fake).pain = RagdollOwner(fake).pain + 1
				fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
				fake:EmitSound("ambient/energy/spark2.wav")
			end)
		else
			local fake = Entity
			timer.Create( "StunEffect"..Entity:EntIndex(), 0.1, 80, function()
				fake:GetPhysicsObjectNum(1):SetVelocity(fake:GetPhysicsObjectNum(1):GetVelocity()+Vector(math.random(-55,55),math.random(-55,55),0))
				fake:EmitSound("ambient/energy/spark2.wav")
			end)
		end
	end
end//лееееееееееееееееееееееееееееееееееееееееень

event.Add("Fake Up","Stun",function(ply)
	if timer.Exists("StunTime" .. ply:EntIndex()) then return false end
end)