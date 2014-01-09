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

GUI.title = T.createtext(GUI, "OVERLAY", 25, "OUTLINE", "CENTER")
GUI.title:SetPoint("BOTTOM", GUI, "TOP", 0, -8)
GUI.title:SetText(G.classcolor.."Altz UI  "..G.Version.."|r")

GUI.close = CreateFrame("Button", nil, GUI)
GUI.close:SetPoint("BOTTOMRIGHT", -10, 10)
GUI.close:SetSize(20, 20)
T.SkinButton(GUI.close, G.Iconpath.."exit", true)
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
--[[                   -- TABS --                   ]]--
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
	
	tab.name = T.createtext(tab, "OVERLAY", 12, "OUTLINE", "LEFT")
	tab.name:SetText(text)
	
	if orientation == "VERTICAL" then
		tab.name:SetPoint("LEFT", 10, 0)
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
		tab.name:SetJustifyH("CENTER")
		tab.name:SetPoint("CENTER")
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
CreateTab(L["介绍"], IntroOptions, GUI, "VERTICAL")

IntroOptions:SetScript("OnShow", function() ReloadButton:Hide() end)
IntroOptions:SetScript("OnHide", function() ReloadButton:Show() end)

local logo = CreateFrame("PlayerModel", G.uiname.."Logo", IntroOptions)
logo:SetSize(500, 300)
logo:SetPoint("CENTER")
logo:SetDisplayInfo(40795)

logo:SetCamDistanceScale(.7)
logo:SetPosition(-2,0,0)
logo:SetRotation(-0.3)
logo.rotation = -0.3

IntroOptions.text = T.createtext(IntroOptions, "OVERLAY", 12, "NONE", "LEFT")
IntroOptions.text:SetPoint("BOTTOMLEFT", 17, 10)
IntroOptions.text:SetTextColor(.5, .5, .5)
IntroOptions.text:SetText(L["小泡泡"].."\nbbs.ngacn.cc/read.php?tid=4729675\nwww.wowinterface.com/downloads/info21263-AltzUIforMoP")

IntroOptions.line = IntroOptions:CreateTexture(nil, "ARTWORK")
IntroOptions.line:SetSize(IntroOptions:GetWidth()-30, 1)
IntroOptions.line:SetPoint("BOTTOM", 0, 50)
IntroOptions.line:SetTexture(1, 1, 1, .2)

local function RotateModel(self, button)
    local rotationIncrement = 0.2
    if button == "LeftButton" then
		self.rotation = self.rotation - rotationIncrement
    else
		self.rotation = self.rotation + rotationIncrement
    end
    self.rotation = floor((self.rotation)*10)/10
    self:SetRotation(self.rotation)
end

logo:SetScript("OnMouseDown", function(self, button) RotateModel(self, button) end)

local resetbu = CreateFrame("Button", G.uiname.."ResetButton", IntroOptions, "UIPanelButtonTemplate")
resetbu:SetPoint("BOTTOMLEFT", IntroOptions, "BOTTOM", 100, 80)
resetbu:SetSize(180, 25)
resetbu:SetText(L["重置"])
F.Reskin(resetbu)
resetbu:SetScript("OnClick", function(self)
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], "Altz UI")
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		aCoreCDB = {}
		T.SetChatFrame()
		T.LoadVariables()
		T.ResetAllAddonSettings()
		ReloadUI()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

--====================================================--
--[[              -- Chat Options --                ]]--
--====================================================--
local ChatOptions = CreateOptionPage("Chat Options", SOCIAL_LABEL, GUI, "VERTICAL")

T.createcheckbutton(ChatOptions, 30, 60, L["频道缩写"], "ChatOptions", "channelreplacement")
T.createcheckbutton(ChatOptions, 30, 90, L["滚动聊天框"], "ChatOptions", "autoscroll", L["滚动聊天框提示"])
T.createcheckbutton(ChatOptions, 30, 120, L["自动接受邀请"], "OtherOptions", "acceptfriendlyinvites", L["自动接受邀请提示"])
T.createcheckbutton(ChatOptions, 30, 150, L["自动邀请"], "OtherOptions", "autoinvite", L["自动邀请提示"])
T.createeditbox(ChatOptions, 180, 152, "", "OtherOptions", "autoinvitekeywords", L["关键词输入"])
T.createDR(ChatOptions.autoinvite, ChatOptions.autoinvitekeywords)
T.createcheckbutton(ChatOptions, 30, 185, L["聊天过滤"], "ChatOptions", "nogoldseller", L["聊天过滤提示"])
T.createslider(ChatOptions, 30, 235, L["过滤阈值"], "ChatOptions", "goldkeywordnum", 1, 1, 5, 1, L["过滤阈值"])
T.createmultilinebox(ChatOptions, 300, 150, 35, 275, L["关键词"], "ChatOptions", "goldkeywordlist", L["关键词输入"])
ChatOptions.goldkeywordlist.edit:SetScript("OnShow", function(self) self:SetText(aCoreDB["goldkeywordlist"]) end)
ChatOptions.goldkeywordlist.edit:SetScript("OnEscapePressed", function(self) self:SetText(aCoreDB["goldkeywordlist"]) self:ClearFocus() end)
ChatOptions.goldkeywordlist.edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() aCoreDB["goldkeywordlist"] = self:GetText() end)
--====================================================--
--[[          -- Bag and Items Options --           ]]--
--====================================================--
local ItemOptions = CreateOptionPage("Item Options", ITEMS, GUI, "VERTICAL", nil, true)

T.createcheckbutton(ItemOptions, 30, 60, L["启用"], "ItemOptions", "enablebag")
T.createcheckbutton(ItemOptions, 30, 90, L["已会配方着色"], "ItemOptions", "alreadyknown", L["已会配方着色提示"])
T.createcheckbutton(ItemOptions, 30, 120, L["自动修理"], "ItemOptions", "autorepair", L["自动修理提示"])
T.createcheckbutton(ItemOptions, 30, 150, L["自动公会修理"], "ItemOptions", "autorepair_guild", L["自动公会修理提示"])
T.createcheckbutton(ItemOptions, 30, 180, L["自动售卖"], "ItemOptions", "autosell", L["自动售卖提示"])
T.createcheckbutton(ItemOptions, 30, 210, L["自动购买"], "ItemOptions", "autobuy", L["自动购买提示"])

ItemOptions.SF:ClearAllPoints()
ItemOptions.SF:SetPoint("TOPLEFT", ItemOptions, "TOPLEFT", 40, -280)
ItemOptions.SF:SetPoint("BOTTOMRIGHT", ItemOptions, "BOTTOMRIGHT", -300, 135)
F.CreateBD(ItemOptions.SF, .3)

local function LineUpAutobuyList()
	sort(aCoreCDB["ItemOptions"]["autobuylist"])
	local index = 1
	for itemID, quantity in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
		if not itemID then return end
		_G[G.uiname.."AutobuyList Button"..itemID]:SetPoint("TOPLEFT", ItemOptions.SF, "TOPLEFT", 5, 20-index*30)
		index = index + 1
	end
end

local function CreateAutobuyButton(itemID, name, icon, quantity)
	local bu = CreateFrame("Frame", G.uiname.."AutobuyList Button"..itemID, ItemOptions.SF)
	bu:SetSize(300, 28)
	F.CreateBD(bu, .2)
	
	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(20, 20)
	bu.icon:SetNormalTexture(icon or G.media.blank)
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

local Autobuy_iteminput = CreateFrame("EditBox", G.uiname.."AutobuyList ItemInput", ItemOptions)
Autobuy_iteminput:SetSize(150, 20)
Autobuy_iteminput:SetPoint("TOPLEFT", 40, -250)
F.CreateBD(Autobuy_iteminput)

Autobuy_iteminput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
Autobuy_iteminput:SetAutoFocus(false)
Autobuy_iteminput:SetTextInsets(3, 0, 0, 0)

Autobuy_iteminput:SetScript("OnShow", function(self) self:SetText(L["输入物品ID"]) end)
Autobuy_iteminput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
Autobuy_iteminput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入物品ID"]) end)
Autobuy_iteminput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

local Autobuy_quantityinput = CreateFrame("EditBox", G.uiname.."AutobuyList QuantityInput", ItemOptions)
Autobuy_quantityinput:SetSize(80, 20)
Autobuy_quantityinput:SetPoint("LEFT", Autobuy_iteminput, "RIGHT", 15, 0)
F.CreateBD(Autobuy_quantityinput)

Autobuy_quantityinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
Autobuy_quantityinput:SetAutoFocus(false)
Autobuy_quantityinput:SetTextInsets(3, 0, 0, 0)

Autobuy_quantityinput:SetScript("OnShow", function(self) self:SetText(L["输入数量"]) end)
Autobuy_quantityinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
Autobuy_quantityinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入数量"]) end)
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
		if aCoreCDB["ItemOptions"]["autobuylist"][tostring(itemID)] then
			aCoreCDB["ItemOptions"]["autobuylist"][tostring(itemID)] = quantity
			_G[G.uiname.."AutobuyList Button"..itemID].num:SetText(quantity)
			LineUpAutobuyList()
		elseif _G[G.uiname.."AutobuyList Button"..itemID] then -- 已经有这个框体
			aCoreCDB["ItemOptions"]["autobuylist"][tostring(itemID)] = quantity
			_G[G.uiname.."AutobuyList Button"..itemID].num:SetText(quantity)
			_G[G.uiname.."AutobuyList Button"..itemID]:Show()
			LineUpAutobuyList()
		else
			aCoreCDB["ItemOptions"]["autobuylist"][tostring(itemID)] = quantity
			CreateAutobuyButton(itemID, name, select(10, GetItemInfo(itemID)), quantity)
			LineUpAutobuyList()
		end
	else
		if not name then
			StaticPopupDialogs[G.uiname.."incorrect item ID"].text = "|cff7FFF00"..itemID.." |r"..L["不正确的物品ID"]
			StaticPopup_Show(G.uiname.."incorrect item ID")
		elseif not tonumber(quantity) then
			StaticPopupDialogs[G.uiname.."incorrect item quantity"].text = "|cff7FFF00"..quantity.." |r"..L["不正确的数量"]
			StaticPopup_Show(G.uiname.."incorrect item quantity")
		end
	end
