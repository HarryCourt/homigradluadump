-- "addons\\homigrad\\lua\\hgame\\tier_1\\client\\camera\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local t = {}
local n, e, r, o
local d = Material('materials/scopes/scope_dbm.png')
CameraSetFOV = 120

CreateClientConVar("hg_fov","120",true,false,nil,90,120)
local smooth_cam = CreateClientConVar("hg_smooth_cam","1",true,false,nil,0,1)

function SETFOV(value)
	CameraSetFOV = value or GetConVar("hg_fov"):GetInt()
end

SETFOV()

cvars.AddChangeCallback("hg_fov",function(cmd,_,value)
    timer.Simple(0,function()
		SETFOV()
		print("	hg: change fov")
	end)
end)

RenderView = {
	x = 0,
	y = 0,
	drawhud = false,
	drawviewmodel = true,
	dopostprocess = true,
	drawmonitors = false,
	bloomtone = true
}

local render_Clear = render.Clear
local render_RenderView = render.RenderView

local white = Color(255,255,255)
local HasFocus = system.HasFocus
local oldFocus
local text

local developer = GetConVar("developer")

local vel = 0
local diffang = Angle(0,0,0)
local diffangSet = Angle(0,0,0)
local diffpos = Vector(0,0,0)

local function err(err) ErrorNoHaltWithStack(err) end

local hook_Run = hook.Run

local hg_screen_ratio
cvars.CreateOption("hg_screen_ratio","1",function(value) hg_screen_ratio = tonumber(value) end,0,1)

function GetRenderTargetScreen() return GetRenderTarget("world" .. scrw ..scrh,scrw,scrh) end

RenderPost = nil

hook.Add("RenderScene","Homigrad",function(pos,angle,fov)
	if not InitNET or hg_screen_ratio == 0 then return true end

	local ply = LocalPlayer()
	local pos,angle = ply:Eye(true)

	RenderSceneCaller = true
	local view = CalcView(ply,pos,angle)
	RenderSceneCaller = nil
	if not view then return end

	RenderView.w = scrw * hg_screen_ratio
	RenderView.h = scrh * hg_screen_ratio
	RenderView.x = 0
	RenderView.y = 0
	RenderView.aspectratio = 0

	RenderView.fov = view.fov + 13
	RenderView.origin = view.origin
	RenderView.angles = view.angles
	RenderView.znear = view.znear
	RenderView.zfar = view.zfar
	RenderView.drawviewer = view.drawviewer
	RenderView.calc = view

	hook_Run("Render Pre",RenderView)
	
	if hook_Run("Render Grab",RenderView) == nil then
		render.Clear(0,0,0,0,true,true)
		render_RenderView(RenderView)
		render.RenderHUD(0,0,scrw,scrh)--ez win haha!
	end

	RenderPost = true
	hook_Run("Render Post",RenderView)
	RenderPost = nil

	return true
end)

hook.Add("VRMod_PreRender","Homigrad",function(view)
	if VRMODSELFENABLED then hook_Run("Render Grab",view) end
end)

hook.Add("VRMod_PreRenderRight","Homigrad",function(view)
	if VRMODSELFENABLED then hook_Run("Render Grab",view) end
end)

hook.Add("PreDrawEffects","!Clear Depth",function() render.ClearDepth(true) end)--чо за кринж

function CamReset()--WTF
	cam.Start3D(RenderView.origin,RenderView.angles,RenderView.fov,0,0,scrw,scrh,0.1,16000)
end

local override

hook.Add("CalcView","!VIEW",function(ply,origin,angles)
	RenderRequest = true
	
	return RenderView
end)

hook.Add("CalcVehicleView","!!!VIIEW",function(veh,ply,view)
	if override then return end

	override = true
	local view = hook.Run("CalcVehicleView",veh,ply,view)
	override = false

	return CalcView(ply,view.origin,view.angles,view.fov)
end)

local ply = LocalPlayer()

