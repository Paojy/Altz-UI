local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.minchat then return end

--[[			Chicchai
]]--	by Lolzen & Cargor (EU-Nozdormu)

-- Configuration
local maxHeight = cfg.maxHeight				-- How high the chat frames are when maximized
local animTime = 0.7				-- How lang the animation takes (in seconds)
local minimizeTime = cfg.minimizeTime				-- Minimize after X seconds
local minimizedLines = cfg.minimizedLines			-- Number of chat messages to show in minimized state

local MaximizeOnEnter = true		-- Maximize when entering chat frame, minimize when leaving
local WaitAfterEnter = 0			-- Wait X seconds after entering before maximizing
local WaitAfterLeave = 1			-- Wait X seconds after leaving before minimizing

local LockInCombat = cfg.LockInCombat		-- Do not maximize in combat

local MaximizeCombatLog = true		-- When the combat log is selected, it will be maximized

-- Modify this to maximize only on special channels
-- comment/remove it to react on all channels
-- you still need the "channel"-event on your chat frame!
local channelNumbers = {
	[1] = false,
	[2] = false,
	[3]  = false,
}

local ChatFrameConfig = {	-- Events which maximize the chat for the different windows
	["ChatFrame1"] = {
		"say", "emote", "text_emote",
		"party", "party_leader", "party_guide",
		"whisper",
		"guild", "officer",
		"battleground", "battleground_leader",
		"raid", "raid_leader", "raid_warning",
		"bn_whisper",
		"bn_conversation",
		"bn_broadcast",
	},
	["ChatFrame3"] = true,
    ["ChatFrame4"] = true,
    ["ChatFrame5"] = true,
    ["ChatFrame6"] = true,
    ["ChatFrame7"] = true,	-- "true" just makes this frame available for minimizing and registers it with Chicchai
}

--[[
	REFERENCE LIST
	These are the available chat events for ChatFrameConfig
		say, yell, emote, text_emote,
		party, party_leader, party_guide,
		whisper, whisper_inform, afk, dnd, ignored,
		guild, officer,
		channel, channel_join, channel_leave, channel_list, channel_notice, channel_notice_user,
		battleground, battleground_leader,
		raid, raid_leader, raid_warning,

		bn_whisper, bn_whisper_inform,
		bn_conversation, bn_conversation_notice, bn_conversation_list,
		bn_alert,
		bn_broadcast, bn_broadcast_inform,
		bn_inline_toast_alert, bn_inline_toast_broadcast, bn_inline_toast_broadcast_inform, bn_inline_toast_conversation,

		system, achievement, guild_achievement,
		bg_system_neutral, bg_system_alliance, bg_system_horde,
		monster_say, monster_party, monster_yell, monster_whisper, monster_emote,
		raid_boss_whisper, raid_boss_emote,
		skill, loot, money, opening, tradeskills, pet_info, combat_misc_info, combat_xp_gain, combat_honor_gain, combat_faction_change,
]]
-- Configuration End
-- Do not change anything under this line except you know what you're doing (:



local select = select
local UP, DOWN = 1, -1

local function getMinHeight(self)
	local minHeight = 0
	for i=1, minimizedLines do
		local line = select(9+i, self:GetRegions())
		if(line) then
			minHeight = minHeight + line:GetHeight() + 2.5
		end
	end
	if(minHeight == 0) then
		minHeight = select(2, self:GetFont()) + 2.5
	end
	return minHeight
end

local function Update(self, elapsed)
	if(self.WaitTime) then
		self.WaitTime = self.WaitTime - elapsed
		if(self.WaitTime > 0) then return end
		self.WaitTime = nil
		if(self.Frozen) then return self:Hide() end
	end

	self.State = nil

	self.TimeRunning = self.TimeRunning + elapsed
	local animPercent = min(self.TimeRunning/animTime, 1)

	local heightPercent = self.Animate == DOWN and 1-animPercent or animPercent

	local minHeight = getMinHeight(self.Frame)
	self.Frame:SetHeight(minHeight + (maxHeight-minHeight) * heightPercent)

	if(animPercent >= 1) then
		self.State = self.Animate
		self.Animate = nil
		self.TimeRunning = nil
		self:Hide()
		if(self.finishedFunc) then self:finishedFunc() end
	end
