-- "addons\\homigrad\\lua\\hinit\\weapons_hands_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_hands","base_weapon")
if not SWEP then return end

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
else
	SWEP.PrintName = "Руки"
	SWEP.Slot = 0
	SWEP.SlotPos = -100
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.BounceWeaponIcon = false
	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/wep_jack_hmcd_hands" )

	local HandTex, ClosedTex = surface.GetTextureID("vgui/hud/gmod_hand"), surface.GetTextureID("vgui/hud/gmod_closedhand")

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	-- Set us up the texture
		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetTexture( self.WepSelectIcon )

		-- Lets get a sin wave to make it bounce
		local fsin = 0


		-- Borders
		y = y + 10
		x = x + 10
		wide = wide - 20

		-- Draw that mother
		surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )

		-- Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end

	local white = Color(255,255,255)

	function SWEP:DrawHUD()
		if not (GetViewEntity() == LocalPlayer()) then return end
		if LocalPlayer():InVehicle() then return end

		local ply = self.Owner

		local Tr = ply:EyeTraceShoot(PlayerDisUse)
		if not Tr then return end

		local fraction = Tr.Fraction * 80000

		local pos = Tr.HitPos:ToScreen()
		local ent = Tr.Entity

		local Size = math.max(1 - fraction,0.25)

		if Tr.Hit then
			if not self.Owner:KeyDown(IN_ATTACK2) and IsValid(ent) and ent.HUDTarget then return end

			surface.SetDrawColor(255,255,255,255 * Size)
			
			local s = 64 * Size

			if self:CanPickup(ent) then
				s = 128 * Size
				
				if self.Owner:KeyDown(IN_ATTACK2) then
					surface.SetTexture(ClosedTex)
				else
					surface.SetTexture(HandTex)
				end

				surface.DrawTexturedRect(pos.x - s / 2,pos.y - s / 2,s,s)
			else
				draw.RoundedBox(s,pos.x - s / 2,pos.y - s / 2,s,s,white)
			end
			
			if IsValid(ent) then
				if ent:GetNoDraw() then return end

				local col

				if ent:IsPlayer() then
					col = ent:GetPlayerColor():ToColor()
				elseif ent.GetPlayerColor ~= nil then
					col = ent.playerColor:ToColor()
				else
					col = Color(255,255,255,255)
				end

				col.a = 255 * Size * 2 * (1 - InvOpenK)

				draw.DrawText(ent:IsPlayer() and ent:Name() or ent:GetNWString("Nickname") or "","H.45",pos.x,pos.y - 30,col,TEXT_ALIGN_CENTER)
			end
		end
	end
end

function JMod.WhomILookinAt(ply, cone, dist)
	/*local CreatureTr, ObjTr, OtherTr = nil, nil, nil

	for i = 1, 150 * cone do
		local Vec = (ply:GetAimVector() + VectorRand() * cone):GetNormalized()

		local Tr = util.QuickTrace(ply:GetAttachment(ply:LookupAttachment("eyes")).Pos, Vec * dist, {ply})

		if Tr.Hit and not Tr.HitSky and Tr.Entity then
			local Ent, Class = Tr.Entity, Tr.Entity:GetClass()

			if Ent:IsPlayer() or Ent:IsNPC() then
				CreatureTr = Tr
			elseif (Class == "prop_physics") or (Class == "prop_physics_multiplayer") or (Class == "prop_ragdoll") then
				ObjTr = Tr
			else
				OtherTr = Tr
			end
		end
	end

	if CreatureTr then return CreatureTr.Entity, CreatureTr.HitPos, CreatureTr.HitNormal end
	if ObjTr then return ObjTr.Entity, ObjTr.HitPos, ObjTr.HitNormal end
	if OtherTr then return OtherTr.Entity, OtherTr.HitPos, OtherTr.HitNormal end

	return nil, nil, nil*/

	local tr = ply:EyeTrace(dist)

	return tr.Entity,tr.HitPos
end

