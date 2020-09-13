local _, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraClassicDB.FontOutline then return end

	local function ReskinFont(font, size, white)
		local oldSize = select(2, font:GetFont())
		size = size or oldSize
		local fontSize = size*AuroraClassicDB.FontScale
		font:SetFont(C.media.font, fontSize, white and "" or "OUTLINE")
		font:SetShadowColor(0, 0, 0, 0)
	end

	ReskinFont(RaidWarningFrame.slot1)
	ReskinFont(RaidWarningFrame.slot2)
	ReskinFont(RaidBossEmoteFrame.slot1)
	ReskinFont(RaidBossEmoteFrame.slot2)
	ReskinFont(AchievementFont_Small)
	ReskinFont(AchievementCriteriaFont)
	ReskinFont(AchievementDescriptionFont)
	ReskinFont(CoreAbilityFont)
	ReskinFont(DestinyFontMed)
	ReskinFont(DestinyFontHuge)
	ReskinFont(DestinyFontLarge)
	ReskinFont(FriendsFont_Normal)
	ReskinFont(FriendsFont_Small)
	ReskinFont(FriendsFont_Large)
	ReskinFont(FriendsFont_UserText)
	ReskinFont(FriendsFont_11)
	ReskinFont(GameFont_Gigantic)
	ReskinFont(GameTooltipHeader)
	ReskinFont(InvoiceFont_Small)
	ReskinFont(InvoiceFont_Med)
	ReskinFont(MailFont_Large)
	ReskinFont(NumberFont_Small)
	ReskinFont(NumberFont_GameNormal)
	ReskinFont(NumberFont_Normal_Med)
	ReskinFont(NumberFont_Shadow_Tiny)
	ReskinFont(NumberFont_OutlineThick_Mono_Small)
	ReskinFont(NumberFont_Outline_Med)
	ReskinFont(NumberFont_Outline_Large)
	ReskinFont(NumberFont_Shadow_Med)
	ReskinFont(NumberFont_Shadow_Small)
	ReskinFont(Number12Font, 12)
	ReskinFont(Number13FontYellow)
	ReskinFont(Number13FontWhite)
	ReskinFont(Number13FontGray)
	ReskinFont(Number14FontWhite)
	ReskinFont(Number15FontWhite)
	ReskinFont(Number18FontWhite)
	ReskinFont(QuestFont_Shadow_Small)
	ReskinFont(QuestFont_Large)
	ReskinFont(QuestFont_Shadow_Huge)
	ReskinFont(QuestFont_Huge)
	ReskinFont(QuestFont_Super_Huge)
	ReskinFont(QuestFont_Enormous)
	ReskinFont(ReputationDetailFont)
	ReskinFont(SpellFont_Small)
	ReskinFont(SystemFont_InverseShadow_Small)
	ReskinFont(SystemFont_Large)
	ReskinFont(SystemFont_Huge1)
	ReskinFont(SystemFont_Huge2)
	ReskinFont(SystemFont_Med1)
	ReskinFont(SystemFont_Med2)
	ReskinFont(SystemFont_Med3)
	ReskinFont(SystemFont_OutlineThick_WTF)
	ReskinFont(SystemFont_OutlineThick_Huge2)
	ReskinFont(SystemFont_OutlineThick_Huge4)
	ReskinFont(SystemFont_Outline_Small)
	ReskinFont(SystemFont_Outline)
	ReskinFont(SystemFont_Shadow_Large)
	ReskinFont(SystemFont_Shadow_Large_Outline)
	ReskinFont(SystemFont_Shadow_Large2)
	ReskinFont(SystemFont_Shadow_Med1)
	ReskinFont(SystemFont_Shadow_Med1_Outline)
	ReskinFont(SystemFont_Shadow_Med2)
	ReskinFont(SystemFont_Shadow_Med3)
	ReskinFont(SystemFont_Shadow_Outline_Huge2)
	ReskinFont(SystemFont_Shadow_Huge1)
	ReskinFont(SystemFont_Shadow_Huge2)
	ReskinFont(SystemFont_Shadow_Huge3)
	ReskinFont(SystemFont_Shadow_Small)
	ReskinFont(SystemFont_Shadow_Small2)
	ReskinFont(SystemFont_Small)
	ReskinFont(SystemFont_Small2)
	ReskinFont(SystemFont_Tiny)
	ReskinFont(SystemFont_Tiny2)
	ReskinFont(SystemFont_NamePlate, 12)
	ReskinFont(SystemFont_LargeNamePlate, 12)
	ReskinFont(SystemFont_NamePlateFixed, 12)
	ReskinFont(SystemFont_LargeNamePlateFixed, 12)
	ReskinFont(SystemFont_World, 64)
	ReskinFont(SystemFont_World_ThickOutline, 64)
	ReskinFont(SystemFont_WTF2, 64)
	ReskinFont(Tooltip_Med)
	ReskinFont(Tooltip_Small)
	ReskinFont(HelpFrameKnowledgebaseNavBarHomeButtonText)
	ReskinFont(Game11Font)
	ReskinFont(Game12Font)
	ReskinFont(Game13Font)
	ReskinFont(Game13FontShadow)
	ReskinFont(Game15Font)
	ReskinFont(Game16Font)
	ReskinFont(Game18Font)
	ReskinFont(Game20Font)
	ReskinFont(Game24Font)
	ReskinFont(Game27Font)
	ReskinFont(Game30Font)
	ReskinFont(Game32Font)
	ReskinFont(Game36Font)
	ReskinFont(Game42Font)
	ReskinFont(Game46Font)
	ReskinFont(Game48Font)
	ReskinFont(Game48FontShadow)
	ReskinFont(Game60Font)
	ReskinFont(Game72Font)
	ReskinFont(Game120Font)
	ReskinFont(System_IME)
	ReskinFont(Fancy12Font)
	ReskinFont(Fancy14Font)
	ReskinFont(Fancy16Font)
	ReskinFont(Fancy18Font)
	ReskinFont(Fancy20Font)
	ReskinFont(Fancy22Font)
	ReskinFont(Fancy24Font)
	ReskinFont(Fancy27Font)
	ReskinFont(Fancy30Font)
	ReskinFont(Fancy32Font)
	ReskinFont(Fancy48Font)
	ReskinFont(SplashHeaderFont)
	ReskinFont(ChatBubbleFont, 13)
	ReskinFont(GameFontNormalHuge2)
	ReskinFont(PriceFont)
	ReskinFont(PriceFontWhite)
	ReskinFont(PriceFontGray)
	ReskinFont(PriceFontGreen)
	ReskinFont(PriceFontRed)

	-- Refont RaidFrame Health
	hooksecurefunc("CompactUnitFrame_UpdateStatusText", function(frame)
		if frame:IsForbidden() then return end
		if not frame.statusText then return end

		local options = DefaultCompactUnitFrameSetupOptions
		frame.statusText:ClearAllPoints()
		frame.statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, options.height/3 - 5)
		frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, options.height/3 - 5)

		if not frame.fontStyled then
			local fontName, fontSize = frame.statusText:GetFont()
			frame.statusText:SetFont(fontName, fontSize, "OUTLINE")
			frame.statusText:SetTextColor(.7, .7, .7)
			frame.statusText:SetShadowColor(0, 0, 0, 0)
			frame.fontStyled = true
		end
	end)

	-- Refont Titles Panel
	hooksecurefunc("PaperDollTitlesPane_UpdateScrollFrame", function()
		local bu = PaperDollTitlesPane.buttons
		for i = 1, #bu do
			if not bu[i].fontStyled then
				ReskinFont(bu[i].text, 14)
				bu[i].fontStyled = true
			end
		end
	end)

	-- WhoFrame LevelText
	hooksecurefunc("WhoList_Update", function()
		local buttons = WhoListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			local level = button.Level
			if level and not level.fontStyled then
				level:SetWidth(32)
				level:SetJustifyH("LEFT")
				level.fontStyled = true
			end
		end
	end)

	-- Text color
	GameFontBlackMedium:SetTextColor(1, 1, 1)
	CoreAbilityFont:SetTextColor(1, 1, 1)
end)