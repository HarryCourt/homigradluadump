-- "lua\\facial_emote\\hook\\main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal


if ( CLIENT ) then
	hook.Add( "DrawOverlay", "DrawOverlay_FacialEmote", facialEmote.debug.DrawOverlay )

	hook.Add( "HUDPaint", "HUDPaint_FacialEmote", function()
		facialEmote.network.sendCommand( "requestEmoteData" )
		facialEmote.network.sendCommand( "requestInitFlex" )
		facialEmote.network.sendCommand( "requestAllowedUsergroup" )
		hook.Remove( "HUDPaint", "HUDPaint_FacialEmote" )
	end )
	
	hook.Add( "PlayerButtonDown", "PlayerButtonDown_FacialEmote", function(ply, key)
		if ( key == GetConVar( "fe_wheelbind" ):GetInt() ) then
			if ( not IsValid( facialEmote.interface.wheel ) ) then
				facialEmote.interface.drawWheel()
			end
		end
	end)
	
	viewRotateTest = math.rad( 90 )
	local function MyCalcView( ply, pos, angles, fov )
		if ( IsValid( facialEmote.interface.editorPanel ) ) then
			local view = {}
			local headPosition, headAngle 
			if ( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) ) then
				headPosition, headAngle = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) )
			else
				headPosition, headAngle = LocalPlayer():GetPos(), Angle( 0, 0, 0 )
			end
			local otherPlayer
			for k , v in pairs ( player.GetAll() ) do
				if ( v ~= LocalPlayer() ) then
					otherPlayer = v
				end
			end 

			local cSim, cCos = math.sin( viewRotateTest ), math.cos( viewRotateTest )
			
			local frontHead = headPosition + angles:Forward()*(cSim * 15) + angles:Right() * ( cCos * 15 )
			view.origin = frontHead
			view.angles = ( headPosition - ( frontHead ) ):Angle() 
			view.fov = fov
			view.drawviewer = true 

			return view
		end
	end
	hook.Add( "CalcView", "MyCalcView", MyCalcView )
end

if ( SERVER ) then
	hook.Add( "Think", "Think_FacialEmote", function()
		facialEmote.face.calcFlex()
		facialEmote.face.calcResetFlex()
	end)
	
	if ( game.SinglePlayer() ) then
		hook.Add( "PlayerButtonDown", "PlayerButtonDown_FacialEmote", function(ply, key)
			ply:SendLua( 'hook.GetTable().PlayerButtonDown.PlayerButtonDown_FacialEmote( LocalPlayer(), ' .. key .. ' )' )
		end)
	end
end
