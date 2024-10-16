-- "lua\\facial_emote\\interface\\vgui\\dnumslider_facialemote.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local PANEL = {}

function PANEL:Init()
	local childrens = self:GetChildren()
	
	self.TextArea:SetTextColor( color_white )
	self.TextArea:SetFont( "Trebuchet24" )
	
	self.Slider:SetWide( self:GetWide()*0.9 )
	self.Slider.Paint = function( self, w, h )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, h/2, w, 2 )
	end
	local sliderBtn = self.Slider:GetChildren()[1]
	
	sliderBtn.Paint = function( self, w, h )
		if ( facialEmote.interface.isMaterialValid( "circdle" ) ) then
			surface.SetDrawColor( color_white )
			surface.SetMaterial( facialEmote.interface.getMaterial( "circle" ) )
			surface.DrawTexturedRect( 0, 0, w, h )
		else
			surface.SetDrawColor( color_white )
			draw.NoTexture()
			draw.CircleFacialEmote( w/2, h/2 + 1, h/2, 20 )
		end
	end    

	self.Label:SetFont( "Trebuchet18" )
	self.Label:SetContentAlignment( 5 )
	self.Label:SetTextColor( color_white )
end 

function PANEL:Paint( w, h )
	surface.SetDrawColor( 80, 80, 80, 100 )
	surface.DrawRect( self:GetWide() * 0.4 - 5, 0, w, h )
end
   
function PANEL:PerformLayout()
	self.Label:SetWide( self:GetWide() * 0.4 ) 
end
 

derma.DefineControl( "DNumSlider_FacialEmote", "Derived DNumSlier for facial emote mod", PANEL, "DNumSlider" )


-- if ( IsValid( DermaPanel ) ) then
	-- DermaPanel:Remove()
-- end

-- DermaPanel = vgui.Create( "DFrame" )
-- DermaPanel:SetPos( 100, 100 )
-- DermaPanel:SetSize( 500, 200 )
-- DermaPanel:SetTitle( "frame" )
-- DermaPanel:MakePopup()

-- local DermaPanel = vgui.Create( "DNumSlider_FacialEmote", DermaPanel )
-- DermaPanel:SetPos( 50, 50 )
-- DermaPanel:SetText( "-------------------------------------------------------------------" )   
-- DermaPanel:SetSize( 400, 25 )   