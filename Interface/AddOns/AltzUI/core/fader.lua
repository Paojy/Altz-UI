local T, C, L, G = unpack(select(2, ...))
-- by zork

local fadeIn_time = .4
local fadeIn_alpha = 1

local fadeOut_time = .4
local fadeOut_time_event = 1.5
local fadeOut_alpha = 0

local frameFadeManager = CreateFrame("FRAME")
G.frameFadeManager = frameFadeManager
local eventmode = 0
local event_fade_frames = {}

T.RegisterEventFade = function(frame)
	local name = frame:GetName()
	if name then
		event_fade_frames[name] = frame
	else
		print("RegisterFading bug, no frame name")
	end
end

T.UnregisterEventFade = function(frame)
	local name = frame:GetName()
	if name then
		event_fade_frames[name] = nil
	else
		print("UnregisterFading bug, no frame name")
	end
end

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
	if frame.Portrait then
		UIFrameFade(frame.Portrait, fadeInfo)
	end
	if frame.actionButtons then
		for _, bu in pairs(frame.actionButtons) do
			bu.cooldown:SetDrawBling(true)
		end
	end
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
	if frame.Portrait then
		UIFrameFade(frame.Portrait, fadeInfo)
	end
	if frame.actionButtons then
		for _, bu in pairs(frame.actionButtons) do
			bu.cooldown:SetDrawBling(false)
		end		
	end
end
T.UIFrameFadeOut = UIFrameFadeOut
--==================================================================--
-- fade-in on enter/fade-out on leave --
--==================================================================--
local function IsFrameMouseOver(parent, children)	
	if parent:IsMouseOver() then
		return true			
	end
	for _, bu in pairs(children) do
		if bu:IsMouseOver() then
			return true
		end
	end	
	return false
end

function T.ParentFader(parent, children)
	if not parent or not children then return end
	
	T.RegisterEnteringWorldCallback(function()
		parent:SetAlpha(parent.fadeOut_alpha or fadeOut_alpha) -- 初始透明度
	end)
	parent:EnableMouse(true)
	
	parent:HookScript("OnEnter", function(self)
		UIFrameFadeIn(self, fadeIn_time, self:GetAlpha(), fadeIn_alpha)
	end)
	
	parent:HookScript("OnLeave", function(self)
		if not IsFrameMouseOver(self, children) then
			UIFrameFadeOut(self, fadeOut_time, self:GetAlpha(), self.fadeOut_alpha or fadeOut_alpha)
		end
	end)
	
	for k, bu in pairs(children) do	
		bu:HookScript("OnEnter", function()
			UIFrameFadeIn(parent, fadeIn_time, parent:GetAlpha(), fadeIn_alpha)
		end)
		
		bu:HookScript("OnLeave", function()
			if not IsFrameMouseOver(parent, children) then
				UIFrameFadeOut(parent, fadeOut_time, parent:GetAlpha(), parent.fadeOut_alpha or fadeOut_alpha)
			end
		end)
	end
	
	EditModeManagerFrame:HookScript("OnHide", function()
		if not IsFrameMouseOver(parent, children) then
			UIFrameFadeOut(parent, fadeOut_time, parent:GetAlpha(), parent.fadeOut_alpha or fadeOut_alpha)
		end
	end)
end

local function IsFramesMouseOver(frames)
	for i, f in pairs(frames) do
		if f:IsMouseOver() then
			return true			
		end	
	end
	
	return false
end

function T.ChildrenFader(parent, children)
	if not parent or not children then return end
	
	for i, f in pairs(children) do
		T.RegisterEnteringWorldCallback(function()
			f:SetAlpha(parent.fadeOut_alpha or fadeOut_alpha) -- 初始透明度
		end)
		f:EnableMouse(true)
	end
	
	parent:HookScript("OnEnter", function(self)
		for i, f in pairs(children) do
			UIFrameFadeIn(f, fadeIn_time, f:GetAlpha(), fadeIn_alpha)
		end	
	end)
	
	parent:HookScript("OnLeave", function(self)	
		if not IsFramesMouseOver(children) then
			for i, f in pairs(children) do
				UIFrameFadeOut(f, fadeOut_time, f:GetAlpha(), parent.fadeOut_alpha or fadeOut_alpha)
			end
		end
	end)
end

