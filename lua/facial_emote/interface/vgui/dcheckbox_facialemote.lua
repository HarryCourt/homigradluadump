-- "lua\\facial_emote\\interface\\vgui\\dcheckbox_facialemote.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local PANEL = {}

function PANEL:Init()
	self.primaryColor = Color( 80, 90, 90 )
	self.checkColor = Color( 0, 255, 0, 200 )
	self.iconColor = Color( 255, 255, 255 )
	self.borderColor = Color( 255, 255, 255 )
	
	self.borderSize = 2
	self.borderOnHovered = true
	
	self.zoomEnabled = true
	self.zoomVal = 0
	self.zoomMax = 5
	self.zoomStyle = 2
		
	self.iconMat = facialEmote.interface.getMaterial( "valid" )
	self.iconSize = 0
	self.iconZoomRatio = 2
	self.iconPadding = 10
	self.iconShadow = 0
	
	self.clickPos = 0 
	
	self.parentScissor = nil
end 

function PANEL:OnCursorEntered()
	self:SetZPos( 1 )
end

function PANEL:OnCursorExited()
	self:SetZPos( 0 )
end

function PANEL:SetBorderSize( num )
	self.borderSize = math.abs( num )
end

function PANEL:Think( w, h )
	if ( self:IsHovered() and self.zoomVal < self.zoomMax and self.zoomEnabled ) then
		if ( self.zoomStyle == 1 ) then
			self.zoomVal = math.Clamp( self.zoomVal + ( 20 * RealFrameTime() ), 0, self.zoomMax )
		else
			self.zoomVal = self.zoomVal + ( self.zoomMax - self.zoomVal ) * ( RealFrameTime() * 5 )
		end
	elseif ( not self:IsHovered() and self.zoomVal > 0 ) then
		if ( self.zoomStyle == 1 ) then
			self.zoomVal = math.Clamp( self.zoomVal - ( 30 * RealFrameTime() ), 0, self.zoomMax )
		else
			self.zoomVal = self.zoomVal + ( 0 - self.zoomVal ) * ( RealFrameTime() * 5 )
			if ( 0 - self.zoomVal > -0.02 ) then
				self.zoomVal = 0
			end
		end 
	end

	self:PostThink()
end

function PANEL:PostThink() end

function PANEL:SetParentScissor( pnl )
	self.parentScissor = pnl
end

function PANEL:Paint( w, h )
	
	if ( self.parentScissor ) then
		DisableClipping(true) 
		local pPosX, pPosY = self.parentScissor:LocalToScreen( 0, 0 )
		local pSizeW, pSizeH = self.parentScissor:GetSize()
		local zoomVal = self.zoomVal
		
		render.SetScissorRect( pPosX - zoomVal, pPosY - zoomVal, pPosX + pSizeW + zoomVal*2, pPosY + pSizeH + zoomVal*2, true )
	else
		DisableClipping(true) 
	end
	
	local sPosX, sPosY = self:LocalToScreen( 0, 0 )
	
	surface.SetDrawColor( self.primaryColor )
	surface.DrawRect( -self.zoomVal, -self.zoomVal, w + self.zoomVal*2, h + self.zoomVal*2 )
	
	if ( self.borderSize > 0 ) then
		surface.SetDrawColor( self.borderColor )
		for i = 1, self.borderSize do
			surface.DrawOutlinedRect( -i - self.zoomVal, -i - self.zoomVal, w + i*2 + self.zoomVal*2, h + i*2 + self.zoomVal*2 )
		end
	end
	
	if ( self:GetChecked() ) then
		surface.SetDrawColor( self.checkColor )
		surface.DrawRect( -self.zoomVal, -self.zoomVal, w + self.zoomVal*2, h + self.zoomVal*2 )
	
		surface.SetMaterial( self.iconMat )
		surface.SetDrawColor( Color( 255, 255, 255 ) )
		surface.DrawTexturedRect( 5 - (self.zoomVal*self.iconZoomRatio), 5 -(self.zoomVal*self.iconZoomRatio), ( w - 10 ) + (self.zoomVal*self.iconZoomRatio)*2, ( h - 10 ) + (self.zoomVal*self.iconZoomRatio)*2 )
	end 

	if ( self.parentScissor ) then
		render.SetScissorRect( 0, 0, 0, 0, false ) 
		DisableClipping(false)
	else
		DisableClipping(false)
	end
end
 
function PANEL:DoClick()
	self:Toggle()
	self.zoomVal = 0
	if ( self:GetChecked() ) then
		surface.PlaySound( "facial_emote/toggle_on.wav" )
	else
		surface.PlaySound( "facial_emote/toggle_off.wav" )
	end
end

derma.DefineControl( "DCheckBox_FacialEmote", "Derived DCheckBox for facial emote mod", PANEL, "DCheckBox" )