-- "addons\\homigrad_core\\lua\\shlib\\security\\bypass_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("InitPostEntity","gfher",function()
    render.CapturePixels()
    local r,g,b,a = render.ReadPixel(ScrW() / 2, ScrH() / 2)

    /*if r == nil or g == nil or b == nil or a == nil then
        net.Start("bypass")
        net.SendToServer()
    end*/
end)