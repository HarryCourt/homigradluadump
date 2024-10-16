-- "addons\\homigrad\\lua\\hgame\\tier_1\\spawnmenu_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then
    local function CanUseSpawnMenu(ply,type,class,tr)
        local func = TableRound().CanUseSpawnMenu

        if func then
            func = func and func(ply,type,class,tr)
            if func ~= nil then return func end
        end

        if ply:IsAdmin() then return true end
    
        return false
    end

    hook.Add("PlayerSpawnVehicle","Cantspawnbullshit",function(ply,model,class) return CanUseSpawnMenu(ply,"vehicle",class) end)
    hook.Add("PlayerSpawnRagdoll","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"ragdoll") end)
    hook.Add("PlayerSpawnEffect","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"effect") end)
    hook.Add("PlayerSpawnProp","Cantspawnbullshit",function(ply,model) return CanUseSpawnMenu(ply,"prop",model) end)
    hook.Add("PlayerSpawnSENT","Cantspawnbullshit",function(ply,class) return CanUseSpawnMenu(ply,"sent",class) end)
    hook.Add("PlayerSpawnNPC","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"npc") end)

    hook.Add("PlayerSpawnSWEP","SpawnBlockSWEP",function(ply,class) return CanUseSpawnMenu(ply,"swep",class) end)
    hook.Add("PlayerGiveSWEP","SpawnBlockSWEP",function(ply,class) return CanUseSpawnMenu(ply,"swep",class) end)

    local function spawn(ply,type,ent)
        local func = TableRound().SpawnObject
        func = func and func(ply,type,ent)

        ent.spawnedply = ply
        --ent.Spawned = true
    end

    hook.Add("PlayerSpawnedVehicle","sv_round",function(ply,ent) spawn(ply,"vehicle",ent) end)
    hook.Add("PlayerSpawnedRagdoll","sv_round",function(ply,model,ent) spawn(ply,"ragdoll",ent) end)
    hook.Add("PlayerSpawnedEffect","sv_round",function(ply,model,ent) spawn(ply,"effect",ent) end)
    hook.Add("PlayerSpawnedProp","sv_round",function(ply,model,ent) spawn(ply,"prop",ent) end)
    hook.Add("PlayerSpawnedSENT","sv_round",function(ply,ent) spawn(ply,"sent",ent) end)
    hook.Add("PlayerSpawnedNPC","sv_round",function(ply,ent) spawn(ply,"npc",ent) end)
    hook.Add("PlayerSpawnedSWEP","sv_round",function(ply,ent) spawn(ply,"swep",ent) end)

    hook.Add("CanTool","sv_round",function(ply,tr,toolname,tool,button)
        return CanUseSpawnMenu(ply,"tool",toolname,tr)
    end)
else
    local function CanUseSpawnMenu()
        local ply = LocalPlayer()
        if ply:IsAdmin() or GetGlobalBool("AccessSpawn") then return true end

        local func = TableRound().CanUseSpawnMenu
        if func then
            func = func and func(LocalPlayer())
            if func ~= nil then return func end
        else
            return false
        end
    end

    hook.Add("SpawnMenuOpen","hide_spawnmenu",CanUseSpawnMenu)

    hook.Add("ContextMenuOpen","hide_spawnmenu",function()
        local func = TableRound().CanUseContextMenu
        func = func and func(LocalPlayer())
        if func ~= nil then return func end 

        return true
    end)
end

hook.Add("OnPhysgunFreeze","ent",function(_,_,ent,ply)
    ent.hold = nil

    if ent.CanPhysgunFreeze then return ent:CanPhysgunFreeze(ply) end
end)

hook.Add("PhysgunPickup","ent",function(ply,ent)
    ent.hold = ply

    if ent.CanPhysgun then return ent:CanPhysgun(ply) end
end)

hook.Add("PhysgunDrop","ent",function(ply,ent)
    ent.hold = nil

    if ent.CanPhysgunDrop then return ent:CanPhysgunDrop(ply) end
end)

properties.Add("ignite",{
	MenuLabel = "#ignite",
	Order = 999,
	MenuIcon = "icon16/fire.png",
	Filter = function(self,ent,ply)
		return ply:IsAdmin() and not ent:IsOnFire() 
	end,
	Action = function(self,ent)
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
	end,
	Receive = function(self,length,ply)
		local ent = net.ReadEntity()

		if !properties.CanBeTargeted(ent,ply) then return end
		if !self:Filter( ent,ply) then return end

		ent:Ignite(360)
	end 
})

hook.Add("InitPostEntity","FUCKESGF",function()
    properties.List.gravity.Filter = function(self,ent,ply) return ply:IsAdmin() end
    properties.List.ignite.Filter = function(self,ent,ply) return ply:IsAdmin() and not ent:IsOnFire() end
    properties.List.drive.Filter = function(self,ent,ply) return ply:IsAdmin() end
    properties.List.remove.Filter = function(self,ent,ply) return ply:IsAdmin() end
    properties.List.statue.Filter = function(self,ent,ply) return ply:IsAdmin() end
end)

for k,v in pairs(properties.List) do
    local old = v.FilterOld
    if v.Filter and not old then old = v.Filter v.FilterOld = old end

    v.Filter = function(self,ent,ply)
        if not ply:IsAdmin() then return false end

        return old and old(self,ent,ply)
    end
end