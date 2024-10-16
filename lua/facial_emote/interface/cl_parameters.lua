-- "lua\\facial_emote\\interface\\cl_parameters.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

-- This part is giga diga biga not optimized , i'm getting bored about this project

local function createCtgr( text, w, h )
	local panel = vgui.Create( "DPanel", facialEmote.interface.parametersPanel.scrollPanel )
	panel:SetPos( 5, 5 )
	panel:SetSize( ( w or 128 ) - 10, 10 )
	panel.oldW = w
	panel.oldH = h
	panel.color = Color( 255, 150, 150 )
	panel.text = text
	
	panel.Paint = function( self, w, h )
		surface.SetDrawColor( self.color )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( Color( 0, 0, 0, 125 ) )
		surface.DrawRect( 0, 0, w, 40 )
		
		draw.SimpleText( self.text, "Coolvetica35", w/2, 20, color_white, 1, 1 )
		-- I didnt find an another way to fix the zPos bug
		-- if ( w ~= self.oldW or h ~= self.oldH ) then
			-- self.customPerformLayout( self, w, h )
			-- self.oldW, self.oldH = w, h 
		-- end
	end
	panel.customPerformLayout = function( self, w, h )
		local yPos = 5
		for k, v in pairs ( self:GetChildren() ) do
			v:SetPos( 5, yPos )
			v:SetWide( w - 10 )
			yPos = yPos + v:GetTall() + 5
		end
	end
	
	panel.yPos = 45
	panel.OnChildAdded = function( self, child )
		child:SetPos( 5, panel.yPos )
		panel.yPos = panel.yPos + child:GetTall() + 5 
		local _, chldSizeH = self:ChildrenSize()
		self:SetTall( chldSizeH + 5 ) 
	end
	return panel
end

local function createBar( parent, text, btn, y )
	local bar = vgui.Create( "DPanel" )
	bar:SetPos( 0, 5 )
	bar:SetSize( 470, ( y or 30 ) )
	bar.oldW = w
	bar.oldH = h
	bar.font = nil

	bar.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 180 ) )
		surface.DrawRect( 0, 0, w, h )
		draw.SimpleText( text, ( self.font or "Coolvetica24" ), 5, h/2, color_white, 0, 1  )
		
		-- I didnt find an another way to fix the zPos bug
		if ( w ~= self.oldW or h ~= self.oldH ) then
			self.customPerformLayout( self, w, h )
			self.oldW, self.oldH = w, h 
		end 
	end
	bar.customPerformLayout = function( self, w, h )
		self.btn:SetPos( w - self.btn:GetWide() - 4, 4 ) 
		self.btn:SetSize( self.btn:GetWide(), h - 8 )
		if ( self.btn.SetParentScissor ) then
			self.btn:SetParentScissor( facialEmote.interface.parametersPanel.scrollPanel )
		end
	end
	 
	btn:SetParent( bar )	
	bar.btn = btn
	bar:SetParent( parent )
	
	return btn, bar
end
 
local function selectCtgr( index )
	for k, pnl in pairs ( facialEmote.interface.parametersPanel.category ) do
		if ( k == index ) then
			pnl:SetVisible( true )
		else
			pnl:SetVisible( false )
		end
	end
end
 
