local _, ns = ...
local F, C = unpack(ns)
local r, g, b = C.r, C.g, C.b

local function reskinPickerOptions(self)
	local scrollTarget = self.ScrollBox.ScrollTarget
	if scrollTarget then
		for i = 1, scrollTarget:GetNumChildren() do
			local child = select(i, scrollTarget:GetChildren())
			if not child.styled then
				child.UnCheck:SetTexture(nil)
				child.Highlight:SetColorTexture(r, g, b, .25)

				local check = child.Check
				check:SetColorTexture(r, g, b, .6)
				check:SetSize(10, 10)
				check:SetPoint("LEFT", 2, 0)
				F.CreateBDFrame(check, .25)

				child.styled = true
			end
		end
	end
end

local function ReskinVoicePicker(voicePicker)
	local customFrame = voicePicker:GetChildren()
	F.StripTextures(customFrame)
	F.SetBD(customFrame, .7)
	voicePicker:HookScript("OnShow", reskinPickerOptions)
end

tinsert(C.defaultThemes, function()
	F.StripTextures(ChatConfigFrame)
	F.SetBD(ChatConfigFrame)
	F.StripTextures(ChatConfigFrame.Header)

	hooksecurefunc("ChatConfig_UpdateCheckboxes", function(frame)
		if not FCF_GetCurrentChatFrame() then return end

		local nameString = frame:GetName().."CheckBox"
		for index in ipairs(frame.checkBoxTable) do
			local checkBoxName = nameString..index
			local checkbox = _G[checkBoxName]
			if checkbox and not checkbox.styled then
				checkbox:HideBackdrop()
				local bg = F.CreateBDFrame(checkbox, .25)
				bg:SetInside()
				F.ReskinCheck(_G[checkBoxName.."Check"])

				checkbox.styled = true
			end
		end
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
		if frame.styled then return end

		local nameString = frame:GetName().."CheckBox"
		for index, value in ipairs(checkBoxTable) do
			local checkBoxName = nameString..index
			F.ReskinCheck(_G[checkBoxName])

			if value.subTypes then
				for i in ipairs(value.subTypes) do
					F.ReskinCheck(_G[checkBoxName.."_"..i])
				end
			end
		end

		frame.styled = true
	end)

	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", function(self)
		for tab in self.tabPool:EnumerateActive() do
			if not tab.styled then
				F.StripTextures(tab)

				tab.styled = true
			end
		end
	end)

	for i = 1, 5 do
		F.StripTextures(_G["CombatConfigTab"..i])
	end

	local line = ChatConfigFrame:CreateTexture()
	line:SetSize(C.mult, 460)
	line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
	line:SetColorTexture(1, 1, 1, .25)

	local backdrops = {
		ChatConfigCategoryFrame,
		ChatConfigBackgroundFrame,
		ChatConfigCombatSettingsFilters,
		CombatConfigColorsHighlighting,
		CombatConfigColorsColorizeUnitName,
		CombatConfigColorsColorizeSpellNames,
		CombatConfigColorsColorizeDamageNumber,
		CombatConfigColorsColorizeDamageSchool,
		CombatConfigColorsColorizeEntireLine,
		ChatConfigChatSettingsLeft,
		ChatConfigOtherSettingsCombat,
		ChatConfigOtherSettingsPVP,
		ChatConfigOtherSettingsSystem,
		ChatConfigOtherSettingsCreature,
		ChatConfigChannelSettingsLeft,
		CombatConfigMessageSourcesDoneBy,
		CombatConfigColorsUnitColors,
		CombatConfigMessageSourcesDoneTo,
	}
	for _, frame in pairs(backdrops) do
		F.StripTextures(frame)
	end

	local combatBoxes = {
		CombatConfigColorsHighlightingLine,
		CombatConfigColorsHighlightingAbility,
		CombatConfigColorsHighlightingDamage,
		CombatConfigColorsHighlightingSchool,
		CombatConfigColorsColorizeUnitNameCheck,
		CombatConfigColorsColorizeSpellNamesCheck,
		CombatConfigColorsColorizeSpellNamesSchoolColoring,
		CombatConfigColorsColorizeDamageNumberCheck,
		CombatConfigColorsColorizeDamageNumberSchoolColoring,
		CombatConfigColorsColorizeDamageSchoolCheck,
		CombatConfigColorsColorizeEntireLineCheck,
		CombatConfigFormattingShowTimeStamp,
		CombatConfigFormattingShowBraces,
		CombatConfigFormattingUnitNames,
		CombatConfigFormattingSpellNames,
		CombatConfigFormattingItemNames,
		CombatConfigFormattingFullText,
		CombatConfigSettingsShowQuickButton,
		CombatConfigSettingsSolo,
		CombatConfigSettingsParty,
		CombatConfigSettingsRaid
	}
	for _, box in pairs(combatBoxes) do
		F.ReskinCheck(box)
	end

	local bg = F.CreateBDFrame(ChatConfigCombatSettingsFilters, .25)
	bg:SetPoint("TOPLEFT", 3, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 1)

	F.Reskin(CombatLogDefaultButton)
	F.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
	F.Reskin(CombatConfigSettingsSaveButton)
	F.Reskin(ChatConfigFrameOkayButton)
	F.Reskin(ChatConfigFrameDefaultButton)
	F.Reskin(ChatConfigFrameRedockButton)
	F.Reskin(ChatConfigFrame.ToggleChatButton)
	F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")
	F.ReskinInput(CombatConfigSettingsNameEditBox)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	F.ReskinColorSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	F.ReskinColorSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)
	F.ReskinScroll(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)

	ChatConfigMoveFilterUpButton:SetSize(22, 22)
	ChatConfigMoveFilterDownButton:SetSize(22, 22)

	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
	ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)

	-- TextToSpeech
	F.StripTextures(TextToSpeechButton, 5)

	F.Reskin(TextToSpeechFramePlaySampleButton)
	F.Reskin(TextToSpeechFramePlaySampleAlternateButton)
	F.Reskin(TextToSpeechDefaultButton)
	F.ReskinCheck(TextToSpeechCharacterSpecificButton)

	F.ReskinDropDown(TextToSpeechFrameTtsVoiceDropdown)
	F.ReskinDropDown(TextToSpeechFrameTtsVoiceAlternateDropdown)
	F.ReskinSlider(TextToSpeechFrameAdjustRateSlider)
	F.ReskinSlider(TextToSpeechFrameAdjustVolumeSlider)

	local checkboxes = {
		"PlayActivitySoundWhenNotFocusedCheckButton",
		"PlaySoundSeparatingChatLinesCheckButton",
		"AddCharacterNameToSpeechCheckButton",
		"NarrateMyMessagesCheckButton",
		"UseAlternateVoiceForSystemMessagesCheckButton",
	}
	for _, checkbox in pairs(checkboxes) do
		F.ReskinCheck(TextToSpeechFramePanelContainer[checkbox])
	end

	hooksecurefunc("TextToSpeechFrame_UpdateMessageCheckboxes", function(frame)
		local checkBoxTable = frame.checkBoxTable
		if checkBoxTable then
			local checkBoxNameString = frame:GetName().."CheckBox"
			local checkBoxName, checkBox
			for index, value in ipairs(checkBoxTable) do
				checkBoxName = checkBoxNameString..index
				checkBox = _G[checkBoxName]
				if checkBox and not checkBox.styled then
					F.ReskinCheck(checkBox)
					checkBox.styled = true
				end
			end
		end
	end)

	-- voice pickers
	ReskinVoicePicker(TextToSpeechFrameTtsVoicePicker)
	ReskinVoicePicker(TextToSpeechFrameTtsVoiceAlternatePicker)

	F.StripTextures(ChatConfigTextToSpeechChannelSettingsLeft)
end)