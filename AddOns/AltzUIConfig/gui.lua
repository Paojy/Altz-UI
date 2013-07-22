local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

--====================================================--
--[[             -- GUI Main Frame --               ]]--
--====================================================--
GUI = CreateFrame("Frame", G.uiname.."GUI Main Frame")
GUI:SetSize(650, 550)
GUI:SetPoint("CENTER", UIParent, "CENTER")
GUI:SetFrameStrata("HIGH")
GUI:SetFrameLevel(4)
GUI:Hide()

GUI:RegisterForDrag("LeftButton")
GUI:SetScript("OnDragStart", function(self) self:StartMoving() self:SetUserPlaced(false) end)
GUI:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
GUI:SetClampedToScreen(true)
GUI:SetMovable(true)
GUI:EnableMouse(true)

F.SetBD(GUI)

GUI.title = T.createtext(GUI, "OVERLAY", 20, "OUTLINE", "CENTER")
GUI.title:SetPoint("BOTTOM", GUI, "TOP", 0, -5)
GUI.title:SetText("|cffA6FFFFAltz UI  "..G.Version.."|r")

GUI.close = CreateFrame("Button", nil, GUI)
GUI.close:SetPoint("BOTTOMRIGHT", -10, 10)
GUI.close:SetSize(20, 20)
GUI.close:SetNormalTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
GUI.close:SetHighlightTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Highlight")
GUI.close:SetPushedTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down")
GUI.close:SetScript("OnClick", function()
	GUI:Hide()
end)

local ReloadButton = CreateFrame("Button", G.uiname.."ReloadButton", GUI, "UIPanelButtonTemplate")
ReloadButton:SetPoint("RIGHT", GUI.close, "LEFT", -15, 0)
ReloadButton:SetSize(100, 25)
ReloadButton:SetText(APPLY)
F.Reskin(ReloadButton)
ReloadButton:SetScript("OnClick", ReloadUI)

GUI.tabindex = 1
GUI.tabnum = 20
for i = 1, 20 do
	GUI["tab"..i] = CreateFrame("Frame", G.uiname.."GUI Tab"..i, GUI)
	GUI["tab"..i]:SetScript("OnMouseDown", function() end)
end
--====================================================--
--[[                   -- TABS --                    ]]--
--====================================================--
local function CreateTab(text, frame, parent, orientation, a)
	local tab = parent["tab"..parent.tabindex]
	tab.n = parent.tabindex
	tab.fname = frame:GetName()
	
	tab:SetFrameLevel(parent:GetFrameLevel()+2)
	
	if a then
		F.CreateBD(tab, a)
	else
		F.CreateBD(tab)
	end
	
	tab.name = T.createtext(tab, "OVERLAY", 12, "OUTLINE", "CENTER")
	tab.name:SetPoint("CENTER")
	tab.name:SetText(text)
	
	if orientation == "VERTICAL" then
		tab:SetSize(130, 25)
		if tab.n == 1 then
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end
		tab:HookScript("OnMouseDown", function(self)
			frame:Show()
			self:SetPoint("TOPLEFT", parent, "TOPRIGHT", 8, -30*tab.n)
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end)
		if tab.n == 1 then
			tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 8, -30)
		else
			tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2, -30*tab.n)
		end
		for i = 1, parent.tabnum do
			if i ~= tab.n then
				parent["tab"..i]:HookScript("OnMouseDown", function(self)
					frame:Hide()
					tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2,  -30*tab.n)
					tab:SetBackdropBorderColor(0, 0, 0)
				end)
			end
		end
	else
		tab:SetSize(tab.name:GetWidth()+10, 25)
		if tab.n == 1 then
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end
		tab:HookScript("OnMouseDown", function(self)
			frame:Show()
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end)
		for i = 1, parent.tabnum do
			if i == 1 then
				parent["tab"..i]:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 15, 2)
			else
				parent["tab"..i]:SetPoint("LEFT", parent["tab"..i-1], "RIGHT", 4, 0)
			end
			if i ~= tab.n then
				parent["tab"..i]:HookScript("OnMouseDown", function(self)
					frame:Hide()
					tab:SetBackdropBorderColor(0, 0, 0)
				end)
			end
		end
	end
	
	parent.tabindex = parent.tabindex +1
end

local function CreateOptionPage(name, title, parent, orientation, a, scroll)
	local Options = CreateFrame("Frame", G.uiname..name, parent)
	CreateTab(title, Options, parent, orientation, a)
	Options:SetAllPoints(parent)
	Options:Hide()

	Options.title = Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	Options.title:SetPoint("TOPLEFT", 35, -23)
	Options.title:SetText(title)

	Options.line = Options:CreateTexture(nil, "ARTWORK")
	Options.line:SetSize(parent:GetWidth()-50, 1)
	Options.line:SetPoint("TOP", 0, -50)
	Options.line:SetTexture(1, 1, 1, .2)
	
	if scroll then
		Options.SF = CreateFrame("ScrollFrame", G.uiname..name.." ScrollFrame", Options, "UIPanelScrollFrameTemplate")
		Options.SF:SetPoint("TOPLEFT", Options, "TOPLEFT", 10, -80)
		Options.SF:SetPoint("BOTTOMRIGHT", Options, "BOTTOMRIGHT", -45, 35)
		Options.SF:SetFrameLevel(Options:GetFrameLevel()+1)

		Options.SFAnchor = CreateFrame("Frame", G.uiname..name.." ScrollAnchor", Options.SF)
		Options.SFAnchor:SetPoint("TOPLEFT", Options.SF, "TOPLEFT", 0, -3)
		Options.SFAnchor:SetWidth(Options.SF:GetWidth()-30)
		Options.SFAnchor:SetHeight(Options.SF:GetHeight()+200)
		Options.SFAnchor:SetFrameLevel(Options.SF:GetFrameLevel()+1)
		
		Options.SF:SetScrollChild(Options.SFAnchor)
		
		F.ReskinScroll(_G[G.uiname..name.." ScrollFrameScrollBar"])
	end
	
	return Options
end
--====================================================--
--[[                -- Intro --                   ]]--
--====================================================--
local IntroOptions = CreateFrame("Frame", G.uiname.."Intro Frame", GUI)
IntroOptions:SetAllPoints(GUI)
CreateTab(L["Intro"], IntroOptions, GUI, "VERTICAL")

IntroOptions:SetScript("OnShow", function() ReloadButton:Hide() end)
IntroOptions:SetScript("OnHide", function() ReloadButton:Show() end)