end)

--====================================================--
--[[               -- Unit Frames --                ]]--
--====================================================--
local UFOptions = CreateOptionPage("UF Options", L["单位框体"], GUI, "VERTICAL")

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

UFInnerframe.style = CreateOptionPage("UF Options style", L["样式"], UFInnerframe, "VERTICAL", .3)
UFInnerframe.style:Show()

T.createcheckbutton(UFInnerframe.style, 30, 60, L["条件渐隐"], "UnitframeOptions", "enablefade", L["条件渐隐提示"])
T.createslider(UFInnerframe.style, 30, 110, L["渐隐透明度"], "UnitframeOptions", "fadingalpha", 100, 0, 80, 5, L["渐隐透明度提示"])
T.createDR(UFInnerframe.style.enablefade, UFInnerframe.style.fadingalpha)
T.createcheckbutton(UFInnerframe.style, 30, 150, L["显示肖像"], "UnitframeOptions", "portrait")
T.createslider(UFInnerframe.style, 30, 200, L["肖像透明度"], "UnitframeOptions", "portraitalpha", 100, 10, 100, 5)
T.createDR(UFInnerframe.style.portrait, UFInnerframe.style.portraitalpha)
T.createcheckbutton(UFInnerframe.style, 30, 240, L["按职业着色"], "UnitframeOptions", "classcolormode", L["按职业染色提示"])
T.createcheckbutton(UFInnerframe.style, 30, 270, L["名字职业着色"], "UnitframeOptions", "nameclasscolormode", L["名字职业着色提示"])
T.createcheckbutton(UFInnerframe.style, 30, 300, L["以万为单位显示"], "UnitframeOptions", "tenthousand")
T.createcheckbutton(UFInnerframe.style, 30, 330, L["总是显示生命值"], "UnitframeOptions", "alwayshp", L["总是显示生命值提示"])
T.createcheckbutton(UFInnerframe.style, 30, 360, L["总是显示能量值"], "UnitframeOptions", "alwayspp", L["总是显示能量值提示"])

UFInnerframe.size = CreateOptionPage("UF Options size", L["尺寸"], UFInnerframe, "VERTICAL", .3)

T.createslider(UFInnerframe.size, 30, 80, L["高度"], "UnitframeOptions", "height", 1, 5, 50, 1)
T.createslider(UFInnerframe.size, 30, 120, L["宽度"], "UnitframeOptions", "width", 1, 50, 500, 1, L["宽度提示"])
T.createslider(UFInnerframe.size, 30, 160, L["宠物框体宽度"], "UnitframeOptions", "widthpet", 1, 50, 500, 1)
T.createslider(UFInnerframe.size, 30, 200, L["首领框体和PVP框体的宽度"], "UnitframeOptions", "widthboss", 1, 50, 500, 1)
T.createslider(UFInnerframe.size, 30, 240, L["尺寸"], "UnitframeOptions", "scale", 100, 50, 300, 5)
T.createslider(UFInnerframe.size, 30, 280, L["生命条高度比"], "UnitframeOptions", "hpheight", 100, 20, 95, 5, L["生命条高度比提示"])
T.createslider(UFInnerframe.size, 30, 320, L["数值字号"], "UnitframeOptions", "valuefontsize", 1, 10, 25, 1, L["数值字号提示"])

UFInnerframe.castbar = CreateOptionPage("UF Options castbar", L["施法条"], UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.castbar, 30, 60, L["启用"], "UnitframeOptions", "castbars")
T.createslider(UFInnerframe.castbar, 30, 110, L["图标大小"], "UnitframeOptions", "cbIconsize", 1, 10, 50, 1)
T.createcheckbutton(UFInnerframe.castbar, 30, 150, L["独立玩家施法条"], "UnitframeOptions", "independentcb")
local CBtextpos_group = {
	["CENTER"] = L["中间"],
	["BOTTOM"] = L["下方"],
	["LEFT"] = L["左"],
	["RIGHT"] = L["右"],
}
T.createslider(UFInnerframe.castbar, 30, 200, L["高度"], "UnitframeOptions", "cbheight", 1, 5, 30, 1)
T.createslider(UFInnerframe.castbar, 30, 240, L["宽度"], "UnitframeOptions", "cbwidth", 1, 50, 500, 5)
T.createradiobuttongroup(UFInnerframe.castbar, 30, 270, L["法术名称位置"], "UnitframeOptions", "namepos", CBtextpos_group)
T.createradiobuttongroup(UFInnerframe.castbar, 30, 300, L["施法时间位置"], "UnitframeOptions", "timepos", CBtextpos_group)
T.createDR(UFInnerframe.castbar.independentcb, UFInnerframe.castbar.cbheight, UFInnerframe.castbar.cbwidth, UFInnerframe.castbar.namepos, UFInnerframe.castbar.timepos)
T.createcheckbutton(UFInnerframe.castbar, 30, 340, L["引导法术分段"], "UnitframeOptions", "channelticks")
T.createDR(UFInnerframe.castbar.castbars, UFInnerframe.castbar.cbIconsize, UFInnerframe.castbar.independentcb, UFInnerframe.castbar.cbheight, UFInnerframe.castbar.cbwidth, UFInnerframe.castbar.namepos, UFInnerframe.castbar.timepos, UFInnerframe.castbar.channelticks)

UFInnerframe.swingtimer = CreateOptionPage("UF Options swingtimer", L["平砍计时条"], UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.swingtimer, 30, 60, L["启用"], "UnitframeOptions", "swing")
T.createslider(UFInnerframe.swingtimer, 30, 110, L["高度"], "UnitframeOptions", "swheight", 1, 5, 30, 1)
T.createslider(UFInnerframe.swingtimer, 30, 150, L["宽度"], "UnitframeOptions", "swwidth", 1, 50, 500, 5)
T.createcheckbutton(UFInnerframe.swingtimer, 30, 190, L["显示副手"], "UnitframeOptions", "swoffhand")
T.createcheckbutton(UFInnerframe.swingtimer, 30, 220, L["显示平砍计时"], "UnitframeOptions", "swtimer")
T.createslider(UFInnerframe.swingtimer, 30, 270, L["字体大小"], "UnitframeOptions", "swtimersize", 1, 8, 20, 1)
T.createDR(UFInnerframe.swingtimer.swing, UFInnerframe.swingtimer.swheight, UFInnerframe.swingtimer.swwidth, UFInnerframe.swingtimer.swoffhand, UFInnerframe.swingtimer.swtimer, UFInnerframe.swingtimer.swtimersize)
T.createDR(UFInnerframe.swingtimer.swtimer, UFInnerframe.swingtimer.swtimersize)

UFInnerframe.aura = CreateOptionPage("UF Options aura", AURAS, UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.aura, 30, 60, L["启用"], "UnitframeOptions", "auras")
T.createcheckbutton(UFInnerframe.aura, 30, 90, L["减益边框"], "UnitframeOptions", "auraborders", L["减益边框提示"])
T.createslider(UFInnerframe.aura, 30, 140, L["每一行的图标数量"], "UnitframeOptions", "auraperrow", 1, 4, 20, 1, L["每行的光环数量提示"])
T.createcheckbutton(UFInnerframe.aura, 30, 180, L["玩家减益"], "UnitframeOptions", "playerdebuffenable", L["玩家减益提示"])
T.createslider(UFInnerframe.aura, 30, 230, L["每一行的图标数量"], "UnitframeOptions", "playerdebuffnum", 1, 4, 20, 1, L["每行的光环数量提示"])
T.createcheckbutton(UFInnerframe.aura, 30, 270, L["过滤增益"], "UnitframeOptions", "AuraFilterignoreBuff", L["过滤增益提示"])
T.createcheckbutton(UFInnerframe.aura, 30, 300, L["过滤减益"], "UnitframeOptions", "AuraFilterignoreDebuff", L["过滤减益提示"])
T.createDR(UFInnerframe.aura.auras, UFInnerframe.aura.auraperrow, UFInnerframe.aura.auraborders, UFInnerframe.aura.playerdebuffenable, UFInnerframe.aura.playerdebuffnum, UFInnerframe.aura.AuraFilterignoreBuff, UFInnerframe.aura.AuraFilterignoreDebuff)
T.createDR(UFInnerframe.aura.playerdebuffenable, UFInnerframe.aura.playerdebuffnum)

UFInnerframe.aurawhitelist = CreateOptionPage("UF Options aurawhitelist", L["白名单"], UFInnerframe, "VERTICAL", .3, true)
UFInnerframe.aurawhitelist.SF:SetPoint("TOPLEFT", 26, -80)

