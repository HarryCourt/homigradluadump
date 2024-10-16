-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\npc_komeiji_fumo_friendly_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_komeiji_fumo_friendly","npc_fumo")
if not ENT then return end

if SERVER then resource.AddWorkshop("2830488783") end

ENT.PrintName = "komeiji friendly"

ENT.Speed = 800
ENT.Acceleration = 800
ENT.Deceleration = 800

ENT.JumpSound = Sound("npc_komeiji_fumo_enemy/jump.mp3")
ENT.JumpHighSound = Sound("npc_komeiji_fumo_enemy/jump.mp3")
ENT.TauntSounds = {
	Sound("npc_komeiji_fumo_enemy/fumo.mp3"),
	Sound("npc_komeiji_fumo_enemy/fumog.mp3"),
	Sound("npc_komeiji_fumo_enemy/fumosus.mp3"),
	Sound("npc_komeiji_fumo_enemy/komeiji.mp3"),
}

ENT.Music = Sound("npc_komeiji_fumo_enemy/alarm.mp3")
ENT.MusicVolume = 0.4

ENT.SpriteMat = Material("npc_komeiji_fumo_friendly/komeiji_fumo_friendly.png")

ENT.Acceleration = 100
ENT.Deceleration = 500

ENT.MaxHealth = 1000

local VECTOR_HIGH = Vector(0,0,16384)

local trace = {
	mask = MASK_SOLID_BRUSHONLY
}

function ENT:RecomputeTargetPath()
	if CurTime() - self.LastPathingInfraction < self.PathInfractionTimeout then return end

	local targetPos = -self.CurrentTarget:GetPos()

	trace.start = targetPos
	trace.endpos = targetPos - VECTOR_HIGH
	trace.filter = self.CurrentTarget
	local tr = util.TraceEntity(trace, self.CurrentTarget)

	if tr.Hit and util.IsInWorld(tr.HitPos) then targetPos = tr.HitPos end

	local rTime = SysTime()
	self.MovePath:Compute(self,targetPos)

	if SysTime() - rTime > 0.005 then self.LastPathingInfraction = CurTime() end
end

function ENT:OnInjured(dmg)
	dmg = dmg:GetDamage()

	self:SetHealth(self:Health() - dmg)
	if self:Health() <= 0 then self:Remove() end

	if self:Health() < self:GetMaxHealth() then
		self:SetNWString("State","Run")
	end
	
	if self:Health() < self:GetMaxHealth() - 100 then
		local ent = ents.Create("npc_komeiji_fumo_enemy")
		ent:SetPos(self:GetPos())
		ent:Spawn()

		self:Remove()
	end
end