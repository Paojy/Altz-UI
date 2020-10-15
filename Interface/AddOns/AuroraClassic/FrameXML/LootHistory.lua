local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	local r, g, b = C.r, C.g, C.b

	local LootHistoryFrame = LootHistoryFrame

	for i = 1, 9 do
		select(i, LootHistoryFrame:GetRegions()):Hide()
	end
	LootHistoryFrame.LootIcon:Hide()
	LootHistoryFrame.Divider:SetAlpha(0)
	LootHistoryFrameScrollFrame:GetRegions():Hide()

	LootHistoryFrame.Label:ClearAllPoints()
	LootHistoryFrame.Label:SetPoint("TOP", LootHistoryFrame, "TOP", 0, -8)

	F.SetBD(LootHistoryFrame)
	F.ReskinClose(LootHistoryFrame.CloseButton)
	F.ReskinScroll(LootHistoryFrameScrollFrameScrollBar)

	-- [[ Resize button ]]

	LootHistoryFrame.ResizeButton:SetNormalTexture("")
	LootHistoryFrame.ResizeButton:SetHeight(8)

	do
		local line1 = LootHistoryFrame.ResizeButton:CreateTexture()
		line1:SetTexture(C.bdTex)
		line1:SetVertexColor(.7, .7, .7)
		line1:SetSize(30, 1)
		line1:SetPoint("TOP")

		local line2 = LootHistoryFrame.ResizeButton:CreateTexture()
		line2:SetTexture(C.bdTex)
		line2:SetVertexColor(.7, .7, .7)
		line2:SetSize(30, 1)
		line2:SetPoint("TOP", 0, -3)

		LootHistoryFrame.ResizeButton:HookScript("OnEnter", function()
			line1:SetVertexColor(r, g, b)
			line2:SetVertexColor(r, g, b)
		end)

		LootHistoryFrame.ResizeButton:HookScript("OnLeave", function()
			line1:SetVertexColor(.7, .7, .7)
			line2:SetVertexColor(.7, .7, .7)
		end)
	end

	-- [[ Item frame ]]

	hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, frame)
		local rollID, _, _, isDone, winnerIdx = C_LootHistory.GetItem(frame.itemIdx)
		local expanded = self.expandedRolls[rollID]

		if not frame.styled then
			frame.Divider:Hide()
			frame.NameBorderLeft:Hide()
			frame.NameBorderRight:Hide()
			frame.NameBorderMid:Hide()
			frame.IconBorder:Hide()

			frame.WinnerRoll:SetTextColor(.9, .9, .9)

			frame.bg = F.ReskinIcon(frame.Icon)

			F.ReskinCollapse(frame.ToggleButton)
			frame.ToggleButton:GetNormalTexture():SetAlpha(0)
			frame.ToggleButton:GetPushedTexture():SetAlpha(0)
			frame.ToggleButton:GetDisabledTexture():SetAlpha(0)

			frame.styled = true
		end

		if isDone and not expanded and winnerIdx then
			local name, class = C_LootHistory.GetPlayerInfo(frame.itemIdx, winnerIdx)
			if name then
				local color = C.ClassColors[class]
				frame.WinnerName:SetVertexColor(color.r, color.g, color.b)
			end
		end

		frame.bg:SetBackdropBorderColor(frame.IconBorder:GetVertexColor())
	end)

	-- [[ Player frame ]]

	hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(_, playerFrame)
		if not playerFrame.styled then
			playerFrame.RollText:SetTextColor(.9, .9, .9)
			playerFrame.WinMark:SetDesaturated(true)

			playerFrame.styled = true
		end

		if playerFrame.playerIdx then
			local name, class, _, _, isWinner = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)

			if name then
				local color = C.ClassColors[class]
				playerFrame.PlayerName:SetTextColor(color.r, color.g, color.b)

				if isWinner then
					playerFrame.WinMark:SetVertexColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	-- [[ Dropdown ]]

	LootHistoryDropDown.initialize = function(self)
		local info = UIDropDownMenu_CreateInfo();
		info.isTitle = 1;
		info.text = MASTER_LOOTER;
		info.fontObject = GameFontNormalLeft;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);

		info = UIDropDownMenu_CreateInfo();
		info.notCheckable = 1;
		local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx);
		local classColor = C.ClassColors[class];
		local colorCode = classColor.colorStr
		info.text = string.format(MASTER_LOOTER_GIVE_TO, colorCode..name.."|r");
		info.func = LootHistoryDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end)