local function LineUpAuraFliterList()
	sort(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"])
	local index = 1
	for spellID, name in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do
		if not spellID then return end
		_G[G.uiname.."WhiteList Button"..spellID]:SetPoint("TOPLEFT", UFInnerframe.aurawhitelist.SF, "TOPLEFT", 10, 20-index*30)
		index = index + 1
	end
end

local function CreateAuraFliterButton(name, icon, spellID)
	local bu = CreateFrame("Frame", G.uiname.."WhiteList Button"..spellID, UFInnerframe.aurawhitelist.SF)
	bu:SetSize(350, 20)

	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(18, 18)
	bu.icon:SetNormalTexture(icon)
	bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetPoint"LEFT"
	F.CreateBG(bu.icon)
	
	bu.spellid = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.spellid:SetPoint("LEFT", 40, 0)
	bu.spellid:SetTextColor(1, .2, .6)
	bu.spellid:SetText(spellID)
	
	bu.spellname = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.spellname:SetPoint("LEFT", 140, 0)
	bu.spellname:SetTextColor(1, 1, 0)
	bu.spellname:SetText(name)
	
	bu.close = CreateFrame("Button", nil, bu, "UIPanelButtonTemplate")
	bu.close:SetSize(18,18)
	bu.close:SetPoint("RIGHT")
	F.Reskin(bu.close)
	bu.close:SetText("x")
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(tonumber(spellID))
		GameTooltip:Show()
	end)
	bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	bu.close:SetScript("OnClick", function() 
		bu:Hide()
		aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = nil
		print("|cffFF0000"..name.." |r"..L["从法术过滤白名单中移出"])
		LineUpAuraFliterList()
	end)
	
	return bu
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

local AuraFliter_spellIDinput = CreateFrame("EditBox", G.uiname.."WhiteList Input", UFInnerframe.aurawhitelist)
AuraFliter_spellIDinput:SetSize(250, 20)
AuraFliter_spellIDinput:SetPoint("TOPLEFT", 30, -60)
F.CreateBD(AuraFliter_spellIDinput)

AuraFliter_spellIDinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
AuraFliter_spellIDinput:SetAutoFocus(false)
AuraFliter_spellIDinput:SetTextInsets(3, 0, 0, 0)

AuraFliter_spellIDinput:SetScript("OnShow", function(self) self:SetText(L["输入法术ID"]) end)
AuraFliter_spellIDinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
AuraFliter_spellIDinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() AuraFliter_spellIDinput:SetText(L["输入法术ID"]) end)
AuraFliter_spellIDinput:SetScript("OnEnterPressed", function(self)
	local spellID = self:GetText()
	self:ClearFocus()
	local name, _, icon = GetSpellInfo(spellID)
	if name then
		if aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] then
			print("|cff7FFF00"..name.." |r"..L["已经在白名单中"])
		elseif _G[G.uiname.."WhiteList Button"..spellID] then -- 已经有这个框体
			aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = name
			_G[G.uiname.."WhiteList Button"..spellID]:Show()
			print("|cff7FFF00"..name.." |r"..L["被添加到法术过滤白名单中"])
			LineUpAuraFliterList()
		else
			aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = name		
			CreateAuraFliterButton(name, icon, spellID)
			print("|cff7FFF00"..name.." |r"..L["被添加到法术过滤白名单中"])
			LineUpAuraFliterList()
		end
	else
		StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID.." |r"..L["不是一个有效的法术ID"]
		StaticPopup_Show(G.uiname.."incorrect spellid")
	end
end)

AuraFliter_spellIDinput:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
	GameTooltip:AddLine(L["白名单提示"])
	GameTooltip:Show() 
end)
AuraFliter_spellIDinput:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		
UFInnerframe.other = CreateOptionPage("UF Options other", OTHER, UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.other, 30, 60, L["启用"], "UnitframeOptions", "showthreatbar")
T.createcheckbutton(UFInnerframe.other, 30, 90, L["显示PvP标记"], "UnitframeOptions", "pvpicon", L["显示PvP标记提示"])
T.createcheckbutton(UFInnerframe.other, 30, 120, L["启用首领框体"], "UnitframeOptions", "bossframes")
T.createcheckbutton(UFInnerframe.other, 30, 150, L["启用PVP框体"], "UnitframeOptions", "arenaframes")

if G.myClass == "DEATHKNIGHT" then
    T.createcheckbutton(UFInnerframe.other, 30, 180, format(L["显示冷却"], RUNES), "UnitframeOptions", "runecooldown")
	T.createslider(UFInnerframe.other, 30, 230, L["字体大小"], "UnitframeOptions", "valuefs", 1, 8, 16, 1)
elseif G.myClass == "DRUID" then
	T.createcheckbutton(UFInnerframe.other, 30, 180, format(L["显示数值"], ECLIPSE), "UnitframeOptions", "eclipsevalue")
	T.createslider(UFInnerframe.other, 30, 230, L["字体大小"], "UnitframeOptions", "valuefs", 1, 8, 16, 1)
elseif G.myClass == "WARLOCK" then
	T.createcheckbutton(UFInnerframe.other, 30, 180, format(L["显示数值"], DEMONIC_FURY), "UnitframeOptions", "demonicfuryvalue")
	T.createslider(UFInnerframe.other, 30, 230, L["字体大小"], "UnitframeOptions", "valuefs", 1, 8, 16, 1)
elseif G.myClass == "SHAMAN" then
	T.createcheckbutton(UFInnerframe.other, 30, 180, format(L["显示时间"], WHC_TITLE_SHAMAN_2), "UnitframeOptions", "totemcooldown")
	T.createslider(UFInnerframe.other, 30, 230, L["字体大小"], "UnitframeOptions", "valuefs", 1, 8, 16, 1)
end

--====================================================--
--[[               -- Raid Frames --                ]]--
--====================================================--
local RFOptions = CreateOptionPage("RF Options", L["团队框架"], GUI, "VERTICAL")

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

RFInnerframe.common = CreateOptionPage("RF Options common", L["通用设置"], RFInnerframe, "VERTICAL", .3)
RFInnerframe.common:Show()

T.createcheckbutton(RFInnerframe.common, 30, 60, L["启用"], "UnitframeOptions", "enableraid")
T.createcheckbutton(RFInnerframe.common, 30, 90, L["显示宠物"], "UnitframeOptions", "showraidpet")
T.createcheckbutton(RFInnerframe.common, 30, 120, L["未进组时显示"], "UnitframeOptions", "showsolo")
T.createslider(RFInnerframe.common, 30, 170, L["名字长度"], "UnitframeOptions", "namelength", 1, 2, 10, 1)
T.createcheckbutton(RFInnerframe.common, 30, 210, L["启用方向箭头"], "UnitframeOptions", "enablearrow", L["enablearrow2"])
T.createslider(RFInnerframe.common, 30, 260, L["尺寸"], "UnitframeOptions", "arrowsacle", 100, 50, 200, 5)
T.createDR(RFInnerframe.common.enablearrow, RFInnerframe.common.arrowsacle)

RFInnerframe.switch = CreateOptionPage("RF Options switch", L["切换"], RFInnerframe, "VERTICAL", .3)

T.createcheckbutton(RFInnerframe.switch, 30, 60, L["禁用自动切换"], "UnitframeOptions", "autoswitch", L["禁用自动切换提示"])
local raidonly_group = {
	["healer"] = L["治疗模式"],
	["dps"] = L["输出/坦克模式"],
}
T.createradiobuttongroup(RFInnerframe.switch, 30, 90, L["团队模式"], "UnitframeOptions", "raidonly", raidonly_group)
T.createDR(RFInnerframe.switch.autoswitch, RFInnerframe.switch.raidonly)

RFInnerframe.healer = CreateOptionPage("RF Options healer", L["治疗模式"], RFInnerframe, "VERTICAL", .3)

local groupfilter_group = {
	["1,2,3,4,5"] = L["25-man"],
	["1,2,3,4,5,6,7,8"] = L["40-man"],
}
T.createradiobuttongroup(RFInnerframe.healer, 30, 60, L["团队规模"], "UnitframeOptions", "healergroupfilter", groupfilter_group)
T.createslider(RFInnerframe.healer, 30, 110, L["高度"], "UnitframeOptions", "healerraidheight", 1, 10, 150, 1)
T.createslider(RFInnerframe.healer, 30, 150, L["宽度"], "UnitframeOptions", "healerraidwidth", 1, 10, 150, 1)
T.createcheckbutton(RFInnerframe.healer, 30, 190, L["raidmanabars"], "UnitframeOptions", "raidmanabars")
T.createslider(RFInnerframe.healer,  30, 240, L["生命条高度比"], "UnitframeOptions", "raidhpheight", 100, 20, 95, 5, L["生命条高度比提示"])
T.createDR(RFInnerframe.healer.raidmanabars, RFInnerframe.healer.raidhpheight)
local raidanchor_group = {
	["LEFT"] = L["LEFT"],
	["TOP"] = L["TOP"],
}
T.createradiobuttongroup(RFInnerframe.healer, 30, 280, L["排列方向"], "UnitframeOptions", "anchor", raidanchor_group)
T.createradiobuttongroup(RFInnerframe.healer, 30, 310, L["小队排列方向"], "UnitframeOptions", "partyanchor", raidanchor_group)
T.createcheckbutton(RFInnerframe.healer, 30, 340, L["GCD"], "UnitframeOptions", "showgcd", L["GCD提示"])
T.createcheckbutton(RFInnerframe.healer, 30, 370, L["显示缺失生命值"], "UnitframeOptions", "showmisshp", L["显示缺失生命值提示"])
T.createcheckbutton(RFInnerframe.healer, 30, 400, L["治疗和吸收预估"], "UnitframeOptions", "healprediction", L["治疗和吸收预估提示"])

