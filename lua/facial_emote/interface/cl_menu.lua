-- "lua\\facial_emote\\interface\\cl_menu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
facialEmote.interface.openMenu = function()
	facialEmote.network.sendCommand( "requestAllowedUsergroup" )
	
	if ( facialEmote.interface.menu ) then
		facialEmote.interface.menu:Remove()
	end
	
	facialEmote.interface.menu = vgui.Create( "DFrame" )
	local menuPanel 		= facialEmote.interface.menu
	menuPanel.panel 		= vgui.Create( "Panel", menuPanel )
	menuPanel.editorBtn 	= vgui.Create( "DButton_FacialEmote", menuPanel.panel )
	menuPanel.parametersBtn = vgui.Create( "DButton_FacialEmote", menuPanel.panel )
	menuPanel.support 		= vgui.Create( "DButton_FacialEmote", menuPanel.panel )
	menuPanel.exit 			= vgui.Create( "DButton_FacialEmote", menuPanel.panel )
	
	local panel 		= menuPanel.panel
	local editorBtn 	= menuPanel.editorBtn
	local parametersBtn = menuPanel.parametersBtn
	local supportBtn 	= menuPanel.support
	local exitBtn 		= menuPanel.exit

	menuPanel:SetPos( 0, 0 )
	menuPanel:SetSize( 500, 335 )
	menuPanel:SetAlpha( 1 )
	menuPanel:AlphaTo( 255, 0.3 )
	menuPanel:ShowCloseButton( false )
	menuPanel:SetSizable( true )
	menuPanel:Center() 
	menuPanel:MakePopup()
	menuPanel.Paint = function( self, w, h )
		DisableClipping( true )
		local maxOut = 10
		for i = 1, maxOut do
			surface.SetDrawColor( Color( 0, 0, 0, 200 - ( i/maxOut ) * 200 ) )
			surface.DrawOutlinedRect( -i, -i, w + i*2, h + i*2 )
		end
		DisableClipping( false ) 
	
		surface.SetDrawColor( 80, 80, 95 )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( 40, 40, 80 )
		surface.DrawRect( 0, 0, w, 50 )
		draw.SimpleText( "FACIAL EMOTE MENU", "Coolvetica40", w/2, 25, Color( 255, 255, 255 ), 1, 1 )
	end
	
	menuPanel.PerformLayout = function( self, w, h )
		local pW, pH = w - 10,  h - 60
		self.panel:SetPos( 5, 55 )
		self.panel:SetSize( pW, pH )
		
		local btns = { editorBtn, parametersBtn, supportBtn, exitBtn }
		local yPos = 10
		
		for _, p in ipairs ( btns ) do
			p:SetPos( 10, yPos )
			p:SetSize( pW-20, 60 )
			yPos = yPos + 65
		end
	end
	menuPanel.lblTitle:Remove()
	
	editorBtn:SetFont( "DermaLarge" )
	editorBtn:SetIcon( facialEmote.interface.getMaterial( "load" ) )
	
	parametersBtn:SetFont( "DermaLarge" )
	parametersBtn:SetIcon( facialEmote.interface.getMaterial( "parameter" ) )
	
	supportBtn:SetFont( "DermaLarge" )
	supportBtn:SetIcon( facialEmote.interface.getMaterial( "information" ) )
	
	exitBtn:SetFont( "DermaLarge" )
	exitBtn:SetIcon( facialEmote.interface.getMaterial( "out" ) )	
	
	panel:SetPos( 5, 30 )
	panel:SetSize( 500, 500 )
	panel.Paint = function( self, w, h )
		surface.SetDrawColor( 35, 35, 40 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	editorBtn:SetText( "Open emote editor" )
	local isAllowed = facialEmote.parameters.client.authorizedGroups[LocalPlayer():GetUserGroup()]
	if ( isAllowed ) then
		editorBtn.DoClick = function( self )
			facialEmote.interface.openEditor()
			menuPanel:Remove()
			surface.PlaySound( "facial_emote/button_click.wav" )
		end
	else
		editorBtn:SetColor( Color( 50, 50, 50 ) )
		editorBtn:SetIconColor( Color( 90, 90, 90 ) )
		editorBtn:SetTextColor( Color( 90, 90, 90 ) )
		editorBtn:SetBorderSize( 0 )
		editorBtn:SetFont( "Coolvetica18" )
		editorBtn:EnableZoom( false )
		editorBtn.DoClick = function( self )
			local groups = ""
			for key in pairs ( facialEmote.parameters.client.authorizedGroups ) do
				groups = groups .. key .. ", "
			end
			groups =  string.sub( groups, 0, #groups-2 )
			
			chat.AddText( Color( 255, 255, 255 ), "Your usergroup is : " .. LocalPlayer():GetUserGroup() )
			chat.AddText( Color( 255, 255, 150 ), "Authorized groups are : " .. groups )
			surface.PlaySound( "facial_emote/error.wav" )
		end
	end
	
	parametersBtn:SetText( "Parameters" )
	parametersBtn.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_click.wav" )
		menuPanel:AlphaTo( 0, 0.4, 0, function()
			menuPanel:Remove()
			facialEmote.interface.openParameters()
		end ) 
	end
	
	supportBtn:SetText( "Informations" )
	supportBtn.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_click.wav" )
		menuPanel:AlphaTo( 0, 0.4, 0, function()
			menuPanel:Remove()
			facialEmote.interface.openInformation()
		end ) 
	end
	
	exitBtn:SetText( "Close" )
	exitBtn.DoClick = function()
		surface.PlaySound( "facial_emote/button_click.wav" )
		menuPanel:AlphaTo( 0, 0.4, 0, function()
			menuPanel:Remove()
		end ) 
	end
end
