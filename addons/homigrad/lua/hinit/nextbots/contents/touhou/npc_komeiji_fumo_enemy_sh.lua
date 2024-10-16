-- "addons\\homigrad\\lua\\hinit\\nextbots\\contents\\touhou\\npc_komeiji_fumo_enemy_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_komeiji_fumo_enemy","npc_fumo")
if not ENT then return end

if SERVER then resource.AddWorkshop("2830488783") end

ENT.PrintName = "komeiji enemy"

ENT.Speed = 800
ENT.Acceleration = 800
ENT.Deceleration = 800

ENT.JumpSound = Sound("npc_komeiji_fumo_friendly/jump.mp3")
ENT.TauntSounds = {
	Sound("npc_komeiji_fumo_friendly/fumo.mp3"),
	Sound("npc_komeiji_fumo_friendly/fumog.mp3"),
	Sound("npc_komeiji_fumo_friendly/fumosus.mp3"),
	Sound("npc_komeiji_fumo_friendly/komeiji.mp3"),
}

ENT.Music = Sound("npc_komeiji_fumo_friendly/hearttanger.mp3")
ENT.SpriteMat = Material("npc_komeiji_fumo_enemy/komeiji_fumo_enemy.png")

ENT.MaxHealth = 6000