-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\npc_koishinextbot_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_koishinextbot","npc_fumo")
if not ENT then return end

if SERVER then resource.AddWorkshop("2828445735") end

ENT.PrintName = "koishinextbot"

ENT.Speed = 800
ENT.Acceleration = 1000
ENT.Deceleration = 1000

ENT.JumpSound = Sound("npc_koishinextbot/jump.mp3")
ENT.JumpHighSound = Sound("npc_koishinextbot/spring.mp3")
ENT.TauntSounds = {
	Sound("npc_koishinextbot/pieceofcake.mp3"),
}

ENT.Music = Sound("npc_koishinextbot/panic.mp3")
ENT.SpriteMat = Material("npc_koishinextbot/koishinextbot")