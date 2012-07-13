
  -- // fader functionality - frame fading
  -- // zork - 2012

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------

  --add some global functions
  local defaultFadeIn   = {time = 0.4, alpha = 1}
  local defaultFadeOut  = {time = 0.4, alpha = 0}
  local defaultEventFadeOut  = {time = 1.5, alpha = 0}
  
  local frameFadeManager = CreateFrame("FRAME");

  -- Generic fade function
  local function UIFrameFade(frame, fadeInfo)
    if (not frame) then
      return;
    end
    if ( not fadeInfo.mode ) then
      fadeInfo.mode = "IN";
    end
    local alpha;
    if ( fadeInfo.mode == "IN" ) then
      if ( not fadeInfo.startAlpha ) then
        fadeInfo.startAlpha = 0;
      end
      if ( not fadeInfo.endAlpha ) then
        fadeInfo.endAlpha = 1.0;
      end
      alpha = 0;
    elseif ( fadeInfo.mode == "OUT" ) then
      if ( not fadeInfo.startAlpha ) then
        fadeInfo.startAlpha = 1.0;
      end
      if ( not fadeInfo.endAlpha ) then
        fadeInfo.endAlpha = 0;
      end
      alpha = 1.0;
    end
    frame:SetAlpha(fadeInfo.startAlpha);

    frame.fadeInfo = fadeInfo;

    local index = 1;
    while FADEFRAMES[index] do
      -- If frame is already set to fade then return
      if ( FADEFRAMES[index] == frame ) then
        return;
      end
      index = index + 1;
    end
    tinsert(FADEFRAMES, frame);
    frameFadeManager:SetScript("OnUpdate", UIFrameFade_OnUpdate);
  end

  -- Convenience function to do a simple fade in
  local function UIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
    local fadeInfo = {};
    fadeInfo.mode = "IN";
    fadeInfo.timeToFade = timeToFade;
    fadeInfo.startAlpha = startAlpha;
    fadeInfo.endAlpha = endAlpha;
    UIFrameFade(frame, fadeInfo);
  end

  -- Convenience function to do a simple fade out
  local function UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
    local fadeInfo = {};
    fadeInfo.mode = "OUT";
    fadeInfo.timeToFade = timeToFade;
    fadeInfo.startAlpha = startAlpha;
    fadeInfo.endAlpha = endAlpha;
    UIFrameFade(frame, fadeInfo);
  end

-----------------------
-- fade-in on enter/fade-out on leave
-----------------------

  --rButtonBarFader func
  function rButtonBarFader(frame,buttonList,fadeIn,fadeOut)
    --if 1 == 1 then return end
    if not frame or not buttonList then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    frame:EnableMouse(true)
	-- dont fade by mouse conditions are met
	
	frame:SetScript("OnEnter", function(self) if frame.eventmode ~= 1 then UIFrameFadeIn(frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end end)
    frame:SetScript("OnLeave", function(self) if frame.eventmode ~= 1 then UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end end)
	
	for _, button in pairs(buttonList) do
      if button then
        button:HookScript("OnEnter", function() if frame.eventmode ~= 1 then UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end end)
        button:HookScript("OnLeave", function() if frame.eventmode ~= 1 then UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end end)
      end
    end

	UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
  end
  
    --rFrameFader func
  function rFrameFader(frame,fadeIn,fadeOut)
    --if 1 == 1 then return end
    if not frame then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultFadeOut end
    frame:EnableMouse(true)
	
	-- dont fade by mouse conditions are met
	frame:SetScript("OnEnter", function(self) if frame.eventmode == 0 then UIFrameFadeIn(frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end end)
    frame:SetScript("OnLeave", function(self) if frame.eventmode == 0 then UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end end)
	
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
  end

	  --rSpellFlyoutFader func
	  --the flyout is special, when hovering the flyout the parented bar must not fade out
  function rSpellFlyoutFader(frame,buttonList,fadeIn,fadeOut)
    if not frame or not buttonList then return end
	if not fadeIn then fadeIn = defaultFadeIn end
	if not fadeOut then fadeOut = defaultFadeOut end
	
	SpellFlyout:SetScript("OnEnter", function() if frame.eventmode ~= 1 then UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end end)
	SpellFlyout:SetScript("OnLeave", function() if frame.eventmode ~= 1 then UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end end)
	
	for _, button in pairs(buttonList) do
	  if button then
		button:HookScript("OnEnter", function() if frame.eventmode ~= 1 then UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha) end end)
	    button:HookScript("OnLeave", function() if frame.eventmode ~= 1 then UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha) end end)
	  end
    end
  end
