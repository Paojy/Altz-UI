--[[--------------------------------------------------------------------
	CustomClassColors
	Change class colors without breaking parts of the Blizzard UI.
	Copyright (c) 2009–2013 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info12513
	http://www.curse.com/addons/wow/classcolors
----------------------------------------------------------------------]]

local _, ns = ...
if ns.alreadyLoaded then
	return
end

local find, format, gsub, match, sub = string.find, string.format, string.gsub, string.match, string.sub
local pairs, type = pairs, type

------------------------------------------------------------------------

local addonFuncs = { }

local blizzHexColors = { }
for class, color in pairs(RAID_CLASS_COLORS) do
	blizzHexColors[color.colorStr] = class
end

------------------------------------------------------------------------
-- ChatConfigFrame.xml

do
	local function ColorLegend(self)
		for i = 1, #self.classStrings do
			local class = CLASS_SORT_ORDER[i]
			local color = CUSTOM_CLASS_COLORS[class]
			self.classStrings[i]:SetFormattedText("|c%s%s|r\n", color.colorStr, LOCALIZED_CLASS_NAMES_MALE[class])
		end
	end
	ChatConfigChatSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
	ChatConfigChannelSettingsClassColorLegend:HookScript("OnShow", ColorLegend)
end

------------------------------------------------------------------------
-- ChatFrame.lua

function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	local chatType = sub(event, 10)
	if sub(chatType, 1, 7) == "WHISPER" then
		chatType = "WHISPER"
	elseif sub(chatType, 1, 7) == "CHANNEL" then
		chatType = "CHANNEL"..arg8
	end

	local info = ChatTypeInfo[chatType]
	if info and info.colorNameByClass and arg12 and arg12 ~= "" then
		local _, class = GetPlayerInfoByGUID(arg12)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				return format("|c%s%s|r", color.colorStr, arg2)
			end
		end
	end

	return arg2
end

do
	-- Lines 3188-3208
	-- Fix class colors in raid roster listing
	local AddMessage = {}

	local function FixClassColors(frame, message, ...)
		if type(message) == "string" and find(message, "|cff") then -- type check required for shitty addons that pass nil or non-string values
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = gsub(message, hex, color.colorStr)
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
--	CompactUnitFrame.lua

do
	local UnitClass, UnitIsConnected = UnitClass, UnitIsConnected
	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		if frame.optionTable.useClassColors and UnitIsConnected(frame.unit) then
			local _, class = UnitClass(frame.unit)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local r, g, b = color.r, color.g, color.b
					frame.healthBar:SetStatusBarColor(r, g, b)
					--frame.healthBar.r, frame.healthBar.g, frame.healthBar.g = r, g, b
				end
			end
		end
	end)
end
------------------------------------------------------------------------
--	FriendsFrame.lua

hooksecurefunc("WhoList_Update", function()
	local offset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	for i = 1, WHOS_TO_DISPLAY do
		local who = i + offset
		local _, _, _, _, _, _, class = GetWhoInfo(who)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["WhoFrameButton"..i.."Class"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFDFrame.lua

hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", function()
	for i = 1, GetNumSubgroupMembers() do
		local _, class = UnitClass("party"..i)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName("party"..i))
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFRFrame.lua

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local _, _, _, _, _, _, _, class = SearchLFGGetResults(index)
	if class then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			button.class:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

------------------------------------------------------------------------
--	LootFrame.lua

hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
	-- TODO: Find a better way of doing this... Blizzard's way is frankly quite awful,
	--       creating multiple new local tables every time the function runs. :(
	for k, playerFrame in pairs(MasterLooterFrame) do
		if type(k) == "string" and match(k, "^player%d+$") and type(playerFrame) == "table" and playerFrame.id and playerFrame.Name then
			local i = playerFrame.id
			local _, class
			if IsInRaid() then
				_, class = UnitClass("raid"..i)
			elseif i > 1 then
				_, class = UnitClass("party"..i)
			else
				_, class = UnitClass("player")
			end
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					playerFrame.Name:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	LootHistory.lua

hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, itemFrame)
	local itemID = itemFrame.itemIdx
	local rollID, _, _, done, winnerID = C_LootHistory.GetItem(itemID)
	local expanded = self.expandedRolls[rollID]
	if done and winnerID and not expanded then
		local _, class = C_LootHistory.GetPlayerInfo(itemID, winnerID)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				itemFrame.WinnerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(self, playerFrame)
	if playerFrame.playerIdx then
		local name, class = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)
		if name then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				playerFrame.PlayerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

