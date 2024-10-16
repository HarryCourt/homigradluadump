-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\sh_util.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function func_error(err) ErrorNoHaltWithStack(err) end

local result,r1,r2,r3,r4,r5,r6,_error,errorH,tbl
local debug_getinfo = debug.getinfo

function util.pcall(func,...)
	_error = true

	result,r1,r2,r3,r4,r5,r6 = xpcall(func,func_error,...)

	errorH = _error
	_error = nil

	if result then
		if type(errorH) == "string" then
			ErrorNoHaltWithStack(errorH)

			return false,errorH
		end

		return true,r1,r2,r3,r4,r5,r6
	end
end--eeeeeeeeeeee

function util.error(text)
	if _error then
		_error = text
	else
		ErrorNoHaltWithStack(text)
	end
end

function util.FindInClassList(class,list)
	local value = list[class]

	if not value then
		for class2,value2 in pairs(list) do
			local star = string.sub(class2,#class2,#class2) == "*"
			local no = string.sub(class2,1,1) == "!"
			local thisClass = class

			if no then
				class2 = string.sub(class2,2,#class2)
			end

			if star then
				class2 = string.sub(class2,1,#class2 - 1)
				thisClass = string.sub(thisClass,1,#class2)
			end

			if thisClass == class2 then
				if no then return end

				value = value2
			end
		end
	end

	return value
end

function util.EyeCanSee(eye,dir,posLookup,k)
	local diff = posLookup - eye
    diff = dir:Dot(diff) / diff:Length()

    return diff >= (k or 0.4)
end

local CMoveData = FindMetaTable("CMoveData")

function CMoveData:RemoveKey(key)
	local newbuttons = bit.band(self:GetButtons(),bit.bnot(key))
	self:SetButtons(newbuttons)
end