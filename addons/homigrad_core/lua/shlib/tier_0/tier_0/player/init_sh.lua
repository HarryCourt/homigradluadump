-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\tier_0\\player\\init_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local CurTime,FrameTime = CurTime,FrameTime
local player_GetAll = player.GetAll
local event_Call = event.Call

local Time,Frame,i,tbl,ply

hook.Add("Think","Z_SHLibPlayer",function()
    if CLIENT and not InitNET then return end--shut the fuck up
    
    Time,Frame = CurTime(),FrameTime()

    i = 0
    tbl = player_GetAll()

    ::loop::

    i = i + 1

    ply = tbl[i]
    if not ply then return end

    if ply.init then event_Call("Player Think",ply,Time,Frame) end

    goto loop
end,1)--dem

event.Add("Player Think","Time",function(ply,time,frame)
    if (ply.delay01 or 0) < time then
        ply.delay01 = time + 0.1

        event_Call("Player Think 0.1",ply,time,frame)
    end

    if (ply.delay025 or 0) < time then
        ply.delay025 = time + 0.25

        event_Call("Player Think 0.25",ply,time,frame)
    end

    if (ply.delay1 or 0) < time then
        ply.delay1 = time + 1

        event_Call("Player Think 1",ply,time,frame)
    end
end)

hook.Add("Move","SHLib",function(ply,mv)
    if not ply.init then return true end

    return event_Call("Move",ply,mv)
end)

hook.Add("SetupMove","SHLib",function(ply,mv,cmd)
    if not ply.init then return true end

    return event_Call("SetupMove",ply,mv,cmd)
end)

hook.Add("FinishMove","SHLib",function(ply,mv)
    if not ply.init then return true end

    return event_Call("FinishMove",ply,mv)
end)

hook.Add("PlayerFootstep","SHLib",function(ply,pos,foot,snd,volume,filter)
    if not ply:Alive() then return true end
    
    return event_Call("Footstep",ply,pos,foot,snd,volume,filter)
end)

hook.Add("OnPlayerHitGround","SHLib",function(...) return event_Call("Landing",...) end)
hook.Add("OnPlayerJump","SHLib",function(ply,speed) return event_Call("Jump",ply,speed) end)

event.Add("Player Spawn","RemoveDecals",function(ply)
	ply:RemoveAllDecals()--нихуя не работает ;c;c;c;;c;c;c
end)

NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4--lmao

local Player = FindMetaTable("Player")
if not HPlayerName then HPlayerName = Player.Name end
function Player:Name() return self:GetNWString("Nick",HPlayerName(self)) end
Player.Nick = Player.Name

local PLAYER = FindMetaTable("Player")
function PLAYER:Alive() return self:GetNWBool("Alive",false) end--stupid

gameevent.Listen("player_connect")
hook.Add("player_connect","!SHLIB",function(data) return event.Call("player_connect",data) end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect","!SHLIB",function(data) return event.Call("player_disconnect",data) end)
