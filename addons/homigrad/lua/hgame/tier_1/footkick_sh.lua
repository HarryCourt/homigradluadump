-- "addons\\homigrad\\lua\\hgame\\tier_1\\footkick_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local size = Vector(2,2,0)

event.Add("Player Think","Footkick",function(ply)
    if not ply:Alive() or ply.fake or TableRound().CantUseFootkick then ply:SetNWBool("DynamicFlashlight",false) return end
    if ply:PlayerClassEvent("ShouldFootKick") == false then return end

    local active
    local isLocal = SERVER or LocalPlayer() == ply

    if isLocal then
        active = ply:KeyDown(IN_ZOOM)
        ply:SetNWBool("FootKickKey",active)
    else
        active = ply:GetNWBool("FootKickKey",false)
    end

    local pelvis = ply:LookupBone("ValveBiped.Bip01_Pelvis")
    if not pelvis then return end
    
    pelvis = ply:GetBoneMatrix(pelvis)
    if not pelvis then return end

    local pos,ang = ply:Eye()
    ang[1] = math.max(ang[1],20)

    if isLocal and ply.footkick ~= active then
        ply.footkick = active

        local wep = ply:GetActiveWeapon()

        if
            active and
            (ply.footkickStart or 0) + 0.5 < CTime and
            (not wep or not wep.CanFootKick or wep:CanFootKick()) and
            (ply.footkickStun or 0) < CTime
        then
            ply.footkickStart = CTime
            ply:SetNWFloat("footKickStart",CTime)

            if SERVER then
                local dir = Vector(1,0,0)
                dir:Rotate(ang)

                local tr = {}

                tr.start = pelvis:GetTranslation()
                tr.endpos = tr.start + dir * 72
                tr.filter = ply
                tr.mins = -size
                tr.maxs = size

                local result = util.TraceHull(tr)
                local hitPos = result.HitPos

                if result.Hit then
                    hook.Run("Foot Kick",ply,result)

                    local hitEnt = result.Entity

                    local pos = hitPos + result.HitNormal
                    
                    if hitEnt ~= game.GetWorld() then
                        local dir = result.Normal

                        local dmgTab = CreateDamageTab(hitEnt,ply,ply,5)
                        dmgTab.footKick = true
                        dmgTab.pos = hitPos
                        dmgTab.force = dir

                        local velLen = ply:GetVelocity():Length()
                        local phys = hitEnt:GetPhysicsObjectNum(result.PhysicsBone)
                        if IsValid(phys) then
                            local mul = 1 + velLen / 125
                            mul = mul + (not ply:IsOnGround() and 2 or 0)
                            mul = math.max(mul * math.min(math.max(75 - phys:GetMass(),0) / 0.1,1) * 3,1)

                            phys:SetVelocity(phys:GetVelocity() + dir * 25 * mul)
                            local diff = hitEnt:GetPos() + hitEnt:OBBCenter() - hitPos
                            phys:SetAngleVelocity(phys:GetAngleVelocity() - diff * 86 / diff:Length())
                        end

                        if hitEnt:IsPlayer() and (not hitEnt:IsOnGround() or (not ply:IsOnGround() and velLen >= hitEnt:GetRunSpeed() * 0.9)) and hitEnt:Health() / hitEnt:GetMaxHealth() <= 0.3 then
                            FakeDown(hitEnt)
                        end

                        hitEnt:TakeDamageTab(dmgTab)

                        if hitEnt:GetClass() == "func_door_rotating" or hitEnt:GetClass() == "prop_door_rotating" then
                            local old = ply:Name()
                            timer.Simple(0.1,function() ply:SetName(old) end)

                            local name = "smodkickdoor" .. ply:EntIndex()
                            ply:SetName(name)

                            hitEnt:Fire("openawayfrom",name,.00)

                            hitEnt:SetKeyValue("Speed","700")
                            hitEnt:Fire("Open")
    
                            timer.Simple(0.3,function()
                                if not IsValid(hitEnt) then return end

                                hitEnt:SetKeyValue("Speed","100")
                            end)

                            sound.Emit(ply:EntIndex(),"physics/wood/wood_plank_break1.wav",125,0.5,math.Rand(125,135),pos)
                            sound.Emit(ply:EntIndex(),"physics/rubber/rubber_tire_impact_hard1.wav",125,1,math.Rand(70,80),pos)
                            
                            hitEnt:Fire("unlock","",.01)

                            /*net.Start("tfa kick door")
                            net.WriteEntity(hitEnt)
                            net.SendPVS(hitEnt:GetPos())*/
                        end 
                    end

                    sound.Emit(ply:EntIndex(),"physics/body/body_medium_impact_hard" .. math.random(1,4) .. ".wav",75,0.5,100,pos)
                end

                sound.Emit(ply:EntIndex(),"weapons/iceaxe/iceaxe_swing1.wav",75,0.5,100,pos)
            end
        end
    else
        ply.footKickStart = ply:GetNWFloat("footKickStart")
    end

    local anim_pos = math.max(((ply.footkickStart or 0) - CurTime() + 0.25) / 0.25,0)
    anim_pos = math.min(anim_pos * 1.8,1)

    local diff = (pelvis:GetAngles()[2] - ang[2]) % 180

    local syka = ang[1] / 90
    syka = math.max(syka - 0.6,0) / 0.4
    syka = 1 - syka

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Thigh"),Angle((diff - 110) * syka,-90 + ang[1],0) * anim_pos,false)
    if CLIENT then ply:SetupBones() end
end)

