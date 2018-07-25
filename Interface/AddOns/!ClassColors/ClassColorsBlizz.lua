--[[--------------------------------------------------------------------
	!ClassColors
	Change class colors without breaking the Blizzard UI.
	Copyright 2009-2018 Phanx <addons@phanx.net>. All rights reserved.
	https://github.com/phanx-wow/ClassColors
	https://www.curseforge.com/wow/addons/classcolors
	https://www.wowinterface.com/downloads/info12513-ClassColors.html
----------------------------------------------------------------------]]
-- ref: https://www.townlong-yak.com/globe/wut/#q:RAID_CLASS_COLORS

local _, ns = ...
if ns.alreadyLoaded then
	return
end

local strfind, format, gsub, strmatch, strsub = string.find, string.format, string.gsub, string.match, string.sub
local pairs, type = pairs, type

------------------------------------------------------------------------

local addonFuncs = {}

local blizzHexColors = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	blizzHexColors[color.colorStr] = class
end

------------------------------------------------------------------------
-- Blizzard_Calendar/Blizzard_Calendar.lua
-- 7.3.0.24920
-- 3320, 4084

addonFuncs["Blizzard_Calendar"] = function()
	local _G = _G
	local CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame = CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame
	local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
	local CalendarEventGetNumInvites, CalendarEventGetInvite = CalendarEventGetNumInvites, CalendarEventGetInvite

	hooksecurefunc("CalendarViewEventInviteListScrollFrame_Update", function() -- 3385
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarViewEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarViewEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				local buttonName = buttons[i]:GetName()
				_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
				_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)

	hooksecurefunc("CalendarCreateEventInviteListScrollFrame_Update", function() -- 4149
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarCreateEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarCreateEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				local buttonName = buttons[i]:GetName()
				_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
				_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end

------------------------------------------------------------------------
-- Blizzard_CollectionsUI/Blizzard_HeirloomCollection.lua
-- 7.3.0.25021
-- 746

addonFuncs["Blizzard_Collections"] = function()
	local NO_CLASS_FILTER = 0
	local NO_SPEC_FILTER = 0

	function HeirloomsJournal:UpdateClassFilterDropDownText() -- 746
		local text
		local classFilter, specFilter = C_Heirloom.GetClassAndSpecFilters()
		if classFilter == NO_CLASS_FILTER then
			text = ALL_CLASSES
		else
			local className, classTag = GetClassInfoByID(classFilter)
			local classColorStr = CUSTOM_CLASS_COLORS[classTag].colorStr
			if specFilter == NO_SPEC_FILTER then
				text = HEIRLOOMS_CLASS_FILTER_FORMAT:format(classColorStr, className)
			else
				local specName = GetSpecializationNameForSpecID(specFilter)
				text = HEIRLOOMS_CLASS_SPEC_FILTER_FORMAT:format(classColorStr, className, specName)
			end
		end
		UIDropDownMenu_SetText(self.classDropDown, text)
	end
end

------------------------------------------------------------------------
-- Blizzard_Commentator/CommentatorCooldownDisplay.lua
-- 7.3.0.25021
-- 156
-- Blizzard_Commentator/UnitFrame.lua
-- 7.3.0.25021
-- 208

addonFuncs["Blizzard_Commentator"] = function()
	local hookedCooldownFrames = {}

	local function setCooldownClass(self, class)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if class then
			self.Name:SetVertexColor(color.r, color.g, color.b, 1.0)
		end
	end

	local function postAcquireCooldown(self)
		for frame in next, self.activeObjects do
			if not hookedCooldownFrames[frame] then
				hooksecurefunc(frame, "SetClass", setCooldownClass)
				hookedCooldownFrames[frame] = true
			end
		end
	end

	hooksecurefunc(CommentatorCooldownDisplayFrame.TeamFrame1.playerRowPool, "Acquire", postAcquireCooldown)
	hooksecurefunc(CommentatorCooldownDisplayFrame.TeamFrame2.playerRowPool, "Acquire", postAcquireCooldown)

	local function setUnitFrameClass(self, class)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if color then
			self.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1)
		end
	end

	-- PvPCommentatorMixin:OnLoad()
	for teamIndex, frames in pairs(PvPCommentator.unitFrames) do
		for playerIndex, frame in pairs(frames) do
			hooksecurefunc(frame, "SetClass", setUnitFrameClass)
		end
	end
