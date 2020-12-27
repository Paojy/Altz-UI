local _, ns = ...
local F, C = unpack(ns)

local function reskinCommunityTab(tab)
	tab:GetRegions():Hide()
	F.ReskinIcon(tab.Icon)
	tab:SetCheckedTexture(C.pushed)
	local hl = tab:GetHighlightTexture()
	hl:SetColorTexture(1, 1, 1, .25)
	hl:SetAllPoints(tab.Icon)
end

local function reskinGuildCards(cards)
	for _, name in pairs({"First", "Second", "Third"}) do
		local guildCard = cards[name.."Card"]
		F.StripTextures(guildCard)
		F.CreateBDFrame(guildCard, .25)
		F.Reskin(guildCard.RequestJoin)
	end
	F.ReskinArrow(cards.PreviousPage, "left")
	F.ReskinArrow(cards.NextPage, "right")
end

local function reskinCommunityCards(frame)
	for _, button in next, frame.ListScrollFrame.buttons do
		button.CircleMask:Hide()
		button.LogoBorder:Hide()
		button.Background:Hide()
		F.ReskinIcon(button.CommunityLogo)
		F.Reskin(button)
	end
	F.ReskinScroll(frame.ListScrollFrame.scrollBar)
end

local function reskinRequestCheckbox(self)
	for button in self.SpecsPool:EnumerateActive() do
		if button.CheckBox then
			F.ReskinCheck(button.CheckBox)
			button.CheckBox:SetSize(26, 26)
		end
	end
end

local function updateCommunitiesSelection(texture, show)
	local button = texture:GetParent()
	if show then
		if texture:GetTexCoord() == 0 then
			button.bg:SetBackdropColor(0, 1, 0, .25)
		else
			button.bg:SetBackdropColor(.51, .773, 1, .25)
		end
	else
		button.bg:SetBackdropColor(0, 0, 0, 0)
	end
end

local function updateNameFrame(self)
	if not self.expanded then return end
	if not self.bg then
		self.bg = F.CreateBDFrame(self.Class)
	end
	local memberInfo = self:GetMemberInfo()
	if memberInfo and memberInfo.classID then
		local classInfo = C_CreatureInfo.GetClassInfo(memberInfo.classID)
		if classInfo then
			local tcoords = CLASS_ICON_TCOORDS[classInfo.classFile]
			self.Class:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
		end
	end
end

local function updateMemberName(self, info)
	if not info then return end

	local class = self.Class
	if not class.bg then
		class.bg = F.CreateBDFrame(class)
	end

	local classTag = select(2, GetClassInfo(info.classID))
	if classTag then
		local tcoords = CLASS_ICON_TCOORDS[classTag]
		class:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
	end
end

