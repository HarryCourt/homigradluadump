-- "addons\\drug\\lua\\entities\\durgz_alcohol\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Alcohol"
ENT.Nicknames = {
    "booze", "beer", "alcohol", "Bud Light", "Coors Light", "Miller Light",
    "shitty light beer", "frat juice", "water"
}
ENT.OverdosePhrase = {"drank too much", "got poisoned on", "discovered that the turnup is real while drinking", "YOLOed on", "Philliped"}
ENT.Author = "Phillip Penrose"
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Information	 = "Drink your troubles away... Just kidding, this is light beer. You won't even get a buzz." 

ENT.TRANSITION_TIME = 6


ENT.WorldModel = "models/drug_mod/alcohol_can.mdl"

if(CLIENT)then
	
	
	killicon.Add("durgz_alcohol","killicons/durgz_alcohol_killicon",Color( 255, 80, 0, 255 ))
	
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 1; --1 is max, 0 is nothing at all
	
	
	local function DoAlcohol()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNWFloat( "SprintSpeed"
		local pl = LocalPlayer();
		
		
		
		if( pl:GetNWFloat("durgz_alcohol_high_start") && pl:GetNWFloat("durgz_alcohol_high_end") > CurTime() )then
		
			if( pl:GetNWFloat("durgz_alcohol_high_start") + TRANSITION_TIME > CurTime() )then
			
				local s = pl:GetNWFloat("durgz_alcohol_high_start");
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				local pf = (c-s) / (e-s);
				
				DrawMotionBlur( 0.03, pf*HIGH_INTENSITY, 0);
				
			elseif( pl:GetNWFloat("durgz_alcohol_high_end") - TRANSITION_TIME < CurTime() )then
			
				local e = pl:GetNWFloat("durgz_alcohol_high_end");
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				local pf = 1 - (c-s) / (e-s);
				
				DrawMotionBlur( 0.03, pf*HIGH_INTENSITY, 0);
				
			else
				
				DrawMotionBlur( 0.03, HIGH_INTENSITY, 0);
				
			end
			
			
		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_alcohol_high", DoAlcohol)
	
end
