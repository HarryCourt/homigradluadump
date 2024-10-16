-- "addons\\homigrad_core\\lua\\autorun\\z_shlib.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
print("\thomigrad start.")
    IncludeDir("hgame/")
print("\thomigrad end")

print("\thomigrad gamemode start.")
    IncludeDir("hgamemode/")
print("\thomigrad gamemode end.")

local Run = function()
    if not Initialize then return end

    print("\thomigrad init start.")
        IncludeDir("hinit/")
        IncludeDir("hlocalize/")
    print("\thomigrad init end.")
end

event.Add("Initialize","Homigrad Out",Run)

Run()
