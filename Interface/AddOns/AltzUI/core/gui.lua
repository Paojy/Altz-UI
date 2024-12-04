local T, C, L, G = unpack(select(2, ...))

local function CreateDividingLine(frame, y, width)
	local tex = frame:CreateTexture(nil, "ARTWORK")
	tex:SetSize(width or frame:GetWidth()-50, 1)
	tex:SetPoint("TOP", frame, "TOP", 0, y)
	tex:SetColorTexture(1, 1, 1, .2)
	
	return tex
end
--====================================================--
--[[             -- GUI Main Frame --               ]]--
--====================================================--
local GUI = CreateFrame("Frame", G.uiname.."GUI Main Frame", UIParent)
GUI:SetSize(650, 550)
GUI:SetPoint("TOPRIGHT", UIParent, "CENTER", 300, 300)
GUI:SetFrameStrata("MEDIUM")
GUI:SetFrameLevel(2)
GUI:Hide()

T.setStripBD(GUI)

-- 移动
GUI:SetClampedToScreen(true)
GUI:SetMovable(true)

GUI.df = CreateFrame("Frame", G.uiname.."_GUIDragFrame", UIParent)
GUI.df:SetAllPoints(GUI)
GUI.df:EnableMouse(true)
GUI.df:RegisterForDrag("LeftButton")
GUI.df:SetClampedToScreen(true)
GUI.df:Hide()

GUI.df:SetScript("OnDragStart", function(self)
	GUI:StartMoving()
	GUI.scale:Hide()
	self.x, self.y = GUI:GetCenter() -- 开始的位置
end)

GUI.df:SetScript("OnDragStop", function(self) 
	GUI:StopMovingOrSizing()
	local x, y = GUI:GetCenter() -- 结束的位置
	local x1, y1 = ("%d"):format(x - self.x), ("%d"):format(y -self.y)
	aCoreCDB["SkinOptions"]["gui_x"] = aCoreCDB["SkinOptions"]["gui_x"] + x1
	aCoreCDB["SkinOptions"]["gui_y"] = aCoreCDB["SkinOptions"]["gui_y"] + y1
	local scale = aCoreCDB["SkinOptions"]["gui_scale"]/100
	GUI:ClearAllPoints()
	GUI:SetPoint("TOPRIGHT", UIParent, "CENTER", aCoreCDB["SkinOptions"]["gui_x"]/scale, aCoreCDB["SkinOptions"]["gui_y"]/scale)
	GUI.scale:Show()
	GUI.scale.pointself()
end)

-- 控制台尺寸
GUI.scale = T.SliderWithValueText(UIParent, "GUIScale", 100, nil, 50, 120, 5, T.split_words(L["控制台"],L["尺寸"]))
GUI.scale:SetFrameLevel(20)
GUI.scale:SetFrameStrata("HIGH")
GUI.scale:SetMovable(true)
GUI.scale:SetClampedToScreen(true)
GUI.scale:Hide()

GUI.scale:SetScript("OnShow", function(self)
	self:SetValue((aCoreCDB["SkinOptions"]["gui_scale"]))
	self.Text:SetText(T.color_text(aCoreCDB["SkinOptions"]["gui_scale"]))
end)

GUI.scale:SetScript("OnValueChanged", function(self, getvalue)
	aCoreCDB["SkinOptions"]["gui_scale"] = getvalue
	self.Text:SetText(T.color_text(aCoreCDB["SkinOptions"]["gui_scale"]))
	
	local scale = aCoreCDB["SkinOptions"]["gui_scale"]/100
	GUI:ClearAllPoints()
	GUI:SetPoint("TOPRIGHT", UIParent, "CENTER", aCoreCDB["SkinOptions"]["gui_x"]/scale, aCoreCDB["SkinOptions"]["gui_y"]/scale)
	GUI:SetScale(scale)
end)
	
GUI.scale.pointself = function()
	local scale = aCoreCDB["SkinOptions"]["gui_scale"]/100
	--GUI.scale:SetClampRectInsets(-650*scale+160, 0, 0, -550*scale+20)	
	GUI.scale:ClearAllPoints()
	GUI.scale:SetPoint("TOPRIGHT", UIParent, "CENTER", aCoreCDB["SkinOptions"]["gui_x"]-15, aCoreCDB["SkinOptions"]["gui_y"]-5)	
end

GUI.scale:SetScript("OnMouseUp", GUI.scale.pointself)

-- 标题
GUI.title = T.createtext(GUI, "OVERLAY", 20, "OUTLINE", "CENTER")
GUI.title:SetPoint("TOP", GUI, "TOP", 0, 8)
GUI.title:SetText(T.color_text("AltzUI "..G.Version))

-- 输入框和按钮
GUI.EditFrameBG = CreateFrame("Frame", nil, GUI)
GUI.EditFrameBG:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", 0, -3)
GUI.EditFrameBG:SetPoint("TOPRIGHT", GUI, "BOTTOMRIGHT", 0, -3)
GUI.EditFrameBG:SetHeight(40)
GUI.EditFrameBG:Hide()
T.setStripBD(GUI.EditFrameBG)

GUI.editframe = T.EditFrame(GUI.EditFrameBG, 450, L["复制粘贴"], {"TOPLEFT", 5, -10})
GUI.editframe.box:ClearAllPoints()
GUI.editframe.box:SetPoint("LEFT", GUI.editframe, "LEFT", 180, 0)

GUI.editframe.box:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
GUI.editframe.box:SetScript("OnEditFocusLost", function(self) self:HighlightText(0,0) end)
GUI.editframe.box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

local function ToggleGUIEditBox(t, text, highlight_text, show_button, func)
	if GUI.editframe.type ~= t then
		GUI.editframe.box.button:SetShown(show_button)
		GUI.editframe.box:SetScript("OnEnterPressed", func)
		GUI.editframe.box:SetText(text)
		if highlight_text then
			GUI.editframe.box:HighlightText()
		end
		GUI.editframe.type = t	
		GUI.EditFrameBG:Show()
		GUI.editframe.box:SetFocus()
	else
		GUI.EditFrameBG:Hide()
		GUI.editframe.type = nil
	end
end

GUI.GitHub = T.ClickTexButton(GUI, {"BOTTOMLEFT", GUI, "BOTTOMLEFT", 5, 0}, G.iconFile.."GitHub.tga", "GitHub")
GUI.GitHub:SetScript("OnClick", function()
	ToggleGUIEditBox("GitHub", G.links["GitHub"], true, false)
end)

GUI.wowi = T.ClickTexButton(GUI, {"LEFT", GUI.GitHub, "RIGHT", 2, 0}, G.iconFile.."doc.tga", "WoWInterface", 20)
GUI.wowi:SetScript("OnClick", function()
	ToggleGUIEditBox("WoWInterface", G.links["WoWInterface"], true, false)
end)

GUI.curse = T.ClickTexButton(GUI, {"LEFT", GUI.wowi, "RIGHT", 2, 0}, G.iconFile.."fire.tga", "Curse", 20)
GUI.curse:SetScript("OnClick", function()
	ToggleGUIEditBox("Curse", G.links["Curse"], true, false)
end)

GUI.export = T.ClickTexButton(GUI, {"LEFT", GUI.curse, "RIGHT", 2, 0}, G.textureFile.."arrow.tga", L["导出"], 20)
GUI.export:SetScript("OnClick", function()	
	ToggleGUIEditBox("export", T.ExportSettings(), true, false)
end)
T.SetupArrow(GUI.export.tex, "down")
T.SetupArrow(GUI.export.hl_tex, "down")

GUI.import = T.ClickTexButton(GUI, {"LEFT", GUI.export, "RIGHT", 2, 0}, G.textureFile.."arrow.tga", L["导入"], 20)
GUI.import:SetScript("OnClick", function()
	ToggleGUIEditBox("import", "", false, true, function() T.ImportSettings(GUI.editframe.box:GetText()) end)
end)
T.SetupArrow(GUI.import.tex, "up")
T.SetupArrow(GUI.import.hl_tex, "up")

