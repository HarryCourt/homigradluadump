-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\melee\\tier_0_base\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("melee_base","hg_wep_base",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "База ближнего боя"
SWEP.Category = "Оружие: Ближний Бой"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.WorldModel = "models/weapons/insurgency/w_marinebayonet.mdl"

SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true
SWEP.FiresUnderwater = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true

SWEP.Primary.Damage = 25
SWEP.Primary.Force = 40

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawSound = ""
SWEP.HitSound = "snd_jack_hmcd_knifehit.wav"
SWEP.FlashHitSound = "snd_jack_hmcd_knifestab.wav"
SWEP.ShouldDecal = true
SWEP.HoldType = "knife"
SWEP.DamageType = DMG_SLASH

SWEP.SubStamina = 2
SWEP.DamagePain = 0
SWEP.DamageBleed = 0

function Circle( x, y, radius, seg )
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end

local white = Color(200,200,200,200)
local white2 = Color(255,255,255,200)

function SWEP:DrawHUD()
	if not (GetViewEntity() == LocalPlayer()) then return end
	if LocalPlayer():InVehicle() then return end

	local tr = self:GetEyeTrace()

	if tr.Hit then
		local hitPos = tr.HitPos
		local pos = hitPos:ToScreen()

		local Size = math.Clamp(1 - ((hitPos - self.Owner:GetShootPos()):Length() / 80) ^ 2,.1,.3)

		surface.SetDrawColor(white)
		draw.NoTexture()
		Circle(pos.x,pos.y, 55 * Size, 32)

		surface.SetDrawColor(white2)
		draw.NoTexture()
		Circle(pos.x,pos.y, 40 * Size, 32)
	end
end

local size = Vector(3,3,3)

function SWEP:GetEyeTrace()
	local ply = self:GetOwner()
	
	local pos,ang = ply:Eye()

	local tr = {}
	tr.start = pos
	tr.endpos = pos + ang:Forward() * 80
	tr.filter = ply
	tr.mins = -size
	tr.maxs = size

	return util.TraceHull(tr)
end

function SWEP:CanPrimaryAttack()
	if self:IsHolstered() or not self:IsDeployed() or ((self.nextAttack or 0) > CurTime()) then return false end

	return true
end

SWEP.sndTwroh = {"weapons/melee/swing_light_sharp_01.wav","weapons/melee/swing_light_sharp_02.wav","weapons/melee/swing_light_sharp_03.wav"}

if SERVER then
	util.AddNetworkString("melee delay")
else
	net.Receive("melee delay",function()
		local wep = LocalPlayer():GetActiveWeapon()
		wep.nextAttack = net.ReadFloat()
	end)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local ply = self:GetOwner()

	local snd = self.sndTwroh or "weapons/slam/throw.wav"
	if TypeID(snd) == TYPE_TABLE then snd = snd[math.random(1,#snd)] end

	self.nextAttack = CurTime() + self.Primary.Delay / (1 + ply:GetNWFloat("adrenaline") / 2) + 1 * math.Clamp(1 - (ply:GetNWFloat("stamina")) / 100,0,1)

	if SERVER then
		/*net.Start("melee delay")
		net.WriteFloat(self.nextAttack)
		net.Send(ply)*/

		sound.EmitNET(self:EntIndex(),snd,60,1,(self.sndTwrohPitch or 100),self:GetPos())
		net.SendOmit(ply)

		ply.stamina = math.max(ply.stamina - self.SubStamina,0)
	elseif ply == LocalPlayer() then
		ply:EmitSound(snd,60,self.sndTwrohPitch or 100)
	end

	--ply:LagCompensation(true)

	local tr = self:GetEyeTrace()

	local ent = tr.Entity

	if SERVER then
		if tr.Hit then
			if IsValid(ent) and IsValid(ent:GetPhysicsObject()) and (string.find(ent:GetPhysicsObject():GetMaterial(),"flesh") or string.find(ent:GetPhysicsObject():GetMaterial(),"player")) then
				sound.Emit(nil,TypeID(self.FlashHitSound) == TYPE_TABLE and self.FlashHitSound[math.random(1,#self.FlashHitSound)] or self.FlashHitSound,75,1,100,tr.HitPos)
			else
				sound.Emit(nil,TypeID(self.HitSound) == TYPE_TABLE and self.HitSound[math.random(1,#self.HitSound)] or self.HitSound,75,1,100,tr.HitPos)
			end
		end

		if IsValid(ent) then
			local dmgTab = CreateDamageTab(ent,ply,self,self.Primary.Damage,self.DamageType)
			dmgTab.isMelee = true
			dmgTab.pos = tr.HitPos
			
			dmgTab.dmgPain = self.DamagePain
			dmgTab.dmgBleed = self.DamageBleed

			dmgTab.force = tr.Normal * self.Primary.Force

			if self.Attack then self:Attack(ent,tr,dmgTab) end

			ent:TakeDamageTab(dmgTab)
		end
	end

	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER and tr.Hit and self.ShouldDecal then
		local pos1 = tr.HitPos + tr.HitNormal
		local pos2 = tr.HitPos - tr.HitNormal
	
		if IsValid(obj) and obj:GetClass()=="prop_ragdoll" then
			util.Decal("Impact.Flesh",pos1,pos2)
		else
			util.Decal("ManhackCut",pos1,pos2)
		end
	end

	--ply:LagCompensation(false)
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
