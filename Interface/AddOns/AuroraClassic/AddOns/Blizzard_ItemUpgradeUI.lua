local _, ns = ...
local F, C = unpack(ns)

local function reskinCurrencyIcon(self)
	for frame in self.iconPool:EnumerateActive() do
		if not frame.bg then
			frame.bg = F.ReskinIcon(frame.Icon)
			frame.bg:SetFrameLevel(2)
		end
	end
end

C.themes["Blizzard_ItemUpgradeUI"] = function()
	local ItemUpgradeFrame = ItemUpgradeFrame
	F.ReskinPortraitFrame(ItemUpgradeFrame)

	hooksecurefunc(ItemUpgradeFrame, "Update", function(self)
		if self.upgradeInfo then
			self.UpgradeItemButton:SetPushedTexture(nil)
		end
	end)
	local bg = F.CreateBDFrame(ItemUpgradeFrame, .25)
	bg:SetPoint("TOPLEFT", 20, -25)
	bg:SetPoint("BOTTOMRIGHT", -20, 375)

	local itemButton = ItemUpgradeFrame.UpgradeItemButton
	itemButton.ButtonFrame:Hide()
	itemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	itemButton.bg = F.ReskinIcon(itemButton.icon)
	F.ReskinIconBorder(itemButton.IconBorder)

	F.ReskinDropDown(ItemUpgradeFrame.ItemInfo.Dropdown)
	F.Reskin(ItemUpgradeFrame.UpgradeButton)
	ItemUpgradeFramePlayerCurrenciesBorder:Hide()

	F.CreateBDFrame(ItemUpgradeFrameLeftItemPreviewFrame, .25)
	ItemUpgradeFrameLeftItemPreviewFrame.NineSlice:SetAlpha(0)
	F.CreateBDFrame(ItemUpgradeFrameRightItemPreviewFrame, .25)
	ItemUpgradeFrameRightItemPreviewFrame.NineSlice:SetAlpha(0)

	hooksecurefunc(ItemUpgradeFrame.UpgradeCostFrame, "GetIconFrame", reskinCurrencyIcon)
	hooksecurefunc(ItemUpgradeFrame.PlayerCurrencies, "GetIconFrame", reskinCurrencyIcon)
end