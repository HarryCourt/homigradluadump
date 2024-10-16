-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\tier_0_hg_wep_base\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("hg_wep_base",{"base_weapon"},true)
if not SWEP then return INCLUDE_BREAK end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel = ""

homigrad_weapons = homigrad_weapons or {}

function SWEP:Initialize()
    Step_Add(self)

    self:Event_Call("Init")

	self:DrawShadow(false)

	self:AddEFlags(EFL_NO_THINK_FUNCTION)
end

function SWEP:IsLocal() return SERVER or self:GetOwner() == LocalPlayer() end

function SWEP:Step(owner)
	local time = CurTime()

	if self:IsLocal() then self:Event_Call("Step Local",owner,time) end

	self:Event_Call("Step",owner,time)
end

function SWEP:Think() end

function SWEP:StepWithoutOwner()
	self:Event_Call("Think",CurTime())
end

function SWEP:MulMove() return 1 end

event.Add("Move","hg_wep_base",function(ply,mv)
	local wep = ply:GetActiveWeapon()
	local move = wep.MulMove
	if not move then return end

    move = move()

	mv:SetMaxSpeed(mv:GetMaxSpeed() * move)
	mv:SetMaxClientSpeed(mv:GetMaxSpeed())
end)

function SWEP:ShouldDropOnDie() return false end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end

function SWEP:PreDrawOpaqueRenderables() end