local resetbu = CreateFrame("Button", G.uiname.."ResetButton", IntroOptions, "UIPanelButtonTemplate")
resetbu:SetPoint("BOTTOMLEFT", IntroOptions, "BOTTOM", 100, 80)
resetbu:SetSize(180, 25)
resetbu:SetText(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
F.Reskin(resetbu)
resetbu:SetScript("OnClick", function()
	aCoreCDB = {}
	T.SetChatFrame()
	T.LoadVariables()
	T.ResetAllAddonSettings()
	ReloadUI()
end)

--====================================================--
--[[              -- Chat Options --                ]]--
--====================================================--
local ChatOptions = CreateOptionPage("Chat Options", SOCIAL_LABEL, GUI, "VERTICAL")

T.createcheckbutton(ChatOptions, 30, 60, L["Replace Channel Name"], "ChatOptions", "channelreplacement", L["Replace Channel Name2"])
T.createcheckbutton(ChatOptions, 30, 90, L["Scroll Chat Frame"], "ChatOptions", "autoscroll", L["Scroll Chat Frame2"])
T.createcheckbutton(ChatOptions, 30, 120, L["Accept Invites"], "OtherOptions", "acceptfriendlyinvites", L["Accept Invites2"])
T.createcheckbutton(ChatOptions, 30, 150, L["Auto Invite"], "OtherOptions", "autoinvite", L["Auto Invite2"])
T.createeditbox(ChatOptions, 180, 152, "", "OtherOptions", "autoinvitekeywords", L["Auto Invite Key Word2"])
T.createDR(ChatOptions.autoinvite, ChatOptions.autoinvitekeywords)
--====================================================--
--[[          -- Bag and Items Options --           ]]--
--====================================================--
local ItemOptions = CreateOptionPage("Item Options", ITEMS, GUI, "VERTICAL", nil, true)

T.createcheckbutton(ItemOptions, 30, 60, L["Combine Bag"], "ItemOptions", "enablebag")
T.createcheckbutton(ItemOptions, 30, 90, L["Colorizes Known Items"], "ItemOptions", "alreadyknown", L["Colorizes Known Items2"])
T.createcheckbutton(ItemOptions, 30, 120, L["autorepair"], "ItemOptions", "autorepair", L["autorepair2"])
T.createcheckbutton(ItemOptions, 30, 150, L["autorepair_guild"], "ItemOptions", "autorepair_guild", L["autorepair_guild2"])
T.createcheckbutton(ItemOptions, 30, 180, L["autosell"], "ItemOptions", "autosell", L["autosell2"])
T.createcheckbutton(ItemOptions, 30, 210, L["autobuy"], "ItemOptions", "autobuy", L["autobuy2"])

ItemOptions.SF:ClearAllPoints()
ItemOptions.SF:SetPoint("TOPLEFT", ItemOptions, "TOPLEFT", 40, -280)
ItemOptions.SF:SetPoint("BOTTOMRIGHT", ItemOptions, "BOTTOMRIGHT", -300, 135)
F.CreateBD(ItemOptions.SF, .3)

StaticPopupDialogs[G.uiname.."incorrect item ID"] = {
	text = L["Incorrect Item ID"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect item quantity"]= {
	text = L["Incorrect Quantity"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

local function LineUpAutobuyList()
	sort(aCoreCDB["ItemOptions"]["autobuylist"])
	local index = 1
	for itemID, quantity in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
		if not itemID then return end
		_G["Altz AutobuyList Button"..itemID]:SetPoint("TOPLEFT", ItemOptions.SF, "TOPLEFT", 5, 20-index*30)
		index = index + 1
	end
end

local function CreateAutobuyButton(itemID, name, icon, quantity)
	local bu = CreateFrame("Frame", "Altz AutobuyList Button"..itemID, ItemOptions.SF)
	bu:SetSize(300, 28)
	F.CreateBD(bu, .2)
	
	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(20, 20)
	bu.icon:SetNormalTexture(icon)
	bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetPoint("LEFT", 5, 0)
	F.CreateBG(bu.icon)
	
	bu.name = T.createtext(bu, "OVERLAY", 16, "OUTLINE", "LEFT")
	bu.name:SetPoint("LEFT", 40, 0)
	bu.name:SetTextColor(1, .2, .6)
	bu.name:SetText(name)
	
	bu.num = T.createtext(bu, "OVERLAY", 16, "OUTLINE", "LEFT")
	bu.num:SetPoint("LEFT", 235, 0)
	bu.num:SetTextColor(1, 1, 0)
	bu.num:SetText(quantity)
	
	bu.close = CreateFrame("Button", nil, bu, "UIPanelButtonTemplate")
	bu.close:SetSize(18,18)
	bu.close:SetPoint("RIGHT", -5, 0)
	F.Reskin(bu.close)
	bu.close:SetText("x")
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(tonumber(itemID))
		GameTooltip:Show()
	end)
	bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	bu.close:SetScript("OnClick", function(self) 
		bu:Hide()
		aCoreCDB["ItemOptions"]["autobuylist"][itemID] = nil
		LineUpAutobuyList()
	end)
	
	return bu
end

local function CreateAutobuyButtonList()
	sort(aCoreCDB["ItemOptions"]["autobuylist"])
	for itemID, quantity in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
		if itemID then
			local name = GetItemInfo(tonumber(itemID))
			local icon = select(10, GetItemInfo(tonumber(itemID)))
			CreateAutobuyButton(itemID, name, icon, quantity)
		end
	end
	LineUpAutobuyList()
end

local Autobuy_iteminput = CreateFrame("EditBox", "Altz AutobuyList ItemInput", ItemOptions)
Autobuy_iteminput:SetSize(150, 20)
Autobuy_iteminput:SetPoint("TOPLEFT", 40, -250)
F.CreateBD(Autobuy_iteminput)

Autobuy_iteminput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
Autobuy_iteminput:SetAutoFocus(false)
Autobuy_iteminput:SetTextInsets(3, 0, 0, 0)

Autobuy_iteminput:SetScript("OnShow", function(self) self:SetText(L["input ItemID"]) end)
Autobuy_iteminput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
Autobuy_iteminput:SetScript("OnEscapePressed", function(self) self:ClearFocus() Autobuy_iteminput:SetText(L["input ItemID"]) end)
Autobuy_iteminput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

local Autobuy_quantityinput = CreateFrame("EditBox", "Altz AutobuyList QuantityInput", ItemOptions)
Autobuy_quantityinput:SetSize(80, 20)
Autobuy_quantityinput:SetPoint("LEFT", Autobuy_iteminput, "RIGHT", 15, 0)
F.CreateBD(Autobuy_quantityinput)

Autobuy_quantityinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
Autobuy_quantityinput:SetAutoFocus(false)
Autobuy_quantityinput:SetTextInsets(3, 0, 0, 0)

Autobuy_quantityinput:SetScript("OnShow", function(self) self:SetText(L["input Quantity"]) end)
Autobuy_quantityinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
Autobuy_quantityinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() Autobuy_quantityinput:SetText(L["input Quantity"]) end)
Autobuy_quantityinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

local Autobuy_additembutton = CreateFrame("Button", G.uiname.."Autobuy Add Item Button", ItemOptions, "UIPanelButtonTemplate")
Autobuy_additembutton:SetPoint("LEFT", Autobuy_quantityinput, "RIGHT", 15, 0)
Autobuy_additembutton:SetSize(50, 20)
Autobuy_additembutton:SetText(ADD)
F.Reskin(Autobuy_additembutton)
Autobuy_additembutton:SetScript("OnClick", function(self)
	local itemID = Autobuy_iteminput:GetText()
	local quantity = Autobuy_quantityinput:GetText()
	local name = GetItemInfo(itemID)
	if name and tonumber(quantity) then
		CreateAutobuyButton(itemID, name, select(10, GetItemInfo(itemID)), quantity)
		aCoreCDB["ItemOptions"]["autobuylist"][tostring(itemID)] = quantity
		LineUpAutobuyList()
	else
		if not name then
			StaticPopupDialogs[G.uiname.."incorrect item ID"].text = "|cff7FFF00"..itemID.." |r"..L["Incorrect Item ID"]
			StaticPopup_Show(G.uiname.."incorrect item ID")
		elseif not tonumber(quantity) then
			StaticPopupDialogs[G.uiname.."incorrect item quantity"].text = "|cff7FFF00"..quantity.." |r"..L["Incorrect Quantity"]
			StaticPopup_Show(G.uiname.."incorrect item quantity")
		end
	end
end)

--====================================================--
--[[               -- Unit Frames --                ]]--
--====================================================--
local UFOptions = CreateOptionPage("UF Options", L["Unit Frames"], GUI, "VERTICAL")

local UFInnerframe = CreateFrame("Frame", G.uiname.."UF Options Innerframe", UFOptions)
UFInnerframe:SetPoint("TOPLEFT", 40, -60)
UFInnerframe:SetPoint("BOTTOMLEFT", -20, 20)
UFInnerframe:SetWidth(UFOptions:GetWidth()-200)
F.CreateBD(UFInnerframe, .3)

UFInnerframe.tabindex = 1
UFInnerframe.tabnum = 20
for i = 1, 20 do
	UFInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."UFInnerframe Tab"..i, UFInnerframe)
	UFInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

UFInnerframe.style = CreateOptionPage("UF Options style", L["Style"], UFInnerframe, "VERTICAL", .3)
UFInnerframe.style:Show()

T.createcheckbutton(UFInnerframe.style, 30, 60, L["eventfade"], "UnitframeOptions", "enablefade", L["eventfade2"])
T.createslider(UFInnerframe.style, 30, 110, L["fademinalpha"], "UnitframeOptions", "fadingalpha", 100, 0, 80, 5, L["fademinalpha2"])
T.createDR(UFInnerframe.style.enablefade, UFInnerframe.style.fadingalpha)
T.createcheckbutton(UFInnerframe.style, 30, 150, L["enableportrait"], "UnitframeOptions", "portrait")
T.createslider(UFInnerframe.style, 30, 200, L["portraitalpha"], "UnitframeOptions", "portraitalpha", 100, 10, 100, 5, L["portraitalpha2"])
T.createDR(UFInnerframe.style.portrait, UFInnerframe.style.portraitalpha)
T.createcheckbutton(UFInnerframe.style, 30, 240, L["classcolormode"], "UnitframeOptions", "classcolormode", L["classcolormode2"])
T.createcheckbutton(UFInnerframe.style, 30, 270, L["transparentmode"], "UnitframeOptions", "transparentmode", L["transparentmode2"])
T.createcolorpickerbu(UFInnerframe.style, 40, 300, L["startcolor"], "UnitframeOptions", "startcolor", L["onlywhentransparent"])
T.createcolorpickerbu(UFInnerframe.style, 210, 300, L["endcolor"], "UnitframeOptions", "endcolor", L["onlywhentransparent"])
T.createcheckbutton(UFInnerframe.style, 30, 330, L["nameclasscolormode"], "UnitframeOptions", "nameclasscolormode", L["nameclasscolormode2"])
T.createcheckbutton(UFInnerframe.style, 30, 360, L["alwayshp"], "UnitframeOptions", "alwayshp", L["alwayshp2"])
T.createcheckbutton(UFInnerframe.style, 30, 390, L["alwayspp"], "UnitframeOptions", "alwayspp", L["alwayspp2"])

UFInnerframe.size = CreateOptionPage("UF Options size", L["Size"], UFInnerframe, "VERTICAL", .3)

T.createslider(UFInnerframe.size, 30, 80, L["height"], "UnitframeOptions", "height", 1, 5, 50, 1, L["height2"])
T.createslider(UFInnerframe.size, 30, 120, L["width"], "UnitframeOptions", "width", 1, 50, 500, 1, L["width2"])
T.createslider(UFInnerframe.size, 30, 160, L["widthpet"], "UnitframeOptions", "widthpet", 1, 50, 500, 1, L["widthpet2"])
T.createslider(UFInnerframe.size, 30, 200, L["widthboss"], "UnitframeOptions", "widthboss", 1, 50, 500, 1, L["widthboss2"])
T.createslider(UFInnerframe.size, 30, 240, L["scale"], "UnitframeOptions", "scale", 100, 50, 300, 5, L["scale2"])
T.createslider(UFInnerframe.size, 30, 280, L["hpheight"], "UnitframeOptions", "hpheight", 100, 20, 95, 5, L["hpheight2"])

UFInnerframe.castbar = CreateOptionPage("UF Options castbar", L["castbar"], UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.castbar, 30, 60, L["enablecastbars"], "UnitframeOptions", "castbars", L["enablecastbars2"])
T.createslider(UFInnerframe.castbar, 30, 110, L["cbIconsize"], "UnitframeOptions", "cbIconsize", 1, 10, 50, 1, L["cbIconsize2"])
T.createDR(UFInnerframe.castbar.castbars, UFInnerframe.castbar.cbIconsize)

UFInnerframe.aura = CreateOptionPage("UF Options aura", AURAS, UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.aura, 30, 60, L["enableauras"], "UnitframeOptions", "auras", L["enableauras2"])
T.createcheckbutton(UFInnerframe.aura, 30, 90, L["auraborders"], "UnitframeOptions", "auraborders", L["auraborders2"])
T.createslider(UFInnerframe.aura, 30, 140, L["aurasperrow"], "UnitframeOptions", "auraperrow", 1, 4, 20, 1, L["aurasperrow2"])
T.createcheckbutton(UFInnerframe.aura, 30, 180, L["enableplayerdebuff"], "UnitframeOptions", "playerdebuffenable", L["enableplayerdebuff2"])
T.createslider(UFInnerframe.aura, 30, 230, L["playerdebuffsperrow"], "UnitframeOptions", "playerdebuffnum", 1, 4, 20, 1, L["playerdebuffsperrow2"])
T.createcheckbutton(UFInnerframe.aura, 30, 270, L["AuraFilterignoreBuff"], "UnitframeOptions", "AuraFilterignoreBuff", L["AuraFilterignoreBuff2"])
T.createcheckbutton(UFInnerframe.aura, 30, 300, L["AuraFilterignoreDebuff"], "UnitframeOptions", "AuraFilterignoreDebuff", L["AuraFilterignoreDebuff2"])
local AuraFiltertext = UFInnerframe.aura:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
AuraFiltertext:SetPoint("TOPLEFT", 16, 320)
AuraFiltertext:SetText(L["aurafilterinfo"])
T.createDR(UFInnerframe.aura.auras, UFInnerframe.aura.auraperrow, UFInnerframe.aura.auraborders, UFInnerframe.aura.playerdebuffenable, UFInnerframe.aura.playerdebuffnum, UFInnerframe.aura.AuraFilterignoreBuff, UFInnerframe.aura.AuraFilterignoreDebuff)
T.createDR(UFInnerframe.aura.playerdebuffenable, UFInnerframe.aura.playerdebuffnum)

UFInnerframe.aurawhitelist = CreateOptionPage("UF Options aurawhitelist", L["WhiteList"], UFInnerframe, "VERTICAL", .3, true)
UFInnerframe.aurawhitelist.SF:SetPoint("TOPLEFT", 26, -80)

StaticPopupDialogs[G.uiname.."incorrect spellid"] = {
	text = L["Incorret Spell"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

local function LineUpAuraFliterList()
	sort(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"])
	local index = 1
	for spellID, name in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do
		if not spellID then return end
		_G["Altz WhiteList Button"..spellID]:SetPoint("TOPLEFT", UFInnerframe.aurawhitelist.SF, "TOPLEFT", 10, 20-index*30)
		index = index + 1
	end
end

local function CreateAuraFliterButton(name, icon, spellID)
	local wb = CreateFrame("Frame", "Altz WhiteList Button"..spellID, UFInnerframe.aurawhitelist.SF)
	wb:SetSize(350, 20)

	wb.icon = CreateFrame("Button", nil, wb)
	wb.icon:SetSize(18, 18)
	wb.icon:SetNormalTexture(icon)
	wb.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	wb.icon:SetPoint"LEFT"
	F.CreateBG(wb.icon)
	
	wb.spellid = T.createtext(wb, "OVERLAY", 12, "OUTLINE", "LEFT")
	wb.spellid:SetPoint("LEFT", 40, 0)
	wb.spellid:SetTextColor(1, .2, .6)
	wb.spellid:SetText(spellID)
	
	wb.spellname = T.createtext(wb, "OVERLAY", 12, "OUTLINE", "LEFT")
	wb.spellname:SetPoint("LEFT", 140, 0)
	wb.spellname:SetTextColor(1, 1, 0)
	wb.spellname:SetText(name)
	
	wb.close = CreateFrame("Button", nil, wb, "UIPanelButtonTemplate")
	wb.close:SetSize(18,18)
	wb.close:SetPoint("RIGHT")
	F.Reskin(wb.close)
	wb.close:SetText("x")
	
	wb:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	wb:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	wb.close:SetScript("OnClick", function() 
		wb:Hide()
		aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = nil
		print("|cffFF0000"..name.." |r"..L["remove frome white list"])
		LineUpAuraFliterList()
	end)
	
	return wb
end

local function CreateAuraFliterButtonList()
	sort(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"])
	for spellID, name in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do
		if spellID then
			local icon = select(3, GetSpellInfo(spellID))
			CreateAuraFliterButton(name, icon, spellID)
		end
	end
	LineUpAuraFliterList()
end

local AuraFliter_spellIDinput = CreateFrame("EditBox", "Altz WhiteList Input", UFInnerframe.aurawhitelist)
AuraFliter_spellIDinput:SetSize(250, 20)
AuraFliter_spellIDinput:SetPoint("TOPLEFT", 30, -60)
F.CreateBD(AuraFliter_spellIDinput)

AuraFliter_spellIDinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
AuraFliter_spellIDinput:SetAutoFocus(false)
AuraFliter_spellIDinput:SetTextInsets(3, 0, 0, 0)

AuraFliter_spellIDinput:SetScript("OnShow", function(self) self:SetText(L["input spellID"]) end)
AuraFliter_spellIDinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
AuraFliter_spellIDinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() AuraFliter_spellIDinput:SetText(L["input spellID"]) end)
AuraFliter_spellIDinput:SetScript("OnEnterPressed", function(self)
	local spellID = self:GetText()
	self:ClearFocus()
	local name, _, icon = GetSpellInfo(spellID)
	if name then
		CreateAuraFliterButton(name, icon, spellID)
		aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = name
		print("|cff7FFF00"..name.." |r"..L["add to white list"])
		LineUpAuraFliterList()
	else
		StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID.." |r"..L["not a corret Spell ID"]
		StaticPopup_Show(G.uiname.."incorrect spellid")
	end
end)

AuraFliter_spellIDinput:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
	GameTooltip:AddLine(L["aurafilterinfo"])
	GameTooltip:Show() 
end)
AuraFliter_spellIDinput:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		
UFInnerframe.other = CreateOptionPage("UF Options other", OTHER, UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.other, 30, 60, L["showthreatbar"], "UnitframeOptions", "showthreatbar", L["showthreatbar2"])
T.createcheckbutton(UFInnerframe.other, 30, 90, L["pvpicon"], "UnitframeOptions", "pvpicon", L["pvpicon2"])
T.createcheckbutton(UFInnerframe.other, 30, 120, L["bossframes"], "UnitframeOptions", "bossframes", L["bossframes2"])
T.createcheckbutton(UFInnerframe.other, 30, 150, L["arenaframes"], "UnitframeOptions", "arenaframes", L["arenaframes2"])
--====================================================--
--[[               -- Raid Frames --                ]]--
--====================================================--
local RFOptions = CreateOptionPage("RF Options", L["Raid Frames"], GUI, "VERTICAL")

local RFInnerframe = CreateFrame("Frame", G.uiname.."RF Options Innerframe", RFOptions)
RFInnerframe:SetPoint("TOPLEFT", 40, -60)
RFInnerframe:SetPoint("BOTTOMLEFT", -20, 20)
RFInnerframe:SetWidth(RFOptions:GetWidth()-200)
F.CreateBD(RFInnerframe, .3)

RFInnerframe.tabindex = 1
RFInnerframe.tabnum = 20
for i = 1, 20 do
	RFInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."RFInnerframe Tab"..i, RFInnerframe)
	RFInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

RFInnerframe.common = CreateOptionPage("RF Options common", L["Commonsettings"], RFInnerframe, "VERTICAL", .3)
RFInnerframe.common:Show()

T.createcheckbutton(RFInnerframe.common, 30, 60, L["enableraid"], "UnitframeOptions", "enableraid", L["enableraid2"])
T.createcheckbutton(RFInnerframe.common, 30, 90, L["showraidpet"], "UnitframeOptions", "showraidpet", L["showraidpet2"])
T.createcheckbutton(RFInnerframe.common, 30, 120, L["showsolo"], "UnitframeOptions", "showsolo", L["showsolo2"])
T.createslider(RFInnerframe.common, 30, 170, L["namelength"], "UnitframeOptions", "namelength", 1, 2, 10, 1, L["namelength2"])
T.createcheckbutton(RFInnerframe.common, 30, 210, L["enablearrow"], "UnitframeOptions", "enablearrow", L["enablearrow2"])
T.createslider(RFInnerframe.common, 30, 260, L["arrowsacle"], "UnitframeOptions", "arrowsacle", 100, 50, 200, 5, L["arrowsacle2"])
T.createDR(RFInnerframe.common.enablearrow, RFInnerframe.common.arrowsacle)

RFInnerframe.switch = CreateOptionPage("RF Options switch", L["switch"], RFInnerframe, "VERTICAL", .3)

T.createcheckbutton(RFInnerframe.switch, 30, 60, L["autoswitch"], "UnitframeOptions", "autoswitch", L["autoswitch2"])
raidonly_group = {
	["healer"] = L["raidonlyhealer"],
	["dps"] = L["raidonlydps"],
}
T.createradiobuttongroup(RFInnerframe.switch, 30, 90, L["Raid Mode"], "UnitframeOptions", "raidonly", raidonly_group)
T.createDR(RFInnerframe.switch.autoswitch, RFInnerframe.switch.raidonly)

RFInnerframe.healer = CreateOptionPage("RF Options healer", L["healerraidtext"], RFInnerframe, "VERTICAL", .3)

groupfilter_group = {
	["1,2,3,4,5"] = L["25-man"],
	["1,2,3,4,5,6,7,8"] = L["40-man"],
}
T.createradiobuttongroup(RFInnerframe.healer, 30, 60, L["groupsize"], "UnitframeOptions", "healergroupfilter", groupfilter_group)
T.createslider(RFInnerframe.healer, 30, 110, L["healerraidheight"], "UnitframeOptions", "healerraidheight", 1, 10, 150, 1, L["healerraidheight2"])
T.createslider(RFInnerframe.healer, 30, 150, L["healerraidwidth"], "UnitframeOptions", "healerraidwidth", 1, 10, 150, 1, L["healerraidwidth2"])
T.createcheckbutton(RFInnerframe.healer, 30, 190, L["raidmanabars"], "UnitframeOptions", "raidmanabars", L["raidmanabars2"])
T.createslider(RFInnerframe.healer,  30, 240, L["hpheight"], "UnitframeOptions", "raidhpheight", 100, 20, 95, 5, L["hpheight2"])
T.createDR(RFInnerframe.healer.raidmanabars, RFInnerframe.healer.raidhpheight)
raidanchor_group = {
	["LEFT"] = L["LEFT"],
	["TOP"] = L["TOP"],
}
T.createradiobuttongroup(RFInnerframe.healer, 30, 280, L["anchor"], "UnitframeOptions", "anchor", raidanchor_group)
T.createradiobuttongroup(RFInnerframe.healer, 30, 310, L["partyanchor"], "UnitframeOptions", "partyanchor", raidanchor_group)
T.createcheckbutton(RFInnerframe.healer, 30, 340, L["showgcd"], "UnitframeOptions", "showgcd", L["showgcd2"])
T.createcheckbutton(RFInnerframe.healer, 30, 370, L["showmisshp"], "UnitframeOptions", "showmisshp", L["showmisshp2"])
T.createcheckbutton(RFInnerframe.healer, 30, 400, L["healprediction"], "UnitframeOptions", "healprediction", L["healprediction2"])

RFInnerframe.dps = CreateOptionPage("RF Options dps", L["dpstankraidtext"], RFInnerframe, "VERTICAL", .3)

T.createradiobuttongroup(RFInnerframe.dps, 30, 60, L["groupsize"], "UnitframeOptions", "dpsgroupfilter", groupfilter_group)
T.createslider(RFInnerframe.dps, 30, 110, L["dpsraidheight"], "UnitframeOptions", "dpsraidheight", 1, 10, 150, 1, L["dpsraidheight2"])
T.createslider(RFInnerframe.dps, 30, 150, L["dpsraidwidth"], "UnitframeOptions", "dpsraidwidth", 1, 10, 150, 1, L["dpsraidwidth2"])
T.createcheckbutton(RFInnerframe.dps, 30, 190, L["dpsraidgroupbyclass"], "UnitframeOptions", "dpsraidgroupbyclass", L["dpsraidgroupbyclass2"])
T.createslider(RFInnerframe.dps, 30, 240, L["unitnumperline"], "UnitframeOptions", "unitnumperline", 1, 1, 40, 1, L["unitnumperline2"])

RFInnerframe.clickcast = CreateOptionPage("RF Options clickcast", L["ClickCast"], RFInnerframe, "VERTICAL", .3)

local enableClickCastbu = T.createcheckbutton(RFInnerframe.clickcast, 30, 60, L["enableClickCast"], "UnitframeOptions", "enableClickCast", L["clickcastinro"])

local clickcastframe = CreateFrame("Frame", G.uiname.."ClickCast Options", RFInnerframe.clickcast)
clickcastframe:SetPoint("TOPLEFT", 30, -120)
clickcastframe:SetPoint("BOTTOMRIGHT", -30, 20)
F.CreateBD(clickcastframe, 0)
clickcastframe.tabindex = 1
clickcastframe.tabnum = 20
for i = 1, 20 do
	clickcastframe["tab"..i] = CreateFrame("Frame", G.uiname.."clickcastframe Tab"..i, clickcastframe)
	clickcastframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

StaticPopupDialogs[G.uiname.."incorrect spell"] = {
	text = L["incorrect spell name"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."give macro"] = {
	text = L["enter a macro"],
	button1 = ACCEPT, 
	button2 = CANCEL,
	hasEditBox = 1,
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

local selectid, selectv
StaticPopupDialogs[G.uiname.."give macro"].OnAccept = function(self)
	local m = _G[self:GetName().."EditBox"]:GetText()
	aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"] = m
end

StaticPopupDialogs[G.uiname.."give macro"].OnShow = function(self)
	_G[self:GetName().."EditBox"]:SetAutoFocus(true)
	if not aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"] or aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"] == "" then
		_G[self:GetName().."EditBox"]:SetText(L["enter a macro"])
		_G[self:GetName().."EditBox"]:HighlightText()
	else
		_G[self:GetName().."EditBox"]:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"])
	end
end

local modifier = {"Click", "shift-", "ctrl-", "alt-"}

for i = 1, 5 do
	local index = tostring(i)
	clickcastframe["Button"..index] = CreateOptionPage("ClickCast Button"..index, L["Button"..index], clickcastframe, "HORIZONTAL", .3)
	clickcastframe["Button"..index].title:Hide()
	clickcastframe["Button"..index].line:Hide()
	if i == 1 then
		clickcastframe["Button"..index]:Show()
	end
	for k, v in pairs(modifier) do
		local inputbox = CreateFrame("EditBox", "ClickCast Button"..index..v.."EditBox", clickcastframe["Button"..index])
		inputbox:SetSize(150, 20)
		inputbox:SetPoint("TOPLEFT", 16, 20-k*30)
		F.CreateBD(inputbox)
		
		inputbox.name = inputbox:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
		inputbox.name:SetPoint("LEFT", inputbox, "RIGHT", 10, 1)
		inputbox.name:SetText(v)
		
		inputbox:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
		inputbox:SetAutoFocus(false)
		inputbox:SetTextInsets(3, 0, 0, 0)
		
		inputbox:SetScript("OnShow", function(self) self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][index][v]["action"]) end)
		inputbox:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][index][v]["action"]) self:ClearFocus() end)
		
		inputbox:SetScript("OnEnterPressed", function(self)
			local var = self:GetText()
			if (var == "target" or var == "tot" or var == "follow" or var == "macro" or var == "focus") then
				aCoreCDB["UnitframeOptions"]["ClickCast"][index][v]["action"] = var
				if var == "macro" then
					selectid, selectv = index, v
					StaticPopup_Show(G.uiname.."give macro")
				end
			elseif GetSpellInfo(var) or var == "NONE" then -- 法术已学会
				aCoreCDB["UnitframeOptions"]["ClickCast"][index][v]["action"] = var
			else
				StaticPopupDialogs[G.uiname.."incorrect spell"].text = L["Incorret Spell"].." |cff7FFF00"..var.." |r"
				StaticPopup_Show(G.uiname.."incorrect spell")
				self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][index][v]["action"])
			end
			self:ClearFocus()
		end)
	end
