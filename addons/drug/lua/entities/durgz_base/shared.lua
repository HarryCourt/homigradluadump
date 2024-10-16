-- "addons\\drug\\lua\\entities\\durgz_base\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
DURGZ_HUD_FONT = "Trebuchet24"




ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drugz"
ENT.Nicknames = {"Drugz"}
ENT.OverdosePhrase = {"took"}
ENT.Author = "God"
ENT.Category = "Drugs"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Information	 = "" 



ENT.TRANSITION_TIME = 0

if(CLIENT)then
	DURGZ_LOST_VIRGINITY = false;
	
	usermessage.Hook("durgz_lose_virginity", function(um)
		DURGZ_LOST_VIRGINITY = true;
	end)
	function ENT:Initialize()
	end


	function ENT:Draw()
		self:DrawModel()
	end

 	 
	usermessage.Hook( "PlayerKilledByDrug", function( message )

		local victim 	= message:ReadEntity(); 
		local inflictor	= message:ReadString();
		
		GAMEMODE:AddDeathNotice( "", -1, inflictor, victim:Name(), victim:Team() ) 

	end) 

end

ENT.itemType = "drug"
ENT.InvMoveSnd = InvMoveSndGlass
ENT.InvCount = 6

local color = Color(255,255,255,255)

function ENT:HUDTarget(ent,k,w,h)
    color.a = 255 * k

	local rainbow = HSVToColor(CurTime() * 360,1,1)
	color.r = rainbow.r
	color.g = rainbow.g
	color.b = rainbow.b
    
    local anim =  (50 * (1 - k))

    draw.SimpleText(ent.PrintName,"ChatFont",w / 2,h / 2 - anim,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	return color
end