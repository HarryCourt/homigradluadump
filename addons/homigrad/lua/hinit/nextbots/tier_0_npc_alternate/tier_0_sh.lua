-- "addons\\homigrad\\lua\\hinit\\nextbots\\tier_0_npc_alternate\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ENT = oop.Reg("npc_alternate","base_nextbot",true)
if not ENT then return INCLUDE_BREAK end

ENT.SpectateCameraDis = 120

ENT.JumpSound = Sound("npc_alternate/jump.mp3")
ENT.JumpHighSound = Sound("npc_alternate/spring.mp3")
ENT.TauntSounds = {
	Sound("npc_alternate/pieceofcake.mp3"),
	Sound("npc_alternate/stepitup.mp3"),
	Sound("npc_alternate/tooeasy.mp3"),
	Sound("npc_alternate/tooslow.mp3"),
}

ENT.DamageDoor = 10

ENT.SpriteSize = 128
ENT.SpriteMat = Material("npc_alternate/alternate")

ENT.Music = Sound("npc_alternate/panic.mp3")
ENT.MusicDistance = 3000
ENT.MusicLevel = 125
ENT.MusicVolume = 1

ENT.MusicRestartDelay = 2

ENT.MusicHide = true

--

ENT.Speed = 750

ENT.AttackDistance = 80
ENT.AttackForce = 800
ENT.AttackInterval = 0.2
ENT.AttackProps = true

ENT.AllowJump = true

ENT.ScanHiddingInterval = 3
ENT.RepathHiddingInterval = 1

ENT.ScanTargetInterval = 1
ENT.ScanTargetDistance = 2500
ENT.RepathInterval = 0.1

ENT.TauntInterval = 1.2
ENT.PathInfractionTimeout = 5

ENT.PrintName = "Alternate"
ENT.Category = "NextBot"
ENT.Spawnable = false

ENT.PhysgunDisabled = true
ENT.AutomaticFrameAdvance = false

list.Set("NPC","npc_alternate", {
	Name = "alternate",
	Class = "npc_alternate",
	Category = "Nextbots",
	AdminOnly = true
})

function ENT:CanSeeYou(ent,pos)
	local pen = sound.Trace((ent or self):GetPos(),1024,5,{[self] = true},pos)

	if pen <= 0.25 then
		return true
	else
		return false
	end
end

NextBotsClassList = NextBotsClassList or {}

ENT:Event_Add("Construct","NextBot",function(class)
	local class = class[1]

	list.Set("NPC",class.ClassName,{
		Name = class.PrintName,
		Class = class.ClassName,
		Category = class.Category,
		AdminOnly = false
	})

	NextBotsClassList[class.ClassName] = class
end)