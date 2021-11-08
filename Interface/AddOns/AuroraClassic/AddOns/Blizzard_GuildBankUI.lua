local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_GuildBankUI"] = function()
	F.StripTextures(GuildBankFrame)
	F.ReskinPortraitFrame(GuildBankFrame)

	GuildBankFrame.Emblem:Hide()
	GuildBankFrame.MoneyFrameBG:Hide()
	F.Reskin(GuildBankFrame.WithdrawButton)
	F.Reskin(GuildBankFrame.DepositButton)
	F.ReskinScroll(GuildBankTransactionsScrollFrameScrollBar)
	F.ReskinScroll(GuildBankInfoScrollFrameScrollBar)
	F.Reskin(GuildBankFrame.BuyInfo.PurchaseButton)
	F.Reskin(GuildBankFrame.Info.SaveButton)
	F.ReskinInput(GuildItemSearchBox)

	GuildBankFrame.WithdrawButton:SetPoint("RIGHT", GuildBankFrame.DepositButton, "LEFT", -2, 0)

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]
		F.ReskinTab(tab)

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	for i = 1, 7 do
		local column = GuildBankFrame.Columns[i]
		column:GetRegions():Hide()

		for j = 1, 14 do
			local button = column.Buttons[j]
			button:SetNormalTexture("")
			button:SetPushedTexture("")
			button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			button.icon:SetTexCoord(unpack(C.TexCoord))
			button.bg = F.CreateBDFrame(button, .3)
			button.bg:SetBackdropColor(.3, .3, .3, .3)
			button.searchOverlay:SetOutside()
			F.ReskinIconBorder(button.IconBorder)
		end
	end

	for i = 1, 8 do
		local tab = _G["GuildBankTab"..i]
		local button = tab.Button
		local icon = button.IconTexture

		F.StripTextures(tab)
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button:SetCheckedTexture(C.pushed)
		F.CreateBDFrame(button)
		icon:SetTexCoord(unpack(C.TexCoord))

		local a1, p, a2, x, y = button:GetPoint()
		button:SetPoint(a1, p, a2, x + C.mult, y)
	end

	local NUM_GUILDBANK_ICONS_PER_ROW = 10
	local NUM_GUILDBANK_ICON_ROWS = 9

	GuildBankPopupFrame.BorderBox:Hide()
	GuildBankPopupFrame.BG:Hide()
	F.SetBD(GuildBankPopupFrame)
	GuildBankPopupEditBox:DisableDrawLayer("BACKGROUND")
	F.ReskinInput(GuildBankPopupEditBox)
	GuildBankPopupFrame:SetHeight(525)
	F.Reskin(GuildBankPopupFrame.OkayButton)
	F.Reskin(GuildBankPopupFrame.CancelButton)
	F.ReskinScroll(GuildBankPopupFrame.ScrollFrame.ScrollBar)

	GuildBankPopupFrame:HookScript("OnShow", function()
		for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
			local button = _G["GuildBankPopupButton"..i]
			if not button.styled then
				button:SetCheckedTexture(C.pushed)
				select(2, button:GetRegions()):Hide()
				F.ReskinIcon(button.Icon)
				local hl = button:GetHighlightTexture()
				hl:SetColorTexture(1, 1, 1, .25)
				hl:SetAllPoints(button.Icon)

				button.styled = true
			end
		end
	end)
end