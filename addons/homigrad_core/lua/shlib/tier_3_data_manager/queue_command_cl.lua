-- "addons\\homigrad_core\\lua\\shlib\\tier_3_data_manager\\queue_command_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
concommand.Add("cl_queue_show",function(ply,cmd,args)
    print(DBSTATE)
    
    for name,list in pairs(threadList) do
        print("theard: " .. tostring(name) .. " " .. table.Count(list))

        for id,tab in pairs(list) do
            print(id,tab.request,tab.url or tab.name,tab.async and "->" or ":")
        end
    end
end)

concommand.Add("cl_queue_reset_all",function(ply,cmd,args)
    for name,list in pairs(threadList) do
        print("theard: " .. tostring(name) .. " " .. table.Count(list))

        for id,tab in pairs(list) do
            list[id] = nil
        end
    end
end)

concommand.Add("cl_queue_log",function(ply,cmd,args)
    queueLog = tonumber(args[1] or 0) > 0
end)
