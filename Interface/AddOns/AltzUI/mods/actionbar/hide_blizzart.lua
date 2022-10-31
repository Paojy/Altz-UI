local T, C, L, G = unpack(select(2, ...))

local scripts = {
	"OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp",
}

local framesToHide = {
	MainMenuBar.ActionBarPageNumber,
	MainMenuBar.BorderArt,
	MainMenuBar.EndCaps,
	MainMenuBar.Background,
}

local framesToDisable = {
	MainMenuBar.ActionBarPageNumber,
	MainMenuBar.BorderArt,
	MainMenuBar.EndCaps,
	MainMenuBar.Background,
}

local textureToHide = {
	
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

local blizzHider = CreateFrame("Frame", "Altz_BizzardHider")
blizzHider:RegisterEvent("PLAYER_LOGIN")
blizzHider:RegisterEvent("ADDON_LOADED")
blizzHider:Hide()
T.blizzHider = blizzHider

blizzHider:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function blizzHider:PLAYER_LOGIN()	
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
end

function blizzHider:ADDON_LOADED(addon)
	if addon == "Blizzard_BindingUI" then
		if QuickKeybindFrame.phantomExtraActionButton then
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