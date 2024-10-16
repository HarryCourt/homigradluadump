-- "addons\\homigrad_core\\lua\\shlib\\loader.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

local string_sub = string.sub
local string_split = string.Split
local string_find = string.find

local string_GetFileFromFilename = string.GetFileFromFilename

local validTag = {
	["cl"] = true,
	["sv"] = true,
	["sh"] = true
}

function IncludeFile_External(path,includeClient,includeServer,includeShared,...)--aaaaaaaeeeeeeeeeeeee😎
	local fileName = string_GetFileFromFilename(path)
	if string_sub(fileName,1,1) == "!" then return end

	local split = string_split(fileName,"_")
	local prefix

	prefix = split[1]
	prefix = #prefix == 2 and string_sub(prefix,1,2) or ""
	
	if not validTag[prefix] then
		prefix = split[#split]
		prefix = string_sub(prefix,1,2)

		if not validTag[prefix] then return end--lol4ik
	end

	if prefix == "cl" then
		return includeClient(path,...)
	elseif prefix == "sv" then
		return includeServer(path,...)
	elseif prefix == "sh" then
		return includeShared(path,...)
	end
end

local function includeClient(path)
	if SERVER then
		AddCSLuaFile(path)
	else
		if ONLYADDCSLUAFILE then return end

		return include(path)
	end
end

local function includeServer(path)
	if not SERVER or ONLYADDCSLUAFILE then return end

	return include(path)
end

local function includeShared(path)
	if SERVER then AddCSLuaFile(path) end
	if ONLYADDCSLUAFILE then return end

	return include(path)
end

function IncludeFile(path,...)
	return IncludeFile_External(path,includeClient,includeServer,includeShared,...)
end

local string_gsub = string.gsub

INCLUDE_BREAK = 1

function IncludeTree_External(path,_files,_dirs,includeDir,includeFile,...)
	local files,dirs,tier_files,tier_dirs = {},{},{},{}
	local v,v2,tier

	for i = 1,#_files do
		v = _files[i]

		local tier = nil
		for i,sum in pairs(string_split(v,"_")) do
			if tier then
				sum = string_gsub(sum,".lua","")
				tier = tonumber(sum)

				break
			end

			if sum == "tier" or sum == "t" then tier = true end
		end

		if tier then
			v2 = tier_files[tier]

			if not v2 then
				v2 = {}
				tier_files[tier] = v2
			end

			v2[#v2 + 1] = v

			continue
		end

		files[#files + 1] = v
	end

	for i = 1,#_dirs do
		v = _dirs[i]

		if string_sub(v,1,1) == "!" then continue end

		tier = nil
		for i,sum in pairs(string_split(v,"_")) do
			if tier then tier = tonumber(sum) break end
			if sum == "tier" or sum == "t" then tier = true end
		end

		if tier then
			v2 = tier_dirs[tier]

			if not v2 then
				v2 = {}
				tier_dirs[tier] = v2
			end

			v2[#v2 + 1] = v .. "/"

			continue
		end

		dirs[#dirs + 1] = v .. "/"
	end

	local result
	local empty = {}

	for tier = 0,#tier_files do
		v2 = tier_files[tier] or empty

		for i = 1,#v2 do
			result = includeFile(path .. v2[i],...)
			if result == INCLUDE_BREAK then return end--спалился
		end
	end

	for i = 1,#files do
		result = includeFile(path .. files[i],...)
		if result == INCLUDE_BREAK then return end
	end

	for tier = 0,#tier_dirs do
		v2 = tier_dirs[tier] or empty

		for i = 1,#v2 do
			includeDir(path .. v2[i],...)
		end
	end

	for i = 1,#dirs do
		includeDir(path .. dirs[i],...)
	end
end

function IncludeDir(path)
	local _files,_dirs = file.Find(path .. "*","LUA")

	IncludeTree_External(
		path,
		
		_files,
		_dirs,

		IncludeDir,
		IncludeFile
	)
end--бесплатно!

local string_sub,string_split,string_gsub,string_find = string.sub,string.Split,string.gsub,string.find
local trace

function GetPath(levelUp)
	trace = debug.traceback()

	if levelUp then levelUp = 3 + levelUp end

	trace = string_split(trace,"\n")
	trace = trace[levelUp or #trace]
	trace = string_split(trace,":")[1]
	trace = string_gsub(trace,"	","")

	if string_sub(trace,1,7) == "addons/" then
		trace = string_sub(trace,8,#trace)
		s = string_find(trace,"/")

		return string_sub(trace,s + 5,#trace)
	elseif string_sub(trace,1,4) == "lua/" then
		return string_sub(trace,5,#trace)
	end

	return trace
end

MapName = game.GetMap()

hook.Add("Initialize","SHLib",function()
	Initialize = true

	event.Call("Initialize")
end)

hook.Add("InitPostEntity","SHLib",function()
    InitPostEntity = true
end)