local F, C = unpack(select(2, ...))

C.themes["Blizzard_Calendar"] = function()
	local r, g, b = C.r, C.g, C.b

	for i = 1, 42 do
		local dayButtonName = "CalendarDayButton"..i
		local bu = _G[dayButtonName]
		bu:DisableDrawLayer("BACKGROUND")
		bu:SetHighlightTexture(C.media.backdrop)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .25)
		hl.SetAlpha = F.dummy

		_G[dayButtonName.."DarkFrame"]:SetAlpha(.5)

		local eventButtonIndex = 1
		local eventButton = _G[dayButtonName.."EventButton"..eventButtonIndex]
		while eventButton do
			eventButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			eventButton.black:SetTexture(nil)
			eventButtonIndex = eventButtonIndex + 1
			eventButton = _G[dayButtonName.."EventButton"..eventButtonIndex]
		end
	end

	for i = 1, 7 do
		_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
	end

	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()
	CalendarViewEventInviteList:GetRegions():Hide()
	CalendarViewEventDescriptionContainer:GetRegions():Hide()
	CalendarCreateEventFrameButtonBackground:Hide()
	CalendarCreateEventMassInviteButtonBorder:Hide()
	CalendarCreateEventCreateButtonBorder:Hide()
	CalendarCreateEventIcon:SetTexCoord(.08, .92, .08, .92)
	CalendarCreateEventIcon.SetTexCoord = F.dummy
	F.CreateBDFrame(CalendarCreateEventIcon)
	CalendarEventPickerCloseButtonBorder:Hide()
	CalendarCreateEventRaidInviteButtonBorder:Hide()
	CalendarMonthBackground:SetAlpha(0)
	CalendarYearBackground:SetAlpha(0)
	CalendarFrameModalOverlay:SetAlpha(.25)
	CalendarViewHolidayInfoTexture:SetAlpha(0)
	CalendarTexturePickerAcceptButtonBorder:Hide()
	CalendarTexturePickerCancelButtonBorder:Hide()
	F.StripTextures(CalendarClassTotalsButton)

	F.StripTextures(CalendarFrame)
	F.SetBD(CalendarFrame, 12, 0, -9, 4)
	F.CreateBD(CalendarClassTotalsButton)
	F.CreateBD(CalendarViewEventInviteList, .25)
	F.CreateBD(CalendarViewEventDescriptionContainer, .25)
	F.CreateBD(CalendarCreateEventInviteList, .25)
	F.CreateBD(CalendarCreateEventDescriptionContainer, .25)

	local function reskinCalendarPage(frame)
		F.StripTextures(frame)
		F.SetBD(frame)
		F.StripTextures(frame.Header)
	end
	reskinCalendarPage(CalendarViewHolidayFrame)
	reskinCalendarPage(CalendarCreateEventFrame)
	reskinCalendarPage(CalendarTexturePickerFrame)
	reskinCalendarPage(CalendarEventPickerFrame)

	local frames = {
		CalendarViewEventTitleFrame, CalendarViewHolidayTitleFrame, CalendarViewRaidTitleFrame, CalendarCreateEventTitleFrame, CalendarTexturePickerTitleFrame, CalendarMassInviteTitleFrame
	}
	for _, titleFrame in next, frames do
		F.StripTextures(titleFrame)
		local parent = titleFrame:GetParent()
		F.StripTextures(parent)
		F.CreateBD(parent)
		F.CreateSD(parent)
	end

	CalendarWeekdaySelectedTexture:SetDesaturated(true)
	CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)

	hooksecurefunc("CalendarFrame_SetToday", function()
		CalendarTodayFrame:SetAllPoints()
	end)

	CalendarTodayFrame:SetScript("OnUpdate", nil)
	CalendarTodayTextureGlow:Hide()
	CalendarTodayTexture:Hide()

	CalendarTodayFrame:SetBackdrop({
		edgeFile = C.media.backdrop,
		edgeSize = C.mult,
	})
	CalendarTodayFrame:SetBackdropBorderColor(r, g, b)

	for i, class in ipairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()
		F.CreateBDFrame(bu)

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
	end

	F.StripTextures(CalendarFilterFrame)
	local bg = F.CreateBDFrame(CalendarFilterFrame, 0)
	bg:SetPoint("TOPLEFT", 35, -1)
	bg:SetPoint("BOTTOMRIGHT", -18, 1)
	F.CreateGradient(bg)
	F.ReskinArrow(CalendarFilterButton, "down")

	for i = 1, 6 do
		local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
		vline:SetHeight(546)
		vline:SetWidth(1)
		vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
		F.CreateBD(vline)
	end
	for i = 1, 36, 7 do
		local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
		hline:SetWidth(637)
		hline:SetHeight(1)
		hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
		F.CreateBD(hline)
	end

	if AuroraClassicDB.Tooltips then
		F.ReskinTooltip(CalendarContextMenu)
		F.ReskinTooltip(CalendarInviteStatusContextMenu)
	end

	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

	CalendarCreateEventHourDropDown:SetWidth(80)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	CalendarCreateEventAMPMDropDown:SetWidth(90)

	local line = CalendarMassInviteFrame:CreateTexture(nil, "BACKGROUND")
	line:SetSize(240, 1)
	line:SetPoint("TOP", CalendarMassInviteFrame, "TOP", 0, -150)
	line:SetTexture(C.media.backdrop)
	line:SetVertexColor(0, 0, 0)

	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:SetPoint("BOTTOMLEFT", CalendarCreateEventFrame, "BOTTOMRIGHT", 28, 0)

	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:SetPoint("TOPLEFT", CalendarCreateEventFrame, "TOPRIGHT", 28, 0)

	local cbuttons = {"CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton", "CalendarCreateEventMassInviteButton", "CalendarCreateEventCreateButton", "CalendarCreateEventInviteButton", "CalendarEventPickerCloseButton", "CalendarCreateEventRaidInviteButton", "CalendarTexturePickerAcceptButton", "CalendarTexturePickerCancelButton", "CalendarMassInviteAcceptButton"}
	for i = 1, #cbuttons do
		local cbutton = _G[cbuttons[i]]
		if not cbutton then
			print(cbuttons[i])
		else
			F.Reskin(cbutton)
		end
	end

	CalendarViewEventAcceptButton.flashTexture:SetTexture("")
	CalendarViewEventTentativeButton.flashTexture:SetTexture("")
	CalendarViewEventDeclineButton.flashTexture:SetTexture("")

	F.ReskinClose(CalendarCloseButton, "TOPRIGHT", CalendarFrame, "TOPRIGHT", -14, -4)
	F.ReskinClose(CalendarCreateEventCloseButton)
	F.ReskinClose(CalendarViewEventCloseButton)
	F.ReskinClose(CalendarViewHolidayCloseButton)
	F.ReskinClose(CalendarViewRaidCloseButton)
	F.ReskinClose(CalendarMassInviteCloseButton)
	F.ReskinScroll(CalendarTexturePickerScrollBar)
	F.ReskinScroll(CalendarViewEventInviteListScrollFrameScrollBar)
	F.ReskinScroll(CalendarViewEventDescriptionScrollFrameScrollBar)
	F.ReskinScroll(CalendarCreateEventInviteListScrollFrameScrollBar)
	F.ReskinScroll(CalendarCreateEventDescriptionScrollFrameScrollBar)
	F.ReskinDropDown(CalendarCreateEventCommunityDropDown)
	F.ReskinDropDown(CalendarCreateEventTypeDropDown)
	F.ReskinDropDown(CalendarCreateEventHourDropDown)
	F.ReskinDropDown(CalendarCreateEventMinuteDropDown)
	F.ReskinDropDown(CalendarCreateEventAMPMDropDown)
	F.ReskinDropDown(CalendarCreateEventDifficultyOptionDropDown)
	F.ReskinDropDown(CalendarMassInviteCommunityDropDown)
	F.ReskinDropDown(CalendarMassInviteRankMenu)
	F.ReskinInput(CalendarCreateEventTitleEdit)
	F.ReskinInput(CalendarCreateEventInviteEdit)
	F.ReskinInput(CalendarMassInviteMinLevelEdit)
	F.ReskinInput(CalendarMassInviteMaxLevelEdit)
	F.ReskinArrow(CalendarPrevMonthButton, "left")
	F.ReskinArrow(CalendarNextMonthButton, "right")
	CalendarPrevMonthButton:SetSize(19, 19)
	CalendarNextMonthButton:SetSize(19, 19)
	F.ReskinCheck(CalendarCreateEventLockEventCheck)

	CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)
end