GUI.reset = T.ClickTexButton(GUI, {"LEFT", GUI.import, "RIGHT", 2, 0}, G.iconFile.."refresh.tga", L["重置"])
GUI.reset:SetScript("OnClick", function()
	GUI.EditFrameBG:Hide()
	GUI.editframe.type = nil
	
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text("Altz UI"))
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		aCoreCDB = {}
		T.LoadVariables()
		ReloadUI()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

GUI.reload = T.ClickTexButton(GUI, {"LEFT", GUI.reset, "RIGHT", 2, 0}, G.iconFile.."save.tga", RELOADUI, 20)
GUI.reload:SetScript("OnClick", ReloadUI)

GUI.unlock = T.ClickTexButton(GUI, {"LEFT", GUI.reload, "RIGHT", 2, 0}, G.iconFile.."lock.tga", HUD_EDIT_MODE_MENU, 20)
GUI.unlock:SetScript("OnClick", function()
	ShowUIPanel(EditModeManagerFrame)
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI.close = T.ClickTexButton(GUI, {"BOTTOMRIGHT", GUI, "BOTTOMRIGHT", -5, 0}, G.iconFile.."exit.tga", nil, 20)
GUI.close:SetScript("OnClick", function()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI:HookScript("OnHide", function()
	StaticPopup_Hide(G.uiname.."Import Confirm")
	StaticPopup_Hide(G.uiname.."Reset Confirm")
	GUI.EditFrameBG:Hide()
	GUI.editframe.type = nil
end)

--====================================================--
--[[                   -- TABS --                   ]]--
--====================================================--
local function CreateOptionPage(name, title, parent, orientation)	
	local frame = CreateFrame("Frame", G.uiname..name, parent)
	frame:SetAllPoints(parent)
	frame:Hide()

	if not parent.tabs then
		parent.tabs = {}
		parent:HookScript("OnShow", function(self)
			if not self.tab_selected then
				self.tabs[1]:GetScript("OnMouseDown")()
				self.tab_selected = true
			end
		end)
	end
	
	local tab = CreateFrame("Frame", nil, parent)
	tab:SetFrameLevel(parent:GetFrameLevel()+2)
	tab:EnableMouse(true)
	
	if parent == GUI then	
		T.setStripBD(tab)
		function tab:Glow()
			tab.bd:SetBackdropBorderColor(unpack(G.addon_color))
			tab.pxbd:SetBackdropBorderColor(unpack(G.addon_color))
		end
		function tab:Fade()
			tab.bd:SetBackdropBorderColor(0, 0, 0, .5)
			tab.pxbd:SetBackdropBorderColor(0, 0, 0, .5)
		end
	else
		tab.bd = T.createBackdrop(tab, 0)
		tab.pxbd = T.createPXBackdrop(tab, 0)
		function tab:Glow()
			tab.bd:SetBackdropBorderColor(unpack(G.addon_color))
			tab.pxbd:SetBackdropBorderColor(unpack(G.addon_color))
		end
		function tab:Fade()
			tab.bd:SetBackdropBorderColor(0, 0, 0, .5)
			tab.pxbd:SetBackdropBorderColor(0, 0, 0, .5)
		end
	end
	
	tab.text = T.createtext(tab, "OVERLAY", 14, "OUTLINE", "LEFT")
	tab.text:SetText(title)
	
	table.insert(parent.tabs, tab)
	
	tab.owner = frame
	tab.index = #parent.tabs	
	frame.hooked_tab = tab
	
	if orientation == "VERTICAL" then	
		tab:SetSize(130, 25)
		tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 4, -35*tab.index)
		
		tab.text:SetJustifyH("LEFT")
		tab.text:SetPoint("LEFT", 14, 0)
		
		tab:SetScript("OnMouseDown", function()
			for i, t in pairs(parent.tabs) do
				if t == tab then
					t.owner:Show()
					t:SetPoint("TOPLEFT", parent, "TOPRIGHT", 8, -35*tab.index)
					t:Glow()
				else
					t.owner:Hide()
					t:SetPoint("TOPLEFT", parent, "TOPRIGHT", 4,  -35*t.index)
					t:Fade()
				end
			end
		end)
	else
		tab:SetSize(tab.text:GetWidth()+10, 20)
		if tab.index == 1 then
			tab:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 15, 2)
		else
			tab:SetPoint("LEFT", parent.tabs[tab.index-1], "RIGHT", 4, 0)
		end
		
		tab.text:SetJustifyH("CENTER")
		tab.text:SetPoint("CENTER")
		
		tab:SetScript("OnMouseDown", function()
			for i, t in pairs(parent.tabs) do
				if t == tab then
					t.owner:Show()
					t:Glow()
				else
					t.owner:Hide()
					t:Fade()
				end
			end
		end)
	end

	return frame
end

local function CreateInnerFrame(parent)
	local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	frame:SetPoint("TOPLEFT", 40, -50)
	frame:SetPoint("BOTTOMLEFT", -20, 25)
	frame:SetWidth(parent:GetWidth()-200)
	
	T.setPXBackdrop(frame, .2)
	frame:SetBackdropBorderColor(1, 1, 1)
	
	return frame
end

--====================================================--
--[[            -- Interface Options --            ]]--
--====================================================--
local SkinOptions = CreateOptionPage("Interface Options", L["界面"], GUI, "VERTICAL")
local SInnerframe = CreateInnerFrame(SkinOptions)

-- 界面风格
SInnerframe.theme = CreateOptionPage("Interface Options theme", L["界面风格"], SInnerframe, "VERTICAL")
T.CreateGUIOpitons(SInnerframe.theme, "SkinOptions", 1, 8)

local function CreateApplySettingButton(text, addon, y, func)
	local Button = T.ClickButton(SInnerframe.theme, 200, nil, {"TOPLEFT", 20, y}, text, nil, string.format(L["更改设置提示"], addon))
	Button:SetScript("OnClick", func)
end

local SetClassColorButton = CreateApplySettingButton(T.split_words(L["重置"],L["职业颜色"]), "ClassColors", -220, function()
	if C_AddOns.IsAddOnLoaded("!ClassColors") then
		StaticPopupDialogs[G.uiname.."Reset Confirm2"].text = string.format(L["重置确认"], T.color_text(L["职业颜色"]))
		StaticPopupDialogs[G.uiname.."Reset Confirm2"].button1 = T.split_words(L["鲜明"],L["职业颜色"])
		StaticPopupDialogs[G.uiname.."Reset Confirm2"].OnAccept = function()
			T.ResetClasscolors()
			ReloadUI()
		end
		StaticPopupDialogs[G.uiname.."Reset Confirm2"].button2 = T.split_words(L["原生"],L["职业颜色"])
		StaticPopupDialogs[G.uiname.."Reset Confirm2"].OnCancel = function()
			table.wipe(ClassColorsDB)
			ReloadUI()
		end
		StaticPopupDialogs[G.uiname.."Reset Confirm2"].OnAlt = function(self)
			self:Hide()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm2")
	else
		StaticPopupDialogs[G.uiname.."need addon"].text = string.format(L["未加载插件"], "ClassColors")
		StaticPopup_Show(G.uiname.."need addon")
	end
end)

local SetBWButton = CreateApplySettingButton(T.split_words(L["重置"],L["BW计时条皮肤"]), "BigWigs", -250, function()
	if C_AddOns.IsAddOnLoaded("BigWigs") then	
		T.ResetBW()
	else
		StaticPopupDialogs[G.uiname.."need addon"].text = string.format(L["未加载插件"], "BigWigs")
		StaticPopup_Show(G.uiname.."need addon")
	end
end)

-- 界面布局
SInnerframe.layout = CreateOptionPage("Interface Options Layout", L["界面布局"], SInnerframe, "VERTICAL")
T.CreateGUIOpitons(SInnerframe.layout, "SkinOptions", 9)