RFInnerframe.dps = CreateOptionPage("RF Options dps", L["输出/坦克模式"], RFInnerframe, "VERTICAL", .3)

T.createradiobuttongroup(RFInnerframe.dps, 30, 60, L["团队规模"], "UnitframeOptions", "dpsgroupfilter", groupfilter_group)
T.createslider(RFInnerframe.dps, 30, 110, L["高度"], "UnitframeOptions", "dpsraidheight", 1, 10, 150, 1)
T.createslider(RFInnerframe.dps, 30, 150, L["宽度"], "UnitframeOptions", "dpsraidwidth", 1, 10, 150, 1)
T.createcheckbutton(RFInnerframe.dps, 30, 190, L["职业顺序"], "UnitframeOptions", "dpsraidgroupbyclass")
T.createslider(RFInnerframe.dps, 30, 240, L["整体高度"], "UnitframeOptions", "unitnumperline", 1, 1, 40, 1, L["整体高度提示"])

RFInnerframe.clickcast = CreateOptionPage("RF Options clickcast", L["点击施法"], RFInnerframe, "VERTICAL", .3)

local enableClickCastbu = T.createcheckbutton(RFInnerframe.clickcast, 30, 60, L["启用"], "UnitframeOptions", "enableClickCast", format(L["点击施法提示"], G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor))

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

StaticPopupDialogs[G.uiname.."give macro"] = {
	text = L["输入一个宏"],
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
		_G[self:GetName().."EditBox"]:SetText(L["输入一个宏"])
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
				StaticPopupDialogs[G.uiname.."incorrect spell"].text = L["不正确的法术名称"].." |cff7FFF00"..var.." |r"
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
			StaticPopupDialogs[G.uiname.."incorrect spell"].text = L["不正确的法术名称"].." |cff7FFF00"..var.." |r"
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
			StaticPopupDialogs[G.uiname.."incorrect spell"].text = L["不正确的法术名称"].." |cff7FFF00"..var.." |r"
			StaticPopup_Show(G.uiname.."incorrect spell")
			self:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"])
		end
		self:ClearFocus()
	end)
end

RFInnerframe.raiddebuff = CreateOptionPage("RF Options Raid Debuff", L["团队减益"], RFInnerframe, "VERTICAL", .3)

local RFDebuff_InnerFrame = CreateFrame("Frame", G.uiname.."RF Debuff Innerframe", RFInnerframe.raiddebuff)
RFDebuff_InnerFrame:SetPoint("TOPLEFT", 40, -60)
RFDebuff_InnerFrame:SetPoint("BOTTOMRIGHT", -30, 20)

local function LineUpRaidDebuffList(parent, raidname)
	local i = -1
	for index, boss in pairs(G.Raids[raidname]) do
		i = i + 1
		if _G[G.uiname.."RaidDebuff"..raidname..boss.."Title"] then
		_G[G.uiname.."RaidDebuff"..raidname..boss.."Title"]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10-i*30)
		i = i + 1
		local t = {}
		for spell, info in pairs(aCoreCDB["RaidDebuff"][raidname][boss]) do
			table.insert(t, info)
		end
		sort(t, function(a,b) return a.level > b.level or (a.level == b.level and a.id > b.id) end)
		for a = 1, #t do
			_G[G.uiname.."RaidDebuff"..raidname..boss..t[a].id]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10-i*30)
			i = i + 1
		end
		else
			print(raidname,boss)
		end
	end
end

local function CreateEncounterDebuffButton(parent, raid, boss, name, spellID, level)
	local bu = CreateFrame("Frame", G.uiname.."RaidDebuff"..raid..boss..spellID, parent)
	bu:SetSize(330, 20)
	
	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(18, 18)
	bu.icon:SetNormalTexture(select(3, GetSpellInfo(spellID)))
	bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetPoint"LEFT"
	F.CreateBG(bu.icon)
	
	bu.level = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.level:SetPoint("LEFT", 40, 0)
	bu.level:SetTextColor(1, .2, .6)
	bu.level:SetText(level)
	
	bu.spellname = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.spellname:SetPoint("LEFT", 140, 0)
	bu.spellname:SetTextColor(1, 1, 0)
	bu.spellname:SetText(name)
	
	bu.close = CreateFrame("Button", nil, bu)
	bu.close:SetSize(22,22)
	bu.close:SetPoint("LEFT", 310, 0)
	bu.close.text = T.createtext(bu.close, "OVERLAY", 12, "OUTLINE", "CENTER")
	bu.close.text:SetPoint("CENTER")
	bu.close.text:SetText("x")
	
	bu.close:SetScript("OnClick", function() 
		bu:Hide()
		aCoreCDB["RaidDebuff"][raid][boss][name] = nil
		LineUpRaidDebuffList(parent, raid)
	end)
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	bu:SetScript("OnMouseDown", function(self)
		local frame = parent:GetParent()
		if frame.selectdebuff ~= spellID then
			UIDropDownMenu_SetText(frame.BossDD, boss)
			frame.Spellinput:ClearFocus()
			frame.Spellinput:SetText(spellID)
			frame.Levelinput:ClearFocus()
			frame.Levelinput:SetText(level)	
			frame.selectdebuff = spellID
		else
			UIDropDownMenu_SetText(frame.BossDD, "")
			frame.Spellinput:ClearFocus()
			frame.Spellinput:SetText("")
			frame.Levelinput:ClearFocus()
			frame.Levelinput:SetText("")		
			frame.selectdebuff = nil
		end
	end)
	
	return bu
end

local function CreateEncounterDebuffList(frame, raid, bosstable)
	for boss, debufflist in pairs (bosstable) do
		local name = frame:CreateFontString(G.uiname.."RaidDebuff"..raid..boss.."Title", "OVERLAY")
		name:SetFont(G.norFont, 14, "OUTLINE")
		name:SetJustifyH("LEFT")
		name:SetText(boss)
		for spell, info in pairs (debufflist) do
			CreateEncounterDebuffButton(frame, raid, boss, spell, info.id, info.level)
		end
	end
	LineUpRaidDebuffList(frame, raid)
end

