-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\cvars_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
cvarsOptions = cvarsOptions or {}

function cvars.CreateOption(name,def,change,min,max)
    local function update(_,_,value)
        if change then change(value) end
    end

    cvarsOptions[name] = cvarsOptions[name] or {}
    cvarsOptions[name]["main"] = change

    cvars.AddChangeCallback(name,update,"option")

    local convar = CreateClientConVar(name,def,true,false,"",tonumber(min),tonumber(max))

    if Initialize then change(convar:GetString()) end

    return convar
end

function cvars.Hook(name,change,id)
    local function update(_,_,value) change(value) end

    cvarsOptions[name] = cvarsOptions[name] or {}
    cvarsOptions[name][id] = change

    cvars.AddChangeCallback(name,update,id)

    if Initialize then change(GetConVar(name):GetString()) end
end

hook.Add("Initialize","CVars Option",function()
    print("setup cvars value")

    for name,list in pairs(cvarsOptions) do
        local convar = GetConVar(name)
        if not convar then print("invalid convar " .. name) continue end
        
        local v = convar:GetString()
    
        for id,update in pairs(list) do update(v,true) end
    end

    print("done") 
end)