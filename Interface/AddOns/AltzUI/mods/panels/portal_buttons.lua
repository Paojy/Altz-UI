local T, C, L, G = unpack(select(2, ...))

local factionGroup = UnitFactionGroup("player")

local siegeID
if factionGroup == "Horde" then
    siegeID = 464256
elseif factionGroup == "Alliance" then
    siegeID = 445418
end

local Data = {
    [375] = 354464, -- 塞兹仙林的迷雾
    [505] = 445414, -- 破晨号
    [353] = siegeID, -- 围攻伯拉勒斯
    [376] = 354462, -- 通灵战潮
    [507] = 445424,	-- 格瑞姆巴托
    [501] = 445269, -- 矶石宝库
    [502] = 445416, -- 千丝之城	
    [503] = 445417, -- 回响之城
}

local function UpdateCooldownText(button)
    local spellCooldownInfo = C_Spell.GetSpellCooldown(button.spellID)

    if spellCooldownInfo then
        local startTime = spellCooldownInfo.startTime
        local duration = spellCooldownInfo.duration
        local isEnabled = spellCooldownInfo.isEnabled

        if startTime > 0 and duration > 0 and isEnabled then
            local remaining = max(0, (startTime + duration) - GetTime())

            -- Hide text and overlay if remaining time is 5 seconds or less
            if remaining > 5 then
                button.cooldownText:SetText(T.FormatTime(remaining))
            else
                button.cooldownText:SetText(T.hex_str(L["传送可用"], 0, 1, 0))
            end
        else
            button.cooldownText:SetText(T.hex_str(L["传送可用"], 0, 1, 0))
        end
    else
        button.cooldownText:SetText(T.hex_str(L["传送不可用"], 1, 0, 0))
    end
end

local function AddAffixScoreToTooltip(affixInfo)
	GameTooltip_AddBlankLineToTooltip(GameTooltip)
	GameTooltip_AddNormalLine(GameTooltip, LFG_LIST_BEST_RUN)
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
	
	local spellID = Data[parent.mapID]
	
	local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
	button:SetAllPoints(parent)
	button:RegisterForClicks("AnyUp", "AnyDown")
	button:SetAttribute("type", "spell")
	
	-- Cooldown text
	local cooldownText = T.createtext(button, "OVERLAY", 12, "OUTLINE", "CENTER")
	cooldownText:SetPoint("BOTTOM", 0, 2)
	button.cooldownText = cooldownText
	
	-- Hover overlay
	local hoverOverlay = button:CreateTexture(nil, "HIGHLIGHT")
	hoverOverlay:SetBlendMode("ADD")
	hoverOverlay:SetAllPoints(button)
	hoverOverlay:SetTexture("Interface\\AddOns\\AltzUI\\media\\hover")

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
	
	if IsSpellKnown(spellID) then
		--print("Show", C_ChallengeMode.GetMapUIInfo(parent.mapID))
		button:Show()
		button:SetAttribute("spell", spellID)
		button.spellID = spellID
		UpdateCooldownText(button)
	else
		--print("Hide", C_ChallengeMode.GetMapUIInfo(parent.mapID))
		button:Hide()
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == "Blizzard_ChallengesUI" and ChallengesFrame then
			ChallengesFrame:HookScript("OnShow", function(self)
				for i = 1, 8 do
					local bu = self.DungeonIcons[i]
					CreateSpellButton(bu)
					UpdateSpellButton(bu)
				end
			end)
		end
	end
end)