local ResetLayoutButton = T.ClickButton(SInnerframe.layout, 200, nil, {"TOPLEFT", 20, -240}, HUD_EDIT_MODE_RESET_POSITION)
ResetLayoutButton:SetScript("OnClick", function()
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(T.split_words(L["界面布局"], L["位置"])))
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		T.ResetEditModeLayout()
		T.ResetAllFramesPoint()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

--====================================================--
--[[              -- Chat Options --                ]]--
--====================================================--
local ChatOptions = CreateOptionPage("Chat Options", SOCIAL_LABEL, GUI, "VERTICAL")
T.CreateGUIOpitons(ChatOptions, "ChatOptions")

--====================================================--
--[[          -- Bag and Items Options --           ]]--
--====================================================--
local ItemOptions = CreateOptionPage("Item Options", ITEMS, GUI, "VERTICAL")
T.CreateGUIOpitons(ItemOptions, "ItemOptions")

ItemOptions.autobuy_list = T.CreateItemListOption(ItemOptions, {"TOPLEFT", 20, -260}, 220,
L["自动购买"]..L["设置"], {"ItemOptions", "autobuylist"}, L["物品数量"])

do
	local ShouldShow = function()
		if aCoreCDB.ItemOptions.autobuy then
			return true
		end
	end
	
	T.createVisibleDR(ShouldShow, ItemOptions.autobuy, ItemOptions.autobuy_list)
end
--====================================================--
--[[               -- Unit Frames --                ]]--
--====================================================--
local UFOptions = CreateOptionPage("UF Options", L["单位框架"], GUI, "VERTICAL")
local UFInnerframe = CreateInnerFrame(UFOptions)

-- 样式
UFInnerframe.style = CreateOptionPage("UF Options style", L["样式"], UFInnerframe, "VERTICAL")
T.CreateGUIOpitons(UFInnerframe.style, "UnitframeOptions", 1, 14)

-- 施法条
UFInnerframe.castbar = CreateOptionPage("UF Options castbar", L["施法条"], UFInnerframe, "VERTICAL")
T.CreateGUIOpitons(UFInnerframe.castbar, "UnitframeOptions", 27, 31)
T.CreateGUIOpitons(UFInnerframe.castbar, "UnitframeOptions", 42, 43)

-- 光环
UFInnerframe.aura = CreateOptionPage("UF Options aura", AURAS, UFInnerframe, "VERTICAL")
T.CreateGUIOpitons(UFInnerframe.aura, "UnitframeOptions", 47, 52)

UFInnerframe.aura.aurafliter_list = T.CreateAuraListOption(UFInnerframe.aura, {"TOPLEFT", 20, -180}, 230,
L["白名单"]..AURAS, {"UnitframeOptions", "AuraFilterwhitelist"})
UFInnerframe.aura.aurafliter_list.apply = function()
	T.ApplyUFSettings({"Auras"})
end
--====================================================--
--[[               -- Raid Frames --                ]]--
--====================================================--
local RFOptions = CreateOptionPage("RF Options", L["团队框架"], GUI, "VERTICAL")
local RFInnerframe = CreateInnerFrame(RFOptions)

-- 样式
RFInnerframe.style = CreateOptionPage("RF Options style", L["样式"], RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.style, "UnitframeOptions", 59, 72)

-- 治疗指示器
RFInnerframe.ind = CreateOptionPage("RF Options indicators", L["治疗指示器"], RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.ind, "UnitframeOptions", 81, 84)

RFInnerframe.ind.hotind_list = T.CreateAuraListOption(RFInnerframe.ind, {"TOPLEFT", 20, -140}, 270,
T.split_words(L["图标指示器"],AURAS), {"UnitframeOptions", "hotind_auralist"}, nil, {"UnitframeOptions", "hotind_filtertype"})
RFInnerframe.ind.hotind_list.apply = function()
	T.ApplyUFSettings({"Auras"}, "Altz_Healerraid")
end

do
	local ShouldShow = function()
		if aCoreCDB.UnitframeOptions.hotind_style == "icon_ind" then
			return true
		end
	end
	
	T.createVisibleDR(ShouldShow, RFInnerframe.ind.hotind_style, RFInnerframe.ind.hotind_list)
end

-- 点击施法
RFInnerframe.clickcast = CreateOptionPage("RF Options clickcast", L["点击施法"], RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.clickcast, "UnitframeOptions", 86, 87)

RFInnerframe.clickcast.reset = T.ClickTexButton(RFInnerframe.clickcast, {"TOPLEFT", RFInnerframe.clickcast, "TOPLEFT", 100, -18}, G.iconFile.."refresh.tga", L["重置"])	
RFInnerframe.clickcast.reset:SetScript("OnClick", function(self)
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(L["点击施法"]))
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		aCoreCDB["UnitframeOptions"]["ClickCast"] = nil
		ReloadUI()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

local clickcastframe = CreateFrame("Frame", G.uiname.."ClickCast Options", RFInnerframe.clickcast, "BackdropTemplate")
clickcastframe:SetPoint("TOPLEFT", 20, -105)
clickcastframe:SetPoint("TOPRIGHT", -30, -105)
clickcastframe:SetHeight(185)
T.setBackdrop(clickcastframe, 0)
G.ClickcastOptions = clickcastframe

-- 当前天赋
local cur_spec = T.createtext(clickcastframe, "OVERLAY", 12, "OUTLINE", "LEFT")
cur_spec:SetPoint("LEFT", RFInnerframe.clickcast.enableClickCast.Text, "RIGHT", 5, 0)

clickcastframe:SetScript("OnShow", function()
	local specID = T.GetSpecID()
	if specID == "nospec" then
		cur_spec:SetText(string.format("%s: %s", L["当前设置"], T.split_words(NONE,SPECIALIZATION)))
	else
		local _, name, _, icon = GetSpecializationInfoByID(specID)
		cur_spec:SetText(string.format("%s: %s%s", L["当前设置"], T.GetTexStr(icon), name))
	end
end)

local click_buttons = {
	{"1", L["Button1"]}, 
	{"2", L["Button2"]},
	{"3", L["Button3"]}, 
	{"4", L["Button4"]}, 
	{"5", L["Button5"]}, 
	{"MouseUp", L["MouseUp"]}, 
	{"MouseDown", L["MouseDown"]},
}

local actions = {
	{"target", TARGET},
	{"focus", FOCUSTARGET},
	{"spell", SPELLS},
	{"item", ITEMS},
	{"follow", FOLLOW},	
	{"menu", L["打开菜单"]},
	{"macro", MACRO},
	{"NONE", NONE},
}

local function GetClickcastValue(bu_tag, mod_ind, key)
	local arg1, arg2, value
	if bu_tag == "MouseUp" then
		arg1 = tostring(5+mod_ind)
		arg2 = "Click"
	elseif bu_tag == "MouseDown" then
		arg1 = tostring(9+mod_ind)
		arg2 = "Click"
	else
		arg1 = tostring(bu_tag)
		arg2 = G.modifier[mod_ind]
	end
	local specID = T.GetSpecID()
	value = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][arg1][arg2][key]
	return value
end

local function ApplyClickcastValue(bu_tag, mod_ind, key, value)
	local arg1, arg2
	if bu_tag == "MouseUp" then
		arg1 = tostring(5+mod_ind)
		arg2 = "Click"
	elseif bu_tag == "MouseDown" then
		arg1 = tostring(9+mod_ind)
		arg2 = "Click"
	else
		arg1 = bu_tag
		arg2 = G.modifier[mod_ind]
	end
	local specID = T.GetSpecID()
	aCoreCDB["UnitframeOptions"]["ClickCast"][specID][arg1][arg2][key] = value
end

local function UpdateClickCast(bu_tag, mod_ind)
	local id, key
	if bu_tag == "MouseUp" then
		id = tostring(5+mod_ind)
		key = "Click"
	elseif bu_tag == "MouseDown" then
		id = tostring(9+mod_ind)
		key = "Click"
	else
		id = bu_tag
		key = G.modifier[mod_ind]
	end
	T.UpdateClicksforAll(id, key)
end

