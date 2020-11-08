local _, ns = ...
local F, C = unpack(ns)

local function reskinSubscribeButton(button)
	F.CreateBDFrame(button, .25)
	button.ButtonText:SetTextColor(1, .8, 0)
end

C.themes["Blizzard_SubscriptionInterstitialUI"] = function()
	local frame = SubscriptionInterstitialFrame

	F.StripTextures(frame)
	frame.ShadowOverlay:Hide()
	F.SetBD(frame)
	F.Reskin(frame.ClosePanelButton)
	F.ReskinClose(frame.CloseButton)

	reskinSubscribeButton(frame.UpgradeButton)
	reskinSubscribeButton(frame.SubscribeButton)
end