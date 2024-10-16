-- "lua\\facial_emote\\interface\\vgui\\dscrollpanel_facialemote.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local PANEL = {}

function PANEL:Init()
	local sbar = self:GetVBar()
	sbar:SetHideButtons( true )
	
	function sbar:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0, 180 )
		surface.DrawRect( 0, 0, w, h )
	end
	function sbar.btnGrip:Paint( w, h )
		local wVal = 180 + math.sin( CurTime() * 3 ) * 40
		surface.SetDrawColor( wVal, wVal, wVal, 255 )
		surface.DrawRect( 0, 0, w, h )
	end
end 

function PANEL:SetGripSize( w )
	self:GetVBar():SetWide( w )
end

derma.DefineControl( "DScrollPanel_FacialEmote", "Derived DScrollPanel for facial emote mod", PANEL, "DScrollPanel" )