local function CreateMacroEditBox(macro_input, frame, bu_tag, mod_ind)
	macro_input.expand_bu = T.ClickTexButton(macro_input, {"LEFT", macro_input, "RIGHT", 0, 0}, G.iconFile.."doc.tga", nil, 20, EDIT)		
	
	local macro_box = T.EditboxMultiLine(macro_input, 360, 140)
	macro_box.bg:SetBackdropColor(0, 0, 0, 1)
	macro_box:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	macro_box:Hide()
	
	macro_box.edit:SetMaxLetters(255)
	macro_box.edit:HookScript("OnChar", function(self)
		macro_box.bottom_text:SetText(format(MACROFRAME_CHAR_LIMIT, self:GetNumLetters()))
	end)
	
	macro_box.edit:SetScript("OnShow", function(self)
		local macroText = GetClickcastValue(bu_tag, mod_ind, "macro")
		self:SetText(macroText)
	end)

	macro_box.button1:SetScript("OnClick", function()
		macro_box.edit:ClearFocus()
		local macroText = macro_box.edit:GetText()
		if macroText then
			ApplyClickcastValue(bu_tag, mod_ind, "macro", macroText)
			UpdateClickCast(bu_tag, mod_ind)
		end
		macro_box:Hide()
		macro_input:GetScript("OnShow")(macro_input)
	end)
	
	macro_box.button2:SetScript("OnClick", function()
		macro_box.edit:ClearFocus()
		macro_box:Hide()
	end)
	
	macro_input.expand_macro_box = macro_box
	
	macro_input.expand_bu:SetScript("OnClick", function()
		macro_box:UpdateScrollChildRect()
		macro_box:Show()
	end)
end

local function CreateClickcastKeyOptions(bu_tag, text)
	local frame = CreateOptionPage("ClickCast Button"..bu_tag, text, clickcastframe, "HORIZONTAL")
	frame.options = {}
	
	for mod_ind, mod_name in pairs(G.modifier) do
		frame.options[mod_ind] = {}
		
		local mod_text = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
		mod_text:SetPoint("TOPLEFT", 25, 10-mod_ind*35)
		mod_text:SetText(mod_name)
		mod_text:SetWidth(40)
		frame.options[mod_ind].mod_text = mod_text
		
		-- 动作
		local action_select = T.SetupDropdown(frame, 100, {"LEFT", mod_text, "RIGHT", -5, 0})
	
		UIDropDownMenu_Initialize(action_select.DropDown, function()
			for i, t in pairs(actions) do
				local info = UIDropDownMenu_CreateInfo()
				info.value = t[1]
				info.text = t[2]
				info.func = function()
					UIDropDownMenu_SetSelectedValue(action_select.DropDown, info.value)
					action_select:SetText(info.text)
					ApplyClickcastValue(bu_tag, mod_ind, "action", info.value)					
					UpdateClickCast(bu_tag, mod_ind)
					frame.options[mod_ind].spell_select:SetShown(info.value == "spell")
					frame.options[mod_ind].item_input:SetShown(info.value == "item")
					frame.options[mod_ind].macro_input:SetShown(info.value == "macro")
				end
				UIDropDownMenu_AddButton(info)
			end
		end, "MENU")
		
		action_select:SetScript("OnShow", function(self)
			local action = GetClickcastValue(bu_tag, mod_ind, "action")			
			UIDropDownMenu_SetSelectedValue(self.DropDown, action)
			for i, t in pairs(actions) do
				if action == t[1] then
					self:SetText(t[2])
				end
			end
		end)
		
		frame.options[mod_ind].action_select = action_select
		
		-- 法术
		local spell_select = T.SetupDropdown(frame, 130, {"LEFT", action_select, "RIGHT", 20, 0})

		UIDropDownMenu_Initialize(spell_select.DropDown, function()
			local spells = {}
			for tag, info in pairs(G.ClickCastSpells) do
				local cur_spec = T.GetSpecID()
				if tag == "class" or tag == cur_spec then
					for i, spellID in pairs(info) do
						table.insert(spells, spellID)
					end
				end
			end
			if #spells > 0 then
				for i, spellID in pairs(spells) do
					local spellName, spellIcon = T.GetSpellInfo(spellID)
					local info = UIDropDownMenu_CreateInfo()
					info.value = spellID
					info.text = T.GetSpellIcon(spellID).." "..spellName
					info.func = function()
						UIDropDownMenu_SetSelectedValue(spell_select.DropDown, info.value)
						spell_select:SetText(info.text)
						ApplyClickcastValue(bu_tag, mod_ind, "spell", info.value)
						UpdateClickCast(bu_tag, mod_ind)
					end
					UIDropDownMenu_AddButton(info)
				end
			end
		end)
		
		spell_select:SetScript("OnShow", function(self)
			local spellID = GetClickcastValue(bu_tag, mod_ind, "spell")
			if spellID == "" then
				self:SetText(NONE)
			else
				UIDropDownMenu_SetSelectedValue(self.DropDown, spellID)
				local name, icon = T.GetSpellInfo(spellID)
				self:SetText(T.GetTexStr(icon).." "..name)
			end
		end)
		
		frame.options[mod_ind].spell_select = spell_select
		
		-- 物品
		local item_input = T.EditboxWithStr(frame, {"LEFT", action_select, "RIGHT", -14, 2}, L["物品名称ID链接"], 140, true)
		
		item_input:SetScript("OnShow", function(self)
			local itemName = GetClickcastValue(bu_tag, mod_ind, "item")
			self:SetText(itemName)
		end)
		
		function item_input:apply()
			local itemText = self:GetText()
			local itemID = GetItemInfoInstant(itemText)
			if itemID then
				local itemName = GetItemInfo(itemID)
				self:SetText(itemName)
				ApplyClickcastValue(bu_tag, mod_ind, "item", itemName)
				UpdateClickCast(bu_tag, mod_ind)
			else
				StaticPopupDialogs[G.uiname.."incorrect itemID"].text = T.color_text((itemText == L["物品名称ID链接"] and "") or itemText)..L["不正确的物品ID"]
				StaticPopup_Show(G.uiname.."incorrect itemID")
				self:SetText(L["物品名称ID链接"])
			end
		end
		
		frame.options[mod_ind].item_input = item_input
		
		-- 宏
		local macro_input = T.EditboxWithStr(frame, {"LEFT", action_select, "RIGHT", -14, 2}, L["输入一个宏"], 140)
		CreateMacroEditBox(macro_input, frame, bu_tag, mod_ind)
		
		macro_input:SetScript("OnShow", function(self)
			local macroText = GetClickcastValue(bu_tag, mod_ind, "macro")
			if string.find(macroText, "\n") then
				self:SetText("......")
				self:Disable()
			else
				self:SetText(macroText)
				if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
					self:Enable()
				else
					self:Disable()
				end
			end
		end)
		
		macro_input:SetScript("OnHide", function(self)
			self.expand_macro_box:Hide()
		end)
		
		function macro_input:apply()
			local macroText = self:GetText()
			if macroText then
				ApplyClickcastValue(bu_tag, mod_ind, "macro", macroText)
				UpdateClickCast(bu_tag, mod_ind)
			end
		end

		frame.options[mod_ind].macro_input = macro_input
	end
	
	frame:SetScript("OnShow", function()
		for mod_ind, _ in pairs(G.modifier) do
			local action = GetClickcastValue(bu_tag, mod_ind, "action")
			frame.options[mod_ind].spell_select:SetShown(action == "spell")
			frame.options[mod_ind].item_input:SetShown(action == "item")
			frame.options[mod_ind].macro_input:SetShown(action == "macro")
		end
	end)
	
	frame.Enable = function()
		for mod_ind, _ in pairs(G.modifier) do
			for key, option in pairs(frame.options[mod_ind]) do
				if string.find(key, "_text") then
					option:SetTextColor(1, 1, 1)
				elseif string.find(key, "_select") then
					UIDropDownMenu_EnableDropDown(option)
				else
					option:Enable()
				end
				if key == "macro_input" then
					option.expand_bu:Enable()
				end
			end
		end
	end
	
	frame.Disable = function()
		for mod_ind, _ in pairs(G.modifier) do
			for key, option in pairs(frame.options[mod_ind]) do
				if string.find(key, "_text") then
					option:SetTextColor(.5, .5, .5)
				elseif string.find(key, "_select") then
					UIDropDownMenu_DisableDropDown(option)
				else
					option:Disable()
				end
				if key == "macro_input" then
					option.expand_bu:Disable()
					option.expand_macro_box:Hide()
				end
			end
		end
	end
	
	table.insert(G.ClickcastOptions, frame)
	T.createDR(RFInnerframe.clickcast.enableClickCast, frame)
