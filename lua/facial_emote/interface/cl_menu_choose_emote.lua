-- "lua\\facial_emote\\interface\\cl_menu_choose_emote.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Create the list of all emote a model got
local function createEmotionList( mainFrame, mdlPath )
	if ( not IsValid( mainFrame ) ) then return end
	
	local scrollPnl = mainFrame.emotionScroll
	if ( not IsValid( scrollPnl ) ) then return end
	if ( not scrollPnl.emoScroll ) then return end
	if ( not facialEmote.face.data[mdlPath] ) then return end
	
	local emotionTable = facialEmote.face.data[mdlPath]
	local editorPanel = facialEmote.interface.editorPanel
	
	-- Reset the selected emote
	if ( mainFrame.selectedEmote ) then
		mainFrame.selectedEmote = nil
	end
	
	scrollPnl:GetParent().selectedModel = mdlPath
	
	for k, p in pairs ( scrollPnl.emoList ) do
		p:Remove()
		scrollPnl[k] = nil
	end
	
	local yPos = 0
	for index, v in pairs ( emotionTable ) do
		scrollPnl.emoList[index] = vgui.Create( "DButton", scrollPnl )
		
		local emotionButton = scrollPnl.emoList[index]
		local emoji = vgui.Create( "DImage", emotionButton )
	
		emotionButton:SetPos( 0, yPos )
		emotionButton:SetSize( 390, 64 )
		emotionButton.Paint = function( self, w, h )
			if ( mainFrame.selectedEmote == index ) then
				surface.SetDrawColor( 140, 150, 160, 255 )
			else
				surface.SetDrawColor( 70, 80, 90, 255 )
			end
			surface.DrawRect( 0, 0, w, h )
			draw.SimpleText( v.name, "DermaLarge", 65, 32, color_white, 0, 1 )
			return true
		end
		emotionButton.DoClick = function( self )
			surface.PlaySound( "facial_emote/button_hovered.wav" )
			mainFrame.selectedEmote = index
		end
		
		emoji:SetPos( 2, 2 )
		emoji:SetSize( 60, 60 )
		emoji:SetMaterial( facialEmote.interface.emojis[v.image] )	
		emoji.Paint = function( self, w, h )
			if ( self:GetMaterial() ) then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( self:GetMaterial()	)
				surface.DrawTexturedRect( 0, 0, w, h )
			end
			draw.SimpleTextOutlined( index, "DermaLarge", w, h, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0, 255 ) )
		end
	
		yPos = yPos + 66
	end
end

-- Create the list of all models that have emote
local function createModelButtons( mainFrame )
	local yPos = 5
	local pnl = mainFrame.mdlScroll
	
	for mdlPath, v in pairs ( facialEmote.face.data ) do
		local btn = vgui.Create( "DButton", pnl )
		local modelImage = vgui.Create( "ModelImage", btn )
		
		btn:SetPos( 3, yPos )
		btn:SetSize( 64, 64 )
		btn.model = mdlPath

		modelImage:SetPos( 0, 0 )
		modelImage:SetSize( 64, 64 )
		modelImage:SetModel( mdlPath )
		modelImage:SetMouseInputEnabled( false )
		modelImage:SetKeyboardInputEnabled( false )
		
		btn.Paint = function( self, w, h ) 
			if ( mainFrame.selectedModel == self.model ) then
				surface.SetDrawColor( 200, 200, 200, 200 )
				surface.DrawRect( 0, 0, w, h )
			end
			return true
		end

		btn.PaintOver = function( self, w, h )
			if ( mainFrame.selectedModel == self.model ) then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawOutlinedRect( 0, 0, w, h )
				surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
				surface.DrawOutlinedRect( 2, 2, w-4, h-4 )
			end
			
			if ( self:IsHovered() ) then
				surface.SetDrawColor( 255, 255, 255, 20 )
				surface.DrawRect( 0, 0, w, h )
			end
		end
		
		btn.DoClick = function( self )
			surface.PlaySound( "facial_emote/button_hovered.wav" )
			createEmotionList( mainFrame, mdlPath )
		end
		
		yPos = yPos + 64
	end
