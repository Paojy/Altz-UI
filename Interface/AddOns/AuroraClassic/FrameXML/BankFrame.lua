local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraClassicDB.Bags then return end

	-- [[ Bank ]]

	BankSlotsFrame:DisableDrawLayer("BORDER")
	BankPortraitTexture:Hide()
	BankFrameMoneyFrameInset:Hide()
	BankFrameMoneyFrameBorder:Hide()

	-- "item slots" and "bag slots" text
	select(9, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY")
	select(10, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY")

	F.ReskinPortraitFrame(BankFrame)
	F.Reskin(BankFramePurchaseButton)
	F.ReskinTab(BankFrameTab1)
	F.ReskinTab(BankFrameTab2)
	F.ReskinInput(BankItemSearchBox)

	local function styleBankButton(bu)
		local border = bu.IconBorder
		local questTexture = bu.IconQuestTexture
		local searchOverlay = bu.searchOverlay

		questTexture:SetDrawLayer("BACKGROUND")
		questTexture:SetSize(1, 1)

		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -C.mult, C.mult)
		border:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
		border:SetDrawLayer("BACKGROUND", 1)

		searchOverlay:SetPoint("TOPLEFT", -C.mult, C.mult)
		searchOverlay:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bu, .25)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		local bag = BankSlotsFrame["Bag"..i]
		local border = bag.IconBorder
		local searchOverlay = bag.searchOverlay

		bag:SetNormalTexture("")
		bag:SetPushedTexture("")
		bag:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bag.SlotHighlightTexture:SetTexture(C.media.checked)

		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -C.mult, C.mult)
		border:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
		border:SetDrawLayer("BACKGROUND", 1)

		searchOverlay:SetPoint("TOPLEFT", -C.mult, C.mult)
		searchOverlay:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)

		bag.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(bag, .25)
	end

	BankItemAutoSortButton:GetNormalTexture():SetTexCoord(.17, .83, .17, .83)
	BankItemAutoSortButton:GetPushedTexture():SetTexCoord(.17, .83, .17, .83)
	F.CreateBDFrame(BankItemAutoSortButton)
	local highlight = BankItemAutoSortButton:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetAllPoints(BankItemAutoSortButton)

	hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button.IconBorder:SetVertexColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]

	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")

	F.Reskin(ReagentBankFrame.DespositButton)
	F.Reskin(ReagentBankFrameUnlockInfoPurchaseButton)

	-- make button more visible
	F.StripTextures(ReagentBankFrameUnlockInfo)
	ReagentBankFrameUnlockInfoBlackBG:SetColorTexture(.1, .1, .1)

	local reagentButtonsStyled = false
	ReagentBankFrame:HookScript("OnShow", function()
		if not reagentButtonsStyled then
			for i = 1, 98 do
				styleBankButton(_G["ReagentBankFrameItem"..i])
			end
			reagentButtonsStyled = true
		end
	end)
end)