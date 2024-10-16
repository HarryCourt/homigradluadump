-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\halflife\\freeman_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local CLASS = player.RegClass("freeman")

function CLASS:Off()
    if CLIENT then return end

    self.ProtectFireGas = nil
end

function CLASS:On()
    if CLIENT then return end

    self:SetModel("models/player/SGG/hev_helmet.mdl")

    self:SetHealth(150)
    self:SetMaxHealth(150)

    self.ProtectFireGas = true
    self.stopOrgans = true
    self.stopBlood = true
    self.stopPain = true
end

function CLASS:PlayerFootstep(pos,foot,name,volume,filter)
    if SERVER then return true end

    sound.Emit(self:EntIndex(),"npc/combine_soldier/gear" .. math.random(1,6) .. ".wav",75,1,100,pos)
end


function CLASS:PlayerDeath()
    self:SetPlayerClass()
end

function CLASS:Think()

end

function CLASS:DamageInput(dmgTab)
    dmgTab.dmg = dmgTab.dmg / 3
    dmgTab.armorMul = 0.75
    
    if dmgTab.isBullet and dmgTab.pos and dmgTab.force then
        net.Start("dmgarmor rich")
        net.WriteVector(dmgTab.pos)
        net.WriteVector(dmgTab.force)
        net.WriteEntity(self)
        net.WriteInt(math.random(1,2),4)
        net.SendPVS(dmgTab.pos)
    end
end

function CLASS:DamageImpulse(dmg) return dmg / 100 end
function CLASS:Suppress(k) return k / 5 end
function CLASS:CameraShakeDamage(ang) ang:Div(10) end
