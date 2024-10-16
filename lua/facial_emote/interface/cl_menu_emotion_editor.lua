-- "lua\\facial_emote\\interface\\cl_menu_emotion_editor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

facialEmote.interface.editorPanel = ( facialEmote.interface.editorPanel or nil )

local function setVar( index, var )
	facialEmote.interface.editorPanel[index] = var
end

local function getVar( index )
	return facialEmote.interface.editorPanel[index]
end 

-- Function to create all sliders for the flex values
local function createAllFlexSliders( pnl )
	local yPos = 5
	local sliders = pnl.sliders
	for k, p in pairs ( sliders ) do
		sliders[k] = nil
		p:Remove()
	end
	
	for i = 0, LocalPlayer():GetFlexNum() - 1 do
		sliders[i] = vgui.Create( "DNumSlider_FacialEmote", pnl )
		sliders[i]:SetPos( 5, yPos )
		sliders[i]:SetSize( 250, 30 )
		sliders[i]:SetText( "(" .. i .. ") " ..  LocalPlayer():GetFlexName(i) )
		sliders[i]:SetValue( 0 )
		sliders[i]:SetMin( 0 )
		sliders[i]:SetMax( 1 )
		sliders[i]:SetDecimals( 2 )
		sliders[i].Paint = function( self, w, h )
			if ( facialEmote.interface.isMaterialValid( "gradient_right_hard" ) ) then
				surface.SetDrawColor( 50, 50, 50, 255 )
				surface.SetMaterial( facialEmote.interface.getMaterial( "gradient_right_hard" ) ) 
				surface.DrawTexturedRect( 0, 0, w, h )
			end
		end
		sliders[i].OnValueChanged = function( self, val )
			LocalPlayer():SetFlexWeight( i, val )
		end
		yPos = yPos + 35
	end 
end

