local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	F.ReskinPortraitFrame(QuestFrame)

	QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")
	QuestLogPopupDetailFrame.SealMaterialBG:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)
	hooksecurefunc("QuestFrame_SetMaterial", function(frame)
		_G[frame:GetName().."MaterialTopLeft"]:Hide()
		_G[frame:GetName().."MaterialTopRight"]:Hide()
		_G[frame:GetName().."MaterialBotLeft"]:Hide()
		_G[frame:GetName().."MaterialBotRight"]:Hide()
	end)

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
		F.ReskinIcon(button.Icon)
		button.NameFrame:Hide()
	end

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for _, questButton in pairs({"QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton"}) do
		F.Reskin(_G[questButton])
	end
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
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = F.Dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = F.Dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- Quest NPC model

	F.StripTextures(QuestModelScene)
	F.SetBD(QuestModelScene)
	F.StripTextures(QuestNPCModelTextFrame)
	F.SetBD(QuestNPCModelTextFrame)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		x = x + 6
		QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)
end)