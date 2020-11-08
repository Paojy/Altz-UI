local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	SendMailMoneyInset:DisableDrawLayer("BORDER")
	InboxFrame:GetRegions():Hide()
	SendMailMoneyBg:Hide()
	SendMailMoneyInset:Hide()
	OpenMailFrameIcon:Hide()
	OpenMailHorizontalBarLeft:Hide()
	F.StripTextures(SendMailFrame)
	OpenStationeryBackgroundLeft:Hide()
	OpenStationeryBackgroundRight:Hide()
	SendStationeryBackgroundLeft:Hide()
	SendStationeryBackgroundRight:Hide()
	InboxPrevPageButton:GetRegions():Hide()
	InboxNextPageButton:GetRegions():Hide()
	InboxTitleText:SetPoint("CENTER", MailFrame, 0, 195)

	F.ReskinPortraitFrame(MailFrame)
	F.ReskinPortraitFrame(OpenMailFrame)
	F.Reskin(SendMailMailButton)
	F.Reskin(SendMailCancelButton)
	F.Reskin(OpenMailReplyButton)
	F.Reskin(OpenMailDeleteButton)
	F.Reskin(OpenMailCancelButton)
	F.Reskin(OpenMailReportSpamButton)
	F.Reskin(OpenAllMail)
	F.ReskinInput(SendMailNameEditBox, 20)
	F.ReskinInput(SendMailSubjectEditBox)
	F.ReskinInput(SendMailMoneyGold)
	F.ReskinInput(SendMailMoneySilver)
	F.ReskinInput(SendMailMoneyCopper)
	F.ReskinScroll(SendMailScrollFrameScrollBar)
	F.ReskinScroll(OpenMailScrollFrameScrollBar)
	F.ReskinRadio(SendMailSendMoneyButton)
	F.ReskinRadio(SendMailCODButton)
	F.ReskinArrow(InboxPrevPageButton, "left")
	F.ReskinArrow(InboxNextPageButton, "right")

	SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

	SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)

	OpenMailLetterButton:SetNormalTexture("")
	OpenMailLetterButton:SetPushedTexture("")
	OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(OpenMailLetterButton)

	for i = 1, 2 do
		F.ReskinTab(_G["MailFrameTab"..i])
	end

	OpenMailMoneyButton:SetNormalTexture("")
	OpenMailMoneyButton:SetPushedTexture("")
	OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(OpenMailMoneyButton)

	SendMailSubjectEditBox:SetPoint("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local it = _G["MailItem"..i]
		local bu = _G["MailItem"..i.."Button"]
		local st = _G["MailItem"..i.."ButtonSlot"]
		local ic = _G["MailItem"..i.."Button".."Icon"]
		local bd = _G["MailItem"..i.."Button".."IconBorder"]
		local line = select(3, _G["MailItem"..i]:GetRegions())

		local a, b = it:GetRegions()
		a:Hide()
		b:Hide()
		bu:SetCheckedTexture(C.media.checked)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		st:Hide()
		line:Hide()
		ic:SetTexCoord(.08, .92, .08, .92)
		bd:SetAlpha(0)
		F.CreateBDFrame(bu)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local bu = _G["SendMailAttachment"..i]
		local border = bu.IconBorder

		bu:GetRegions():Hide()
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		border:SetPoint("TOPLEFT", -C.mult, C.mult)
		border:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
		border:SetDrawLayer("BACKGROUND")
		F.CreateBDFrame(bu, .25)
	end

	-- sigh
	-- we mess with quality colour numbers, so we have to fix this
	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local bu = _G["SendMailAttachment"..i]

			if bu:GetNormalTexture() == nil and bu.IconBorder:IsShown() then
				bu.IconBorder:Hide()
			end
		end
	end)

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local bu = _G["OpenMailAttachmentButton"..i]
		local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]
		local border = bu.IconBorder

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		ic:SetTexCoord(.08, .92, .08, .92)

		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -C.mult, C.mult)
		border:SetPoint("BOTTOMRIGHT", C.mult, -C.mult)
		border:SetDrawLayer("BACKGROUND")
		F.CreateBDFrame(bu, .25)
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			button.IconBorder:SetTexture(C.media.backdrop)
			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	MailFont_Large:SetTextColor(1, 1, 1)
	MailFont_Large:SetShadowColor(0, 0, 0)
	MailFont_Large:SetShadowOffset(1, -1)
	MailTextFontNormal:SetTextColor(1, 1, 1)
	MailTextFontNormal:SetShadowOffset(1, -1)
	MailTextFontNormal:SetShadowColor(0, 0, 0)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
end)