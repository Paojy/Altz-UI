local T, C, L, G = unpack(select(2, ...))

local factionGroup = UnitFactionGroup("player")

local Data = {
    [525] = 1216786, -- 水闸行动
	[499] = 445444, -- 圣焰隐修院
	[378] = 354465, -- 赎罪大厅
	[503] = 445417, -- 艾拉-卡拉，回响之城
	[505] = 445414, -- 破晨号
	[542] = 1237215, -- 奥尔达尼生态圆顶
	[391] = 367416, -- 塔扎维什：琳彩天街
	[392] = 367416, -- 塔扎维什：索·莉亚的宏图
}

local function UpdateCooldownText(button)
	if button.spellID then
		local spellCooldownInfo = C_Spell.GetSpellCooldown(button.spellID)
	
		if spellCooldownInfo then
			local startTime = spellCooldownInfo.startTime
			local duration = spellCooldownInfo.duration
			local isEnabled = spellCooldownInfo.isEnabled
	
			if startTime > 0 and duration > 0 and isEnabled then
				local remaining = max(0, (startTime + duration) - GetTime())
	
				if remaining > 5 then
					button.cooldownText:SetText(T.FormatTime(remaining))
					button.cooldownIcon:Hide()
				else
					button.cooldownText:SetText("")
					button.cooldownIcon:SetAtlas("Raid-Icon-SummonPending")
					button.cooldownIcon:Show()
				end
			else
				button.cooldownText:SetText("")
				button.cooldownIcon:SetAtlas("Raid-Icon-SummonPending")
				button.cooldownIcon:Show()
			end
		else
			button.cooldownText:SetText("")
			button.cooldownIcon:SetAtlas("Raid-Icon-SummonDeclined")
			button.cooldownIcon:Show()
		end
	else
		button.cooldownText:SetText("")
		button.cooldownIcon:Hide()
	end
end

local function AddScoreToTooltip(Info, overTime)
	if info then
		GameTooltip_AddBlankLineToTooltip(GameTooltip)
		GameTooltip_AddNormalLine(GameTooltip, LFG_LIST_BEST_RUN..string.format("[%s]", L["赛季"]))
		GameTooltip_AddColoredLine(GameTooltip, MYTHIC_PLUS_POWER_LEVEL:format(Info.level), HIGHLIGHT_FONT_COLOR)
		
		local displayZeroHours = Info.durationSec >= SECONDS_PER_HOUR
		local durationText = SecondsToClock(Info.durationSec, displayZeroHours)
		
		if overTime then
			local overtimeText = DUNGEON_SCORE_OVERTIME_TIME:format(durationText)
			GameTooltip_AddColoredLine(GameTooltip, overtimeText, LIGHTGRAY_FONT_COLOR)
		else
			GameTooltip_AddColoredLine(GameTooltip, durationText, HIGHLIGHT_FONT_COLOR)
		end
	end
end

local function AddAffixScoreToTooltip(affixInfo)
	GameTooltip_AddBlankLineToTooltip(GameTooltip)
	GameTooltip_AddNormalLine(GameTooltip, LFG_LIST_BEST_RUN..string.format("[%s]", L["当前词缀"]))
	GameTooltip_AddColoredLine(GameTooltip, MYTHIC_PLUS_POWER_LEVEL:format(affixInfo.level), HIGHLIGHT_FONT_COLOR)

	local displayZeroHours = affixInfo.durationSec >= SECONDS_PER_HOUR
	local durationText = SecondsToClock(affixInfo.durationSec, displayZeroHours)

	if affixInfo.overTime then
		local overtimeText = DUNGEON_SCORE_OVERTIME_TIME:format(durationText)
		GameTooltip_AddColoredLine(GameTooltip, overtimeText, LIGHTGRAY_FONT_COLOR)
	else
		GameTooltip_AddColoredLine(GameTooltip, durationText, HIGHLIGHT_FONT_COLOR)
	end
end

