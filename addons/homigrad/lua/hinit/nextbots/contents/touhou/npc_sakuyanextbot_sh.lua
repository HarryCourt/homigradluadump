-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\npc_sakuyanextbot_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_sakuyanextbot","npc_fumo")
if not ENT then return end

if SERVER then resource.AddWorkshop("2828448531") end

ENT.PrintName = "sakuyanextbot"

ENT.Speed = 900
ENT.Acceleration = 900
ENT.Deceleration = 900

ENT.FastSpeed = 1250
ENT.FastAcceleration = 1250
ENT.FastDeceleration = 1250

ENT.AngrySpeed = 1500
ENT.Acceleration = 1500
ENT.Deceleration = 1500

ENT.ScanTargetDistance = 9999
ENT.MusicDistance = 9999

ENT.JumpSound = Sound("npc_sakuyanextbot/jump.mp3")
ENT.JumpHighSound = Sound("npc_sakuyanextbot/spring.mp3")
ENT.TauntSounds = {
	Sound("npc_sakuyanextbot/pieceofcake.mp3"),
}

ENT.Music = Sound("npc_sakuyanextbot/panic.mp3")
ENT.SpriteMat = Material("npc_sakuyanextbot/sakuyanextbot")