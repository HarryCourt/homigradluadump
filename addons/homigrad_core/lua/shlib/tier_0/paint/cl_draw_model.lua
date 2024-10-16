-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\paint\\cl_draw_model.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--рубат пидор

ChacheClientsideModels = ChacheClientsideModels or {}
ChacheClientsideModelsByID = ChacheClientsideModelsByID or {}
local list,listID = ChacheClientsideModels,ChacheClientsideModelsByID
local id = 0
local old
local time,time2 = 0,0

local IsValid = IsValid

hook.Add("PreRender","ClientsideModel",function()
    old = id
    id = 0

    time = FrameNumber()
    time2 = RealTime()
end)

local hg_allow_lightonmodels

cvars.CreateOption("hg_allow_lightonmodels","0",function(value) hg_allow_lightonmodels = tonumber(value or 0) > 0 end)

hook.Add("Render Post","ClientsideModels",function()
    if old then
        for i = 1,old - id do
            i = old + i

            local mdl = list[i]
            if IsValid(mdl) then
                list[i] = nil
                
                mdl:SetNoDraw(true)
                mdl:Remove()
            end
        end
    end

    for id,mdl in pairs(listID) do
        if not IsValid(mdl) then
            listID[id] = nil
        elseif (mdl.deleteTime or 0) < time2 then
            listID[id] = nil
            
            mdl:SetNoDraw(true)
            mdl:Remove()
        elseif (mdl.renderTime or 0) < time then
            mdl:SetNoDraw(true)--omagad.........
        else
            mdl:SetNoDraw(not hg_allow_lightonmodels)
        end
    end
end)

function GetClientSideModel(mdlpath)
    id = id + 1

    local mdl = list[id]

    if not IsValid(mdl) then
        mdl = ClientsideModel(mdlpath)
        if not IsValid(mdl) then return end

        mdl:SetModel(mdlpath)

        list[id] = mdl

        return mdl,true
    end

    mdl:SetModel(mdlpath)

    return mdl
end


function GetClientSideModelID(mdlpath,id)
    local mdl = listID[id]

    if not IsValid(mdl) then
        mdl = ClientsideModel(mdlpath)
        if not IsValid(mdl) then return end
        
        mdl.renderTime = time
        mdl.deleteTime = time2 + 0.1

        listID[id] = mdl

        return mdl,true
    end

    mdl.renderTime = time
    mdl.deleteTime = time2 + 0.1
    
    return mdl
end

concommand.Add("hg_drawmodel_chache_clear",function()
    local count = 0

    for id,mdl in pairs(list) do
        list[id] = nil
        if IsValid(mdl) then mdl:Remove() end

        count = count + 1
    end

    for id,mdl in pairs(listID) do
        listID[id] = nil
        if IsValid(mdl) then mdl:Remove() end

        count = count + 1
    end

    print("\tremoved " .. count .. " models")
end)

concommand.Add("hg_drawmodel_chache",function()
    local count = 0

    for id,mdl in pairs(list) do
        print(id)

        count = count + 1
    end

    for id,mdl in pairs(listID) do
        print(id)
        
        count = count + 1
    end

    print(count)
end)

RunConsoleCommand("hg_drawmodel_chache_clear")