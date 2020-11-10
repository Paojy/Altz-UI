local T, C, L, G = unpack(select(2, ...))

local noop = function() end
local noops = { 'ClearAllPoints', 'SetPoint', 'SetScale', 'SetShown' }
local function SetNoopsi(frame)
	for _, func in pairs(noops) do
		if frame[func] ~= noop then
			frame[func] = noop
		end
	end
end


local function ButtonEventsRegisterFrame(added)
	local frames = _G.ActionBarButtonEventsFrame.frames
	for index = #frames, 1, -1 do
		local frame = frames[index]
		local wasAdded = frame == added
		if not added or wasAdded then
			if not strmatch(frame:GetName(), 'ExtraActionButton%d') then
				_G.ActionBarButtonEventsFrame.frames[index] = nil
			end

			if wasAdded then
				break
			end
		end
	end
end

local function DisableBlizzard()
	-- Spellbook open in combat taint, only happens sometimes
	_G.MultiActionBar_HideAllGrids = function() end
	_G.MultiActionBar_ShowAllGrids = function() end
	
	-- MainMenuBar:ClearAllPoints taint during combat
	_G.MainMenuBar.SetPositionForStatusBars = function() end
	
	-- shut down some events for things we dont use
	SetNoopsi(_G.MainMenuBarArtFrame)
	SetNoopsi(_G.MainMenuBarArtFrameBackground)
	_G.MainMenuBarArtFrame:UnregisterAllEvents()
	_G.StatusTrackingBarManager:UnregisterAllEvents()
	_G.ActionBarButtonEventsFrame:UnregisterAllEvents()
	_G.ActionBarButtonEventsFrame:RegisterEvent('ACTIONBAR_SLOT_CHANGED') -- these are needed to let the ExtraActionButton show
	_G.ActionBarButtonEventsFrame:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN') -- needed for ExtraActionBar cooldown
	_G.ActionBarActionEventsFrame:UnregisterAllEvents()
	_G.ActionBarController:UnregisterAllEvents()
	_G.ActionBarController:RegisterEvent('UPDATE_EXTRA_ACTIONBAR') -- this is needed to let the ExtraActionBar show
	
	-- lets only keep ExtraActionButtons in here
	hooksecurefunc(_G.ActionBarButtonEventsFrame, 'RegisterFrame', ButtonEventsRegisterFrame)
	ButtonEventsRegisterFrame()
	
	-- this would taint along with the same path as the SetNoopers: ValidateActionBarTransition
	_G.VerticalMultiBarsContainer:Size(10, 10) -- dummy values so GetTop etc doesnt fail without replacing
	SetNoopsi(_G.VerticalMultiBarsContainer)
end

local blizzHider = CreateFrame("Frame", "Altz_BizzardHider")
blizzHider:RegisterEvent("PLAYER_LOGIN")
blizzHider:Hide()
blizzHider:SetScript("OnEvent", DisableBlizzard)

--hide micro menu

local buttonList = {
	--CharacterMicroButton,
	--SpellbookMicroButton,
	---TalentMicroButton,
	--AchievementMicroButton,
	--QuestLogMicroButton,
	--GuildMicroButton,
	--PVPMicroButton,
	--LFDMicroButton,
	--CompanionsMicroButton,
	--EJMicroButton,
	--MainMenuMicroButton,
	HelpMicroButton,
	}

for _, button in pairs(buttonList) do
	button:SetParent(blizzHider)
end

--hide main menu bar frames
MainMenuBar:SetParent(blizzHider)
MainMenuBarArtFrameBackground:SetParent(blizzHider)
ActionBarDownButton:SetParent(blizzHider)
ActionBarUpButton:SetParent(blizzHider)

-- bag
MainMenuBarBackpackButton:SetParent(blizzHider)

--hide override actionbar frames
OverrideActionBarExpBar:SetParent(blizzHider)
OverrideActionBarHealthBar:SetParent(blizzHider)
OverrideActionBarPowerBar:SetParent(blizzHider)
OverrideActionBarPitchFrame:SetParent(blizzHider) --maybe we can use that frame later for pitchig and such

  -----------------------------
  -- HIDE TEXTURES
  -----------------------------

  --remove some the default background textures
  StanceBarLeft:SetTexture(nil)
  StanceBarMiddle:SetTexture(nil)
  StanceBarRight:SetTexture(nil)
  SlidingActionBarTexture0:SetTexture(nil)
  SlidingActionBarTexture1:SetTexture(nil)
  PossessBackground1:SetTexture(nil)
  PossessBackground2:SetTexture(nil)

  MainMenuBarArtFrame.LeftEndCap:SetTexture(nil)
  MainMenuBarArtFrame.RightEndCap:SetTexture(nil)
  
  --remove OverrideBar textures

    local textureList =  {
      "_BG",
      "EndCapL",
      "EndCapR",
      "_Border",
      "Divider1",
      "Divider2",
      "Divider3",
      "ExitBG",
      "MicroBGL",
      "MicroBGR",
      "_MicroBGMid",
      "ButtonBGL",
      "ButtonBGR",
      "_ButtonBGMid",
    }

    for _,tex in pairs(textureList) do
      OverrideActionBar[tex]:SetAlpha(0)
    end