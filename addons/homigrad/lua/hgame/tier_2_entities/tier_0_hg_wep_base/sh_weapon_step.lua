-- "addons\\homigrad\\lua\\hgame\\tier_2_entities\\tier_0_hg_wep_base\\sh_weapon_step.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
StepWeapons = StepWeapons or {}
local StepWeapons = StepWeapons

function Step_Add(ent)
    StepWeapons[#StepWeapons + 1] = ent

    ent:AddEFlags(EFL_NO_THINK_FUNCTION)--этот флаг просто имба
end

local player_GetAll = player.GetAll

local pairs = pairs
local IsValid = IsValid 

hook.Add("Think","ZStep weapons",function()
    if CLIENT and not InitNET then return end

    local i = 0

    while i < #StepWeapons do
        i = i + 1

        local ent = StepWeapons[i]

        if not IsValid(ent) then
            table.remove(StepWeapons,i)

            i = i - 1

            continue
        end

        if CLIENT then
            if ent.DrawOrder then
                ent.DrawOrder = nil
            else
                continue
            end
        end

        ent:StepWithoutOwner()

        local owner = ent:GetOwner()
        if not IsValid(owner) or owner:GetActiveWeapon() ~= ent then continue end
        
        ent:Step(owner)
    end
end,2)