local raidindex = 1
local function CreateRaidDebuffOptions()
	for raidname, bosstable in pairs (aCoreCDB["RaidDebuff"]) do
		local frame = CreateFrame("ScrollFrame", G.uiname.."Raiddebuff Frame"..raidindex, RFInnerframe.raiddebuff, "UIPanelScrollFrameTemplate")
		frame:SetPoint("TOPLEFT", 40, -95)
		frame:SetPoint("BOTTOMRIGHT", -50, 20)
		frame:Hide()
		
		frame.SFAnchor = CreateFrame("Frame", G.uiname.."Raiddebuff Frame"..raidindex.."ScrollAnchor", frame)
		frame.SFAnchor:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -3)
		frame.SFAnchor:SetWidth(frame:GetWidth()-30)
		frame.SFAnchor:SetHeight(frame:GetHeight()+200)
		frame.SFAnchor:SetFrameLevel(frame:GetFrameLevel()+1)
		
		frame:SetScrollChild(frame.SFAnchor)
		
		F.ReskinScroll(_G[G.uiname.."Raiddebuff Frame"..raidindex.."ScrollBar"])
		
		CreateEncounterDebuffList(frame.SFAnchor, raidname, bosstable)
		
		local BossDD = CreateFrame("Frame", G.uiname..raidname.."SelectBossDropdown", frame, "UIDropDownMenuTemplate")
		BossDD:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 10, 5)
		F.ReskinDropDown(BossDD)

		BossDD.name = T.createtext(BossDD, "OVERLAY", 13, "OUTLINE", "LEFT")
		BossDD.name:SetPoint("BOTTOMRIGHT", BossDD, "BOTTOMLEFT", 15, 12)
		BossDD.name:SetText("BOSS")

		UIDropDownMenu_SetWidth(BossDD, 100)
		UIDropDownMenu_SetText(BossDD, "")

		UIDropDownMenu_Initialize(BossDD, function(self, level, menuList)
			local info = UIDropDownMenu_CreateInfo()
			for i = 1, #(G.Raids[raidname]) do
				info.text = G.Raids[raidname][i]
				info.func = function()
					UIDropDownMenu_SetText(BossDD, G.Raids[raidname][i])
					CloseDropDownMenus()
				end
				UIDropDownMenu_AddButton(info)
			end
		end)
		
		frame.BossDD = BossDD
		
		local Spellinput = CreateFrame("EditBox", G.uiname..raidname.."Spell Input", frame)
		Spellinput:SetSize(60, 20)
		Spellinput:SetPoint("LEFT", BossDD, "RIGHT", -5, 2)
		F.CreateBD(Spellinput)
		
		Spellinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
		Spellinput:SetAutoFocus(false)
		Spellinput:SetTextInsets(3, 0, 0, 0)

		Spellinput:SetScript("OnShow", function(self) self:SetText(L["输入法术ID"]) end)
		Spellinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
		Spellinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入法术ID"]) end)
		Spellinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
		
		frame.Spellinput = Spellinput
		
		local Levelinput = CreateFrame("EditBox", G.uiname..raidname.."Level Input", frame)
		Levelinput:SetSize(60, 20)
		Levelinput:SetPoint("LEFT", Spellinput, "RIGHT", 5, 0)
		F.CreateBD(Levelinput)

		Levelinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
		Levelinput:SetAutoFocus(false)
		Levelinput:SetTextInsets(3, 0, 0, 0)

		Levelinput:SetScript("OnShow", function(self) self:SetText(L["输入层级"]) end)
		Levelinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
		Levelinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入层级"]) end)
		Levelinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
		
		frame.Levelinput = Levelinput
		
		local Add = CreateFrame("Button", G.uiname..raidname.."Add Debuff Button", frame, "UIPanelButtonTemplate")
		Add:SetPoint("LEFT", Levelinput, "RIGHT", 10, 0)
		Add:SetSize(70, 20)
		Add:SetText(ADD)
		F.Reskin(Add)
		Add:SetScript("OnClick", function(self)
			local boss = UIDropDownMenu_GetText(BossDD)
			local spellID = tonumber(Spellinput:GetText())
			local level = tonumber(Levelinput:GetText())
			if not spellID or not GetSpellInfo(spellID) then
				StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID.." |r"..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellid")
			elseif not level then
				StaticPopupDialogs[G.uiname.."incorrect level"].text = "|cff7FFF00"..Levelinput:GetText().." |r"..L["必须是一个数字"]
				StaticPopup_Show(G.uiname.."incorrect level")
			elseif bosstable[boss] then
				local name = GetSpellInfo(spellID)
				if aCoreCDB["RaidDebuff"][raidname][boss][name] then -- 已经有这个ID ，改一下层级
					aCoreCDB["RaidDebuff"][raidname][boss][name]["level"] = level
					_G[G.uiname.."RaidDebuff"..raidname..boss..spellID].level:SetText(level)
					LineUpRaidDebuffList(frame.SFAnchor, raidname)
				elseif _G[G.uiname.."RaidDebuff"..raidname..boss..spellID] then -- 已经有这个框体
					aCoreCDB["RaidDebuff"][raidname][boss][name] = {id = spellID, level = level,}
					_G[G.uiname.."RaidDebuff"..raidname..boss..spellID].level:SetText(level)
					_G[G.uiname.."RaidDebuff"..raidname..boss..spellID]:Show()
					LineUpRaidDebuffList(frame.SFAnchor, raidname)
				else
					aCoreCDB["RaidDebuff"][raidname][boss][name] = {id = spellID, level = level,}
					CreateEncounterDebuffButton(frame.SFAnchor, raidname, boss, name, spellID, level)
					LineUpRaidDebuffList(frame.SFAnchor, raidname)
				end
			end
		end)
		
		frame.Add = Add
		
		local Back = CreateFrame("Button", nil, frame)
		Back:SetSize(26, 26)
		Back:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Up")
		Back:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Down")
		Back:SetPoint("LEFT", Add, "RIGHT", 2, 0)
		Back:SetScript("OnClick", function() 
			local children = {RFInnerframe.raiddebuff:GetChildren()}
			for i = 1, #children do
				if children[i]:GetName():match(G.uiname.."Raiddebuff Frame") then
					children[i]:Hide()
				end
			end
			RFDebuff_InnerFrame:Show()
		end)
		
		local Reset = CreateFrame("Button", G.uiname..raidname.."Reset RaidDebuff Button", frame, "UIPanelButtonTemplate")
		Reset:SetPoint("BOTTOM", ReloadButton, "TOP", 0, 10)
		Reset:SetSize(100, 25)
		Reset:SetText(L["重置"])
		F.Reskin(Reset)
		Reset:SetScript("OnClick", function(self)
			StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], raidname)
			StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
				aCoreCDB["RaidDebuff"][raidname] = nil
				ReloadUI()
			end
			StaticPopup_Show(G.uiname.."Reset Confirm")
		end)
		
		local tab = CreateFrame("Button", G.uiname.."Raiddebuff Tab"..raidindex, RFDebuff_InnerFrame, "UIPanelButtonTemplate")
		tab:SetFrameLevel(RFDebuff_InnerFrame:GetFrameLevel()+2)
		tab:SetSize(150, 25)
		tab:SetText(raidname)
		F.Reskin(tab)
	
		tab:HookScript("OnMouseDown", function(self)
			RFDebuff_InnerFrame:Hide()
			frame:Show()
		end)
	
		if mod(raidindex, 2) == 1 then
			tab:SetPoint("TOPLEFT", RFDebuff_InnerFrame, "TOPLEFT", 20, -floor(raidindex/2)*35-20)
		elseif mod(raidindex, 2) == 0 then
			tab:SetPoint("TOPLEFT", RFDebuff_InnerFrame, "TOPLEFT", 190, -floor(raidindex/2-1)*35-20)
		end
		
		RFDebuff_InnerFrame["tab"..raidindex] = tab
		RFDebuff_InnerFrame["frame"..raidindex] = frame
		
		raidindex = raidindex +1
	end
end

RFInnerframe.cooldownaura = CreateOptionPage("RF Options Cooldown Aura", L["重要法术"], RFInnerframe, "VERTICAL", .3)

local cooldownauraframe = CreateFrame("Frame", G.uiname.."Cooldown Aura Options", RFInnerframe.cooldownaura)
cooldownauraframe:SetPoint("TOPLEFT", 30, -85)
cooldownauraframe:SetPoint("BOTTOMRIGHT", -30, 20)
F.CreateBD(cooldownauraframe, 0)
cooldownauraframe.tabindex = 1
cooldownauraframe.tabnum = 2
for i = 1, 2 do
	cooldownauraframe["tab"..i] = CreateFrame("Frame", G.uiname.."cooldownauraframe Tab"..i, cooldownauraframe)
	cooldownauraframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

local function LineUpCooldownAuraList(parent, auratype)
	local t = {}
	for spell, info in pairs(aCoreCDB["CooldownAura"][auratype]) do
		table.insert(t, info)
	end
	sort(t, function(a,b) return a.level > b.level or (a.level == b.level and a.id > b.id) end)
	for i = 1, #t do
		_G[G.uiname.."Cooldown"..auratype..t[i].id]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, 20-i*30)
	end
end

local function CreateCooldownAuraButton(parent, auratype, name, spellID, level)
	local bu = CreateFrame("Frame", G.uiname.."Cooldown"..auratype..spellID, parent)
	bu:SetSize(330, 20)
	
	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(18, 18)
	bu.icon:SetNormalTexture(select(3, GetSpellInfo(spellID)))
	bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetPoint"LEFT"
	F.CreateBG(bu.icon)
	
	bu.level = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.level:SetPoint("LEFT", 40, 0)
	bu.level:SetTextColor(1, .2, .6)
	bu.level:SetText(level)
	
	bu.spellname = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.spellname:SetPoint("LEFT", 140, 0)
	bu.spellname:SetTextColor(1, 1, 0)
	bu.spellname:SetText(name)
	
	bu.close = CreateFrame("Button", nil, bu)
	bu.close:SetSize(22,22)
	bu.close:SetPoint("LEFT", 310, 0)
	bu.close.text = T.createtext(bu.close, "OVERLAY", 12, "OUTLINE", "CENTER")
	bu.close.text:SetPoint("CENTER")
	bu.close.text:SetText("x")
	
	bu.close:SetScript("OnClick", function() 
		bu:Hide()
		aCoreCDB["CooldownAura"][auratype][name] = nil
		LineUpCooldownAuraList(parent, auratype)
	end)
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	bu:SetScript("OnMouseDown", function(self)
		local frame = parent:GetParent():GetParent()
		if frame.selectdebuff ~= spellID then
			frame.Spellinput:ClearFocus()
			frame.Spellinput:SetText(spellID)
			frame.Levelinput:ClearFocus()
			frame.Levelinput:SetText(level)	
			frame.selectdebuff = spellID
		else
			frame.Spellinput:ClearFocus()
			frame.Spellinput:SetText("")
			frame.Levelinput:ClearFocus()
			frame.Levelinput:SetText("")		
			frame.selectdebuff = nil
		end
	end)
	
	return bu
end

local function CreateCooldownAuraList(frame, auratype, auratable)
	for spell, info in pairs (auratable) do
		if info.id then
		CreateCooldownAuraButton(frame, auratype, spell, info.id, info.level)
		end
	end
	LineUpCooldownAuraList(frame, auratype)
end

