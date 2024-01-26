local _, ns = ...
local B, C, L, DB = unpack(ns)
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

-- [[ Options UI ]]

-- these variables are loaded on init and updated only on gui.okay. Calling gui.cancel resets the saved vars to these
local old, checkboxes = {}, {}

-- function to copy table contents and inner table
local function copyTable(source, target)
	for key, value in pairs(source) do
		if type(value) == "table" then
			target[key] = {}
			for k in pairs(value) do
				target[key][k] = value[k]
			end
		else
			target[key] = value
		end
	end
end

local function addSubCategory(parent, name)
	local header = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	header:SetText(name)

	local line = parent:CreateTexture(nil, "ARTWORK")
	line:SetSize(610, 1)
	line:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
	line:SetColorTexture(1, 1, 1, .2)

	return header
end

local function toggle(f)
	AuroraClassicDB[f.value] = f:GetChecked()
end

local modConver = {
	[1] = 0,
	[2] = 1,
	[0] = 2,
}

local function createToggleBox(parent, value, text, category, index)
	local f = CreateFrame("CheckButton", "$parent"..value, parent, "InterfaceOptionsCheckButtonTemplate")
	f.value = value
	f.Text:SetText(text)
	f:SetScript("OnClick", toggle)

	local xoffset = modConver[mod(index, 3)]*180
	local yoffset = -(floor(index/3.1)*32 + 20)
	f:SetPoint("TOPLEFT", category, "BOTTOMLEFT", xoffset, yoffset)

	tinsert(checkboxes, f)
	return f
end

-- create frames/widgets

local oncall = CreateFrame("Frame", "AuroraCallingFrame", UIParent)
oncall.name = "AuroraClassic"
InterfaceOptions_AddCategory(oncall)

local header = oncall:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
header:SetPoint("TOPLEFT", 20, -26)
header:SetText("|cff0080ffAuroraClassic|r "..GetAddOnMetadata("AuroraClassic", "Version"))

local bu = CreateFrame("Button", nil, oncall, "UIPanelButtonTemplate")
bu:SetSize(120, 25)
bu:SetPoint("TOPLEFT", 20, -56)
bu:SetText(SETTINGS)
bu:SetScript("OnClick", function()
	while CloseWindows() do end
	SlashCmdList.AURORA()
end)

local gui = CreateFrame("Frame", "AuroraOptions", UIParent, "BackdropTemplate")
gui.name = "AuroraClassic"
gui:SetSize(640, 550)
gui:SetPoint("CENTER")
gui:Hide()
tinsert(UISpecialFrames, "AuroraOptions")

local cancel = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
cancel:SetSize(100, 22)
cancel:SetPoint("BOTTOMRIGHT", -10, 10)
cancel:SetText(CANCEL)

local okay = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
okay:SetSize(100, 22)
okay:SetPoint("RIGHT", cancel, "LEFT", -5, 0)
okay:SetText(OKAY)

local default = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
default:SetSize(100, 22)
default:SetPoint("BOTTOMLEFT", 10, 10)
default:SetText(DEFAULTS)

local title = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 36, -26)
title:SetText("|cff0080ffAuroraClassic|r "..GetAddOnMetadata("AuroraClassic", "Version").." |cffffffff("..COMMAND.." /ac)")

local features = addSubCategory(gui, L["Features"])
features:SetPoint("TOPLEFT", 16, -60)

local featuresList = {
	[1] = {"Shadow", L["Shadow Border"]},
	[2] = {"Loot", L["Loot"]},
	[3] = {"Bags", L["Bags"]},
	[4] = {"ChatBubbles", L["ChatBubbles"]},
	[5] = {"ObjectiveTracker", L["ObjectiveTracker"]},
	[6] = {"Tooltips", L["Tooltips"]},
}
for index, value in ipairs(featuresList) do
	createToggleBox(gui, value[1], value[2], features, index)
end

local appearance = addSubCategory(gui, L["Appearance"])
appearance:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -110)

createToggleBox(gui, "FlatMode", L["FlatMode"], appearance, 1)

local fontBox = createToggleBox(gui, "FontOutline", L["Replace default game fonts"], appearance, 4)
local fontSlider = CreateFrame("Slider", "AuroraOptionsFontSlider", gui, "OptionsSliderTemplate")
fontSlider:SetPoint("TOPLEFT", fontBox, "BOTTOMLEFT", 20, -30)
fontSlider:SetMinMaxValues(.5, 1)
fontSlider:SetValueStep(.1)
fontSlider.Text:SetText(L["FontScale"])
fontSlider.Low:SetText(.5)
fontSlider.High:SetText(1)
local fontValue = fontSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
fontValue:SetPoint("TOP", fontSlider, "BOTTOM", 0, 4)

