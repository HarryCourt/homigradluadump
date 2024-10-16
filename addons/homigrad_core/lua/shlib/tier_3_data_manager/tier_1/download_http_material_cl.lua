-- "addons\\homigrad_core\\lua\\shlib\\tier_3_data_manager\\tier_1\\download_http_material_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local chache = {}

file.CreateDir("homigrad")
file.CreateDir("homigrad/chache")

local removeSpecSumbol = {
    "?",
    "/",
    "\\",
    ":",
    "<",
    ">",
    ",",
    "\"",
    "|"
}

function GetHTTPMaterial(url)
    if not url then return end
    
    local mat = chache[url]

    if not mat then
        if mat == false then return end

        local path = url
        for _,sum in pairs(removeSpecSumbol) do path = string.gsub(path,sum,"") end
        
        mat = file.Read("homigrad/chache/" .. path .. ".png")//нахуя мне кеш подгружать, он на то и кеш долбаёб блядь.
        
        if not mat then
            chache[url] = false

            local tab = queueAdd()
            tab.async = true
            tab:SetThread("download")

            tab.name = url
            tab.url = url
            tab.method = "GET"
            tab.failed = function(err)
                ErrorNoHalt("download_http: err " .. tostring(err) .. "\n" .. tostring(url))

                tab:Remove()
            end

            tab.success = function(code,body)
                tab:Remove()

                if code ~= 200 then
                    ErrorNoHalt("download_http: backend err " .. url)

                    return
                end

                file.Write("homigrad/chache/" .. path .. ".png",body)
                chache[url] = Material("data/homigrad/chache/" .. path .. ".png")
            end

            tab.Request = function()
                tab.request = true

                HTTP(tab)
            end

            tab:Send()

            return
        else
            mat = Material("data/homigrad/chache/" .. path .. ".png","smooth")

            chache[url] = mat
        end
    end


    return mat
end

function SetHTTPMaterial(url,data)
    local path = url
    for _,sum in pairs(removeSpecSumbol) do path = string.gsub(path,sum,"") end

    file.Write("homigrad/chache/" .. path .. ".png",data)
    chache[url] = Material("data/homigrad/chache/" .. path .. ".png")
end

function DrawHTTPMaterial(x,y,w,h,url)
    local mat = GetHTTPMaterial(url)
    
    if not mat then
        DrawLoading(x,y,w,h)
    else
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(x,y,w,h)
    end
end

local mat_loading = Material("homigrad/vgui/loading.png")

function DrawLoading(x,y,w,h)
    local size = math.min(w,h) / 2

    surface.SetMaterial(mat_loading)
    surface.SetDrawColor(255,255,255,255)
    surface.DrawTexturedRectRotated(x + w / 2,y + h / 2,size,size,-(RealTime() * 360) % 360)
end

threadList.download = threadList.download or {}

local old = 0

hook.Add("PostRenderVGUI","Download HTTP",function()
    local queue = threadList.download[1]
    if not queue then return end

    draw.SimpleText(queue.name,"DefaultFixedDropShadow",0,0)
    
    if #threadList.download > 1 then
        old = math.max(old,#threadList.download)

        surface.SetDrawColor(0,0,0)
        surface.DrawRect(0,0,ScrW(),1)

        surface.SetDrawColor(0,255,0)
        surface.DrawRect(0,0,ScrW() * (1 - #threadList.download / old),1)

        draw.SimpleText((old - #threadList.download) .. "/" .. old,"DefaultFixedDropShadow",ScrW(),0,nil,TEXT_ALIGN_RIGHT)
    else
        old = 0
    end
end)

concommand.Add("download_clearchache",function()
    local files = file.Find("homigrad/chache/*","DATA")

    local count = 0

    for _,f in pairs(files) do
        file.Delete("homigrad/chache/" .. f)

        count = count + 1
    end

    chache = {}

    print("remove " .. count .. " files.")

    for k in pairs(threadList.download) do threadList.download[k] = nil end
end)