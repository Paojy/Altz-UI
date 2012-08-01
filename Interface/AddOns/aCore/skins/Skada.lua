if not IsAddOnLoaded("Skada") then return end
--====================================================--
--[[                 -- Skada --                    ]]--
--====================================================--
local Skada = Skada
local barmod = Skada.displays["bar"]
local blank = "Interface\\AddOns\\aCore\\media\\statusbar"

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
barmod.ApplySettings_(self, win)
	
	local skada = win.bargroup

	skada:SetTexture(blank)
	skada:SetSpacing(1, 1)
	skada:SetFont(font, 10)
	skada:SetFrameLevel(5)
	
	skada:SetBackdrop(nil)
	if not skada.border then
		creategrowBD(skada, 0, 0, 0, 0.3, 1)
		skada.border:ClearAllPoints()
		skada.border:SetPoint('TOPLEFT', win.bargroup.button or win.bargroup, 'TOPLEFT', -3, 3)
		skada.border:SetPoint('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT', 3, -3)
	end
end

for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end
