-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\sh_optimize.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local weapon	= FindMetaTable( "Weapon" )
local entity	= FindMetaTable( "Entity" )

local GetOwner = entity.GetOwner
local GetTable = entity.GetTable

local empty = {}
local val

function weapon:__index( key )
    val = weapon[key]
    if val ~= nil then return val end
    
    val = entity[key]
    if val ~= nil then return val end

    val = (GetTable(self) or empty)[key]
    if val ~= nil then return val end

    return key == "Owner" and GetOwner(self) or nil--позор
end

local player = FindMetaTable("Player")

function player:__index( key )
    val = player[key]
    if val ~= nil then return val end
    
    val = entity[key]
    if val ~= nil then return val end

    val = (GetTable(self) or empty)[key]
    if val ~= nil then return val end

    return nil
end