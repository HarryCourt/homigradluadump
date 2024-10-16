-- "lua\\facial_emote\\interface\\init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal


facialEmote.interface.openErrorHunter = function()
	facialEmote.interface.errorHunterPanel = vgui.Create( "DFrame" )
	
	local errorHunterPanel = facialEmote.interface.errorHunterPanel
	errorHunterPanel:SetPos( 100, 100 )
	errorHunterPanel:SetSize( 600, ScrH() - 100 )
	errorHunterPanel:SetTitle( "Error hunter" )
	errorHunterPanel:Center()
	errorHunterPanel:MakePopup()
	errorHunterPanel.text = "finish"
	errorHunterPanel.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, w, h )
	end

	local richtext = vgui.Create( "RichText", errorHunterPanel )
	richtext:Dock( FILL )
 
	local error = 0
	local BOOL, NUMBER, STRING, TABLE, FUNCTION = 1, 2, 3, 4, 5
	local hookList = { DrawOverlay = "DrawOverlay_FacialEmote", PlayerButtonDown = "PlayerButtonDown_FacialEmote" }
	local hookTab = hook.GetTable()
	local enums = { boolean = BOOL, number = NUMBER, string = STRING, table = TABLE, ["function"] = FUNCTION }
	
	local subTable = { 
		data = { load = FUNCTION, write = FUNCTION },
		debug = { DrawOverlay = FUNCTION, msg = TABLE, print = FUNCTION },
		face = { data = TABLE, removeEmote = FUNCTION, saveEmote = FUNCTION },
		hooks = {},
		interface = { createChoice = FUNCTION, createMaterial = FUNCTION, drawWheel = FUNCTION, emojis = TABLE, getMaterial = FUNCTION, isMaterialValid = FUNCTION, materials = TABLE, openEditor = FUNCTION, openEmoteSelector = FUNCTION, openErrorHunter = FUNCTION, openMenu = FUNCTION, openModelList = FUNCTION, openModelSelector = FUNCTION, openParameters = FUNCTION },
		lang = { data = TABLE },
		network = { addCommand = FUNCTION, commands = TABLE, receiveCommand = FUNCTION, sendCommand = FUNCTION },
		parameters = { client = TABLE }
	}

	for k, v in pairs ( subTable ) do
		if ( facialEmote[k] ) then
			for subK, subV in pairs( v ) do
				if ( facialEmote[k][subK] and enums[type( facialEmote[k][subK] )] == subV ) then
					richtext:InsertColorChange( 30, 255, 30, 255 )
					richtext:AppendText( "Checked : " .. k .. "/" .. subK .." \n" )
				else
					richtext:InsertColorChange( 255, 70, 70, 255 )
					richtext:AppendText( "Checked : " .. k .. "/" .. subK .." \n" )
					error = error + 1
				end
			end
		else
			error = error + 1
		end
	end
	
	for k, v in pairs ( hookList ) do
		if ( hookTab[k][v] ) then
			richtext:InsertColorChange( 30, 255, 30, 255 )
			richtext:AppendText( "Checked Hook : (" .. k .. ") " .. v .." \n" )
		else
			richtext:InsertColorChange( 255, 70, 70, 255 )
			richtext:AppendText( "Checked Hook : (" .. k .. ") " .. v .." \n" )
			error = error + 1
		end
	end
	
	richtext:InsertColorChange( 255, 255, 100, 255 )
	richtext:AppendText( "Error(s) found : " .. error )
end 
  
