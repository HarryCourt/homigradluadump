-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\npc_yuyuko_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_yuyuko","npc_fumo")
if not ENT then return end

if SERVER then resource.AddWorkshop("2892187389") end

ENT.PrintName = "npc_yuyuko"

ENT.Speed = 800
ENT.Acceleration = 1000
ENT.Deceleration = 1000

ENT.JumpSound = Sound("npc_yuyuko/jump.mp3")
ENT.JumpHighSound = Sound("npc_yuyuko/spring.mp3")
ENT.TauntSounds = {
	Sound("npc_yuyuko/pieceofcake.mp3"),
	Sound("npc_yuyuko/stepitup.mp3"),
	Sound("npc_yuyuko/tooeasy.mp3"),
	Sound("npc_yuyuko/tooslow.mp3"),
}

ENT.HugSounds = {
	Sound("npc_yuyuko/gotcha.mp3"),
	Sound("npc_yuyuko/hahey.mp3"),
	Sound("npc_yuyuko/timetorelax.mp3"),
	Sound("npc_yuyuko/tooeasy_friendly.mp3"),
	Sound("npc_yuyuko/whatup.mp3"),
}

ENT.VehicleHugSounds = {
	Sound("npc_yuyuko/comeback.mp3"),
	Sound("npc_yuyuko/gonnacrash.mp3"),
	Sound("npc_yuyuko/wait.mp3"),
}

ENT.Music =  Sound("npc_yuyuko/panic.mp3")
ENT.SpriteMat = Material("npc_yuyuko/yuyuko")