end

------------------------------------------------------------------------
-- Blizzard_GuildUI/Blizzard_GuildRoster.lua
-- 7.3.0.25021
-- 120

addonFuncs["Blizzard_GuildUI"] = function() -- 120
	hooksecurefunc("GuildRosterButton_SetStringText", function(buttonString, text, isOnline, class)
		local color = isOnline and class and CUSTOM_CLASS_COLORS[class]
		if color then
			buttonString:SetTextColor(color.r, color.g, color.b)
		end
	end)
end

------------------------------------------------------------------------
-- Blizzard_InspectUI/InspectPaperDollFrame.lua
-- 7.3.0.25021
-- 34

addonFuncs["Blizzard_InspectUI"] = function()
	hooksecurefunc("InspectPaperDollFrame_SetLevel", function() -- 34
		local unit = InspectFrame.unit
		if not unit then return end

		local className, class = UnitClass(unit)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if not color then return end

		local spec, specName = GetInspectSpecialization(unit)
		if spec then
			spec, specName = GetSpecializationInfoByID(spec)
		end

		local level, effectiveLevel = UnitLevel(unit), UnitEffectiveLevel(unit)
		if level == -1 or effectiveLevel == -1 then
			level = "??"
		elseif effectiveLevel ~= 1 then
			level = EFFECTIVE_LEVEL_FORMAT:format(effectiveLevel, level)
		end

		if specName and specName ~= "" then
			InspectLevelText:SetFormattedText(PLAYER_LEVEL, level, color.colorStr, specName, className)
		else
			InspectLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, level, color.colorStr, className)
		end
	end)
end

------------------------------------------------------------------------
-- Blizzard_RaidUI/Blizzard_RaidUI.lua
-- 7.3.0.25021
-- 374, 551, 736, 1103

