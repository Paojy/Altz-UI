local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local font = GameFontHighlight:GetFont()

local SetupPanel = CreateFrame("Frame", "Altzsetuppanel", WorldFrame)
SetupPanel:SetFrameStrata("FULLSCREEN")
F.CreateBD(SetupPanel, .5)
SetupPanel:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT", -5, 5)
SetupPanel:SetPoint("BOTTOMRIGHT",WorldFrame,"BOTTOMRIGHT", 5, -5)
SetupPanel:Hide()

SetupPanel.text = SetupPanel:CreateFontString(nil, "OVERLAY")
SetupPanel.text:SetFont(font, 15, "NONE")
SetupPanel.text:SetJustifyH("CENTER")
SetupPanel.text:SetPoint("TOP", SetupPanel, "BOTTOM", 0, 75)
SetupPanel.text:SetTextColor(1, 1, 1)
SetupPanel.text:SetText("ver"..G.Version.." "..L["Paopao <Purgatory> CN5_Abyssion's Lair"])

SetupPanel.text2 = SetupPanel:CreateFontString(nil, "OVERLAY")
SetupPanel.text2:SetFont(font, 35, "NONE")
SetupPanel.text2:SetJustifyH("CENTER")
SetupPanel.text2:SetPoint("BOTTOM", 0, 110)
SetupPanel.text2:SetTextColor(1, 1, 1)
SetupPanel.text2:SetText(L["Welcome to Altz UI Setup"])

local Setupbutton = CreateFrame("Button", "AltzuiSetupButton", SetupPanel, "UIPanelButtonTemplate")
Setupbutton:SetPoint("BOTTOM", 0, 80)
Setupbutton:SetSize(UIParent:GetWidth()+10, 25)
F.Reskin(Setupbutton)
Setupbutton.text = Setupbutton:CreateFontString(nil, "OVERLAY")
Setupbutton.text:SetFont(font, 20, "NONE")
Setupbutton.text:SetJustifyH("CENTER")
Setupbutton.text:SetAllPoints()
Setupbutton.text:SetTextColor(0.5, 0.5, 0.5, .1)
Setupbutton.text:SetText(L["Install"])
Setupbutton:Hide()

Setupbutton:SetScript("OnClick", function()
	T.SetChatFrame()
	T.ResetAllAddonSettings()
	aCoreCDB.notmeet = false
	ReloadUI()
end)

Setupbutton:HookScript("OnEnter", function() Setupbutton.text:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1) end)
Setupbutton:HookScript("OnLeave", function() Setupbutton.text:SetTextColor(0.5, 0.5, 0.5, .1) end)

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function() 
	if aCoreCDB.notmeet then
		UIParent:SetAlpha(0)
		SetupPanel:Show()
		Setupbutton:Show()
	end
end)
