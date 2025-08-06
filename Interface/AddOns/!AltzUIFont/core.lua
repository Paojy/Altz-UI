local f = CreateFrame("Frame", "AltzUIFont", UIParent)
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)	
	if addon == "AuroraClassic" then
		local _, _, _, C = unpack(AuroraClassic)
		if GetLocale() == "ruRU" then
			C.Font[1] =  "Interface\\AddOns\\AltzUI\\media\\fonts\\narrowfont.ttf"
		else
			C.Font[1] =  "Interface\\AddOns\\AltzUI\\media\\fonts\\font.ttf"
		end
	end
end)