-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\food\\tier_1_content\\wep_food_surst_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_food_surst", "wep_food_base")
if not SWEP then return end

SWEP.PrintName = "Сюрстремминг"

SWEP.WorldModel = "models/jordfood/jtun.mdl"

SWEP.wmVector = Vector(4, 1, -1)
SWEP.wmAngle = Angle(0, 0, 90)

SWEP.ParticleColor = Color(75, 65, 25)

SWEP.HungryAdd = 1

function SWEP:EatValue(ent)
    if CLIENT and self:GetOwner() ~= LocalPlayer() then return end
    
    local add = self.HungryAdd / self.MaxValue

    if SERVER then
        ent.hungry = math.min(ent.hungry + add, 10)
        ent.blood = math.min(ent.blood + 30 * self.HungryAdd, 5000)
        ent.stamina = math.min(ent.stamina + self.HungryAdd, 100)
        ent:SetHealth(math.min(ent:Health() + 1, ent:GetMaxHealth()))
    end

    local start = RealTime()

    hook.Add("RenderScreenspaceEffects", "BlurEffect", function()
        DrawMotionBlur(0.9,math.max(start + 10 - RealTime(),0) / 10 * 0.7,0.1)
    end)
    
    timer.Create("BlurEffectTimer",10, 1, function()
        hook.Remove("RenderScreenspaceEffects", "BlurEffect")
    end)
end

SWEP.dwsItemPos = Vector(0,0,-0.8)
SWEP.dwsItemAng = Angle(0,0,-25)
SWEP.dwsItemFOV = -17