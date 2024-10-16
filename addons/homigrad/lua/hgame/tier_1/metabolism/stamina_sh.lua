-- "addons\\homigrad\\lua\\hgame\\tier_1\\metabolism\\stamina_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local max = math.max

event.Add("Move","homigrad",function(ply,mv)
	if not ply:Alive() then return end

	local maxspeed = mv:GetMaxSpeed() * (ply:GetNWFloat("staminamul",1))

	local value = ply.EZarmor
	value = value and value.speedfrac or 1

	maxspeed = maxspeed * max(value,0.75)

	mv:SetMaxSpeed(maxspeed)
	mv:SetMaxClientSpeed(maxspeed)
end)

local min,max = math.min,math.max

event.Add("Move","Smooth",function(ply,mv)
    /*if not ply:Alive() then return end

	local vel = mv:GetVelocity()

	ply.speeed = vel:Length()

    if not ply:OnGround() then return end

    local isRunning = mv:KeyDown(IN_SPEED)
    local isMoving = mv:KeyDown(IN_FORWARD) or mv:KeyDown(IN_BACK) or mv:KeyDown(IN_MOVELEFT) or mv:KeyDown(IN_MOVERIGHT)

	local runSpeed,walkSpeed = ply:GetRunSpeed(),ply:GetWalkSpeed()

	local time = CurTime()

    if isMoving and isRunning then
		if not ply.startRunBoost then ply.startRunBoost = time end

		if ply.startRunBoost then
			local maxspeed = Lerp((1 - max(ply.startRunBoost - time + 0.5,0) / 0.5),walkSpeed,runSpeed)

			mv:SetMaxSpeed(maxspeed)
			mv:SetMaxClientSpeed(maxspeed)
		end
	else
		ply.startRunBoost = nil
	end*/
end,10)

event.Add("FinishMove","Finish",function(ply,mv)

end)

local pulseStart = 0

hook.Add("RenderScreenspaceEffects","Stamina",function()
	local ply = LocalPlayer()
	if not ply:Alive() or ply:GetNWBool("Otrub") then return end

	local pulse = 1 / ply:GetNWFloat("pulse",1 / 80)

	local k = math.max(pulse - 80,0) / 80
	k = k + math.Clamp(-pulse + 60,0,40) / 60

	local time = RealTime()

	if k <= 0 then return end

	if pulseStart + 1 / pulse * 60 < time then
		pulseStart = time 

		LocalPlayer():EmitSound("snd_jack_hmcd_heartpound.wav",75,100,math.min(k,0.25))

		if k > 0.2 then
			LocalPlayer():ViewPunch(Angle(-0.25 * k,0,0))
		end
	end
	
	if hook.Run("Should Draw Screenspace") == false then return end

	//DrawSobel(ply:GetNWFloat("adrenaline") / 4)
end)
