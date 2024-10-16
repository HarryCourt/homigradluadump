-- "addons\\homigrad\\lua\\hinit\\cl_init_vrmod.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

//ctr + c ctr + v в голове ничего

vrmod.hookSelf("camera",function()
    local displayCalculations = { left = {}, right = {}}
		
    local localply = LocalPlayer()

    for k,v in pairs(displayCalculations) do
        local mtx = (k == "left") and VRMOD_DisplayInfo.ProjectionLeft or VRMOD_DisplayInfo.ProjectionRight
        local xscale = mtx[1][1]
        local xoffset = mtx[1][3]
        local yscale = mtx[2][2]
        local yoffset = mtx[2][3]
        local tan_px = math.abs((1.0 - xoffset) / xscale)
        local tan_nx = math.abs((-1.0 - xoffset) / xscale)
        local tan_py = math.abs((1.0 - yoffset) / yscale)
        local tan_ny = math.abs((-1.0 - yoffset) / yscale)
        local w = tan_px + tan_nx
        local h = tan_py + tan_ny

        v.HorizontalFOV = math.atan(w / 2.0) * 180 / math.pi * 2
        v.AspectRatio = w / h
        v.HorizontalOffset = xoffset
        v.VerticalOffset = yoffset
    end

    local ipd = VRMOD_DisplayInfo.TransformRight[1][4] * 2
    local eyez = VRMOD_DisplayInfo.TransformRight[3][4]

    local rtWidth, rtHeight = VRMOD_DisplayInfo.RecommendedWidth * 2, VRMOD_DisplayInfo.RecommendedHeight

    local hfovLeft = displayCalculations.left.HorizontalFOV
    local hfovRight = displayCalculations.right.HorizontalFOV
    local aspectLeft = displayCalculations.left.AspectRatio
    local aspectRight = displayCalculations.right.AspectRatio

    hook.Add("RenderScene","!VRMOD",function(pos,angle,fov)
        if not VRMODSELFENABLED then return end
    
        VRMOD_SubmitSharedTexture()
        VRMOD_UpdatePosesAndActions()
    
        --handle tracking
        local rawPoses = VRMOD_GetPoses()
        for k,v in pairs(rawPoses) do
            g_VR.tracking[k] = g_VR.tracking[k] or {}
            local worldPose = g_VR.tracking[k]
            worldPose.pos, worldPose.ang = LocalToWorld(v.pos * g_VR.scale, v.ang, g_VR.origin, g_VR.originAngle)
            worldPose.vel = LocalToWorld(v.vel, Angle(0,0,0), Vector(0,0,0), g_VR.originAngle) * g_VR.scale
            worldPose.angvel = LocalToWorld(Vector(v.angvel.pitch, v.angvel.yaw, v.angvel.roll), Angle(0,0,0), Vector(0,0,0), g_VR.originAngle)
            if k == "pose_righthand" then
                worldPose.pos, worldPose.ang = LocalToWorld(g_VR.rightControllerOffsetPos * 0.01 * g_VR.scale, g_VR.rightControllerOffsetAng, worldPose.pos, worldPose.ang)
            elseif k == "pose_lefthand" then
                worldPose.pos, worldPose.ang = LocalToWorld(g_VR.leftControllerOffsetPos * 0.01 * g_VR.scale, g_VR.leftControllerOffsetAng, worldPose.pos, worldPose.ang)
            end
        end
        g_VR.sixPoints = (g_VR.tracking.pose_waist and g_VR.tracking.pose_leftfoot and g_VR.tracking.pose_rightfoot) ~= nil
        hook.Call("VRMod_Tracking")
        
        g_VR.input, g_VR.changedInputs = VRMOD_GetActions()
    
        for k,v in pairs(g_VR.changedInputs) do
            hook.Call("VRMod_Input",nil,k,v)
        end
    
        if not system.HasFocus() or #g_VR.errorText > 0 then
            render.Clear(0,0,0,255,true,true)
            cam.Start2D()
    
            local text = not system.HasFocus() and "Please focus the game window" or g_VR.errorText
            draw.DrawText( text, "DermaLarge", ScrW() / 2, ScrH() / 2, Color( 255,255,255, 255 ), TEXT_ALIGN_CENTER )
            cam.End2D()
    
            return true
        end
        
        local netFrame = VRUtilNetUpdateLocalPly()
    
        if g_VR.currentvmi then
            local pos, ang = LocalToWorld(g_VR.currentvmi.offsetPos,g_VR.currentvmi.offsetAng,g_VR.tracking.pose_righthand.pos,g_VR.tracking.pose_righthand.ang)
            g_VR.viewModelPos = pos
            g_VR.viewModelAng = ang
        end
        
        /*if IsValid(g_VR.viewModel) then
            if not g_VR.usingWorldModels then
                g_VR.viewModel:SetPos(g_VR.viewModelPos)
                g_VR.viewModel:SetAngles(g_VR.viewModelAng)
                g_VR.viewModel:SetupBones()
                --override hand pose in net frame
                if netFrame then
                    local b = g_VR.viewModel:LookupBone("ValveBiped.Bip01_R_Hand")
                    if b then
                        local mtx = g_VR.viewModel:GetBoneMatrix(b)
                        netFrame.righthandPos = mtx:GetTranslation()
                        netFrame.righthandAng = mtx:GetAngles() - Angle(0,0,180)
                    end
                end
            end
            g_VR.viewModelMuzzle = g_VR.viewModel:GetAttachment(1)
        end*/
        
        --set view according to viewentity

        /*local viewEnt = localply:GetViewEntity()

        if viewEnt ~= localply then
            local rawPos, rawAng = WorldToLocal(g_VR.tracking.hmd.pos, g_VR.tracking.hmd.ang, g_VR.origin, g_VR.originAngle)
            
            if viewEnt ~= currentViewEnt then
                local pos,ang = LocalToWorld(rawPos,rawAng,viewEnt:GetPos(),viewEnt:GetAngles())
                pos1, ang1 = WorldToLocal(viewEnt:GetPos(),viewEnt:GetAngles(),pos,ang)
            end

            rawPos, rawAng = LocalToWorld(rawPos, rawAng, pos1, ang1)

            g_VR.view.origin, g_VR.view.angles = LocalToWorld(rawPos,rawAng,viewEnt:GetPos(),viewEnt:GetAngles())
        else
            g_VR.view.origin, g_VR.view.angles = g_VR.tracking.hmd.pos, g_VR.tracking.hmd.ang
        end

        currentViewEnt = viewEnt*/

        RenderView.origin, RenderView.angles = localply:Eye(true)
        
        g_VR.view = RenderView

        RenderSceneCaller = true
        local view = CalcView(localply,RenderView.origin,RenderView.angles)
        RenderSceneCaller = nil

        if not view then return end
    
        RenderView.x = 0
        RenderView.y = 0
        RenderView.w = rtWidth / 2
        RenderView.h = rtHeight

        RenderView.fov = view.fov + 13
        RenderView.origin = view.origin
        RenderView.angles = view.angles
        RenderView.znear = view.znear
        RenderView.drawviewer = view.drawviewer
        RenderView.calc = view
        
        RenderView.origin = RenderView.origin + view.angles:Forward() * -(eyez * g_VR.scale)

        g_VR.eyePosLeft = RenderView.origin + view.angles:Right() * -(ipd * 0.5 * g_VR.scale)
        g_VR.eyePosRight = RenderView.origin + view.angles:Right() * (ipd * 0.5 * g_VR.scale)
    
        render.PushRenderTarget(g_VR.rt)
            RenderView.origin = g_VR.eyePosLeft
            RenderView.x = 0
            RenderView.fov = hfovLeft
            RenderView.aspectratio = aspectLeft
            hook.Call("VRMod_PreRender")
            render.RenderView(RenderView)
    
            RenderView.origin = g_VR.eyePosRight
            RenderView.x = rtWidth / 2
            RenderView.fov = hfovRight
            RenderView.aspectratio = aspectRight
            hook.Call("VRMod_PreRenderRight")
            render.RenderView(RenderView)
        render.PopRenderTarget(g_VR.rt)
     
        hook.Call("VRMod_PostRender")

        RenderPost = true
        hook.Run("Render Post",view)
        RenderPost = nil
    
        return true
    end,-2)
end,
function()
    hook.Remove("RenderScene","!VRMOD")
end)