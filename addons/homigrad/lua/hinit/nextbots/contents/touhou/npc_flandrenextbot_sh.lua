-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\npc_flandrenextbot_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_flandrenextbot","npc_fumo")
if not ENT then return end

if SERVER then resource.AddWorkshop("2828445664") end

ENT.PrintName = "flandrenextbot"

ENT.Speed = 800
ENT.Acceleration = 800
ENT.Deceleration = 800

ENT.JumpSound = Sound("npc_flandrenextbot/jump.mp3")
ENT.JumpHighSound = Sound("npc_flandrenextbot/spring.mp3")
ENT.TauntSounds = {
	Sound("npc_flandrenextbot/pieceofcake.mp3"),
}

ENT.Music = Sound("npc_flandrenextbot/panic.mp3")
ENT.SpriteMat = Material("npc_flandrenextbot/flandrenextbot")