local function CreateCooldownAuraOptions()
	for auratype, auratable in T.pairsByKeys(aCoreCDB["CooldownAura"]) do
		local frame = CreateOptionPage("Cooldown "..auratype.." Options", L[auratype], cooldownauraframe, "HORIZONTAL", .3, true)
		frame.title:Hide()
		frame.line:Hide()
		if auratype == "Buffs" then
			frame:Show()
		end
		
		frame.SF:SetPoint("TOPLEFT", 10, -40)
		frame.SF:SetPoint("BOTTOMRIGHT", -30, 20)
		
		CreateCooldownAuraList(frame.SFAnchor, auratype, auratable)
		
		local Spellinput = CreateFrame("EditBox", G.uiname..auratype.."Spell Input", frame)
		Spellinput:SetSize(120, 20)
		Spellinput:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -10)
		F.CreateBD(Spellinput)
		
		Spellinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
		Spellinput:SetAutoFocus(false)
		Spellinput:SetTextInsets(3, 0, 0, 0)

		Spellinput:SetScript("OnShow", function(self) self:SetText(L["输入法术ID"]) end)
		Spellinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
		Spellinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入法术ID"]) end)
		Spellinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
		
		frame.Spellinput = Spellinput
		
		local Levelinput = CreateFrame("EditBox", G.uiname..auratype.."Level Input", frame)
		Levelinput:SetSize(80, 20)
		Levelinput:SetPoint("LEFT", Spellinput, "RIGHT", 5, 0)
		F.CreateBD(Levelinput)

		Levelinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
		Levelinput:SetAutoFocus(false)
		Levelinput:SetTextInsets(3, 0, 0, 0)

		Levelinput:SetScript("OnShow", function(self) self:SetText(L["输入层级"]) end)
		Levelinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
		Levelinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入层级"]) end)
		Levelinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
		
		frame.Levelinput = Levelinput
		
		local Add = CreateFrame("Button", G.uiname..auratype.."Add CooldownAura Button", frame, "UIPanelButtonTemplate")
		Add:SetPoint("LEFT", Levelinput, "RIGHT", 10, 0)
		Add:SetSize(70, 20)
		Add:SetText(ADD)
		F.Reskin(Add)
		Add:SetScript("OnClick", function(self)
			local spellID = tonumber(Spellinput:GetText())
			local level = tonumber(Levelinput:GetText())
			if not spellID or not GetSpellInfo(spellID) then
				StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID.." |r"..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellid")
			elseif not level then
				StaticPopupDialogs[G.uiname.."incorrect level"].text = "|cff7FFF00"..Levelinput:GetText().." |r"..L["必须是一个数字"]
				StaticPopup_Show(G.uiname.."incorrect level")
			else
				local name = GetSpellInfo(spellID)
				if aCoreCDB["CooldownAura"][auratype][name] then -- 已经有这个ID ，改一下层级
					aCoreCDB["CooldownAura"][auratype][name]["level"] = level
					_G[G.uiname.."Cooldown"..auratype..spellID].level:SetText(level)
					LineUpCooldownAuraList(frame.SFAnchor, auratype)
				elseif _G[G.uiname.."Cooldown"..auratype..spellID] then -- 已经有这个框体
					aCoreCDB["CooldownAura"][auratype][name] = {id = spellID, level = level,}
					_G[G.uiname.."Cooldown"..auratype..spellID].level:SetText(level)
					_G[G.uiname.."Cooldown"..auratype..spellID]:Show()
					LineUpCooldownAuraList(frame.SFAnchor, auratype)
				else
					aCoreCDB["CooldownAura"][auratype][name] = {id = spellID, level = level,}
					CreateCooldownAuraButton(frame.SFAnchor, auratype, name, spellID, level)
					LineUpCooldownAuraList(frame.SFAnchor, auratype)
				end
			end
		end)
		
		frame.Add = Add
		
		local Reset = CreateFrame("Button", G.uiname..auratype.."Reset CooldownAura Button", frame, "UIPanelButtonTemplate")
		Reset:SetPoint("BOTTOM", ReloadButton, "TOP", 0, 10)
		Reset:SetSize(100, 25)
		Reset:SetText(L["重置"])
		F.Reskin(Reset)
		Reset:SetScript("OnClick", function(self)
			StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], L[auratype])
			StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
				aCoreCDB["CooldownAura"][auratype] = nil
				ReloadUI()
			end
			StaticPopup_Show(G.uiname.."Reset Confirm")
		end)
		
		cooldownauraframe[auratype.."Options"] = frame
	end
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

ActionbarInnerframe.common = CreateOptionPage("Actionbar Options common", L["通用设置"], ActionbarInnerframe, "VERTICAL", .3)
ActionbarInnerframe.common:Show()

T.createcheckbutton(ActionbarInnerframe.common, 30, 60, L["显示冷却时间"], "ActionbarOptions", "cooldown", L["显示冷却时间提示"])
T.createslider(ActionbarInnerframe.common, 30, 110, L["冷却时间数字大小"], "ActionbarOptions", "cooldownsize", 1, 18, 25, 1, L["冷却时间数字大小提示"])
T.createcheckbutton(ActionbarInnerframe.common, 30, 150, L["不可用颜色"], "ActionbarOptions", "rangecolor", L["不可用颜色提示"])
T.createslider(ActionbarInnerframe.common, 30, 200, L["键位字体大小"], "ActionbarOptions", "keybindsize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 240, L["宏名字字体大小"], "ActionbarOptions", "macronamesize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 280, L["可用次数字体大小"], "ActionbarOptions", "countsize", 1, 8, 20, 1)
T.createDR(ActionbarInnerframe.common.cooldown, ActionbarInnerframe.common.cooldownsize)

ActionbarInnerframe.bar12 = CreateOptionPage("Actionbar Options bar12", L["主动作条"], ActionbarInnerframe, "VERTICAL", .3)

--ActionbarInnerframe.bar12.bar2toggle = T.ABtogglebox(ActionbarInnerframe.bar12, 30, 60, 1, L["主动作条"])
T.createcheckbutton(ActionbarInnerframe.bar12, 30, 60, L["更改上下位置"], "ActionbarOptions", "bar1top")
T.createslider(ActionbarInnerframe.bar12, 30, 110, L["图标大小"], "ActionbarOptions", "bar12size", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.bar12, 30, 150, L["图标间距"], "ActionbarOptions", "bar12space", 1, 0, 10, 1)
T.createcheckbutton(ActionbarInnerframe.bar12, 30, 190, L["悬停渐隐"], "ActionbarOptions", "bar12mfade", L["悬停渐隐提示"])
T.createcheckbutton(ActionbarInnerframe.bar12, 30, 220, L["条件渐隐"], "ActionbarOptions", "bar12efade", L["条件渐隐提示"])
T.createslider(ActionbarInnerframe.bar12, 30, 270, L["渐隐透明度"], "ActionbarOptions", "bar12fademinaplha", 100, 0, 80, 5, L["渐隐透明度提示"])

ActionbarInnerframe.bar3 = CreateOptionPage("Actionbar Options bar3", L["额外动作条"], ActionbarInnerframe, "VERTICAL", .3)

--ActionbarInnerframe.bar3.bar3toggle = T.ABtogglebox(ActionbarInnerframe.bar3, 30, 60, 2, L["额外动作条"])
T.createcheckbutton(ActionbarInnerframe.bar3, 30, 60, L["3*2*2布局"], "ActionbarOptions", "bar3uselayout322", L["3*2*2布局提示"])
T.createslider(ActionbarInnerframe.bar3, 30, 110, L["额外动作条间距"], "ActionbarOptions", "space1", 1, -300, 150, 1, L["额外动作条间距提示"])
T.createslider(ActionbarInnerframe.bar3, 30, 150, L["图标大小"], "ActionbarOptions", "bar3size", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.bar3, 30, 190, L["图标间距"], "ActionbarOptions", "bar3space", 1, 0, 10, 1)
T.createcheckbutton(ActionbarInnerframe.bar3, 30, 230, L["悬停渐隐"], "ActionbarOptions", "bar3mfade", L["悬停渐隐提示"])
T.createcheckbutton(ActionbarInnerframe.bar3, 30, 260, L["条件渐隐"], "ActionbarOptions", "bar3efade", L["条件渐隐提示"])
T.createslider(ActionbarInnerframe.bar3, 30, 310, L["渐隐透明度"], "ActionbarOptions", "bar3fademinaplha", 100, 0, 80, 5, L["渐隐透明度提示"])

ActionbarInnerframe.bar45 = CreateOptionPage("Actionbar Options bar45", L["右侧额外动作条"], ActionbarInnerframe, "VERTICAL", .3)

--ActionbarInnerframe.bar45.bar4toggle = T.ABtogglebox(ActionbarInnerframe.bar45, 30, 60, 3, L["右侧额外动作条"].." 1")
--ActionbarInnerframe.bar45.bar5toggle = T.ABtogglebox(ActionbarInnerframe.bar45, 30, 90, 4, L["右侧额外动作条"].." 2")
--T.createDR(ActionbarInnerframe.bar45.bar4toggle, ActionbarInnerframe.bar45.bar5toggle)
T.createslider(ActionbarInnerframe.bar45, 30, 60, L["图标大小"], "ActionbarOptions", "bar45size", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.bar45, 30, 100, L["图标间距"], "ActionbarOptions", "bar45space", 1, 0, 10, 1)
T.createcheckbutton(ActionbarInnerframe.bar45, 30, 140, L["悬停渐隐"], "ActionbarOptions", "bar45mfade", L["悬停渐隐提示"])
T.createcheckbutton(ActionbarInnerframe.bar45, 30, 170, L["条件渐隐"], "ActionbarOptions", "bar45efade", L["条件渐隐提示"])
T.createslider(ActionbarInnerframe.bar45, 30, 220, L["渐隐透明度"], "ActionbarOptions", "bar45fademinaplha", 100, 0, 80, 5, L["渐隐透明度提示"])

ActionbarInnerframe.petbar = CreateOptionPage("Actionbar Options petbar", L["宠物动作条"], ActionbarInnerframe, "VERTICAL", .3)

T.createcheckbutton(ActionbarInnerframe.petbar, 30, 60, L["5*2布局"], "ActionbarOptions", "petbaruselayout5x2", L["5*2布局提示"])
T.createslider(ActionbarInnerframe.petbar, 30, 110, L["缩放尺寸"], "ActionbarOptions", "petbarscale", 10, 5, 25, 1)
T.createslider(ActionbarInnerframe.petbar, 30, 150, L["图标间距"], "ActionbarOptions", "petbuttonspace", 1, 0, 5, 1)
T.createcheckbutton(ActionbarInnerframe.petbar, 30, 190, L["悬停渐隐"], "ActionbarOptions", "petbarmfade", L["悬停渐隐提示"])
T.createcheckbutton(ActionbarInnerframe.petbar, 30, 220, L["条件渐隐"], "ActionbarOptions", "petbarefade", L["条件渐隐提示"])
T.createslider(ActionbarInnerframe.petbar, 30, 270, L["渐隐透明度"], "ActionbarOptions", "petbarfademinaplha", 100, 0, 80, 5, L["渐隐透明度提示"])

