-- "addons\\homigrad\\lua\\hgamemode\\src\\roundsystem\\levels\\bodycam\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LevelList.bodycam = false

bodycam = bodycam or {}

function bodycam.CanRandomNext() return math.random(1,3) == 3 end

local models = {}

local bodygroups = {}
bodygroups[0] = 0
bodygroups[1] = 0
bodygroups[2] = 0
bodygroups[3] = 1
bodygroups[4] = 1
bodygroups[5] = 1
bodygroups[6] = 2

table.insert(models,{"models/furious/player/policeint/policeint_male_04.mdl",bodygroups})
table.insert(models,{"models/furious/player/policeint/policeint_male_05.mdl",bodygroups})
table.insert(models,{"models/furious/player/policeint/policeint_male_07.mdl",bodygroups})
table.insert(models,{"models/furious/player/policeint/policeint_male_08.mdl",bodygroups})
table.insert(models,{"models/furious/player/policeint/policeint_male_09.mdl",bodygroups})

bodycam.red = {
	"Alpha",Color(75,75,75),
	weapons = {"weapon_radio","weapon_hands","med_band","med_band","med_kit","med_painkiller"},
    classes = {
        {
            "class_solder",
            main_weapon = {"wep_m4a1","wep_ak47","wep_val"}
        },
        {
            "class_scout",
            main_weapon = {"wep_mp7","wep_mp5","wep_mac10"}
        },
        {
            "class_support",
            main_weapon = {"wep_xm1014","wep_neg"}
        }
    },
    selectLink = true,
	secondary_weapon = {"wep_fiveseven","wep_deagl"},
	models = models,
    armors = {
        {{"ent_jack_gmod_ezarmor_smokebalacvlava",Color(255,255,255)},{"ent_jack_gmod_ezarmor_zryachiibalacvlava",Color(255,255,255)}},
        {"ent_jack_gmod_ezarmor_tc800",Color(195,195,195)},
        {"ent_jack_gmod_ezarmor_mtorso",Color(65,65,65)},
        {"ent_jack_gmod_ezarmor_redutt5_neck",Color(55,55,55)},

        {"ent_jack_gmod_ezarmor_azimutb",Color(175,175,175)},
        {"ent_jack_gmod_ezarmor_xcel",Color(195,195,195)},
        {"ent_jack_gmod_ezarmor_lshz2dtmshield",Color(255,255,255)},
    }
}

bodycam.blue = {
	"Beta",Color(75,75,75),
	weapons = bodycam.red.weapons,
	main_weapon = bodycam.red.main_weapon,
	secondary_weapon = bodycam.red.secondary_weapon,
	models = models,
    armors = bodycam.red.armors,
    classes = bodycam.red.classes,
    selectLink = true
}

bodycam.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function bodycam.StartRound(data)
	game.CleanUpMap(false)

	if CLIENT then
        return
    end

	return bodycam.StartRoundSV()
end

bodycam.GetTeamName = tdm.GetTeamName

function bodycam.BodyCam() return true end

if SERVER then return end

local function DrawScreen(lply,k)
    local name,color = riot.GetTeamName(lply)

    local w,h = ScrW(),ScrH()

	draw.DrawText(L("you",L(lply:GetNWString("ClassName"))),"H.25",w / 2,h / 2 - h / 6,cname,TEXT_ALIGN_CENTER)
 
    draw.DrawText(L("you_team",L(name)),"H.25",w / 2,h / 2,cname,TEXT_ALIGN_CENTER)
    draw.DrawText(L("bodycam"),"H.25",w / 2,h / 8,cblue,TEXT_ALIGN_CENTER)

    draw.DrawText(L("bodycam_loadscreen"), "H.25",w / 2,h / 1.2,cgray,TEXT_ALIGN_CENTER)
end

function bodycam.HUDPaint(white)
    local lply = LocalPlayer()
	local name,color = tdm.GetTeamName(lply)

    if homicide.DrawLoadScreen(DrawScreen,tdm.LoadScreenTime) then return end

	tdm.DrawRoundTime()
end

function bodycam.BodyCam()
    local ply = LocalPlayer()

    if not ply:Alive() then
        if IsSpectate == 1 then return true end
        
        return DeathStartTime - CurTime() + 5 > 0
    end

    return ply:Team() ~= 1002
end

local disTrace = {}
local delay,time = 0,0

local color = Color(0,255,0)