function T.GroupFader(framegroup)
	if not framegroup then return end
	
	for i, frame in pairs(framegroup) do
		T.RegisterEnteringWorldCallback(function()
			frame:SetAlpha(frame.fadeOut_alpha or fadeOut_alpha) -- 初始透明度
		end)	
		frame:EnableMouse(true)
		
		frame:HookScript("OnEnter", function(self)
			for i, f in pairs(framegroup) do
				UIFrameFadeIn(f, fadeIn_time, f:GetAlpha(), fadeIn_alpha)
			end	
		end)
		
		frame:HookScript("OnLeave", function(self)
			if not IsFramesMouseOver(framegroup) then
				for i, f in pairs(framegroup) do
					UIFrameFadeOut(f, fadeOut_time, f:GetAlpha(), f.fadeOut_alpha or fadeOut_alpha)	
				end
			end
		end)
	end
end

local function IsActionbarMouseOver(actionbars)
	for i, bar in pairs(actionbars) do
		if bar:IsMouseOver() then
			return true			
		end
		for k, bu in pairs(bar.actionButtons) do
			if bu:IsMouseOver() then
				return true
			end
		end
	end
	
	return false
end

local function ActionbarsFade(actionbars, mode)
	if mode == "in" then
		for i, bar in pairs(actionbars) do
			if bar.enable_fade and eventmode ~= 1 then
				UIFrameFadeIn(bar, fadeIn_time, bar:GetAlpha(), fadeIn_alpha)
			end
		end
	elseif not IsActionbarMouseOver(actionbars) then
		for i, bar in pairs(actionbars) do
			if bar.enable_fade and eventmode ~= 1 then
				UIFrameFadeOut(bar, fadeOut_time, bar:GetAlpha(), bar.fadeOut_alpha or fadeOut_alpha)	
			end
		end
	end
end

function T.ActionbarFader(actionbars)
	if not actionbars then return end
	
	for i, bar in pairs(actionbars) do
		bar:HookScript("OnEnter", function(self)
			ActionbarsFade(actionbars, "in")
		end)
		
		bar:HookScript("OnLeave", function(self)
			ActionbarsFade(actionbars, "out")
		end)
		
		for k, bu in pairs(bar.actionButtons) do	
			bu:HookScript("OnEnter", function(self)
				ActionbarsFade(actionbars, "in")
			end)
			
			bu:HookScript("OnLeave", function(self)
				ActionbarsFade(actionbars, "out")
			end)
		end
	end
end

--==================================================================--
-- fade-in when center conditions meets --
--==================================================================--
local EmptyPowerType = {
	["RAGE"] = true,
	["RUNIC_POWER"] = true,
	["LUNAR_POWER"] = true,
	["MAELSTROM"] = true,
	["INSANITY"] = true,
	["FURY"] = true,
	["PAIN"] = true,
}

frameFadeManager:RegisterEvent("PLAYER_REGEN_DISABLED")
frameFadeManager:RegisterEvent("PLAYER_REGEN_ENABLED")
frameFadeManager:RegisterEvent("PLAYER_TARGET_CHANGED")
frameFadeManager:RegisterEvent("PLAYER_ENTERING_WORLD")

frameFadeManager:RegisterUnitEvent("UNIT_HEALTH", "player")
frameFadeManager:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
frameFadeManager:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
frameFadeManager:RegisterUnitEvent("UNIT_MAXPOWER", "player")
frameFadeManager:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
frameFadeManager:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
frameFadeManager:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
frameFadeManager:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
frameFadeManager:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
frameFadeManager:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")

frameFadeManager:SetScript("OnEvent", function(self,event)
	if
	UnitCastingInfo('player') or UnitChannelInfo('player') or
	UnitAffectingCombat('player') or
	UnitExists('target') or
	UnitHealth('player') < UnitHealthMax('player') or
	(EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") > 0) or
	(not EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") < UnitPowerMax("player"))
	then
		eventmode = 1
		for name, frame in pairs(event_fade_frames) do
			UIFrameFadeIn( frame, fadeIn_time, frame:GetAlpha(), fadeIn_alpha)
		end
	else
		eventmode = 0
		for name, frame in pairs(event_fade_frames) do
			UIFrameFadeOut(frame, fadeOut_time_event, frame:GetAlpha(), frame.fadeOut_alpha or fadeOut_alpha)	
		end
	end
end)