end

T.RegisterEnteringWorldCallback(function()
	for i, info in pairs(click_buttons) do
		CreateClickcastKeyOptions(unpack(info))
	end
end)

-- 光环图标
RFInnerframe.icon_display = CreateOptionPage("RF Options Icon Display", T.split_words(L["光环"],L["图标"]), RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.icon_display, "UnitframeOptions", 88, 100)

-- 团队减益
RFInnerframe.raiddebuff = CreateOptionPage("RF Options Raid Debuff", T.split_words(L["副本"],L["减益"]), RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.raiddebuff, "UnitframeOptions", 101, 101)

RFInnerframe.raiddebuff.debuff_list = T.createscrolllist(RFInnerframe.raiddebuff, {"TOPLEFT", 10, -85}, false, 395, 380)

local function UpdateEncounterTitle(option_list, i, encounterID, y)
	if not option_list.titles[i] then
		local frame = CreateFrame("Frame", nil, option_list.anchor)
		frame:SetSize(380, 16)
		
		frame.tex = frame:CreateTexture(nil, "ARTWORK")
		frame.tex:SetSize(60, 30)
		frame.tex:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
		
		frame.text = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
		frame.text:SetPoint("BOTTOMLEFT", frame.tex, "BOTTOMRIGHT", 0, 0)
		
		frame.line = frame:CreateTexture(nil, "ARTWORK")
		frame.line:SetSize(380, 1)
		frame.line:SetPoint("BOTTOM")
		frame.line:SetColorTexture(1, 1, 1)
		
		option_list.titles[i] = frame
	end
	
	local portrait = (encounterID == 1 and [[Interface\EncounterJournal\UI-EJ-BOSS-Default]]) or select(5, EJ_GetCreatureInfo(1, encounterID))
	local name = (encounterID == 1 and L["杂兵"]) or EJ_GetEncounterInfo(encounterID)
	
	local title = option_list.titles[i]
	title.tex:SetTexture(portrait)
	title.text:SetText(name)
	
	title:ClearAllPoints()
	title:SetPoint("TOPLEFT", option_list.anchor, "TOPLEFT", 20, y)
	title:Show()
end

local function UpdateEncounterAuraButton(option_list, encounterID, spellID, level, y)
	if not option_list.spells["icon"..encounterID.."_"..spellID] then
		local parent = RFInnerframe.raiddebuff
		local frame = T.createscrollbutton("spell", option_list, {"UnitframeOptions", "raid_debuffs", parent.selected_InstanceID, encounterID}, spellID)
		frame:SetWidth(380)
		
		frame:SetScript("OnMouseDown", function(self)	
			local encounterName = (encounterID == 1 and L["杂兵"]) or EJ_GetEncounterInfo(encounterID)
			UIDropDownMenu_SetSelectedValue(option_list.encounterDD.DropDown, encounterID)
			option_list.encounterDD:SetText(encounterName)
			option_list.spell_input:SetText(spellID)
			option_list.spell_input.current_spellID = spellID
			option_list.level_input:SetText(level)
		end)
		
		option_list.spells["icon"..encounterID.."_"..spellID] = frame
	end
	
	local spellName, spellIcon = T.GetSpellInfo(spellID)
	
	local bu = option_list.spells["icon"..encounterID.."_"..spellID]
	bu.display(spellIcon, spellName, spellID, level)
	
	bu:ClearAllPoints()
	bu:SetPoint("TOPLEFT", option_list.anchor, "TOPLEFT", 20, y)
	bu:Show()
end

local function DisplayRaidDebuffList()
	local parent = RFInnerframe.raiddebuff
	local option_list = RFInnerframe.raiddebuff.debuff_list
	
	option_list.encounters = table.wipe(option_list.encounters)
	
	local dataIndex = 1
	EJ_SelectInstance(parent.selected_InstanceID)
	local encounterID = select(3, EJ_GetEncounterInfoByIndex(dataIndex, parent.selected_InstanceID))
	while encounterID ~= nil do
		table.insert(option_list.encounters, encounterID)
		dataIndex = dataIndex + 1	
		encounterID = select(3, EJ_GetEncounterInfoByIndex(dataIndex, parent.selected_InstanceID))
	end
	table.insert(option_list.encounters, 1)
	
	for k, v in pairs(option_list.titles) do v:Hide() end	
	for k, v in pairs(option_list.spells) do v:Hide() end
	
	local y = -10
	for i, encounterID in pairs(option_list.encounters) do
		UpdateEncounterTitle(option_list, i, encounterID, y)
		y = y - 20
		if aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID] and aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID][encounterID] then
			for spellID, level in pairs (aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID][encounterID]) do
				UpdateEncounterAuraButton(option_list, encounterID, spellID, level, y)
				y = y - 25
			end
		end
		y = y - 15
	end
end

do
	local parent = RFInnerframe.raiddebuff 
	local option_list = RFInnerframe.raiddebuff.debuff_list
	option_list:Hide()
	
	option_list.encounters = {}
	option_list.titles = {}
	option_list.spells = {}
	option_list.lineuplist = DisplayRaidDebuffList
	option_list.apply = function()
		T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
	end
	
	-- 重置
	option_list.reset = T.ClickTexButton(option_list, {"TOPLEFT", parent, "TOPLEFT", 100, -18}, G.iconFile.."refresh.tga", L["重置"])	
	option_list.reset:SetScript("OnClick", function(self)
		local InstanceName = EJ_GetInstanceInfo(parent.selected_InstanceID)
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(InstanceName))
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID] = nil
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)
	
	-- 返回
	option_list.back = T.ClickTexButton(option_list, {"TOPRIGHT", parent, "TOPRIGHT", -30, -20}, G.iconFile.."refresh.tga", BACK)
	T.SetupArrow(option_list.back.tex, "left")
	T.SetupArrow(option_list.back.hl_tex, "left")
	
	option_list.back:SetScript("OnClick", function() 
		option_list:Hide()
		parent.instance_list:Show()
	end)
	
	-- 首领下拉菜单
	option_list.encounterDD = T.SetupDropdown(option_list, 120, {"BOTTOMLEFT", option_list, "TOPLEFT", 0, 2})
	
	-- 法术ID输入框
	option_list.spell_input = T.EditboxWithStr(option_list, {"LEFT", option_list.encounterDD, "RIGHT", -5, 0}, L["输入法术ID"], 100)
	option_list.spell_input:HookScript("OnChar", function(self) 
		self.current_spellID = nil
	end)
	function option_list.spell_input:apply()
		if self.current_spellID then
			return true
		else
			local spellText = self:GetText()		
			local spellName, spellIcon, _, spellID = T.GetSpellInfo(spellText)
			if spellName then
				self:SetText(spellName)
				self.current_spellID = spellID
				return true
			else
				StaticPopupDialogs[G.uiname.."incorrect spellID"].text = T.color_text((spellText == L["输入法术ID"] and "") or spellText)..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellID")
			end
		end
	end
	
	-- 优先级输入框
	option_list.level_input = T.EditboxWithStr(option_list, {"LEFT", option_list.spell_input, "RIGHT", 5, 0}, L["优先级"], 100)
	function option_list.level_input:apply()
		local level = self:GetText()
		if tonumber(level) then
			self:SetText(level)
			return true
		else
			StaticPopupDialogs[G.uiname.."incorrect number"].text = T.color_text(level)..L["必须是一个数字"]
			StaticPopup_Show(G.uiname.."incorrect number")
		end
	end
	
	-- 添加
	option_list.add = T.ClickButton(option_list, 0, 20, {"LEFT", option_list.level_input, "RIGHT", 5, 0}, ADD)
	option_list.add:SetScript("OnClick", function(self)
		option_list.spell_input:GetScript("OnEnterPressed")(option_list.spell_input)
		option_list.level_input:GetScript("OnEnterPressed")(option_list.level_input)
		if not option_list.spell_input:apply() or not option_list.level_input:apply() then return end
		
		local encounterID = UIDropDownMenu_GetSelectedValue(option_list.encounterDD.DropDown)
		local spellName, spellIcon, _, spellID = T.GetSpellInfo(option_list.spell_input.current_spellID)
		local level = option_list.level_input:GetText()
		
		if not aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID][encounterID] then
			aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID][encounterID] = {}
		end
		
		aCoreCDB["UnitframeOptions"]["raid_debuffs"][parent.selected_InstanceID][encounterID][spellID] = level		
		option_list.apply()
		DisplayRaidDebuffList()
		
		option_list.spell_input:SetText(L["输入法术ID"])
		option_list.spell_input.current_spellID = nil
		option_list.level_input:SetText(L["优先级"])
	end)
