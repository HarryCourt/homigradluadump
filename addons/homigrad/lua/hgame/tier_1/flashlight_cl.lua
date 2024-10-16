-- "addons\\homigrad\\lua\\hgame\\tier_1\\flashlight_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local color_white = Color(255,255,255,90)
local color_white2 = Color(255,255,255,5)

local hg_best_flashlight

cvars.CreateOption("hg_best_flashlight","1",function(value)
    hg_best_flashlight = tonumber(value)

    if hg_best_flashlight >= -1 then
        local player_GetAll = player.GetAll
    
        local function create(ply)
            local lamp = ProjectedTexture()
            ply.DynamicFlashlight = lamp

            lamp:SetTexture("effects/flashlight001")
            lamp:SetFarZ(900)
            lamp:SetNearZ(1)
            lamp:SetFOV(90)
            lamp:SetEnableShadows(true)
            lamp:AddThink()

            function lamp:Think()
                if (self.render or 0) < RealTime() then self:Remove() end
            end
        end
        
        local function remove(ply)
            if IsValid(ply.DynamicFlashlight) then
                ply.DynamicFlashlight:Remove()
                ply.DynamicFlashlight = nil
            end
        end
        
        local material = Material("sprites/gmdm_pickups/light")
        local angZero = Angle(0,0,0)
        local vecZero = Vector(0,0,0)
        local addPosa = Vector(3,-2,0)
        
        local function Draw(ply)
            if not ply:Alive() then return end
            
            if not ply:GetNWBool("DynamicFlashlight") then
                ply:SetNWBool("DynamicFlashlight",false)
                
                if hg_best_flashlight == 1 and ply.DynamicFlashlight then remove(ply) end
    
                return
            end
    
            local fake = ply:GetNWEntity("Ragdoll")
            local ent = IsValid(fake) and fake or ply

            local bone = ent:LookupBone("ValveBiped.Bip01_L_Hand")
            local pos,ang

            local dontdrawmdl

            if not ply:EyeMode() and bone then
                local matrix = ent:GetBoneMatrix(bone)
                pos,ang = matrix:GetTranslation(),matrix:GetAngles()
            else
                pos,ang = ply:EyePos(),ply:EyeAngles()

                dontdrawmdl = true
            end

            local mdl = GetClientSideModelID("models/maxofs2d/lamp_flashlight.mdl",tostring(ply) .. "flashlight")
            if not mdl then return end
            
            mdl:SetAngles(ply:EyeAngles())
            mdl:SetPos(pos + Vector(4,-2,0):Rotate(ang) + Vector(5,0,0):Rotate(ply:EyeAngles()))
            
            if hg_best_flashlight == 1 or (hg_best_flashlight == 0 and ply == LocalPlayer()) then
                local lamp = ply.DynamicFlashlight

                if not IsValid(lamp) then create(ply) lamp = ply.DynamicFlashlight end
                lamp:SetPos(mdl:GetPos() + Vector(25,0,0):Rotate(mdl:GetAngles()))
                lamp:SetAngles(mdl:GetAngles())
                lamp:SetBrightness(math.Rand(0.95,1))
                lamp:Update()
                lamp.render = RealTime()
            else
                local tr = {
                    start = pos,
                    endpos = pos + mdl:GetAngles():Forward():Mul(128),
                    filter = ent
                }

                local dlight = DynamicLight(ply:EntIndex())
                dlight.Pos = util.TraceLine(tr).HitPos
                dlight.r = 255
                dlight.g = 255
                dlight.b = 255
                dlight.Brightness = 0.1
        
                dlight.Decay = 1000
                dlight.Size = math.Rand(480,512)
                dlight.DieTime = CurTime() + 0.25
        
                dlight.ignoreLimit = true
                dlight:Spawn()
            end
            
            mdl:SetModelScale(0.5)
            local wep = ply:GetActiveWeapon()
            mdl:SetNoDraw(dontdrawmdl or not (not IsValid(wep) or wep:GetClass() == "weapon_hands"))
            mdl:DrawModel(STUDIO_NOSHADOWS)
        end

        FindMetaTable("Player").DrawFlashlight = Draw

        local function DrawFlash(ply)
            local mdl = ply.mdlFlashlight
        end

        local GetAll = player.GetAll

        hook.Add("PostDrawOpaqueRenderables","FlashLightLocal",function()
            if not InitNET then return end

            if LocalPlayer():Alive() and not DRAWMODEL then
                Draw(LocalPlayer())
            end
        end)

        hook.Add("PostPlayerDraw","Flashlight",function(ply)
            Draw(ply)
        end)
    else
        FindMetaTable("Player").DrawFlashlight = function() end
        
        hook.Remove("Think","Flashlight")
        hook.Remove("PostPlayerDraw","Flashlight")
    end
end,-2,1)