end

clickcastframe["MouseUp"] = CreateOptionPage("ClickCast MouseUp", L["MouseUp"], clickcastframe, "HORIZONTAL", .3)
clickcastframe["MouseUp"].title:Hide()
clickcastframe["MouseUp"].line:Hide()
for k, v in pairs(modifier) do
	local inputbox = CreateFrame("EditBox", "ClickCast MouseUp"..v.."EditBox", clickcastframe["MouseUp"])
	inputbox:SetSize(150, 20)
	inputbox:SetPoint("TOPLEFT", 16, 20-k*30)
	F.CreateBD(inputbox)
		
	inputbox.name = inputbox:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
	inputbox.name:SetPoint("LEFT", inputbox, "RIGHT", 10, 1)
	inputbox.name:SetText(v)
		
	inputbox:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	inputbox:SetAutoFocus(false)
	inputbox:SetTextInsets(3, 0, 0, 0)
		
	inputbox:SetScript("OnShow", function(self) self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+5)]["Click"]["action"]) end)
	inputbox:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+5)]["Click"]["action"]) self:ClearFocus() end)
		
	inputbox:SetScript("OnEnterPressed", function(self)
		local var = self:GetText()
		if (var == "target" or var == "tot" or var == "follow" or var == "macro" or var == "focus") then
			aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+5)]["Click"]["action"] = var
			if var == "macro" then
				selectid, selectv = tostring(k+5), "Click"
				StaticPopup_Show(G.uiname.."give macro")
			end
		elseif GetSpellInfo(var) or var == "NONE" then -- 法术已学会
			aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+5)]["Click"]["action"] = var
		else
			StaticPopupDialogs[G.uiname.."incorrect spell"].text = L["Incorret Spell"].." |cff7FFF00"..var.." |r"
			StaticPopup_Show(G.uiname.."incorrect spell")
			self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+5)]["Click"]["action"])
		end
		self:ClearFocus()
	end)