end

local CreateInstanceButton = function(frame, instanceID, instanceName, bgImage)
	local parent = RFInnerframe.raiddebuff
	local bu = T.ClickButton(frame.anchor, 150, 20, nil, instanceName, bgImage)
	
	bu:SetFrameLevel(frame.anchor:GetFrameLevel()+2)
	bu.tex:SetTexCoord(0, 1, .4, .6)
	bu.tex:SetAlpha(.3)
	
	if mod(frame.button_i, 2) == 1 then
		bu:SetPoint("TOPLEFT", frame.anchor, "TOPLEFT", 20+mod(frame.button_i+1, 2)*200, frame.y)
		frame.y = frame.y - 30
	else
		bu:SetPoint("TOPLEFT", frame.anchor, "TOPLEFT", 20+mod(frame.button_i+1, 2)*200, frame.y + 30)
	end
	
	bu:SetScript("OnMouseDown", function()
		parent.selected_InstanceID = instanceID
		frame:Hide()
		
		local option_list = parent.debuff_list
		option_list:Show()
		
		UIDropDownMenu_Initialize(option_list.encounterDD.DropDown, function()
			local dataIndex = 1
			EJ_SelectInstance(parent.selected_InstanceID)
			local encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(dataIndex, parent.selected_InstanceID)
			
			while encounterName ~= nil do
				local info = UIDropDownMenu_CreateInfo()
				info.text = encounterName
				info.value = encounterID
				info.func = function()
					option_list.encounterDD:SetText(info.text)
					UIDropDownMenu_SetSelectedValue(option_list.encounterDD.DropDown, info.value)
				end
				UIDropDownMenu_AddButton(info)
				
				dataIndex = dataIndex + 1
				encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(dataIndex, parent.selected_InstanceID)
			end
			
			local info = UIDropDownMenu_CreateInfo()
			info.text = L["杂兵"]
			info.value = 1
			info.func = function()
				option_list.encounterDD:SetText(info.text)
				UIDropDownMenu_SetSelectedValue(option_list.encounterDD.DropDown, 1)
			end
			UIDropDownMenu_AddButton(info)
		end)
		
		local first_encounterID = select(3, EJ_GetEncounterInfoByIndex(1, parent.selected_InstanceID))
		local encounterName = EJ_GetEncounterInfo(first_encounterID)
		option_list.encounterDD:SetText(encounterName)
		UIDropDownMenu_SetSelectedValue(option_list.encounterDD.DropDown, first_encounterID)
		
		DisplayRaidDebuffList()
	end)
	
	if not aCoreCDB["UnitframeOptions"]["raid_debuffs"][instanceID] then
		aCoreCDB["UnitframeOptions"]["raid_debuffs"][instanceID] = {}
	end
	
	frame.list[instanceID] = bu
	frame.button_i = frame.button_i + 1
end

RFInnerframe.raiddebuff.instance_list = T.createscrolllist(RFInnerframe.raiddebuff, {"TOPLEFT", 25, -55}, false, 395, 400)
RFInnerframe.raiddebuff.instance_list:SetScript("OnShow", function(self)
	if self.init then return end
	
	local parent = RFInnerframe.raiddebuff
	local tier_num = EJ_GetNumTiers()
	
	self.y = -10
	for i = tier_num, 1, -1 do
		local tier_title = T.createtext(self.anchor, "OVERLAY", 16, "OUTLINE", "LEFT")
		tier_title:SetPoint("TOPLEFT", self.anchor, "TOPLEFT", 20, self.y)
		tier_title:SetText(EJ_GetTierInfo(i))
		self.y = self.y - 20
		
		CreateDividingLine(self.anchor, self.y, 400)
		self.y = self.y - 10
		
		EJ_SelectTier(i)
		
		self.button_i = 1	
		local dungeon_i, raid_i = 1, 1
		
		-- 地下城
		local instanceID, instanceName, _, _, _, _, bgImage = EJ_GetInstanceByIndex(dungeon_i, false)
		while instanceID ~= nil do	
			CreateInstanceButton(self, instanceID, instanceName, bgImage)	
			
			dungeon_i = dungeon_i + 1
			instanceID, instanceName, _, _, _, _, bgImage = EJ_GetInstanceByIndex(dungeon_i, false)
		end
		
		-- 团本
		instanceID, instanceName, _, _, _, _, bgImage = EJ_GetInstanceByIndex(raid_i, true)
		while instanceID ~= nil do
			CreateInstanceButton(self, instanceID, instanceName, bgImage)
		
			raid_i = raid_i + 1
			instanceID, instanceName, _, _, _, _, bgImage = EJ_GetInstanceByIndex(raid_i, true)
		end
		
		self.y = self.y - 10
	end
	
	self.init = true
end)

hooksecurefunc("SetItemRef", function(link)
  if link:find("addon:altz:raiddebuff") then
	local _, _, action, InstanceID, encounterID, spellID = string.split(":", link)
	
	InstanceID = tonumber(InstanceID)
	encounterID = tonumber(encounterID)
	spellID = tonumber(spellID)

	if action == "raiddebuff_config" then	
		GUI:Show()
		GUI.df:Show()
		GUI.scale:Show()
		
		RFOptions.hooked_tab:GetScript("OnMouseDown")()	
		RFInnerframe.raiddebuff.hooked_tab:GetScript("OnMouseDown")()
		RFInnerframe.raiddebuff.instance_list.list[InstanceID]:GetScript("OnMouseDown")()
		local button = RFInnerframe.raiddebuff.debuff_list.spells["icon"..encounterID.."_"..spellID]
		if button then
			button:GetScript("OnMouseDown")(button)
		end
		
	elseif action == "raiddebuff_delete" then
		if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] then
			aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] = nil
			aCoreCDB["UnitframeOptions"]["debuff_list_black"][spellID] = true
			if RFInnerframe.raiddebuff.selected_InstanceID == InstanceID then
				DisplayRaidDebuffList()
			end
			print(string.format(L["已删除并加入黑名单"], T.GetIconLink(spellID)))
		end
	end
  end
end)

-- 全局减益
RFInnerframe.globaldebuff = CreateOptionPage("RF Options Raid Debuff Fliter List", T.split_words(L["全局"], L["减益"]), RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.globaldebuff, "UnitframeOptions", 102, 102)

RFInnerframe.globaldebuff.whitelist = T.CreateAuraListOption(RFInnerframe.globaldebuff, {"TOPLEFT", 30, -55}, 200,
L["白名单"]..AURAS, {"UnitframeOptions", "debuff_list"}, L["优先级"])
RFInnerframe.globaldebuff.whitelist.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

CreateDividingLine(RFInnerframe.globaldebuff, -250)

