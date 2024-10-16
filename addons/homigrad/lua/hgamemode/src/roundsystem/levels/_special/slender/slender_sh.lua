-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\slender\\slender_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local CLASS = player.RegClass("slender")

CLASS.main_weapons = {
    "weapon_sar2","weapon_spas12","weapon_mp7"
}

function CLASS:ShouldFootKick() return false end

function CLASS:Off()
    self.HUDTarget = nil
end

function CLASS:On()
    if CLIENT then return end

    self:SetModel("models/slenderman/slenderman.mdl")

    self:SetHealth(5000)
    self:SetMaxHealth(5000)

    self:SetRunSpeed(500)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    //self:GetPhysicsObject():SetMass(5000)

    if SERVER then self:StripWeapons() end

    self.HUDTarget = function() end

    self.stopStamina = true
end

function CLASS:PlayerFootstep(pos,foot,name,volume,filter)
    return true
end

function CLASS:PlayerDeath()
    self:SetPlayerClass()
end

function CLASS:Move(mv)
    if not self:GetNWBool("CanMove") then
        mv:SetMaxSpeed(0)
        mv:SetMaxClientSpeed(0)
    end
end

local function see(entEye,entLookup)
    if not entEye:Alive() or entLookup:GetMoveType() == MOVETYPE_NOCLIP then return false end

    local bone = entLookup:LookupBone("ValveBiped.Bip01_Head1")
    local posLookup = entLookup:GetBonePosition(bone)
    if not posLookup then return end

    local eye,ang = entEye:Eye()
    local dis = eye:Distance(posLookup)

    if dis <= 12 then return true,true end
    if dis > (GetGlobalVar("Fog Dis") or 16000) then return false end

    local tr = {
        start = eye,
        endpos = posLookup,
        filter = {entEye,entEye:GetNWEntity("Ragdoll")},
        mask = MASK_SHOT
    }

    local result = util.TraceLine(tr)
    if result.HitPos == endpos or result.Entity ~= entLookup then return end

    return util.EyeCanSee(eye,ang:Forward(),posLookup,0.4)
end

local delay = 0

function CLASS:Think()
    if CLIENT then return end

    local meSee = false
    local canHit

    if delay < CurTime() then
        delay = CurTime() + 0.1
        canHit = true
    end

    local players = {}

    for i,ply in pairs(player.GetAll()) do
        if ply == self or not see(ply,self) then continue end

        meSee = true

        players[ply] = true
    end

    if self:KeyDown(IN_ATTACK) then
        if not self:GetNWBool("Visible") then
            if self:GetNWFloat("Cooldown") < CurTime() and not meSee then
                self:SetNWBool("Visible",true)
                self:SetVelocity(Vector())

                self.dmg = 3
                self.canMove = false
            end
        else
            self.canMove = false
            self:SetNWFloat("Cooldown",CurTime() + 5)
        end
    elseif self:KeyDown(IN_ATTACK2) then
        if not self:GetNWBool("Visible") then
            if self:GetNWFloat("Cooldown2",0) < CurTime() and meSee then
                self:SetNWBool("Visible",true)
                self.canMove = false
                self:SetNWFloat("Cooldown2",CurTime() + 15)
                self:SetVelocity(Vector())

                self.dmg = 1
            end
        end
    else
        if not meSee then
            self:SetNWBool("Visible",false)
            self.canMove = true
        else
            self:SetNWFloat("Cooldown",CurTime() + 1)
        end
    end
    
    if self:GetNWBool("Visible") and canHit then
        for ply in pairs(players) do
            local dmgTab = CreateDamageTab(ply,self,self,self.dmg)

            ply:TakeDamageTab(dmgTab)
        end
    end

    if self.canMove then
        self:SetNWAngle("Angle",self:GetAngles())
    end

    self:SetNWBool("MeSee",meSee)
    self:SetNWBool("CanMove",self.canMove)
end

if SERVER then
    function CLASS:Fake() return false end
    function CLASS:CanPickupItem() return self:GetMoveType() == MOVETYPE_NOCLIP end
    function CLASS:JModArmorEquip() return false end

    function CLASS:Pain() return false end
    function CLASS:DamageImpulse() return false end
    function CLASS:DamageBlood() return false end

    return
