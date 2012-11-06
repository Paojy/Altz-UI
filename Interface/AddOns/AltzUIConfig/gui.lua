local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

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
	bu:SetScript("OnClick", function()
		if bu:GetChecked() then
			aCoreCDB[bu.value] = true
		else
			aCoreCDB[bu.value] = false
		end
	end)
	bu:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(bu, "ANCHOR_RIGHT", 10, 10)
		GameTooltip:AddLine(tip)
		GameTooltip:Show() 
	end)
	bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
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
	bu:SetScript("OnClick", function()
		if bu:GetChecked() then
			aCoreCDB[bu.value] = true
		else
			aCoreCDB[bu.value] = false
		end
	end)
	if tip then
		bu:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(bu, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end	
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
		aCoreCDB[slider.value] = getvalue
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

-- dependency relationship
local function createDR(parent, ...)
    for i=1, select("#", ...) do
		local object = select(i, ...)
		if object:GetObjectType() == "Slider" then
			parent:HookScript("OnShow", function(self)
				if self:GetChecked() then
					BlizzardOptionsPanel_Slider_Enable(object)
				else
					BlizzardOptionsPanel_Slider_Disable(object)
				end
			end)
			parent:HookScript("OnClick", function(self)
				if self:GetChecked() then
					BlizzardOptionsPanel_Slider_Enable(object)
				else
					BlizzardOptionsPanel_Slider_Disable(object)
				end
			end)	
		else
			parent:HookScript("OnShow", function(self)
				if self:GetChecked() then
					object:Enable()
				else
					object:Disable()
				end
			end)
			parent:HookScript("OnClick", function(self)
				if self:GetChecked() then
					object:Enable()
				else
					object:Disable()
				end
			end)
		end
    end
end
--====================================================--
--[[                -- GUI --                       ]]--
--====================================================--
local aModgui = CreateFrame("Frame", "AltzUI GUI Frame", UIParent)
aModgui.name = ("AltzUI")
InterfaceOptions_AddCategory(aModgui)

aModgui.title = aModgui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aModgui.title:SetPoint("TOPLEFT", 15, -20)
aModgui.title:SetText("AltzUI v."..G.Version)

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

local Bagtitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
Bagtitle:SetPoint("TOPLEFT", 16, 3-1*30)
Bagtitle:SetText(BAGSLOT)

local enablebagbu = createcheckbutton(scrollFrame.Anchor, 2, L["Enable Bag"], "enablebag")

local Chattitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
Chattitle:SetPoint("TOPLEFT", 16, 3-3*30)
Chattitle:SetText(CHAT)

local enablechatbu = createcheckbutton(scrollFrame.Anchor, 4, L["Enable Chat"], "enablechat")
local channelreplacementbu = createcheckbutton(scrollFrame.Anchor, 5, L["Replace Channel Name"], "channelreplacement", L["Replace Channel Name2"])
local autoscrollbu = createcheckbutton(scrollFrame.Anchor, 6, L["Scroll Chat Frame"], "autoscroll", L["Scroll Chat Frame2"])

local aPlatetitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aPlatetitle:SetPoint("TOPLEFT", 16, 3-7*30)
aPlatetitle:SetText(UNIT_NAMEPLATES)

local enableplatebu = createcheckbutton(scrollFrame.Anchor, 8, L["Enable Plate"], "enableplate")
local platewidthbox = createeditbox(scrollFrame.Anchor, 9, L["Plate Width"], "platewidth")
local plateheightbox = createeditbox(scrollFrame.Anchor, 10, L["Plate Height"], "plateheight")
local autotoggleplatesbu = createcheckbutton(scrollFrame.Anchor, 11, L["Auto Toggle"], "autotoggleplates", L["Auto Toggle2"])
local threatplatesbu = createcheckbutton(scrollFrame.Anchor, 12, L["Threat Color"], "threatplates", L["Threat Color2"])
local platedebuffbu = createcheckbutton(scrollFrame.Anchor, 13, L["Plate Debuff"], "platedebuff", L["Plate Debuff2"])
local platebuffbu = createcheckbutton(scrollFrame.Anchor, 14, L["Plate Buff"], "platebuff", L["Plate Buff2"])
local plateauranumbox = createeditbox(scrollFrame.Anchor, 15, L["Plate Aura Number"], "plateauranum")
local plateaurasizebox = createeditbox(scrollFrame.Anchor, 16, L["Plate Aura Size"], "plateaurasize")
createDR(enableplatebu, platewidthbox, plateheightbox, autotoggleplatesbu, threatplatesbu, platedebuffbu, platebuffbu, plateauranumbox, plateaurasizebox)

local aTiptitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aTiptitle:SetPoint("TOPLEFT", 16, 3-17*30)
aTiptitle:SetText(USE_UBERTOOLTIPS)

local enabletipbu = createcheckbutton(scrollFrame.Anchor, 18, L["Enable Tip"], "enabletip")
local cursorbu = createcheckbutton(scrollFrame.Anchor, 19, L["Show at Mouse"], "cursor", L["Show at Mouse2"])
local hideRealmbu = createcheckbutton(scrollFrame.Anchor, 20, L["Hide Realm"], "hideRealm", L["Hide Realm2"])
local hideTitlesbu = createcheckbutton(scrollFrame.Anchor, 21, L["Hide Title"], "hideTitles", L["Hide Title2"])
local showspellIDbu = createcheckbutton(scrollFrame.Anchor, 22, L["Show SpellID"], "showspellID", L["Show SpellID2"])
local showtalentbu = createcheckbutton(scrollFrame.Anchor, 23, L["Show Talent"], "showtalent", L["Show Talent2"])
local colorborderClassbu = createcheckbutton(scrollFrame.Anchor, 24, L["Class Color"], "colorborderClass", L["Class Color2"])
local combathidebu = createcheckbutton(scrollFrame.Anchor, 25, L["Hide in Combat"], "combathide", L["Hide in Combat2"])
createDR(enabletipbu, cursorbu, hideRealmbu, hideTitlesbu, showspellIDbu, colorborderClassbu, combathidebu)

local aCT = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aCT:SetPoint("TOPLEFT", 16, 3-26*30)
aCT:SetText(L["Combat Text"])

local combattextbu = createcheckbutton(scrollFrame.Anchor, 27, L["Enalbe CT"], "combattext")
local showreceivedctbu = createcheckbutton(scrollFrame.Anchor, 28, L["ReceivedCT"], "showreceivedct")
local showoutputctbu = createcheckbutton(scrollFrame.Anchor, 29, L["OutPutCT"], "showoutputct")
local ctfliterbu = createcheckbutton(scrollFrame.Anchor, 30, L["Fliter CT"], "ctfliter", L["Fliter CT2"])
local cticonsizeslider = createslider(scrollFrame.Anchor, 31, L["CT icon size"], "cticonsize", 10, 30, 1)
local ctbigiconsizeslider = createslider(scrollFrame.Anchor, 32, L["CT crit icon size"], "ctbigiconsize", 10, 30, 1)
local ctshowdotsbu = createcheckbutton(scrollFrame.Anchor, 33, L["CT show dot"], "ctshowdots")
local ctshowhotsbu = createcheckbutton(scrollFrame.Anchor, 34, L["CT show hot"], "ctshowhots")
local ctfadetimeslider = createslider(scrollFrame.Anchor, 35, L["CT fade time"], "ctfadetime", 2, 10, 0.5, L["CT fade time2"])
createDR(combattextbu, showreceivedctbu, showoutputctbu, ctfliterbu, cticonsizeslider, ctbigiconsizeslider, ctshowdotsbu, ctshowhotsbu, ctfadetimeslider)

local aTweakstitle = scrollFrame.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
aTweakstitle:SetPoint("TOPLEFT", 16, 3-36*30)
aTweakstitle:SetText(OTHER)

local autorepairbu = createcheckbutton(scrollFrame.Anchor, 37, L["autorepair"], "autorepair", L["autorepair2"])
local autorepair_guildbu = createcheckbutton(scrollFrame.Anchor, 38, L["autorepair_guild"], "autorepair_guild", L["autorepair_guild2"])
local autosellbu = createcheckbutton(scrollFrame.Anchor, 39, L["autosell"], "autosell", L["autosell2"])
local helmcloakbuttonsbu = createcheckbutton(scrollFrame.Anchor, 40, L["helmcloakbuttons"], "helmcloakbuttons", L["helmcloakbuttons2"])
local undressbuttonbu = createcheckbutton(scrollFrame.Anchor, 41, L["undressbutton"], "undressbutton", L["undressbutton2"])
local autoscreenshotbu = createcheckbutton(scrollFrame.Anchor, 42, L["Achievement Shot"], "autoscreenshot", L["Achievement Shot2"])
local alreadyknownbu = createcheckbutton(scrollFrame.Anchor, 43, L["Colorizes Known Items"], "alreadyknown", L["Colorizes Known Items2"])
local collectgarbagebu = createcheckbutton(scrollFrame.Anchor, 44, L["Collect Garbage"], "collectgarbage", L["Collect Garbage2"])
local acceptresbu = createcheckbutton(scrollFrame.Anchor, 45, L["Accept Resurrects"], "acceptres", L["Accept Resurrects2"])
local battlegroundresbu = createcheckbutton(scrollFrame.Anchor, 46, L["Releases Spirit in BG"], "battlegroundres", L["Releases Spirit in BG2"])
local hideerrorsbu = createcheckbutton(scrollFrame.Anchor, 47, L["Hide Errors"], "hideerrors", L["Hide Errors2"])
local acceptfriendlyinvitesbu = createcheckbutton(scrollFrame.Anchor, 48, L["Accept Invites"], "acceptfriendlyinvites", L["Accept Invites2"])
local autoquestsbu = createcheckbutton(scrollFrame.Anchor, 49, L["Auto Quests"], "autoquests", L["Auto Quests2"])
local saysappedbu = createcheckbutton(scrollFrame.Anchor, 50, L["Say Sapped"], "saysapped", L["Say Sapped2"])
local camerabu = createcheckbutton(scrollFrame.Anchor, 51, L["camera"], "camera", L["camera2"])
local raidcdenablebu = createcheckbutton(scrollFrame.Anchor, 52, L["RaidCD"], "raidcdenable", L["RaidCD2"])

local raidcdwidthbox = createeditbox(scrollFrame.Anchor, 53, L["RaidCD Width"], "raidcdwidth")
local raidcdheightbox = createeditbox(scrollFrame.Anchor, 54, L["RaidCD Height"], "raidcdheight")
local raidcdfontsizebox = createeditbox(scrollFrame.Anchor, 55, L["RaidCD FontSize"], "raidcdfontsize")

--====================================================--
--[[        -- Actionbar and Buff GUI --             ]]--
--====================================================--

local actionbargui = CreateFrame("Frame", "rFrame GUI Frame", UIParent)
actionbargui.name = ("Actionbar and Buffframe")
actionbargui.parent = ("AltzUI")
InterfaceOptions_AddCategory(actionbargui)

actionbargui.title = actionbargui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
actionbargui.title:SetPoint("TOPLEFT", 15, -20)
actionbargui.title:SetText(L["Actionbar and Buffframe"])

actionbargui.line = actionbargui:CreateTexture(nil, "ARTWORK")
actionbargui.line:SetSize(600, 1)
actionbargui.line:SetPoint("TOP", 0, -50)
actionbargui.line:SetTexture(1, 1, 1, .2)

actionbargui.intro = actionbargui:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftGrey")
actionbargui.intro:SetText(L["Reload UI to apply settings"])
actionbargui.intro:SetPoint("TOPLEFT", 20, -60)

local reloadbu2 = CreateFrame("Button", "AltzUIReLoadButton2", actionbargui, "UIPanelButtonTemplate")
reloadbu2:SetPoint("TOPRIGHT", -16, -20)
reloadbu2:SetSize(150, 25)
reloadbu2:SetText(APPLY)
reloadbu2:SetScript("OnClick", function()
	ReloadUI()
end)

local scrollFrame2 = CreateFrame("ScrollFrame", "rFrame GUI Frame_ScrollFrame", actionbargui, "UIPanelScrollFrameTemplate")
scrollFrame2:SetPoint("TOPLEFT", actionbargui, "TOPLEFT", 10, -80)
scrollFrame2:SetPoint("BOTTOMRIGHT", actionbargui, "BOTTOMRIGHT", -35, 0)
scrollFrame2:SetFrameLevel(actionbargui:GetFrameLevel()+1)
	
scrollFrame2.Anchor = CreateFrame("Frame", "rFrame GUI Frame_ScrollAnchor", scrollFrame2)
scrollFrame2.Anchor:SetPoint("TOPLEFT", scrollFrame2, "TOPLEFT", 0, -3)
scrollFrame2.Anchor:SetWidth(scrollFrame2:GetWidth()-30)
scrollFrame2.Anchor:SetHeight(scrollFrame2:GetHeight()+200)
scrollFrame2.Anchor:SetFrameLevel(scrollFrame2:GetFrameLevel()+1)
scrollFrame2:SetScrollChild(scrollFrame2.Anchor)

local Actionbartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
Actionbartitle:SetPoint("TOPLEFT", 16, 3-1*30)
Actionbartitle:SetText(ACTIONBARS_LABEL)

local cooldownbu = createcheckbutton(scrollFrame2.Anchor, 2, L["cooldown"], "cooldown", L["cooldown2"])
local rangecolorbu = createcheckbutton(scrollFrame2.Anchor, 3, L["rangecolor"], "rangecolor", L["rangecolor2"])
local keybindsizebox = createeditbox(scrollFrame2.Anchor, 4, L["keybindsize"], "keybindsize")
local macronamesizebox = createeditbox(scrollFrame2.Anchor, 5, L["macronamesize"], "macronamesize")
local countsizebox = createeditbox(scrollFrame2.Anchor, 6, L["countsize"], "countsize")

local bar12title = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
bar12title:SetPoint("TOPLEFT", 16, 3-7*30)
bar12title:SetText(L["Bar1&2"])

local bar12sizebox = createeditbox(scrollFrame2.Anchor, 8, L["buttonsize"], "bar12size")
local bar12spacebox = createeditbox(scrollFrame2.Anchor, 9, L["buttonspace"], "bar12space")
local bar12mfadebu = createcheckbutton(scrollFrame2.Anchor, 10, L["mousefade"], "bar12mfade", L["mousefade2"])
local bar12efadebu = createcheckbutton(scrollFrame2.Anchor, 11, L["eventfade"], "bar12efade", L["eventfade2"])
local bar12fademinaplhaslider = createslider(scrollFrame2.Anchor, 12, L["fademinalpha"], "bar12fademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local bar3title = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
bar3title:SetPoint("TOPLEFT", 16, 3-13*30)
bar3title:SetText(L["Bar3"])

local bar3uselayout322bu = createcheckbutton(scrollFrame2.Anchor, 14, L["Bar3 layout322"], "bar3uselayout322", L["Bar3 layout3222"])
local space1box = createeditbox(scrollFrame2.Anchor, 15, L["bar3space"], "space1", L["bar3space2"])
local bar3sizebox = createeditbox(scrollFrame2.Anchor, 16, L["buttonsize"], "bar3size")
local bar3spacebox = createeditbox(scrollFrame2.Anchor, 17, L["buttonspace"], "bar3space")
local bar3mfadebu = createcheckbutton(scrollFrame2.Anchor, 18, L["mousefade"], "bar3mfade", L["mousefade2"])
local bar3efadebu = createcheckbutton(scrollFrame2.Anchor, 19, L["eventfade"], "bar3efade", L["eventfade2"])
local bar3fademinaplhaslider = createslider(scrollFrame2.Anchor, 20, L["fademinalpha"], "bar3fademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local bar45title = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
bar45title:SetPoint("TOPLEFT", 16, 3-21*30)
bar45title:SetText(L["Bar4&5"])

local bar45sizebox = createeditbox(scrollFrame2.Anchor, 22, L["buttonsize"], "bar45size")
local bar45spacebox = createeditbox(scrollFrame2.Anchor, 23, L["buttonspace"], "bar45space")
local bar45mfadebu = createcheckbutton(scrollFrame2.Anchor, 24, L["mousefade"], "bar45mfade", L["mousefade2"])
local bar45efadebu = createcheckbutton(scrollFrame2.Anchor, 25, L["eventfade"], "bar45efade", L["eventfade2"])
local bar45fademinaplhaslider = createslider(scrollFrame2.Anchor, 26, L["fademinalpha"], "bar45fademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local petbartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
petbartitle:SetPoint("TOPLEFT", 16, 3-27*30)
petbartitle:SetText(L["Petbar"])

local petbaruselayout5x2bu = createcheckbutton(scrollFrame2.Anchor, 28, L["petbaruselayout5x2"], "petbaruselayout5x2", L["petbaruselayout5x22"])
local petbarscaleslider = createslider(scrollFrame2.Anchor, 29, L["barscale"], "petbarscale", 0.5, 2.5, 0.1)
local petbuttonspacebox = createeditbox(scrollFrame2.Anchor, 30, L["buttonspace"], "petbuttonspace")
local petbarmfadebu = createcheckbutton(scrollFrame2.Anchor, 31, L["mousefade"], "petbarmfade", L["mousefade2"])
local petbarefadebu = createcheckbutton(scrollFrame2.Anchor, 32, L["eventfade"], "petbarefade", L["eventfade2"])
local petbarfademinaplhaslider = createslider(scrollFrame2.Anchor, 33, L["fademinalpha"], "petbarfademinaplha", 0, 0.8, 0.05, L["fademinalpha2"])

local stancebartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
stancebartitle:SetPoint("TOPLEFT", 16, 3-34*30)
stancebartitle:SetText(L["Stancebar"])

local stancebarbuttonsziebox = createeditbox(scrollFrame2.Anchor, 35, L["buttonsize"], "stancebarbuttonszie")
local stancebarbuttonspacebox = createeditbox(scrollFrame2.Anchor, 36, L["buttonspace"], "stancebarbuttonspace")

local micromenutitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
micromenutitle:SetPoint("TOPLEFT", 16, 3-37*30)
micromenutitle:SetText(L["MicroMenu"])

local micromenuscaleslider = createslider(scrollFrame2.Anchor, 38, L["barscale"], "micromenuscale", 0.5, 2.5, 0.1)
local micromenufadebu = createcheckbutton(scrollFrame2.Anchor, 39, L["mousefade"], "micromenufade", L["mousefade2"])
local micromenuminalphaslider = createslider(scrollFrame2.Anchor, 40, L["fademinalpha"], "micromenuminalpha", 0, 0.8, 0.05, L["fademinalpha2"])

local leave_vehicletitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
leave_vehicletitle:SetPoint("TOPLEFT", 16, 3-41*30)
leave_vehicletitle:SetText(L["leave_vehicle"])

local leave_vehiclebuttonsizebox = createeditbox(scrollFrame2.Anchor, 42, L["buttonsize"], "leave_vehiclebuttonsize")

local extrabartitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
extrabartitle:SetPoint("TOPLEFT", 16, 3-43*30)
extrabartitle:SetText(L["extrabarbutton"])

local extrabarbuttonsizebox = createeditbox(scrollFrame2.Anchor, 44, L["buttonsize"], "extrabarbuttonsize")

local BuffFrametitle = scrollFrame2.Anchor:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
BuffFrametitle:SetPoint("TOPLEFT", 16, 3-45*30)
BuffFrametitle:SetText(BUFFOPTIONS_LABEL)

local buffrowspacebox = createeditbox(scrollFrame2.Anchor, 46, L["buffrowspace"], "buffrowspace")
local buffcolspacebox = createeditbox(scrollFrame2.Anchor, 47, L["buffcolspace"], "buffcolspace")
local buffsPerRowbox = createeditbox(scrollFrame2.Anchor, 48, L["buffsPerRow"], "buffsPerRow")
local buffdebuffgapbox = createeditbox(scrollFrame2.Anchor, 49, L["buffdebuffgap"], "buffdebuffgap")
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
	T.ResetAllAddonSettings()
	if aCoreCDB.notmeet then
		T.Reset()
		T.SetChatFrame()
		T.LoadaModVariables()
		T.LoadResetVariables()
		aCoreCDB.notmeet = false
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
	if arg1 ~= "AltzUIConfig" then return end
	if aCoreCDB == nil then
		T.Reset()
		aCoreCDB.notmeet = true -- have we met?
	end
	T.LoadaModVariables()		
	T.LoadResetVariables()	
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