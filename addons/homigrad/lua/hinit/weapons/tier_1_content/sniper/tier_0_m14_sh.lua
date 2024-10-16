-- "addons\\homigrad\\lua\\hinit\\weapons\\tier_1_content\\sniper\\tier_0_m14_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SWEP = oop.Reg("wep_m14","wep_ak47")
if not SWEP then return end

SWEP.PrintName 				= "M14"
SWEP.Category 				= "Оружие: Снайперки"

--

SWEP.MoveMul = 0.8

SWEP.Primary.ClipSize		= 18
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "rifle"
SWEP.Primary.AmmoDWR        = "ar2"

SWEP.Primary.Cone = 0
SWEP.Primary.Spread = 0.035
SWEP.Primary.Damage = 50
SWEP.Primary.Force = 140
SWEP.Primary.Wait = 1 / 6

SWEP.Primary.Sound = {"pwb/weapons/tar21/shoot.wav"}
SWEP.Primary.SoundFar = "arccw_go/sg556/sg556_distant.wav"

SWEP.HoldType = "ar2"

SWEP.WorldModel				= "models/weapons/arccw_go/v_rif_sg556.mdl"

SWEP.vbwPos = Vector(-10,2,5)
SWEP.vbwAng = Angle(0,0,0)

SWEP.dwsItemPos = Vector(-22,5,5)
SWEP.dwsItemFOV = 1

SWEP.wmVector = Vector(-12,6.4,-4.8)
SWEP.wmAngle = Angle(-1,10,180)

SWEP.MuzzlePos = Vector(0,0.04,0)
SWEP.CameraPos = Vector(-25,0,2.3)

SWEP.Reload1 = "arccw_go/sg556/sg556_clipout.wav"
SWEP.Reload2 = "arccw_go/sg556/sg556_clipin.wav"
SWEP.Reload3 = "arccw_go/sg556/sg556_boltback.wav"
SWEP.Reload4 = "arccw_go/sg556/sg556_boltforward.wav"

SWEP.BoltBone = "v_weapon.sg556_Chamber"
SWEP.BoltMul = 2

SWEP.ClipBone = "v_weapon.sg556_Clip"

SWEP.FakeVec1 = Vector(7,-12,-11)
SWEP.FakeVec2 = Vector(8,-3,0)

SWEP.DeploySound = "arccw_go/sg556/sg556_draw.wav"
SWEP.DeployTime = 1

SWEP.ZoomInSound = "arccw_go/sg556/sg556_zoom_in.wav"
SWEP.ZoomOutSound = "arccw_go/sg556/sg556_zoom_out.wav"

SWEP.CR_Scope = 0.5
SWEP.CLR_Scope = 0.05

SWEP.MuzzlePos = Vector(0,1.65,0)

SWEP.eyeSprayH = 14
SWEP.eyeSprayW = 0.25
SWEP.eyeSpraySinW = 0.2

SWEP.eyeSprayLSet = 0.9
SWEP.eyeSprayLReset = 0.75
SWEP.eyeSpraySinAddW = -1

--

SWEP.HSM = "models/weapons/arccw_go/atts/awp.mdl"
SWEP.HSMScale = Vector(1,1,1)

SWEP.HSP = "models/weapons/arccw_go/atts/awp_hsp.mdl"
SWEP.HSPScale = Vector(1,1,1)

SWEP.HSMat = Material("hud/scopes/ssr_go.png","mips smooth")

SWEP.HSSize = 20
SWEP.HSBone = "holosight"
SWEP.HSMagnification = 2

SWEP.HSVec = Vector(-21,-1.655,1)
SWEP.HSAng = Angle()

SWEP.HSCameraVec = Vector(11,0,1.58597)
SWEP.HSCameraForward = -8.5
SWEP.HSZoom = 2

SWEP.HSDiffMul = 5

local color = Color(255,255,255,255)
local size = Vector(0.1,0.1,0.1)
local mat = Material("color")

local function remove(self,scope) scope:Remove() end

local black = Material("arccw/hud/black.png")

function SWEP:DrawSetupSkinPost(gun)
    gun:SetBodygroup(5,1)
    gun:SetBodygroup(6,1)
end

function SWEP:DrawAttancments(gun)
    if RenderScope then return end
    local hsm,create = self.HSM

    if hsm then
        hsm,create = GetClientSideModelID(self.HSM,tostring(self) .. "hsm")
        self.hsm = hsm

        if create then
            local Mat = Matrix()
            Mat:Scale(self.HSMScale)
            hsm:EnableMatrix("RenderMultiply",Mat)
        end
    end

    local hsp,create = self.HSP,nil

    if hsp then
        hsp,create = GetClientSideModelID(self.HSP,tostring(self) .. "hsp")
        hsp:SetNoDraw(true)
        self.hsp = hsp

        if create then
            local Mat = Matrix()
            Mat:Scale(self.HSPScale)
            hsp:EnableMatrix("RenderMultiply",Mat)
        end
    end

    if CLIENT then gun:SetupBones() end

    local pos,ang = self:GetMuzzlePos(gun)

    ang:Rotate(self.HSAng)
    pos:Add(self.HSVec:Clone():Rotate(ang))

    if IsValid(hsm) then
        hsm:SetRenderOrigin(pos)
        hsm:SetRenderAngles(ang)
        hsm:DrawModel()
    end

    if IsValid(hsp) then
        hsp:SetRenderOrigin(pos)
        hsp:SetRenderAngles(ang)
    end
end