function facialEmote.interface.openParameters()
	if ( IsValid( facialEmote.interface.parametersPanel ) ) then
		facialEmote.interface.parametersPanel:Remove()
	end
	
	facialEmote.interface.parametersPanel = vgui.Create( "DFrame" )
	local parametersPanel = facialEmote.interface.parametersPanel

	parametersPanel.scrollPanel = vgui.Create( "DScrollPanel_FacialEmote", parametersPanel )
	parametersPanel.closeBtn 	= vgui.Create( "DButton_FacialEmote", parametersPanel )
	
	local scrollPanel = parametersPanel.scrollPanel
	local closeBtn 	= parametersPanel.closeBtn
	
	parametersPanel:SetPos( 100, 100 )
	parametersPanel:SetSize( 500, 450 )
	parametersPanel:ShowCloseButton( true )
	parametersPanel:SetAlpha( 1 )
	parametersPanel:AlphaTo( 255, 0.4 )
	parametersPanel:SetTitle( "" )
	parametersPanel:SetSizable( false )
	parametersPanel:SetDraggable( true )
	parametersPanel:ShowCloseButton( false )
	parametersPanel:Center()
	parametersPanel:MakePopup()
	
	parametersPanel.titleH = 50
	parametersPanel.category = {}
	
	parametersPanel.primaryColor = Color( 90, 90, 100 )
	parametersPanel.Paint = function( self, w, h )
		surface.SetDrawColor( self.primaryColor )
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( 40, 40, 80 )
		surface.DrawRect( 0, 0, w, self.titleH  )
		draw.SimpleText( "PARAMETERS", "Coolvetica40", w/2, 25, Color( 255, 255, 255 ), 1, 1 )
	end
	parametersPanel.alertText = ""
	parametersPanel.alertExpireTime = 0
	parametersPanel.alertAlpha = 0
	parametersPanel.PaintOver = function( self, w, h )
		if ( self.alertAlpha > 0 ) then
			surface.SetDrawColor( Color( 255, 255, 255, self.alertAlpha ) )
			surface.DrawRect( 0, h*.4, w, h*.2 )
			draw.SimpleText( self.alertText, "Coolvetica50", w/2,  h*.5, Color( 50, 50, 50, self.alertAlpha ), 1, 1 )
			if ( CurTime() > self.alertExpireTime ) then
				self.alertAlpha = math.Clamp( self.alertAlpha - ( 255 * RealFrameTime() ), 0, 255 )
			end		
		end
	end
	parametersPanel.btnClose.DoClick = function ( self, button ) 		
		parametersPanel:AlphaTo( 0, 0.25, 0, function( self )
			parametersPanel:Remove()
			facialEmote.interface.openMenu()
		end )
	end
	
	scrollPanel:SetPos( 5, parametersPanel.titleH + 5 )
	scrollPanel:SetSize( 490, parametersPanel:GetTall() - parametersPanel.titleH - 55 )
	scrollPanel:SetGripSize( 5 )
	scrollPanel.performLayoutCast = false
	scrollPanel.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 50, 50, 65 ) )
		surface.DrawRect( 0, 0, w, h )
		DisableClipping( true )
		surface.SetDrawColor( Color( 50, 50, 65 ) )
		surface.DrawRect( 0, h, w, 5 )
		DisableClipping( false )
	end
 
	closeBtn:SetPos( 5, parametersPanel:GetTall() - parametersPanel.titleH + 10 )
	closeBtn:SetSize( parametersPanel:GetWide() - 10, 35 )
	closeBtn:SetText( "Close" )
	closeBtn:SetFont( "Coolvetica50" )
	closeBtn:SetColor( Color( 180, 80, 80 ) )
	closeBtn:SetBorderColor( Color( 255, 255, 255 ) )
	closeBtn.DoClick = function( self )
		parametersPanel:AlphaTo( 0, 0.25, 0, function( self )
			parametersPanel:Remove()
			facialEmote.interface.openMenu()
		end )
	end
	
	local hotkey_binder = vgui.Create( "DBinder" )
	-- local editor_icon = vgui.Create( "DCheckBox_FacialEmote" )
	local allowed_groups = vgui.Create( "DButton_FacialEmote" )
	local request_emote_from_server = vgui.Create( "DButton_FacialEmote" )
	local enable_debug = vgui.Create( "DCheckBox_FacialEmote" )
	local search_error = vgui.Create( "DButton_FacialEmote" )
	
	local checkBox = { request_emote_from_server, enable_debug }
	for _, btn in pairs ( checkBox ) do
		btn:SetBorderSize( 1 )
		btn:SetWide( 24 )
	end
	
	local dBtn = { allowed_groups, request_emote_from_server, search_error }
	for _, btn in pairs ( dBtn ) do
		btn:SetFont( "Coolvetica35" )
		btn:SetBorderColor( color_white )
		btn:SetBorderSize( 1 )
		btn:SetBorderOnHovered( false )
		btn:EnableZoom( false )
		btn:SetFont( "Coolvetica20" )
		btn:SetWide( 75 )
	end
	
	local hoykey = GetConVar( "fe_wheelbind" )
	if ( hoykey ) then
		hotkey_binder:SetValue( hoykey:GetInt() )
	end	
	hotkey_binder.OnChange = function( self, num )
		if ( num == 107 ) then return end
		self:SetText( string.upper( self:GetText() ) )
		GetConVar( "fe_wheelbind" ):SetInt( num )
	end
	hotkey_binder:SetWide( 100 )
	hotkey_binder:SetText( string.upper( hotkey_binder:GetText() ) )
	hotkey_binder.DoClick = function( self )
		self:SetText( "PRESS A KEY" )
		input.StartKeyTrapping()
		self.Trapping = true
	end
	hotkey_binder.DoRightClick = function( self)
		self:SetText( "NONE" )
		self:SetValue( 0 )
	end
	hotkey_binder.Paint = function( self, w, h )
		surface.SetDrawColor( 70, 70, 70, 255 )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
		draw.SimpleText( self:GetText(), "Coolvetica20", w/2, h/2, color_white, 1, 1 )
		return true
	end
	
	request_emote_from_server.DoClick = function( self )
		parametersPanel.alertText 		= "Emote requested !"
		parametersPanel.alertExpireTime = CurTime() + 0.5
		parametersPanel.alertAlpha 		= 255
		surface.PlaySound( "facial_emote/debug.wav" )
		facialEmote.network.sendCommand( "requestEmoteData" )
	end
	
	search_error.DoClick = function( self )
		facialEmote.interface.openErrorHunter()
	end
	
	allowed_groups.DoClick = function( self )
		local isAllowed = facialEmote.parameters.client.authorizedGroups[LocalPlayer():GetUserGroup()]
		if ( isAllowed ) then
			facialEmote.interface.openGroupEditor()
		else
			parametersPanel.alertText 		= "Admin only"
			parametersPanel.alertExpireTime = CurTime() + 0.5
			parametersPanel.alertAlpha 		= 255
			surface.PlaySound( "facial_emote/error.wav" )
			
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
	
	allowed_groups:SetText( "Edit" ) 
	request_emote_from_server:SetMaxZoom( 5 )  
	request_emote_from_server:SetText( "Request" )
	search_error:SetText( "Search" )
	
	local enabledCVar = GetConVar( "fe_debug_enabled" )
	if ( enabledCVar ) then
		enable_debug:SetValue( enabledCVar:GetBool() )
	end	
	enable_debug.OnChange = function( self, bVal )
		enabledCVar:SetBool( bVal )
	end
	
	local client = createCtgr( "Client", 490 )
	client.color = Color( 255, 180, 100 )
	
	createBar( client, "Hotkey emote wheel", hotkey_binder, 40 )
	-- createBar( client, "Enable icon in editor", editor_icon, 30 )
	
	local server = createCtgr( "Server", 490 )
	server:SetPos( 5, client.yPos + 10 )
	server.color = Color( 130, 240, 240 )
	createBar( server, "Edit groups allowed to use the editor", allowed_groups )

	
	local debugTab = createCtgr( "Debug", 490 )
	debugTab:SetPos( 5, client.yPos + server.yPos + 15 )
	debugTab.color = Color( 130, 240, 130 )
	createBar( debugTab, "Request emote from server", request_emote_from_server )
	createBar( debugTab, "Search any lua problem", search_error )
	createBar( debugTab, "Enable debug notification", enable_debug )

	
	-- idk men ..
	local emptySpace = vgui.Create( "DPanel", scrollPanel )
	emptySpace:SetPos( 0, client.yPos + server.yPos + debugTab.yPos + 5 )
	emptySpace:SetSize( 5, 5 )
	emptySpace.Paint = function() end
	
end