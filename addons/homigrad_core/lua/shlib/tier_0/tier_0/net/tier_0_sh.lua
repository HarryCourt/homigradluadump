-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\tier_0\\net\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SafeFromSend
SafeFromSend = function(parent)
    local type = TypeID(parent)

    if type == TYPE_FUNCTION then
        return nil
    elseif type == TYPE_DAMAGEINFO then
        return nil
    elseif type == TYPE_TABLE then
        for k,v in pairs(parent) do
            k = SafeFromSend(k)
            if not k then parent[k] = nil continue end

            parent[k] = SafeFromSend(v)
        end
    end

    return parent
end

function net.SafeFromSend(tbl)
    local new = util.tableCopy(tbl)
    
    SafeFromSend(new)

    return new
end