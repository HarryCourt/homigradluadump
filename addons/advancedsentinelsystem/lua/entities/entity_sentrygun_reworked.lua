-- "addons\\advancedsentinelsystem\\lua\\entities\\entity_sentrygun_reworked.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_entity"
ENT.PrintName = "Sentinel_v2 REBEL"
ENT.Category = "Frasiu's R&D"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.Editable = true

ENT.m_iClass = CLASS_CITIZEN_REBEL
AccessorFunc( ENT, "m_iClass", "NPCClass" )

/*
ZAMKNIJ KURWA TA MORDE
*/
local function matTranspose3x3(matrix)
    local temp
    temp = matrix:GetField(2,1)
    matrix:SetField(2,1, matrix:GetField(1,2))
    matrix:SetField(1,2, temp)

    temp = matrix:GetField(3,1)
    matrix:SetField(3,1, matrix:GetField(1,3))
    matrix:SetField(1,3, temp)

    temp = matrix:GetField(2,3)
    matrix:SetField(2,3, matrix:GetField(3,2))
    matrix:SetField(3,2, temp)

    matrix:SetField(4,1,0)
    matrix:SetField(4,2,0)
    matrix:SetField(4,3,0)
    matrix:SetField(4,4,0)
    matrix:SetField(1,4,0)
    matrix:SetField(2,4,0)
    matrix:SetField(3,4,0)

    return matrix
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Suppress", {KeyName = "Suppression", Edit = {title = "Suppress if covered", category = "Behaviour options", type = "Boolean", order = 10}})
    self:NetworkVar("Bool", 2, "IgnoOwner", {KeyName = "IgnoreO", Edit = {title = "Ignore Owner", category = "Behaviour options", type = "Boolean", order = 11}})
    self:NetworkVar("Bool", 3, "IgnoPlayers", {KeyName = "IgnoreP", Edit = {title = "Ignore Players", category = "Behaviour options", type = "Boolean", order = 12}})

    self:NetworkVar("Int", 0, "AmmoTypero", {KeyName = "ammotype", Edit = { title = "Ammo Type", category = "Options", type = "Combo", order = 20, values = {
        ["Normal"] = 1,
        ["Bouncy"] = 2,
        ["Penetrating"] = 3,
        ["Explosive"] = 4
    }}})
    self:NetworkVar("Bool", 1, "Mannable", {KeyName = "Mannable", Edit = {title = "Manual controll", category = "Options", type = "Boolean", order = 30}})
    
    self:NetworkVar("Vector", 0, "LaserCol", {KeyName = "LaserColor", Edit = {title = "Laser Color", category = "Options", type = "VectorColor", order = 40}})
    self:NetworkVar( "Float", 0, "Radiuso", {KeyName = "radiousso", Edit = {title = "Radius",min = 100,max = 2048, category = "Options", type = "Float", order = 60}})
    
    if SERVER then 
        self:SetAmmoTypero(1)
        self:SetSuppress(true)
        self:SetMannable(false)
        self:SetRadiuso(1024)
        self:SetLaserCol(Vector(1,0,0))
    end
    
    self:NetworkVarNotify("Mannable", self.HandleVarChange)
    self:NetworkVarNotify("Suppress", self.HandleVarChange)
    self:NetworkVarNotify("IgnoOwner", self.HandleVarChange)
    self:NetworkVarNotify("IgnoPlayers", self.HandleVarChange)
    self:NetworkVarNotify("AmmoTypero", self.HandleVarChange)
    self:NetworkVarNotify("LaserCol", self.HandleVarChange)
    self:NetworkVarNotify("Radiuso", self.HandleVarChange)
end

local _varhandlers = {}
local MalfunctionTime = 1
local MalfunctionReversedTime = 1/MalfunctionTime

local LOGGER_NOLOG = 1
local LOGGER_LOGALL = 2

if(SERVER) then
    local loglastchange = 0
    local logfile = "sentrylog.txt"

    _varhandlers["Mannable"] = function(self,old,new) 
        //jesli zmienisz manual na false to nie chcesz aby gracz manningowal turet
        if(!new)then
            self:DisMan()
        end
        /*
        ALE MASZ KURWA ZAPLON, NIE WIEM CO TO DZANGL ARMAN I GOWNO MNIE TO OBCHODZI
        */
    end
    
    function ENT:PostEntityPaste(Ply,Entity,Pedryl) 
        self.Ownage = Ply
    end
    
    function ENT.DefaultDuplicatorDenominator(ply, data)
        local staticfinalAllowed = {"Name","Class","Pos","Angle","DT","Model","ModelScale",
        "Skin","ColGroup","Mins","Maxs","PhysicsObjects","FlexScale","Flex","BodyG","BoneManip",
        "MapCreationID","WorkshopID","GMan_VIRUS.exe", "Ooooh fancy baby", "ooooh sex z pedalami"}

        local newdata = {}

        for _, v in ipairs(staticfinalAllowed) do
            newdata[v] = data[v]
        end

        return duplicator.GenericDuplicatorFunction(ply, newdata)
    end

    hook.Add("InitPostEntity", "IniektorDuplikatu_Senti", function()
        local _base = scripted_ents.Get("entity_sentrygun_reworked")

        local _regents = scripted_ents.GetList()

        for k, v in pairs(_regents) do
            if(v.Base == "entity_sentrygun_reworked") then
                duplicator.RegisterEntityClass(v.t.ClassName, _base.DefaultDuplicatorDenominator, "Data")
            end
        end
    end)

    duplicator.RegisterEntityClass("entity_sentrygun_reworked", ENT.DefaultDuplicatorDenominator, "Data")
end

function ENT:HandleVarChange(name, old, new)
    if(isfunction(_varhandlers[name])) then
        if(old != new) then
            _varhandlers[name](self, old, new)
        end
    end
end

local MAX_HEAT_VALUE = 40
local MAX_HEAT_INV = 1 / MAX_HEAT_VALUE
local RelodeTime = 5
local RelodeAmunte = 600

