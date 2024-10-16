-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_0_base\\wep_gnade_base\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_gnade_base","hg_wep_base",true)
if not SWEP then return INCLUDE_BREAK end

SWEP.PrintName = "База Гаранаты"
SWEP.Author = ""
SWEP.Purpose = "Бах Бам Бум, Бадабум!"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.itemType = "granade"

SWEP.Granade = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.HoldType = "normal"

function SWEP:PrimaryAttack()
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

SWEP:Event_Add("Step","Main",function(self,owner)
    local hold = self:GetNWInt("Hold")

    if hold == 0 then return end

    if hold == 1 then
        self:SetStandType("melee")
        owner:SetAnimation(PLAYER_ATTACK1)
        
        if SERVER then
            if not owner:KeyDown(IN_ATTACK) then
                TrownGranade(owner,750,self.Granade)

                self:Remove()
                owner:SelectWeapon("weapon_hands")

                return
            end

            if owner:KeyDown(IN_ATTACK2) then
                if not self.ignoreAttack2 then
                    self.ignoreAttack1 = true self:SetNWInt("Hold",2)
                end
            else self.ignoreAttack2 = nil end
        end
    end

    if hold == 2 then
        self:SetStandType("knife")
        owner:SetAnimation(PLAYER_ATTACK1)

        if SERVER then
            if not owner:KeyDown(IN_ATTACK2) then
                TrownGranade(owner,250,self.Granade)

                self:Remove()
                owner:SelectWeapon("weapon_hands")

                return
            end

            if owner:KeyDown(IN_ATTACK) then
                if not self.ignoreAttack1 then
                    self.ignoreAttack2 = true self:SetNWInt("Hold",1)
                end
            else self.ignoreAttack1 = nil end
        end
    end
end)

function SWEP:SetFakeWep()
    if self:GetNWInt("Hold") ~= 0 then
        local owner = self:GetOwner()

        TrownGranade(owner,0,self.Granade)
        self:Remove()
        owner:SelectWeapon("weapon_hands")
    else
        return false
    end
end

SWEP.InvMoveSnd = InvMoveSndGranade
SWEP.InvCount = 3