SWEP.SwayScale = 3
SWEP.BobScale = 3
SWEP.InstantPickup = true -- FF compat
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = " Ваши руки, ЛКМ/Перезарядка: поднять/опустить кулаки;\n В поднятом состоянии: ЛКМ - удар, ПКМ - блок;\n В опущенном состоянии: ПКМ - поднять предмет, R - проверить пульс;\n При удержании предмета: Перезарядка - зафиксировать предмет в воздухе, E - крутить предмет в воздухе."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "normal"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.UseHands = true
SWEP.AttackSlowDown = .5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ReachDistance = 125
SWEP.HomicideSWEP = true

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextIdle")
	self:NetworkVar("Bool", 2, "Fists")
	self:NetworkVar("Float", 1, "NextDown")
	self:NetworkVar("Bool", 3, "Blocking")
	self:NetworkVar("Bool", 4, "IsCarrying")
end

function SWEP:Initialize()
	self:SetNextIdle(CurTime() + 5)
	self:SetNextDown(CurTime() + 5)
	self:SetHoldType(self.HoldType)
	self:SetFists(false)
	self:SetBlocking(false)

	self:DrawShadow(false)
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then
		return
	end

	self:SetNextPrimaryFire(CurTime() + .5)
	self:SetFists(false)
	self:SetNextDown(CurTime())

	return true
end

function SWEP:Holster() return true end
function SWEP:CanPrimaryAttack() return true end

local pickupWhiteList = {
	["prop_ragdoll"] = true,
	["prop_physics"] = true,
	["prop_physics_multiplayer"] = true
}

function SWEP:CanPickup(ent)
	if not IsValid(ent) then return end

	if ent:IsNPC() then return false end
	if ent:IsPlayer() then return false end
	if ent:IsWorld() then return false end

	local class = ent:GetClass()

	local phys = ent:GetPhysicsObject()

	if pickupWhiteList[class] then return true end
	if IsValid(phys) and phys:IsMotionEnabled() then return true end

	return false
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if self:GetFists() then return end

	if SERVER then
		if IsValid(self.CarryEnt) then return end

		local ply = self.Owner
		local tr = ply:EyeTrace(PlayerDisUse)

		if not tr then return end
		
		local ent = tr.Entity

		if IsValid(ent) and self:CanPickup(ent) and not ent:IsPlayer() then
			local Dist = (tr.StartPos - tr.HitPos):Length()

			if Dist < self.ReachDistance then
				sound.Play("Flesh.ImpactSoft", self.Owner:GetShootPos(), 65, math.random(90, 110))

				self:SetCarrying(ent,tr.PhysicsBone,tr.HitPos,Dist)

				tr.Entity.Touched = true

				self:ApplyForce()
			end
		elseif IsValid(ent) and ent:IsPlayer() then
			local Dist = (self.Owner:GetShootPos() - tr.HitPos):Length()

			if Dist < self.ReachDistance then
				sound.Play("Flesh.ImpactSoft", self.Owner:GetShootPos(), 65, math.random(90, 110))
				self.Owner:SetVelocity(self.Owner:GetAimVector() * 20)
				ent:SetVelocity(-self.Owner:GetAimVector() * 50)
				self:SetNextSecondaryFire(CurTime() + .25)
			end
		end
	end
end

function SWEP:FreezeMovement()
	/*if self.Owner:KeyDown(IN_USE) and self.Owner:KeyDown(IN_ATTACK2) and self:GetNWBool( "Pickup" ) then
		return true
	end

	return false*/
end

if SERVER then
	util.AddNetworkString("get pulse")
else
	net.Receive("get pulse",function()
		chat.AddText(L("pulse_" .. net.ReadString()))
	end)
end

