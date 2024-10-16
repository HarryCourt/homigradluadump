-- "addons\\homigrad_core\\lua\\shlib\\tier_1\\nwtable_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENTITY = FindMetaTable("Entity")

function ENTITY:SetNWTable(key,tbl)
    local tbl = util.TableToJSON(tbl)

    for i = 1,10 do
        local text = self:GetNWString(key .. i,"")
        if text == "" then break end

        self:SetNWString(key .. i,"")
    end

    for i = 1,math.ceil(#tbl / 199) do
        local text = string.sub(tbl,199 * (i - 1) + 1,199 * i)

        self:SetNWString(key .. i,text)
    end
end

local empty = {}

function ENTITY:GetNWTable(key,limit,value,update)
    local tbl = (self.nwTables or empty)[key]

    if not tbl or value then
        self.nwTables = self.nwTables or {}

        local path = ""

        for i = 1,limit or 10 do
            self:SetNWVarProxy(key .. i,function(_,_,_,value)
                if not IsValid(self) then return end---looool
                
                self:GetNWTable(key,i,value)
            end)

            local text = i == limit and value or self:GetNWString(key .. i,"")
            path = path .. text
        end


        tbl = util.JSONToTable(path)
        self.nwTables[key] = tbl

        if tbl then
            local func = self["OnNWTable_" .. key]
            
            if func then func(self,tbl) end
        end

        if update then update(self,tbl) end
    end

    return tbl
end