addonFuncs["Blizzard_RaidUI"] = function()
	local _G = _G
	local min = math.min
	local GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass = GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass
	local MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP = MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP

	hooksecurefunc("RaidGroupFrame_Update", function() -- 371
		local isRaid = IsInRaid()
		if not isRaid then return end
		for i = 1, min(GetNumGroupMembers(), MAX_RAID_MEMBERS) do
			local name, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo(i)
			local color = online and not dead and _G["RaidGroup"..subgroup].nextIndex <= MEMBERS_PER_RAID_GROUP and class and CUSTOM_CLASS_COLORS[class]
			if color then
				local button = _G["RaidGroupButton"..i]
				button.subframes.name:SetTextColor(color.r, color.g, color.b)
				button.subframes.class:SetTextColor(color.r, color.g, color.b)
				button.subframes.level:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)

	hooksecurefunc("RaidGroupFrame_UpdateHealth", function(i) -- 548
		local _, _, _, _, _, class, _, online, dead = GetRaidRosterInfo(i)
		local color = online and not dead and class and CUSTOM_CLASS_COLORS[class]
		if color then
			local r, g, b = color.r, color.g, color.b
			_G["RaidGroupButton"..i.."Name"]:SetTextColor(r, g, b)
			_G["RaidGroupButton"..i.."Class"]:SetTextColor(r, g, b)
			_G["RaidGroupButton"..i.."Level"]:SetTextColor(r, g, b)
		end
	end)

	hooksecurefunc("RaidPullout_UpdateTarget", function(frame, button, unit, which) -- 760
		if _G[frame]["show"..which] and UnitCanCooperate("player", unit) then
			local _, class = UnitClass(unit)
			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				_G[button..which.."Name"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)

	local petowners = {}
	for i = 1, 40 do
		petowners["raidpet"..i] = "raid"..i
	end
	hooksecurefunc("RaidPulloutButton_UpdateDead", function(button, dead, class) -- 1100
		local color = not dead and class and CUSTOM_CLASS_COLORS[class]
		if color then
			if class == "PETS" then
				class, class = UnitClass(petowners[button.unit])
			end
			button.nameLabel:SetVertexColor(color.r, color.g, color.b)
		end
	end)
end

------------------------------------------------------------------------
-- Blizzard_StoreUISecure.lua

-- RAID_CLASS_COLORS is referenced several times in here, but it is
-- forbidden to addons, so there's nothing we can do about it.

------------------------------------------------------------------------
-- Blizzard_TradeSkillUI/Blizzard_TradeSkillDetails.lua
-- 7.3.0.25021
-- 469, 470

addonFuncs["Blizzard_TradeSkillUI"] = function()
	-- TradeSkillGuildListingMixin:Refresh()
	hooksecurefunc(TradeSkillFrame.DetailsFrame.GuildFrame, "Refresh", function(self) -- 470, 471
		if self.waitingOnData then return end

		local _, _, numMembers = GetGuildRecipeInfoPostQuery()
		local offset = FauxScrollFrame_GetOffset(self.Container.ScrollFrame)
		for i, craftersButton in ipairs(self.Container.ScrollFrame.buttons) do
			local dataIndex = offset + i
			if dataIndex > numMembers then
				break
			end

			local _, _, class, online = GetGuildRecipeMember(i + offset)
			local color = online and class and CUSTOM_CLASS_COLORS[class]
			if color then
				craftersButton.Text:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end

------------------------------------------------------------------------
-- FrameXML/ChatConfigFrame.xml
-- 7.3.0.25021
-- 134

do
	local function ColorLegend(self)
		for i = 1, #self.classStrings do
			local class = CLASS_SORT_ORDER[i]
			local color = CUSTOM_CLASS_COLORS[class]
			self.classStrings[i]:SetFormattedText("|c%s%s|r\n", color.colorStr, LOCALIZED_CLASS_NAMES_MALE[class])
		end
	end
	--ChatConfigChatSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
	--ChatConfigChannelSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
end

------------------------------------------------------------------------
-- FrameXML/ChatFrame.lua
-- 7.3.0.25021
-- 2962, 3289

function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	if not arg2 then
		return arg2
	end

	local chatType = strsub(event, 10)
	if strsub(chatType, 1, 7) == "WHISPER" then
		chatType = "WHISPER"
	elseif strsub(chatType, 1, 7) == "CHANNEL" then
		chatType = "CHANNEL"..arg8
	end

	if chatType == "GUILD" then
		arg2 = Ambiguate(arg2, "guild")
	else
		arg2 = Ambiguate(arg2, "none")
	end

	local info = ChatTypeInfo[chatType]
	if info and info.colorNameByClass and arg12 and arg12 ~= "" and arg12 ~= 0 then
		local _, class = GetPlayerInfoByGUID(arg12)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if color then
			return format("|c%s%s|r", color.colorStr, arg2)
		end
	end

	return arg2
end

do
	local AddMessage = {}

	local function FixClassColors(frame, message, ...) -- 3174
		if type(message) == "string" and strfind(message, "|cff") then -- type check required for shitty addons that pass nil or non-string values
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = color and gsub(message, hex, color.colorStr) or message -- color check required for Warmup, maybe others
			end
		end
		return AddMessage[frame](frame, message, ...)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		AddMessage[frame] = frame.AddMessage
		frame.AddMessage = FixClassColors
	end
end

------------------------------------------------------------------------
-- FrameXML/CompactUnitFrame.lua
-- 7.3.0.25021
-- 374

do
	local UnitClass, UnitIsConnected, UnitIsPlayer
	    = UnitClass, UnitIsConnected, UnitIsPlayer

	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame) -- 371
		local opts = frame.optionTable
		if opts.healthBarColorOverride or not opts.useClassColors
		or not (opts.allowClassColorsForNPCs or UnitIsPlayer(frame.unit))
		or not UnitIsConnected(frame.unit) then
			return
		end

		local _, class = UnitClass(frame.unit)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if not color then return end

		frame.healthBar:SetStatusBarColor(color.r, color.g, color.b)
		if frame.optionTable.colorHealthWithExtendedColors then
			frame.selectionHighlight:SetVertexColor(color.r, color.g, color.b)
		end
	end)
