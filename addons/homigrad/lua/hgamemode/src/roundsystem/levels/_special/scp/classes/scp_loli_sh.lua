-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\_special\\scp\\classes\\scp_loli_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local CLASS = player.RegClass("scploli")

function CLASS:Off()
    self.isSCP = nil

    if CLIENT then
        return
    end

    self:SetNWString("SCP","")
    self.stopStamina = nil
    self.notStun = nil
    self.notCollideFake = nil
    self.notSpeedFake = nil
    self.notFakeDownCommand = nil
    self.notPanic = nil
    --self:GodDisable()
end

function CLASS:On()
    self.isSCP = "loli"
    self.stopStamina = true
    self.notStun = true
    self.notCollideFake = true
    self.notSpeedFake = true
    self.notFakeDownCommand = true
    self.notPanic = true

    self.playersView = {}

    if CLIENT then return end

    self:SetNWString("SCP","LOLI")
    --self:GodEnable()

    self:SetModel("models/player/creepergirl/sour_creepergirl_player.mdl")
    self:SetWalkSpeed(300)
    self:SetRunSpeed(300)
    self:SetLadderClimbSpeed(400)
    
    self:GetPhysicsObject():SetMass(5000)

    self:SetPlayerColor(Vector(1,0,0))

    self:SetHealth(250)
    self:SetMaxHealth(250)
end

function CLASS:PlayerDeath() self:SetPlayerClass() end

local max,min = math.max,math.min

local scp096Here
local scp096Volume = 0

local abs,cos = math.abs,math.cos
local random,Rand = math.random,math.Rand
local Clamp = math.Clamp
local roll = 0

local killDis = 80

function CLASS:Think()
    if SERVER then
        local pos = self:GetPos()
    
        for i,ply in pairs(player.GetAll()) do
            if ply == self or not ply:Alive() or ply:HasGodMode() then continue end
            if ply:GetPos():Distance(pos) > killDis then continue end

            local pos = ply:GetPos()
            ply:Kill()

            blood_Explode(pos,pos + Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
			blood_Explode(pos,pos + Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))

			net.Start("kevin impact")
			net.WriteVector(pos)
			net.Broadcast()
        end

        if (self.delayHitDoor or 0) < CurTime() then
            self.delayHitDoor = CurTime() + 0.5

            for i,ent in pairs(ents.FindInSphere(self:GetPos(),killDis)) do
                if not ent:GetNoDraw() and JMod.IsDoor(ent) then
                    ent.hpDoor = ent.hpDoor or 100
                    ent.hpDoor = math.max(ent.hpDoor - 10,0)

                    if ent.hpDoor <= 0 then
                        JMod.BlastThatDoor(ent,self:GetAimVector() * 1024)

                        sound.Emit(ent:EntIndex(),"physics/metal/metal_grate_impact_hard" .. random(1,3) .. ".wav",120,1,120)
                        sound.Emit(ent:EntIndex(),"physics/metal/metal_sheet_impact_hard" .. random(6,7) .. ".wav",120,1,120)
                    else
                        sound.Emit(ent:EntIndex(),"physics/metal/metal_grate_impact_hard" .. random(1,3) .. ".wav",120,90)
                        sound.Emit(ent:EntIndex(),"physics/metal/metal_sheet_impact_hard" .. random(6,7) .. ".wav",120,90)
                    end
                end
            end
        end
    end
end

function CLASS:Fake() return false end
function CLASS:CanPickupItem() return self:GetMoveType() == MOVETYPE_NOCLIP end
function CLASS:JModArmorEquip() return false end

function CLASS:Pain() return false end
function CLASS:DamageImpulse() return false end
function CLASS:DamageBlood() return false end

function CLASS:PlayerDamage(dmgTab)
    if self:GetNWInt("State",0) ~= 2 then return true end
    
    dmgTab.dmg = dmgTab.dmg * 0.025

    return false
end

function CLASS:CalcMainActivity(vel)

end

function CLASS:CanUseSpectateHUD()

end

local white = Color(255,255,255)

local keyOld
local empty = {}

function CLASS:HUDPaint()
    if not CLASS.CanUseSpectateHUD(self) then
        local key = self:KeyDown(IN_WALK)
        if keyOld ~= key and key then
            SpectateHideNick = not SpectateHideNick

            chat.AddText("Ники игроков: " .. tostring(not SpectateHideNick))
        end
        keyOld = key
    end

    if not SpectateHideNick then return end

    for _,ply in pairs(player.GetAll()) do
        if not ply:Alive() then continue end

        local pos = ply:GetPos():ToScreen()
        if not pos.visible then continue end

        draw.SimpleText(ply:Nick(),"H.18",pos.x,pos.y,white,TEXT_ALIGN_CENTER,TEXT_ALING_CENTER)
    end
end

CLASS.color = Color(255,0,255)

function CLASS:TeamName()
	return "SCPLOLI",CLASS.color
end

local SCP173 = player.classList.scp173

CLASS.CanLisenOutput = SCP173.CanLisenOutput