local alphaSlider = CreateFrame("Slider", "AuroraOptionsAlpha", gui, "OptionsSliderTemplate")
alphaSlider:SetPoint("LEFT", fontSlider, "RIGHT", 100, 0)
alphaSlider:SetMinMaxValues(0, 1)
alphaSlider:SetValueStep(.1)
alphaSlider.Text:SetText(L["Opacity"])
alphaSlider.Low:SetText(0)
alphaSlider.High:SetText(1)
local alphaValue = alphaSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
alphaValue:SetPoint("TOP", alphaSlider, "BOTTOM", 0, 4)

local line = gui:CreateTexture(nil, "ARTWORK")
line:SetSize(610, 1)
line:SetPoint("TOPLEFT", fontSlider, "BOTTOMLEFT", -20, -30)
line:SetColorTexture(1, 1, 1, .2)

local reloadText = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 0, -40)
reloadText:SetText(L["Reload Text"])

local reloadButton = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
reloadButton:SetPoint("LEFT", reloadText, "RIGHT", 20, 0)
reloadButton:SetSize(128, 25)
reloadButton:SetText(RELOADUI)

local credits = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("AuroraClassic by Haleth, Siweia.")
credits:SetPoint("BOTTOM", 0, 40)

-- add event handlers

local function guiRefresh()
	alphaSlider:SetValue(AuroraClassicDB.Alpha)
	alphaValue:SetText(AuroraClassicDB.Alpha)

	fontSlider:SetValue(AuroraClassicDB.FontScale)
	fontValue:SetText(AuroraClassicDB.FontScale)
	if AuroraClassicDB.FontOutline then
		fontSlider:Enable()
		fontSlider.Text:SetTextColor(1, 1, 1)
	else
		fontSlider:Disable()
		fontSlider.Text:SetTextColor(.5, .5, .5)
	end

	for i = 1, #checkboxes do
		checkboxes[i]:SetChecked(AuroraClassicDB[checkboxes[i].value] == true)
	end
end

gui:RegisterEvent("ADDON_LOADED")
gui:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "AuroraClassic" then return end

	-- fill 'old' table
	copyTable(AuroraClassicDB, old)

	B.SetBD(gui)
	B.Reskin(bu)
	B.Reskin(okay)
	B.Reskin(cancel)
	B.Reskin(default)
	B.Reskin(reloadButton)
	B.ReskinSlider(alphaSlider)
	B.ReskinSlider(fontSlider)

	for i = 1, #checkboxes do
		B.ReskinCheck(checkboxes[i])
	end

	guiRefresh()
	self:UnregisterEvent("ADDON_LOADED")
end)

local function updateFrames()
	for _, frame in pairs(C.frames) do
		frame:SetBackdropColor(0, 0, 0, AuroraClassicDB.Alpha)
	end
end

local function guiOkay()
	copyTable(AuroraClassicDB, old)
	gui:Hide()
end

local function guiCancel()
	copyTable(old, AuroraClassicDB)

	updateFrames()
	guiRefresh()
	gui:Hide()
end

local function guiDefault()
	copyTable(C.options, AuroraClassicDB)

	updateFrames()
	guiRefresh()
end

reloadButton:SetScript("OnClick", ReloadUI)
okay:SetScript("OnClick", guiOkay)
cancel:SetScript("OnClick", guiCancel)
default:SetScript("OnClick", guiDefault)

alphaSlider:SetScript("OnValueChanged", function(_, value)
	value = tonumber(format("%.1f", value))
	AuroraClassicDB.Alpha = value
	alphaValue:SetText(value)
	updateFrames()
end)

fontBox:HookScript("OnClick", function(self)
	if self:GetChecked() then
		fontSlider:Enable()
		fontSlider.Text:SetTextColor(1, 1, 1)
	else
		fontSlider:Disable()
		fontSlider.Text:SetTextColor(.5, .5, .5)
	end
end)

fontSlider:SetScript("OnValueChanged", function(_, value)
	value = tonumber(format("%.1f", value))
	AuroraClassicDB.FontScale = value
	fontValue:SetText(value)
end)

-- easy slash command

SlashCmdList.AURORA = function()
	ToggleFrame(gui)
end
SLASH_AURORA1 = "/ac"