end

------------------------------------------------------------------------
-- FrameXML/FriendsFrame.lua
-- 7.3.0.25021
-- 743

hooksecurefunc("WhoList_Update", function()
	local offset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	for i = 1, WHOS_TO_DISPLAY do
		local _, _, _, _, _, _, class = GetWhoInfo(i + offset)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if color then
			_G["WhoFrameButton"..i.."Class"]:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

------------------------------------------------------------------------
-- FrameXML/LFDFrame.lua
-- 7.3.0.25021
-- 496

hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", function()
	for i = 1, GetNumSubgroupMembers() do
		local _, class = UnitClass("party"..i)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if color then
			local name, server = UnitName("party"..i) -- skip call to GetUnitName wrapper func
			if server and server ~= "" then
				_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s-%s|r", color.colorStr, name, server)
			else
				_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s|r", color.colorStr, name)
			end
		end
	end
end)

------------------------------------------------------------------------
-- FrameXML/LFGFrame.lua
-- 7.3.0.25021
-- 2070

hooksecurefunc("LFGCooldownCover_Update", function(self)
	local nextIndex, numPlayers, prefix = 1
	if IsInRaid() then
		numPlayers = GetNumGroupMembers()
		prefix = "raid"
	else
		numPlayers = GetNumSubgroupMembers()
		prefix = "party"
	end

	for i = 1, numPlayers do
		if nextIndex > #self.Names then
			break
		end

		local unit = prefix..i
		if self.showAll or (self.showCooldown and UnitHasLFGRandomCooldown(unit)) or UnitHasLFGDeserter(unit) then
			local _, class = UnitName(unit)
			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				local name, server = UnitName(unit) -- skip call to GetUnitName wrapper func
				if server and server ~= "" then
					self.Names[nextIndex]:SetFormattedText("|c%s%s-%s|r", color.colorStr, name, server)
				else
					self.Names[nextIndex]:SetFormattedText("|c%s%s|r", color.colorStr, name)
				end
			end
			nextIndex = nextIndex + 1
		end
	end
end)

------------------------------------------------------------------------
-- FrameXML/LFGList.lua
-- 7.3.0.25021
-- 1479, 1558, 3170

local grayedOutStatus = {
	failed = true,
	cancelled = true,
	declined = true,
	declined_full = true,
	declined_delisted = true,
	invitedeclined = true,
	timedout = true,
}

hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", function(member, appID, memberIdx, status, pendingStatus)
	if not pendingStatus and grayedOutStatus[status] then
		-- grayedOut
		return
	end

	local name, class = C_LFGList.GetApplicantMemberInfo(appID, memberIdx)
	local color = name and class and CUSTOM_CLASS_COLORS[class]
	if color then
		member.Name:SetTextColor(color.r, color.g, color.b)
	end
end)

hooksecurefunc("LFGListApplicantMember_OnEnter", function(self) -- 1551
	local applicantID = self:GetParent().applicantID
	local memberIdx = self.memberIdx
	local name, class = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
	local color = name and class and CUSTOM_CLASS_COLORS[class]
	if color then
		GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
	end
end)

local LFG_LIST_TOOLTIP_MEMBERS_SIMPLE = gsub(LFG_LIST_TOOLTIP_MEMBERS_SIMPLE, "%%d", "%%d+")

hooksecurefunc("LFGListSearchEntry_OnEnter", function(self) -- 3128
	local resultID = self.resultID
	local _, activityID, _, _, _, _, _, _, _, _, _, _, numMembers = C_LFGList.GetSearchResultInfo(resultID)
	local _, _, _, _, _, _, _, _, displayType = C_LFGList.GetActivityInfo(activityID)
	if displayType ~= LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then return end
	local start
	for i = 4, GameTooltip:NumLines() do
		if strfind(_G["GameTooltipTextLeft"..i]:GetText(), LFG_LIST_TOOLTIP_MEMBERS_SIMPLE) then
			start = i
			break
		end
	end
	if start then
		for i = 1, numMembers do
			local _, class = C_LFGList.GetSearchResultMemberInfo(resultID, i)
			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				_G["GameTooltipTextLeft"..(start+i)]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)

