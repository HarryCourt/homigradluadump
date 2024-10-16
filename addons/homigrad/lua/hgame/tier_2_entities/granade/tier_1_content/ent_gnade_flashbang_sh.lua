-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\granade\\tier_1_content\\ent_gnade_flashbang_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("ent_gnade_flashbang", "ent_gnade_base")
if not ENT then return end

ENT.PrintName = "Flashbang"
ENT.JModPreferredCarryAngles = Angle(0, 140, 0)
ENT.Model = "models/jmod/explosives/grenades/flashbang/flashbang.mdl"
ENT.ModelScale = 0.8
ENT.SpoonScale = 2

if SERVER then
    util.AddNetworkString("FlashbangEffect")

    function ENT:Initialize()
        self:SetModel(self.Model)
        self:SetModelScale(self.ModelScale)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end

    function ENT:Arm()
        self:SetBodygroup(2, 1)
        self:SetState(JMod.EZ_STATE_ARMED)
        self:SpoonEffect()

        local time = 2.5
        timer.Simple(time - 1, function()
            if IsValid(self) then
                player.EventPoint(self:GetPos(), "flashbang pre detonate", 1024, self)
            end
        end)

        timer.Simple(time, function()
            if IsValid(self) then
                self:Detonate()
            end
        end)
    end

    function ENT:Detonate()
        if self.Exploded then return end
        self.Exploded = true

        local SelfPos = self:GetPos() + Vector(0, 0, 10)
        JMod.Sploom(self.Owner, self:GetPos(), 20)

        sound.Play("arccw_go/flashbang/flashbang_explode1.wav", SelfPos, 75, 100, 1)

        timer.Simple(.1, function()
            if not IsValid(self) then return end

            util.BlastDamage(self, self.Owner or self, SelfPos, 1000, 2)

            for _, ply in pairs(player.GetAll()) do
                self:HandlePlayerFlash(ply, SelfPos)
            end
        end)

        SafeRemoveEntityDelayed(self, 10)
    end

    function ENT:HandlePlayerFlash(ply, explosionPos)
        local plyPos = ply:EyePos()
        local distance = explosionPos:Distance(plyPos)
    
        if distance < 1000 then
            local trace = util.TraceLine({
                start = explosionPos,
                endpos = plyPos,
                filter = {self, ply},
                mask = MASK_SHOT
            })
    
            if not trace.Hit then
                local plyViewDirection = ply:EyeAngles():Forward()
                local grenadeDirection = (explosionPos - plyPos):GetNormalized()
    
                local angleToGrenade = math.deg(math.acos(plyViewDirection:Dot(grenadeDirection)))
    
                
                local fov = ply:GetFOV()
    
                if angleToGrenade <= (fov / 2) then
                 
                    net.Start("FlashbangEffect")
                    net.WriteFloat(distance)
                    net.Send(ply)
                end
            end
        end
    end
    
elseif CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end

    net.Receive("FlashbangEffect", function()
        local distance = net.ReadFloat()
        local intensity = math.Clamp(1 - (distance / 1000), 0, 1)
        local duration = 3

      
        LocalPlayer():ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), 0.1, duration - 0.1)

        
        local endTime = CurTime() + duration

        hook.Add("RenderScreenspaceEffects", "FlashbangPostProcess", function()
            local remainingTime = endTime - CurTime()
            local flashAmount = math.Clamp(remainingTime / duration, 0, 1)

            if flashAmount > 0 then
                DrawMotionBlur(0.1, flashAmount, 0.03)

                local dlight = DynamicLight(LocalPlayer():EntIndex())
                if dlight then
                    dlight.pos = LocalPlayer():EyePos()
                    dlight.r = 255
                    dlight.g = 255
                    dlight.b = 255
                    dlight.brightness = 3 * flashAmount
                    dlight.Decay = 1000
                    dlight.Size = 300 * flashAmount
                    dlight.DieTime = CurTime() + 0.1
                end
            else
                hook.Remove("RenderScreenspaceEffects", "FlashbangPostProcess")
            end
        end)

       
        timer.Simple(duration + 0.5, function()
            hook.Remove("RenderScreenspaceEffects", "FlashbangPostProcess")
        end)
    end)

    language.Add("ent_gnade_flashbang", "EZ Flashbang Grenade")
end
