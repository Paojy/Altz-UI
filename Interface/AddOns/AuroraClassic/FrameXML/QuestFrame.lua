local _, ns = ...
local F, C = unpack(ns)

local function UpdateProgressItemQuality(self)
	local button = self.__owner
	local index = button:GetID()
	local buttonType = button.type
	local objectType = button.objectType

	local quality
	if objectType == "item" then
		quality = select(4, GetQuestItemInfo(buttonType, index))
	elseif objectType == "currency" then
		quality = select(4, GetQuestCurrencyInfo(buttonType, index))
	end

	local color = C.QualityColors[quality or 1]
	button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
end

tinsert(C.defaultThemes, function()
	F.ReskinPortraitFrame(QuestFrame)

	F.StripTextures(QuestFrameDetailPanel, 0)
	F.StripTextures(QuestFrameRewardPanel, 0)
	F.StripTextures(QuestFrameProgressPanel, 0)
	F.StripTextures(QuestFrameGreetingPanel, 0)

	local line = QuestFrameGreetingPanel:CreateTexture()
	line:SetColorTexture(1, 1, 1, .25)
	line:SetSize(256, C.mult)
	line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)
	QuestGreetingFrameHorizontalBreak:SetTexture("")
	QuestFrameGreetingPanel:HookScript("OnShow", function()
		line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
		local button = _G["QuestProgressItem"..i]
		button.NameFrame:Hide()
		button.bg = F.ReskinIcon(button.Icon)
		button.Icon.__owner = button
		hooksecurefunc(button.Icon, "SetTexture", UpdateProgressItemQuality)

		local bg = F.CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT", button.bg, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", button.bg, 100, 0)
	end

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	F.Reskin(QuestFrameAcceptButton)
	F.Reskin(QuestFrameDeclineButton)
	F.Reskin(QuestFrameCompleteQuestButton)
	F.Reskin(QuestFrameCompleteButton)
	F.Reskin(QuestFrameGoodbyeButton)
	F.Reskin(QuestFrameGreetingGoodbyeButton)

	F.ReskinScroll(QuestProgressScrollFrameScrollBar)
	F.ReskinScroll(QuestRewardScrollFrameScrollBar)
	F.ReskinScroll(QuestDetailScrollFrameScrollBar)
	F.ReskinScroll(QuestGreetingScrollFrameScrollBar)

	-- Text colour stuff

	QuestProgressRequiredItemsText:SetTextColor(1, .8, 0)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText:SetTextColor(1, .8, 0)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText.SetTextColor = F.Dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = F.Dummy
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = F.Dummy
	AvailableQuestsText:SetTextColor(1, .8, 0)
	AvailableQuestsText.SetTextColor = F.Dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = F.Dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- Quest NPC model

	F.StripTextures(QuestModelScene)
	F.StripTextures(QuestNPCModelTextFrame)
	local bg = F.SetBD(QuestModelScene)
	bg:SetOutside(nil, nil, nil, QuestNPCModelTextFrame)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, _, x, y)
		x = x + 6
		QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)
end)