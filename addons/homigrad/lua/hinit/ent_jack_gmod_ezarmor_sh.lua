-- "addons\\homigrad\\lua\\hinit\\ent_jack_gmod_ezarmor_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿local ENT = oop.Reg("ent_jack_gmod_ezarmor","base_entity")
if not ENT then return end

ENT.Author = "Jackarunda"
ENT.Category = "JMod - EZ"
ENT.Information = "glhfggwpezpznore"
ENT.PrintName = "EZ Armor"
ENT.NoSitAllowed = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
---
ENT.JModEZstorable = true

ENT.itemType = "armor"

---
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 40
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(Angle(0, 0, 0))
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()
		JMod.Hint(ply, self.ClassName)
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)

		return ent
	end

	function ENT:Initialize()
		self.Specs = JMod.ArmorTable[self.ArmorName]
		self:SetModel(self.entmdl or self.Specs.mdl)
		self:SetMaterial(self.Specs.mat or "")

		if self.Specs.lbl then
			self:SetDTString(0, self.Specs.lbl)
		end

		if self.Specs.clr then
			self:SetColor(Color(self.Specs.clr.r, self.Specs.clr.g, self.Specs.clr.b))
		end

		--self.Entity:PhysicsInitBox(Vector(-10,-10,-10),Vector(10,10,10))
		if self.ModelScale and not self.Specs.gayPhysics then
			self:SetModelScale(self.ModelScale)
		end

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)

		if not IsValid(self:GetPhysicsObject()) then return end
		self:GetPhysicsObject():SetMass(10)
		
		self.Durability = self.Durability or self.Specs.dur

		if self.Specs.chrg then
			self.ArmorCharges = self.ArmorCharges or table.FullCopy(self.Specs.chrg)
		end

		---
		timer.Simple(.01, function()
			if not IsValid(self) or not IsValid(self:GetPhysicsObject()) then return end--lox
			
			self:GetPhysicsObject():SetMass(10)
			self:GetPhysicsObject():Wake()
		end)

		---
		self.EZID = self.EZID or JMod.GenerateGUID()

		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 then
			if data.Speed > 25 then
				self:EmitSound(util.GetSurfaceData(data.OurSurfaceProps).impactSoftSound)
			end
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		if dmginfo:GetDamage() >= 5 then
			self.Durability = self.Durability - dmginfo:GetDamage() / 2

			if self.Durability <= 0 then
				self:Remove()
			end
		end
	end
	
	local function GetAreSlotsClear(currentArmorItems,newArmorName)
		local NewArmorInfo = JMod.ArmorTable[newArmorName]
		local RequiredSlots = NewArmorInfo.slots
	
		for id, currentArmorData in pairs(currentArmorItems) do
			local CurrentArmorInfo = JMod.ArmorTable[currentArmorData.name]
	
			for newSlotName, newCoverage in pairs(RequiredSlots) do
				for oldSlotName, oldCoverage in pairs(CurrentArmorInfo.slots) do
					if oldSlotName == newSlotName then return false, id end
				end
			end
		end
	
		return true, nil
	end

	ENT.UsePreStop = true

	function ENT:Use(ply)
		local have = not GetAreSlotsClear(ply.EZarmor.items,self.ArmorName)

		if ply:KeyDown(IN_WALK) then
			if IsValid(self.inv) then
				if #self.inv:GetAllItems() ~= 0 then
					self.inv:Open(ply) return
				end
			end
		else
			if ply:KeyDown(IN_SPEED) and (not IsValid(self.inv) or #self.inv:GetAllItems() == 0) then
				if ply:KeyDown(IN_SPEED) then
					ItemPickup(ply,self) return
				end
			end
		
			if not have then
				JMod.EZ_Equip_Armor(ply,self) return
			end
		end

		ply:PickupObject(self)

		return
	end

	function ENT:InvShouldInsertItem(slot,item)
		local parent = slot.inv.parent

		if parent:IsPlayer() and GetAreSlotsClear(parent.EZarmor.items,item.ent.ArmorName) then return true end
	end

	function ENT:InvInsertItem(slot,item)
		local inv = slot.inv
		local parent = inv.parent
		local ent = item.ent

		if not parent:IsPlayer() or item.type ~= "armor" then return end
		
		if GetAreSlotsClear(parent.EZarmor.items,ent.ArmorName) then
			if item.inv then item.inv:PopItem(item) end

			if IsValid(ent.inv) then ent.inv:CloseAll() end

			JMod.EZ_Equip_Armor(parent,ent)

			return true
		end
	end
elseif CLIENT then
	function ENT:Draw()
		local Ang, Pos = self:GetAngles(), self:GetPos()
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(Pos)
		local DetailDraw = Closeness < 18000 -- cutoff point is 200 units when the fov is 90 degrees
		self:DrawModel()
		local Label = self:GetDTString(0)

		if DetailDraw and Label and Label ~= "" then
			local Up, Right, Forward, TxtCol = Ang:Up(), Ang:Right(), Ang:Forward(), Color(0, 0, 0, 220)
			Ang:RotateAroundAxis(Ang:Up(), 90)
			cam.Start3D2D(Pos + Up * 4.3 - Right * 2 + Forward * 6, Ang, .03)
			draw.SimpleText("JACKARUNDA INDUSTRIES", "JMod-Stencil", 0, 0, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(Label, "JMod-Stencil", 0, 100, TxtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end

	language.Add("ent_jack_gmod_ezarmor", "EZ Armor")

	local white = Color(255,255,255)

	function ENT:HUDTarget(ent,k,w,h)
        white.a = 255 * k
        local anim = (50 * (1 - k))

        draw.SimpleText(self.PrintName,"H.18",w / 2,h / 2 + 25 * k + anim,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end

	function ENT:DrawInv(item,w,h,butt)
		surface.SetMaterial(EntityIcon(item.spawnname))
		local size = h - 14 + butt.hovered * 5
	
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(w / 2 - size / 2 + 1,h / 2 - size / 2 + 1,size,size)
	end
end