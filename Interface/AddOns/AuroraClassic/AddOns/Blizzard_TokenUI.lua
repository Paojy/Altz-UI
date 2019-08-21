local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	TokenFramePopupCorner:Hide()
	TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
	F.StripTextures(TokenFramePopup)
	F.CreateBD(TokenFramePopup)
	F.CreateSD(TokenFramePopup)
	F.ReskinClose(TokenFramePopupCloseButton)
	F.ReskinCheck(TokenFramePopupInactiveCheckBox)
	F.ReskinCheck(TokenFramePopupBackpackCheckBox)

	local function updateButtons()
		local buttons = TokenFrameContainer.buttons
		if not buttons then return end

		for i = 1, #buttons do
			local bu = buttons[i]

			if not bu.styled then
				bu.highlight:SetPoint("TOPLEFT", 1, 0)
				bu.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
				bu.highlight.SetPoint = F.dummy
				bu.highlight:SetColorTexture(r, g, b, .2)
				bu.highlight.SetTexture = F.dummy

				bu.categoryMiddle:SetAlpha(0)
				bu.categoryLeft:SetAlpha(0)
				bu.categoryRight:SetAlpha(0)

				bu.icon:SetTexCoord(.08, .92, .08, .92)
				bu.bg = F.CreateBG(bu.icon)

				if bu.expandIcon then
					bu.expBg = F.CreateBDFrame(bu.expandIcon, .25)
					bu.expBg:SetPoint("TOPLEFT", bu.expandIcon, -3, 3)
					bu.expBg:SetPoint("BOTTOMRIGHT", bu.expandIcon, 3, -3)
					F.CreateGradient(bu.expBg)
				end

				bu.styled = true
			end

			if bu.isHeader then
				bu.bg:Hide()
				bu.expBg:Show()
			else
				bu.bg:Show()
				bu.expBg:Hide()
			end
		end
	end

	TokenFrame:HookScript("OnShow", updateButtons)
	hooksecurefunc("TokenFrame_Update", updateButtons)
	hooksecurefunc(TokenFrameContainer, "update", updateButtons)

	F.ReskinScroll(TokenFrameContainerScrollBar)
end)