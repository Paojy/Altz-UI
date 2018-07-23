local T, C, L, G = unpack(select(2, ...))
-- by zork

local defaultFadeIn = {time = 0.4, alpha = 1}
local defaultFadeOut = {time = 0.4, alpha = 0}
local defaultEventFadeOut = {time = 1.5, alpha = 0}

local frameFadeManager = CreateFrame("FRAME")

-- Generic fade function
local function UIFrameFade(frame, fadeInfo)
	if not frame then return end
	if not fadeInfo.mode then fadeInfo.mode = "IN" end
	local alpha
	if fadeInfo.mode == "IN" then
		if not fadeInfo.startAlpha then fadeInfo.startAlpha = 0 end
		if not fadeInfo.endAlpha then fadeInfo.endAlpha = 1 end
		alpha = 0
	elseif fadeInfo.mode == "OUT" then
		if not fadeInfo.startAlpha then fadeInfo.startAlpha = 1.0 end
		if not fadeInfo.endAlpha then fadeInfo.endAlpha = 0 end
		alpha = 1.0
	end
	frame:SetAlpha(fadeInfo.startAlpha)
	frame.fadeInfo = fadeInfo

	local index = 1
	while FADEFRAMES[index] do
		if ( FADEFRAMES[index] == frame ) then return end -- If frame is already set to fade then return
		index = index + 1
	end
	tinsert(FADEFRAMES, frame)
	frameFadeManager:SetScript("OnUpdate", UIFrameFade_OnUpdate)
end

-- Convenience function to do a simple fade in
local function UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {}
	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = timeToFade
	fadeInfo.startAlpha = startAlpha
	fadeInfo.endAlpha = endAlpha
	UIFrameFade(frame, fadeInfo)
end
T.UIFrameFadeIn = UIFrameFadeIn

-- Convenience function to do a simple fade out
local function UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = timeToFade
	fadeInfo.startAlpha = startAlpha
	fadeInfo.endAlpha = endAlpha
	UIFrameFade(frame, fadeInfo)
end
T.UIFrameFadeOut = UIFrameFadeOut
--==================================================================--
-- fade-in on enter/fade-out on leave --
--==================================================================--