end

clickcastframe["MouseDown"] = CreateOptionPage("ClickCast MouseDown", L["MouseDown"], clickcastframe, "HORIZONTAL", .3)
clickcastframe["MouseDown"].title:Hide()
clickcastframe["MouseDown"].line:Hide()
for k, v in pairs(modifier) do
	local inputbox = CreateFrame("EditBox", "ClickCast MouseDown"..v.."EditBox", clickcastframe["MouseDown"])
	inputbox:SetSize(150, 20)
	inputbox:SetPoint("TOPLEFT", 16, 20-k*30)
	F.CreateBD(inputbox)
		
	inputbox.name = inputbox:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
	inputbox.name:SetPoint("LEFT", inputbox, "RIGHT", 10, 1)
	inputbox.name:SetText(v)
		
	inputbox:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	inputbox:SetAutoFocus(false)
	inputbox:SetTextInsets(3, 0, 0, 0)
		
	inputbox:SetScript("OnShow", function(self) self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"]) end)
	inputbox:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"]) self:ClearFocus() end)
		
	inputbox:SetScript("OnEnterPressed", function(self)
		local var = self:GetText()
		if (var == "target" or var == "tot" or var == "follow" or var == "macro" or var == "focus") then
			aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"] = var
			if var == "macro" then
				selectid, selectv = tostring(k+9), "Click"
				StaticPopup_Show(G.uiname.."give macro")
			end
		elseif GetSpellInfo(var) or var == "NONE" then -- 法术已学会
			aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"] = var
		else
			StaticPopupDialogs[G.uiname.."incorrect spell"].text = L["Incorret Spell"].." |cff7FFF00"..var.." |r"
			StaticPopup_Show(G.uiname.."incorrect spell")
			self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"])
		end
		self:ClearFocus()
	end)
end
--====================================================--
--[[           -- Actionbar Options --              ]]--
--====================================================--
local ActionbarOptions = CreateOptionPage("Actionbar Options", ACTIONBARS_LABEL, GUI, "VERTICAL")

local ActionbarInnerframe = CreateFrame("Frame", G.uiname.."Actionbar Options Innerframe", ActionbarOptions)
ActionbarInnerframe:SetPoint("TOPLEFT", 40, -60)
ActionbarInnerframe:SetPoint("BOTTOMLEFT", -20, 20)
ActionbarInnerframe:SetWidth(ActionbarOptions:GetWidth()-200)
F.CreateBD(ActionbarInnerframe, .3)

ActionbarInnerframe.tabindex = 1
ActionbarInnerframe.tabnum = 20
for i = 1, 20 do
	ActionbarInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."ActionbarInnerframe Tab"..i, ActionbarInnerframe)
	ActionbarInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