------------------------------------------------------------------------
-- FrameXML/LFRFrame.lua
-- 7.3.0.25021
-- 505

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local _, _, _, _, _, _, _, class = SearchLFGGetResults(index)
	local color = class and CUSTOM_CLASS_COLORS[class]
	if color then
		button.class:SetTextColor(color.r, color.g, color.b)
	end
end)

------------------------------------------------------------------------
-- FrameXML/LevelUpDisplay.lua
-- 7.3.0.25021
-- 1359

hooksecurefunc("BossBanner_ConfigureLootFrame", function(lootFrame, data)
		local color = CUSTOM_CLASS_COLORS[data.className]
		lootFrame.PlayerName:SetTextColor(color.r, color.g, color.b)
end)

------------------------------------------------------------------------
-- FrameXML/LootFrame.lua
-- 7.3.0.25021
-- 918

hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
	-- TODO: Find a better way of doing this... Blizzard's way is frankly quite awful,
	--       creating multiple new local tables every time the function runs. :(
	for k, playerFrame in pairs(MasterLooterFrame) do
		if type(k) == "string" and strmatch(k, "^player%d+$") and type(playerFrame) == "table" and playerFrame.id and playerFrame.Name then
			local i = playerFrame.id
			local _, class
			if IsInRaid() then
				_, class = UnitClass("raid"..i)
			elseif i > 1 then
				_, class = UnitClass("party"..i)
			else
				_, class = UnitClass("player")
			end

			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				playerFrame.Name:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)

------------------------------------------------------------------------
-- FrameXML/LootHistory.lua
-- 7.3.0.25021
-- 242, 286, 419

hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, itemFrame) -- 242
	local itemID = itemFrame.itemIdx
	local rollID, _, _, done, winnerID = C_LootHistory.GetItem(itemID)
	local expanded = self.expandedRolls[rollID]
	if done and winnerID and not expanded then
		local _, class = C_LootHistory.GetPlayerInfo(itemID, winnerID)
		local color = class and CUSTOM_CLASS_COLORS[class]
		if color then
			itemFrame.WinnerName:SetVertexColor(color.r, color.g, color.b)
		end
	end
end)

hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(self, playerFrame) -- 286
	if playerFrame.playerIdx then
		local name, class = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)
		local color = name and class and CUSTOM_CLASS_COLORS[class]
		if color then
			playerFrame.PlayerName:SetVertexColor(color.r, color.g, color.b)
		end
	end
end)

function LootHistoryDropDown_Initialize(self) -- 419
	local info = UIDropDownMenu_CreateInfo()
	info.text = MASTER_LOOTER
	info.fontObject = GameFontNormalLeft
	info.isTitle = 1
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)

	local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
	local color = CUSTOM_CLASS_COLORS[class]

	info = UIDropDownMenu_CreateInfo()
	info.text = format(MASTER_LOOTER_GIVE_TO, format("|c%s%s|r", color.colorStr, name))
	info.func = LootHistoryDropDown_OnClick
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)
end

------------------------------------------------------------------------
-- FrameXML/PaperDollFrame.lua
-- 7.3.0.25021
-- 418

hooksecurefunc("PaperDollFrame_SetLevel", function() -- 418
	local className, class = UnitClass("player")
	local color = CUSTOM_CLASS_COLORS[class].colorStr

	local primaryTalentTree, specName = GetSpecialization()
	if primaryTalentTree then
		primaryTalentTree, specName = GetSpecializationInfo(primaryTalentTree)
	end

	local level = UnitLevel("player")
	local effectiveLevel = UnitEffectiveLevel("player")
	if effectiveLevel ~= level then
		level = EFFECTIVE_LEVEL_FORMAT:format(effectiveLevel, level)
	end

	if specName and specName ~= "" then
		CharacterLevelText:SetFormattedText(PLAYER_LEVEL, level, color, specName, className)
	else
		CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, level, color, className)
	end