facialEmote.interface.openInformation = function()
	facialEmote.interface.informationPanel = vgui.Create( "DFrame" )
	local informationPanel = facialEmote.interface.informationPanel
	informationPanel.mainPanel = vgui.Create( "DPanel", informationPanel )
	informationPanel.richtext = vgui.Create( "RichText", informationPanel.mainPanel )
	informationPanel.closeBtn = vgui.Create( "DButton_FacialEmote", informationPanel )
	
	local mainPanel = informationPanel.mainPanel
	local richtext 	= informationPanel.richtext
	local closeBtn 	= informationPanel.closeBtn
	
	informationPanel:SetPos( 100, 100 )
	informationPanel:SetSize( 500, 380 )
	informationPanel:SetAlpha( 0 )
	informationPanel:AlphaTo( 255, 0.25 )
	informationPanel:SetTitle( "" )
	informationPanel:ShowCloseButton( false )
	informationPanel:Center()
	informationPanel:MakePopup()
	
	informationPanel.title = "Information"
	informationPanel.titleH = 50
	informationPanel.titleCol = Color( 40, 40, 80 )
	
	informationPanel.Paint = function( self, w, h )
		surface.SetDrawColor(  80, 80, 95 )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( self.titleCol )
		surface.DrawRect( 0, 0, w, self.titleH )	
		surface.SetDrawColor( self.titleCol.r - 10, self.titleCol.g - 10, self.titleCol.b - 10 )
		surface.DrawRect( 0, self.titleH-5, w, 5 )
		draw.SimpleText( self.title, "Coolvetica50", w/2, self.titleH/2, color_white, 1, 1 )
	end
	
	mainPanel:SetPos( 5, informationPanel.titleH + 5 )
	mainPanel:DockPadding( 5, 5, 5, 5 )
	mainPanel:SetSize( informationPanel:GetWide() - 10, informationPanel:GetTall() - informationPanel.titleH - 80 )
	mainPanel.Paint = function( self, w, h )
		surface.SetDrawColor( 35, 35, 40 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local text = [[Facial emote addon made by Xenikay.

  Future update :
  - Emit a sound when you use an emote
  - Add your own emoji
  - UX and UI design improvement
  - More options for emote edition
  - In-game language editor
  - Minor Optimisation
  
  Version : ]] .. facialEmote.version
	
	richtext:Dock( FILL )
	richtext:SetVerticalScrollbarEnabled( false )
	richtext:SetText( text )
	function richtext:PerformLayout()
		richtext:SetFontInternal( "Coolvetica20" )
		richtext:SetFGColor( Color( 255, 255, 255 ) )
	end 

	closeBtn:SetPos( 5, informationPanel.titleH + mainPanel:GetTall() + 10 )
	closeBtn:SetSize( informationPanel:GetWide() - 10, 65 )
	closeBtn:SetColor( Color( 60, 60, 75 ) )
	closeBtn:SetFont( "Coolvetica55" )
	closeBtn:SetText( "Close" )
	closeBtn:SetBorderSize( 1 )
	closeBtn:SetBorderOnHovered( false )
	closeBtn:SetBorderColor( Color( 160, 160, 175 ) )
	closeBtn.DoClick = function( self )
		informationPanel:AlphaTo( 0, 0.3, 0, function()
			facialEmote.interface.openMenu()
			informationPanel:Remove()
		end )
	end
end 


-- I'm trying dock on this one
facialEmote.interface.openGroupEditor = function()
	facialEmote.interface.groupEditorPanel = vgui.Create( "DFrame" )
	
	local mainPanel = facialEmote.interface.groupEditorPanel
	
	mainPanel:SetSize( 300, 500 )
	mainPanel:SetTitle( "Edit group" )
	mainPanel:Center()
	mainPanel:MakePopup()

	local AppList = vgui.Create( "DListView", mainPanel )
	local btnPnl = vgui.Create( "DPanel", mainPanel )
	local removeGroup = vgui.Create( "DButton", btnPnl )
	local addGroup = vgui.Create( "DButton", btnPnl )
	local textEntry = vgui.Create( "DTextEntry", btnPnl )
	
	addGroup:SetText( "Add" )
	removeGroup:SetText( "Remove" )
	btnPnl:SetTall( 34 )
	
	addGroup:Dock( RIGHT )
	removeGroup:Dock( RIGHT ) 
	textEntry:Dock( FILL ) 
	AppList:Dock( FILL )
	btnPnl:Dock( BOTTOM )
	
	AppList:SetMultiSelect( false )
	AppList:AddColumn( "Authorized group" )

	for k, v in pairs ( facialEmote.parameters.client.authorizedGroups ) do
		AppList:AddLine( k )
	end
	
	AppList.OnRowSelected = function( lst, index, pnl )
		textEntry:SetValue( pnl:GetColumnText( 1 ) )
	end
	
	addGroup.DoClick = function( self )
		if ( string.Replace( textEntry:GetValue(), " ", "" ) ~= "" ) then
			facialEmote.network.sendCommand( "addAllowedGroup", textEntry:GetValue() )
			facialEmote.parameters.client.authorizedGroups[textEntry:GetValue()] = true
			for _, line in pairs( AppList:GetLines() ) do
				if ( line:GetValue( 1 ) == textEntry:GetValue() ) then
					return
				end
			end
			AppList:AddLine( textEntry:GetValue() )
		end
	end
	
	removeGroup.DoClick = function( self )
		if ( string.Replace( textEntry:GetValue(), " ", "" ) ~= "" ) then
			facialEmote.network.sendCommand( "removeAllowedGroup", textEntry:GetValue() )
			facialEmote.parameters.client.authorizedGroups[textEntry:GetValue()] = nil
			for k, line in pairs( AppList:GetLines() ) do
				if ( line:GetValue( 1 ) == textEntry:GetValue() ) then
					AppList:RemoveLine( k )
					return
				end
			end
		end
	end

end