ActionbarInnerframe.common = CreateOptionPage("Actionbar Options common", L["Commonsettings"], ActionbarInnerframe, "VERTICAL", .3)
ActionbarInnerframe.common:Show()

T.createcheckbutton(ActionbarInnerframe.common, 30, 60, L["cooldown"], "ActionbarOptions", "cooldown", L["cooldown2"])
T.createcheckbutton(ActionbarInnerframe.common, 30, 90, L["rangecolor"], "ActionbarOptions", "rangecolor", L["rangecolor2"])
T.createslider(ActionbarInnerframe.common, 30, 140, L["keybindsize"], "ActionbarOptions", "keybindsize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 180, L["macronamesize"], "ActionbarOptions", "macronamesize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 220, L["countsize"], "ActionbarOptions", "countsize", 1, 8, 20, 1)

ActionbarInnerframe.bar12 = CreateOptionPage("Actionbar Options bar12", L["Bar1&2"], ActionbarInnerframe, "VERTICAL", .3)

ActionbarInnerframe.bar12.bar2toggle = T.ABtogglebox(ActionbarInnerframe.bar12, 30, 60, 1, L["Bar1&2"])
T.createslider(ActionbarInnerframe.bar12, 30, 110, L["buttonsize"], "ActionbarOptions", "bar12size", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.bar12, 30, 150, L["buttonspace"], "ActionbarOptions", "bar12space", 1, 0, 10, 1)
T.createcheckbutton(ActionbarInnerframe.bar12, 30, 190, L["mousefade"], "ActionbarOptions", "bar12mfade", L["mousefade2"])
T.createcheckbutton(ActionbarInnerframe.bar12, 30, 220, L["eventfade"], "ActionbarOptions", "bar12efade", L["eventfade2"])
T.createslider(ActionbarInnerframe.bar12, 30, 270, L["fademinalpha"], "ActionbarOptions", "bar12fademinaplha", 100, 0, 80, 5, L["fademinalpha2"])

