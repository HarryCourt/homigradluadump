-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\weapon_molotok_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_molotok","hg_wep_base")
if not SWEP then return end


SWEP.PrintName 				= "Молоток"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Ударный ручной инструмент, применяемый для забивания гвоздей, разбивания предметов и других работ\n\nЛКМ - бить, ПКМ+Е - изменить режим (забивание/отдирание гвоздей), ПКМ - забить/отдереть гвоздь (в зависимости от режима)"
SWEP.Category 				= "Предметы"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false


SWEP.Primary.Damage = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 180

SWEP.Secondary.Automatic	= true

SWEP.Slot					= 1
SWEP.SlotPos				= 3
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= "models/weapons/w_jjife_t.mdl"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsPos = Vector(0,40,0)
SWEP.dwsItemPos = Vector(-4.5,0,-0.4)
SWEP.dwsItemAng = Angle(-15,0,0)

SWEP.vbw = true
SWEP.vbwPistol = true
SWEP.vbwPos = Vector(-7,2,0)

SWEP.dwr_reverbDisable = true

SWEP.DrawSound = "weapons/melee/holster_in_light.wav"

if SERVER then
    SWEP:Event_Add("Deploy","Snd",function(self) sound.Emit(self,self.DrawSound) end)
end

SWEP.HitSound = "snd_jack_hmcd_hammerhit.wav"
SWEP.FlashHitSound = "Impact.Flesh"
SWEP.HoldType = "melee"
SWEP.DamageType = DMG_CLUB

local tr = {}