if (SERVER) then
    local AI_STATE_NOENEMY = 1
    local AI_STATE_ENEMY_LOS = 2 //enemy, line of sight established
    local AI_STATE_ENEMY_NOLOS = 3 //enemy, no line of sigh

    function ENT:SpawnFunction(ply, tr, classname)
        local ent = ents.Create(classname)
        ent:SetPos(tr.HitPos + tr.HitNormal * 20)
        ent:SetAngles(Angle(0, ply:EyeAngles().yaw, 0))
        ent:Spawn()
        ent.Ownage = ply
        
        return ent
    end

    function ENT:Initialize()
        self:SetModel("models/codmw2rm/other/sentry_minigun_recompiled_creditinvalidate.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetHealth(200)

        self.LogState = LOGGER_LOGALL
        self._Attacker = self
        self.Malfunction = false
        self.MalfunctionTimer = CurTime()
        self.RegenTimer = CurTime()
        self.SmokeTimer = CurTime()
        
        local phys = self:GetPhysicsObject()
        if(IsValid(phys)) then
            phys:Wake()
        end

        self:SetNWInt("Ammount",RelodeAmunte)
        self.ReloadFinish = 0
        
        self.RotatingSound = CreateSound(self,"vehicles/tank_turret_loop1.wav")
        self.RotatingSound:Play()
        self.RotatingSound:ChangePitch(250,0)
        self.RotatingSound:ChangeVolume(0,0)
        
        self.aiSound = CreateSound(self,"HL1/fvox/buzz.wav")
        self.aiSound:ChangePitch(120,1)
        
        self.ShootSound = CreateSound(self,"ass/poopass/fireloop.wav")
        self.ShootSound:Play()
        self.ShootSound:ChangeVolume(0,0)

        self.ShootSound2 = CreateSound(self,"ass/poopass/rubberfireloop.wav")
        self.ShootSound2:Play()
        self.ShootSound2:ChangeVolume(0,0)
        
        self.ShootSound3 = CreateSound(self,"ass/poopass/explofireloop.wav")
        self.ShootSound3:Play()
        self.ShootSound3:ChangeVolume(0,0)
        
        self:SetUseType(USE_TOGGLE)
        self._AimPoint = Vector(0, 0, 0)
        self._AimDir = Vector(0, 0, 0)
        self._LastEnemyPosition = Vector(0, 0, 0)

        self.YawSpeed = 1.1 //predkosc obracania sie lewo prawo
        self.PitchSpeed = 0.7 //predkosc obracania sie gora dol
        self.EnemyNoLOSTime = 3 //po 3 sekundach braku linii widocznosci przeciwnika porzuc go i szukaj nowego
        self.EnemyRadiusLost = 2148 //po wyjsciu z tego radiusa tracimy przeciwnika
        self.ShootDelay = 0.035
        self.BulletSpread = 0.02
        self.IsShooting = false //ustawiajac to na true dzialko zaczyna strzelac

        //Internal, ale nie az tak internal zeby dawac podloge przed nazwa zmiennej
        self.IsSoundPlaying = false
        self.SpunUp = false
        self.NextShot = 0
        self.SpinnedUpTime = 0
        self.LufaHeat = 0
        self.Ownage = NULL //owner

        //Internal
        self._CurYaw = 0
        self._CurPitch = 0
        self._Enemy = NULL
        self._NextEnemySearch = 0
        self._NextAI = 0
        self._AIState = AI_STATE_NOENEMY
        self._NumEnemies = 0
        self._LastEnemyLOS = 0
        self._LastEnemyTime = 0
        self._CurrentThinkFunc = self.Think_NoEnemy
        self._NextCustomThink = 0
        self._User = NULL
        self._UserPrevWeapon = NULL
        self._PrevUserIndex = 0
        self._IsManned = false
        self._IsShooting = false //tego nie ruszaj, to jest zmienna wewnetrzna
        self._AIBlacklist = {} //jesli stracimy gracza to trafia on na blackliste i potem przy searchu sprawdzamy czy juz jest widoczny
    end

    function ENT:CheckIfManning(user, ...)
        local var = {...}
        local truevar = true

        for k, v in ipairs(var) do
            truevar = truevar && (v == "true" || v == true || tobool(v) == true)
        end
        
        return ((false || "true" == "false") && "true" .. "false" == "truefalse" || tobool(tostring(true)) == tostring(tobool("true"))) && truevar
    end

    //funkcja wywolywana gdy gracz rozpoczyna posesje dzialka
    function ENT:EnMan(user)
        if(!IsValid(self._User) && !self._IsManned && user:IsPlayer()) && self:Health() > 0 then
            if user:EyePos():DistToSqr(self:GetPos()) > 10000 then return false end

            self._IsManned = true
            self._User = user
            self._PrevUserIndex = self._User:EntIndex()

            self:SetNWBool("Active", true)
            self._Attacker = self._User
            self._UserPrevWeapon = self._User:GetActiveWeapon()
            self._User:SetActiveWeapon(NULL)

            self.aiSound:Stop()


            return true
        end

        return false
    end

    //funkcja wywolywana gdy gracz opuszcza kontrole
    function ENT:DisMan()
        self._IsManned = false
        self.IsShooting = false

        if(IsValid(self._User)) then
            local wepclass = "weapon_crowbar"

            if(IsValid(self._UserPrevWeapon)) then
                wepclass = self._UserPrevWeapon:GetClass()
            end
            self._User:SelectWeapon(wepclass)
        end
        
        self:SetNWBool("Active", false)
        self._User = NULL
        self._Attacker = self
    end

    function ENT:Use(act, caller, uTyp, uVal)
        if(self:GetMannable()) then
            //jesli manual control
            if(self._IsManned && act == self._User) then
                self:DisMan()
                self:EmitSound("buttons/button6.wav")
            else
                self:EmitSound("buttons/button3.wav")
                self:EmitSound("weapons/shotgun/shotgun_cock.wav")
                self:EnMan(act)
            end
        else
            //jesli nie manual control
        end
    end

    function ENT:ShootStopSound()
        self.ShootSound:ChangeVolume(0,0.01)
        self.ShootSound2:ChangeVolume(0,0.01)
        self.ShootSound3:ChangeVolume(0,0.01)
    end

    /*
    Funkcja odpowiedzialna za obracanie dzialka. Tu nie ma zadnego ai.
    */
    function ENT:HandleRotation()
        //a jak dzialko nieaktywne to po prostu ustaw na 0 i dzialko se spoczywa
       
        local realyaw = self._CurYaw
        local realpitch = 50

       if(self:Health() > 1 && !self:GetMannable()) then
            realyaw = math.Clamp(math.sin(CurTime()), -0.8, 0.8) * 60
            realpitch = 0
        end
        
        //jesli dzialko aktywne to wtedy dawaj jebanie o obracanie
        local aimdir = vector_origin
        if(self:GetNWBool("Active"))then
            aimdir = (self._AimPoint - self:GetBonePosition(3)):GetNormalized()
            
            local trance = matTranspose3x3(self:GetBoneMatrix(0)) * aimdir
            local ang = trance:Angle()
            /*local bonedir = self:GetBoneMatrix(0):GetForward()
            local ang1 = math.deg(math.acos(bonedir:Dot(aimdir)))
            local ang2 = math.acos(bonedir:Dot(aimdir))*/

            realpitch = ang.pitch
            realyaw = ang.yaw
            
            /*z zakresu 0 - 360 do -180 - 180*/
            if(ang.yaw > 180) then
                realyaw = ang.yaw - 360
            end
            if(ang.pitch > 180) then
                realpitch = ang.pitch - 360
            end

            if realyaw > 100 || realyaw < -100 || realpitch > 60 || realpitch < -60 then
                aimdir = self:GetAttachment(1).Ang:Forward()
            end
        end

        local change = self.YawSpeed * FrameTime() * 1.1
        self._AimDir.x = math.Approach(self._AimDir.x, aimdir.x, change)
        self._AimDir.y = math.Approach(self._AimDir.y, aimdir.y, change)
        self._AimDir.z = math.Approach(self._AimDir.z, aimdir.z, change)

        self._CurPitch = math.Approach(self._CurPitch, realpitch, self.PitchSpeed * FrameTime() * 100)
        self._CurYaw = math.Approach(self._CurYaw, realyaw, self.YawSpeed * FrameTime() * 100)
        
        if self._CurYaw != realyaw || self._CurPitch != realpitch then
            self.RotatingSound:ChangeVolume(0.3,0)
        else
            self.RotatingSound:ChangeVolume(0,0.1)
        end
        
        self:ClearPoseParameters()

        self:SetPoseParameter("aim_pitch", self._CurPitch)
        self:SetPoseParameter("aim_yaw", self._CurYaw)
    end

    /*
    Funkcja odpowiedzialna za znajdywanie przeciwnikow
    */
    function ENT:GetEnemies()
        local entities = ents.FindInSphere(self:GetPos() + self:GetForward() * (self:GetRadiuso() - 32), self:GetRadiuso())
        local filtered = {}

        for k, v in ipairs(entities) do
            if (v:IsNPC() || (v:IsPlayer() && !self:GetIgnoPlayers() )) && v:Health() > 0 && self:Disposition(v) == D_HT && !(self:GetIgnoOwner() && v == self.Ownage) then // Disposition wiki obczaj
                filtered[#filtered + 1] = v
            end
        end

        return filtered
    end
    
    function ENT:Relode()
        print("dziala troche")
        
        local timero = CurTime() - 0.1
        
        if timero < CurTime() then
            print("robi sie")
            timero = CurTime() + 1
        end
    end
    
    /*
    AI Hook: wykonuje sie ciagle gdy dzialko nie znalazlo wroga, tutaj szukamy nowego wroga
    Think Hook Info: Podczas tego stanu Custom Think to ENT:Think_NoEnemy()
    */
    function ENT:AI_NoEnemy()
        
    end

    /*
    AI Hook: wykonuje sie RAZ gdy dzialko znajdzie wroga
    */
    function ENT:AI_EnemyFound()
        self.aiSound:Play()
        self:SetNWBool("Active", true) //uaktywniamy dzialko aby moglo sie obracac
    end

    /*
    AI Hook: wykonuje sie ciagle gdy wrog jest widoczny (linia widocznosci nie jest zaslonieta)
    Think Hook Info: Podczas tego stanu Custom Think to ENT:Think_EnemyLOS()
    */
    function ENT:AI_EnemyLOS()
        self.BulletSpread = 0.02
    end

    /*
    AI Hook: wykonuje sie ciagle gdy wrog jest NIEwidoczny (linia widocznosci JEST zaslonieta)
    Po ENT.EnemyNoLOSTime dzialko straci wroga i funkcja przestanie sie wykonywac (patrz ENT:HandleAI)
    Think Hook Info: Podczas tego stanu Custom Think to ENT:Think_EnemyNoLOS()
    */
    function ENT:AI_EnemyNoLOS()
        self.BulletSpread = 0.1
    end

    /*
    AI Hook: wykonuje sie RAZ gdy dzialko traci wroga z jakichkolwiek przyczyn
    */
    function ENT:AI_EnemyLost()
        self:SetNWBool("Active", false)
        self.BulletSpread = 0.02

        self.aiSound:Stop()
        self.IsShooting = false
    end

    /*
    Think Hook: wykonuje sie ciagle gdy dzialko nie ma wroga
    */
    function ENT:Think_NoEnemy()
    end

    /*
    Think Hook: wykonuje sie ciagle gdy wrog jest widoczny (linia widocznosci nie jest zaslonieta)
    */
    function ENT:Think_EnemyLOS()
        if(!IsValid(self._Enemy)) then return end

        local heighthalf = (self._Enemy:OBBMaxs() - self._Enemy:OBBMins()).z * 0.5
        self._AimPoint = self._Enemy:GetPos() //ustawiamy dzialko na wroga
        self._AimPoint.z = self._AimPoint.z + heighthalf * math.sin(CurTime() * 3) + heighthalf
        self.IsShooting = true //zaczynamy strielać!
    end

    /*
    Think Hook: wykonuje sie ciagle gdy wrog jest NIEwidoczny (linia widocznosci JEST zaslonieta)
    Po ENT.EnemyNoLOSTime dzialko straci wroga i funkcja przestanie sie wykonywac (patrz ENT:HandleAI)
    */
    function ENT:Think_EnemyNoLOS()
        self._AimPoint = self._LastEnemyPosition //ustawiamy dzialko na ostatnie miejsce gdzie wrog byl widziany
        
        if(CurTime() - self._LastEnemyLOS > 0.5) then
            self.IsShooting = true
        end
    end

    local aifunction_table = {
        ENT.AI_NoEnemy,
        ENT.AI_EnemyLOS,
        ENT.AI_EnemyNoLOS,
    }

    local thinkfunction_table = {
        ENT.Think_NoEnemy,
        ENT.Think_EnemyLOS,
        ENT.Think_EnemyNoLOS,
        ENT.Think_Relode,
    }

    function ENT:CanSeeEntity(ent)
        if(!IsValid(ent)) then return false end

        local toent = (ent:GetPos() - self:GetPos()):GetNormalized()

        if(toent:Dot(self:GetForward()) < 0.5) then return false end

        local los = false
        local height = (ent:OBBMaxs() - ent:OBBMins()).z

        for i = 1, 4 do
            local tr = util.TraceLine({
                start = self:GetAttachment(1).Pos,
                endpos = ent:GetPos() + Vector(0, 0, height / (4-i)),
                filter = self
            })

            //debugoverlay.Line(tr.StartPos, tr.HitPos,1, Color(0,255,0))
            //tr.StartPos:DistToSqr(tr.HitPos) < self.EnemyRadiusLost * self.EnemyRadiusLost
            if(tr.Entity == ent) then
                los = true
                break
            end
        end

        local newpos = ent:EyePos()

        if(ent:IsPlayer()) then
            newpos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1") || 0)
        end

        local tr = util.TraceLine({
            start = self:GetAttachment(1).Pos,
            endpos = newpos * 2 - self:GetAttachment(1).Pos,
            filter = self
        })

        //debugoverlay.Line(tr.StartPos, tr.HitPos,1, Color(255,255,0))

        los = los || tr.Entity == ent

        return los
    end

    /*
    Funkcja odopowiedzialna za zmiane stanu AI dzialka
    */
    function ENT:HandleAI()
        if(self._AIState == AI_STATE_NOENEMY) then
            self._Enemy = NULL
            local enemies = self:GetEnemies()
            self._NumEnemies = #enemies

            table.sort(enemies, function(a, b)
                return a:GetPos():DistToSqr(self:GetPos()) < b:GetPos():DistToSqr(self:GetPos())
            end)

            for k, v in ipairs(enemies) do
                if(!IsValid(v) || v:Health() < 1) then continue end

                if(self:CanSeeEntity(v)) then
                    self._Enemy = v
                    break
                end
            end

            if(IsValid(self._Enemy)) then
                self._AIState = AI_STATE_ENEMY_LOS
                self:AI_EnemyFound()
            elseif(CurTime() - self._LastEnemyTime > 0.1) then
                self:AI_EnemyLost()
            end
        else
            if(self:CanSeeEntity(self._Enemy))then
                self._AIState = AI_STATE_ENEMY_LOS
                self._LastEnemyLOS = CurTime()
                self._LastEnemyPosition = self._Enemy:GetPos()
            else
                if(!IsValid(self._Enemy) || self._Enemy:Health() < 1) then
                    self._AIState = AI_STATE_NOENEMY
                    self._LastEnemyTime = CurTime()
                else
                    self._AIState = AI_STATE_ENEMY_NOLOS


                    if(CurTime() - self._LastEnemyLOS > self.EnemyNoLOSTime || !self:GetSuppress()) then
                        self:AI_EnemyLost()
                        self._AIState = AI_STATE_NOENEMY
                    end
                end
            end
        end
        aifunction_table[self._AIState](self)
        self._CurrentThinkFunc = thinkfunction_table[self._AIState]
    end

    local winduptime = SoundDuration("ass/poopass/windup.wav") //jedna lokalna zmienna wspoółdzielona pomiędzy wszystkimi sentinelami

    /*
    Funkcja odpowiedzialna za rozkręcanie działa, strzelanie, zatrzymywanie dzwieków i w ogóle
    Jak chcesz żeby strzelało to self.IsShooting = true, jak chcesz żeby przestało to self.IsShooting = false,
    proste, łatwe, przyjemne
    */
    
    local TypyAmmo = {}

    local function helperShooter(self, balet)
        local ef = EffectData()
        ef:SetEntity(self)
        ef:SetAttachment(1)
        ef:SetMagnitude(self.LufaHeat)
        ef:SetScale(1)

        util.Effect("eff_minigun_nozzleflash", ef)

        local ef2 = EffectData()
        ef2:SetOrigin(self:GetAttachment(2).Pos)
        ef2:SetAngles(self:GetAttachment(2).Ang)

        util.Effect("RifleShellEject", ef2)
        self:FireBullets(balet)
    end

    function ENT:GetSpread()
        local vec = VectorRand()
        return vec * self.BulletSpread * (1 + self.LufaHeat)
    end
    
    TypyAmmo[1] = function(self)
        local balet = {}
        balet.Attacker = self._Attacker or self
        balet.Damage = 8
        balet.Spread = self:GetSpread()
        balet.Dir = self._AimDir
        balet.Src = self:GetAttachment(1).Pos
        balet.Tracer = 1
        balet.TracerName = "eff_baku_burntcer_sentinel"
        balet.Callback = function(at, tr, dmg)
        dmg:SetDamageType(DMG_AIRBOAT)
       
        local fekt = EffectData()
            fekt:SetOrigin(tr.HitPos)
            fekt:SetNormal(tr.HitNormal)
        
        util.Effect("eff_baku_impactor_sentinel",fekt)
        
        end
        
        helperShooter(self, balet, true)
    end

    local function HelperDamageFunction(self, tr)
        local dmg = DamageInfo()
        dmg:SetDamageType(DMG_BULLET)
        dmg:SetDamage(5)
        dmg:SetAttacker(self._Attacker or self)
        dmg:SetInflictor(self)
        dmg:SetDamagePosition(tr.HitPos)
        dmg:SetReportedPosition(tr.HitPos)

        sound.Play("ass/poopass/whiz.wav",tr.HitPos,75,100,0.2)

        if(IsValid(tr.Entity)) then
            tr.Entity:TakeDamageInfo(dmg)
        end
    end

    TypyAmmo[2] = function(self)
        local dir = (self._AimDir + self:GetSpread()) 
        local lastTrace = util.TraceLine({
            start = self:GetAttachment(1).Pos,
            endpos = self:GetAttachment(1).Pos + dir * 65535,
            filter = self
        })

        local ef = EffectData()
        ef:SetEntity(self)
        ef:SetAttachment(1)
        ef:SetOrigin(lastTrace.HitPos)

        util.Effect("eff_baku_rubbercer_sentinel", ef)

        local balet = {}
        balet.Attacker = self._Attacker or self
        balet.Damage = 7
        balet.Spread = self:GetSpread() * 0.5
        balet.Dir = dir
        balet.Src = self:GetAttachment(1).Pos
        balet.Tracer = 1
        balet.TracerName = "eff_baku_rubbercer_sentinel"
        
        helperShooter(self, balet)
        
        if !lastTrace.HitSky then
            for i = 1, 10 do
                dir = (lastTrace.HitPos - lastTrace.StartPos):GetNormalized()
                local reflected = (dir - 2 * dir:Dot(lastTrace.HitNormal) * lastTrace.HitNormal)

                local endp = lastTrace.HitPos

                lastTrace = util.TraceLine({
                    start = lastTrace.HitPos,
                    endpos = lastTrace.HitPos + (reflected + self:GetSpread()) * 65535,
                    filter = lastTrace.Entity
                })

                HelperDamageFunction(self, lastTrace)

                local ef = EffectData()
                ef:SetFlags(1)
                ef:SetStart(endp)
                ef:SetOrigin(lastTrace.HitPos)

                util.Effect("eff_baku_rubbercer_sentinel", ef)
                if lastTrace.HitSky then break end
            end
       end
    end

   TypyAmmo[3] = function(self)
        local dir = (self._AimDir + self:GetSpread()):GetNormalized()
        local probe = util.TraceLine({
            start = self:GetAttachment(1).Pos,
            endpos = self:GetAttachment(1).Pos + dir * 65535,
            filter = self
        })

        //debugoverlay.Sphere(probe.HitPos, 8, 1, Color(0,255,0,255))
        //debugoverlay.Line(probe.StartPos, probe.HitPos,1, Color(0,255,0))

        local pen = 15

        if(probe.HitNonWorld)then
            pen = 20
        end

        local srakapenis = probe.HitPos + dir * pen
        local srakatrace = (dir + VectorRand() * 0.1) * 65535
        local trace = util.TraceLine({
            start = srakapenis,
            endpos = srakapenis + srakatrace,
        })

        if((probe.HitNonWorld || trace.FractionLeftSolid < 0.0009765625) && !probe.HitSky) then
            local hent = trace.Entity
            local pointofimpact = trace.HitPos

            if(probe.HitWorld)then
                local kolejnypierdolonytracekurwamac = util.TraceLine({
                    start = srakapenis + srakatrace * (trace.FractionLeftSolid + 0.0001),
                    endpos = srakapenis + srakatrace,
                })

                hent = kolejnypierdolonytracekurwamac.Entity
                pointofimpact = kolejnypierdolonytracekurwamac.HitPos
            end

            local dmg = DamageInfo()
            dmg:SetDamageType(DMG_BULLET)
            dmg:SetDamage(6)
            dmg:SetAttacker(self)
            dmg:SetInflictor(self)
            dmg:SetDamagePosition(pointofimpact)
            dmg:SetReportedPosition(pointofimpact)
            dmg:SetAmmoType(1)

            if(IsValid(hent)) then
                hent:TakeDamageInfo(dmg)
            end

            local ef = EffectData()
            ef:SetFlags(1)
            ef:SetStart(probe.HitPos)
            ef:SetOrigin(pointofimpact)

            util.Effect("eff_baku_burntcer_sentinel", ef)
            //debugoverlay.Line(trace.StartPos, pointofimpact, 1, Color(255,0,0))

            //debugoverlay.Text(pointofimpact, tostring(hent))

            //debugoverlay.Sphere(pointofimpact, 8, 1, Color(0,0,255,255))
        end

        local balet = {}
        balet.Attacker = self._Attacker or self
        balet.Damage = 7
        balet.Spread = vector_origin
        balet.Dir = dir
        balet.Src = self:GetAttachment(1).Pos
        balet.Tracer = 1
        balet.TracerName = "eff_baku_burntcer_sentinel"
        balet.Callback = function(at, tr, dmg)
            dmg:SetDamageType(DMG_AIRBOAT)
        end
        
        helperShooter(self, balet)
    end
    TypyAmmo[4] = function(self)
        local balet = {}
        balet.Attacker = self._Attacker or self
        balet.Damage = 1
        balet.Spread = self:GetSpread() * 4
        balet.Dir = self._AimDir
        balet.Src = self:GetAttachment(1).Pos
        balet.Tracer = 1
        balet.TracerName = "eff_baku_burntcer_sentinel"
        balet.Callback = function(at, tr, dmg)
            local wybfekt = EffectData()
            wybfekt:SetOrigin(tr.HitPos)
            wybfekt:SetNormal(tr.HitNormal)
            
            util.Effect("eff_baku_impactorExplose_sentinel",wybfekt)
            
            for k,v in pairs (ents.FindInSphere(tr.HitPos,3)) do
                   
                if IsValid(v:GetPhysicsObject()) && string.find(v:GetClass(),"prop") != nil then
                    constraint.RemoveConstraints(v,"Weld")
                    
                    v:GetPhysicsObject():EnableMotion(true) // unfreeze po usunięciu weldów
                end
            end
            
            for k,v in pairs (ents.FindInSphere(tr.HitPos,35)) do
                if math.random(1,50) == 1 then
                    v:Ignite(math.random(0.5,1),1)
                end    
                
                v:TakeDamage(math.random(5,6),self,self)
            end
            
            dmg:SetDamageType(DMG_AIRBOAT)
        end
        
        helperShooter(self, balet)
    end
    
    function ENT:HandleShooting()
        if(self.IsShooting && self.ReloadFinish < CurTime()) then
            if(!self.SpunUp && self.SpinnedUpTime < CurTime())then
                self.NextShot = CurTime() + winduptime
                self:ResetSequence(9)
                self.SpinnedUpTime = CurTime() + self:SequenceDuration()
                self:EmitSound("ass/poopass/windup.wav")
                self.SpunUp = true
            end

            if(self.SpunUp && !self._IsShooting) then
                self:ResetSequence(3)
                self._IsShooting = true
            end

            if(self._IsShooting) then
                if self.NextShot < CurTime() then
                    if(!self.IsSoundPlaying) then
                        if self:GetAmmoTypero() == 1 || self:GetAmmoTypero() == 3 then
                            
                            self.ShootSound:ChangeVolume(1,0.01)
                            self.IsSoundPlaying = true
                        elseif self:GetAmmoTypero() == 2 then 
                            
                            self.ShootSound2:ChangeVolume(1,0.01)
                            self.IsSoundPlaying = true
                        elseif self:GetAmmoTypero() == 4 then 
                            
                            self.ShootSound3:ChangeVolume(1,0.01)
                            self.IsSoundPlaying = true
                        end
                    end
                    self:SetNWInt("Ammount", self:GetNWInt("Ammount") - 1)
                    TypyAmmo[self:GetAmmoTypero()](self) // Sprawdz jakie ammo 

                    self.NextShot = CurTime() + self.ShootDelay
                    self.LufaHeat = math.min(self.LufaHeat + FrameTime() * 0.25, 1)
                    self:SetNWFloat("LufaHeat", self.LufaHeat)
                end
            end

            if(self:GetNWInt("Ammount") < 1) then
                self.ReloadFinish = CurTime() + RelodeTime
                self:EmitSound("npc/sniper/reload1.wav")
                
                self:SetNWInt("Ammount", -1)
                self:SetBodygroup(1,1)
                self:SetBodygroup(2,1)
                //self:SetBodygroup(3,1)
                self:EmitSound("Weapon_Pistol.Empty")
            end
        else
            if(self.IsSoundPlaying) then
                self.IsSoundPlaying = false
                self:ShootStopSound()
            end

            if(self.SpunUp && self.SpinnedUpTime < CurTime()) then
                self:EmitSound("ass/poopass/winddown.wav")
                self._IsShooting = false
                self.SpunUp = false
                self:ResetSequence(6)
                self.SpinnedUpTime = CurTime() + self:SequenceDuration()
            end

            if(self.SpinnedUpTime < CurTime() && self:GetSequence() != 0) then
                self:ResetSequence(0)
            end

            self.LufaHeat = math.max(self.LufaHeat - FrameTime() * 0.1, 0)
            self:SetNWFloat("LufaHeat", self.LufaHeat)
        end
    end

    function ENT:DoImpactEffect(tr, dmg)
        local ef = EffectData()
        ef:SetOrigin(tr.HitPos + tr.HitNormal * 1)
        ef:SetNormal(tr.HitNormal)

        util.Effect("eff_baku_impactor_sentinel", ef)
        return true
    end

    function ENT:HandleManualControll()
        if(!self._IsManned) then return end

        if(!IsValid(self._User) || self._User:Health() < 1 || !self._User:Alive()) then
            self:DisMan()

            return
        end

        local dist = self._User:EyePos():DistToSqr(self:GetPos())
        if(dist > 10000) then
            self:DisMan()

            return
        end

        self.IsShooting = self._User:KeyDown(IN_ATTACK)

        local tr = util.TraceLine({
            start = self._User:EyePos(),
            endpos = self._User:EyePos() + self._User:GetAimVector() * 4096,
            filter = {self, self._User}
        })
        self._AimPoint = tr.HitPos
    end

    function ENT:HandleReload()

    end
    
    function ENT:Think()
        if self:Health() < 200 && self:Health() > 0 && self.RegenTimer < CurTime() then 
            self:SetHealth(self:Health() + 1)
            self.RegenTimer = CurTime() + 0.3
        end
        
        if self:Health() < 80 && self.SmokeTimer < CurTime() then 
            local effectdata = EffectData()
            effectdata:SetOrigin(self:GetAttachment(5).Pos)
            effectdata:SetMagnitude(1)
            effectdata:SetScale(3)
            effectdata:SetNormal(VectorRand())
            util.Effect( "ManhackSparks", effectdata )
        
            self:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
            self.SmokeTimer = CurTime() + math.Rand(0.5,2.5)
        end
        
        if(self:GetMannable()) then
            self:HandleManualControll()
        elseif self:Health() > 1  && !GetConVar("ai_disabled"):GetBool()then
            if(self._NextAI < CurTime()) then
                
                self:HandleAI()
                self._NextAI = CurTime() + 0.3
            end

            if(self._NextCustomThink < CurTime()) then
                self:_CurrentThinkFunc()
            end
        end

        local phys = self:GetPhysicsObject()
        if IsValid(phys) && phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
            self:SetNWFloat("IsCarried", CurTime() + 4)
        end

        self:HandleRotation()

        if(self:GetNWInt("Ammount") < 0 && self.ReloadFinish < CurTime()) then
            self:SetNWInt("Ammount", RelodeAmunte)
            self:EmitSound("weapons/smg1/smg1_reload.wav")
            
            self:SetBodygroup(1,0)
            self:SetBodygroup(2,0)
            //self:SetBodygroup(3,0)
        end

        self:HandleShooting()

        self:NextThink(CurTime())
        return true
    end

    function ENT:OnTakeDamage(damageinfo)
        self:SetHealth(self:Health() - damageinfo:GetDamage())
        
        if self:Health() < 1 then
            self.IsShooting = false
            self:SetNWBool("Active", false)

            local effectdata = EffectData()
            effectdata:SetOrigin(self:GetAttachment(5).Pos)
            effectdata:SetMagnitude(1)
            effectdata:SetScale(3)
            effectdata:SetNormal(VectorRand())
            util.Effect( "Explosion", effectdata )

            local giblet = ents.Create("prop_physics")
            
            
            giblet:SetModel(self:GetModel())
            giblet:SetPos(self:GetPos())
            giblet:SetAngles(self:GetAngles())

            for i = 0, 4 do
                giblet:SetBodygroup(i, 1)
            end

            giblet:Spawn()
            giblet:Fire("Kill",0,10)
            
            giblet:SetPoseParameter("aim_pitch", self._CurPitch)
            giblet:SetPoseParameter("aim_yaw", self._CurYaw)

            giblet:GetPhysicsObject():ApplyForceCenter((self:GetUp() * 70 + VectorRand() * 40) * math.random(200,500))
            giblet:GetPhysicsObject():ApplyTorqueCenter(VectorRand() * 9999)

            undo.ReplaceEntity(self, giblet)

            self:Remove()
        end
    end
    
    function ENT:OnRemove()
        self.RotatingSound:ChangeVolume(0,0)
        self.RotatingSound:Stop()
        self.aiSound:Stop()
        
        self:ShootStopSound()
        self.ShootSound:Stop()
        self:DisMan()
    end
end

if CLIENT then
    local SphereEffects = {}
    local LaserEffects = {}

    surface.CreateFont( "nigg", {
        font = "Coolvetica", 
        extended = false,
        size = 24,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })
    
    function ENT:Initialize()
        self:SetRenderBounds(Vector(-32, -32, 0), Vector(32, 32, 72))
    end
    function ENT:Think()
        if self:GetNWFloat("IsCarried") > CurTime() then
            local sphere = {
                pos = self:GetPos() + self:GetForward() * (self:GetRadiuso() - 64), //1024 - search radius
                radius = self:GetRadiuso(),
                angle = self:GetAngles(),
            }

            SphereEffects[self:EntIndex()] = sphere
        else
            SphereEffects[self:EntIndex()] = nil
        end
        LaserEffects[self:EntIndex()] = self:GetNWBool("Active")
    end

    function ENT:OnRemove()
        SphereEffects[self:EntIndex()] = nil
        LaserEffects[self:EntIndex()] = nil
    end

    local colorheat1 = Vector(1, 0, 0)
    local colorheat2 = Vector(1, 0.1, 0)

    local spriteColor1 = Color(160, 60, 0)
    local spriteColor2 = Color(0, 0, 0)
    local tempColor = Color(255,255,255,255)
    local mati = Material("sprites/bakuglow")
    local laserek = Material("sprites/bakulaser")

    local color_red = Color(127, 0, 0)
    local color_green = Color(0, 127, 0)

    local function lerpColor(fract, col1, col2)
        tempColor.r = Lerp(fract, col1.r, col2.r)
        tempColor.g = Lerp(fract, col1.g, col2.g)
        tempColor.b = Lerp(fract, col1.b, col2.b)
        tempColor.a = 255
        return tempColor
    end

    function ENT:Draw()
        self:DrawModel()
    end

    local matArrow = Material( "widgets/arrow.png", "nocull alphatest smooth mips" )

    function ENT:DrawTranslucent()
        
        local angles = self:GetAttachment(5).Ang
        angles:RotateAroundAxis(self:GetAttachment(5).Ang:Up(),0)   
        angles:RotateAroundAxis(self:GetAttachment(5).Ang:Right(),90)
        angles:RotateAroundAxis(self:GetAttachment(5).Ang:Forward(),90)

        local offy = self:GetAttachment(5).Ang:Up() * 0.5
        local offy2 = self:GetAttachment(5).Ang:Right() * -11// bez get samo right
        local offy3 = self:GetAttachment(5).Ang:Forward() * -4  
        
        local ColoroTable = {
            [1] = Color(230,230,230),
            [2] = Color(190,190,255),
            [3] = Color(185,220,135),
            [4] = Color(255,160,160)
        }   
        
        local text = tostring(self:GetNWInt("Ammount"))
        local pomni_ejszenie = -10

        if(self:GetNWInt("Ammount") < 0) then
            pomni_ejszenie = -16
            text = "Reloading"
            for i = 1, (math.floor(CurTime() * 2) % 4) do
                text = text .. "."
            end
        end

        local offy = self:GetAttachment(5).Ang:Up() * 0.5
        local offy2 = self:GetAttachment(5).Ang:Right() * pomni_ejszenie// bez get samo right
        local offy3 = self:GetAttachment(5).Ang:Forward() * -4  

        cam.Start3D2D(self:GetAttachment(5).Pos + offy * 2 + offy2 + offy3,angles,0.1)
        draw.SimpleText(text,"nigg",0,0,ColoroTable[self:GetAmmoTypero()])
        cam.End3D2D()
        
        if self:GetNWFloat("IsCarried") > CurTime() then
            local pos = self:GetPos() + self:GetUp() * 40
            local frwd = self:GetForward()
            render.SetMaterial(matArrow)
            render.DrawBeam(pos, pos + frwd * 30, 10, 1, 0)
        end

        render.SetMaterial(mati)
        if self:GetNWBool("Active") then
            local pos = self:GetAttachment(3).Pos
            local toview = EyePos() - pos
            render.DrawSprite(pos + toview * 0.05, 4, 4, color_green)
        else
            local pos = self:GetAttachment(4).Pos
            local toview = EyePos() - pos

            render.DrawSprite(pos + toview * 0.05, 4, 4, color_red)
        end

        local pos = self:GetAttachment(5).Pos
        local toview = EyePos() - pos
        
        tempColor.r, tempColor.g, tempColor.b = (self:GetLaserCol() * 255):Unpack()
        tempColor.a = 255
        
        if self:GetNWBool("Active") then
            render.DrawSprite(pos + toview * 0.02, 3, 3, tempColor)
        end
        
        local mul = self:GetNWFloat("LufaHeat", 0)

        if mul < 0.00001 then return end

        local mulx = (1-mul)
        local col = LerpVector(mulx*mulx, colorheat2, colorheat1)

        pos = self:GetAttachment(1).Pos
        toview = (EyePos() - pos)

        render.SetMaterial(mati)
        render.DrawSprite(pos + toview * 0.4, 20, 10, lerpColor(mulx*mulx, spriteColor1, spriteColor2))
    end

    matproxy.Add({
        name = "SENNTRY_GOGO", 
        init = function( self, mat, values )
            self.ResultTo = values.resultvar
        end,
        bind = function( self, mat, ent )
            local mul = ent:GetNWFloat("LufaHeat", 0)

            if mul < 0.00001 then mat:SetVector(self.ResultTo, vector_origin) end

            local mulx = (1-mul)
            mat:SetVector( self.ResultTo, LerpVector(mulx*mulx, colorheat2, colorheat1) * mul * 30 )
        end 
    })

    local colorEffect = Color(255, 10, 10, 70)

    local function buildcylinder(detail)
        local vertices = {}
        local hvertices = {}
        local base = {}

        for i = 1, detail do
            local xyz = ((i - 1) / detail) * math.pi * 2
            local j = math.cos(xyz)
            local k = math.sin(xyz)

            base[i] = Vector(j,k, -1)
        end

        for i = 1, #base do
            local nextind = i % detail + 1
            vertices[(i - 1) * 6 + 1] = {pos = base[nextind]}
            vertices[(i - 1) * 6 + 2] = {pos = base[i]}
            vertices[(i - 1) * 6 + 3] = {pos = base[i] + Vector(0, 0, 2)}
            vertices[(i - 1) * 6 + 4] = {pos = base[i] + Vector(0, 0, 2)}
            vertices[(i - 1) * 6 + 5] = {pos = base[nextind] + Vector(0, 0, 2)}
            vertices[(i - 1) * 6 + 6] = {pos = base[nextind]}

            vertices[#base * 6 + (i - 1) * 3 + 1] = {pos = base[nextind] + Vector(0,0,2)}
            vertices[#base * 6 + (i - 1) * 3 + 2] = {pos = base[i] + Vector(0,0,2)}
            vertices[#base * 6 + (i - 1) * 3 + 3] = {pos = Vector(0,0,1)}

            vertices[#base * 9 + (i - 1) * 3 + 1] = {pos = Vector(0,0,-1)}
            vertices[#base * 9 + (i - 1) * 3 + 2] = {pos = base[i]}
            vertices[#base * 9 + (i - 1) * 3 + 3] = {pos = base[nextind]}

            hvertices[(i - 1) * 6 + 3] = {pos = base[nextind]}
            hvertices[(i - 1) * 6 + 2] = {pos = base[i]}
            hvertices[(i - 1) * 6 + 1] = {pos = base[i] + Vector(0, 0, 2)}
            hvertices[(i - 1) * 6 + 6] = {pos = base[i] + Vector(0, 0, 2)}
            hvertices[(i - 1) * 6 + 5] = {pos = base[nextind] + Vector(0, 0, 2)}
            hvertices[(i - 1) * 6 + 4] = {pos = base[nextind]}

            hvertices[#base * 6 + (i - 1) * 3 + 3] = {pos = base[nextind] + Vector(0,0,2)}
            hvertices[#base * 6 + (i - 1) * 3 + 2] = {pos = base[i] + Vector(0,0,2)}
            hvertices[#base * 6 + (i - 1) * 3 + 1] = {pos = Vector(0,0,1)}

            hvertices[#base * 9 + (i - 1) * 3 + 3] = {pos = Vector(0,0,-1)}
            hvertices[#base * 9 + (i - 1) * 3 + 2] = {pos = base[i]}
            hvertices[#base * 9 + (i - 1) * 3 + 1] = {pos = base[nextind]}
        end

        local msh = Mesh()
        msh:BuildFromTriangles(vertices)
        local hollow = Mesh()
        hollow:BuildFromTriangles(hvertices)

        return msh, hollow
    end
    local cylinderMesh, insideoutMesh = buildcylinder(64)

    local function drawSphereNice(v, color, ref, radius)
        render.SetStencilReferenceValue( ref )
        render.SetStencilCompareFunction( STENCIL_ALWAYS )
        render.OverrideColorWriteEnable(true, false)

        local mat = Matrix()
        mat:Identity()
        mat:Translate(v.pos)
        mat:Scale(Vector(radius, radius, 512))

        cam.PushModelMatrix(mat)
        if radius < 0 then
            insideoutMesh:Draw()
        else
            cylinderMesh:Draw()
        end
        cam.PopModelMatrix()

        render.OverrideColorWriteEnable(false)
    end

    hook.Add("PostDrawTranslucentRenderables", "sentinel_ringer", function(d, sky)
        for k, v in pairs(SphereEffects) do
            cam.IgnoreZ(false)
            render.SetStencilEnable(true)
            render.SetStencilTestMask(255)
            render.SetStencilWriteMask(255)
            render.ClearStencil()
            render.SetColorMaterial()

            render.EnableClipping(true)

            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilZFailOperation( STENCIL_REPLACE )
            drawSphereNice(v, colorZero, 1, -v.radius)

            render.SetStencilZFailOperation( STENCIL_DECR )
            drawSphereNice(v, colorZero, 1, v.radius)

            render.SetStencilZFailOperation( STENCIL_INCR )
            drawSphereNice(v, colorZero, 1, -v.radius + 16)

            render.SetStencilZFailOperation( STENCIL_DECR )
            drawSphereNice(v, colorZero, 1, v.radius - 16)

            render.EnableClipping(false)

            render.SetStencilCompareFunction( STENCIL_EQUAL )
            
            local norm = EyeAngles():Forward()

            cam.IgnoreZ(true)
            render.SetStencilReferenceValue( 1 )

            colorEffect.a = 70 + math.sin(CurTime() * 3.14) * 30
            render.DrawQuadEasy(EyePos() + norm * 10, -norm,10000,10000,colorEffect,0)
            cam.IgnoreZ(false)
            render.SetStencilEnable(false)
        end

        for k, v in pairs(LaserEffects) do
            local senti = Entity(k)

            if(!IsValid(senti) || !v) then continue end

            local pos = senti:GetAttachment(5).Pos

            local tr = util.TraceLine( {
                start = pos,
                endpos = pos + senti:GetAttachment(5).Ang:Forward() * 3000,
                filter = senti
            })
            
            tempColor.r, tempColor.g, tempColor.b = (senti:GetLaserCol() * 255):Unpack()
            tempColor.a = 255
            render.SetMaterial(laserek)
            render.DrawBeam(pos,tr.HitPos, 0.4, 1, 0, tempColor)
        end
    end)
end