function T.ActionbarFader(frame, buttonList, fadeIn, fadeOut)
	if not frame or not buttonList then return end
	if not fadeIn then fadeIn = defaultFadeIn end
	if not fadeOut then fadeOut = defaultFadeOut end
	frame:EnableMouse(true)

	frame:SetScript("OnEnter", function(self)
		if frame.eventmode ~= 1 then
			UIFrameFadeIn(frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
			for _, bu in pairs(buttonList) do
				local name = bu:GetName()
				local cd= _G[name.."Cooldown"]
				cd:SetDrawBling(true)
			end
		end

	end)
	frame:SetScript("OnLeave", function(self)
		if frame.eventmode ~= 1 then
			UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
			for _, bu in pairs(buttonList) do
				local name = bu:GetName()
				local cd= _G[name.."Cooldown"]
				cd:SetDrawBling(false)
			end
		end
	end)

	for _, button in pairs(buttonList) do
		if button then
			button:HookScript("OnEnter", function()
				if frame.eventmode ~= 1 then
					UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
					for _, bu in pairs(buttonList) do
						local name = bu:GetName()
						local cd= _G[name.."Cooldown"]
						cd:SetDrawBling(true)
					end
				end
			end)

			button:HookScript("OnLeave", function()
				if frame.eventmode ~= 1 then
					UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
					for _, bu in pairs(buttonList) do
						local name = bu:GetName()
						local cd= _G[name.."Cooldown"]
						cd:SetDrawBling(false)
					end
				end
			end)
		end
	end

	UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
	for _, bu in pairs(buttonList) do
		local name = bu:GetName()
		local cd= _G[name.."Cooldown"]
		cd:SetDrawBling(false)
	end
end

function T.FrameFader(frame,fadeIn,fadeOut)
	if not frame then return end
	if not fadeIn then fadeIn = defaultFadeIn end
	if not fadeOut then fadeOut = defaultFadeOut end
	frame:EnableMouse(true)

	frame:SetScript("OnEnter", function(self) if frame.eventmode ~= 1 then UIFrameFadeIn(frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end end)
	frame:SetScript("OnLeave", function(self) if frame.eventmode ~= 1 then UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end end)

	UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
end

--the flyout is special, when hovering the flyout the parented bar must not fade out
function T.SpellFlyoutFader(frame,buttonList,fadeIn,fadeOut)
	if not frame or not buttonList then return end
	if not fadeIn then fadeIn = defaultFadeIn end
	if not fadeOut then fadeOut = defaultFadeOut end

	SpellFlyout:HookScript("OnEnter", function()
		if frame.eventmode ~= 1 then
			UIFrameFadeIn(frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
			for _, bu in pairs(buttonList) do
				local name = bu:GetName()
				local cd= _G[name.."Cooldown"]
				cd:SetDrawBling(true)
			end
		end
	end)

	SpellFlyout:HookScript("OnLeave", function()
		if frame.eventmode ~= 1 then
			UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
			for _, bu in pairs(buttonList) do
				local name = bu:GetName()
				local cd= _G[name.."Cooldown"]
				cd:SetDrawBling(false)
			end
		end
	end)

	for _, button in pairs(buttonList) do
		if button then
			button:HookScript("OnEnter", function()
				if frame.eventmode ~= 1 then
					UIFrameFadeIn(frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
					for _, bu in pairs(buttonList) do
						local name = bu:GetName()
						local cd= _G[name.."Cooldown"]
						cd:SetDrawBling(false)
					end
				end
			end)

			button:HookScript("OnLeave", function()
				if frame.eventmode ~= 1 then
					UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
					for _, bu in pairs(buttonList) do
						local name = bu:GetName()
						local cd= _G[name.."Cooldown"]
						cd:SetDrawBling(false)
					end
				end
			end)
		end
	end
end
--==================================================================--
-- fade-in when center conditions meets --
--==================================================================--
local function regi(frame)
	frame:RegisterEvent('PLAYER_REGEN_DISABLED')
	frame:RegisterEvent('PLAYER_REGEN_ENABLED')
	frame:RegisterEvent('UNIT_TARGET')
	frame:RegisterEvent('PLAYER_TARGET_CHANGED')
	frame:RegisterEvent('UNIT_HEALTH')
	frame:RegisterEvent('UNIT_MAXHEALTH')
	frame:RegisterEvent('UNIT_POWER_UPDATE')
	frame:RegisterEvent('UNIT_MAXPOWER')
	frame:RegisterEvent('UNIT_SPELLCAST_START')
	frame:RegisterEvent('UNIT_SPELLCAST_FAILED')
	frame:RegisterEvent('UNIT_SPELLCAST_STOP')
	frame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
	frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
	--frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED')
	frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

--[[
MANA = 0
*RAGE = 1
FOCUS = 2
ENERGY = 3
COMBO_POINTS = 4
RUNES = 5
*RUNIC_POWER = 6
SOUL_SHARDS = 7
*LUNAR_POWER = 8
HOLY_POWER = 9
ALTERNATE_POWER = 10
*MAELSTROM = 11
CHI = 12
*INSANITY = 13
OBSOLETE = 14
OBSOLETE2 = 15
ARCANE_CHARGES = 16
*FURY = 17
*PAIN = 18
]]

local EmptyPowerType = {
	["RAGE"] = true,
	["RUNIC_POWER"] = true,
	["LUNAR_POWER"] = true,
	["MAELSTROM"] = true,
	["INSANITY"] = true,
	["FURY"] = true,
	["PAIN"] = true,
}

function T.ActionbarEventFader(frame,buttonList,fadeIn,fadeOut)
	if not frame or not buttonList then return end
	if not fadeIn then fadeIn = defaultFadeIn end
	if not fadeOut then fadeOut = defaultEventFadeOut end

	regi(frame)

	frame:SetScript("OnEvent", function(self,event)
		if
		UnitCastingInfo('player') or UnitChannelInfo('player') or
		UnitAffectingCombat('player') or
		UnitExists('target') or
		UnitHealth('player') < UnitHealthMax('player') or
		(EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") > 0) or
		(not EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") < UnitPowerMax("player"))
		then
			frame.eventmode = 1
			UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
			for _, bu in pairs(buttonList) do
				local name = bu:GetName()
				local cd= _G[name.."Cooldown"]
				cd:SetDrawBling(true)
			end
		else
			frame.eventmode = 0
			UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
			for _, bu in pairs(buttonList) do
				local name = bu:GetName()
				local cd= _G[name.."Cooldown"]
				cd:SetDrawBling(false)
			end
		end
	end)

	UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
	for _, bu in pairs(buttonList) do
		local name = bu:GetName()
		local cd= _G[name.."Cooldown"]
		cd:SetDrawBling(false)
	end
end

function T.FrameEventFader(frame,fadeIn,fadeOut)
	if not frame then return end
	if not fadeIn then fadeIn = defaultFadeIn end
	if not fadeOut then fadeOut = defaultEventFadeOut end

	regi(frame)

	frame:SetScript("OnEvent", function(self,event)
		if
		UnitCastingInfo('player') or UnitChannelInfo('player') or
		UnitAffectingCombat('player') or
		UnitExists('target') or
		UnitHealth('player') < UnitHealthMax('player') or
		(EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") > 0) or
		(not EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") < UnitPowerMax("player"))
		then
			frame.eventmode = 1
			UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
		else
			print(333)
			frame.eventmode = 0
			UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
		end
	end)

	UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
end
