-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\camera\\cl_vehicel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
event.Add("PreCalcView","Vehicle",function(ply,view)
	if not ply:InVehicle() then return end

    local pod = ply:GetVehicle()
    local vehicle = pod.vehiclebase
    if not IsValid(vehicle) then return end

    local viewoverride = vehicle:GetViewOverride()

    if viewoverride then
        local X = viewoverride.X
        local Y = viewoverride.Y
        local Z = viewoverride.Z

        view.vec:Add(pod:GetForward() * X + pod:GetRight() * Y + pod:GetUp() * Z)
    end

    return view
end,-3)