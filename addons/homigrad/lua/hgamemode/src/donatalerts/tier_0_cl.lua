-- "addons\\homigrad\\lua\\hgamemode\\src\\donatalerts\\tier_0_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
donatList = donatList or {}
donatActives = donatActives or {}

function donatAlertsFunReg(amount,name)
    local donat = {
        amount = amount,
        name = name,
        catchActive = true
    }

    donatList[amount] = donat

    return donat
end

function donatOff(amount)
    donatList[amount].off()
    donatActives[amount] = nil
end

net.Receive("donat on",function()
    local donat = donatList[tonumber(net.ReadString())]
    if not donat then return end

    if donat.catchActive then donatActives[donat.amount] = true end

    donat.on(net.ReadTable())
end)

net.Receive("donat off",function()
    local donat = donatList[tonumber(net.ReadString())]
    if not donat then return end

    donatActives[donat.amount] = nil

    donat.off()
end)

hook.Add("Think","donatAlerts",function()
    for amount in pairs(donatActives) do
        local donat = donatList[amount]
        if donat.think then donat.think() end
    end
end)