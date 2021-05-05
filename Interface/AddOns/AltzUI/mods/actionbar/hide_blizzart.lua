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

local scripts = {
	"OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp",
}

local framesToHide = {
	MainMenuBar, OverrideActionBar, HelpMicroButton, MainMenuBarBackpackButton, MainMenuBarArtFrameBackground,
	ActionBarDownButton, ActionBarUpButton,
}

local framesToDisable = {
	MainMenuBar,
	MicroButtonAndBagsBar, MainMenuBarArtFrame, StatusTrackingBarManager,
	ActionBarDownButton, ActionBarUpButton,
	OverrideActionBar,
	OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
}

local textureToHide = {
	StanceBarLeft,
	StanceBarMiddle,
	StanceBarRight,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	PossessBackground1,
	PossessBackground2,
	MainMenuBarArtFrame.LeftEndCap,
	MainMenuBarArtFrame.RightEndCap,
}


local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

local function buttonShowGrid(name, showgrid)
	for i = 1, 12 do
		local button = _G[name..i]
		if button then
			button:SetAttribute("showgrid", showgrid)
			button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		end
	end
end

local eframe = CreateFrame("Frame")
local updateAfterCombat
local function toggleButtonGrid()
	if InCombatLockdown() then
		updateAfterCombat = true
		eframe:RegisterEvent("PLAYER_REGEN_ENABLED", toggleButtonGrid)
	else
		local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
		buttonShowGrid("ActionButton", showgrid)
		buttonShowGrid("MultiBarBottomRightButton", showgrid)
		if updateAfterCombat then
			eframe:UnregisterEvent("PLAYER_REGEN_ENABLED", toggleButtonGrid)
			updateAfterCombat = false
		end
	end
end

local blizzHider = CreateFrame("Frame", "Altz_BizzardHider")
blizzHider:RegisterEvent("PLAYER_LOGIN")
blizzHider:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
blizzHider:RegisterEvent("ADDON_LOADED")
blizzHider:Hide()
T.blizzHider = blizzHider

blizzHider:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function blizzHider:PLAYER_LOGIN()	
	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(true)
	MainMenuBar.ignoreFramePositionManager = true
	MainMenuBar:SetAttribute("ignoreFramePositionManager", true)

	for _, frame in next, framesToHide do
		frame:SetParent(blizzHider)
	end

	for _, frame in next, framesToDisable do
		frame:UnregisterAllEvents()
		DisableAllScripts(frame)
	end
	
	for _, texture in next, textureToHide do
		texture:SetTexture(nil)
	end
	
	-- Update button grid
	hooksecurefunc("MultiActionBar_UpdateGridVisibility", toggleButtonGrid)
	
	-- hide some interface options we dont use
	_G.InterfaceOptionsActionBarsPanelStackRightBars:SetScale(0.5)
	_G.InterfaceOptionsActionBarsPanelStackRightBars:SetAlpha(0)
	_G.InterfaceOptionsActionBarsPanelStackRightBarsText:Hide() -- hides the !
	_G.InterfaceOptionsActionBarsPanelRightTwoText:SetTextColor(1,1,1) -- no yellow
	_G.InterfaceOptionsActionBarsPanelRightTwoText.SetTextColor = noop -- i said no yellow
	_G.InterfaceOptionsActionBarsPanelLockActionBars:SetScale(0.0001)
	_G.InterfaceOptionsActionBarsPanelLockActionBars:SetAlpha(0)
end

function blizzHider:CURRENCY_DISPLAY_UPDATE()
	TokenFrame_LoadUI()
	TokenFrame_Update()
	BackpackTokenFrame_Update()
end

function blizzHider:ADDON_LOADED(addon)
	if addon == "Blizzard_BindingUI" then
		if QuickKeybindFrame.phantomExtraActionButton.UnregisterAllEvents then
			QuickKeybindFrame.phantomExtraActionButton:UnregisterAllEvents()
			QuickKeybindFrame.phantomExtraActionButton:SetParent(blizzHider)
		else
			QuickKeybindFrame.phantomExtraActionButton.Show = QuickKeybindFrame.phantomExtraActionButton.Hide
		end
		QuickKeybindFrame.phantomExtraActionButton:Hide()
		blizzHider:UnregisterEvent("ADDON_LOADED")
	end
end

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