ActionbarInnerframe.other = CreateOptionPage("Actionbar Options bar12", OTHER, ActionbarInnerframe, "VERTICAL", .3)

local stancebartitle = ActionbarInnerframe.other:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
stancebartitle:SetPoint("TOPLEFT", 36, -75)
stancebartitle:SetText(L["姿态/形态条"])
local stancebarinneranchor_group = {
	["LEFT"] = L["左"],
	["RIGHT"] = L["右"],
}
T.createradiobuttongroup(ActionbarInnerframe.other, 30, 90, L["排列方向"], "ActionbarOptions", "stancebarinneranchor", stancebarinneranchor_group)
T.createslider(ActionbarInnerframe.other, 30, 140, L["图标大小"], "ActionbarOptions", "stancebarbuttonszie", 1, 15, 40, 1)
T.createslider(ActionbarInnerframe.other, 30, 180, L["图标间距"], "ActionbarOptions", "stancebarbuttonspace", 1, 0, 5, 1)
T.createcheckbutton(ActionbarInnerframe.other, 30, 215, L["悬停渐隐"], "ActionbarOptions", "stancebarmfade", L["悬停渐隐提示"])
T.createslider(ActionbarInnerframe.other, 30, 260, L["渐隐透明度"], "ActionbarOptions", "stancebarfademinaplha", 100, 0, 80, 5, L["渐隐透明度提示"])
local leave_vehicletitle = ActionbarInnerframe.other:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
leave_vehicletitle:SetPoint("TOPLEFT", 36, -295)
leave_vehicletitle:SetText(L["离开载具按钮"])
T.createslider(ActionbarInnerframe.other, 30, 330, L["图标大小"], "ActionbarOptions", "leave_vehiclebuttonsize", 1, 15, 50, 1)
local extrabartitle = ActionbarInnerframe.other:CreateFontString(nil, "ARTWORK", "GameFontNormalLeftYellow")
extrabartitle:SetPoint("TOPLEFT", 36, -375)
extrabartitle:SetText(L["额外特殊按钮"])
T.createslider(ActionbarInnerframe.other, 30, 410, L["图标大小"], "ActionbarOptions", "extrabarbuttonsize", 1, 15, 50, 1)

--====================================================--
--[[           -- BuffFrame Options --              ]]--
--====================================================--
local BuffFrameOptions = CreateOptionPage("BuffFrame Options", AURAS, GUI, "VERTICAL")

T.createslider(BuffFrameOptions, 30, 120, L["图标大小"], "BuffFrameOptions", "buffsize", 1, 20, 50, 1)
T.createslider(BuffFrameOptions, 320, 120, L["图标大小"], "BuffFrameOptions", "debuffsize", 1, 20, 50, 1)
T.createslider(BuffFrameOptions, 30, 160, L["行距"], "BuffFrameOptions", "buffrowspace", 1, 0, 20, 1)
T.createslider(BuffFrameOptions, 320, 160, L["行距"], "BuffFrameOptions", "debuffrowspace", 1, 0, 20, 1)
T.createslider(BuffFrameOptions, 30, 200, L["图标左右间隙"], "BuffFrameOptions", "buffcolspace", 1, 0, 10, 1)
T.createslider(BuffFrameOptions, 320, 200, L["图标左右间隙"], "BuffFrameOptions", "debuffcolspace", 1, 0, 10, 1)
T.createslider(BuffFrameOptions, 30, 240, L["每一行的图标数量"], "BuffFrameOptions", "buffsPerRow", 1, 10, 30, 1)
T.createslider(BuffFrameOptions, 320, 240, L["每一行的图标数量"], "BuffFrameOptions", "debuffsPerRow", 1, 10, 30, 1)
T.createslider(BuffFrameOptions, 30, 280, L["持续时间大小"], "BuffFrameOptions", "bufftimesize", 1, 8, 20, 1)
T.createslider(BuffFrameOptions, 320, 280, L["持续时间大小"], "BuffFrameOptions", "debufftimesize", 1, 8, 20, 1)
T.createslider(BuffFrameOptions, 30, 320, L["堆叠数字大小"], "BuffFrameOptions", "buffcountsize", 1, 8, 20, 1)
T.createslider(BuffFrameOptions, 320, 320, L["堆叠数字大小"], "BuffFrameOptions", "debuffcountsize", 1, 8, 20, 1)
T.createcheckbutton(BuffFrameOptions, 30, 370, L["分离Buff和Debuff"], "BuffFrameOptions", "seperate")

local bufftitle = T.createtext(BuffFrameOptions, "OVERLAY", 18, "OUTLINE", "CENTER")
bufftitle:SetPoint("BOTTOM", BuffFrameOptions.buffsize, "TOP", 0, 25)
bufftitle:SetTextColor(.3, 1, .5)
bufftitle:SetText(L["Buffs"])

local debufftitle = T.createtext(BuffFrameOptions, "OVERLAY", 18, "OUTLINE", "CENTER")
debufftitle:SetPoint("BOTTOM", BuffFrameOptions.debuffsize, "TOP", 0, 25)
debufftitle:SetTextColor(1, .5, .3)
debufftitle:SetText(L["Debuffs"])
--====================================================--
--[[           -- NamePlates Options --             ]]--
--====================================================--
local PlateOptions = CreateOptionPage("Plate Options", UNIT_NAMEPLATES, GUI, "VERTICAL")
	
T.createcheckbutton(PlateOptions, 30, 60, L["启用"], "PlateOptions", "enableplate")
T.createslider(PlateOptions, 30, 110, L["姓名板宽度"], "PlateOptions", "platewidth", 1, 100, 300, 5)
T.createslider(PlateOptions, 30, 150, L["姓名板高度"], "PlateOptions", "plateheight", 1, 5, 25, 1)
PlateOptions.classcolorplatestoggle = T.CVartogglebox(PlateOptions, 30, 190, "ShowClassColorInNameplate", SHOW_CLASS_COLOR_IN_V_KEY)
T.createcheckbutton(PlateOptions, 30, 220, L["仇恨染色"], "PlateOptions", "threatplates", L["仇恨染色提示"])
T.createcheckbutton(PlateOptions, 30, 250, L["自动显示/隐藏"], "PlateOptions", "autotoggleplates", L["自动显示/隐藏提示"])
T.createcheckbutton(PlateOptions, 30, 280, L["显示减益"], "PlateOptions", "platedebuff", L["显示减益提示"])
T.createcheckbutton(PlateOptions, 30, 310, L["显示增益"], "PlateOptions", "platebuff", L["显示增益提示"])
T.createslider(PlateOptions, 30, 360, L["图标数量"], "PlateOptions", "plateauranum", 1, 3, 10, 1)
T.createslider(PlateOptions, 30, 400, L["图标大小"], "PlateOptions", "plateaurasize", 1, 20, 40, 2)
T.createDR(PlateOptions.enableplate, PlateOptions.platewidth, PlateOptions.plateheight, PlateOptions.threatplates, PlateOptions.autotoggleplates, PlateOptions.platedebuff, PlateOptions.platebuff, PlateOptions.plateauranum, PlateOptions.plateaurasize)

--====================================================--
--[[             -- Tooltip Options --              ]]--
--====================================================--
local TooltipOptions = CreateOptionPage("Tooltip Options", USE_UBERTOOLTIPS, GUI, "VERTICAL")

T.createcheckbutton(TooltipOptions, 30, 60, L["启用"], "TooltipOptions", "enabletip")
T.createslider(TooltipOptions, 30, 110, L["尺寸"], "TooltipOptions", "size", 10, 5, 15, 1)
T.createcheckbutton(TooltipOptions, 30, 150, L["跟随光标"], "TooltipOptions", "cursor")
T.createcheckbutton(TooltipOptions, 30, 180, L["隐藏服务器名称"], "TooltipOptions", "hideRealm")
T.createcheckbutton(TooltipOptions, 30, 210, L["隐藏称号"], "TooltipOptions", "hideTitles")
T.createcheckbutton(TooltipOptions, 30, 240, L["显示法术编号"], "TooltipOptions", "showspellID")
T.createcheckbutton(TooltipOptions, 30, 270, L["显示物品编号"], "TooltipOptions", "showitemID")
T.createcheckbutton(TooltipOptions, 30, 300, L["显示天赋"], "TooltipOptions", "showtalent")
T.createcheckbutton(TooltipOptions, 30, 330, L["按职业着色"], "TooltipOptions", "colorborderClass")
T.createcheckbutton(TooltipOptions, 30, 360, L["战斗中隐藏"], "TooltipOptions", "combathide")
T.createDR(TooltipOptions.enabletip, TooltipOptions.size, TooltipOptions.cursor, TooltipOptions.hideRealm, TooltipOptions.hideTitles, TooltipOptions.showspellID, TooltipOptions.showitemID, TooltipOptions.showtalent, TooltipOptions.colorborderClass, TooltipOptions.combathide)

--====================================================--
--[[             -- Combattext Options --              ]]--
--====================================================--
local CombattextOptions = CreateOptionPage("CombatText Options", L["战斗信息"], GUI, "VERTICAL")