ActionbarInnerframe.bar3 = CreateOptionPage("Actionbar Options bar3", L["Bar3"], ActionbarInnerframe, "VERTICAL", .3)

ActionbarInnerframe.bar3.bar3toggle = T.ABtogglebox(ActionbarInnerframe.bar3, 30, 60, 2, L["Bar3"])
T.createcheckbutton(ActionbarInnerframe.bar3, 30, 90, L["Bar3 layout322"], "ActionbarOptions", "bar3uselayout322", L["Bar3 layout3222"])
T.createslider(ActionbarInnerframe.bar3, 30, 140, L["bar3space"], "ActionbarOptions", "space1", 1, -300, 150, 1, L["bar3space2"])
T.createslider(ActionbarInnerframe.bar3, 30, 180, L["buttonsize"], "ActionbarOptions", "bar3size", 1, 15, 40, 1)
 T.createslider(ActionbarInnerframe.bar3, 30, 220, L["buttonspace"], "ActionbarOptions", "bar3space", 1, 0, 10, 1)
T.createcheckbutton(ActionbarInnerframe.bar3, 30, 260, L["mousefade"], "ActionbarOptions", "bar3mfade", L["mousefade2"])
T.createcheckbutton(ActionbarInnerframe.bar3, 30, 290, L["eventfade"], "ActionbarOptions", "bar3efade", L["eventfade2"])
T.createslider(ActionbarInnerframe.bar3, 30, 340, L["fademinalpha"], "ActionbarOptions", "bar3fademinaplha", 100, 0, 80, 5, L["fademinalpha2"])

ActionbarInnerframe.bar45 = CreateOptionPage("Actionbar Options bar45", L["Bar4&5"], ActionbarInnerframe, "VERTICAL", .3)

ActionbarInnerframe.bar45.bar4toggle = T.ABtogglebox(ActionbarInnerframe.bar45, 30, 60, 3, L["Bar4&5"].." 1")
ActionbarInnerframe.bar45.bar5toggle = T.ABtogglebox(ActionbarInnerframe.bar45, 30, 90, 4, L["Bar4&5"].." 2")
T.createDR(ActionbarInnerframe.bar45.bar4toggle, ActionbarInnerframe.bar45.bar5toggle)
T.createslider(ActionbarInnerframe.bar45, 30, 140, L["buttonsize"], "ActionbarOptions", "bar45size", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.bar45, 30, 180, L["buttonspace"], "ActionbarOptions", "bar45space", 1, 0, 10, 1)
T.createcheckbutton(ActionbarInnerframe.bar45, 30, 220, L["mousefade"], "ActionbarOptions", "bar45mfade", L["mousefade2"])
T.createcheckbutton(ActionbarInnerframe.bar45, 30, 250, L["eventfade"], "ActionbarOptions", "bar45efade", L["eventfade2"])
T.createslider(ActionbarInnerframe.bar45, 30, 300, L["fademinalpha"], "ActionbarOptions", "bar45fademinaplha", 100, 0, 80, 5, L["fademinalpha2"])

ActionbarInnerframe.petbar = CreateOptionPage("Actionbar Options petbar", L["Petbar"], ActionbarInnerframe, "VERTICAL", .3)

T.createcheckbutton(ActionbarInnerframe.petbar, 30, 60, L["petbaruselayout5x2"], "ActionbarOptions", "petbaruselayout5x2", L["petbaruselayout5x22"])
T.createslider(ActionbarInnerframe.petbar, 30, 110, L["barscale"], "ActionbarOptions", "petbarscale", 10, 5, 25, 1)
T.createslider(ActionbarInnerframe.petbar, 30, 150, L["buttonspace"], "ActionbarOptions", "petbuttonspace", 1, 0, 5, 1)
T.createcheckbutton(ActionbarInnerframe.petbar, 30, 190, L["mousefade"], "ActionbarOptions", "petbarmfade", L["mousefade2"])
T.createcheckbutton(ActionbarInnerframe.petbar, 30, 220, L["eventfade"], "ActionbarOptions", "petbarefade", L["eventfade2"])
T.createslider(ActionbarInnerframe.petbar, 30, 270, L["fademinalpha"], "ActionbarOptions", "petbarfademinaplha", 100, 0, 80, 5, L["fademinalpha2"])