end

facialEmote.interface.openEmoteSelector = function()
	if ( not IsValid( facialEmote.interface.editorPanel ) ) then return end
	local editorPanel = facialEmote.interface.editorPanel
	
	local background 	= vgui.Create( "DPanel", editorPanel )
	local mainFrame		= vgui.Create( "DFrame", background )

	mainFrame.mdlScroll 	= vgui.Create( "DScrollPanel_FacialEmote", mainFrame )
	mainFrame.emotionScroll = vgui.Create( "DScrollPanel_FacialEmote", mainFrame )
	
	mainFrame.closeButton 	= vgui.Create( "DImageButton_FacialEmote", mainFrame )
	mainFrame.modifyButton 	= vgui.Create( "DImageButton_FacialEmote", mainFrame )
	mainFrame.deleteButton 	= vgui.Create( "DImageButton_FacialEmote", mainFrame )
	
	-- The black background
	background:SetPos( 0, 0 )
	background:SetSize( ScrW(), ScrH() )
	background:SetAlpha( 0 )
	background:AlphaTo( 255, 0.3 )
	background.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 0, 0, 220 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	-- The main frame
	mainFrame:SetSize( 500, 500 )
	mainFrame:SetTitle( "" )
	mainFrame:Center()
	mainFrame:ShowCloseButton( false )
	mainFrame.selectedModel = ""	
	mainFrame.OnRemove = function( self )
		self:GetParent():Remove() 
	end
	mainFrame.Paint = function( self, w, h )
		surface.SetDrawColor( 100, 100, 100, 255 )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( 45, 50, 55, 255 )
		surface.DrawRect( 2, 53, w-4, h-54 )
		
		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawRect( 10, 60, 70, 370 )
		surface.DrawRect( 90, 60, 400, 370 )
		
		surface.DrawRect( 90, 60, 400, 370 )

		draw.GradientBox( -1, 0, w, 50, 0, Color( 220, 220, 220, 150 ), Color( 90, 90, 90, 150 ) )
		
		draw.SimpleText( "LOAD EMOTION", "DermaLarge", 10, 10, color_white, 0, 0 )
	end

	-- The scroll of the models
	mainFrame.mdlScroll:SetPos( 10, 60 )
	mainFrame.mdlScroll:SetSize( 78, 370 )
	mainFrame.mdlScroll:GetVBar():SetSize( 6 )
	mainFrame.mdlScroll:GetVBar():SetHideButtons( true )
	mainFrame.mdlScroll:GetVBar().Paint = function( self, w, h ) end
	mainFrame.mdlScroll:GetVBar().btnGrip.Paint = function( self, w, h )
		surface.SetDrawColor( 255, 255, 255, 100 )
		surface.DrawRect( 0, 0, w, h )
	end
	createModelButtons( mainFrame )
	
	-- The scroll of the emotes
	mainFrame.emotionScroll:SetPos( 95, 65 )
	mainFrame.emotionScroll:SetSize( 390, 360 )
	mainFrame.emotionScroll:SetGripSize( 5 )
	mainFrame.emotionScroll.emoScroll = true
	mainFrame.emotionScroll.emoList = {}
	mainFrame.emotionScroll.Paint = function( self, w, h ) end
	createEmotionList( mainFrame, LocalPlayer():GetModel() )	
	
	local btnList = {
		[3] = { "modifyButton", "load" },
		[2] = { "deleteButton", "bin" },
		[1] = { "closeButton", "cancel" }
	}
	
	mainFrame.modifyButton:SetColor( Color( 100, 100, 100 ) )
	mainFrame.deleteButton:SetColor( Color( 100, 100, 100 ) )
	mainFrame.closeButton:SetColor( Color( 230, 100, 100 ) )
	
	mainFrame.modifyButton:EnableZoom( false )
	mainFrame.deleteButton:EnableZoom( false )
	
	mainFrame.modifyButton.enabled = false
	mainFrame.deleteButton.enabled = false
	
	local xPos = 435
	for _, tb in ipairs ( btnList ) do
		local btn = mainFrame[tb[1]]
		btn:SetPos( xPos, 0 )
		btn:SetSize( 50, 50 )
		btn:AlignBottom( 10 )
		btn:SetCircle( true )
		btn:SetBorderSize( 1 )
		btn:SetMaterial( facialEmote.interface.getMaterial( tb[2] ) )
		
		xPos = xPos - 65
	end

	mainFrame.closeButton.DoClick = function( self )
		surface.PlaySound( "facial_emote/button_out.wav" )
		background:AlphaTo( 0, 0.3, nil, function( _, pnl )
			pnl:Remove()
		end )
	end
	 
	mainFrame.modifyButton.PostThink = function( self )
		if ( mainFrame.selectedEmote and not self.enabled ) then
			self:SetIconColor( Color( 255, 255, 255 ) )
			self:SetColor( Color( 100, 100, 220 ) )
			self:EnableZoom( true )
			self.enabled = true
		elseif ( not mainFrame.selectedEmote and self.enabled ) then
			self:SetIconColor( Color( 150, 150, 150 ) )
			self:SetColor( Color( 70, 70, 70 ) )
			self:EnableZoom( false )
			self.enabled = false
		end
	end
	mainFrame.modifyButton.DoClick = function( self )
		-- The problem is if you load a emotion data without the proper playerModel
		-- It will maybe try to find unknown sliders
		-- if ( mdlPath ~= LocalPlayer():GetModel() ) then
			-- facialEmote.network.sendCommand( "setPlayerModel", mdlPath )
		-- end
		if ( not mainFrame.selectedEmote ) then return end
		
		local indexEmote 	= mainFrame.selectedEmote
		if ( not facialEmote.face.data[mainFrame.selectedModel] ) then return end
		local selectedEmote = facialEmote.face.data[mainFrame.selectedModel][indexEmote]
		if ( not selectedEmote ) then return end
		
		editorPanel.indexEntry:SetValue( indexEmote )
		editorPanel.nameEntry:SetValue( selectedEmote.name )
		editorPanel.selectedEmoji = selectedEmote.image
		for _, p in pairs ( editorPanel.flexScroll.sliders ) do
			p:SetValue( 0 )
		end
		for i = 0, LocalPlayer():GetFlexNum() do
			if ( selectedEmote.data[i] ) then
				editorPanel.flexScroll.sliders[i]:SetValue( selectedEmote.data[i] )
			end
		end
		-- for k, v in pairs ( selectedEmote.data ) do
			-- editorPanel.flexScroll.sliders[k]:SetValue( v )
		-- end
		
		mainFrame:GetParent():AlphaTo( 0, 0.25, 0, function()
			mainFrame:GetParent():Remove()		
		end )
		
	end
	
	mainFrame.deleteButton.PostThink = function( self )
		if ( mainFrame.selectedEmote and not self.enabled  ) then
			self:SetIconColor( Color( 255, 255, 255 ) )
			self:SetColor( Color( 170, 50, 180 ) )
			self:EnableZoom( true )
			self.enabled = true
		elseif ( not mainFrame.selectedEmote and self.enabled ) then
			self:SetIconColor( Color( 150, 150, 150 ) )
			self:SetColor( Color( 70, 70, 70 ) )
			self:EnableZoom( false )
			self.enabled = false
		end
	end
	
	mainFrame.deleteButton.DoClick = function( self )
		if ( not mainFrame.selectedEmote ) then return end
		
		local function deleteEmote()
			local index, mdlPath = mainFrame.selectedEmote, mainFrame.selectedModel
			facialEmote.network.sendCommand( "removeEmote", mdlPath, index )
			mainFrame.emotionScroll.emoList[index]:Remove()
			mainFrame.emotionScroll.emoList[index] = nil
			local yPos = 0
			for k, p in pairs ( mainFrame.emotionScroll.emoList ) do
				if ( IsValid( p ) ) then
					p:SetPos( 0, yPos )
					yPos = yPos + 66
				end
			end
		end
		facialEmote.interface.createChoice( "Delete the emote ?", "Are you sure to delete this emote ?", "Yes", "No", deleteEmote )
	end
	
end


