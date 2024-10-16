-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\other\\weapon_per4ik_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_per4ik","hg_wep_base")
if not SWEP then return end

SWEP.Base                   = "weapon_base"

SWEP.PrintName 				= "Перцовка"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Гражданское газовое оружие самообороны, снаряженное слезоточивыми и раздражающими веществами (ирритантами)"
SWEP.Category 				= "Предметы"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= 300
SWEP.Primary.DefaultClip	= 300
SWEP.Primary.Automatic		= true
SWEP.Primary.Wait		    = 0
SWEP.Primary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 3
SWEP.SlotPos				= 3
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/custom/pepperspray.mdl"
SWEP.WorldModel				= "models/weapons/custom/pepperspray.mdl"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsItemAng = Angle(0,180,0)
SWEP.dwsItemPos = Vector(-0.4,0,0)
SWEP.dwsItemFOV = -11

SWEP.dwr_reverbDisable = true
SWEP.vbw = true
SWEP.vbwPistol = true
SWEP.vbwPos = Vector(-6,-3,1)
SWEP.vbwAng = Angle(-40,-0,-90)
SWEP.vbwModelScale = Vector(0.9,0.9,0.9)

SWEP.itemType = "other"
SWEP.invNoDrawClip = true

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

if SERVER then
    function SWEP:Think()
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        local attack = owner:KeyDown(IN_ATTACK)
        self:SetNWBool("Attack",attack)

        if attack and self:Clip1() > 0 then
            self:TakePrimaryAmmo(1)
            
            local tr = owner:GetEyeTrace()
            local ent = tr.Entity
            local head = ent:LookupBone("ValveBiped.Bip01_Head1")
            local ent1 = ent
            ent = RagdollOwner(ent) or ent
                                    
            if not self.Sound or not self.Sound:IsPlaying() then
                self.Sound = CreateSound(owner,"PhysicsCannister.ThrusterLoop")
                self.Sound:Play()
            end

            if IsValid(ent) and ent:IsPlayer() and tr.HitPos:Distance(tr.StartPos) <= 125 then
                
                if head then
                    head = ent1:GetBoneMatrix(head)
                    local per4ikToEyes = ent1:GetAttachment(ent1:LookupAttachment("eyes")).Ang:Forward():Dot(tr.Normal)
                    
                    if head:GetTranslation():Distance(tr.HitPos) <= 25 and per4ikToEyes < -0.5 then
                        if self.cantUsePer4ik then return end

                        /*local dmgInfo = DamageInfo()
                        dmgInfo:SetAttacker(owner)
                        dmgInfo:SetInflictor(self)
                        dmgInfo:SetDamage(5)*/

                        //GuiltLogic(ent,owner,dmgInfo)

                        net.Start("JMod_VisionBlur")
                        net.WriteFloat(5)
                        net.Send(ent)

                       // ent.pain = math.min(ent.pain + 0.5,190)
                    end
                end
            end
        else
            if self.Sound and self.Sound:IsPlaying() then self.Sound:Stop() end
        end
    end

    function SWEP:Holster()
        self:SetNWBool("Attack",false)

        if self.Sound and self.Sound:IsPlaying() then self.Sound:Stop() end

        return true
    end

    function SWEP:OwnerChanged()
        self:SetNWBool("Attack",false)

        if self.Sound and self.Sound:IsPlaying() then self.Sound:Stop() end
    end
else
    local WorldModel = ClientsideModel(SWEP.WorldModel)

    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if (IsValid(_Owner)) then
            -- Specify a good position
            local offsetVec = Vector(4,-1,0)
            local offsetAng = Angle(180, 90, 0)
            
            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if !boneid then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if !matrix then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end