ActionbarInnerframe.other = CreateOptionPage("Actionbar Options bar12", OTHER, ActionbarInnerframe, "VERTICAL", .3)

local stancebartitle = ActionbarInnerframe.other:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
stancebartitle:SetPoint("TOPLEFT", 36, -75)
stancebartitle:SetText(L["Stancebar"])
T.createslider(ActionbarInnerframe.other, 30, 110, L["buttonsize"], "ActionbarOptions", "stancebarbuttonszie", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.other, 30, 150, L["buttonspace"], "ActionbarOptions", "stancebarbuttonspace", 1, 0, 5, 1)
local leave_vehicletitle = ActionbarInnerframe.other:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
leave_vehicletitle:SetPoint("TOPLEFT", 36, -205)
leave_vehicletitle:SetText(L["leave_vehicle"])
T.createslider(ActionbarInnerframe.other, 30, 240, L["buttonsize"], "ActionbarOptions", "leave_vehiclebuttonsize", 1, 15, 50, 1)
local extrabartitle = ActionbarInnerframe.other:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
extrabartitle:SetPoint("TOPLEFT", 36, -295)
extrabartitle:SetText(L["extrabarbutton"])
T.createslider(ActionbarInnerframe.other, 30, 330, L["buttonsize"], "ActionbarOptions", "extrabarbuttonsize", 1, 15, 50, 1)

--====================================================--
--[[           -- BuffFrame Options --              ]]--
--====================================================--
local BuffFrameOptions = CreateOptionPage("BuffFrame Options", AURAS, GUI, "VERTICAL")

T.createslider(BuffFrameOptions, 30, 120, L["buffsize"], "BuffFrameOptions", "buffsize", 1, 20, 50, 1)
T.createslider(BuffFrameOptions, 320, 120, L["buffsize"], "BuffFrameOptions", "debuffsize", 1, 20, 50, 1)
T.createslider(BuffFrameOptions, 30, 160, L["rowspace"], "BuffFrameOptions", "buffrowspace", 1, 0, 20, 1)
T.createslider(BuffFrameOptions, 320, 160, L["rowspace"], "BuffFrameOptions", "debuffrowspace", 1, 0, 20, 1)
T.createslider(BuffFrameOptions, 30, 200, L["colspace"], "BuffFrameOptions", "buffcolspace", 1, 0, 10, 1)
T.createslider(BuffFrameOptions, 320, 200, L["colspace"], "BuffFrameOptions", "debuffcolspace", 1, 0, 10, 1)
T.createslider(BuffFrameOptions, 30, 240, L["NumIconPerRow"], "BuffFrameOptions", "buffsPerRow", 1, 10, 30, 1)
T.createslider(BuffFrameOptions, 320, 240, L["NumIconPerRow"], "BuffFrameOptions", "debuffsPerRow", 1, 10, 30, 1)
T.createslider(BuffFrameOptions, 30, 280, L["timesize"], "BuffFrameOptions", "bufftimesize", 1, 8, 20, 1)
T.createslider(BuffFrameOptions, 320, 280, L["timesize"], "BuffFrameOptions", "debufftimesize", 1, 8, 20, 1)
T.createslider(BuffFrameOptions, 30, 320, L["stacksize"], "BuffFrameOptions", "buffcountsize", 1, 8, 20, 1)
T.createslider(BuffFrameOptions, 320, 320, L["stacksize"], "BuffFrameOptions", "debuffcountsize", 1, 8, 20, 1)
T.createcheckbutton(BuffFrameOptions, 30, 370, L["seperatebuff"], "BuffFrameOptions", "seperate")

local bufftitle = T.createtext(BuffFrameOptions, "OVERLAY", 18, "OUTLINE", "CENTER")
bufftitle:SetPoint("BOTTOM", buffsize, "TOP", 0, 25)
bufftitle:SetTextColor(.3, 1, .5)
bufftitle:SetText(L["Buff"])

local debufftitle = T.createtext(BuffFrameOptions, "OVERLAY", 18, "OUTLINE", "CENTER")
debufftitle:SetPoint("BOTTOM", debuffsize, "TOP", 0, 25)
debufftitle:SetTextColor(1, .5, .3)
debufftitle:SetText(L["Debuff"])
--====================================================--
--[[           -- NamePlates Options --             ]]--
--====================================================--
local PlateOptions = CreateOptionPage("Plate Options", UNIT_NAMEPLATES, GUI, "VERTICAL")
	
T.createcheckbutton(PlateOptions, 30, 60, L["Enable Plate"], "PlateOptions", "enableplate")
T.createslider(PlateOptions, 30, 110, L["Plate Width"], "PlateOptions", "platewidth", 1, 100, 300, 5)
T.createslider(PlateOptions, 30, 150, L["Plate Height"], "PlateOptions", "plateheight", 1, 5, 25, 1)
PlateOptions.classcolorplatestoggle = T.CVartogglebox(PlateOptions, 30, 190, "ShowClassColorInNameplate", SHOW_CLASS_COLOR_IN_V_KEY)
T.createcheckbutton(PlateOptions, 30, 220, L["Threat Color"], "PlateOptions", "threatplates", L["Threat Color2"])
T.createcheckbutton(PlateOptions, 30, 250, L["Auto Toggle"], "PlateOptions", "autotoggleplates", L["Auto Toggle2"])
T.createcheckbutton(PlateOptions, 30, 280, L["Plate Debuff"], "PlateOptions", "platedebuff", L["Plate Debuff2"])
T.createcheckbutton(PlateOptions, 30, 310, L["Plate Buff"], "PlateOptions", "platebuff", L["Plate Buff2"])
T.createslider(PlateOptions, 30, 360, L["Plate Aura Number"], "PlateOptions", "plateauranum", 1, 3, 10, 1)
T.createslider(PlateOptions, 30, 400, L["Plate Aura Size"], "PlateOptions", "plateaurasize", 1, 20, 40, 2)
T.createDR(PlateOptions.enableplate, PlateOptions.platewidth, PlateOptions.plateheight, PlateOptions.threatplates, PlateOptions.autotoggleplates, PlateOptions.platedebuff, PlateOptions.platebuff, PlateOptions.plateauranum, PlateOptions.plateaurasize)

--====================================================--
--[[             -- Tooltip Options --              ]]--
--====================================================--
local TooltipOptions = CreateOptionPage("Tooltip Options", USE_UBERTOOLTIPS, GUI, "VERTICAL")

T.createcheckbutton(TooltipOptions, 30, 60, L["Enable Tip"], "TooltipOptions", "enabletip")
T.createcheckbutton(TooltipOptions, 30, 90, L["Show at Mouse"], "TooltipOptions", "cursor", L["Show at Mouse2"])
T.createcheckbutton(TooltipOptions, 30, 120, L["Hide Realm"], "TooltipOptions", "hideRealm", L["Hide Realm2"])
T.createcheckbutton(TooltipOptions, 30, 150, L["Hide Title"], "TooltipOptions", "hideTitles", L["Hide Title2"])
T.createcheckbutton(TooltipOptions, 30, 180, L["Show SpellID"], "TooltipOptions", "showspellID", L["Show SpellID2"])
T.createcheckbutton(TooltipOptions, 30, 210, L["Show ItemID"], "TooltipOptions", "showitemID", L["Show ItemID2"])
T.createcheckbutton(TooltipOptions, 30, 240, L["Show Talent"], "TooltipOptions", "showtalent", L["Show Talent2"])
T.createcheckbutton(TooltipOptions, 30, 270, L["Class Color"], "TooltipOptions", "colorborderClass", L["Class Color2"])
T.createcheckbutton(TooltipOptions, 30, 300, L["Hide in Combat"], "TooltipOptions", "combathide", L["Hide in Combat2"])
T.createDR(TooltipOptions.enabletip, TooltipOptions.cursor, TooltipOptions.hideRealm, TooltipOptions.hideTitles, TooltipOptions.showspellID, TooltipOptions.showitemID, TooltipOptions.showtalent, TooltipOptions.colorborderClass, TooltipOptions.combathide)

