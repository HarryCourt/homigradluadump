-- "addons\\homigrad\\lua\\hgame\\tier_0\\sh_bones.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function Spawn(ply)
    ply.rclavicle = Angle()
    ply.rupperarm = Angle()
    ply.rforearm = Angle()
    ply.rhand = Angle()

    ply.spine = Angle()
    ply.head = Angle()

    ply.rfinger1 = {Angle(),Angle()}
    ply.rfinger2 = {Angle(),Angle(),Angle()}
    ply.rfinger3 = {Angle(),Angle(),Angle()}
    ply.rfinger4 = {Angle(),Angle(),Angle()}
end

event.Add("Player Spawn","Bones",Spawn)

local Player = FindMetaTable("Player")

local lookup = {
    rupperarm = "ValveBiped.Bip01_R_Upperarm",
    rforearm = "ValveBiped.Bip01_R_Forearm",
    rhand = "ValveBiped.Bip01_R_Hand",

    spine = "ValveBiped.Bip01_Spine",
    head = "ValveBiped.Bip01_Head1"
}

function Player:SetBoneAng(bone,ang)
    self:ManipulateBoneAngles(self:LookupBone(lookup[bone]),ang,false)
end

function Player:GetBoneAng(bone)
    return self:GetManipulateBoneAngles(self:LookupBone(lookup[bone]))
end

function Player:AddBoneAng(name,ang)--используй переменые лутче,хотя х3
    local bone = self:LookupBone(lookup[name])

    self:ManipulateBoneAngles(bone,self:GetManipulateBoneAngles(bone):Add(ang),false)
end

local FrameNumber = FrameNumber

local rclavicle,rupperarm,rforearm,rhand
local spine,head

local list = {}

local ENTITY = FindMetaTable("Entity")

local ManipulateBoneAngles = ENTITY.ManipulateBoneAngles // незнаю насколько это правда....
local LookupBone = ENTITY.LookupBone // это прям если максимально доебатся...
local SetupBones = ENTITY.SetupBones

local angZero = Angle()

local function think(ply)
    if (CLIENT and list[ply] == FrameNumber()) or not ply:Alive() or vrmod.IsPlayerInVR(ply)  then return end

    if not ply.ManipulateBoneAngles then return end
    
    local bone = LookupBone(ply,"ValveBiped.Bip01_R_Clavicle")//ебать кстати это реально мб прирост даёт...

    rclavicle = ply.rclavicle

    if not rclavicle then Spawn(ply) return end
    
    if bone then
        rupperarm = ply.rupperarm
        rforearm = ply.rforearm
        rhand = ply.rhand
        spine = ply.spine
        head = ply.head

        ManipulateBoneAngles(ply,bone,rclavicle,false)
        ManipulateBoneAngles(ply,LookupBone(ply,"ValveBiped.Bip01_R_Upperarm"),rupperarm,false)
        ManipulateBoneAngles(ply,LookupBone(ply,"ValveBiped.Bip01_R_Forearm"),rforearm,false)
        ManipulateBoneAngles(ply,LookupBone(ply,"ValveBiped.Bip01_R_Hand"),rhand,false)

        ManipulateBoneAngles(ply,LookupBone(ply,"ValveBiped.Bip01_Spine"),spine,false)
        ManipulateBoneAngles(ply,LookupBone(ply,"ValveBiped.Bip01_Head1"),head,false)

        rclavicle:Set(angZero)
        rupperarm:Set(angZero)
        rforearm:Set(angZero)
        rhand:Set(angZero)

        spine:Set(angZero)
        head:Set(angZero)
    end

    event.Call("Setup Bones",ply)
    
    if CLIENT then
        SetupBones(ply)

        list[ply] = FrameNumber()//по максимуму не обращаемся к игроку
    end
end//хоть попробуй вякнуть о костях, ща ими вертеть на хуе буду как захочу

if SERVER then
    event.Add("Player Think","Bones",function(ply)
        think(ply)
    end,-10)
else
    event.Add("PreCalcView","Bones",function()
        if not InitNET then return end

        for i,ply in pairs(player.GetAll()) do
            think(ply)
        end
    end,-10)
end

