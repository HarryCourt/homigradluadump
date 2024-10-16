-- "addons\\jmod_master\\lua\\jmod\\sh_equippables.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿-- these are custom things that can be "put on" a player, separate from armor
local Slots = {"glowsticks"}

-- slot for glowsticky things
JMod.Equippables = {
	["one_glowstick"] = {
		slot = "glowsticks",
		mdls = {
			{
				mdl = "models/jmod/props/glowstick.mdl",
				mat = "models/jmod/props/jlowstick_on",
				scl = 1,
				bon = "ValveBiped.Bip01_Spine4",
				pos = Vector(-12, -10, -3),
				ang = Angle(-70, 0, 90)
			}
		},
		thinkFunc = function(ply, col, timeLeft)
			if CLIENT then
				local Mult = (timeLeft > 30 and 1) or .5
				local R, G, B = math.Clamp(col.r + 20, 0, 255), math.Clamp(col.g + 20, 0, 255), math.Clamp(col.b + 20, 0, 255)
				local DLight = DynamicLight(ply:EntIndex())

				if DLight then
					DLight.Pos = ply:GetShootPos() + ply:GetAimVector() * 10 - ply:GetUp() * 20
					DLight.r = R
					DLight.g = G
					DLight.b = B
					DLight.Brightness = .8 * Mult ^ 2
					DLight.Size = 180 * Mult ^ 2
					DLight.Decay = 15000
					DLight.DieTime = CurTime() + .3
					DLight.Style = 0
				end
			end
		end
	},
	["rave_glowsticks"] = {
		slot = "glowsticks",
		mdls = {
			{
				mdl = "models/holograms/hq_torus_thin.mdl",
				mat = "models/debug/debugwhite",
				fb = true,
				scl = 1,
				bon = "ValveBiped.Bip01_Spine4",
				col = Color(200, 50, 50),
				pos = Vector(-4, 4, 1),
				ang = Angle(90, 20, 0)
			},
			{
				mdl = "models/holograms/hq_torus_thin.mdl",
				mat = "models/debug/debugwhite",
				fb = true,
				scl = .6,
				bon = "ValveBiped.Bip01_R_Hand",
				col = Color(50, 200, 50),
				pos = Vector(0, 0, 0),
				ang = Angle(60, 0, 0)
			},
			{
				mdl = "models/holograms/hq_torus_thin.mdl",
				mat = "models/debug/debugwhite",
				fb = true,
				scl = .6,
				bon = "ValveBiped.Bip01_L_Hand",
				col = Color(50, 50, 200),
				pos = Vector(0, 0, 0),
				ang = Angle(130, 0, 0)
			}
		},
		thinkFunc = function(ply, col, timeLeft)
			if CLIENT and ply == LocalPlayer() and not ply:ShouldDrawLocalPlayer() then
				local Mult = (timeLeft > 30 and 1) or .5
				local R, G, B = math.Clamp(col.r + 20, 0, 255), math.Clamp(col.g + 20, 0, 255), math.Clamp(col.b + 20, 0, 255)
				local DLight = DynamicLight(ply:EntIndex())

				if DLight then
					DLight.Pos = ply:GetShootPos() + ply:GetAimVector() * 10 - ply:GetUp() * 20
					DLight.r = R
					DLight.g = G
					DLight.b = B
					DLight.Brightness = .8 * Mult ^ 2
					DLight.Size = 220 * Mult ^ 2
					DLight.Decay = 15000
					DLight.DieTime = CurTime() + .3
					DLight.Style = 0
				end
			end
		end,
		drawFunc = function(ply, col, timeLeft)
			local Mult = (timeLeft > 30 and 1) or .5

			local function LightUp(pos, col, index)
				local DLight = DynamicLight(index)

				if DLight then
					DLight.Pos = pos
					DLight.r = col.r
					DLight.g = col.g
					DLight.b = col.b
					DLight.Brightness = 4 * Mult ^ 2
					DLight.Size = 40 * Mult ^ 2
					DLight.Decay = 1500
					DLight.DieTime = CurTime() + .3
					DLight.Style = 0
				end
			end

			local Index = ply:LookupBone("ValveBiped.Bip01_Head1")

			if Index then
				local Pos, Ang = ply:GetBonePosition(Index)

				if Pos then
					LightUp(Pos, Color(200, 50, 50), ply:EntIndex())
				end
			end

			Index = ply:LookupBone("ValveBiped.Bip01_R_Hand")

			if Index then
				local Pos, Ang = ply:GetBonePosition(Index)

				if Pos then
					LightUp(Pos, Color(50, 200, 50), ply:EntIndex() + 1)
				end
			end

			Index = ply:LookupBone("ValveBiped.Bip01_L_Hand")

			if Index then
				local Pos, Ang = ply:GetBonePosition(Index)

				if Pos then
					LightUp(Pos, Color(50, 50, 200), ply:EntIndex() + 2)
				end
			end
		end
	}
}
if CLIENT then
	net.Receive("JMod_EquippableSync", function()
		local ply = net.ReadEntity()

		if IsValid(ply) then
			ply.EZequippables = net.ReadTable()
			ply.EZequippableModels = nil
		end
	end)
elseif SERVER then
	local function SyncEquippables(ply)
		net.Start("JMod_EquippableSync")
		net.WriteEntity(ply)
		net.WriteTable(ply.EZequippables)
		net.Broadcast()
	end

	function JMod.SetEquippable(ply, slot, name, color, endTime)
		ply.EZequippables = ply.EZequippables or {}

		if name then
			ply.EZequippables[slot] = {
				nam = name,
				col = color,
				tim = endTime
			}
		else
			ply.EZequippables[slot] = nil
		end

		ply:EmitSound("snds_jack_gmod/equip" .. math.random(1, 5) .. ".wav", 60, math.random(90, 110))
		SyncEquippables(ply)
	end

	hook.Add("DoPlayerDeath", "JModEquippablesDeath", function(ply)
		ply.EZequippables = {}
		SyncEquippables(ply)
	end)
end
