-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\cl_view_backweapons.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PickTable = {}
PickLerp = {}

--[[hook.Add( "HUDWeaponPickedUp", "WeaponPickedUp", function( weapon )
	table.insert( PickTable, weapon:GetPrintName() )
	--PrintTable(PickTable)
	timer.Simple(5,function()
		table.remove(PickTable,1)
		table.remove(PickLerp,1)
	end)
end )

hook.Add( "HUDItemPickedUp", "ItemPickedUp", function( itemName )
	table.insert( PickTable, "#" .. itemName )
	--PrintTable(PickTable)
	timer.Simple(5,function()
		table.remove(PickTable,1)
		table.remove(PickLerp,1)
	end)
end )

hook.Add( "HUDAmmoPickedUp", "AmmoPickedUp", function( ammo, ammout )
	table.insert( PickTable, ammo.." - "..ammout )
	--PrintTable(PickTable)
	timer.Simple(5,function()
		table.remove(PickTable,1)
		table.remove(PickLerp,1)
	end)
end )

function GAMEMODE:HUDDrawPickupHistory()
	for i = 1, table.Count( PickTable ) do
		if PickTable[i] then
			PickLerp[i] = Lerp(5*FrameTime(),PickLerp[i] or 0,(i-1)*20)
			draw.DrawText( "+ "..PickTable[i], "H.25", ScrW()-5, ScrH()/3+PickLerp[i], color_white, TEXT_ALIGN_RIGHT )
		end
	end
end]]--

local clone = Vector(0,0,0)
local vecZero,angZero = Vector(0,0,0),Angle(0,0,0)

local RifleOffset = Vector(-8,-4,-2)
local RifleAng = Angle(0,0,-20)

local PistolOffset = Vector(8,-9,-8)
local PistolAng = Angle(-80,0,0)

local Offset,Ang = Vector(0,0,0),Angle(0,0,0)

local function remove(wep,ent) ent:Remove() end

local LocalPlayer = LocalPlayer
local GetViewEntity = GetViewEntity

local femaleMdl = {}

for i = 1,6 do femaleMdl["models/player/group01/female_0" .. i .. ".mdl"] = true end
for i = 1,6 do femaleMdl["models/player/group03/female_0" .. i .. ".mdl"] = true end

local vecFull = Vector(1,1,1)

DrawPlayerBackWeapons = function(ply,ent)
    if TypeID(ent) == TYPE_NUMBER then
        ent = ply:GetNWEntity("Ragdoll")
        ent = IsValid(ent) and ent or ply
    end

    local list = ply:GetWeapons()
    if #list == 0 then return end

    local activeWep = ply:GetActiveWeapon()
    activeWep = IsValid(activeWep) and activeWep

    local matrix = ent:LookupBone("ValveBiped.Bip01_Spine2")
    if not matrix then return end
    
    matrix = ent:GetBoneMatrix(matrix)
    if not matrix then return end
    
    local spinePos,spineAng = matrix:GetTranslation(),matrix:GetAngles()

    matrix = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Pelvis"))
    local pelvisPos,pelvisAng = matrix:GetTranslation(),matrix:GetAngles()

    local gameVBWHide = ply == ent and roundActive and TableRound().VBWHide

    if gameVBWHide then list = gameVBWHide(ply,list) or list end

    local sUp,sRight,sForward = spineAng:Up(),spineAng:Right(),spineAng:Forward()
    local pUp,pRight,pForward = pelvisAng:Up(),pelvisAng:Right(),pelvisAng:Forward()

    local path = tostring(ent) .. (ent.id or "")
    
    for i,wep in pairs(list) do
        if not wep.vbw then continue end

        local worldMdl = wep.WorldModel
        if not worldMdl then continue end

        local active = activeWep ~= wep
        wep.vbwActive = active
        if not active then continue end

        local localPos,localAng,pistol
        local func = wep.vbwFunc

        if func then
            localPos,localAng,pistol = func(wep,ply,mdl)

            Offset:Set(pelvisPos)
            Ang:Set(pelvisAng)

            clone:Set(localPos):Rotate(Ang)

            Ang:RotateAroundAxis(pUp,localAng[1]):RotateAroundAxis(pRight,localAng[2]):RotateAroundAxis(pForward,localAng[3])
        else
            pistol = wep.vbvPistol or not wep.FakeVec2

            if pistol then
                --[[if isFamale then
                    localPos = wep.vbwPosF or wep.vbwPos or PistolOffsetF
                    localAng = wep.vbwAngF or wep.vbwAng or PistolAngF
                else]]--
                    localPos = wep.vbwPos or PistolOffset
                    localAng = wep.vbwAng or PistolAng
                --end

                Offset:Set(pelvisPos)
                Ang:Set(pelvisAng)

                clone:Set(localPos):Rotate(Ang)

                Ang:RotateAroundAxis(pUp,localAng[1]):RotateAroundAxis(pRight,localAng[2]):RotateAroundAxis(pForward,localAng[3])
            else
                --[[if isFamale then
                    localPos = wep.vbwPosF or wep.vbwPos or RifleOffsetF
                    localAng = wep.vbwAngF or wep.vbwAng or RifleAngF
                else]]--
                    localPos = wep.vbwPos or RifleOffset
                    localAng = wep.vbwAng or RifleAng
                --end

                Offset:Set(spinePos)
                Ang:Set(spineAng)
                
                clone:Set(localPos):Rotate(Ang)

                Ang:RotateAroundAxis(sUp,localAng[1]):RotateAroundAxis(sRight,localAng[2]):RotateAroundAxis(sForward,localAng[3])
            end
        end

        local mdl,isCreate = GetClientSideModelID(worldMdl,path .. worldMdl)
        if not mdl then continue end--why
        
        if isCreate then
            local Mat = Matrix()
            Mat:Scale(wep.vbwModelScale or vecFull)
            mdl:EnableMatrix("RenderMultiply",Mat)
        end--убейте меня

        mdl:SetRenderOrigin(Offset:Add(clone))
        mdl:SetRenderAngles(Ang)
        mdl:SetupBones()
        
        if wep.Render then
            wep:Render(mdl)
        else
            mdl:DrawModel()
        end
    end
end

cvars.CreateOption("hg_draw_backweapons","1",function(value)
    if tonumber(value) > 0 then
        hook.Add("PostPlayerDraw","BackWeapons",DrawPlayerBackWeapons)
    else
        hook.Remove("PostPlayerDraw","BackWeapons")
    end
end)

hook.Add("PostPlayerDraw VGUI","BackWeaponS",DrawPlayerBackWeapons)