end

local function getChicchai(self)
	if(self:GetObjectType() == "Frame") then self = self.Frame  end
	if(self.isDocked) then self = GENERAL_CHAT_DOCK.DOCKED_CHAT_FRAMES[1] end
	return self.Chicchai
end

local function SetFrozen(self, isFrozen)
	getChicchai(self).Frozen = isFrozen
end

local function Animate(self, dir, waitTime, finishedFunc)
	local self = getChicchai(self)
	if(self.Frozen) then return end
	if(self.Animate == dir or self.State == dir and not self.Animate) then return end

	if(self.Animate == -dir) then
		self.TimeRunning = animTime - self.TimeRunning
	else
		self.TimeRunning = 0
	end
	self.WaitTime = waitTime
	self.Animate = dir
	self.finishedFunc = finishedFunc
	self:Show()
end

local function Maximize(self) Animate(self, UP) end
local function Minimize(self) Animate(self, DOWN) end

local function MinimizeAfterWait(self)
	Animate(self, DOWN, minimizeTime)
end

local CheckEnterLeave
if(MaximizeOnEnter) then
	CheckEnterLeave = function(self)
		self = getChicchai(self)
		if(MouseIsOver(self.Frame) and not self.wasOver) then
			self.wasOver = true
			Animate(self, UP, WaitAfterEnter)
		elseif(self.wasOver and not MouseIsOver(self.Frame)) then
			self.wasOver = nil
			Animate(self, DOWN, WaitAfterLeave)
		end
	end
end

if(MaximizeCombatLog) then
	hooksecurefunc("FCF_Tab_OnClick", function(self)
		local frame = getChicchai(ChatFrame2)
		if(not frame) then return end

		if(self == ChatFrame2Tab) then
			Animate(frame, UP)
			SetFrozen(frame, true)
		elseif(frame.Frozen) then
			SetFrozen(frame, nil)
			Animate(frame, DOWN)
		end
	end)
end

local function updateHeight(self)
	getChicchai(self)
	if(self.State ~= DOWN) then return end
	self.Frame:ScrollToBottom()
	self.Frame:SetHeight(getMinHeight(self.Frame))
end

local function chatEvent(self)
	if(event == "CHAT_MSG_CHANNEL" and channelNumbers and not channelNumbers[arg8]) then return end

	if(not LockInCombat or not UnitAffectingCombat("player")) then
		Animate(self, UP, nil, MinimizeAfterWait)
	end
end

for chatname, options in pairs(ChatFrameConfig) do
	local chatframe = _G[chatname]
	local chicchai = CreateFrame"Frame"
	if(MaximizeOnEnter) then
		local updater = CreateFrame("Frame", nil, chatframe)
		updater:SetScript("OnUpdate", CheckEnterLeave)
		updater.Frame = chatframe
	end
	chicchai.Frame = chatframe
	chatframe.Chicchai = chicchai
	if(type(options) == "table") then
		for _, event in pairs(options) do
			if(not event:match("[A-Z]")) then
				event = "CHAT_MSG_"..event:upper()
			end
			chicchai:RegisterEvent(event)
		end
	end
	ChatFrameConfig[chatname] = chicchai
	
	chatframe.Maximize = Maximize
	chatframe.Minimize = Minimize
	chatframe.UpdateHeight = updateHeight
	chatframe.SetFrozen = SetFrozen

	chicchai:SetScript("OnUpdate", Update)
	chicchai:SetScript("OnEvent", chatEvent)
	chicchai:Hide()

	updateHeight(chatframe)

	hooksecurefunc(chatframe, "AddMessage", updateHeight)
end

_G.Chicchai = ChatFrameConfig

