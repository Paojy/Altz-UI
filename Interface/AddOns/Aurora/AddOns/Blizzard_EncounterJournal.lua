local F, C = unpack(select(2, ...))

C.themes["Blizzard_EncounterJournal"] = function()
	local r, g, b = C.r, C.g, C.b

	EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournal:DisableDrawLayer("BORDER")
	EncounterJournalInset:DisableDrawLayer("BORDER")
	EncounterJournal:DisableDrawLayer("OVERLAY")

	EncounterJournalPortrait:Hide()
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalBg:Hide()
	EncounterJournalTitleBg:Hide()
	EncounterJournalInsetBg:Hide()
	EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()
	
	EncounterJournalEncounterFrameInfoInstanceButton:Hide()
	EncounterJournalEncounterFrameInfoInstanceButton.Show = function() end
	
	select(5, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	EncounterJournalEncounterFrameInfoDifficulty.UpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficulty.UpRight:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficulty.DownLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficulty.DownRight:SetAlpha(0)
	
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.UpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.UpRight:SetAlpha(0)	
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.DownLeft:SetAlpha(0)	
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.DownRight:SetAlpha(0)	
	
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle:GetRegions()):Hide()
	EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle.UpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle.UpRight:SetAlpha(0)	
	EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle.DownLeft:SetAlpha(0)	
	EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle.DownRight:SetAlpha(0)	
	
	F.SetBD(EncounterJournal)

	-- [[ Dungeon / raid tabs ]]

	local function onEnable(self)
		self:SetHeight(self.storedHeight) -- prevent it from resizing
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function onDisable(self)
		self:SetBackdropColor(r, g, b, .2)
	end

	local function onClick(self)
		self:GetFontString():SetTextColor(1, 1, 1)
	end

	for _, tabName in pairs({"EncounterJournalInstanceSelectSuggestTab", "EncounterJournalInstanceSelectDungeonTab", "EncounterJournalInstanceSelectRaidTab", "EncounterJournalInstanceSelectLootJournalTab"}) do
		local tab = _G[tabName]
		local text = tab:GetFontString()

		tab:DisableDrawLayer("OVERLAY")

		tab.mid:Hide()
		tab.left:Hide()
		tab.right:Hide()

		tab.midHighlight:SetAlpha(0)
		tab.leftHighlight:SetAlpha(0)
		tab.rightHighlight:SetAlpha(0)

		tab:SetHeight(tab.storedHeight)
		tab.grayBox:GetRegions():SetAllPoints(tab)

		text:SetPoint("CENTER")
		text:SetTextColor(1, 1, 1)

		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)
		
		F.Reskin(tab)
	end
	
	for _, EJ_Button in pairs({EncounterJournal.LootJournal.LegendariesFrame.ClassButton, EncounterJournal.LootJournal.LegendariesFrame.SlotButton, EncounterJournal.LootJournal.ItemSetsFrame.ClassButton}) do
		EJ_Button.UpLeft:Hide()
		EJ_Button.UpLeft.Show = function() end
		EJ_Button.UpRight:Hide()
		EJ_Button.UpRight.Show = function() end
		EJ_Button.DownLeft:Hide()
		EJ_Button.DownLeft.Show = function() end
		EJ_Button.DownRight:Hide()
		EJ_Button.DownRight.Show = function() end
		EJ_Button.HighLeft:Hide()
		EJ_Button.HighRight:Hide()
		
		local text = EJ_Button:GetFontString()
		text:SetPoint("CENTER")
		text:SetTextColor(1, 1, 1)
		
		F.Reskin(EJ_Button)
	end
	
	EncounterJournalInstanceSelectSuggestTab:SetBackdropColor(r, g, b, .2)

	-- [[ Side tabs ]]

	EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoOverviewTab:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfo, "TOPRIGHT", 9, -35)
	EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoOverviewTab, "BOTTOM", 0, 1)
	EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoLootTab, "BOTTOM", 0, 1)

	local tabs = {EncounterJournalEncounterFrameInfoOverviewTab, EncounterJournalEncounterFrameInfoLootTab, EncounterJournalEncounterFrameInfoBossTab, EncounterJournalEncounterFrameInfoModelTab}
	for _, tab in pairs(tabs) do
		tab:SetScale(.75)

		tab:SetBackdrop({
			bgFile = C.media.backdrop,
			edgeFile = C.media.backdrop,
			edgeSize = 1 / .75,
		})

		tab:SetBackdropColor(0, 0, 0, .5)
		tab:SetBackdropBorderColor(0, 0, 0)

		tab:SetNormalTexture("")
		tab:SetPushedTexture("")
		tab:SetDisabledTexture("")
		tab:SetHighlightTexture("")
	end

	-- [[ Instance select ]]

	F.ReskinDropDown(EncounterJournalInstanceSelectTierDropDown)

	local index = 1

	local function listInstances()
		while true do
			local bu = EncounterJournal.instanceSelect.scroll.child["instance"..index]
			if not bu then return end

			bu:SetNormalTexture("")
			bu:SetHighlightTexture("")
			bu:SetPushedTexture("")

			bu.bgImage:SetDrawLayer("BACKGROUND", 1)

			local bg = F.CreateBG(bu.bgImage)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)

			index = index + 1
		end
	end

	hooksecurefunc("EncounterJournal_ListInstances", listInstances)
	listInstances()

	-- [[ Encounter frame ]]

	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")

	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

	F.CreateBDFrame(EncounterJournalEncounterFrameInfoModelFrame, .25)

	EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				F.Reskin(bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = F.dummy

				local hl = bossButton:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .2)
				hl:SetPoint("TOPLEFT", 2, -1)
				hl:SetPoint("BOTTOMRIGHT", 0, 1)

				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = EncounterJournalEncounterFrameInfoModelTab:GetPoint()
			EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 1)
		end)
	end

	hooksecurefunc("EncounterJournal_ToggleHeaders", function(self)
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				header.flashAnim.Play = F.dummy

				header.descriptionBG:SetAlpha(0)
				header.descriptionBGBottom:SetAlpha(0)
				for i = 4, 18 do
					select(i, header.button:GetRegions()):SetTexture("")
				end

				header.description:SetTextColor(1, 1, 1)
				header.button.title:SetTextColor(1, 1, 1)
				header.button.title.SetTextColor = F.dummy
				header.button.expandedIcon:SetTextColor(1, 1, 1)
				header.button.expandedIcon.SetTextColor = F.dummy

				F.Reskin(header.button)

				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
				header.button.bg = F.CreateBG(header.button.abilityIcon)

				header.styled = true
			end

			if header.button.abilityIcon:IsShown() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, role, index)
		local header = self.overviews[index]
		if not header.styled then
			header.flashAnim.Play = F.dummy

			header.descriptionBG:SetAlpha(0)
			header.descriptionBGBottom:SetAlpha(0)
			for i = 4, 18 do
				select(i, header.button:GetRegions()):SetTexture("")
			end

			header.button.title:SetTextColor(1, 1, 1)
			header.button.title.SetTextColor = F.dummy
			header.button.expandedIcon:SetTextColor(1, 1, 1)
			header.button.expandedIcon.SetTextColor = F.dummy

			F.Reskin(header.button)

			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object, description)
		local parent = object:GetParent()

		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor(1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	local items = EncounterJournal.encounter.info.lootScroll.buttons

	for i = 1, #items do
		local item = items[i]

		item.boss:SetTextColor(1, 1, 1)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)

		item.icon:SetPoint("TOPLEFT", 1, -1)

		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		F.CreateBG(item.icon)

		local bg = CreateFrame("Frame", nil, item)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(item:GetFrameLevel() - 1)
		F.CreateBD(bg, .25)
	end

	-- [[ Search results ]]

	EncounterJournalSearchResultsBg:Hide()
	for i = 3, 11 do
		select(i, EncounterJournalSearchResults:GetRegions()):Hide()
	end

	F.CreateBD(EncounterJournalSearchResults)
	EncounterJournalSearchResults:SetBackdropColor(.15, .15, .15, .9)

	EncounterJournal.searchBox.searchPreviewContainer.botLeftCorner:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.botRightCorner:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.bottomBorder:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.leftBorder:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.rightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local function styleSearchButton(result, index)
		if index == 1 then
			result:SetPoint("TOPLEFT", EncounterJournalSearchBox, "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", EncounterJournalSearchBox, "BOTTOMRIGHT", -5, 1)
		else
			result:SetPoint("TOPLEFT", EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMRIGHT", 0, 1)
		end

		result:SetNormalTexture("")
		result:SetPushedTexture("")
		result:SetHighlightTexture("")

		local hl = result:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(C.media.backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		result.hl = hl

		F.CreateBD(result)
		result:SetBackdropColor(.1, .1, .1, .9)

		if result.icon then
			result:GetRegions():Hide() -- icon frame

			result.icon:SetTexCoord(.08, .92, .08, .92)

			local bg = F.CreateBG(result.icon)
			bg:SetDrawLayer("BACKGROUND", 1)
		end

		result:HookScript("OnEnter", resultOnEnter)
		result:HookScript("OnLeave", resultOnLeave)
	end

	for i = 1, 5 do
		styleSearchButton(EncounterJournalSearchBox["sbutton"..i], i)
	end

	styleSearchButton(EncounterJournalSearchBox.showAllResults, 6)

	hooksecurefunc("EncounterJournal_SearchUpdate", function()
		local scrollFrame = EncounterJournal.searchResults.scrollFrame
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local results = scrollFrame.buttons
		local result, index

		local numResults = EJ_GetNumSearchResults()

		for i = 1, #results do
			result = results[i]
			index = offset + i

			if index <= numResults then
				if not result.styled then
					result:SetNormalTexture("")
					result:SetPushedTexture("")
					result:GetRegions():Hide()

					result.resultType:SetTextColor(1, 1, 1)
					result.path:SetTextColor(1, 1, 1)

					F.CreateBG(result.icon)

					result.styled = true
				end

				if result.icon:GetTexCoord() == 0 then
					result.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc(EncounterJournal.searchResults.scrollFrame, "update", function(self)
		for i = 1, #self.buttons do
			local result = self.buttons[i]

			if result.icon:GetTexCoord() == 0 then
				result.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	F.ReskinClose(EncounterJournalSearchResultsCloseButton)
	F.ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)

	-- [[ Various controls ]]

	F.Reskin(EncounterJournalEncounterFrameInfoDifficulty)
	F.Reskin(EncounterJournalEncounterFrameInfoResetButton)
	F.Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle)
	F.Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle)
	F.ReskinClose(EncounterJournalCloseButton)
	F.ReskinInput(EncounterJournalSearchBox)
	F.ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	F.ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)
	
	F.ReskinScroll2(EncounterJournal.LootJournal.ItemSetsFrame.ScrollBar)
	
	-- [[ Suggest frame ]]

	local suggestFrame = EncounterJournal.suggestFrame

	-- Tooltip

	local EncounterJournalTooltip = EncounterJournalTooltip

	F.CreateBD(EncounterJournalTooltip)

	EncounterJournalTooltip.Item1.newBg = F.ReskinIcon(EncounterJournalTooltip.Item1.icon)
	EncounterJournalTooltip.Item2.newBg = F.ReskinIcon(EncounterJournalTooltip.Item2.icon)

	local function rewardOnEnter()
		for i = 1, 2 do
			local item = EncounterJournalTooltip["Item"..i]
			if item:IsShown() then
				if item.IconBorder:IsShown() then
					item.newBg:SetVertexColor(item.IconBorder:GetVertexColor())
					item.IconBorder:Hide()
				else
					item.newBg:SetVertexColor(0, 0, 0)
				end
			end
		end
	end

	-- Suggestion 1

	local suggestion = suggestFrame.Suggestion1

	suggestion.bg:Hide()

	F.CreateBD(suggestion, .25)

	suggestion.icon:SetPoint("TOPLEFT", 135, -15)
	F.CreateBG(suggestion.icon)

	local centerDisplay = suggestion.centerDisplay

	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)

	F.Reskin(suggestion.button)

	local reward = suggestion.reward

	reward:HookScript("OnEnter", rewardOnEnter)
	reward.text:SetTextColor(.9, .9, .9)
	reward.iconRing:Hide()
	reward.iconRingHighlight:SetTexture("")
	F.CreateBG(reward.icon)

	F.ReskinArrow(suggestion.prevButton, "left")
	F.ReskinArrow(suggestion.nextButton, "right")

	-- Suggestion 2 and 3

	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]

		suggestion.bg:Hide()

		F.CreateBD(suggestion, .25)

		suggestion.icon:SetPoint("TOPLEFT", 10, -10)
		F.CreateBG(suggestion.icon)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)

		F.Reskin(centerDisplay.button)

		local reward = suggestion.reward

		reward:HookScript("OnEnter", rewardOnEnter)
		reward.iconRing:Hide()
		reward.iconRingHighlight:SetTexture("")
		F.CreateBG(reward.icon)
	end

	-- Hook functions

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]

			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask(nil)
				suggestion.icon:SetTexture(data.iconPath)
				suggestion.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then break end

				local data = self.suggestions[i]

				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask(nil)
					suggestion.icon:SetTexture(data.iconPath)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		local rewardData = suggestion.reward.data
		if rewardData then
			local texture = rewardData.itemIcon or rewardData.currencyIcon or [[Interface\Icons\achievement_guildperk_mobilebanking]]
			suggestion.reward.icon:SetMask("")
			suggestion.reward.icon:SetTexture(texture)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)
	
	local bg = EncounterJournal.LootJournal:GetRegions()
	bg:Hide()
	
	F.ReskinDropDown(LootJournalViewDropDown)
	
	for k, bu in pairs(EncounterJournal.LootJournal.LegendariesFrame.buttons) do
		bu.Background:Hide()
		F.Reskin(bu)
		F.CreateBG(bu.Icon)
		bu.Icon:SetDrawLayer("ARTWORK")
	end
	for k, bu in pairs(EncounterJournal.LootJournal.LegendariesFrame.rightSideButtons) do
		bu.Background:Hide()
		F.Reskin(bu)
		F.CreateBG(bu.Icon)
		bu.Icon:SetDrawLayer("ARTWORK")
	end
	
	-- ItemSetsFrame

	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "UpdateList", function()
		local itemSets = EncounterJournal.LootJournal.ItemSetsFrame.buttons
		for i = 1, #itemSets do
			local itemSet = itemSets[i]
			itemSet.ItemLevel:SetTextColor(1, 1, 1)
			itemSet.Background:Hide()

			if not itemSet.bg then
				itemSet.bg = F.CreateBDFrame(itemSet, .25)
			end

			local items = itemSet.ItemButtons
			for j = 1, #items do
				local item = items[j]
				item.Border:Hide()
				item.Icon:SetPoint("TOPLEFT", 1, -1)
				item.Icon:SetTexCoord(.08, .92, .08, .92)
				item.Icon:SetDrawLayer("OVERLAY")
				F.CreateBG(item.Icon)
			end
		end
	end)
end