local function ChallengesDungeonIconOnEnter(parent, self)
	local name = C_ChallengeMode.GetMapUIInfo(parent.mapID)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(name, 1, 1, 1)
	
	local inTimeInfo, overtimeInfo = C_MythicPlus.GetSeasonBestForMap(parent.mapID)
	local affixScores, overallScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(parent.mapID)
	
	if overallScore and (inTimeInfo or overtimeInfo) then
		local color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(overallScore) or HIGHLIGHT_FONT_COLOR
		local overallText = DUNGEON_SCORE_TOTAL_SCORE:format(color:WrapTextInColorCode(overallScore))
		GameTooltip_AddNormalLine(GameTooltip, overallText, GREEN_FONT_COLOR)
		
		local inTimeScore = inTimeInfo and inTimeInfo.dungeonScore or 0
		local overTimeScore = overtimeInfo and overtimeInfo.dungeonScore or 0
		
		if inTimeScore >= overTimeScore then
			AddScoreToTooltip(inTimeInfo)
		elseif overTimeScore > 0 then
			AddScoreToTooltip(overtimeInfo, true)
		end
	end
	
	if affixScores then
		local fastestAffixScore = TableUtil.FindMin(affixScores, function(affixScore)
			return affixScore.durationSec
		end)
	
		if fastestAffixScore then
			AddAffixScoreToTooltip(fastestAffixScore)
		end
	end
	
	GameTooltip:Show()
end

local function CreateSpellButton(parent, spellID)
	if parent.portal_bu then return end
	
	parent.HighestLevel:ClearAllPoints()
	parent.HighestLevel:SetPoint("TOP", parent, "TOP", 0, -4)
	parent.HighestLevel:SetFont(G.numFont, 25, "OUTLINE")
	parent.HighestLevel:SetShadowOffset(0, 0)
	
	parent.Icon:SetAlpha(.5)
	
	local spellID = Data[parent.mapID]
	
	local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
	button:SetAllPoints(parent)
	button:RegisterForClicks("AnyUp", "AnyDown")
	button:SetAttribute("type", "spell")
	
	-- Cooldown icon
	local cooldownIcon = button:CreateTexture(nil, "OVERLAY")
	cooldownIcon:SetSize(25, 25)
	cooldownIcon:SetPoint("BOTTOM", 0, 13)	
	button.cooldownIcon = cooldownIcon
	
	-- Cooldown text
	local cooldownText = T.createtext(button, "OVERLAY", 12, "OUTLINE", "CENTER")
	cooldownText:SetPoint("CENTER", cooldownIcon, "CENTER", 0, 0)
	button.cooldownText = cooldownText
	
	-- Name text
	local nameText = T.createtext(button, "OVERLAY", 12, "OUTLINE", "CENTER")
	nameText:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 2)
	nameText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 2)
	nameText:SetHeight(12)
	button.nameText = nameText
	
	-- Hover overlay
	local hoverOverlay = button:CreateTexture(nil, "HIGHLIGHT")
	hoverOverlay:SetBlendMode("ADD")
	hoverOverlay:SetAllPoints(button)
	hoverOverlay:SetTexture("Interface\\AddOns\\AltzUI\\media\\hover")
	button.hoverOverlay = hoverOverlay
	
	button:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	button:SetScript("OnEvent", function(self, event, ...)
		if self:IsShown() and event == "SPELL_UPDATE_COOLDOWN" then
			UpdateCooldownText(self)
		end
	end)
   
	button:SetScript("OnShow", function(self)
		UpdateCooldownText(self)
    end)
	
	button:SetScript("OnEnter", function(self)
		ChallengesDungeonIconOnEnter(parent, self)
    end)
	
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
    end)
	
	parent.portal_bu = button
end

local function UpdateSpellButton(parent)
	local button = parent.portal_bu
	local spellID = Data[parent.mapID]
	
	if spellID then
		local name = C_ChallengeMode.GetMapUIInfo(parent.mapID)
		
		button.nameText:SetText(name)
		
		if IsSpellKnown(spellID) then
			button:SetAttribute("spell", spellID)
			button.spellID = spellID		
			UpdateCooldownText(button)
			button.hoverOverlay:Show()
		else
			button:SetAttribute("spell", nil)
			button.spellID = nil
			UpdateCooldownText(button)
			button.hoverOverlay:Hide()
		end
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == "Blizzard_ChallengesUI" and ChallengesFrame then
			ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo.Score:SetFont(G.numFont, 40, "OUTLINE")
			hooksecurefunc(ChallengesFrame, "Update", function()
				for i = 1, 8 do
					local bu = ChallengesFrame.DungeonIcons[i]
					CreateSpellButton(bu)
					UpdateSpellButton(bu)
				end
			end)
		end
	end
end)