local step
step = function(parent,list)
    local world = game.GetWorld()

    for i,info in pairs(constraint.GetTable(parent)) do
        local ent1,ent2 = info.Ent1,info.Ent2

        if not table.HasValue(list,ent1) and ent1 ~= world then
            list[#list + 1] = ent1
            
            step(ent1,list)
        end

        if not table.HasValue(list,ent2) and ent2 ~= world then
            list[#list + 2] = ent2

            step(ent2,list)
        end
    end
end

local function TwoTrace(pos,dir,filter)
    tr.start = pos

    tr.endpos = tr.start + dir * 75
    tr.filter = {filter}

    local result1 = util.TraceLine(tr)
    if not IsValid(result1.Entity) then return end

    tr.start = result1.HitPos
    tr.endpos = tr.start + dir * 25

    tr.filter[2] = result1.Entity

    if SERVER then step(result1.Entity,tr.filter) end

    local result2 = util.TraceLine(tr)
    if not result2.Hit then return end

    return result1,result2
end

local sndsThrow = {"weapons/melee/swing_fists_01.wav","weapons/melee/swing_fists_02.wav","weapons/melee/swing_fists_03.wav"}

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    owner:SetAnimation(PLAYER_ATTACK1)

    if CLIENT then return end

    self:OutHoldEnt()

    self:SetNextPrimaryFire(CurTime() + 1 / (owner.stamina / 100) )
    self:SetNextSecondaryFire(CurTime() + 2)

    sound.Emit(self,sndsThrow[math.random(1,#sndsThrow)],60,1,250)

    owner.stamina = math.max(owner.stamina - 5,0)

    local tr = owner:EyeTrace(PlayerDisUse)
    local ang = tr.Normal:Angle()

    if tr.HitWorld then sound.Emit(self,self.HitSound,75) end

    local nail = owner:FindItems("ent_nail_molotok")[1]

    if nail then
        local ent = tr.Entity
        local t1,t2 = TwoTrace(tr.HitPos,tr.Normal,owner)

        if t1 then
            local ent1,ent2 = t1.Entity,t2.Entity

            if not IsValid(ent1:GetPhysicsObject()) or not IsValid(ent2:GetPhysicsObject()) then return end

            nail:SetPos(t1.HitPos)
            
            local ang = tr.Normal:Angle()
            ang:RotateAroundAxis(ang:Up(),90)

            nail:SetAngles(ang)
            nail:Spawn()
            nail:Parent(ent1,ent2,t1.PhysicsBone,t2.PhysicsBone)
            
            sound.Emit(self,"snd_jack_hmcd_hammerhit.wav")

            owner:ViewPunch(Angle(-3,0,0))
        end
    end

    if IsValid(ent) then
        local dmginfo = DamageInfo()
        dmginfo:SetDamageType(self.DamageType)
        dmginfo:SetAttacker(owner)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamagePosition(tr.HitPos)
        dmginfo:SetDamageForce(ang:Forward() * self.Primary.Force * 7)

        if ent:IsNPC() or ent:IsPlayer() then
            sound.Emit(self,self.FlashHitSound,75)
        else
            if IsValid(ent:GetPhysicsObject()) then
                local pos1 = tr.HitPos + tr.HitNormal
                local pos2 = tr.HitPos - tr.HitNormal

                if ent:GetClass() == "prop_ragdoll" then
                    sound.Emit(self,self.FlashHitSound,75)

                    util.Decal("Impact.Flesh",pos1,pos2)
                else
                    sound.Emit(self,self.HitSound,75)

                    util.Decal("ManhackCut",pos1,pos2)
                end
            end
        end

        ent:TakeDamageInfo(dmginfo)
    end
end

local empty = {}

function SWEP:SecondaryAttack()
    if CLIENT then return end

    self:OutHoldEnt()

    local owner = self:GetOwner()
    
    local tr = owner:EyeTraceShoot(PlayerDisUse,true)
    tr.mask = MASK_ALL
    tr = util.TraceLine(tr)

    local ent = tr.Entity

    if IsValid(ent) and ent:GetClass() == "ent_nail_molotok" then
        ent:UnParent()
        ent:Remove()

        self:SetClip(self:Clip() + 1)

        self:SetNextSecondaryFire(CurTime() + 1)

        owner:ViewPunch(Angle(-1,0,-3))
    end
end


if SERVER then
    hook.Add("Fake Up","molotok",function(ply,rag)
        if (rag and rag.IsWeld or 0) > 0 then return false end
    end)

    function SWEP:OutHoldEnt()

        local ent = self.holdEnt

        if IsValid(ent) then
            ent:SetCollisionGroup(COLLISION_GROUP_NONE)
            ent:SetVelocity(Vector())
        end

        self.holdEnt = nil
        self.mode = nil
    end

    function SWEP:Think()
        local owner = self:GetOwner()

        if not self.mode and not owner:KeyDown(IN_RELOAD) then self:OutHoldEnt() return end

        if not IsValid(self.holdEnt) then
            local tr = owner:EyeTrace(PlayerDisUse)
            local ent = tr.Entity
            
            if IsValid(ent) then
                local phys = ent:GetPhysicsObject()

                if not IsValid(phys) then return end
                if not phys:IsMotionEnabled() then return end
                if phys:GetMass() > 200 then return end
                if ent:GetCollisionGroup() ~= COLLISION_GROUP_NONE then return end

                self.holdEnt = ent

                ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            end
        else
            local ent = self.holdEnt
            if not IsValid(ent) or ent:GetPos():Distance(owner:GetPos()) > PlayerDisUse * 2 then self:OutHoldEnt() return end--mdem

            local active = owner:KeyDown(IN_WALK)

            if active ~= self.oldActive then
                self.oldActive = active

                if active then
                    self.mode = not self.mode

                    owner:ChatPrint("Зависание объекта: " .. tostring(self.mode))
                end
            end

            if not self.mode then
                self.pos = owner:EyePos():Add(owner:EyeAngles():Forward():Mul(75))
                self.ang = Angle(0,owner:EyeAngles()[2],0)
            end

            local params = {
                secondstoarrive = 0.01,
                pos = self.pos,
                angle = self.ang,
                maxangular = 125,
                maxangulardamp = 125,
                maxspeed = 75,
                maxspeeddamp = 65,
                teleportdistance = 0,
                deltatime = 0.01,
            }

            local phys = ent:GetPhysicsObject()
            phys:Wake()
            phys:ComputeShadowControl(params)
        end
    end

    return
end

local white = Color(255,255,255)
local bonenames = {
    ['ValveBiped.Bip01_Head1']="голову",
    ['ValveBiped.Bip01_Spine']="спину",
    ['ValveBiped.Bip01_Spine2']="спину",
    ['ValveBiped.Bip01_Pelvis']="живот",
    ['ValveBiped.Bip01_R_Hand']="правую кисть",
    ['ValveBiped.Bip01_R_Forearm']="правое предплечье",
    ['ValveBiped.Bip01_R_UpperArm']="правое предплечье",
    ['ValveBiped.Bip01_R_Foot']="правую ногу",
    ['ValveBiped.Bip01_R_Thigh']='правое бедро',
    ['ValveBiped.Bip01_R_Calf']='правую голень',
    ['ValveBiped.Bip01_R_Shoulder']='правое плечо',
    ['ValveBiped.Bip01_R_Elbow']='правый локоть',
	['ValveBiped.Bip01_L_Hand']='левую кисть',
    ['ValveBiped.Bip01_L_Forearm']='левое предплечье',
    ['ValveBiped.Bip01_L_UpperArm']="левое предплечье",
    ['ValveBiped.Bip01_L_Foot']='левую ногу',
    ['ValveBiped.Bip01_L_Thigh']='левое бедро',
    ['ValveBiped.Bip01_L_Calf']='левую голень',
    ['ValveBiped.Bip01_L_Shoulder']='левое плечо',
    ['ValveBiped.Bip01_L_Elbow']='левый локоть'
}

local yellow = Color(255,255,0)

function SWEP:DrawHUD()
    local owner = LocalPlayer()

    local tr = owner:EyeTraceShoot(PlayerDisUse,true)
    tr.mask = MASK_ALL
    tr = util.TraceLine(tr)

    if not tr.Hit then return end

    local pos = tr.HitPos:ToScreen()
    local x,y = pos.x,pos.y

    surface.SetDrawColor(255,255,255,255)
    draw.NoTexture()
    Circle(x,y,5,32)

    local text
    local textcolor = color_wihte

    if tr.Entity:GetClass() == "ent_nail_molotok" then
        text = "Отбить гвоздь"

        surface.SetDrawColor(255,255,0,25)
        textcolor = yellow

        local w = 70 * ScreenSize
        draw.GradientLeft(x,y - 40,w,20 * ScreenSize)
        draw.GradientRight(x - w,y - 40,w,20 * ScreenSize)
    else
        local t1,t2 = TwoTrace(tr.HitPos,tr.Normal,owner)
        if not t1 or not t2 then return end

        local ent = t1.Entity

        if ent:IsRagdoll() then
            text = "Прибить конечность"
        elseif ent ~= Entity(0) and t1.Hit then
            text = "Прибить проп"
        end
    end

    if not text then return end--lol??

    draw.DrawText(text,"TargetID",x,y - 40,textcolor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end