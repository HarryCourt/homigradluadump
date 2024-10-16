-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\tier_0_fumo_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_fumo","npc_alternate")
if not ENT then return end

if SERVER then resource.AddWorkshop("2493325727") end

ENT.JumpSound = Sound("fumo/jump.mp3")
ENT.JumpHighSound = Sound("fumo/spring.mp3")

ENT.TauntSounds = {
    Sound("fumo/tooslow.mp3"),
    Sound("fumo/stepitup.mp3"),
    Sound("fumo/tooeasy.mp3"),
    Sound("fumo/pieceofcake.mp3")
}

ENT.Music = Sound("fumo/panic.mp3")
ENT.MusicLevel = 75
ENT.MusicPosLocal = true

ENT.SpriteMat = Material("fumo/npc_fumo.png", "smooth mips")

ENT.PrintName = "Sanic.png"
ENT.Category = "Nextbot | Touhou"

function ENT:GetMusicDSP(point,pos,filter)
	local pen = sound.Trace(pos,1024,16,filter)

	if pen <= 0.1 then
		return 0
	elseif pen <= 0.7 then
		return 14
	else
		return 14
	end
end

ENT.Speed = 1000
ENT.Acceleration = 5000
ENT.Deceleration = 5000

ENT.FastSpeed = 800
ENT.FastAcceleration = 800
ENT.FastDeceleration = 800

ENT.AngrySpeed = 2000
ENT.Acceleration = 2000
ENT.Deceleration = 2000

ENT.ScanTargetDistance = 9999
ENT.MusicDistance = 2500

ENT.AttackWait = false
ENT.AttackDelay = 0.2
ENT.AttackInterval = 0.5

ENT.FastSpeed = 1000

ENT.Acceleration = 1250
ENT.Deceleration = 1250

ENT.FastTimeFollow = 30
ENT.AngryTimeFollow = 60

ENT.AngryFast = 3
ENT.AngryKill = 12

ENT.MusicVolume = 0.2

ENT.Angry = 0

function ENT:AttackEntPre(ent)
    self.Angry = self.Angry + 1

    sound.Emit(ent:EntIndex(),"fumo/jump.mp3",511,1,200,nil,nil,{self,ent})
end

function ENT:AttackEntPost(ent)
    local currentTime = CurTime()

    if currentTime - self.LastTaunt > self.TauntInterval then
        self.LastTaunt = currentTime
        sound.Emit(self:EntIndex(),table.Random(self.TauntSounds),350,1,math.random(95,105),nil,self:GetPos())
    end
end

ENT.Stun = 0
ENT.Stun2 = 0
ENT.SoundDetect = Sound("homigrad/detect!.mp3")
ENT.DetectDelay = 1.25
ENT.WantSee = true

function ENT:ChaseUpdate(currentTime,startFollowTime)
	self.LastHidingPlaceScan = 0

    local speed,acc,dec = self.Speed,self.Acceleration,self.Deceleration

    if self.WantSee and self:CanSeeYou(self,self.CurrentTarget:EyePos()) then
        self.WantSee = false
        self.Stun = currentTime + self.DetectDelay
        self.Stun2 = currentTime + 0.25
        self:SetNWFloat("Detect",currentTime)

        sound.Emit(self:EntIndex(),self.SoundDetect,350,1,100,nil,self:GetPos())
    end

    if self.Stun2 < currentTime and self.Stun > currentTime then
        self:SetNWString("State","Detect")

        return false
    end

    if self.Stun2 > currentTime then
        if currentTime - self.LastPathRecompute > self.RepathInterval then
            self.LastPathRecompute = currentTime
            self:RecomputeTargetPath()
        end
    
        self:MovePathUpdate()
    
        self:SetNWString("State","Detect")
        
        return false
    end

    if self.Angry < self.AngryFast and startFollowTime - currentTime + self.FastTimeFollow < 0 then
        self.Angry = self.AngryFast

        speed = self.FastSpeed or speed
        acc = self.FastAcceleration or acc
        dec = self.FastDeceleration or dec
    elseif self.Angry < self.AngryKill and startFollowTime - currentTime + self.AngryTimeFollow < 0 then
        self.Angry = self.AngryKill

        speed = self.AngrySpeed or speed
        acc = self.AngryAcceleration or acc
        dec = self.AngryDeceleration or dec
    end

    self.loco:SetDesiredSpeed(speed)
	self.loco:SetAcceleration(acc)
	self.loco:SetDeceleration(dec)

    self:SetNWInt("Angry",self.Angry)

	self:AttackThink(currentTime,self.Angry >= self.AngryFast and self.AttackInterval / 2)

	self:FussAmbient_Interval(currentTime)
	self:RecomputeTargetPath_Interval(currentTime)

	self:MovePathUpdate()
	self:SkyThink(currentTime)
end

function ENT:GoAwayUpdate()
    self.WantSee = false
end

function ENT:HideUpdate(currentTime)
    if self:GetNWString("State","Hide") == "Hide" then
        self.WantSee = true
        self.Angry = 0
        self:SetNWInt("Angry",self.Angry)
    end

	self:HideThink(currentTime)
end

local mat = Material("color")
local angry = Material("homigrad/scp/angry.png")
local z = Material("homigrad/scp/z.png")
local detect = Material("homigrad/scp/detect.png")

function ENT:DrawSprite(pos,normal,size,color,rot)
    local hide = self:GetNWString("State") == "Hide"

    local time = CurTime()

    local k = self:GetNWFloat("Angry")
    local state = (k >= self.AngryKill and 2) or (k >= self.AngryFast and 1) or 0

    if hide then
        rot = rot + math.cos(time * 8)
    else
        local rotAdd = (state == 2 and math.cos(time * 360 * 2) * 2) or (state == 1 and math.cos(CurTime() * 360 * 2) * 8) or math.cos(CurTime() * 360)
        rot = rot + rotAdd
    end

	render.DrawQuadEasy(pos,normal,size + (state == 1 and math.cos(time* 16) * 16 or 0),size,color,rot)

    cam.Start3D2D(pos + normal,normal:Angle() + Angle(90,0,0),1)
        if state > 0 then
            surface.SetMaterial(mat)
            surface.SetDrawColor(0,0,0)
            surface.DrawTexturedRectRotated(-20,10,1,16,-45 + rot)
            surface.DrawTexturedRectRotated(-20,-15,1,16,45 + rot)

            if state > 1 then
                surface.SetDrawColor(255,255,255)
                surface.SetMaterial(angry)
                surface.DrawTexturedRectRotated(-40,-40,32,32,45 - rot)
            end
        end

        if hide then
            surface.SetMaterial(z)
            surface.SetDrawColor(255,255,255)

            local x,y = -time % 1 * 16,math.cos(time * 16) * 6 - time % 1 * 16

            surface.DrawTexturedRectRotated(-60 + x,-40 + y,32,32,45 + time % 1 * 25)
        end

        local anim_pos = self:GetNWFloat("Detect",0) - time + self.DetectDelay

        if anim_pos > 0 then
            surface.SetMaterial(detect)
            surface.SetDrawColor(255,255,255)

            surface.DrawTexturedRectRotated(-80 - (self.DetectDelay - anim_pos) * 16,0,64,64,90)
        end
    cam.End3D2D()
end