C.themes["Blizzard_Communities"] = function()
	local r, g, b = C.r, C.g, C.b
	local CommunitiesFrame = CommunitiesFrame

	F.ReskinPortraitFrame(CommunitiesFrame)
	CommunitiesFrame.NineSlice:Hide()
	CommunitiesFrame.PortraitOverlay:SetAlpha(0)
	F.ReskinDropDown(CommunitiesFrame.StreamDropDownMenu)
	F.ReskinMinMax(CommunitiesFrame.MaximizeMinimizeFrame)
	F.ReskinArrow(CommunitiesFrame.AddToChatButton, "down")
	F.ReskinDropDown(CommunitiesFrame.CommunitiesListDropDownMenu)

	local calendarButton = CommunitiesFrame.CommunitiesCalendarButton
	calendarButton:SetSize(24, 24)
	calendarButton:SetNormalTexture(1103070)
	calendarButton:SetPushedTexture(nil)
	calendarButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.ReskinIcon(calendarButton:GetNormalTexture())

	for _, name in next, {"GuildFinderFrame", "InvitationFrame", "TicketFrame", "CommunityFinderFrame", "ClubFinderInvitationFrame"} do
		local frame = CommunitiesFrame[name]
		if frame then
			F.StripTextures(frame)
			frame.InsetFrame:Hide()
			if frame.CircleMask then
				frame.CircleMask:Hide()
				frame.IconRing:Hide()
				F.ReskinIcon(frame.Icon)
			end
			if frame.FindAGuildButton then F.Reskin(frame.FindAGuildButton) end
			if frame.AcceptButton then F.Reskin(frame.AcceptButton) end
			if frame.DeclineButton then F.Reskin(frame.DeclineButton) end
			if frame.ApplyButton then F.Reskin(frame.ApplyButton) end

			local optionsList = frame.OptionsList
			if optionsList then
				F.ReskinDropDown(optionsList.ClubFilterDropdown)
				F.ReskinDropDown(optionsList.ClubSizeDropdown)
				F.ReskinDropDown(optionsList.SortByDropdown)
				F.ReskinRole(optionsList.TankRoleFrame, "TANK")
				F.ReskinRole(optionsList.HealerRoleFrame, "HEALER")
				F.ReskinRole(optionsList.DpsRoleFrame, "DPS")
				F.ReskinInput(optionsList.SearchBox)
				optionsList.SearchBox:SetSize(118, 22)
				F.Reskin(optionsList.Search)
				optionsList.Search:ClearAllPoints()
				optionsList.Search:SetPoint("TOPRIGHT", optionsList.SearchBox, "BOTTOMRIGHT", 0, -2)
			end

			local requestFrame = frame.RequestToJoinFrame
			if requestFrame then
				F.StripTextures(requestFrame)
				F.SetBD(requestFrame)
				F.StripTextures(requestFrame.MessageFrame)
				F.StripTextures(requestFrame.MessageFrame.MessageScroll)
				F.CreateBDFrame(requestFrame.MessageFrame.MessageScroll, .25)
				F.Reskin(requestFrame.Apply)
				F.Reskin(requestFrame.Cancel)
				hooksecurefunc(requestFrame, "Initialize", reskinRequestCheckbox)
			end

			if frame.ClubFinderSearchTab then reskinCommunityTab(frame.ClubFinderSearchTab) end
			if frame.ClubFinderPendingTab then reskinCommunityTab(frame.ClubFinderPendingTab) end
			if frame.GuildCards then reskinGuildCards(frame.GuildCards) end
			if frame.PendingGuildCards then reskinGuildCards(frame.PendingGuildCards) end
			if frame.CommunityCards then reskinCommunityCards(frame.CommunityCards) end
			if frame.PendingCommunityCards then reskinCommunityCards(frame.PendingCommunityCards) end
		end
	end

	F.StripTextures(CommunitiesFrameCommunitiesList)
	CommunitiesFrameCommunitiesList.InsetFrame:Hide()
	CommunitiesFrameCommunitiesList.FilligreeOverlay:Hide()
	F.ReskinScroll(CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar)
	CommunitiesFrameCommunitiesListListScrollFrame.ScrollBar.Background:Hide()

	hooksecurefunc(CommunitiesFrameCommunitiesList, "Update", function(self)
		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.bg then
				button.bg = F.CreateBDFrame(button, 0, true)
				button.bg:SetPoint("TOPLEFT", 5, -5)
				button.bg:SetPoint("BOTTOMRIGHT", -10, 5)

				button:SetHighlightTexture("")
				button.IconRing:SetAlpha(0)
				button.__iconBorder = F.ReskinIcon(button.Icon)
				button.Background:Hide()
				button.Selection:SetAlpha(0)
				hooksecurefunc(button.Selection, "SetShown", updateCommunitiesSelection)
			end

			button.CircleMask:Hide()
			button.__iconBorder:SetShown(button.IconRing:IsShown())
		end
	end)

	for _, name in next, {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		local tab = CommunitiesFrame[name]
		reskinCommunityTab(tab)
	end

	-- ChatTab
	F.Reskin(CommunitiesFrame.InviteButton)
	F.StripTextures(CommunitiesFrame.Chat)
	F.ReskinScroll(CommunitiesFrame.Chat.MessageFrame.ScrollBar)
	CommunitiesFrame.ChatEditBox:DisableDrawLayer("BACKGROUND")
	local bg1 = F.CreateBDFrame(CommunitiesFrame.Chat.InsetFrame, .25)
	bg1:SetPoint("TOPLEFT", 1, -3)
	bg1:SetPoint("BOTTOMRIGHT", -3, 22)
	local bg2 = F.CreateBDFrame(CommunitiesFrame.ChatEditBox, 0, true)
	bg2:SetPoint("TOPLEFT", -5, -5)
	bg2:SetPoint("BOTTOMRIGHT", 4, 5)

	do
		local dialog = CommunitiesFrame.NotificationSettingsDialog
		F.StripTextures(dialog)
		F.SetBD(dialog)
		F.ReskinDropDown(dialog.CommunitiesListDropDownMenu)
		F.Reskin(dialog.OkayButton)
		F.Reskin(dialog.CancelButton)
		F.ReskinCheck(dialog.ScrollFrame.Child.QuickJoinButton)
		dialog.ScrollFrame.Child.QuickJoinButton:SetSize(25, 25)
		F.Reskin(dialog.ScrollFrame.Child.AllButton)
		F.Reskin(dialog.ScrollFrame.Child.NoneButton)
		F.ReskinScroll(dialog.ScrollFrame.ScrollBar)

		hooksecurefunc(dialog, "Refresh", function(self)
			local frame = self.ScrollFrame.Child
			for i = 1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child.StreamName and not child.styled then
					F.ReskinRadio(child.ShowNotificationsButton)
					F.ReskinRadio(child.HideNotificationsButton)

					child.styled = true
				end
			end
		end)
	end

	do
		local dialog = CommunitiesFrame.EditStreamDialog
		F.StripTextures(dialog)
		F.SetBD(dialog)
		dialog.NameEdit:DisableDrawLayer("BACKGROUND")
		local bg = F.CreateBDFrame(dialog.NameEdit, .25)
		bg:SetPoint("TOPLEFT", -3, -3)
		bg:SetPoint("BOTTOMRIGHT", -4, 3)
		F.StripTextures(dialog.Description)
		F.CreateBDFrame(dialog.Description, .25)
		F.ReskinCheck(dialog.TypeCheckBox)
		F.Reskin(dialog.Accept)
		F.Reskin(dialog.Delete)
		F.Reskin(dialog.Cancel)
	end

	do
		local dialog = CommunitiesTicketManagerDialog
		F.StripTextures(dialog)
		F.SetBD(dialog)
		dialog.Background:Hide()
		F.Reskin(dialog.LinkToChat)
		F.Reskin(dialog.Copy)
		F.Reskin(dialog.Close)
		F.ReskinArrow(dialog.MaximizeButton, "down")
		F.ReskinDropDown(dialog.ExpiresDropDownMenu)
		F.ReskinDropDown(dialog.UsesDropDownMenu)
		F.Reskin(dialog.GenerateLinkButton)

		dialog.InviteManager.ArtOverlay:Hide()
		F.StripTextures(dialog.InviteManager.ColumnDisplay)
		dialog.InviteManager.ListScrollFrame.Background:Hide()
		F.ReskinScroll(dialog.InviteManager.ListScrollFrame.scrollBar)
		dialog.InviteManager.ListScrollFrame.scrollBar.Background:Hide()

		hooksecurefunc(dialog, "Update", function(self)
			local column = self.InviteManager.ColumnDisplay
			for i = 1, column:GetNumChildren() do
				local child = select(i, column:GetChildren())
				if not child.styled then
					F.StripTextures(child)
					F.CreateBDFrame(child, .25)

					child.styled = true
				end
			end

			local buttons = self.InviteManager.ListScrollFrame.buttons
			for i = 1, #buttons do
				local button = buttons[i]
				if not button.styled then
					F.Reskin(button.CopyLinkButton)
					button.CopyLinkButton.Background:Hide()
					F.Reskin(button.RevokeButton)
					button.RevokeButton:SetSize(18, 18)

					button.styled = true
				end
			end
		end)
	end

	-- Roster
	CommunitiesFrame.MemberList.InsetFrame:Hide()
	F.CreateBDFrame(CommunitiesFrame.MemberList.ListScrollFrame, .25)
	F.StripTextures(CommunitiesFrame.MemberList.ColumnDisplay)
	F.ReskinDropDown(CommunitiesFrame.GuildMemberListDropDownMenu)
	F.ReskinScroll(CommunitiesFrame.MemberList.ListScrollFrame.scrollBar)
	CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.Background:Hide()
	F.ReskinCheck(CommunitiesFrame.MemberList.ShowOfflineButton)
	CommunitiesFrame.MemberList.ShowOfflineButton:SetSize(25, 25)
	F.Reskin(CommunitiesFrame.CommunitiesControlFrame.GuildControlButton)
	F.Reskin(CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton)
	F.Reskin(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)
	F.ReskinDropDown(CommunitiesFrame.CommunityMemberListDropDownMenu)

	local detailFrame = CommunitiesFrame.GuildMemberDetailFrame
	F.StripTextures(detailFrame)
	F.SetBD(detailFrame)
	F.ReskinClose(detailFrame.CloseButton)
	F.Reskin(detailFrame.RemoveButton)
	F.Reskin(detailFrame.GroupInviteButton)
	F.ReskinDropDown(detailFrame.RankDropdown)
	F.StripTextures(detailFrame.NoteBackground)
	F.CreateBDFrame(detailFrame.NoteBackground, .25)
	F.StripTextures(detailFrame.OfficerNoteBackground)
	F.CreateBDFrame(detailFrame.OfficerNoteBackground, .25)
	detailFrame:ClearAllPoints()
	detailFrame:SetPoint("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 34, 0)

	do
		local dialog = CommunitiesSettingsDialog
		dialog.BG:Hide()
		F.SetBD(dialog)
		F.Reskin(dialog.ChangeAvatarButton)
		F.Reskin(dialog.Accept)
		F.Reskin(dialog.Delete)
		F.Reskin(dialog.Cancel)
		F.ReskinInput(dialog.NameEdit)
		F.ReskinInput(dialog.ShortNameEdit)
		F.StripTextures(dialog.Description)
		F.CreateBDFrame(dialog.Description, .25)
		F.StripTextures(dialog.MessageOfTheDay)
		F.CreateBDFrame(dialog.MessageOfTheDay, .25)
		F.ReskinCheck(dialog.ShouldListClub.Button)
		F.ReskinCheck(dialog.AutoAcceptApplications.Button)
		F.ReskinCheck(dialog.MaxLevelOnly.Button)
		F.ReskinCheck(dialog.MinIlvlOnly.Button)
		F.ReskinInput(dialog.MinIlvlOnly.EditBox)
		F.ReskinDropDown(ClubFinderFocusDropdown)
		F.ReskinDropDown(ClubFinderLookingForDropdown)
		F.ReskinDropDown(ClubFinderLanguageDropdown)
	end

	do
		local dialog = CommunitiesAvatarPickerDialog
		F.StripTextures(dialog)
		F.SetBD(dialog)
		F.ReskinScroll(CommunitiesAvatarPickerDialogScrollBar)
		F.Reskin(dialog.OkayButton)
		F.Reskin(dialog.CancelButton)

		hooksecurefunc(CommunitiesAvatarPickerDialog.ScrollFrame, "Refresh", function(self)
			for i = 1, 5 do
				for j = 1, 6 do
					local avatarButton = self.avatarButtons[i][j]
					if avatarButton:IsShown() and not avatarButton.bg then
						avatarButton.bg = F.ReskinIcon(avatarButton.Icon)
						avatarButton.Selected:SetTexture("")
						avatarButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
					end

					if avatarButton.Selected:IsShown() then
						avatarButton.bg:SetBackdropBorderColor(r, g, b)
					else
						avatarButton.bg:SetBackdropBorderColor(0, 0, 0)
					end
				end
			end
		end)
	end

	hooksecurefunc(CommunitiesFrame.MemberList, "RefreshListDisplay", function(self)
		for i = 1, self.ColumnDisplay:GetNumChildren() do
			local child = select(i, self.ColumnDisplay:GetChildren())
			if not child.styled then
				F.StripTextures(child)
				F.CreateBDFrame(child, .25)

				child.styled = true
			end
		end

		for _, button in ipairs(self.ListScrollFrame.buttons or {}) do
			if button and not button.hooked then
				hooksecurefunc(button, "RefreshExpandedColumns", updateNameFrame)
				if button.ProfessionHeader then
					local header = button.ProfessionHeader
					for i = 1, 3 do
						select(i, header:GetRegions()):Hide()
					end
					F.CreateBDFrame(header, .45)
					header:SetHighlightTexture(C.bdTex)
					header:GetHighlightTexture():SetVertexColor(r, g, b, .25)
					F.CreateBDFrame(header.Icon)
				end

				button.hooked = true
			end
			if button and button.bg then
				button.bg:SetShown(button.Class:IsShown())
			end
		end
	end)

	-- Benefits
	CommunitiesFrame.GuildBenefitsFrame.Perks:GetRegions():SetAlpha(0)
	CommunitiesFrame.GuildBenefitsFrame.Rewards.Bg:SetAlpha(0)
	F.StripTextures(CommunitiesFrame.GuildBenefitsFrame)
	F.ReskinScroll(CommunitiesFrameRewards.scrollBar)

	local factionFrameBar = CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Bar
	F.StripTextures(factionFrameBar)
	local bg = F.CreateBDFrame(factionFrameBar, .25)
	factionFrameBar.Progress:SetTexture(C.bdTex)
	bg:SetOutside(factionFrameBar.Progress)

	hooksecurefunc("CommunitiesGuildPerks_Update", function(self)
		local buttons = self.Container.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button and button:IsShown() and not button.bg then
				F.ReskinIcon(button.Icon)
				F.StripTextures(button)
				button.bg = F.CreateBDFrame(button, .25)
				button.bg:ClearAllPoints()
				button.bg:SetPoint("TOPLEFT", button.Icon, 0, C.mult)
				button.bg:SetPoint("BOTTOMLEFT", button.Icon, 0, -C.mult)
				button.bg:SetWidth(button:GetWidth())
			end
		end
	end)

	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local buttons = self.RewardsContainer.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button then
				if not button.bg then
					F.ReskinIcon(button.Icon)
					select(6, button:GetRegions()):SetAlpha(0)
					select(7, button:GetRegions()):SetAlpha(0)

					button.bg = F.CreateBDFrame(button, .25)
					button.bg:SetPoint("TOPLEFT", button.Icon, -5, 5)
					button.bg:SetPoint("BOTTOMRIGHT", 0, 10)
				end
				button.DisabledBG:Hide()
			end
		end
	end)

	-- Guild Info
	F.Reskin(CommunitiesFrame.GuildLogButton)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameInfo)
	F.StripTextures(CommunitiesFrameGuildDetailsFrameNews)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrameScrollBar)
	local bg3 = F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfoMOTDScrollFrame, .25)
	bg3:SetPoint("TOPLEFT", 0, 3)
	bg3:SetPoint("BOTTOMRIGHT", -5, -4)

	F.StripTextures(CommunitiesGuildTextEditFrame)
	F.SetBD(CommunitiesGuildTextEditFrame)
	CommunitiesGuildTextEditFrameBg:Hide()
	F.StripTextures(CommunitiesGuildTextEditFrame.Container)
	F.CreateBDFrame(CommunitiesGuildTextEditFrame.Container, .25)
	F.ReskinScroll(CommunitiesGuildTextEditFrameScrollBar)
	F.ReskinClose(CommunitiesGuildTextEditFrameCloseButton)
	F.Reskin(CommunitiesGuildTextEditFrameAcceptButton)
	local closeButton = select(4, CommunitiesGuildTextEditFrame:GetChildren())
	F.Reskin(closeButton)

	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameInfoScrollBar)
	F.CreateBDFrame(CommunitiesFrameGuildDetailsFrameInfo.DetailsFrame, .25)
	F.ReskinScroll(CommunitiesFrameGuildDetailsFrameNewsContainer.ScrollBar)
	F.StripTextures(CommunitiesFrameGuildDetailsFrame)

	hooksecurefunc("GuildNewsButton_SetNews", function(button)
		if button.header:IsShown() then
			button.header:SetAlpha(0)
		end
	end)

	F.StripTextures(CommunitiesGuildNewsFiltersFrame)
	CommunitiesGuildNewsFiltersFrameBg:Hide()
	F.SetBD(CommunitiesGuildNewsFiltersFrame)
	F.ReskinClose(CommunitiesGuildNewsFiltersFrame.CloseButton)
	for _, name in next, {"GuildAchievement", "Achievement", "DungeonEncounter", "EpicItemLooted", "EpicItemPurchased", "EpicItemCrafted", "LegendaryItemLooted"} do
		local filter = CommunitiesGuildNewsFiltersFrame[name]
		F.ReskinCheck(filter)
	end

	F.StripTextures(CommunitiesGuildLogFrame)
	CommunitiesGuildLogFrameBg:Hide()
	F.SetBD(CommunitiesGuildLogFrame)
	F.ReskinClose(CommunitiesGuildLogFrameCloseButton)
	F.ReskinScroll(CommunitiesGuildLogFrameScrollBar)
	F.StripTextures(CommunitiesGuildLogFrame.Container)
	F.CreateBDFrame(CommunitiesGuildLogFrame.Container, .25)
	local closeButton = select(3, CommunitiesGuildLogFrame:GetChildren())
	F.Reskin(closeButton)

	local bossModel = CommunitiesFrameGuildDetailsFrameNews.BossModel
	F.StripTextures(bossModel)
	bossModel:ClearAllPoints()
	bossModel:SetPoint("LEFT", CommunitiesFrame, "RIGHT", 40, 0)
	local textFrame = bossModel.TextFrame
	F.StripTextures(textFrame)
	local bg = F.SetBD(bossModel)
	bg:SetOutside(bossModel, nil, nil, textFrame)

	-- Recruitment dialog
	do
		local dialog = CommunitiesFrame.RecruitmentDialog
		F.StripTextures(dialog)
		F.SetBD(dialog)
		F.ReskinCheck(dialog.ShouldListClub.Button)
		F.ReskinCheck(dialog.MaxLevelOnly.Button)
		F.ReskinCheck(dialog.MinIlvlOnly.Button)
		F.ReskinDropDown(dialog.ClubFocusDropdown)
		F.ReskinDropDown(dialog.LookingForDropdown)
		F.ReskinDropDown(dialog.LanguageDropdown)
		F.StripTextures(dialog.RecruitmentMessageFrame)
		F.StripTextures(dialog.RecruitmentMessageFrame.RecruitmentMessageInput)
		F.ReskinScroll(dialog.RecruitmentMessageFrame.RecruitmentMessageInput.ScrollBar)
		F.ReskinInput(dialog.RecruitmentMessageFrame)
		F.ReskinInput(dialog.MinIlvlOnly.EditBox)
		F.Reskin(dialog.Accept)
		F.Reskin(dialog.Cancel)
	end

	-- ApplicantList
	local applicantList = CommunitiesFrame.ApplicantList
	F.StripTextures(applicantList)
	F.StripTextures(applicantList.ColumnDisplay)
	F.ReskinScroll(applicantList.ListScrollFrame.scrollBar)
	local listBG = F.CreateBDFrame(applicantList, .25)
	listBG:SetPoint("TOPLEFT", 0, 0)
	listBG:SetPoint("BOTTOMRIGHT", -15, 0)

	hooksecurefunc(applicantList, "BuildList", function(self)
		local columnDisplay = self.ColumnDisplay
		for i = 1, columnDisplay:GetNumChildren() do
			local child = select(i, columnDisplay:GetChildren())
			if not child.styled then
				F.StripTextures(child)

				local bg = F.CreateBDFrame(child, .25)
				bg:SetPoint("TOPLEFT", 4, -2)
				bg:SetPoint("BOTTOMRIGHT", 0, 2)

				child:SetHighlightTexture(C.bdTex)
				local hl = child:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .25)
				hl:SetInside(bg)

				child.styled = true
			end
		end

		local buttons = self.ListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if not button.styled then
				button:SetPoint("LEFT", listBG, C.mult, 0)
				button:SetPoint("RIGHT", listBG, -C.mult, 0)
				button:SetHighlightTexture(C.bdTex)
				button:GetHighlightTexture():SetVertexColor(r, g, b, .25)
				button.InviteButton:SetSize(66, 18)
				button.CancelInvitationButton:SetSize(20, 18)

				F.Reskin(button.InviteButton)
				F.Reskin(button.CancelInvitationButton)
				hooksecurefunc(button, "UpdateMemberInfo", updateMemberName)

				button.styled = true
			end
		end
	end)
end