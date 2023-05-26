local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

if not aCoreCDB["TooltipOptions"]["enabletip"] then return end

local combathide = aCoreCDB["TooltipOptions"]["combathide"]

local you = "<You>"
local boss = "Boss"

local classification = {
    elite = "+",
    rare = " Rare",
    rareelite = " Rare+",
}

local hex = function(r, g, b)
    return format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end

local function unitColor(unit)
    local r, g, b = 1, 1, 1
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        r, g, b = G.Ccolors[class].r, G.Ccolors[class].g, G.Ccolors[class].b
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            r, g, b = FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b 
        end
    end
    return r, g, b
end

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(you)
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)		
	local spellID = select(10,UnitAura(...))
	
	if spellID then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format(G.classcolor.."%s|r", spellID))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetAction", function(self, action)
	local actionType, actionID = GetActionInfo(action)
	if actionType == "spell" or actionType == "companion" then
		if actionID then
			self:AddLine(" ")
			self:AddDoubleLine("SpellID:", format(G.classcolor.."%s|r", actionID))
			self:Show()
		end
	elseif actionType == "item" then
		if actionID then
			self:AddLine(" ")
			self:AddDoubleLine("ItemID:", format(G.classcolor.."%s|r", actionID))
			self:Show()
		end
	end
end)

local isSpells = {
	["GetSpellByID"] = true,
	["GetSpellBookItem"] = true, -- taint in 46092
	["GetTraitEntry"] = true,
	["GetMountBySpellID"] = true,
}

local isItems = {
	["GetBagItem"] = true,
	["GetInventoryItem"] = true,
	["GetMerchantItem"] = true,
	["GetBuybackItem"] = true,
	["GetItemByID"] = true,
	["GetRecipeResultItem"] = true,
	["GetRecipeReagentItem"] = true,
	["GetToyByItemID"] = true,
	["GetHeirloomByItemID"] = true,
	["GetHyperlink"] = true,
	["GetItemKey"] = true,
}

local isUnit = {
	["GetUnit"] = true,
	["GetWorldCursor"] = true,
}

hooksecurefunc(GameTooltip, "ProcessLines", function(self)
	local getterName = self.processingInfo and self.processingInfo.getterName
	--print(getterName)
	if isSpells[getterName] then
		local spellID = select(2, self:GetSpell())
		if spellID then
			self:AddLine(" ")
			self:AddDoubleLine("SpellID:", format(G.classcolor.."%s|r", spellID))
			self:Show()
		end
	elseif isItems[getterName] then
		local link = select(2, self:GetItem())
		if link then
			local itemId = GetItemInfoFromHyperlink(link)
			local keystone = strmatch(link, "|Hkeystone:([0-9]+):")
			if keystone then itemId = tonumber(keystone) end
			
			self:AddLine(" ")
			self:AddDoubleLine("ItemID:", format(G.classcolor.."%s|r", itemId))
			self:Show()
		end
	elseif isUnit[getterName] then
		local name, unit = self:GetUnit()
		if unit then
			if combathide and InCombatLockdown() then
				return self:Hide()
			end
				
			local r, g, b = unitColor(unit)
			local ricon = GetRaidTargetIndex(unit)

			if ricon then
				local text = GameTooltipTextLeft1:GetText()
				GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
			end
				
			if UnitIsPlayer(unit) then
				self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or UnitIsDND(unit) and CHAT_FLAG_DND or not UnitIsConnected(unit) and "<DC>" or ""))
				
				-- 服务器
				local _, realm = UnitName(unit)
				if realm then
					local text = GameTooltipTextLeft1:GetText()
					text = text:gsub("- "..realm, "")
					if text then GameTooltipTextLeft1:SetText(text) end
				end
				
				-- 头衔
				local title = UnitPVPName(unit)
				if title then
					local text = GameTooltipTextLeft1:GetText()
					title = title:gsub(name, "")
					text = text:gsub(title, "")
					if text then GameTooltipTextLeft1:SetText(text) end
				end
				
				-- 公会
				local unitGuild, tmp, tmp2 = GetGuildInfo(unit)
				local text = GameTooltipTextLeft2:GetText()
				if tmp then
					--tmp2=tmp2+1
					GameTooltipTextLeft2:SetText("<"..text..">  "..tmp.."  ("..tmp2..")")
				end
				
				if IsShiftKeyDown() then
					local summary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
					
					local score = summary and summary.currentSeasonScore
					if score and score > 0 then
						local color = C_ChallengeMode.GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
						GameTooltip:AddDoubleLine(L["大秘境评分"], score, 1, 1, 1, color.r, color.g, color.b)
					end
					
					local runs = summary and summary.runs
					if runs then
						GameTooltip:AddLine("     ")
						GameTooltip:AddDoubleLine(L["副本"], L["评分层数"], 1, 1, 1, 1, 1, 1)
						for i, info in pairs(runs) do
							local map = C_ChallengeMode.GetMapUIInfo(info.challengeModeID)
							GameTooltip:AddDoubleLine(map, info.mapScore.."("..info.bestRunLevel..")", 1, 1, 1, 1, 1, 1)
						end
					end
				end
			end			
			
			local alive = not UnitIsDeadOrGhost(unit)
			local level = UnitLevel(unit)
		
			if level then
				if not UnitIsWildBattlePet(unit) then
					local unitClass = UnitIsPlayer(unit) and hex(r, g, b)..UnitClass(unit).."|r" or ""
					local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
					local diff = GetQuestDifficultyColor(level)
		
					if level == -1 then
						level = "|cffff0000"..boss
					end
		
					local classify = UnitClassification(unit)
					local textLevel = ("%s%s%s|r"):format(hex(diff.r, diff.g, diff.b), tostring(level), classification[classify] or "")
		
					for i=2, self:NumLines() do
						local tiptext = _G["GameTooltipTextLeft"..i]
						if tiptext:GetText():find(LEVEL) then
							if alive then
								tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
							else
								tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
							end
						end
		
						if tiptext:GetText():find(PVP) then
							tiptext:SetText(nil)
						end	
					end
				end
			end
		
			if not alive then
				GameTooltipStatusBar:Hide()
			end
			
			if UnitExists(unit.."target") then
				local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
				self:AddLine(tartext)
			end
			
			GameTooltipStatusBar:SetStatusBarColor(r, g, b)
		else
			for i=2, self:NumLines() do
				local tiptext = _G["GameTooltipTextLeft"..i]
		
				if tiptext:GetText():find(PVP) then
					tiptext:SetText(nil)
				end
		
				GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
			end
		end
	end
end)

-- GameTooltipStatusBar

GameTooltipStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
T.createBackdrop(GameTooltipStatusBar, GameTooltipStatusBar, 1)
 
GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = T.createtext(self, "OVERLAY", 12, "OUTLINE", "CENTER")
			self.text:SetPoint"BOTTOM"
        end
        self.text:Show()
        local hp = T.ShortValue(min).." / "..T.ShortValue(max)
        self.text:SetText(hp)
    end
end)