local F, C = unpack(Aurora)
local addon, ns = ...
local L = ns.L

local checkbuttons = {}
local resetbuttons = {}
local editboxes = {}
local sliders = {}

local function createRSbutton(parent, index, addon, value, tip)
	local bu = CreateFrame("CheckButton", "Reset"..addon.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu.addon = addon
	bu.value = value
	bu:SetPoint("TOPLEFT", 16, -65-index*30)
	bu.text = bu:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	bu.text:SetPoint("LEFT", bu, "RIGHT", 1, 1)
	bu.text:SetText(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON.."  "..bu.addon)
	bu:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(bu, "ANCHOR_RIGHT", 10, 10)
		GameTooltip:AddLine(tip)
		GameTooltip:Show() 
	end)
	bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bu:SetScript("OnClick", function()
		if bu:GetChecked() then
			aCoreCDB[bu.value] = true
		else
			aCoreCDB[bu.value] = false
		end
	end)
	tinsert(resetbuttons, bu)
	tinsert(checkbuttons, bu)
	return bu
end

local function createcheckbutton(parent, index, name, value, tip)
	local bu = CreateFrame("CheckButton", "AltzGUI"..name.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu.value = value
	bu:SetPoint("TOPLEFT", 16, 10-index*30)
	bu.text = bu:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	bu.text:SetPoint("LEFT", bu, "RIGHT", 1, 1)
	bu.text:SetText(name)
	if tip then
		bu:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(bu, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	bu:SetScript("OnClick", function()
		if bu:GetChecked() then
			aCoreCDB[bu.value] = true
		else
			aCoreCDB[bu.value] = false
		end
	end)
	tinsert(checkbuttons, bu)
	return bu
end

local function createeditbox(parent, index, name, value, tip)
	local box = CreateFrame("EditBox", "AltzGUI"..name.."EditBox", parent)
	box.value = value
	box:SetSize(120, 20)
	box:SetPoint("TOPLEFT", 16, 10-index*30)
	box.name = box:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	box.name:SetPoint("LEFT", box, "RIGHT", 10, 1)
	box.name:SetText(name)
	box:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	box:SetScript("OnShow", function(self) self:SetText(aCoreCDB[box.value]) end)
	box:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB[box.value]) self:ClearFocus() end)
	box:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		aCoreCDB[box.value] = self:GetText()
	end)
	if tip then
		box:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(box, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	tinsert(editboxes, box)
	return box
end

local function createslider(parent, index, name, value, min, max, step, tip)
	local slider = CreateFrame("Slider", "oUF_Mlight"..name.."Slider", parent, "OptionsSliderTemplate")
	slider.value = value
	slider:SetWidth(150)
	slider:SetPoint("TOPLEFT", 16, 10-index*30)
	slider.name = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	slider.name:SetPoint("LEFT", slider, "RIGHT", 10, 1)
	slider.name:SetText(name)
	BlizzardOptionsPanel_Slider_Enable(slider)
	slider:SetMinMaxValues(min, max)
	slider:SetValueStep(step)
	slider:SetScript("OnValueChanged", function(self, getvalue)
		oUF_MlightDB[slider.value] = getvalue
	end)
	if tip then
		slider:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(slider, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		slider:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	tinsert(sliders, slider)
	return slider
end

--====================================================--
--[[             -- aMode GUI --                    ]]--
--====================================================--
local aModgui = CreateFrame("Frame", "AltzUI GUI Frame", UIParent)
aModgui.name = ("AltzUI")
InterfaceOptions_AddCategory(aModgui)

aModgui.title = aModgui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aModgui.title:SetPoint("TOPLEFT", 15, -20)
aModgui.title:SetText("AltzUI v."..GetAddOnMetadata("aCore", "Version"))

aModgui.line = aModgui:CreateTexture(nil, "ARTWORK")
aModgui.line:SetSize(600, 1)
aModgui.line:SetPoint("TOP", 0, -50)
aModgui.line:SetTexture(1, 1, 1, .2)

aModgui.intro = aModgui:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
aModgui.intro:SetText(L["Reload UI to apply settings"])
aModgui.intro:SetPoint("TOPLEFT", 20, -60)

local reloadbu = CreateFrame("Button", "AltzUIReLoadButton", aModgui, "UIPanelButtonTemplate")
reloadbu:SetPoint("TOPRIGHT", -16, -20)
reloadbu:SetSize(150, 25)
reloadbu:SetText(APPLY)
reloadbu:SetScript("OnClick", function()
	ReloadUI()
end)

local scrollFrame = CreateFrame("ScrollFrame", "AltzUI GUI Frame_ScrollFrame", aModgui, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", aModgui, "TOPLEFT", 10, -80)
scrollFrame:SetPoint("BOTTOMRIGHT", aModgui, "BOTTOMRIGHT", -35, 0)
scrollFrame:SetFrameLevel(aModgui:GetFrameLevel()+1)
	
scrollFrame.Anchor = CreateFrame("Frame", "AltzUI GUI Frame_ScrollAnchor", scrollFrame)
scrollFrame.Anchor:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -3)
scrollFrame.Anchor:SetWidth(scrollFrame:GetWidth()-30)
scrollFrame.Anchor:SetHeight(scrollFrame:GetHeight()+200)
scrollFrame.Anchor:SetFrameLevel(scrollFrame:GetFrameLevel()+1)
scrollFrame:SetScrollChild(scrollFrame.Anchor)

local aChattitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aChattitle:SetPoint("TOPLEFT", 16, 3-1*30)
aChattitle:SetText(CHAT)

local channelreplacementbu = createcheckbutton(scrollFrame.Anchor, 2, L["Replace Channel Name"], "channelreplacement", L["Replace Channel Name2"])
local autoscrollbu = createcheckbutton(scrollFrame.Anchor, 3, L["Scroll Chat Frame"], "autoscroll", L["Scroll Chat Frame2"])

local aPlatetitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aPlatetitle:SetPoint("TOPLEFT", 16, 3-4*30)
aPlatetitle:SetText(UNIT_NAMEPLATES)

local autotoggleplatesbu = createcheckbutton(scrollFrame.Anchor, 5, L["Auto Toggle"], "autotoggleplates", L["Auto Toggle2"])
local threatplatesbu = createcheckbutton(scrollFrame.Anchor, 6, L["Threat Color"], "threatplates", L["Threat Color2"])

local aTiptitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aTiptitle:SetPoint("TOPLEFT", 16, 3-7*30)
aTiptitle:SetText(USE_UBERTOOLTIPS)

local cursorbu = createcheckbutton(scrollFrame.Anchor, 8, L["Show at Mouse"], "cursor", L["Show at Mouse2"])
local hideRealmbu = createcheckbutton(scrollFrame.Anchor, 9, L["Hide Realm"], "hideRealm", L["Hide Realm2"])
local hideTitlesbu = createcheckbutton(scrollFrame.Anchor, 10, L["Hide Title"], "hideTitles", L["Hide Title2"])
local showspellIDbu = createcheckbutton(scrollFrame.Anchor, 11, L["Show SpellID"], "showspellID", L["Show SpellID2"])
local colorborderClassbu = createcheckbutton(scrollFrame.Anchor, 12, L["Class Color"], "colorborderClass", L["Class Color2"])
local combathidebu = createcheckbutton(scrollFrame.Anchor, 13, L["Hide in Combat"], "combathide", L["Hide in Combat2"])

local aTweakstitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aTweakstitle:SetPoint("TOPLEFT", 16, 3-14*30)
aTweakstitle:SetText(OTHER)

local autoscreenshotbu = createcheckbutton(scrollFrame.Anchor, 15, L["Achievement Shot"], "autoscreenshot", L["Achievement Shot2"])
local alreadyknownbu = createcheckbutton(scrollFrame.Anchor, 16, L["Colorizes Known Items"], "alreadyknown", L["Colorizes Known Items2"])
local collectgarbagebu = createcheckbutton(scrollFrame.Anchor, 17, L["Collect Garbage"], "collectgarbage", L["Collect Garbage2"])
local acceptresbu = createcheckbutton(scrollFrame.Anchor, 18, L["Accept Resurrects"], "acceptres", L["Accept Resurrects2"])
local battlegroundresbu = createcheckbutton(scrollFrame.Anchor, 19, L["Releases Spirit in BG"], "battlegroundres", L["Releases Spirit in BG2"])
local hideerrorsbu = createcheckbutton(scrollFrame.Anchor, 20, L["Hide Errors"], "hideerrors", L["Hide Errors2"])
local acceptfriendlyinvitesbu = createcheckbutton(scrollFrame.Anchor, 21, L["Accept Invites"], "acceptfriendlyinvites", L["Accept Invites2"])
local autoquestsbu = createcheckbutton(scrollFrame.Anchor, 22, L["Auto Quests"], "autoquests", L["Auto Quests2"])
local combattextbu = createcheckbutton(scrollFrame.Anchor, 23, L["Combat Text"], "combattext", L["Combat Text2"])
local saysappedbu = createcheckbutton(scrollFrame.Anchor, 24, L["Say Sapped"], "saysapped", L["Say Sapped2"])
local raidcdenablebu = createcheckbutton(scrollFrame.Anchor, 25, L["RaidCD"], "raidcdenable", L["RaidCD2"])

local raidcdwidthbox = createeditbox(scrollFrame.Anchor, 26, L["RaidCD Width"], "raidcdwidth")
local raidcdheightbox = createeditbox(scrollFrame.Anchor, 27, L["RaidCD Height"], "raidcdheight")
local raidcdfontsizebox = createeditbox(scrollFrame.Anchor, 28, L["RaidCD FontSize"], "raidcdfontsize")

local atitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aTweakstitle:SetPoint("TOPLEFT", 16, 3-14*30)
aTweakstitle:SetText(OTHER)

--====================================================--
--[[             -- rFrame GUI --                    ]]--
--====================================================--

local rFramegui = CreateFrame("Frame", "rFrame GUI Frame", UIParent)
rFramegui.name = ("Actionbar and Buffframe")
rFramegui.parent = ("AltzUI")
InterfaceOptions_AddCategory(rFramegui)

rFramegui.title = rFramegui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
rFramegui.title:SetPoint("TOPLEFT", 15, -20)
rFramegui.title:SetText(L["Actionbar and Buffframe"])

rFramegui.line = rFramegui:CreateTexture(nil, "ARTWORK")
rFramegui.line:SetSize(600, 1)
rFramegui.line:SetPoint("TOP", 0, -50)
rFramegui.line:SetTexture(1, 1, 1, .2)

rFramegui.intro = rFramegui:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
rFramegui.intro:SetText(L["Reload UI to apply settings"])
rFramegui.intro:SetPoint("TOPLEFT", 20, -60)

local reloadbu2 = CreateFrame("Button", "AltzUIReLoadButton2", rFramegui, "UIPanelButtonTemplate")
reloadbu2:SetPoint("TOPRIGHT", -16, -20)
reloadbu2:SetSize(150, 25)
reloadbu2:SetText(APPLY)
reloadbu2:SetScript("OnClick", function()
	ReloadUI()
end)

local scrollFrame2 = CreateFrame("ScrollFrame", "rFrame GUI Frame_ScrollFrame", rFramegui, "UIPanelScrollFrameTemplate")
scrollFrame2:SetPoint("TOPLEFT", rFramegui, "TOPLEFT", 10, -80)
scrollFrame2:SetPoint("BOTTOMRIGHT", rFramegui, "BOTTOMRIGHT", -35, 0)
scrollFrame2:SetFrameLevel(rFramegui:GetFrameLevel()+1)
	
scrollFrame2.Anchor = CreateFrame("Frame", "rFrame GUI Frame_ScrollAnchor", scrollFrame2)
scrollFrame2.Anchor:SetPoint("TOPLEFT", scrollFrame2, "TOPLEFT", 0, -3)
scrollFrame2.Anchor:SetWidth(scrollFrame2:GetWidth()-30)
scrollFrame2.Anchor:SetHeight(scrollFrame2:GetHeight()+200)
scrollFrame2.Anchor:SetFrameLevel(scrollFrame2:GetFrameLevel()+1)
scrollFrame2:SetScrollChild(scrollFrame2.Anchor)

local Actionbartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
Actionbartitle:SetPoint("TOPLEFT", 16, 3-1*30)
Actionbartitle:SetText(ACTIONBARS_LABEL)

local cooldownflashbu = createcheckbutton(scrollFrame2.Anchor, 2, L["cooldownflash"], "cooldownflash", L["cooldownflash2"])
local cooldownbu = createcheckbutton(scrollFrame2.Anchor, 3, L["cooldown"], "cooldown", L["cooldown2"])
local rangecolorbu = createcheckbutton(scrollFrame2.Anchor, 4, L["rangecolor"], "rangecolor", L["rangecolor2"])

local bar12title = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
bar12title:SetPoint("TOPLEFT", 16, 3-5*30)
bar12title:SetText(L["Bar1&2"])

local bar12sizebox = createeditbox(scrollFrame2.Anchor, 6, L["buttonsize"], "bar12size")
local bar12spacebox = createeditbox(scrollFrame2.Anchor, 7, L["buttonspace"], "bar12space")
local bar12mfadebu = createcheckbutton(scrollFrame2.Anchor, 8, L["mousefade"], "bar12mfade", L["mousefade2"])
local bar12efadebu = createcheckbutton(scrollFrame2.Anchor, 9, L["eventfade"], "bar12efade", L["eventfade2"])
local bar12fademinaplhaslider = createslider(scrollFrame2.Anchor, 10, L["fademinalpha"], "bar12fademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local bar3title = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
bar3title:SetPoint("TOPLEFT", 16, 3-11*30)
bar3title:SetText(L["Bar3"])

local bar3uselayout322bu = createcheckbutton(scrollFrame2.Anchor, 12, L["Bar3 layout322"], "bar3uselayout322", L["Bar3 layout3222"])
local space1box = createeditbox(scrollFrame2.Anchor, 13, L["bar3space"], "space1", L["bar3space2"])
local bar3sizebox = createeditbox(scrollFrame2.Anchor, 14, L["buttonsize"], "bar3size")
local bar3spacebox = createeditbox(scrollFrame2.Anchor, 15, L["buttonspace"], "bar3space")
local bar3mfadebu = createcheckbutton(scrollFrame2.Anchor, 16, L["mousefade"], "bar3mfade", L["mousefade2"])
local bar3efadebu = createcheckbutton(scrollFrame2.Anchor, 17, L["eventfade"], "bar3efade", L["eventfade2"])
local bar3fademinaplhaslider = createslider(scrollFrame2.Anchor, 18, L["fademinalpha"], "bar3fademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local bar45title = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
bar45title:SetPoint("TOPLEFT", 16, 3-19*30)
bar45title:SetText(L["Bar4&5"])

local bar45sizebox = createeditbox(scrollFrame2.Anchor, 20, L["buttonsize"], "bar45size")
local bar45spacebox = createeditbox(scrollFrame2.Anchor, 21, L["buttonspace"], "bar45space")
local bar45mfadebu = createcheckbutton(scrollFrame2.Anchor, 22, L["mousefade"], "bar45mfade", L["mousefade2"])
local bar45efadebu = createcheckbutton(scrollFrame2.Anchor, 23, L["eventfade"], "bar45efade", L["eventfade2"])
local bar45fademinaplhaslider = createslider(scrollFrame2.Anchor, 24, L["fademinalpha"], "bar45fademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local petbartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
petbartitle:SetPoint("TOPLEFT", 16, 3-25*30)
petbartitle:SetText(L["Petbar"])

local petbaruselayout5x2bu = createcheckbutton(scrollFrame2.Anchor, 26, L["petbaruselayout5x2"], "petbaruselayout5x2", L["petbaruselayout5x22"])
local petbarscaleslider = createslider(scrollFrame2.Anchor, 27, L["barscale"], "petbarscale", 0.5, 2.5, 0.1)
local petbuttonspacebox = createeditbox(scrollFrame2.Anchor, 28, L["buttonspace"], "petbuttonspace")
local petbarmfadebu = createcheckbutton(scrollFrame2.Anchor, 29, L["mousefade"], "petbarmfade", L["mousefade2"])
local petbarefadebu = createcheckbutton(scrollFrame2.Anchor, 30, L["eventfade"], "petbarefade", L["eventfade2"])
local petbarfademinaplhaslider = createslider(scrollFrame2.Anchor, 31, L["fademinalpha"], "petbarfademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local stancebartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
stancebartitle:SetPoint("TOPLEFT", 16, 3-32*30)
stancebartitle:SetText(L["Stancebar"])

local stancebarbuttonsziebox = createeditbox(scrollFrame2.Anchor, 33, L["buttonsize"], "stancebarbuttonszie")
local stancebarbuttonspacebox = createeditbox(scrollFrame2.Anchor, 34, L["buttonspace"], "stancebarbuttonspace")

local micromenutitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
micromenutitle:SetPoint("TOPLEFT", 16, 3-35*30)
micromenutitle:SetText(L["MicroMenu"])

local micromenuscaleslider = createslider(scrollFrame2.Anchor, 36, L["barscale"], "micromenuscale", 0.5, 2.5, 0.1)
local micromenufadebu = createcheckbutton(scrollFrame2.Anchor, 37, L["mousefade"], "micromenufade", L["mousefade2"])
local micromenuminalphaslider = createslider(scrollFrame2.Anchor, 38, L["fademinalpha"], "micromenuminalpha", 0, 0.8, 0.05, L["fademinalpha2"])

local leave_vehicletitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
leave_vehicletitle:SetPoint("TOPLEFT", 16, 3-39*30)
leave_vehicletitle:SetText(L["leave_vehicle"])

local leave_vehiclebuttonsizebox = createeditbox(scrollFrame2.Anchor, 40, L["buttonsize"], "leave_vehiclebuttonsize")

local extrabartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
extrabartitle:SetPoint("TOPLEFT", 16, 3-41*30)
extrabartitle:SetText(L["extrabarbutton"])

local extrabarbuttonsizebox = createeditbox(scrollFrame2.Anchor, 42, L["buttonsize"], "extrabarbuttonsize")

local BuffFrametitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
BuffFrametitle:SetPoint("TOPLEFT", 16, 3-43*30)
BuffFrametitle:SetText(BUFFOPTIONS_LABEL)

local buffrowspacebox = createeditbox(scrollFrame2.Anchor, 44, L["buffrowspace"], "buffrowspace")
local buffcolspacebox = createeditbox(scrollFrame2.Anchor, 45, L["buffcolspace"], "buffcolspace")
local buffsPerRowbox = createeditbox(scrollFrame2.Anchor, 46, L["buffsPerRow"], "buffsPerRow")
local buffdebuffgapbox = createeditbox(scrollFrame2.Anchor, 47, L["buffdebuffgap"], "buffdebuffgap")
--====================================================--
--[[               -- Reset UI --                   ]]--
--====================================================--
local resetui = CreateFrame("Frame", "AltzUI Reset Frame", UIParent)
resetui.name = ("AltzUI Reset")
resetui.parent = ("AltzUI")
InterfaceOptions_AddCategory(resetui)

resetui.title = resetui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
resetui.title:SetPoint("TOPLEFT", 15, -20)
resetui.title:SetText(L["AltzUI Reset Settings"])

resetui.line = resetui:CreateTexture(nil, "ARTWORK")
resetui.line:SetSize(600, 1)
resetui.line:SetPoint("TOP", 0, -50)
resetui.line:SetTexture(1, 1, 1, .2)

resetui.intro = resetui:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
resetui.intro:SetText(L["Reset tip"])
resetui.intro:SetPoint("TOPLEFT", 20, -60)

local resetbu = CreateFrame("Button", "AltzUIResetButton", resetui, "UIPanelButtonTemplate")
resetbu:SetPoint("TOPRIGHT", -16, -20)
resetbu:SetSize(150, 25)
resetbu:SetText(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
resetbu:SetScript("OnClick", function()
	if aCoreCDB.notmeet then
		ns.ResetDefault()
	else
		ns.LoadaModVariables()
	end
	ReloadUI()
end)

local ResetDefault = createcheckbutton(resetui, 1, L["Reset All Settings"], "notmeet")
ResetDefault:SetPoint("TOPLEFT", 16, -95)
local setClassColorbu = createRSbutton(resetui, 3, "!ClassColors", "setClassColor", L["Reset ClassColor"])
local setDBMbu = createRSbutton(resetui, 4, "DBM-Core", "setDBM", L["Reset DBM"])
local setSkadabu = createRSbutton(resetui, 5, "Skada", "setSkada", L["Reset Skada"])
local setsetNumerationbu = createRSbutton(resetui, 6, "Numeration", "setNumeration", L["Reset Numeration"])
local setOMFbu = createRSbutton(resetui, 7, "oUF_MovableFrames", "setOMF", L["Reset OMF"])

--====================================================--
--[[                -- Init --                      ]]--
--====================================================--
local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

function eventframe:ADDON_LOADED(arg1)
	if arg1 ~= "aCore" then return end
	if not aCoreCDB or aCoreCDB == nil then 
		ns.LoadaModVariables()
	end
	for i = 1, #checkbuttons do
		F.ReskinCheck(checkbuttons[i])
	end
	for i = 1, #editboxes do
		F.CreateBD(editboxes[i])
	end
	for i = 1, #sliders do
		F.ReskinSlider(sliders[i])
	end
	F.Reskin(reloadbu)
	F.Reskin(reloadbu2)
	F.Reskin(resetbu)
	F.ReskinScroll(_G["AltzUI GUI Frame_ScrollFrameScrollBar"])
	F.ReskinScroll(_G["rFrame GUI Frame_ScrollFrameScrollBar"])
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function eventframe:PLAYER_ENTERING_WORLD(arg1)
	for i = 1, #checkbuttons do
		checkbuttons[i]:SetChecked(aCoreCDB[checkbuttons[i].value] == true)
	end
	for i = 1, #sliders do
		sliders[i]:SetValue(aCoreCDB[sliders[i].value])
	end
	for i = 1, #resetbuttons do
		if not IsAddOnLoaded(resetbuttons[i].addon) then
			resetbuttons[i]:Disable()
		end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end