RFInnerframe.globaldebuff.blacklist = T.CreateAuraListOption(RFInnerframe.globaldebuff, {"TOPLEFT", RFInnerframe.globaldebuff.whitelist, "BOTTOMLEFT", 0, -10}, 200,
L["黑名单"]..AURAS, {"UnitframeOptions", "debuff_list_black"})
RFInnerframe.globaldebuff.blacklist.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

-- 全局增益
RFInnerframe.globalbuff = CreateOptionPage("RF Options Cooldown Aura", T.split_words(L["全局"], L["增益"]), RFInnerframe, "VERTICAL")
T.CreateGUIOpitons(RFInnerframe.globalbuff, "UnitframeOptions", 103, 103)

RFInnerframe.globalbuff.whitelist = T.CreateAuraListOption(RFInnerframe.globalbuff, {"TOPLEFT", 30, -60}, 380,
L["白名单"]..AURAS, {"UnitframeOptions", "buff_list"}, L["优先级"])
RFInnerframe.globalbuff.whitelist.apply = function()
	T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
end
--====================================================--
--[[           -- Actionbar Options --              ]]--
--====================================================--
local ActionbarOptions = CreateOptionPage("Actionbar Options", ACTIONBARS_LABEL, GUI, "VERTICAL")
local ActionbarInnerframe = CreateInnerFrame(ActionbarOptions)

-- 样式
ActionbarInnerframe.common = CreateOptionPage("Actionbar Options common", L["样式"], ActionbarInnerframe, "VERTICAL")
T.CreateGUIOpitons(ActionbarInnerframe.common, "ActionbarOptions", 1, 12)

do
	local ShouldShow = function()
		if aCoreCDB.ActionbarOptions.fadingalpha_type == "custom" then
			return true
		end
	end
	
	T.createVisibleDR(ShouldShow, ActionbarInnerframe.common.fadingalpha_type, ActionbarInnerframe.common.fadingalpha)
end

-- 冷却提示
ActionbarInnerframe.cdflash = CreateOptionPage("Actionbar Options cdflash", L["冷却提示"], ActionbarInnerframe, "VERTICAL")
T.CreateGUIOpitons(ActionbarInnerframe.cdflash, "ActionbarOptions", 13, 15)

do
	local ShouldShow = function()
		if aCoreCDB.ActionbarOptions.cdflash_enable then
			return true
		end
	end
	
	local line1 = CreateDividingLine(ActionbarInnerframe.cdflash, -115)
	ActionbarInnerframe.cdflash.ignorespell_list = T.CreateAuraListOption(ActionbarInnerframe.cdflash, {"TOPLEFT", 30, -125}, 185,
	L["黑名单"]..SPELLS, {"ActionbarOptions", "cdflash_ignorespells"})
	
	local line2 = CreateDividingLine(ActionbarInnerframe.cdflash, -290)
	ActionbarInnerframe.cdflash.ignoreitem_list = T.CreateItemListOption(ActionbarInnerframe.cdflash, {"TOPLEFT", 30, -300}, 185,
	L["黑名单"]..ITEMS, {"ActionbarOptions", "cdflash_ignoreitems"})
	
	T.createVisibleDR(ShouldShow, ActionbarInnerframe.cdflash.cdflash_enable, line1, line2, ActionbarInnerframe.cdflash.ignorespell_list, ActionbarInnerframe.cdflash.ignoreitem_list)
end
--====================================================--
--[[           -- NamePlates Options --             ]]--
--====================================================--
local PlateOptions = CreateOptionPage("Plate Options", UNIT_NAMEPLATES, GUI, "VERTICAL")
local PlateInnerframe = CreateInnerFrame(PlateOptions)

-- 通用
PlateInnerframe.common = CreateOptionPage("Nameplates Options common", T.split_words(L["一般"], L["设置"]), PlateInnerframe, "VERTICAL")
T.CreateGUIOpitons(PlateInnerframe.common, "PlateOptions", 1, 16)

-- 样式
PlateInnerframe.style = CreateOptionPage("Nameplates Options style", L["样式"], PlateInnerframe, "VERTICAL")
T.CreateGUIOpitons(PlateInnerframe.style, "PlateOptions", 17, 23)
PlateInnerframe.style.option_y = PlateInnerframe.style.option_y - 150
T.CreateGUIOpitons(PlateInnerframe.style, "PlateOptions", 24, 26)

do
	local ShouldShowNumber = function()
		if aCoreCDB.PlateOptions.theme == "number" then
			return true
		end
	end
	
	T.createVisibleDR(ShouldShowNumber, PlateInnerframe.style.theme, 
		PlateInnerframe.style.number_size, PlateInnerframe.style.number_alwayshp,
		PlateInnerframe.style.number_colorheperc)
	
	local ShouldShowBar = function()
		if aCoreCDB.PlateOptions.theme ~= "number" then
			return true
		end
	end
	
	T.createVisibleDR(ShouldShowBar, PlateInnerframe.style.theme,
		PlateInnerframe.style.bar_width, PlateInnerframe.style.bar_height,
		PlateInnerframe.style.valuefontsize, PlateInnerframe.style.bar_hp_perc, 
		PlateInnerframe.style.bar_alwayshp)
end

-- 玩家姓名板
PlateInnerframe.playerresource = CreateOptionPage("Player Resource Bar Options", L["玩家姓名板"], PlateInnerframe, "VERTICAL")
T.CreateGUIOpitons(PlateInnerframe.playerresource, "PlateOptions", 27, 30)

-- 光环过滤列表
PlateInnerframe.auralist = CreateOptionPage("Plate Options Aura", L["光环"], PlateInnerframe, "VERTICAL")
T.CreateGUIOpitons(PlateInnerframe.auralist, "PlateOptions", 31, 31)

PlateInnerframe.auralist.my_filter = T.CreateAuraListOption(PlateInnerframe.auralist, {"TOPLEFT", 20, -55}, 200,
L["我施放的光环"], {"PlateOptions", "myplateauralist"}, nil, {"PlateOptions", "myfiltertype"})
PlateInnerframe.auralist.my_filter.apply = function()
	T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
end

CreateDividingLine(PlateInnerframe.auralist, -260)

PlateInnerframe.auralist.other_filter = T.CreateAuraListOption(PlateInnerframe.auralist, {"TOPLEFT", 20, -265}, 200,
L["其他人施放的光环"], {"PlateOptions", "otherplateauralist"}, nil, {"PlateOptions", "otherfiltertype"})
PlateInnerframe.auralist.other_filter.apply = function()
	T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
end

-- 自定义
PlateInnerframe.custom = CreateOptionPage("Plate Options Custom", CUSTOM, PlateInnerframe, "VERTICAL")
T.CreateGUIOpitons(PlateInnerframe.custom, "PlateOptions", 34, 34)

PlateInnerframe.custom.color = T.CreatePlateColorListOption(PlateInnerframe.custom,  {"TOPLEFT", 30, -55}, 200,
L["自定义颜色"], {"PlateOptions", "customcoloredplates"})
PlateInnerframe.custom.color.apply = T.PostUpdateAllPlates

CreateDividingLine(PlateInnerframe.custom, -250)

PlateInnerframe.custom.power = T.CreatePlatePowerListOption(PlateInnerframe.custom,  {"TOPLEFT", PlateInnerframe.custom.color, "BOTTOMLEFT", 0, -10}, 200,
L["自定义能量"], {"PlateOptions", "custompowerplates"})
PlateInnerframe.custom.power.apply = T.PostUpdateAllPlates

--====================================================--
--[[             -- Combattext Options --              ]]--
--====================================================--
local CombattextOptions = CreateOptionPage("CombatText Options", L["战斗数字"], GUI, "VERTICAL")
T.CreateGUIOpitons(CombattextOptions, "CombattextOptions", 1, 11)

--====================================================--
--[[              -- Other Options --               ]]--
--====================================================--
local OtherOptions = CreateOptionPage("Other Options", OTHER, GUI, "VERTICAL")
T.CreateGUIOpitons(OtherOptions, "OtherOptions", 1, 18)