T.createcheckbutton(CombattextOptions, 30, 60, L["启用"], "CombattextOptions", "combattext")
T.createcheckbutton(CombattextOptions, 30, 90, L["承受伤害/治疗"], "CombattextOptions", "showreceivedct")
T.createcheckbutton(CombattextOptions, 30, 120, L["输出伤害/治疗"], "CombattextOptions", "showoutputct")
T.createcheckbutton(CombattextOptions, 30, 150, L["过滤战斗信息"], "CombattextOptions", "ctfliter", L["过滤战斗信息提示"])
T.createslider(CombattextOptions, 30, 200, L["图标大小"], "CombattextOptions", "cticonsize", 1, 10, 30, 1)
T.createslider(CombattextOptions, 30, 240, L["暴击图标大小"], "CombattextOptions", "ctbigiconsize", 1, 10, 30, 1)
T.createcheckbutton(CombattextOptions, 30, 280, L["显示DOT"], "CombattextOptions", "ctshowdots")
T.createcheckbutton(CombattextOptions, 30, 310, L["显示HOT"], "CombattextOptions", "ctshowhots")
T.createcheckbutton(CombattextOptions, 30, 340, L["显示宠物"], "CombattextOptions", "ctshowpet")
T.createslider(CombattextOptions, 30, 390, L["隐藏时间"], "CombattextOptions", "ctfadetime", 10, 20, 100, 5, L["隐藏时间提示"])
T.createDR(CombattextOptions.combattext, CombattextOptions.showreceivedct, CombattextOptions.showoutputct, CombattextOptions.ctfliter, CombattextOptions.cticonsize, CombattextOptions.ctbigiconsize, CombattextOptions.ctshowdots, CombattextOptions.ctshowhots, CombattextOptions.ctshowpet, CombattextOptions.ctfadetime)

--====================================================--
--[[              -- RaidTool Options --                ]]--
--====================================================--
local RaidToolOptions = CreateOptionPage("RaidTool Options", L["团队工具"], GUI, "VERTICAL")

T.createcheckbutton(RaidToolOptions, 30, 60, L["1-5队"], "RaidToolOptions", "onlyactive")
T.createslider(RaidToolOptions, 30, 110, L["倒数时长"], "RaidToolOptions", "pulltime", 1, 3, 20, 1, L["需要启用DBM"])
T.createcheckbutton(RaidToolOptions, 30, 150, L["药水通报"], "RaidToolOptions", "potion")
T.createmultilinebox(RaidToolOptions, 200, 60, 35, 205, L["药水通报过滤"], "RaidToolOptions", "potionblacklist", L["药水通报过滤提示"])

--====================================================--
--[[              -- Other Options --                ]]--
--====================================================--
local OtherOptions = CreateOptionPage("Other Options", OTHER, GUI, "VERTICAL")

local style_group = {
	[1] = L["透明样式"],
	[2] = L["深色样式"],
	[3] = L["普通样式"],
}
T.createradiobuttongroup(OtherOptions, 30, 70, L["界面风格"], "OtherOptions", "style", style_group)
OtherOptions.style:HookScript("OnShow", function(self)
	if aCoreCDB["OtherOptions"]["style"] == 3 then
		UFInnerframe.style.portrait:Disable()
		BlizzardOptionsPanel_Slider_Disable(UFInnerframe.style.portraitalpha)
	else
		UFInnerframe.style.portrait:Enable()
		BlizzardOptionsPanel_Slider_Enable(UFInnerframe.style.portraitalpha)
	end
end)
local stylebuttons = {OtherOptions.style:GetChildren()}
for i = 1, #stylebuttons do
	stylebuttons[i]:HookScript("OnClick", function(self)
		if aCoreCDB["OtherOptions"]["style"] == 3 then
			UFInnerframe.style.portrait:Disable()
			BlizzardOptionsPanel_Slider_Disable(UFInnerframe.style.portraitalpha)
		else
			UFInnerframe.style.portrait:Enable()
			BlizzardOptionsPanel_Slider_Enable(UFInnerframe.style.portraitalpha)
		end
	end)
end
T.createslider(OtherOptions, 30, 130, L["缩放按钮高度"], "OtherOptions", "minimapheight", 1, 100, 300, 5, L["缩放按钮高度提示"])
T.createslider(OtherOptions, 30, 170, L["系统菜单尺寸"], "OtherOptions", "micromenuscale", 100, 50, 200, 5)
T.createslider(OtherOptions, 30, 210, L["信息条尺寸"], "OtherOptions", "infobarscale", 100, 50, 200, 5)
T.createcheckbutton(OtherOptions, 30, 250, L["整理小地图图标"], "OtherOptions", "collectminimapbuttons")
T.createcheckbutton(OtherOptions, 300, 250, L["整理隐藏的小地图图标"], "OtherOptions", "collecthidingminimapbuttons")
local MBCFpos_group = {
	["TOP"] = L["上方"],
	["BOTTOM"] = L["下方"],
}
T.createradiobuttongroup(OtherOptions, 30, 280, L["整理栏位置"], "OtherOptions", "MBCFpos", MBCFpos_group)
T.createDR(OtherOptions.collectminimapbuttons, OtherOptions.MBCFpos, OtherOptions.collecthidingminimapbuttons)

OtherOptions.DividingLine = OtherOptions:CreateTexture(nil, "ARTWORK")
OtherOptions.DividingLine:SetSize(OtherOptions:GetWidth()-50, 1)
OtherOptions.DividingLine:SetPoint("TOP", 0, -315)
OtherOptions.DividingLine:SetTexture(1, 1, 1, .2)

T.createcheckbutton(OtherOptions, 30, 330, L["隐藏错误提示"], "OtherOptions", "hideerrors", L["隐藏错误提示提示"])	
T.createcheckbutton(OtherOptions, 300, 330, L["成就截图"], "OtherOptions", "autoscreenshot", L["成就截图提示"])
T.createcheckbutton(OtherOptions, 30, 360, L["回收内存"], "OtherOptions", "collectgarbage", L["回收内存提示"])
T.createcheckbutton(OtherOptions, 300, 360, L["最远镜头"], "OtherOptions", "camera", L["最远镜头提示"])
T.createcheckbutton(OtherOptions, 30, 390, L["自动接受复活"], "OtherOptions", "acceptres", L["自动接受复活提示"])	
T.createcheckbutton(OtherOptions, 300, 390, L["战场自动释放灵魂"], "OtherOptions", "battlegroundres", L["战场自动释放灵魂提示"])
T.createcheckbutton(OtherOptions, 30, 420, L["自动交接任务"], "OtherOptions", "autoquests", L["自动交接任务提示"])
T.createcheckbutton(OtherOptions, 300, 420, L["大喊被闷了"], "OtherOptions", "saysapped", L["大喊被闷了提示"])

--====================================================--
--[[               -- Skin Options --               ]]--
--====================================================--
local SkinOptions = CreateOptionPage("Skin Options", L["插件皮肤"], GUI, "VERTICAL")

T.createcheckbutton(SkinOptions, 30, 60, "ClassColor", "SkinOptions", "setClassColor", L["更改设置提示"])
T.createcheckbutton(SkinOptions, 30, 90, "DBM", "SkinOptions", "setDBM", L["更改设置提示"])
T.createcheckbutton(SkinOptions, 30, 120, "Skada", "SkinOptions", "setSkada", L["更改设置提示"])
T.createcheckbutton(SkinOptions, 30, 150, "Numeration", "SkinOptions", "setNumeration", L["更改设置提示"])
T.createcheckbutton(SkinOptions, 30, 180, "Recount", "SkinOptions", "setRecount")
T.createcheckbutton(SkinOptions, 30, 210, L["更改设置"], "SkinOptions", "editsettingsbu")

--====================================================--
--[[               -- Commands --               ]]--
--====================================================--
local Comands = CreateOptionPage("Comands", L["命令"], GUI, "VERTICAL")

Comands.text = T.createtext(Comands, "OVERLAY", 13, "OUTLINE", "LEFT")
Comands.text:SetPoint("TOPLEFT", 30, -60)
Comands.text:SetText(format(L["指令"], G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor))

--====================================================--
--[[               -- Credits --               ]]--
--====================================================--
local Credits = CreateOptionPage("Credits", L["制作"], GUI, "VERTICAL")

Credits.text = T.createtext(Credits, "OVERLAY", 13, "OUTLINE", "CENTER")
Credits.text:SetPoint("CENTER")
Credits.text:SetText(format(L["制作说明"], G.Version, G.classcolor, "fgprodigal susnow Zork Haste Tukz Haleth Qulight Freebaser Monolit warbaby"))

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
	CreateRaidDebuffOptions()
	CreateCooldownAuraOptions()
	if aCoreCDB["SkinOptions"]["editsettingsbu"] then
		T.ResetAllAddonSettings()
		aCoreCDB["SkinOptions"]["editsettingsbu"] = false
	end
end
--[[
local GUIbutton = CreateFrame("Button", G.uiname.."GUI MenuButton", GameMenuFrame, "GameMenuButtonTemplate")
GUIbutton:SetSize(GameMenuButtonMacros:GetWidth(), GameMenuButtonMacros:GetHeight())
GUIbutton:SetPoint("BOTTOM", GameMenuButtonHelp, "TOP", 0, -1)
GUIbutton:SetText("Altz UI")
F.Reskin(GUIbutton)
GameMenuButtonLogout:ClearAllPoints()
GameMenuButtonLogout:SetPoint("TOP", GUIbutton, "BOTTOM", 0, -20)
GameMenuFrame:SetHeight(GUIbutton:GetHeight()+GameMenuButtonMacros:GetHeight()+20)

GUIbutton:SetScript("OnClick", function()
	HideUIPanel(GameMenuFrame)
	_G["AltzUI_GUI Main Frame"]:Show()
end)

]]--
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