-- Open the list of model that already got modification
function facialEmote.interface.openEditor()
	-- Check if the editor interface already exist and delete it to create a new one
	if ( IsValid( facialEmote.interface.editorPanel ) ) then
		facialEmote.interface.editorPanel:Remove()
	end
	facialEmote.network.sendCommand( "resetEmotion" )

	-- The main panel for the editor
	facialEmote.interface.editorPanel = vgui.Create( "DFrame" )
	local editorPanel = facialEmote.interface.editorPanel 
	local sW, sH = ScrW(), ScrH()
	
	editorPanel:SetPos( 0, 0 )
	editorPanel:SetSize( sW, sH )
	editorPanel:SetDraggable( false )
	editorPanel:MakePopup()
	
	editorPanel.mouseDragX = nil
	
	editorPanel.OnEmoteAdded = function( self, mdlPath, index )
		setVar( "alertMessage", "Emote sucessfully saved !" )
		setVar( "alertExpireTime", CurTime() + 5 )
		setVar( "alertColor", Color( 100, 255, 100 ) )
		setVar( "alertFlash", 150 )
	end
	editorPanel.OnEmoteRemoved = function( self, mdlPath, index ) end
	editorPanel.OnMousePressed = function( self, keyCode )
		self.mouseDragX = self:LocalCursorPos()
	end
	editorPanel.OnMouseReleased = function( self, keyCode ) 
		editorPanel.mouseDragX = nil
	end
	editorPanel.OnRemove = function( self ) 
		for i = 1, LocalPlayer():GetFlexNum() do
			LocalPlayer():SetFlexWeight( i, 0 )
		end
		facialEmote.network.sendCommand( "recoverPlayerModel" )
	end 
	editorPanel.Paint = function( self, w, h ) end
	editorPanel.PaintOver = function( self, w, h )
		local msg = getVar( "alertMessage" )
		if ( msg ) then
			local rgb = ( getVar( "alertFlash" ) or 0 )
			if ( rgb > 0 ) then
				setVar( "alertFlash", math.Clamp( rgb - ( 255 * RealFrameTime() ), 0, 255 ) )
			end
			surface.SetDrawColor( rgb, rgb, rgb, 150 )
			surface.DrawRect( w*0.4, 50, w*0.2, 50 )
			draw.SimpleText( msg, "Trebuchet24", w/2, 75, getVar( "alertColor" ), 1, 1 )
			if ( CurTime() > getVar( "alertExpireTime" ) ) then
				setVar( "alertMessage", nil )
			end
		end	
	end
	
	editorPanel.Think = function( self )
		local mX, mY = self:LocalCursorPos()
		if ( mX > 300 and mX < ScrW() - 300 ) then
			if ( input.IsMouseDown( MOUSE_FIRST ) ) then
				if ( self.mouseDragX ) then 
					local result = self.mouseDragX - mX
					self.mouseDragX = mX
					viewRotateTest = viewRotateTest + math.rad( result ) * 0.5
				end
			end
		end
	end
	
	-- Set variables for the menu interaction
	setVar( "playerModel", LocalPlayer():GetModel() )
	setVar( "loadedIndex", nil )
	setVar( "selectedEmoji", nil )
	setVar( "alertMessage", nil )
	setVar( "alertExpireTime", nil )
	setVar( "alertColor", nil )
	setVar( "alertFlash", nil )
	
	local editorPanel = facialEmote.interface.editorPanel
	
	editorPanel.informationPanel 	= vgui.Create( "DPanel", editorPanel )
	editorPanel.flexPanel 			= vgui.Create( "DPanel", editorPanel )
	editorPanel.nameEntry 			= vgui.Create( "DTextEntry", editorPanel.informationPanel )
	editorPanel.indexEntry 			= vgui.Create( "DNumberWang", editorPanel.informationPanel )
	
	if ( facialEmote.interface.isMaterialValid( "information" ) ) then
		editorPanel.resetButton 		= vgui.Create( "DImageButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.newModelButton 		= vgui.Create( "DImageButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.loadModelButton 	= vgui.Create( "DImageButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.quitButton 			= vgui.Create( "DImageButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.helpButton 			= vgui.Create( "DImageButton_FacialEmote", editorPanel.informationPanel )
	else
		editorPanel.resetButton 		= vgui.Create( "DButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.newModelButton 		= vgui.Create( "DButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.loadModelButton 	= vgui.Create( "DButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.quitButton 			= vgui.Create( "DButton_FacialEmote", editorPanel.informationPanel )
		editorPanel.helpButton 			= vgui.Create( "DButton_FacialEmote", editorPanel.informationPanel )
	end
	
	editorPanel.exportButton 		= vgui.Create( "DButton_FacialEmote", editorPanel.informationPanel )
	editorPanel.imageScroll 		= vgui.Create( "DScrollPanel_FacialEmote", editorPanel.informationPanel ) 
	editorPanel.flexScroll 			= vgui.Create( "DScrollPanel_FacialEmote", editorPanel.flexPanel ) 
	editorPanel.flexReset 			= vgui.Create( "DButton_FacialEmote", editorPanel.flexPanel )
	
	local informationPanel 	= editorPanel.informationPanel
	local flexPanel 		= editorPanel.flexPanel
	local nameEntry 		= editorPanel.nameEntry
	local indexEntry 		= editorPanel.indexEntry
	local resetButton 		= editorPanel.resetButton
	local newModelButton 	= editorPanel.newModelButton
	local loadModelButton 	= editorPanel.loadModelButton
	local quitButton		= editorPanel.quitButton
	local exportButton 		= editorPanel.exportButton
	local helpButton 		= editorPanel.helpButton
	local imageScroll 		= editorPanel.imageScroll
	local flexScroll 		= editorPanel.flexScroll
	local flexReset 		= editorPanel.flexReset
	
	-- Left side
 	informationPanel:SetPos( 0, 0 )
	informationPanel:SetSize( 275, ScrH() )
	informationPanel.Paint = function( self, w, h )
		surface.SetDrawColor( 90, 90, 100, 255 )
		surface.DrawRect( 0, 0, w, h )
		
		if ( facialEmote.interface.isMaterialValid( "gradient_right_hard" ) ) then
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, w, 50 )
			surface.SetDrawColor( 130, 130, 180, 255 )
			surface.SetMaterial( facialEmote.interface.getMaterial( "gradient_right_hard" ) )
			surface.DrawTexturedRect( 0, 0, w, 50 )
		else
			surface.SetDrawColor( 130, 130, 180, 255 )
			surface.DrawRect( 0, 0, w, 50 )
		end
		draw.SimpleText( "Emotion Informations", "Coolvetica30", w/2, 25, color_white, 1, 1 )
		
		local wBtn = w - 6
		
		surface.SetDrawColor( 50, 55, 65, 255 )
		surface.DrawRect( 3, 53, wBtn, 50 )
		
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawRect( 3, 103, wBtn, h - 106 )		
	end
	
	-- Right side
	flexPanel:SetPos( ScrW()-275, 0 )
	flexPanel:SetSize( 275, ScrH() )
	flexPanel.Paint = function( self, w, h )
		surface.SetDrawColor( 90, 90, 100, 255 )
		surface.DrawRect( 0, 0, w, h )
		
		if ( facialEmote.interface.isMaterialValid( "gradient_right_hard" ) ) then
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, w, 50 )
			surface.SetDrawColor( 180, 130, 130, 255 )
			surface.SetMaterial( facialEmote.interface.getMaterial( "gradient_right_hard" ) )  
			surface.DrawTexturedRect( 0, 0, w, 50 )
		else
			surface.SetDrawColor( 180, 130, 130, 255 )
			surface.DrawRect( 0, 0, w, 50 )		
		end
		draw.SimpleText( "Facial Information", "Coolvetica30", w/2, 25, color_white, 1, 1 )
		
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawRect( 3, 55, w-6, h - 59 )
	end 
	
	local topLeftButtons = { 
		{ "resetButton", "New emote pattern","add" },
		{ "newModelButton", "Select playermodel", "playermodel" },
		{ "loadModelButton", "Load emote","load" },
		{ "helpButton", "Informations","information" },
		{ "quitButton","Quit editor", "out" }
	}
	
	local xPos, yPos = 10, 5
	if ( facialEmote.interface.isMaterialValid( "information" ) ) then
		for _, info in ipairs ( topLeftButtons ) do
			editorPanel[info[1]]:SetPos( xPos, 53 + yPos )
			editorPanel[info[1]]:SetSize( 40, 40 )
			editorPanel[info[1]]:SetCircle( true )
			editorPanel[info[1]]:SetMaxZoom( 4 )
			editorPanel[info[1]]:SetMaterial( facialEmote.interface.getMaterial( info[3] ) )
			xPos = xPos + 53
		end
	else
		for _, info in ipairs ( topLeftButtons ) do
			editorPanel[info[1]]:SetPos( xPos, 53 + yPos )
			editorPanel[info[1]]:SetSize( informationPanel:GetWide() - 20, 25 )
			editorPanel[info[1]]:SetText( info[2] )
			editorPanel[info[1]]:SetFont( "Coolvetica40" )
			yPos = yPos + 28
		end
	end
	
	resetButton:SetColor( Color( 50, 180, 50 ) )
	newModelButton:SetColor( Color( 170, 50, 150 ) )
	loadModelButton:SetColor( Color( 100, 100, 220 ) )
	helpButton:SetColor( Color( 100, 200, 200 ) )
	quitButton:SetColor( Color( 215, 80, 80 ) )
	
	resetButton.DoClick = function( self )
		local function resetAllSettings()
			local index = 1
			local emoteData = facialEmote.face.data[LocalPlayer():GetModel()]
			if ( emoteData ) then
				for i = 1, 100 do
					if ( not emoteData[i] ) then
						index = i
						break
					end
				end
			end
			indexEntry:SetValue( index )
			nameEntry:SetValue( "Insert name here" )
			setVar( "selectedEmoji", nil )
			setVar( "alertMessage", "All settings reset" )
			setVar( "alertColor", Color( 255, 255, 255 ) )
			setVar( "alertExpireTime", CurTime() + 3 )
			setVar( "alertFlash", 255 )
			for k, p in pairs ( flexScroll.sliders ) do
				p:SetValue( 0 )
			end
			for i = 1, LocalPlayer():GetFlexNum() do
				LocalPlayer():SetFlexWeight( i, 0 )
			end
		end
		
		if ( facialEmote.face.data[LocalPlayer():GetModel()] and not facialEmote.face.data[LocalPlayer():GetModel()][indexEntry:GetValue()] ) then
			facialEmote.interface.createChoice( "Create new emotion", "You haven't save your emote, are you sure you want to continue ?", "Yes", "No", resetAllSettings )
		else
			resetAllSettings()
		end
		surface.PlaySound( "facial_emote/button_click.wav" )
	end
	
	newModelButton.DoClick = function( self )
		facialEmote.interface.openModelSelector()
		surface.PlaySound( "facial_emote/fade_in.wav" )
		surface.PlaySound( "facial_emote/button_click.wav" )
	end 
		
	loadModelButton.DoClick = function( self ) 
		surface.PlaySound( "facial_emote/fade_in.wav" )
		facialEmote.interface.openEmoteSelector()
		surface.PlaySound( "facial_emote/button_click.wav" )
	end	
	
	helpButton.DoClick = function( self )
		facialEmote.interface.createChoice( "NEED HELP ?", "If you have any question you can post a comment in the workshop addon", "Okay", "Link (next update)" )
		surface.PlaySound( "facial_emote/button_click.wav" )
	end

	quitButton.DoClick = function( self )
		self:GetParent():GetParent():Remove()
		facialEmote.interface.openMenu()
		surface.PlaySound( "facial_emote/button_click.wav" )
	end 

	local _, child_h = informationPanel:ChildrenSize()
	
	-- The name entry
	nameEntry:SetPos( 70, child_h + 10 )
	nameEntry:SetSize( 190, 30 )    
	nameEntry:SetValue( "Insert name here" )
	-- nameEntry:SetFont( "Trebuchet24" )
	nameEntry:SetAllowNonAsciiCharacters( false )
	nameEntry:SetTextColor( Color( 20, 20, 20 ) )
	nameEntry.OnGetFocus = function( self )
		if ( self:GetValue() == "Insert name here" ) then
			self:SetValue( "" )
		end
	end

	-- Get a free index for the model
	local index = 1
	local emoteData = facialEmote.face.data[LocalPlayer():GetModel()]
	if ( emoteData ) then
		for i = 1, 100 do
			if ( not emoteData[i] ) then
				index = i
				break
			end
		end
	end
	
	-- The index entry
	indexEntry:SetPos( 15, child_h + 10 )
	indexEntry:SetSize( 45, 30 )
	indexEntry:SetMin( 1 )
	indexEntry:SetMax( 50 )
	indexEntry:SetValue( index )
	indexEntry:SetDrawLanguageID( false ) 
	indexEntry:SetFont( "DermaLarge" )
	
	local _, child_h = informationPanel:ChildrenSize() 
	imageScroll:SetPos( 10, child_h + 5 )
	imageScroll:SetSize( 255, informationPanel:GetTall() - ( child_h + 70 ))
	imageScroll:SetGripSize( 7 )
	imageScroll.emojisButtons = {}
	imageScroll.Paint = function( self, w, h )
		if ( facialEmote.interface.isMaterialValid( "left_corner" ) ) then
			surface.SetDrawColor( 0, 0, 0, 150 )
			surface.SetMaterial( facialEmote.interface.getMaterial( "left_corner" ) )
			surface.DrawTexturedRect( 0, 0, w, h )	
		end
	end	 
	
	flexScroll:SetPos( 5, 55 )	
	flexScroll:SetSize( 265, ScrH() - 125 )
	flexScroll:SetGripSize( 7 )
	flexScroll.sliders = {}
	flexScroll.Paint = function( self, w, h ) end	
	flexScroll.Think = function( self )
		if ( LocalPlayer():GetModel() ~= getVar( "playerModel" ) ) then
			createAllFlexSliders( self )			
			local index = 1
			local emoteData = facialEmote.face.data[LocalPlayer():GetModel()]
			if ( emoteData ) then
				for i = 1, 100 do
					if ( not emoteData[i] ) then
						index = i
						break
					end
				end
			end
			indexEntry:SetValue( index )
			setVar( "playerModel", LocalPlayer():GetModel() )
		end
	end
	
	createAllFlexSliders( flexScroll ) -- Create all sliders
	
	-- Create all the emojis button
	local xPos, yPos = 5, 5
	for k, v in pairs ( facialEmote.interface.emojis ) do
		imageScroll.emojisButtons[k] = vgui.Create( "DButton", imageScroll )
		local imgButton = imageScroll.emojisButtons[k]
		
		imgButton:SetPos( xPos, yPos )
		imgButton:SetSize( 55, 55 )
		imgButton.emojiKey = k
		imgButton.material = v
		imgButton.percentSize = 90
		imgButton.alpha = 50
		imgButton.Think = function( self )
			if ( imgButton.emojiKey == getVar( "selectedEmoji" ) ) then
				if ( self.percentSize < 100 ) then
					self.percentSize = math.Clamp( self.percentSize + ( 150 * RealFrameTime() ), 0, 100 )
				end
			else
				if ( self.percentSize > 90 ) then
					self.percentSize = math.Clamp( self.percentSize - ( 100 * RealFrameTime() ), 0, 90 )
				end
			end
		end
		imgButton.DoClick = function( self, w, h )
			self.percentSize = 80
			informationPanel.selectedEmoji = setVar( "selectedEmoji", self.emojiKey )
			surface.PlaySound( "facial_emote/test_3.wav" )
		end
		imgButton.Paint = function( self, w, h )
			surface.SetMaterial( self.material )
			if ( imgButton.emojiKey == getVar( "selectedEmoji" ) ) then
				surface.SetDrawColor( 255, 255, 255, 255 )
			else
				surface.SetDrawColor( 255, 255, 255, 70 )
			end
			
			if ( self.percentSize == 100 ) then
				surface.DrawTexturedRect( 0, 0, w, h )
			else
				local ratio = self.percentSize/100
				local halfW, halfH = w/2, h/2
				surface.DrawTexturedRect( ( halfW ) - ( halfW ) * ratio , ( halfH) - ( halfH ) * ratio, w * ratio, h * ratio )
			end
			return true
		end
	
		xPos = xPos + 60
		if ( xPos > 200 ) then
			yPos = yPos + 60
			xPos = 5
		end
	end
	
	exportButton:SetPos( 6, ScrH() - 60 ) 
	exportButton:SetSize( 263, 50 )
	exportButton:SetFont( "DermaLarge" )
	exportButton:SetText( "Save emote" )
	exportButton.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_click.wav" )
		
		local err = false
		local name = string.Replace( nameEntry:GetValue(), " ", "" )
		
		if ( name == "" or name == "Insert name here" ) then
			setVar( "alertMessage", "The name is incorrect !" )
			setVar( "alertColor", Color( 255, 0, 0 ) )
			setVar( "alertExpireTime", CurTime() + 5 )
			setVar( "alertFlash", 255 )
			surface.PlaySound( "facial_emote/error.wav" )
			return
		end
		if ( not getVar( "selectedEmoji" ) ) then
			setVar( "alertMessage", "You need to select an emoji !" )
			setVar( "alertColor", Color( 255, 0, 0 ) )
			setVar( "alertExpireTime", CurTime() + 5 )
			setVar( "alertFlash", 255 )
			surface.PlaySound( "facial_emote/error.wav" )
			return
		end
		
		local function saveEmote()
			local flexData = {}
			for k, v in pairs ( flexScroll.sliders ) do
				if ( v:GetValue() > 0 ) then
					flexData[k] = v:GetValue()
				end
			end
			facialEmote.network.sendCommand( "saveEmote", LocalPlayer():GetModel(), indexEntry:GetValue(), flexData, nameEntry:GetValue(), getVar( "selectedEmoji" ) )
		end
		
		if ( facialEmote.face.data[LocalPlayer():GetModel()] ) then
			if ( facialEmote.face.data[LocalPlayer():GetModel()][tonumber(indexEntry:GetValue())] ) then
				facialEmote.interface.createChoice( "Overwrite the emote", "There's already an emote that exist with this index are you sure you want to erase it ?", "YES", "NO", saveEmote )
			else
				saveEmote()
			end
		else
			saveEmote()
		end
	end	
	
	flexReset:SetPos( 6, ScrH() - 60 ) 
	flexReset:SetSize( 263, 50 )
	flexReset:SetFont( "DermaLarge" )
	flexReset:SetText( "Reset" )
	flexReset.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_click.wav" )
		for k, p in pairs ( flexScroll.sliders ) do
			p:SetValue( 0 )
		end
		for i = 1, LocalPlayer():GetFlexNum() do
			LocalPlayer():SetFlexWeight( i, 0 )
		end
	end
	
end