-----------------------
-- fade-in when center conditions meets
-----------------------
--[[
powerType - A number identifying the power type (number)
0 - Mana
1 - Rage
2 - Focus
3 - Energy
6 - Runic Power
]]

function regi(frame)
	frame:RegisterEvent('PLAYER_REGEN_DISABLED')
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent('UNIT_TARGET')
	frame:RegisterEvent('PLAYER_TARGET_CHANGED')
	frame:RegisterEvent('UNIT_HEALTH')
	frame:RegisterEvent('UNIT_HEALTHMAX')
	frame:RegisterEvent('UNIT_POWER')
	frame:RegisterEvent('UNIT_POWERMAX')
	frame:RegisterEvent('UNIT_SPELLCAST_START')
	frame:RegisterEvent('UNIT_SPELLCAST_FAILED')
	frame:RegisterEvent('UNIT_SPELLCAST_STOP')
	frame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED')
	frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
	frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED')
	frame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function ActionbarEventFader(frame,buttonList,fadeIn,fadeOut)
	if not frame or not buttonList then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultEventFadeOut end
	
	local powerType = UnitPowerType("player")
	
	regi(frame)
	
	frame:SetScript("OnEvent", function(self,event)
		if
			UnitCastingInfo('player') or UnitChannelInfo('player') or
			UnitAffectingCombat('player') or
			UnitExists('target') or
			UnitHealth('player') < UnitHealthMax('player') or
			((UnitPowerType("player") == 1 or UnitPowerType("player") == 6) and UnitPower("player") > 0) or
			((UnitPowerType("player") ~= 1 and UnitPowerType("player") ~= 6) and UnitPower("player") < UnitPowerMax("player"))
		then
			frame.eventmode = 1
			UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
		else
			frame.eventmode = 0
			UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
		end
	end)
	
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
end

function FrameEventFader(frame,fadeIn,fadeOut)
	if not frame then return end
    if not fadeIn then fadeIn = defaultFadeIn end
    if not fadeOut then fadeOut = defaultEventFadeOut end
	
	local powerType = UnitPowerType("player")
	
	regi(frame)
	
	frame:SetScript("OnEvent", function(self,event)
		if
			UnitCastingInfo('player') or UnitChannelInfo('player') or
			UnitAffectingCombat('player') or
			UnitExists('target') or
			UnitHealth('player') < UnitHealthMax('player') or
			((UnitPowerType("player") == 1 or UnitPowerType("player") == 6) and UnitPower("player") > 0) or
			((UnitPowerType("player") ~= 1 and UnitPowerType("player") ~= 6) and UnitPower("player") < UnitPowerMax("player"))
		then
			frame.eventmode = 1
			UIFrameFadeIn( frame, fadeIn.time, frame:GetAlpha(), fadeIn.alpha)
		else
			frame.eventmode = 0
			UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
		end
	end)
	
    UIFrameFadeOut(frame, fadeOut.time, frame:GetAlpha(), fadeOut.alpha)
end


-- test frame
--[[

local aMedia = "Interface\\Addons\\aMedia\\"
local blank = "Interface\\Buttons\\WHITE8x8"

local frameBD = {
    edgeFile = aMedia.."grow", edgeSize = 3,
    bgFile = blank,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local function createBD(f, r, g, b, a, ba)
	if f.border then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -3, 3)
	border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetBackdrop(frameBD)
    border:SetBackdropColor(r, g, b, a)
    border:SetBackdropBorderColor(0, 0, 0, ba)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.border = border
end


local abtoggle = CreateFrame("Frame", nil, UIParent)
createBD(abtoggle, 0, 0, 0, 1, 1)
abtoggle:SetSize(50,50)
abtoggle:SetPoint('CENTER')

FrameEventFader(abtoggle)
]]