end

function CLASS:CalcView(view)
    if GetViewEntity() ~= LocalPlayer() then return end

    view.vec = self:GetPos() + Vector(0,0,75)
    view.drawviewer = false

    return view
end

function CLASS:PlayerDraw()
    if self:GetNWBool("Visible") then
        local mdl = GetClientSideModelID(self:GetModel(),tostring(self))
        mdl:SetRenderOrigin(self:GetPos())
        mdl:SetRenderAngles(self:GetNWAngle("Angle"))
        mdl:DrawModel()
    end

    return true
end

local slender = 0
local oldSlender = 0
local delayshort = 0

local whitenoise = Material("homigrad/vgui/whitenoise.png","noclamp 1")

local random,Rand = math.random,math.Rand

local red,yellow,white = Color(255,0,0),Color(255,255,0),Color(255,255,255)

local snd

hook.Add("PostDrawEffects","Slender",function()
    local ply = LocalPlayer()

    if ply.PlayerClassName == "slender" or not ply:Alive() then
        if IsValid(snd) then snd:Remove() end

        return
    end
    
    local time = RealTime()
    local ft = FrameTime()

    local iSee

    for i,ply2 in pairs(player.GetAll()) do
        if not ply2:GetNWBool("Visible") or ply2.PlayerClassName ~= "slender" or not see(ply,ply2) then continue end

        slender = math.min(slender + 10 * ft,1)

        iSee = true
    end

    if not iSee then
        slender = math.max(slender - 10 * ft,0)
    end

    if slender > 0 then
        if delayshort < time then
            for i = 1,3 do
                surface.PlaySound("camera_static/closeup_short.wav")
            end
            
            surface.PlaySound("camera_static/single_big" .. math.random(1,3) .. ".wav")
        end

        delayshort = time + math.random(60,120)
    end

    oldSlender = slender

    local k = math.min(slender,1)
    
    if not IsValid(snd) then
        snd =  sound.CreatePoint(ply,"camera_static/static.wav",90)
    end

    snd:Play()

    snd.volume = k

    cam.Start2D()
        surface.SetMaterial(whitenoise)
        
        for i = 1,16 do
            surface.SetDrawColor(255,255,255,Rand(1,5) * k)

            local x,y = random(0,512),random(0,512)

            surface.DrawTexturedRectUV(-x,-y,scrw + x,scrh + y,0,0,scrw / 512 / Rand(2,3),scrh / 512 / Rand(2,3))
        end
    cam.End2D()
end)

hook.Add("PostDrawEffects","Slender Me",function()
    local ply = LocalPlayer()
    if ply.PlayerClassName ~= "slender" then return end

    cam.Start2D()
        local text,color = "Ты невидемый",white

        if ply:GetNWBool("Visible") then
            text = "Ты стоишь"
            color = yellow
        elseif ply:GetNWFloat("Cooldown") > CurTime() then
            text = "Задержка..."
            color = red
        end

        if ply:GetNWFloat("Cooldown2",0) < CurTime() then
            draw.SimpleText("Ты можешь использовать скример","H.18",scrw / 2,70,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

        draw.SimpleText(text,"H.18",scrw / 2,100,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        if ply:GetNWBool("MeSee") then
            draw.SimpleText("На тебя смотрят!","H.18",scrw / 2,130,yellow,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end

    cam.End2D()
end)

hook.Add("PostDrawOpaqueRenderables","Slender",function()
    if LocalPlayer().PlayerClassName ~= "slender" then return end

    local lamp = SlenderFlashlight
    if not IsValid(lamp) then
        lamp  = ProjectedTexture()
        SlenderFlashlight = lamp

        lamp:SetTexture("effects/flashlight001")
        lamp:SetFarZ(900)
        lamp:SetNearZ(1)
        lamp:SetFOV(135)
        lamp:SetEnableShadows(true)
    end

    lamp:SetPos(EyePos())
    lamp:SetAngles(EyeAngles())
    lamp:Update()
end)

function CLASS:CanUseSpectateHUD() return true end