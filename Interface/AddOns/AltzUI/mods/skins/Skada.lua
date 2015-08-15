local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
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
	skada:SetFont(font, 10)
	skada:SetFrameLevel(5)
	
	skada:SetBackdrop(nil)
	if not skada.border then
		skada.border = F.CreateBDFrame(skada, 0.3)
		skada.border:ClearAllPoints()
		skada.border:SetPoint('TOPLEFT', win.bargroup.button or win.bargroup, 'TOPLEFT')
		skada.border:SetPoint('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT')
		skada.border:SetBackdrop(nil)
		F.SetBD(skada.border)
	end
end

for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end