function SWEP:DrawHolosight()
    local hsm,hsp = self.hsm,self.hsp
    if not IsValid(hsm) then return end

    render.UpdateScreenEffectTexture()
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    render.SetStencilWriteMask(255)
    render.SetStencilTestMask(255)

    render.SetBlend(0)
    render.SetStencilReferenceValue(32)
    render.OverrideDepthEnable(true,true)
        render.SetStencilReferenceValue(32)
        
        if IsValid(hsp) then
            hsp:DrawModel()
        else
            self:DrawWorldModel()
            
            hsm:DrawModel()
        end
    render.OverrideDepthEnable(false,true)
    render.SetBlend(1)

    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

    render.SetStencilReferenceValue(32)

    cam.Start2D()
    self:DrawHS()
    cam.End2D()

    render.SetStencilEnable(false)

    //if IsValid(hsm) then hsm:DrawModel() end
end

function SWEP:DrawWorldModelPost(gun)
    self:DrawAttancments(gun)
end

local defaultdot = Material("arccw/hud/hit_dot.png")

SWEP.ScopeImersiveView = 0.95

function SWEP:ChangeCalcView(ply,view)
    view.imersiveSetL = view.imersiveSetL / (1 - self.ScopeImersiveView * ScopeLerp)
end

function SWEP:DrawRT()
    render.DrawTextureToScreenRect(GetRenderTarget("hrt" .. scrw .. scrh,scrw,scrh),0,0,scrw,scrh)
end

function SWEP:DrawHS()
    self:DrawRT()

    render.SetStencilPassOperation(STENCIL_DECR)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

    local pos = self.hsm:GetPos():Add(self.HSCameraVec:Clone():Rotate(self.hsm:GetAngles())):ToScreen()

    local dx,dy = scrw / 2 - pos.x,scrh / 2 - pos.y
    dx = dx * 5
    dy = dy * 5

    local hss = math.min(scrw,scrh) / 2

    local pos = self:GetCameraTransform()

    hss = hss * (BodyCamMode and 0.40 or 1)

    surface.SetMaterial(self.HSMat or defaultdot)
    surface.SetDrawColor(255,255,255)

    local x,y = scrw / 2 + dx,scrh / 2 + dy

    surface.DrawTexturedRectRotated(x,y,hss,hss,0)

    surface.SetDrawColor(0,0,0)
    surface.DrawRect(0,0,scrw,scrh)
end

function SWEP:GetCameraTransform()
    local hsm = self.hsm
    hsm = IsValid(hsm) and hsm or self.hsp
    local pos,ang = hsm:GetPos(),hsm:GetAngles()

    local vec = self.HSCameraVec
    pos:Add(Vector(self.HSCameraForward,vec[2],vec[3]):Rotate(ang))

    return pos,ang
end

SWEP.ScopeLerp = 0.2
SWEP.ScopeLerpOut = 0.1

function SWEP:IsScopePre() return true end--self:GetOwner():KeyDown(IN_DUCK) end

SWEP.ScopeMulW = 1
SWEP.ScopeMulH = 0.5
SWEP.ScopeDiffDiv = 1

function SWEP:SetDisFog(dis)
    --if self:IsScope() then return dis * (1 + ScopeLerp) end
end

hook.Add("Set Dis Fog","Swep",function(dis)
    local wep = LocalPlayer():GetActiveWeapon()

    if wep.SetDisFog then return wep:SetDisFog(dis) end
end)

local color = Color(0,0,0)

local abs = math.abs
local clamp = math.Clamp
local Rand = math.Rand
local Round = math.Round
local min,max = math.min,math.max

RenderScope = nil

SWEP.ScopeSetToMuzzlePos = true

function SWEP:DoRT(renderView)
    renderView = renderView or RenderView
    renderView = util.tableCopy(renderView)

    local rtMat = GetRenderTarget("hrt" .. scrw .. scrh,scrw,scrh)
    local pos,ang = self:GetMuzzlePos()

    if self.ScopeSetToMuzzlePos then renderView.origin = pos end
  
    renderView.fov = Lerp(ScopeLerp,renderView.fov,renderView.fov / self.HSZoom)

    RenderScope = true
    render.PushRenderTarget(rtMat)
        render.Clear(0,0,0,255,true,true)
        render.RenderView(renderView)
    render.PopRenderTarget()
    RenderScope = nil
end

SWEP.ScopeSensitivity = 0.75
function SWEP:AdjustMouseSensitivity() return self:IsScope() and self.ScopeSensitivity or 1 end

hook.Add("Render Pre","Weapons",function(renderView)
    if GetViewEntity() ~= LocalPlayer() then return end

    local wep = LocalPlayer():GetActiveWeapon()
    if not IsValid(wep) or not wep.HSZoom then return end
    
    wep:DoRT()
end)

hook.Add("PreDrawEffects","Weapons",function()
    if RenderScope or GetViewEntity() ~= LocalPlayer() then return end
    
    local wep = LocalPlayer():GetActiveWeapon()
    if not IsValid(wep) or not wep.DrawHolosight then return end

    CamReset()

    render.SetColorModulation(1,1,1)

    wep:DrawHolosight()
    cam.End3D()
end)

function SWEP:ShootEffect(pos,dir)
    local color = Color(255,225,125)

    self:ShootLight(pos,dir,color)
    self:ShootEffect_Manual(pos,dir,color,{
        gasTimeScale = 2.5,
        gasSideScale = 2.75,
        gasForwardScale = 3
    })
end