function SWEP:ApplyForce()
	local owner = self:GetOwner()

	local pos,ang = owner:Eye()

	local ent = self.CarryEnt

	local phys = ent:GetPhysicsObjectNum(self.CarryBone)
	if not IsValid(phys) then return end

	local TargetPos = phys:GetPos()

	if self.CarryPos then
		TargetPos = ent:LocalToWorld(self.CarryPos)
	end

	local vec = pos + ang:Forward():Mul(self.CarryDist) - TargetPos
	local len, mul = vec:Length(), ent:GetPhysicsObject():GetMass()

	if len > self.ReachDistance then
		self:SetCarrying()

		return
	end

	local Force = vec - phys:GetVelocity():Sub(owner:GetVelocity()) / 2
	Force = Force * 25 * math.Clamp(phys:GetMass() / 10,0.35,1)
	
	local ForceMagnitude = Force:Length()

	local ply = RagdollOwner(ent)

	if ent:GetClass() == "prop_ragdoll" then
		/*Force = Force * 5
		ForceMagnitude = ForceMagnitude / 10*/

		if owner:KeyPressed(IN_RELOAD) then
			if not ply then
				net.Start("get pulse")
				net.WriteString("0")
				net.Send(owner)
			else
				if ply.heartstop then
					net.Start("get pulse")
					net.WriteString("0")
					net.Send(owner)
				else
					local pulse = 1 / ply.pulse
					net.Start("get pulse")
					net.WriteString(pulse > 80 and 1 or (pulse > 60 and 2) or (pulse > 40 and 3) or 4)
					net.Send(owner)
				end
			end
		end
	end

	if SERVER then
		if owner:KeyDown(IN_DUCK) and owner:KeyDown(IN_ATTACK) then
			if ply and ply.fake and ply.heartstop then
				if self.firstTimePrint then self.Owner:ChatPrint("Вы начинаете проводить СЛР... (держите ЛКМ зажатым до появления пульса)") end
				self.firstTimePrint = false

				if (self.CPRThink or 0) < CurTime() and ply.heartstop then
					self.CPRThink = CurTime() + 0.5

					ply.o2 = math.min(ply.o2 + 0.1,1)
					ply.impulse = 3

					if ply.o2 == 1 then
						ply.heartstop = false
					end
					
					ent:EmitSound("physics/body/body_medium_impact_soft"..math.random(7)..".wav",90)
					ent:GetPhysicsObject():ApplyForceCenter(Vector(0,0,-1500))
				end
			end
		else
			self.firstTimePrint = true
		end
	end

	/*if ForceMagnitude > 6000 then
		self:SetCarrying()

		return
	end*/

	if self.CarryPos then
		phys:ApplyForceOffset(Force,ent:LocalToWorld(self.CarryPos))
	else
		phys:ApplyForceCenter(Force)
	end

	/*if self.Owner:KeyDown(IN_USE) then
		SetAng = SetAng or self.Owner:EyeAngles()
		local commands = self.Owner:GetCurrentCommand()
		local x,y = commands:GetMouseX(),commands:GetMouseY()

		if ent:IsRagdoll() then
			rotate = Vector(x,y,0) / 6
		else
			rotate = Vector(x,y,0)/4
		end

		phys:AddAngleVelocity(rotate)
	end*/

	phys:ApplyForceCenter(Vector(0,0,mul))
	phys:AddAngleVelocity(-phys:GetAngleVelocity() / 10)
end

function SWEP:OnRemove()

end

function SWEP:GetCarrying()
	return self.CarryEnt
end

function SWEP:SetCarrying(ent, bone, pos, dist)
	if IsValid(ent) then
		self:SetNWBool( "Pickup", true )
		self.CarryEnt = ent
		self.CarryBone = bone
		self.CarryDist = dist

		if not (ent:GetClass() == "prop_ragdoll") then
			self.CarryPos = ent:WorldToLocal(pos)
		else
			self.CarryPos = nil
		end
	else
		self:SetNWBool( "Pickup", false )
		self.CarryEnt = nil
		self.CarryBone = nil
		self.CarryPos = nil
		self.CarryDist = nil
	end
end