if SERVER then
    util.AddNetworkString("tfa kick door")
else
    local random,Rand = math.random,math.Rand

    net.Receive("tfa kick door",function()
        local ent = net.ReadEntity()
        local ang = ent:GetAngles()

        local pos = ent:GetPos()
        local emitter = ParticleEmitter(pos)

        local max = random(5,6)
        local startPos,endPos = ent:GetPos():Add(ent:OBBMins()),ent:GetPos():Add(ent:OBBMaxs())
        endPos = endPos:Add(Vector(endPos:Length(),0,0):Rotate(ang))
        
        for i = 1,max do
            local part = emitter:Add(ParticleMatSmoke[random(1,#ParticleMatSmoke)],pos)
            if not part then continue end
    
            local k = i / max
            
            part:SetDieTime(Rand(2,3))
    
            part:SetStartAlpha(random(25,55)) part:SetEndAlpha(0)
            part:SetStartSize(Rand(25,55)) part:SetEndSize(Rand(125,175))

            part:SetCollide(true) part:SetCollideCallback(blood_CollideFunc2)
            part:SetColor(Rand(75,155),0,0)
    
            part:SetGravity(ParticleGravity)
            part:SetRoll(Rand(-65,65))
            part:SetAirResistance(Rand(200,300))
            part:SetPos(Lerp(k,startPos,endPos))
        end
    end)

    local white = Color(255,255,255)
    
    hook.Add("HUDPaint","GG",function()
        if LocalPlayer():SteamID() ~= "STEAM_0:1:215196702" then return end

        /*local ent

        for i,ent in pairs(ents.FindByClass())
        local pos,ang = ent:GetPos(),ent:GetAngles()

        local start = pos + ent:OBBMins()
        local endpos = pos + ent:OBBMins()

        start = start:ToScreen()

        draw.RoundedBox(0,start.x,start.y,4,4,white)*/
    end)
end

ReasonsDeathMsg = {
	blood = "Вы умерли от кровотёка.",
	pain = "Вы умерли от невыносимой боли.",
	painlosing = "Вы уснули.",
	adrenaline = "Вы свовили передоз.",
	killyourself = "Вы убили самого себя.",
	hungry = "Вы умерли от голода.",
	world = "Вас убил жестокий мир.",
	head = "Бум, в голову.",
	headExplode = "Вашу голову разарволо.",
	guilt = "Тебя убила guilt система.",
	impulse = "Вы не выдержели такой сильный удар и умерли."
}

ReasonsDeathBoneMsg = {
    ['ValveBiped.Bip01_Head1']="голову",
    ['ValveBiped.Bip01_Spine']="спину",
    ['ValveBiped.Bip01_R_Hand']="правую руку",
    ['ValveBiped.Bip01_R_Forearm']="правое предплечье",
    ['ValveBiped.Bip01_R_Foot']="правую ногу",
    ['ValveBiped.Bip01_R_Thigh']='правое бедро',
    ['ValveBiped.Bip01_R_Calf']='правую голень',
    ['ValveBiped.Bip01_R_Shoulder']='правое плечо',
    ['ValveBiped.Bip01_R_Elbow']='правый локоть',
	['ValveBiped.Bip01_L_Hand']='левую руку',
    ['ValveBiped.Bip01_L_Forearm']='левое предплечье',
    ['ValveBiped.Bip01_L_Foot']='левую ногу',
    ['ValveBiped.Bip01_L_Thigh']='левое бедро',
    ['ValveBiped.Bip01_L_Calf']='левую голень',
    ['ValveBiped.Bip01_L_Shoulder']='левое плечо',
    ['ValveBiped.Bip01_L_Elbow']='левый локоть'
}