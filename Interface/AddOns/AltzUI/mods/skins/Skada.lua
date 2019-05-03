local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)
if not IsAddOnLoaded("Skada") or not aCoreCDB["SkinOptions"]["setSkada"] then return end

local Skada = Skada
local barmod = Skada.displays["bar"]
local blank = "Interface\\AddOns\\AltzUI\\media\\statusbar"

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
	barmod.ApplySettings_(self, win)
	
	local skada = win.bargroup

	skada:SetTexture(blank)
	skada:SetSpacing(1, 1)
	skada:SetFont(G.norFont, 12, "NONE")
	
	skada:SetBackdrop(nil)
	skada.borderFrame:SetBackdrop(nil)
	
	if not skada.border then
		skada.border = CreateFrame("Frame", G.uiname..skada:GetName().."Skin", skada)
		skada.border:SetPoint("TOPLEFT", skada, "TOPLEFT", -1, 1)
		skada.border:SetPoint("BOTTOMRIGHT", skada, "BOTTOMRIGHT", 1, -1)
		F.SetBD(skada.border)
	end
end

for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end
