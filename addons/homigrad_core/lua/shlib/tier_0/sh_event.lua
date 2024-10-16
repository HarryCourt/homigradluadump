-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\sh_event.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
event = event or {}
local event = event

event.list = event.list or {}
local event_list = event.list

local _event,manual

local pairs = pairs

local empty = {}

function event.Construct(manual)
	local list = {}

	local min,max

	for prio in pairs(manual) do
		if not min then
			min = prio
			max = prio
		else
			if min > prio then min = prio end
			if max < prio then max = prio end
		end
	end

	for prio = min,max do
		for name,func in pairs(manual[prio] or empty) do list[#list + 1] = func end
	end

	return list
end

function event.Add(class,name,func,prio)
	_event = event_list[class]

	prio = prio or 0

	if not _event then
		_event = {manual = {}}
		event_list[class] = _event
	end

	manual = _event.manual

	if not manual[prio] then manual[prio] = {} end

	manual[prio][name] = func

	_event.list = event.Construct(manual)
end

function event.Remove(class,name,prio)
	_event = event_list[class]
	if not _event then return end

	prio = prio or 0

	manual = _event.manual
	if not manual[prio] then return end

	manual[prio][name] = nil

	_event.list = event.Construct(manual)
end

--

local r1,r2,r3

function event.Call(class,...)
	_event = event_list[class]
	if not _event then return end

	local list = _event.list
	local max = #list
	local i = 1
	
	::loop::

	func = list[i]

	r1,r2,r3 = func(...)
	if r1 ~= nil then return r1,r2,r3 end

	i = i + 1

	if i <= max then goto loop end
end

event.Run = event.Call

function event.CallNoReturn(class,...)
	_event = event_list[class]
	if not _event then return end

	local list = _event.list
	local max = #list
	local i = 1
	
	::loop::

	func = list[i]

	func(...)

	i = i + 1

	if i <= max then goto loop end
end