--====================================================--
--[[             -- Combattext Options --              ]]--
--====================================================--
local CombattextOptions = CreateOptionPage("CombatText Options", L["Combat Text"], GUI, "VERTICAL")

T.createcheckbutton(CombattextOptions, 30, 60, L["Enalbe CT"], "CombattextOptions", "combattext")
T.createcheckbutton(CombattextOptions, 30, 90, L["ReceivedCT"], "CombattextOptions", "showreceivedct")
T.createcheckbutton(CombattextOptions, 30, 120, L["OutPutCT"], "CombattextOptions", "showoutputct")
T.createcheckbutton(CombattextOptions, 30, 150, L["Fliter CT"], "CombattextOptions", "ctfliter", L["Fliter CT2"])
T.createslider(CombattextOptions, 30, 200, L["CT icon size"], "CombattextOptions", "cticonsize", 1, 10, 30, 1)
T.createslider(CombattextOptions, 30, 240, L["CT crit icon size"], "CombattextOptions", "ctbigiconsize", 1, 10, 30, 1)
T.createcheckbutton(CombattextOptions, 30, 280, L["CT show dot"], "CombattextOptions", "ctshowdots")
T.createcheckbutton(CombattextOptions, 30, 310, L["CT show hot"], "CombattextOptions", "ctshowhots")
T.createcheckbutton(CombattextOptions, 30, 340, L["CT show pet"], "CombattextOptions", "ctshowpet")
T.createslider(CombattextOptions, 30, 390, L["CT fade time"], "CombattextOptions", "ctfadetime", 10, 20, 100, 5, L["CT fade time2"])
T.createDR(CombattextOptions.combattext, CombattextOptions.showreceivedct, CombattextOptions.showoutputct, CombattextOptions.ctfliter, CombattextOptions.cticonsize, CombattextOptions.ctbigiconsize, CombattextOptions.ctshowdots, CombattextOptions.ctshowhots, CombattextOptions.ctshowpet, CombattextOptions.ctfadetime)

--====================================================--
--[[              -- RaidTool Options --                ]]--
--====================================================--
local RaidToolOptions = CreateOptionPage("RaidTool Options", L["RaidTools"], GUI, "VERTICAL")

T.createcheckbutton(RaidToolOptions, 30, 60, L["only1-5"], "RaidToolOptions", "onlyactive")
T.createslider(RaidToolOptions, 30, 110, L["dbm_pulltime"], "RaidToolOptions", "pulltime", 1, 3, 20, 1, L["need dbm"])
T.createcheckbutton(RaidToolOptions, 30, 150, L["potion"], "RaidToolOptions", "potion")
T.createmultilinebox(RaidToolOptions, 200, 60, 35, 205, L["potionblacklist"], "RaidToolOptions", "potionblacklist", L["potionblacklist2"])

--====================================================--
--[[              -- Other Options --                ]]--
--====================================================--
local OtherOptions = CreateOptionPage("Other Options", OTHER, GUI, "VERTICAL")

T.createslider(OtherOptions, 30, 80, L["Minimap Scale"], "OtherOptions", "minimapheight", 1, 100, 300, 5)
T.createcheckbutton(OtherOptions, 30, 120, L["Collect minimapbuttons"], "OtherOptions", "collectminimapbuttons")
T.createcheckbutton(OtherOptions, 30, 150, L["Collect hiding minimapbuttons"], "OtherOptions", "collecthidingminimapbuttons")
T.createDR(OtherOptions.collectminimapbuttons, OtherOptions.collecthidingminimapbuttons)
T.createcheckbutton(OtherOptions, 30, 180, L["Hide Errors"], "OtherOptions", "hideerrors", L["Hide Errors2"])
T.createcheckbutton(OtherOptions, 30, 210, L["Achievement Shot"], "OtherOptions", "autoscreenshot", L["Achievement Shot2"])
T.createcheckbutton(OtherOptions, 30, 240, L["Collect Garbage"], "OtherOptions", "collectgarbage", L["Collect Garbage2"])
T.createcheckbutton(OtherOptions, 30, 270, L["camera"], "OtherOptions", "camera", L["camera2"])
T.createcheckbutton(OtherOptions, 30, 300, L["Accept Resurrects"], "OtherOptions", "acceptres", L["Accept Resurrects2"])	
T.createcheckbutton(OtherOptions, 30, 330, L["Releases Spirit in BG"], "OtherOptions", "battlegroundres", L["Releases Spirit in BG2"])
T.createcheckbutton(OtherOptions, 30, 360, L["Auto Quests"], "OtherOptions", "autoquests", L["Auto Quests2"])
T.createcheckbutton(OtherOptions, 30, 390, L["Say Sapped"], "OtherOptions", "saysapped", L["Say Sapped2"])

--====================================================--
--[[               -- Skin Options --                   ]]--
--====================================================--
local SkinOptions = CreateOptionPage("Skin Options", L["Addon Skins"], GUI, "VERTICAL")

T.createcheckbutton(SkinOptions, 30, 60, "ClassColor", "SkinOptions", "setClassColor", L["need edit"])
T.createcheckbutton(SkinOptions, 30, 90, "DBM", "SkinOptions", "setDBM", L["need edit"])
T.createcheckbutton(SkinOptions, 30, 120, "Skada", "SkinOptions", "setSkada", L["need edit"])
T.createcheckbutton(SkinOptions, 30, 150, "Numeration", "SkinOptions", "setNumeration", L["need edit"])
T.createcheckbutton(SkinOptions, 30, 180, "Recount", "SkinOptions", "setRecount")
T.createcheckbutton(SkinOptions, 30, 210, L["Edit Settings"], "SkinOptions", "editsettingsbu", L["Edit Settings2"])

--====================================================--
--[[                -- Init --                      ]]--
--====================================================--
local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

function eventframe:ADDON_LOADED(arg1)
	if arg1 ~= "AltzUIConfig" then return end
	if aCoreDB == nil then
		aCoreDB = {}
	end
	if aCoreCDB == nil then
		aCoreCDB = {}
	end
	T.LoadAccountVariables()
	T.LoadVariables()
	CreateAuraFliterButtonList()
	CreateAutobuyButtonList()
	if aCoreCDB["SkinOptions"]["editsettingsbu"] then
		T.ResetAllAddonSettings()
		aCoreCDB["SkinOptions"]["editsettingsbu"] = false
	end
end

--[[ CPU and Memroy testing
local interval = 0
cfg:SetScript("OnUpdate", function(self, elapsed)
 	interval = interval - elapsed
	if interval <= 0 then
		UpdateAddOnMemoryUsage()
			print("----------------------")
			print("|cffBF3EFFoUF_Mlight|r CPU  "..GetAddOnCPUUsage("oUF_Mlight").." Memory "..format("%.1f kb", floor(GetAddOnMemoryUsage("oUF_Mlight"))))
			print("|cffFFFF00oUF|r CPU  "..GetAddOnCPUUsage("oUF").."  Memory  "..format("%.1f kb", floor(GetAddOnMemoryUsage("oUF"))))
			print("----------------------")
		interval = 4
	end
end)
]]--