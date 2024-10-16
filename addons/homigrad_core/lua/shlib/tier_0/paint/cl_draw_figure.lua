-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\paint\\cl_draw_figure.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local constructManual = {
    "circle",
    "circle_contr",

    "romb",
    "romb_contr",
    
    "star",
    "star_contr",

    "triangle",
    "triangle_contr"
}

local pngParametrs = "mips"
local materials = {}

for i,name in pairs(constructManual) do
	materials[name] = Material("homigrad/vgui/models/" .. name .. ".png",pngParametrs)
end

local SetMaterial = surface.SetMaterial
local DrawTexturedRectRotated = surface.DrawTexturedRectRotated

materials.loading = Material("homigrad/vgui/loading.png",pngParametrs)

function surface.SetFigure(name)
    SetMaterial(materials[name])
end

function draw.Figure(x,y,w,h,r)
    DrawTexturedRectRotated(x,y,w,h,r or 0)
end