end)

------------------------------------------------------------------------
-- FrameXML/RaidFinder.lua
-- 7.3.0.25021
-- 488

hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", function() -- 488
	local prefix, members
	if IsInRaid() then
		prefix, members = "raid", GetNumGroupMembers()
	else
		prefix, members = "party", GetNumSubgroupMembers()
	end

	local cooldowns = 0
	for i = 1, members do
		local unit = prefix .. i
		if UnitHasLFGDeserter(unit) and not UnitIsUnit(unit, "player") then
			cooldowns = cooldowns + 1
			if cooldowns <= MAX_RAID_FINDER_COOLDOWN_NAMES then
				local _, class = UnitClass(unit)
				local color = class and CUSTOM_CLASS_COLORS[class]
				if color then
					_G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName(unit))
				end
			end
		end
	end
end)

------------------------------------------------------------------------
-- FrameXML/RaidWarning.lua
-- 7.3.0.25021
-- 130

do
	local AddMessage = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(frame, message, ...) -- 130
		if strfind(message, "|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = gsub(message, hex, color.colorStr)
			end
		end
		return AddMessage(frame, message, ...)
	end
end

------------------------------------------------------------------------
-- FrameXML/StaticPopup.lua (via GetClassColor)
-- 7.3.0.25021
-- 1600
-- 7.2.0.23911
-- 1600

hooksecurefunc("StaticPopup_OnUpdate", function(self, elapsed)
	if self.which ~= "GROUP_INVITE_CONFIRMATION" or self.timeLeft <= 0 then return end

	if not self.linkRegion or not self.nextUpdateTime then return end
	if self.nextUpdateTime > GetTime() then return end

	local _, _, guid = GetInviteConfirmationInfo(self.data)
	local _, class, _, _, _, name = GetPlayerInfoByGUID(guid)
	local color = class and CUSTOM_CLASS_COLORS[class]
	if color then
		GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", color.colorStr, name)
	end
end)

------------------------------------------------------------------------
-- FrameXML/UnitPositionFrameTemplates.lua (via GetClassColor)
-- 7.3.0.25021
-- 185
-- 7.2.0.23835
-- 200

-- UnitPositionFrameMixin
-- --> UnitPositionFrameTemplate
--     --> GroupMembersPinTemplate (Blizzard_SharedMapDataProviders/GroupMembersDataProvider.xml)
--     --> BattlefieldMinimapUnitPositionFrame (Blizzard_BattlefieldMinimap/Blizzard_BattlefieldMinimap.xml)
--         --> self:GetMap():SetPinTemplateType("GroupMembersPinTemplate", "UnitPositionFrame")
--     --> WorldMapUnitPositionFrame (FrameXML/WorldMapFrame.xml)

local function UnitPositionFrameMixin_GetUnitColor(self, timeNow, unit, appearanceData)
	if appearanceData.shouldShow then
		local r, g, b  = 1, 1, 1

		if appearanceData.useClassColor then
			local _, class = UnitClass(unit)
			local color = class and CUSTOM_CLASS_COLORS[class]
			if color then
				r, g, b = color.r, color.g, color.b
				--ChatFrame3:AddMessage(string.join(' ', tostringall('GetUnitColor', unit, class)))
			end
		end

		return true, CheckColorOverrideForPVPInactive(unit, timeNow, r, g, b)
	end

	return false
end

addonFuncs["Blizzard_BattlefieldMinimap"] = function()
	BattlefieldMinimapUnitPositionFrame.GetUnitColor = UnitPositionFrameMixin_GetUnitColor
end

------------------------------------------------------------------------

local numAddons = 0

for addon, func in pairs(addonFuncs) do
	if IsAddOnLoaded(addon) then
		addonFuncs[addon] = nil
		func()
	else
		numAddons = numAddons + 1
	end
end

if numAddons > 0 then
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		local func = addonFuncs[addon]
		if func then
			addonFuncs[addon] = nil
			numAddons = numAddons - 1
			func()
		end
		if numAddons == 0 then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetScript("OnEvent", nil)
		end
	end)
end
