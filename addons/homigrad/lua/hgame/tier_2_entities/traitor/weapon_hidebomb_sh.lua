-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\traitor\\weapon_hidebomb_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("weapon_hidebomb","hg_wep_base")
if not SWEP then return end

SWEP.PrintName 				= "Бомба в пропе"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "ЛКМ, чтобы заложить в проп/поставить; ПКМ, чтобы взорвать"
SWEP.Category 				= "Примочки убийцы"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 4
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= "models/props_junk/cardboard_jox004a.mdl"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

SWEP.dwsItemPos = Vector(0,0,0)
SWEP.dwsItemAng = Vector(0,0,90)
SWEP.dwsItemFOV = -10

SWEP.itemType = "other"

SWEP.EnableTransformModel = true

SWEP.wmScale = 1
SWEP.wmVector = Vector(2,1,-2)
SWEP.wmAngle = Angle(0,0,0)
SWEP.wmScale = 0.5

SWEP.HoldType = "normal"

SWEP.HolsterTime = 0
SWEP.DeployTime = 0


function SWEP:Reload() end
function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

if SERVER then
    local BigFireModels = {
        ["models/props_c17/oildrum001_explosive.mdl"] = true,
        ["models/props_c17/canister_propane01a.mdl"] = true
    }

    local FireModels = {
        ["models/props_junk/gascan001a.mdl"] = true,
        ["models/props_junk/propane_tank001a.mdl"] = true,
        ["models/props_junk/PropaneCanister001a.mdl"] = true,
        ["models/props_junk/metalgascan.mdl"] = true,
        ["models/props_c17/canister01a.mdl"] = true,
        ["models/props_c17/canister02a.mdl"] = true

    }

    local function Bomb(ent)
        local SelfPos,PowerMult,Model = ent:LocalToWorld(ent:OBBCenter()),6,ent:GetModel()

        if IsValid(ent.parentBomb) then ent.parentBomb:Remove() end

        ParticleEffect("pcf_jack_groundsplode_large",SelfPos,vector_up:Angle())
        util.ScreenShake(SelfPos,10,40,1,1000)

        if math.random(1,100) == 100 then
            for i = 1,75 do sound.Emit(nil,"snds_jack_gmod/oof.ogg",140,1,100,SelfPos) end

            if IsValid(ent) then ent:Remove() end

            return
        else
            sound.Emit(nil,"snd_jack_fragsplodefar.wav",140,1,100,SelfPos)

            for i = 1,4 do
                sound.Emit(nil,"snd_jack_fragsplodeclose.wav",140,1,200,SelfPos)
            end
        end

        if util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 3 or util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 66 then
            JMod.FragSplosion(ent, SelfPos + Vector(0, 0, 20), 1024, 50, 3500, ent.owner or game.GetWorld())
        end

        timer.Simple(.1,function()
            for i = 1, 5 do
                local Tr = util.QuickTrace(SelfPos, VectorRand() * 20)

                if Tr.Hit then
                    util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
                end
            end
        end)

        JMod.WreckBuildings(ent, SelfPos, PowerMult,nil,nil,true)
        JMod.BlastDoors(ent, SelfPos, PowerMult)

        if IsValid(ent) then ent:Remove() end

        timer.Simple(0,function()
            local ZaWarudo = game.GetWorld()
            local Infl, Att = (IsValid(ent) and ent) or ZaWarudo, (IsValid(ent) and IsValid(ent.owner) and ent.owner) or (IsValid(ent) and ent) or ZaWarudo

            BlastDamage(Infl,Att,SelfPos,400,125)
        end)

        if IsValid(ent.parentBomb) then ent.parentBomb:Remove() end
    end

    SWEP:Event_Add("Init","Normal",function(self)
        self:SetHoldType("normal")
        self:SetNWBool("HaveBomb",true)
    end)

    --local cyka = {}

    function SWEP:PrimaryAttack()
        if IsValid(self.bomb) then return end

        local owner = self:GetOwner()

        local tr = {}
        tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
        local dir = Vector(1,0,0)
        dir:Rotate(owner:EyeAngles())
        tr.endpos = tr.start + dir * 75
        tr.filter = owner

        local traceResult = util.TraceLine(tr)
        local ent = traceResult.Entity

        if not IsValid(ent) then
            ent = ents.Create("prop_physics")
            ent:SetModel("models/props_junk/cardboard_box004a.mdl")

            ent:SetPos(traceResult.HitPos)
            ent:Spawn()
        end

        self.bomb = ent
        ent.parentBomb = self

        ent:CallOnRemove("homigrad-bomb",Bomb)
        ent:EmitSound("buttons/button24.wav",75,50)
        self:SetNWBool("HaveBomb",false)
    end

    function SWEP:SecondaryAttack()
        if not IsValid(self.bomb) then return end

        local ent = self.bomb

        ent:EmitSound("snds_jack_gmod/plunger.ogg")

		timer.Simple(math.Rand(0.3,0.4),function() Bomb(ent) end)

        self.bomb = nil
        self:Remove()
    end
else
    function SWEP:ShouldRender() return self:GetNWBool("HaveBomb") end
    
    function SWEP:DrawHUD()
        local owner = self.Owner
        local tr = {}
        tr.start = owner:GetAttachment(owner:LookupAttachment("eyes")).Pos
        local dir = Vector(1,0,0)
        dir:Rotate(owner:EyeAngles())
        tr.endpos = tr.start + dir * 75
        tr.filter = owner

        local traceResult = util.TraceLine(tr)
        local ent = traceResult.Entity

        if not IsValid(ent) then
            local hit = traceResult.Hit and 1 or 0
            local frac = traceResult.Fraction
            surface.SetDrawColor(Color(255, 255, 255, 255 * hit))
            draw.NoTexture()
            Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
        else
            local frac = traceResult.Fraction
            surface.SetDrawColor(Color(255, 255, 255, 255))
            draw.NoTexture()
            Circle(traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y, 5 / frac, 32)
            draw.DrawText( "Заложить бомбу "..tostring((util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 3 or util.GetSurfaceIndex(ent:GetBoneSurfaceProp(0)) == 66) and "в металлический проп" or ""), "TargetID", traceResult.HitPos:ToScreen().x, traceResult.HitPos:ToScreen().y - 40, color_white, TEXT_ALIGN_CENTER )
        end
    end
end