function RagdollOwner(rag)
	if not IsValid(rag) then return end

	local ent = rag:GetNWEntity("RagdollController")

	return IsValid(ent) and ent
end

local ScopeLerp = 0
local scope
local G = 0
local size = 0.03
local angle = Angle(0)
local possight = Vector(0)

LerpEyeRagdoll = Angle(0,0,0)

local lply = LocalPlayer()
LerpEye = IsValid(lply) and lply:EyeAngles() or Angle(0,0,0)

local vecZero,vecFull = Vector(0.01,0.01,0.01),Vector(1,1,1)
local firstPerson

local max = math.max
local upang = Angle(-90,0,0)
local oldShootTime
local startRecoil = 0
local angRecoil = Angle(0,0,0)
local recoil = 0
local sprinthuy = 0
local oldview = {}

local whitelistSimfphys = {}
whitelistSimfphys.gred_simfphys_brdm2 = true
whitelistSimfphys.gred_simfphys_brdm2_atgm = true
whitelistSimfphys.gred_simfphys_brdm_hq = true

local view = {}

ADDFOV = 0
ADDROLL = 0

local vehicleVel = Vector()
local vehicleVecUp = EyePos()
local vehicleVecSide = EyePos()
local vehicleVecForward = EyePos()

local vehicleClamp = Vector(50,50,50)
local vehicleVelLimit = Vector(3,3,3)

local oldView

event.Add("PreCalcView","EyeMode",function(ply,view)
	if GetViewEntity() ~= ply then return end
	
	if ply:Alive() and ply:EyeMode() then
		view.origin = view.vec
		view.angles = view.ang
		view.drawviewer = false

		view = table.Copy(view)

		DRAWMODEL = nil
		
		return view
	end
end,-3)

CalcView = function(ply,vec,ang,fov,znear,zfar)
	if STOPRENDER then return end

	DRAWMODEL = GetViewEntity() == ply
	
	local head = ply:LookupBone("ValveBiped.Bip01_Head1")
	if head then ply:ManipulateBoneScale(head,DRAWMODEL and vecZero or vecFull) end

	local vec,ang = ply:Eye()

	local view = {
		vec = vec,
		ang = ang,
		fov = CameraSetFOV,

		znear = znear,
		zfar = zfar,

		drawviewer = true
	}

	view.znear = ply._EyeTraceNoWallHit and 1 or view.znear

	local result = event.Run("PreCalcView",ply,view,oldView or view)
	if result ~= nil then
		oldView = table.Copy(result)
		
		view.origin = view.vec
		view.angles = view.ang

		return result
	end

	if not DRAWMODEL then
		return {
			vec = vec,
			ang = ang,
			fov = CameraSetFOV,
	
			znear = znear,
			zfar = zfar,
	
			drawviewer = true
		}
	end

	view.origin = view.vec
	view.angles = view.ang

	oldView = table.Copy(view)

	return view
end

hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
}

hook.Add("HUDShouldDraw","HideHUD",function(name)
	if hide[name] then return false end
end)

local hg_voiceflex

cvars.CreateOption("hg_voiceflex","1",function(value) hg_voiceflex = tonumber(value) > 0 end)

hook.Add("Think","mouthanim",function()
	if not hg_voiceflex then return end

	for i, ply in pairs(player.GetAll()) do
		local fake = ply:GetNWEntity("Ragdoll")
		local ent = IsValid(fake) and fake or ply

		local flexes = {
			ent:GetFlexIDByName("jaw_drop"),
			ent:GetFlexIDByName("left_part"),
			ent:GetFlexIDByName("right_part"),
			ent:GetFlexIDByName("left_mouth_drop"),
			ent:GetFlexIDByName("right_mouth_drop")
		}

		local weight = ply:IsSpeaking() and math.Clamp(ply:VoiceVolume() * 12,0,12) or 0

		for k, v in pairs(flexes) do
			ent:SetFlexWeight(v,weight)
		end
	end
end)

--FindMetaTable("Player").ShouldDrawLocalPlayer = function() return true end