hook.Add("BodyCam HUDPaint","Teams",function()
    if roundActiveName ~= "bodycam" then return end
    
    local i = 0
    local time = CurTime()

    for i,ply in pairs(team.GetPlayers(LocalPlayer():Team())) do
        local y = ScrH() - 48 - i * 20

        surface.SetFont("H.18")

        local name = ply:Name()

        local w,h = surface.GetTextSize(name)
        local mx,my = gui.MouseX(),gui.MouseY()

        if IsValid(ply) and ply ~= LocalPlayer() then
            local dis = disTrace[ply]

            if not dis or delay < time then
                local tr = {
                    start = EyePos(),
                    endpos = ply:EyePos(),
                    filter = LocalPlayer(),
                    mask = MASK_SHOT
                }

                if util.TraceLine(tr).Entity == ply then
                    dis = tr.start:Distance(tr.endpos)
                else
                    dis = nil
                end

                disTrace[ply] = dis
            end
            
            if dis and dis < 4000 then
                local ent = ply:GetEntity()
                
                local pos = ent:LookupBone("ValveBiped.Bip01_Head1")
                
                local add = dis <= 128 and Vector(0,0,8) or Vector(0,0,12)
                
                local posMin = ent:GetPos():Add(ent:OBBMins()):ToScreen()
                local posMax = ent:GetPos():Add(ent:OBBMaxs()):ToScreen()
                
                local x,y = posMin.x,posMin.y

                draw.Frame(x,y,posMax.x - x,posMax.y - y,color,color)

                local pos = pos and ply:GetBonePosition(pos):Add(add) or (ply:GetPos():Add(ply:OBBCenter()))
                pos = pos:ToScreen()

                if dis <= 300 then
                    draw.SimpleText("FRIENDS","ChatFont",pos.x,pos.y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end
        end

        i = i + 1
    end

    if delay < time then delay = time + 0.25 end

    local time = math.Round(roundTimeStart + roundTime - CurTime())
    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = acurcetime

        draw.SimpleText(acurcetime,"H.18",ScrW() / 2,ScrH() - 100,white2,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end)

local white = Color(255,255,255)

local function replace(str)
    return string.rep("0",2 - #tostring(str)) .. str
end

local icon = Material("homigrad/icon.png")

hook.Add("BodyCam HUDPaint","BodyCam",function(view)
    if roundActiveName ~= "bodycam" then return end

    local data = os.date("*t")

    local name = bodycam.GetTeamName(LocalPlayer())
    if not name then return end

    local w,h = ScrW(),ScrH()

    draw.SimpleText(data.year .. "-" .. replace(data.month) .. "-" .. replace(data.day) .. " T" .. replace(data.hour) .. ":" .. replace(data.min) .. ":" .. replace(data.sec) .. "Z","HS.25",w - 300,200,white,TEXT_ALIGN_RIGHT)
    draw.SimpleText("HOMIG." .. string.upper(name) .. ":" .. LocalPlayer():UserID(),"HS.25",w - 300,225,white,TEXT_ALIGN_RIGHT)

    local ply = LocalPlayer()

    surface.SetMaterial(icon)
    surface.SetDrawColor(0,0,0,5)
    surface.DrawTexturedRectRotated(w - 575 + 2,220 + 2,70 * ScreenSize,70 * ScreenSize,0)
    surface.SetDrawColor(255,255,255)
    surface.DrawTexturedRectRotated(w - 575,220,64 * ScreenSize,64 * ScreenSize,0)

    local time = DeathStartTime - CurTime() + 5
    if time <= 0 then RagdollFirstPerson = nil return end
    
    surface.SetDrawColor(0,0,0,255 * (1 - math.min(time,1)))
    surface.DrawRect(0,0,w,h)

    local pos = EyePos():Add(Vector(1,0,0):Rotate(EyeAngles() + (view.calc.angDiff or Angle()) * 5)):ToScreen()

    draw.SimpleText("УБИТ","HS.45",pos.x + math.random(-1,1),pos.y + math.random(-1,1),white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    RagdollFirstPerson = ply:GetNWEntity("RagdollDeath")
end)

local vecZero = Vector(0.01,0.01,0.01)

bodycam.DisableSpectate = function(ply,view)
    if not view or ply:Alive() then return end

    local time = DeathStartTime - CurTime() + 5

    if time < 0 then
        if IsSpectate == 1 then
            local ent = SpecEnt
    
            ent = ent:GetEntity()
            local headBone = ent:LookupBone("ValveBiped.Bip01_Head1")
            local head = headBone and ent:GetBoneMatrix(headBone)
        
            if head then
                local ang = head:GetAngles()
                ang:RotateAroundAxis(ang:Right(),90)
                ang:RotateAroundAxis(ang:Up(),-90)
                ang:RotateAroundAxis(ang:Forward(),90)
                ang:RotateAroundAxis(ang:Forward(),90)

                view.vec = head:GetTranslation():Add(Vector(5,-5,9):Rotate(ang))
                view.ang = ang
            end

            return
        end

        return false
    end
    
    local rag = ply:GetNWEntity("RagdollDeath")
    if not IsValid(rag) then return end

    rag:SetupBones()

    local headBone = rag:LookupBone("ValveBiped.Bip01_Head1")
    local head = headBone and rag:GetBoneMatrix(headBone)

    if head then
        view.vec = head:GetTranslation()
        local ang = head:GetAngles()
        ang:Add(Angle(0,0,0))

        view.vec:Add(Vector(2.5,0,-2):Rotate(ang))
        rag:ManipulateBoneScale(headBone,vecZero)

        view.ang = ang
    else

    end--wtf?
end