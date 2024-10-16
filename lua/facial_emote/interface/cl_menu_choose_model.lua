-- "lua\\facial_emote\\interface\\cl_menu_choose_model.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

function facialEmote.interface.openModelSelector()
	if ( not IsValid( facialEmote.interface.editorPanel ) ) then return end
	local editorPanel = facialEmote.interface.editorPanel
	
	local selectorPanel = vgui.Create( "DPanel", editorPanel )
	local modelPanel = vgui.Create( "DFrame", selectorPanel )
	local newModelEntry = vgui.Create( "DTextEntry", modelPanel )
	local modelPreview 	= vgui.Create( "DModelPanel", modelPanel )
	local modelList 	= vgui.Create( "DImageButton_FacialEmote", modelPanel )
	local acceptModel 	= vgui.Create( "DImageButton_FacialEmote", modelPanel )
	local cancelModel 	= vgui.Create( "DImageButton_FacialEmote", modelPanel )

	selectorPanel:SetPos( 0, 0 )
	selectorPanel:SetSize( ScrW(), ScrH() )
	selectorPanel:SetAlpha( 0 )
	selectorPanel:AlphaTo( 255, 0.4 )
	selectorPanel.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	modelPanel:SetSize( 500, 200 )
	modelPanel:SetTitle( "" )
	modelPanel:Center()
	modelPanel:ShowCloseButton( false ) 
	
	modelPanel.mdlP = true
	modelPanel.extended = false 
	
	modelPanel.modelPreview = modelPreview
	modelPanel.modelEntry = newModelEntry
	
	modelPanel.Paint = function( self, w, h )
		
		surface.SetDrawColor( 100, 100, 100, 255 )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( 45, 50, 55, 255 )
		surface.DrawRect( 2, 53, w-4, h-54 )
		
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawRect( 150, 60, 340, 128 )
		
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawRect( 150, 60, 340, 128 )

		surface.SetDrawColor( 20, 20, 20, 255 )
		surface.DrawRect( 10, 60, 128, 128 )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 160, 110, 64, 64 )

		surface.SetDrawColor( 80, 80, 80, 255 )
		surface.DrawRect( 160, 110, 64, 15 )
		
		draw.GradientBox( -1, 0, w, 50, 0, Color( 220, 220, 220, 150 ), Color( 90, 90, 90, 150 ) )
		
		draw.SimpleText( "SELECT MODEL", "DermaLarge", 10, 10, color_white, 0, 0 )
		draw.SimpleText( "Flex(s)", "Trebuchet18", 192, 108, color_white, 1, 0 )
		draw.SimpleText( modelPreview.Entity:GetFlexNum(), "DermaLarge", 192, 150, color_white, 1, 1 ) 
	end
	
	newModelEntry:SetPos( 155, 70 )
	newModelEntry:SetSize( 330, 25 )
	newModelEntry:SetText( LocalPlayer():GetModel() )
	newModelEntry.OnEnter = function( self )
		modelPreview:SetModel( self:GetValue() )
	end
	
	
	modelPreview:SetPos( 10, 60 )
	modelPreview:SetSize( 128, 128 )
	modelPreview:SetModel( LocalPlayer():GetModel() )
	modelPreview.Think = function( self, ent )
		if ( self:GetAlpha() ~= selectorPanel:GetAlpha() ) then
			self:SetAlpha( selectorPanel:GetAlpha() )
		end
	end
	
	modelList:SetPos( 235, 117 )
	modelList:SetSize( 50, 50 )
	modelList:SetMaxZoom( 3 )
	modelList:SetCircle( true )
	modelList:SetColor( Color( 90, 95, 95 ) )
	modelList:SetMaterial( facialEmote.interface.getMaterial( "icon_search_playermodel" ) )
	modelList.DoClick = function( self )
		facialEmote.interface.openModelList( modelPanel )
		surface.PlaySound( "facial_emote/button_click.wav" )
	end
 
	acceptModel:SetPos( 365, 117 )
	acceptModel:SetSize( 50, 50 )
	acceptModel:SetMaxZoom( 5 )
	acceptModel:SetCircle( true )
	acceptModel:SetColor( Color( 60, 180, 60 ) )
	acceptModel:SetMaterial( facialEmote.interface.getMaterial( "valid" )  )	
	acceptModel.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_click.wav" )
		selectorPanel:AlphaTo( 0, 0.3, nil, function( _, pnl ) pnl:Remove()	end )
		if ( LocalPlayer():GetModel() == newModelEntry:GetValue() ) then return end
		
		facialEmote.network.sendCommand( "setPlayerModel", newModelEntry:GetValue() )
		for i = 0, 64 do
			LocalPlayer():SetFlexWeight( i, 0 )
		end
	end
	
	cancelModel:SetPos( 430, 117 )
	cancelModel:SetSize( 50, 50 )
	cancelModel:SetMaxZoom( 5 )
	cancelModel:SetCircle( true )
	cancelModel:SetColor( Color( 180, 60, 60 ) )
	-- cancelModel:SetIconColor( Color( 255, 100, 100 ) )
	cancelModel:SetIconSize( 20 )
	cancelModel:SetMaterial( facialEmote.interface.getMaterial( "cancel" )  )	
	cancelModel.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_click.wav" )
		surface.PlaySound( "facial_emote/fade_out.wav" )
		selectorPanel:AlphaTo( 0, 0.3, nil, function( _, pnl )
			pnl:Remove()
		end )
	end

