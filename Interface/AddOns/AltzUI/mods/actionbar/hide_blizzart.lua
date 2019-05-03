local T, C, L, G = unpack(select(2, ...))

local blizzHider = CreateFrame("Frame", "Altz_BizzardHider")
blizzHider:Hide()

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