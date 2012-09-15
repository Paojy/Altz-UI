
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local dragFrameList = ns.dragFrameList

  local show = true
  local padding = 2
  local scale = aCoreCDB.micromenuscale
  local mouseover = {
        enable          = aCoreCDB.micromenufade,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = aCoreCDB.micromenuminalpha},
		}
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  --micro menu button objects
  local buttonList = {
    CharacterMicroButton,
    SpellbookMicroButton,
    TalentMicroButton,
    AchievementMicroButton,
    QuestLogMicroButton,
    GuildMicroButton,
    PVPMicroButton,
    LFDMicroButton,
    CompanionsMicroButton,
    EJMicroButton,
    MainMenuMicroButton,
    HelpMicroButton,
  }

  local NUM_MICROBUTTONS = # buttonList
  local buttonWidth = CharacterMicroButton:GetWidth()
  local buttonHeight = CharacterMicroButton:GetHeight()
  local gap = -3

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MicroMenu", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(NUM_MICROBUTTONS*buttonWidth + (NUM_MICROBUTTONS-1)*gap + 2*padding)
  frame:SetHeight(buttonHeight + 2*padding)
  frame:SetPoint("TOP", UIParent, "TOP",  0, 25)
  frame:SetScale(scale)

  --move the buttons into position and reparent them
  for _, button in pairs(buttonList) do
    button:SetParent(frame)
  end
  CharacterMicroButton:ClearAllPoints();
  CharacterMicroButton:SetPoint("LEFT", padding, 0)
  
--disable reanchoring of the micro menu by the petbattle ui
 PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil) --remove the onshow script
 
if not show then --wait...you no see me? :(
	frame:SetParent(rABS_BizzardHider)
	return
end

  --create drag frame and drag functionality
  rCreateDragFrame(frame, dragFrameList, -2 , false) --frame, dragFrameList, inset, clamp

  --create the mouseover functionality
  if mouseover.enable then
    ActionbarFader(frame, buttonList, mouseover.fadeIn, mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end
