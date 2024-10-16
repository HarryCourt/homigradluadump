-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_0_base\\wep_food_base\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_base","hg_wep_base",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.Category = "Еда"
SWEP.Spawnable = true

SWEP.EnableTransformModel = true

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.HoldType = "normal"

SWEP.HandBack = 0
SWEP.HandRight = 0

SWEP.anim = 0

SWEP.DelayEat = 1
SWEP.MaxValue = 4

SWEP.Slot = 5
SWEP.SlotPos = 10

SWEP.itemType = "other"

SWEP.InvMoveSnd = InvMoveSndPlastic

SWEP.dwsItemPos = Vector(0.5,0,-3.5)
SWEP.dwsItemAng = Angle(0,0,0)
SWEP.dwsItemFOV = -15

function SWEP:EmitSnd(snd)
    sound.Emit(self:EntIndex(),TypeID(snd) == TYPE_TABLE and snd[math.random(1,#snd)] or snd,75,1,math.random(95,105))
end

function SWEP:EatValue() end

SndEat = SndEat or {}
for i = 1,9 do SndEat[i] = "snd_jack_eat" .. i .. ".ogg" end

SndEatWater = SndEatWater or {}
for i = 1,2 do SndEatWater[i] = "snd_jack_drink" .. i .. ".ogg" end

SWEP.SndEet = SndEat

if SERVER then
    util.AddNetworkString("eat")
else
    net.Receive("eat",function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        ent:EatValue()
    end)

    SWEP.ParticleColor = Color(255,255,255)
    SWEP.ParticleMat = Material("particle/particle_noisesphere")
    
    local random,Rand = math.random,math.Rand

    function SWEP:EatValue()
        local col = self.ParticleColor
        local r,g,b,a = col.r,col.g,col.b,col.a

        local pos,ang = self:GetTransformWorldModel()

        local emitter = ParticleEmitter(pos)

        local dir = ang:Up()
        dir[3] = dir[3] + 2
        dir:Normalize()

        for i = 1,random(3,5) do
            local part = emitter:Add(self.ParticleMat,pos)
            if not part then continue end
    
            local dir = dir:Clone():Mul(100)
            dir:Rotate(Angle(Rand(-75,75),Rand(-125,125),0))
    
            part:SetDieTime(Rand(1,2))
    
            part:SetStartAlpha(random(125,155)) part:SetEndAlpha(255)
            part:SetStartSize(Rand(1,2)) part:SetEndSize(Rand(10,12))
    
            part:SetColor(r,g,b,a)
            part:SetRoll(Rand(-300,300))
            part:SetVelocity(dir) part:SetAirResistance(Rand(25,75))
            part:SetGravity(ParticleGravity)
            part:SetPos(pos)
        end
    
        emitter:Finish()
    end
end

SWEP:Event_Add("Step","Main",function(self,owner,time)
    local hold

    if SERVER then
        self:SetNWBool("Eat",owner:KeyDown(IN_ATTACK))
        hold = self:GetNWBool("Eat")
    end

    if self:GetNWBool("Eat") then
        self.anim = LerpFT(0.5,self.anim,1)
    else
        self.anim = LerpFT(0.5,self.anim,0)
    end

    if SERVER then
        if hold ~= self.oldHold then
            self.delayEat = time + 1
        end

        if hold and self.delayEat < time then
            self.delayEat = time + self.DelayEat

            if self:EatValue(owner) ~= false then
                self.Value = (self.Value or self.MaxValue) - 1

                net.Start("eat")
                net.WriteEntity(self)
                net.SendPVS(self:GetPos())

                self:EmitSnd(self.SndEet)
                owner:ViewPunch(Angle(-2.5,0,math.Rand(-1,1)))

                if self.Value <= 0 then
                    local pos,ang = self:GetTransformWorldModel()
                    DropProp(pos,ang,self.WorldModel,self.wmScale,Angle(0,owner:EyeAngles()[2],0):Forward():Mul(75):Add(Vector(0,0,75)),Vector(),collideSnd)

                    self:Remove()
                else
                    self:EmitSnd(self.SndEet)
                end
            end
        end

        self.oldHold = hold
    end

    local anim = self.anim

    if CLIENT and owner == LocalPlayer() and DRAWMODEL then
        owner.rupperarm:Add(Angle(0,-25,20):Mul(anim))
        owner.rforearm:Add(Angle(-24,-120 + self.HandBack,20):Mul(anim))
        owner.rhand:Add(Angle(-20,self.HandRight,0):Mul(anim))
    else

    owner.rupperarm:Add(Angle(0,-25,20):Mul(anim))
        owner.rforearm:Add(Angle(-30,-120 + self.HandBack,0):Mul(anim))
        owner.rhand:Add(Angle(-0,self.HandRight,0):Mul(anim))
    end
end)

FoodCategories = {}

SWEP:Event_Add("Construct","Food Category",function(class)
    if class[1].ClassName == "wep_food_base" then return end//we
    
    FoodCategories[class[1].ClassName] = true
end)