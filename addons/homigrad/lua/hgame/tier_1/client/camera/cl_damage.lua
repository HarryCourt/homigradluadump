-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\camera\\cl_damage.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local screenShake = 0
local punchAngK = 0
local puncAng = Angle()

local Rand = math.Rand

net.Receive("you get damage",function()
    local dmgTab = net.ReadTable()
    local dmg = dmgTab.dmg

    if dmgTab.isExplosive then
        screenShake = math.min(screenShake + dmg,2)
    end

    punchAngK = punchAngK + 1

    dmg = dmg / 10

    local addAng = dmgTab.pos and (dmgTab.pos - EyePos()):Angle():Div(10):Mul(dmg) or Angle(Rand(-dmg,dmg),Rand(-dmg,dmg))
    addAng:Div(1 + LocalPlayer():GetNWFloat("painlosing") * 40)
    
    hook.Run("Camera Shake Damage",addAng)
    
    puncAng = puncAng:Add(addAng)
end)

event.Add("PreCalcView","Movement",function(ply,view)
    local vec = view.vec
    local ang = view.ang

    punchAngK = LerpFT(0.1,punchAngK,0)
    screenShake = LerpFT(0.1,screenShake,0)

    vec:Add(Vector(Rand(-screenShake,screenShake),Rand(-screenShake,screenShake),Rand(-screenShake,screenShake)))
    ang:Add(puncAng * punchAngK)
    ang[3] = ang[3] + puncAng[2] * punchAngK

    puncAng:LerpFT(0.1)
end)