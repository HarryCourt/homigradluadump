-- "addons\\homigrad_core\\lua\\autorun\\shlib.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
print("\tshlib start.")
    include("shlib/loader.lua")
    IncludeDir("shlib/")
print("\tslib end")

if ENABLE_ADMINPANEL then
    print("\thomigrad admin panel start.")
        IncludeDir("hadminpanel/")
    print("\thomigrad admin panel end.")
else
    print("\thomigrad admin panel disabled.")
end