--====================================================--
--[[               -- Commands --               ]]--
--====================================================--
local Comands = CreateOptionPage("Comands", L["命令"], GUI, "VERTICAL")

Comands.text = T.createtext(Comands, "OVERLAY", 14, "OUTLINE", "LEFT")
Comands.text:SetPoint("TOPLEFT", 30, -60)
Comands.text:SetText(L["指令"])
Comands.text:SetSpacing(10)

Comands.mem = T.createtext(Comands, "OVERLAY", 14, "OUTLINE", "RIGHT")
Comands.mem:SetPoint("TOPRIGHT", -30, -60)

Comands.ef = CreateFrame("Frame")
Comands.ef.t = 0
Comands.ef:SetScript("OnUpdate", function(self, e)
	self.t = self.t + e
	if self.t > .5 then
		UpdateAddOnMemoryUsage()
		Comands.mem:SetText(T.memFormat(GetAddOnMemoryUsage("AltzUI")))
		self.t = 0
	end
end)

--====================================================--
--[[               -- Credits --               ]]--
--====================================================--
local Credits = CreateOptionPage("Credits", L["制作"], GUI, "VERTICAL")

Credits.text = T.createtext(Credits, "OVERLAY", 12, "OUTLINE", "CENTER")
Credits.text:SetPoint("CENTER")
Credits.text:SetText(format(L["制作说明"], G.Version, "fgprodigal susnow Zork Haste Tukz Haleth Qulight Freebaser Monolit warbaby siweia"))

--====================================================--
--[[       -- 插件按钮和小地图按钮 --               ]]--
--====================================================--

AddonCompartmentFrame:RegisterAddon({
	text = C_AddOns.GetAddOnMetadata("AltzUI", "Title"),
	icon = C_AddOns.GetAddOnMetadata("AltzUI", "IconTexture"),
	registerForAnyClick = true,
	notCheckable = true,
	func = function(btn, arg1, arg2, checked, mouseButton)
		if GUI:IsShown() then
			GUI:Hide()
			GUI.df:Hide()
			GUI.scale:Hide()
		else
			GUI:Show()
			GUI.df:Show()
			GUI.scale:Show()
		end
	end,
})

local MinimapButton = CreateFrame("Button", "AltzUI_MinimapButton", Minimap)
MinimapButton:SetSize(32,32)
MinimapButton:SetFrameLevel(8)
MinimapButton:SetPoint("BOTTOMLEFT", 0, 0)
MinimapButton:RegisterForClicks("AnyDown")

MinimapButton.icon = MinimapButton:CreateTexture(nil, "BORDER")
MinimapButton.icon:SetTexture(G.media.addon_icon)
MinimapButton.icon:SetSize(18,18)
MinimapButton.icon:SetPoint("CENTER")
MinimapButton.icon:SetTexCoord(.1, .9, .1, .9)

MinimapButton.CircleGlow = MinimapButton:CreateTexture(nil, "OVERLAY")
MinimapButton.CircleGlow:SetAtlas("GarrLanding-CircleGlow")
MinimapButton.CircleGlow:SetSize(30, 30)
MinimapButton.CircleGlow:SetBlendMode("ADD")
MinimapButton.CircleGlow:SetPoint("CENTER")
MinimapButton.CircleGlow:Hide()

MinimapButton.SoftButtonGlow = MinimapButton:CreateTexture(nil, "OVERLAY")
MinimapButton.SoftButtonGlow:SetAtlas("GarrLanding-SideToast-Glow", true)
MinimapButton.SoftButtonGlow:SetBlendMode("ADD")
MinimapButton.SoftButtonGlow:SetPoint("CENTER")
MinimapButton.SoftButtonGlow:Hide()

MinimapButton.anim = MinimapButton:CreateAnimationGroup()
MinimapButton.anim:SetLooping("REPEAT")

MinimapButton.anim:SetScript("OnPlay", function(self)
	MinimapButton.CircleGlow:Show()
	MinimapButton.SoftButtonGlow:Show()
end)

MinimapButton.anim:SetScript("OnStop", function(self)
	MinimapButton.CircleGlow:Hide()
	MinimapButton.SoftButtonGlow:Hide()
end)

MinimapButton.anim:SetScript("OnFinished", function(self)
	MinimapButton.CircleGlow:Hide()
	MinimapButton.SoftButtonGlow:Hide()
end)

T.CreateAnimations(MinimapButton, MinimapButton.anim, {
	{"Alpha", "CircleGlow", 0, .1, 1, 0, 1},
	{"Alpha", "CircleGlow", .1, .5, 1, 1, 0},
	{"Scale", "CircleGlow", 0, .25, 1, .75, 1.5},
	{"Alpha", "SoftButtonGlow", 0, .5, 1, 0, 1},
	{"Alpha", "SoftButtonGlow", .5, .5, 1, 1, 0},
	{"Scale", "SoftButtonGlow", 0, .75, 1, 1, 1.5},
})

MinimapButton:SetScript("OnEnter",function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
	GameTooltip:AddLine("AltzUI")
	GameTooltip:Show()

	self.anim:Play()
end)

MinimapButton:SetScript("OnLeave", function(self)    
	GameTooltip:Hide()
	
	self.anim:Stop()
end)

local AddonConfigMenu = CreateFrame("Frame", G.uiname.."AddonConfigMenu", UIParent, "UIDropDownMenuTemplate")

local function AddonConfigMenu_Initialize(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.text = L["设置向导"]
	info.func = T.RunSetup
	info.notCheckable = true
	UIDropDownMenu_AddButton(info)
end

T.RegisterInitCallback(function()
	UIDropDownMenu_Initialize(AddonConfigMenu, AddonConfigMenu_Initialize, "MENU")
end)

MinimapButton:SetScript("OnClick", function(self, btn)
	if btn == "LeftButton" then
		if GUI:IsShown() then
			GUI:Hide()
			GUI.df:Hide()
			GUI.scale:Hide()
		else
			GUI:Show()
			GUI.df:Show()
			GUI.scale:Show()
		end
	else
		ToggleDropDownMenu(1, nil, AddonConfigMenu, self, 0, 5)
	end
end)

T.ToggleMinimapButton = function()
	if aCoreCDB["SkinOptions"]["minimapbutton"] then
		MinimapButton:Show()
	else
		MinimapButton:Hide()
	end
end

--====================================================--
--[[                -- Init --                      ]]--
--====================================================--
local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

function eventframe:ADDON_LOADED(arg1)
	if arg1 ~= "AltzUI" then return end
	
	if aCoreDB == nil then
		aCoreDB = {}
	end
	
	if aCoreCDB == nil then
		aCoreCDB = {}
	end
	
	T.LoadAccountVariables()
	T.LoadVariables()

	local scale = aCoreCDB["SkinOptions"]["gui_scale"]/100
	GUI:ClearAllPoints()
	GUI:SetPoint("TOPRIGHT", UIParent, "CENTER", aCoreCDB["SkinOptions"]["gui_x"]/scale, aCoreCDB["SkinOptions"]["gui_y"]/scale)
	GUI:SetScale(scale)
	GUI.scale.pointself()
	
	T.ToggleMinimapButton()
	
	for _, func in next, G.Init_callbacks do
		func()
	end
end

function eventframe:PLAYER_ENTERING_WORLD()
	for _, func in next, G.EnteringWorld_callbacks do
		func()
	end
	
	eventframe:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

--====================================================--
--[[                  -- Game menu --               ]]--
--====================================================--


local function ShowGUI()
	GUI:Show()
	GUI.df:Show()
	GUI.scale:Show()
	HideUIPanel(GameMenuFrame)
end

hooksecurefunc(GameMenuFrame, "InitButtons", function()
	local GUI_button = GameMenuFrame:AddButton(G.addon_colorStr.."AltzUI".."|r", ShowGUI)
	T.SetMenuButtonBD(GUI_button)
end)

GameMenuFrame:HookScript("OnShow", function()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)



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
