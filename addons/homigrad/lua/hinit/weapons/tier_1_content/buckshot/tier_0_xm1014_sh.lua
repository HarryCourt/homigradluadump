-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\buckshot\\tier_0_xm1014_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_xm1014","hg_wep")
if not SWEP then return end

SWEP.PrintName 				= "XM1014"
SWEP.Instructions           = "\n11 выстрелов в секунду\n100 Урона\n0.04 Разброс"
SWEP.Category 				= "Оружие: Дробовики"

------------------------------------------

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Shell = "ShotgunShellEject"

SWEP.NumBullet = 16

SWEP.ChamberAuto = true

SWEP.Primary.Cone = 0.06
SWEP.Primary.Spread = 0
SWEP.Primary.Damage = 125
SWEP.Primary.DamageDisK = {
    {350,1},
    {1000,0.5},
    {3000,0}
}

SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 7

SWEP.Primary.Sound = "pwb/weapons/remington_870/shoot.wav"
SWEP.Primary.SoundFar = "arccw_go/xm1014/xm1014-1-distant.wav"

SWEP.HoldType = "ar2"

SWEP.Slot					= 2
SWEP.SlotPos				= 0

SWEP.WorldModel				= "models/weapons/arccw_go/v_shot_m1014.mdl"

SWEP.vbwPos = Vector(-16,1,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-22,5,5)
SWEP.dwsItemFOV = 2

SWEP.wmVector = Vector(-12,5.5,-5)
SWEP.wmAngle = Angle(-1.7,10,180)

SWEP.MuzzlePos = Vector(0,0,0)
SWEP.CameraPos = Vector(-30,0,1.3)
SWEP.CR_Scope = 2

SWEP.Reload1 = "arccw_go/m4a1/m4a1_boltback.wav"
SWEP.Reload2 = {
    "arccw_go/xm1014/xm1014_insertshell_01.wav",
    "arccw_go/xm1014/xm1014_insertshell_02.wav",
    "arccw_go/xm1014/xm1014_insertshell_03.wav"
}

SWEP.FakeVec1 = Vector(7,-10,-14)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.BoltBone = "v_weapon.xm1014_Bolt"
SWEP.BoltMul = 2

SWEP.DeploySound = "arccw_go/xm1014/xm1014_draw.wav"

SWEP.CHandUp = 12
SWEP.CHandHoldUp = 0.1

SWEP.eyeSprayH = 25
SWEP.eyeSprayW = 5

SWEP.ReloadMode = false
SWEP.delayReload = 0

function SWEP:ReloadCan() return false end//отрубает магазины ебаные

function SWEP:Reload()
	self.AmmoChek = 3

	local Time = CurTime()

	if not self:CanFight() or self.reloadedDelay or self.delayReload > CurTime() then return end

    if self.reloadAnimSet == 1 then//для удержания затвора на дробовике
		self.reloadAnimDelay = CurTime() + 0.025
	end
    
    self.reloadHold = Time

    local owner = self:GetOwner()

    if self:Clip1() == 0 then self.forceInsert = true end
    if self:Clip1() == self:GetMaxClip1() then self.forceInsert = nil end
    
    local cant

    if not owner:IsNPC() and owner:KeyDown(IN_WALK) and self.forceInsert then
        self.forceInsert = nil

        cant = true
    end

    if not self.forceInsert then//взводит патрон в патроник
        if self:InsertChamber() then
            self:SoundEmit(self.Reload1)
        
            self:SetClipPos(1)

            self.reloadAnimSet = 1
			self.reloadAnimDelay = CurTime() + 0.1
        
            return
        end
    end

    if self.reloadAnimSet == 0 and not cant and ((not self.ReloadMode or (not owner:IsNPC() and owner:KeyDown(IN_WALK))) or self.forceInsert) then//вставляет патроны
        local type = self:GetPrimaryAmmoType()
        local count = (owner:IsNPC() and 1) or owner:GetAmmoCount(type)

        if count > 0 and self:Clip1() < self:GetMaxClip1() then
            if not owner:IsNPC() then owner:SetAmmo(count - 1,type) end
            self:SetClip1(self:Clip1() + 1)

            self:SoundEmit(self.Reload2[math.random(1,#self.Reload2)])

            self.delayReload = CurTime() + 0.5
            self.attackDelay = CurTime() + 0.5

            self:SetNWFloat("ReloadAnim2",CurTime())
        end

        return
    end
end

SWEP.reloadAnimAngInsert = Angle()

SWEP:Event_Add("Step","Reload Anim",function(self,ply)
    if ply:IsNPC() then
        if not self.forceInsert or (self.reloadAnimSet == 0 and (not self.ReloadMode or self.forceInsert)) then self:Reload() end

        return
    end

    local k = math.max(self:GetNWFloat("ReloadAnim2",0) + 0.3 - CurTime(),0) / 0.3

    self.reloadAnimAngInsert = Angle(0,0,-5):Mul(k)

    ply.rhand:Add(self.reloadAnimAngInsert)
end)

SWEP:Event_Add("Pre CalcView","Reload Insert",function(self,owner)//перед захватом позиции отводим все изменения
	owner:AddBoneAng("rhand",-self.reloadAnimAngInsert)
	owner:SetupBones()
end)

SWEP:Event_Add("Post CalcView","Reload Insert",function(self,owner)//возвращаем на место для рендера
	owner:AddBoneAng("rhand",self.reloadAnimAngInsert)
end)

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        flashScale = 3,
        gasTimeScale = 2.5,
        gasSideScale = 2.75,
        gasForwardScale = 3
    })
end

SWEP.MoveMul = 0.8