end



-- Extend the model selector menu ( 1 - 2 )
facialEmote.interface.openModelList = function( mdlPanel )
	if ( not IsValid( mdlPanel ) ) then return end
	if ( not mdlPanel.mdlP ) then return end
	local w, h = mdlPanel:GetSize()
	if ( not mdlPanel.extended ) then
		mdlPanel.extended = true
		mdlPanel:SizeTo( w, 400, 0.3 )  
	else
		mdlPanel.extended = false
		mdlPanel:SizeTo( w, 200, 0.3 )  
	end
	
	if ( not IsValid( mdlPanel.modelList ) ) then
		mdlPanel.modelList = vgui.Create( "DScrollPanel", mdlPanel )
		mdlPanel.modelList:SetPos( 10, 200 )
		mdlPanel.modelList:SetSize( 480, 190 )
		mdlPanel.modelList.Paint = function( self, w, h )
			surface.SetDrawColor( 20, 20, 20, 255 )
			surface.DrawRect( 0, 0, w, h )
		end
		
		local vBar = mdlPanel.modelList:GetVBar()
		vBar:SetSize( 6, 20 )
		vBar.Paint = function( self, w, h )
			-- surface.SetDrawColor( 0, 0, 0, 120 )
			-- surface.DrawRect( 0, 0, w, h )
		end
		vBar.btnGrip.Paint = function( self, w, h )
			local wVal = 180 + math.sin( CurTime() * 3 ) * 35
			surface.SetDrawColor( wVal, wVal, wVal, 255 )
			surface.DrawRect( 0, 0, w, h )
		end
		vBar:SetHideButtons( true )
		-- dBar:SetHideButtons( false )
		
		
		
		local xPos, yPos = 5, 2
		for k, v in pairs ( player_manager.AllValidModels() ) do
			local SpawnI = vgui.Create( "SpawnIcon", mdlPanel.modelList )
			SpawnI:SetPos( xPos, yPos )
			SpawnI:SetSize( 64, 64 )
			SpawnI:SetModel( v )
			SpawnI.DoClick = function( self )
				mdlPanel.modelPreview:SetModel( v )
				mdlPanel.modelEntry:SetValue( v )
			end
			
			xPos = xPos + 66
			if ( xPos > 440 ) then
				yPos = yPos+66
				xPos = 5
			end
		end
	end
	
end