function LootHistoryDropDown_Initialize(self)
	local info = UIDropDownMenu_CreateInfo()
	info.isTitle = 1
	info.text = MASTER_LOOTER
	info.fontObject = GameFontNormalLeft
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)

	info = UIDropDownMenu_CreateInfo()
	info.notCheckable = 1
	local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
	local color = CUSTOM_CLASS_COLORS[class]
	info.text = format(MASTER_LOOTER_GIVE_TO, format("|c%s%s|r", color.colorStr, name))
	info.func = LootHistoryDropDown_OnClick

	UIDropDownMenu_AddButton(info)
end

------------------------------------------------------------------------
--	PaperDollFrame.lua

hooksecurefunc("PaperDollFrame_SetLevel", function()
	local className, class = UnitClass("player")
	local color = CUSTOM_CLASS_COLORS[class]
	if color then
		local spec = GetSpecialization()
		if spec then
			local _, spec = GetSpecializationInfo(spec)
			if specName then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), color.colorStr, specName, className)
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), color.colorStr, className)
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidFinder.lua

hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", function()
	local _G = _G

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
				if class then
					local color = CUSTOM_CLASS_COLORS[class]
					if color then
						_G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName(unit))
					end
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidWarning.lua

do
	local AddMessage = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(frame, message, ...)
		if find(message, "|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = gsub(message, hex, color.colorStr)
			end
		end
		return AddMessage(frame, message, ...)
	end
end

------------------------------------------------------------------------
--	Blizzard_Calendar.lua

addonFuncs["Blizzard_Calendar"] = function()
	local _G = _G
	local CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame = CalendarViewEventInviteListScrollFrame, CalendarCreateEventInviteListScrollFrame
	local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
	local CalendarEventGetNumInvites, CalendarEventGetInvite = CalendarEventGetNumInvites, CalendarEventGetInvite

	hooksecurefunc("CalendarViewEventInviteListScrollFrame_Update", function()
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarViewEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarViewEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local buttonName = buttons[i]:GetName()
					_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
					_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	hooksecurefunc("CalendarCreateEventInviteListScrollFrame_Update", function()
		local _, namesReady = CalendarEventGetNumInvites()
		if not namesReady then return end

		local buttons = CalendarCreateEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarCreateEventInviteListScrollFrame)
		for i = 1, #buttons do
			local _, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local buttonName = buttons[i]:GetName()
					_G[buttonName.."Name"]:SetTextColor(color.r, color.g, color.b)
					_G[buttonName.."Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_ChallengesUI.lua

addonFuncs["Blizzard_ChallengesUI"] = function()
	local F_PLAYER_CLASS = "%s - " .. PLAYER_CLASS
	local F_PLAYER_CLASS_NO_SPEC = "%s - " .. PLAYER_CLASS_NO_SPEC

	local _G = _G
	local ChallengesFrame = ChallengesFrame
	local GetChallengeBestTimeInfo, GetChallengeBestTimeNum, GetSpecializationInfoByID = GetChallengeBestTimeInfo, GetChallengeBestTimeNum, GetSpecializationInfoByID

	local gameTooltipTextLeft = setmetatable({}, { __index = function(t, i)
		local obj = _G["GameTooltipTextLeft"..i]
		if obj then
			rawset(t, i, obj)
		end
		return obj
	end })

	hooksecurefunc("ChallengesFrameGuild_OnEnter", function(self)
		local guildTime = ChallengesFrame.details.GuildTime
		if not guildTime.hasTime then return end

		for i = 1, GetChallengeBestTimeNum(guildTime.mapID, true) do
			local name, className, class, specID = GetChallengeBestTimeInfo(guildTime.mapID, i, true)
			if class then
				local color = CUSTOM_CLASS_COLORS[class].colorStr
				if color then
					local _, specName = GetSpecializationInfoByID(specID)
					if specName and specName ~= "" then
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS, name, color, specName, className)
					else
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS_NO_SPEC, name, color, className)
					end
				end
			end
		end
	end)

	hooksecurefunc("ChallengesFrameRealm_OnEnter", function(self)
		local realmTime = ChallengesFrame.details.RealmTime
		if not realmTime.hasTime then return end

		for i = 1, GetChallengeBestTimeNum(realmTime.mapID, false) do
			local name, className, class, specID = GetChallengeBestTimeInfo(realmTime.mapID, i, false)
			if class then
				local color = CUSTOM_CLASS_COLORS[class].colorStr
				if color then
					local _, specName = GetSpecializationInfoByID(specID)
					if specName and specName ~= "" then
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS, name, color, specName, className)
					else
						gameTooltipTextLeft[i+1]:SetFormattedText(F_PLAYER_CLASS_NO_SPEC, name, color, className)
					end
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_GuildRoster.lua

addonFuncs["Blizzard_GuildUI"] = function()
	hooksecurefunc("GuildRosterButton_SetStringText", function(buttonString, text, isOnline, class)
		if isOnline and class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				buttonString:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)
end

------------------------------------------------------------------------
--	InspectPaperDollFrame.lua

addonFuncs["Blizzard_InspectUI"] = function()
	local InspectFrame, InspectLevelText = InspectFrame, InspectLevelText
	local GetSpecialization, GetSpecializationInfo, UnitClass, UnitLevel = GetSpecialization, GetSpecializationInfo, UnitClass, UnitLevel

	hooksecurefunc("InspectPaperDollFrame_SetLevel", function()
		local unit = InspectFrame.unit
		if not unit then return end

		local className, class = UnitClass(unit)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				local level = UnitLevel(unit)
				if level == -1 then
					level = "??"
				end
				local spec, specName, _ = GetSpecialization(true)
				if spec then
					_, specName = GetSpecializationInfo(spec, true)
				end
				if specName and specName ~= "" then
					InspectLevelText:SetFormattedText(PLAYER_LEVEL, level, color.colorStr, specName, className)
				else
					InspectLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, level, color.colorStr, className)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_RaidUI.lua

addonFuncs["Blizzard_RaidUI"] = function()
	local _G = _G
	local min = math.min
	local GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass = GetNumGroupMembers, GetRaidRosterInfo, IsInRaid, UnitCanCooperate, UnitClass
	local MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP = MAX_RAID_MEMBERS, MEMBERS_PER_RAID_GROUP

	hooksecurefunc("RaidGroupFrame_Update", function()
		local isRaid = IsInRaid()
		if not isRaid then return end
		for i = 1, min(GetNumGroupMembers(), MAX_RAID_MEMBERS) do
			local name, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo(i)
			if class and online and not dead and _G["RaidGroup"..subgroup].nextIndex <= MEMBERS_PER_RAID_GROUP then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					local button = _G["RaidGroupButton"..i]
					button.subframes.name:SetTextColor(color.r, color.g, color.b)
					button.subframes.class:SetTextColor(color.r, color.g, color.b)
					button.subframes.level:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	hooksecurefunc("RaidGroupFrame_UpdateHealth", function(i)
		local _, _, _, _, _, class, _, online, dead = GetRaidRosterInfo(i)
		if class and online and not dead then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				local r, g, b = color.r, color.g, color.b
				_G["RaidGroupButton"..i.."Name"]:SetTextColor(r, g, b)
				_G["RaidGroupButton"..i.."Class"]:SetTextColor(r, g, b)
				_G["RaidGroupButton"..i.."Level"]:SetTextColor(r, g, b)
			end
		end
	end)

	hooksecurefunc("RaidPullout_UpdateTarget", function(frame, button, unit, which)
		if UnitCanCooperate("player", unit) then
			if _G[frame]["show"..which] then
				local _, class = UnitClass(unit)
				if class then
					local color = class and CUSTOM_CLASS_COLORS[class]
					if color then
						_G[button..which.."Name"]:SetTextColor(color.r, color.g, color.b)
					end
				end
			end
		end
	end)

	local petowners = {}
	for i = 1, 40 do
		petowners["raidpet"..i] = "raid"..i
	end
	hooksecurefunc("RaidPulloutButton_UpdateDead", function(button, dead, class)
		if not dead then
			if class == "PETS" then
				local _
				_, class = UnitClass(petowners[button.unit])
			end
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					button.nameLabel:SetVertexColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_TradeSkillUI.lua

addonFuncs["Blizzard_TradeSkillUI"] = function()
	local TRADE_SKILL_GUILD_CRAFTERS_DISPLAYED = TRADE_SKILL_GUILD_CRAFTERS_DISPLAYED
	local FauxScrollFrame_GetOffset, TradeSkillGuildCraftersFrame = FauxScrollFrame_GetOffset, TradeSkillGuildCraftersFrame
	local GetGuildRecipeInfoPostQuery, GetGuildRecipeMember = GetGuildRecipeInfoPostQuery, GetGuildRecipeMember

	hooksecurefunc("TradeSkillGuilCraftersFrame_Update", function()
		local _, _, numMembers = GetGuildRecipeInfoPostQuery()
		local offset = FauxScrollFrame_GetOffset(TradeSkillGuildCraftersFrame)
		for i = 1, TRADE_SKILL_GUILD_CRAFTERS_DISPLAYED do
			if i > numMembers then
				break
			end
			local _, class, online = GetGuildRecipeMember(i + offset)
			if class and online then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					_G["TradeSkillGuildCrafter"..i.."Text"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
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