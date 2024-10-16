-- "lua\\facial_emote\\interface\\cl_wheel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
facialEmote.interface.drawWheel = function()
	if ( not facialEmote.face.data[ LocalPlayer():GetModel()] ) then return end
	if ( IsValid( facialEmote.interface.wheel ) ) then
		facialEmote.interface.wheel:Remove()
	end

	facialEmote.interface.wheel = vgui.Create( "Panel" )
	facialEmote.interface.wheel:SetPos( 0, 0 )
	facialEmote.interface.wheel:SetSize( ScrW(), ScrH() ) 
	facialEmote.interface.wheel:MakePopup() 
	facialEmote.interface.wheel:SetKeyboardInputEnabled(false) 
	
	facialEmote.interface.wheel.midW = ScrW()/2
	facialEmote.interface.wheel.midH = ScrH()/2
	facialEmote.interface.wheel.selectedModel = LocalPlayer():GetModel()
	facialEmote.interface.wheel.selectedEmote = nil
	facialEmote.interface.wheel.emotes = {}
	
	local id = 1
	for k, v in pairs ( facialEmote.face.data[LocalPlayer():GetModel()] ) do
		facialEmote.interface.wheel.emotes[id] = { data = v, index = k }
		id = id + 1
	end
	facialEmote.interface.wheel.emotesAmount = table.Count( facialEmote.interface.wheel.emotes ) -- If for ANY reason an index is a string
	
	facialEmote.interface.wheel.Paint = function( self, w, h )		
		local midW, midH 	= ScrW()/2, ScrH()/2
		local circleSize 	= math.min( midW, midH )
		local emoteAmount 	= math.max( self.emotesAmount, 4 )
		local angPerSegment = 360 / emoteAmount
		local mouseAng 		= math.deg( math.atan2( gui.MouseY() - midH, gui.MouseX() - midW ) ) + 180
		local centerdist 	= math.Dist( gui.MouseX(), gui.MouseY(), midW, midH )
		
		self.selectedEmote = nil
		
		Derma_DrawBackgroundBlur( self, 0 )
		surface.SetDrawColor( 0, 0, 0, 200 )
		draw.NoTexture()
		draw.CircleFacialEmote( midW, midH, circleSize, 180 )
		surface.SetDrawColor( 255, 255, 255, 150 )
		draw.CircleFacialEmote( midW, midH, 10, 20 )
		
		local ang = 180
		for i = 1, emoteAmount do
			local xLineNormal, yLineNormal = math.cos( math.rad( ang ) ), math.sin( math.rad( ang ) )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawLine( midW + xLineNormal * (circleSize/5), midH + yLineNormal * (circleSize/5), midW + (xLineNormal*(circleSize*.95)), midH + (yLineNormal*(circleSize*.95)) )
			ang = ang + angPerSegment
		end
		
		local ang = 180
		for _, emote in ipairs ( self.emotes ) do
			
			local finalAng = ang - 180
			local xRectNormal, yRectNormal = math.cos( math.rad( ang + ( angPerSegment / 2 ) ) ), math.sin( math.rad( ang + ( angPerSegment / 2 ) ) )
			local maxSize = angPerSegment*1.4
			local wRectSize, hRectSize = maxSize, maxSize
			
			if ( mouseAng >= finalAng and mouseAng <= ( finalAng + angPerSegment ) and centerdist > circleSize/5 and centerdist < circleSize ) then
				render.ClearStencil()
				render.SetStencilEnable(true)
				render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
				render.SetStencilWriteMask(6)
				render.SetStencilReferenceValue(6)
				render.SetStencilTestMask(6)
				render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
				render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
				render.SetStencilPassOperation(STENCILOPERATION_REPLACE)

				draw.CircleFacialEmote( midW, midH, circleSize/5, 90)
				
				render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
				render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
				render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
				render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
				render.SetStencilReferenceValue(0)
				
				local cir = {}
				local seg = 60
				table.insert( cir, { x = midW, y = midH } )
				for i = 0, seg do
					local a = ( finalAng + ( ( i/seg )* angPerSegment ) ) - 180
					table.insert( cir, { x = midW + math.cos( math.rad( a ) ) * ( circleSize - 10 ), y = midH + math.sin( math.rad( a ) ) * ( circleSize - 10 ) } )
				end
				surface.SetDrawColor( 255, 255, 255, 100 )
				draw.NoTexture()
				surface.DrawPoly( cir )

				render.SetStencilEnable(false)
				render.ClearStencil()
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				local maxSize = angPerSegment*1.65
				wRectSize, hRectSize = maxSize, maxSize
				self.selectedEmote = emote.index
			else
				surface.SetDrawColor( 100, 100, 100, 100 )
			end
			
			if ( facialEmote.interface.emojis[emote.data.image] ) then
				surface.SetMaterial( facialEmote.interface.emojis[emote.data.image] )
			end
			
			surface.DrawTexturedRect( midW + (xRectNormal*(circleSize*.66)) - ( wRectSize/2 ), midH + (yRectNormal*(circleSize*.66)) - ( hRectSize/2 ), wRectSize, hRectSize )
		
			draw.SimpleText( emote.data.name, "Trebuchet24", midW + (xRectNormal*(circleSize*.66)), midH + (yRectNormal*(circleSize*.66)) + hRectSize/2, color_white, 1, 0 )

			ang = ang + angPerSegment
		end
	end
	
	facialEmote.interface.wheel.Think = function( self )
		if ( LocalPlayer():GetModel() ~= self.selectedModel ) then
			self:Remove()
		end
		if ( not input.IsButtonDown( GetConVar( "fe_wheelbind" ):GetInt() ) ) then
			if ( self.selectedEmote ) then
				facialEmote.network.sendCommand( "applyEmotion", self.selectedEmote )
			end
			self:Remove()
		end
	end

end