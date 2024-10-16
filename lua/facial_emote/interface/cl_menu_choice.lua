-- "lua\\facial_emote\\interface\\cl_menu_choice.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Draw of the main choice panel
local function drawChoicePanel( self, w, h )
	surface.SetDrawColor( 80, 80, 85, 255 )
	surface.DrawRect( 0, 0, w, h )
		
	local gradientRight = facialEmote.interface.getMaterial( "gradient_right_hard" )
	if ( gradientRight ) then
		surface.SetDrawColor( 150, 150, 150, 255 )
		surface.SetMaterial( gradientRight )
		surface.DrawTexturedRect( 0, 0, w, 35 )
	else
		draw.GradientBox( 0, 0, w*2.5, 35, 0, Color( 150, 150, 150, 255 ), Color( 0, 0, 0, 0 ) )
	end

	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawRect( 5, h - 45, 390, 40 )
	
	surface.SetDrawColor( Color( 120, 120, 120, 255 ) )
	surface.DrawOutlinedRect( 0, 0, w, h )
	surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
end

local function drawButton( self, w, h )
	if ( self:IsHovered() ) then
		if ( self:IsDown() ) then
			surface.SetDrawColor( 80, 80, 125, 255 )
		else
			surface.SetDrawColor( 100, 100, 110, 255 )
		end
	else
		surface.SetDrawColor( 45, 45, 50, 255 )
	end
 
	surface.DrawRect( 0, 0, w, h )
	surface.SetDrawColor( ( self:IsHovered() and color_white ) or ( Color( 170, 170, 170 ) ) )
	surface.DrawOutlinedRect( 0, 0, w, h )

	local textColor = ( ( self:IsHovered() and self.hoveredTextColor ) or color_white )
	draw.SimpleText( self:GetText(), "Trebuchet24", w/2, h/2, textColor, 1, 1 )
	return true	
end 

local function onHoveredButton( self )
	surface.PlaySound( "facial_emote/button_hovered.wav" )
end
 
local function onButtonClicked( self )
	if ( self.func ) then self.func() end
	self:GetParent():Remove()
end

-- Create a panel with 2 choices
function facialEmote.interface.createChoice( title, text, btnValidTxt, btnUnvldTxt, vldFunc, unvldFunc, linkedPanel )
	local title, text, btnValidTxt, btnUnvldTxt	= ( title or "NO TITLE" ), ( text or "NO TEXT" ), ( btnValidTxt or "1" ), ( btnUnvldTxt or "2" )
 
	local backgroundPnl = vgui.Create( "DPanel" )
	backgroundPnl:SetPos( 0, 0 )
	backgroundPnl:SetSize( ScrW(), ScrH() )
	backgroundPnl:MakePopup()
	backgroundPnl.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, w, h )
	end
	backgroundPnl.OnChildRemoved = function( self, child )
		self:Remove()
	end
	
	if ( linkedPanel ) then
		backgroundPnl.Think = function( self )
			if ( not IsValid( linkedPanel ) ) then
				self:Remove()
			end
		end
	end

	local choiceFrame = vgui.Create( "DFrame", backgroundPnl )
	choiceFrame:SetSize( 400, 75 )
	choiceFrame:SetTitle( title )
	choiceFrame:ShowCloseButton( false )
	choiceFrame:SetAlpha( 0 )
	choiceFrame:AlphaTo( 255, 0.5 )
	choiceFrame:Center()  
	choiceFrame.Paint = drawChoicePanel
	choiceFrame.PerformLayout = function(self) end
	
	choiceFrame.btnYes 	= vgui.Create( "DButton", choiceFrame )
	choiceFrame.btnNo 	= vgui.Create( "DButton", choiceFrame )
	choiceFrame.descText = vgui.Create( "DLabel", choiceFrame )
	
	choiceFrame.lblTitle:SetFont( "Trebuchet24" )
	choiceFrame.lblTitle:SetTextColor( Color( 255, 255, 255, 255 ) )
	choiceFrame.lblTitle:SetPos( 10, 8 )
	
	choiceFrame.descText:SetPos( 5, 40 )
	choiceFrame.descText:SetFont( "Trebuchet18" )
	choiceFrame.descText:SetContentAlignment( 5 )
	choiceFrame.descText:SetWrap( true )
	choiceFrame.descText:SetText( text )
	choiceFrame.descText:SetSize( 390, 100 )
	choiceFrame.descText:SetTextInset( 20, 0 )
	choiceFrame.descText:SetTextColor( Color( 255, 255, 255 ) )

	choiceFrame.descText.lastSize = 0 
	choiceFrame.descText.Paint = function( self, w, h )
		surface.SetDrawColor( 45, 45, 55, 255 )
		surface.DrawRect( 0, 0, w, h )
	end
	choiceFrame.descText.Think = function( self )
		local w, h = self:GetContentSize() 
		if ( h ~= self.lastSize ) then
			self:SetSize( 390, h + 20)
			self.lastSize  = h
		end
	end
	choiceFrame.descText.PerformLayout = function( self )
		local _, h = self:GetSize()
		local hSize = 40 + h + 45
		
		choiceFrame:SetSize( 400, hSize )
		choiceFrame.btnYes:SetPos( 10, hSize - 40 )
		choiceFrame.btnNo:SetPos( 210, hSize - 40 )
	end

	choiceFrame.btnYes:SetSize( 180, 30 )
	choiceFrame.btnYes:SetText( btnValidTxt )
	choiceFrame.btnYes.hoveredTextColor = Color( 120, 255, 120 )
	choiceFrame.btnYes.func = vldFunc
	choiceFrame.btnYes.OnCursorEntered = onHoveredButton
	choiceFrame.btnYes.DoClick = onButtonClicked
	choiceFrame.btnYes.Paint = drawButton
	
	choiceFrame.btnNo:SetSize( 180, 30 )
	choiceFrame.btnNo:SetText( btnUnvldTxt )
	choiceFrame.btnNo.hoveredTextColor = Color( 255, 120, 120 )
	choiceFrame.btnNo.func = unvldFunc
	choiceFrame.btnNo.OnCursorEntered = onHoveredButton
   	choiceFrame.btnNo.DoClick = onButtonClicked
	choiceFrame.btnNo.Paint = drawButton

   return backgroundPnl 
end