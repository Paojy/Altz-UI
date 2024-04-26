local T, C, L, G = unpack(select(2, ...))

-- 大秘境评分
local ef = CreateFrame("Frame")
ef:RegisterEvent("ADDON_LOADED")
ef:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		local frame = CreateFrame("Frame", "InspectChallengeModeFrame", InspectFrame)
		frame:SetAllPoints(InspectFrame)
		frame:Hide()
		
		frame.title = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "CENTER")
		frame.title:SetPoint("TOP", 0, -50)
		frame.title:SetText(DUNGEON_SCORE)
		
		frame.score = T.createtext(frame, "OVERLAY", 25, "OUTLINE", "CENTER")
		frame.score:SetPoint("TOP", frame.title, "BOTTOM", 0, -5)

		frame.map_buttons = {}
		
		for i = 1, 8 do
			local bu = CreateFrame("Frame", nil, frame)
			bu:SetSize(280, 30)
			bu:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -80-35*i)
			
			bu.icon = bu:CreateTexture(nil, "ARTWORK")
			bu.icon:SetSize(30, 30)
			bu.icon:SetPoint("LEFT", bu, "LEFT", 0, 0)		
			
			bu.iconbg = T.createTexBackdrop(bu, bu.icon)
			
			bu.left = T.createtext(bu, "OVERLAY", 14, "OUTLINE", "LEFT")
			bu.left:SetPoint("LEFT", bu.icon, "RIGHT", 5, 0)		
			bu.left:SetTextColor(1, .82, 0)
			
			bu.right = T.createtext(bu, "OVERLAY", 16, "OUTLINE", "LEFT")
			bu.right:SetPoint("LEFT", bu, "RIGHT", -50, 0)
			
			frame.map_buttons[i] = bu
		end
		
		frame:SetScript("OnShow", function()
			-- 重置
			frame.score:SetText(UNKNOWN)
			for i, bu in pairs(frame.map_buttons) do
				bu:Hide()
			end
			
			-- 显示分数
			if InspectFrame.unit and UnitLevel(InspectFrame.unit) >= GetMaxLevelForPlayerExpansion() then
				local summary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(InspectFrame.unit)
				if summary and summary.currentSeasonScore and summary.runs then
					local score = summary.currentSeasonScore
					if score > 0 then
						
						local color = C_ChallengeMode.GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
						frame.score:SetText(T.hex_str(score, color.r, color.g, color.b))
						for i, info in pairs(summary.runs) do
							local bu = frame.map_buttons[i]
							local name, _, _, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(info.challengeModeID)
							local color = C_ChallengeMode.GetDungeonScoreRarityColor(info.mapScore*8) or HIGHLIGHT_FONT_COLOR
							
							if texture == 0 then
								bu.icon:SetTexture("Interface\\Icons\\achievement_bg_wineos_underxminutes")
							else
								bu.icon:SetTexture(texture)
							end
							bu.left:SetText(name)
							bu.right:SetText(T.hex_str(info.mapScore, color.r, color.g, color.b).."("..info.bestRunLevel..")")
							bu:Show()
						end
					end
				end
			end
		end)
		
		-- 标签
		local tab = CreateFrame("Button", "InspectFrameTab4", InspectFrame, "PanelTabButtonTemplate")
		tab:SetID("4")
		tab:SetText(CHALLENGES)
		T.ReskinTab(tab)
		
		tab:SetScript("OnClick", InspectFrameTab_OnClick)
		
		PanelTemplates_SetNumTabs(InspectFrame, 4)
		table.insert(tab, InspectFrame.Tabs)
		table.insert(INSPECTFRAME_SUBFRAMES, "InspectChallengeModeFrame")
		
		-- 需要重新定位
		for i = 1, 4 do
			local tab = _G["InspectFrameTab"..i]
			if tab then
				if i ~= 1 then
					tab:ClearAllPoints()
					tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
				end
			end
		end
	end
end)