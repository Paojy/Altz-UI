local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local padding = 2
local scale = aCoreCDB.micromenuscale
local mouseover = {
	enable= aCoreCDB.micromenufade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB.micromenuminalpha},
	}

-- FUNCTIONS

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

local NUM_MICROBUTTONS = #buttonList
local buttonWidth = CharacterMicroButton:GetWidth()
local buttonHeight = CharacterMicroButton:GetHeight()
local gap = -3

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_MicroMenu", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["MicroMenu"]
frame:SetWidth(NUM_MICROBUTTONS*buttonWidth + (NUM_MICROBUTTONS-1)*gap + 2*padding)
frame:SetHeight(30 + 2*padding)
frame:SetPoint("TOP", UIParent, "TOP",0, -5)
frame:SetScale(scale)

--move the buttons into position and reparent them
for _, button in pairs(buttonList) do
	button:SetParent(frame)
end
CharacterMicroButton:ClearAllPoints();
CharacterMicroButton:SetPoint("BOTTOMLEFT", padding, 0)

--disable reanchoring of the micro menu by the petbattle ui
PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil) --remove the onshow script

--create drag frame and drag functionality
T.CreateDragFrame(frame, dragFrameList, -2 , false) --frame, dragFrameList, inset, clamp

--create the mouseover functionality
if mouseover.enable then
	T.ActionbarFader(frame, buttonList, mouseover.fadeIn, mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end