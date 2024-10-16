-- "addons\\homigrad\\gamemodes\\homigradcom\\gamemode\\shit.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

function GM:PlayerSpawn(ply) end
function GM:PlayerSetModel() end
function GM:PlayerLoadout() end
function GM:IsSpawnpointSuitable() end

function GM:PlayerInitialSpawn(ply) end

function GM:PlayerDeath() end
function GM:PlayerDeathThink() end

function GM:CreateTeams() CreateTeams() end

function GM:PlayerChangedTeam(ply,old,new) end
function GM:PlayerCanJoinTeam(ply,team) return hook.Run("PlayerCanJoinTeam",ply,team) end
function GM:OnPlayerChangedTeam(ply,newproxy) end--OnPlayerChangedTeam(ply,new) end

function GM:PlayerCanSeePlayersChat() end
function GM:PlayerCanHearPlayersVoice() end

function GM:PlayerStartVoice() end
function GM:PlayerEndVoice() end

function GM:ShowTeam(ply) ply:ConCommand("hg_showteam") end

GM.SecondsBetweenTeamSwitches = 1