function SWEP:Think()
	local owner = self:GetOwner()

	local fists = self:GetFists()

	if owner:KeyDown(IN_ATTACK2) and not fists then
		if IsValid(self.CarryEnt) then self:ApplyForce() end
	elseif self.CarryEnt then
		self:SetCarrying()
	end

	if fists and owner:KeyDown(IN_ATTACK2) then
		self:SetNextPrimaryFire(CurTime() + .5)
		self:SetBlocking(true)
	else
		self:SetBlocking(false)
	end

	local HoldType = "fist"

	if fists then
		HoldType = "fist"
		local Time = CurTime()

		if self:GetBlocking() then
			self:SetNextDown(Time + 1)
			HoldType = "camera"
		end

		if (self:GetNextDown() < Time) or owner:KeyDown(IN_SPEED) then
			self:SetNextDown(Time + 1)
			self:SetFists(false)
			self:SetBlocking(false)
		end
	else
		HoldType = "normal"
	end

	if IsValid(self.CarryEnt) or self.CarryEnt then
		HoldType = "magic"
	end

	if self.Owner:KeyDown(IN_SPEED) then
		HoldType = "normal"
	end

	if SERVER then
		self:SetHoldType(HoldType)
	end
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()

	local side = "fists_left"

	if math.random(1, 2) == 1 then
		side = "fists_right"
	end

	if owner:KeyDown(IN_ATTACK2) then return end
	
	self:SetNextDown(CurTime() + 7)

	if not self:GetFists() then
		self:SetFists(true)
		self:SetNextPrimaryFire(CurTime() + 0.35)

		return
	end

	if self:GetBlocking() then return end
	if owner:KeyDown(IN_SPEED) then return end

	if not IsFirstTimePredicted() then return end

	owner:ViewPunch(Angle(0,0,math.random(-2,2)))
	owner:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		sound.Emit(self:EntIndex(),"weapons/slam/throw.wav",65,math.random(90,110))
		owner:ViewPunch(Angle(0,0,math.random(-2,2)))

		timer.Simple(0.075,function()
			if IsValid(self) then self:AttackFront() end
		end)
	end

	self:SetNextPrimaryFire(CurTime() + 0.35)
	self:SetNextSecondaryFire(CurTime() + 0.35)
end

function SWEP:AttackFront()
	if CLIENT then return end

	local owner = self:GetOwner()

	local tr = owner:EyeTrace(PlayerDisUse) //Ent,HitPos = JMod.WhomILookinAt(owner,.3,55)
	if not tr then return end

	local ent,hitPos = tr.Entity,tr.HitPos

	local dir = tr.Normal

	if IsValid(ent) or (ent and ent.IsWorld and ent:IsWorld()) then
		local SelfForce, Mul = -150, 1
		
		if self:IsEntSoft(ent) then
			SelfForce = 25

			if ent:IsPlayer() and IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon().GetBlocking and ent:GetActiveWeapon():GetBlocking() and not RagdollOwner(ent) then
				sound.Play("Flesh.ImpactSoft", hitPos, 65, math.random(90, 110))
			else
				sound.Play("Flesh.ImpactHard", hitPos, 65, math.random(90, 110))
			end
		else
			sound.Play("Flesh.ImpactSoft", hitPos, 65, math.random(90, 110))
		end

		local dmgTab = CreateDamageTab(ent,owner,self,5,DMG_CLUB)
		dmgTab.isFists = true
		dmgTab.force = dir * 5
		dmgTab.pos = hitPos

		ent:TakeDamageTab(dmgTab)

		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			if ent:IsPlayer() then ent:SetVelocity(dir * 150) end

			phys:ApplyForceOffset(dir * 5000,hitPos)
			//owner:SetVelocity(-AimVec * SelfForce * .8)
		end

		/*if ent:GetClass() == "func_breakable_surf" then
			if math.random(1,20) == 10 then ent:Fire("break","",0) end
		end

		if ent:GetClass() == "func_breakable" then
			if math.random(7,11) == 10 then ent:Fire("break","",0) end
		end*/
	end
end

--self.CarryDist
--self.CarryPos
--self.CarryBone

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end

	self:SetFists(false)
	self:SetBlocking(false)
end

function SWEP:DrawWorldModel() end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer() or RagdollOwner(ent)
end
