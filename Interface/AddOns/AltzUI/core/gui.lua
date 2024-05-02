local T, C, L, G = unpack(select(2, ...))

local function CreateDividingLine(frame, y, width)
	local tex = frame:CreateTexture(nil, "ARTWORK")
	tex:SetSize(width or frame:GetWidth()-50, 1)
	tex:SetPoint("TOP", frame, "TOP", 0, y)
	tex:SetColorTexture(1, 1, 1, .2)
end

local function CreateTitle(frame, x, y, text, fs, color)
	local fs = T.createtext(frame, "OVERLAY", fs or 14, "OUTLINE", "LEFT")
	fs:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
	fs:SetText(text)
	if color then
		fs:SetTextColor(unpack(color))
	end
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
GUI.scale = CreateFrame("Slider", G.uiname.."GUIScaleSlider", UIParent, "OptionsSliderTemplate")
GUI.scale:SetFrameLevel(20)
T.ReskinSlider(GUI.scale)
getmetatable(GUI.scale).__index.Enable(GUI.scale)
GUI.scale:SetMinMaxValues(50, 120)
GUI.scale:SetValueStep(5)
GUI.scale:SetFrameStrata("HIGH")
GUI.scale:SetMovable(true)
GUI.scale:SetClampedToScreen(true)
GUI.scale:Hide()
GUI.scale:SetSize(100, 12)

GUI.scale.Thumb:SetSize(25, 16)

GUI.scale.Text:ClearAllPoints()
GUI.scale.Text:SetPoint("RIGHT", GUI.scale, "LEFT", 0, 0)

GUI.scale.High:SetAlpha(0)
GUI.scale.Low:SetAlpha(0)

GUI.scale:SetScript("OnShow", function(self)
	self:SetValue((aCoreCDB["SkinOptions"]["gui_scale"]))
	self.Text:SetText(L["控制台"]..L["尺寸"].." |cFF00FFFF"..aCoreCDB["SkinOptions"]["gui_scale"].."|r")
end)

GUI.scale:SetScript("OnValueChanged", function(self, getvalue)
	aCoreCDB["SkinOptions"]["gui_scale"] = getvalue
	T.TestSlider_OnValueChanged(self, getvalue)

	self.Text:SetText(L["控制台"]..L["尺寸"].." |cFF00FFFF"..aCoreCDB["SkinOptions"]["gui_scale"].."|r")
	
	local scale = aCoreCDB["SkinOptions"]["gui_scale"]/100
	GUI:ClearAllPoints()
	GUI:SetPoint("TOPRIGHT", UIParent, "CENTER", aCoreCDB["SkinOptions"]["gui_x"]/scale, aCoreCDB["SkinOptions"]["gui_y"]/scale)
	GUI:SetScale(scale)
end)
	
GUI.scale.pointself = function()
	local scale = aCoreCDB["SkinOptions"]["gui_scale"]/100
	--GUI.scale:SetClampRectInsets(-650*scale+160, 0, 0, -550*scale+20)	
	GUI.scale:ClearAllPoints()
	GUI.scale:SetPoint("TOPRIGHT", UIParent, "CENTER", aCoreCDB["SkinOptions"]["gui_x"]-3, aCoreCDB["SkinOptions"]["gui_y"]-5)	
end

GUI.scale:SetScript("OnMouseUp", GUI.scale.pointself)

-- 标题
GUI.title = T.createtext(GUI, "OVERLAY", 20, "OUTLINE", "CENTER")
GUI.title:SetPoint("TOP", GUI, "TOP", 0, 8)
GUI.title:SetText(T.color_text("AltzUI "..G.Version))

-- 输入框和按钮
GUI.EditFrame = CreateFrame("Frame", nil, GUI)
GUI.EditFrame:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", 0, -3)
GUI.EditFrame:SetPoint("TOPRIGHT", GUI, "BOTTOMRIGHT", 0, -3)
GUI.EditFrame:SetHeight(40)
GUI.EditFrame:Hide()
T.setStripBD(GUI.EditFrame)

GUI.editbox = T.EditboxWithButton(GUI.EditFrame, 200, {"TOPLEFT", 5, -10}, L["复制粘贴"])

GUI.editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
GUI.editbox:SetScript("OnEditFocusLost", function(self) self:HighlightText(0,0) end)
GUI.editbox:HookScript("OnHide", function(self) self.button:Hide() end)

GUI.GitHub = T.ClickTexButton(GUI, {"BOTTOMLEFT", GUI, "BOTTOMLEFT", 5, 0}, [[Interface\AddOns\AltzUI\media\icons\GitHub.tga]], "GitHub")
GUI.GitHub:SetScript("OnClick", function()
	if GUI.editbox.type ~= "GitHub" then
		GUI.EditFrame:Show()
		GUI.editbox.button:Hide()
		GUI.editbox:SetText(G.links["GitHub"])
		GUI.editbox.type = "GitHub"
	else
		GUI.EditFrame:Hide()
		GUI.editbox.type = nil
	end
end)

GUI.wowi = T.ClickTexButton(GUI, {"LEFT", GUI.GitHub, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\EJ.tga]], "WoWInterface", 20)
GUI.wowi:SetScript("OnClick", function()
	if GUI.editbox.type ~= "WoWInterface" then
		GUI.EditFrame:Show()
		GUI.editbox.button:Hide()
		GUI.editbox:SetText(G.links["WoWInterface"])
		GUI.editbox.type = "WoWInterface"
	else
		GUI.EditFrame:Hide()
		GUI.editbox.type = nil
	end
end)

GUI.curse = T.ClickTexButton(GUI, {"LEFT", GUI.wowi, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\Spellbook.tga]], "Curse", 20)
GUI.curse:SetScript("OnClick", function()
	if GUI.editbox.type ~= "Curse" then
		GUI.EditFrame:Show()
		GUI.editbox.button:Hide()
		GUI.editbox:SetText(G.links["Curse"])
		GUI.editbox.type = "Curse"
	else
		GUI.EditFrame:Hide()
		GUI.editbox.type = nil
	end
end)

GUI.export = T.ClickTexButton(GUI, {"LEFT", GUI.curse, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\arrow.tga]], L["导出"], 20)
GUI.export:SetScript("OnClick", function()	
	if GUI.editbox.type ~= "export" then
		GUI.EditFrame:Show()
		GUI.editbox.button:Hide()
		T.ExportSettings(GUI.editbox)
		GUI.editbox.type = "export"
	else
		GUI.EditFrame:Hide()
		GUI.editbox.type = nil
	end
end)
T.SetupArrow(GUI.export.tex, "down")
T.SetupArrow(GUI.export.hl_tex, "down")

GUI.import = T.ClickTexButton(GUI, {"LEFT", GUI.export, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\arrow.tga]], L["导入"], 20)
GUI.import:SetScript("OnClick", function()	
	if GUI.editbox.type ~= "import" then
		GUI.EditFrame:Show()
		GUI.editbox.button:Show()
		GUI.editbox:SetScript("OnEnterPressed", function()
			T.ImportSettings(GUI.editbox:GetText())
		end)
		GUI.editbox:SetText("")
		GUI.editbox.type = "import"
	else
		GUI.EditFrame:Hide()
		GUI.editbox.type = nil
	end
end)
T.SetupArrow(GUI.import.tex, "up")
T.SetupArrow(GUI.import.hl_tex, "up")

GUI.reset = T.ClickTexButton(GUI, {"LEFT", GUI.import, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])
GUI.reset:SetScript("OnClick", function()
	GUI.EditFrame:Hide()
	GUI.editbox.type = nil
	
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text("Altz UI"))
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		aCoreCDB = {}
		T.SetChatFrame()
		T.LoadVariables()
		T.ResetAllAddonSettings()
		ReloadUI()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

GUI.unlock = T.ClickTexButton(GUI, {"LEFT", GUI.reset, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\lock.tga]], L["解锁框体"], 20)
GUI.unlock:SetScript("OnClick", function()	
	GUI.EditFrame:Hide()
	GUI.editbox.type = nil
	
	T.UnlockAll()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI.reload = T.ClickTexButton(GUI, {"LEFT", GUI.unlock, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\RaidTool.tga]], RELOADUI, 20)
GUI.reload:SetScript("OnClick", ReloadUI)

GUI.close = T.ClickTexButton(GUI, {"BOTTOMRIGHT", GUI, "BOTTOMRIGHT", -5, 0}, [[Interface\AddOns\AltzUI\media\icons\exit.tga]], nil, 20)
GUI.close:SetScript("OnClick", function()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI:HookScript("OnHide", function()
	StaticPopup_Hide(G.uiname.."Import Confirm")
	StaticPopup_Hide(G.uiname.."Reset Confirm")
	GUI.EditFrame:Hide()
	GUI.editbox.type = nil
end)

--====================================================--
--[[                   -- TABS --                   ]]--
--====================================================--
local function CreateOptionPage(name, title, parent, orientation, db_key)	
	local frame = CreateFrame("Frame", G.uiname..name, parent)
	frame:SetAllPoints(parent)
	frame:Hide()

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	frame.title:SetPoint("TOPLEFT", 35, -23)
	frame.title:SetText(title)
	
	frame.line = frame:CreateTexture(nil, "ARTWORK")
	frame.line:SetSize(parent:GetWidth()-50, 1)
	frame.line:SetPoint("TOP", 0, -50)
	frame.line:SetColorTexture(1, 1, 1, .2)
	
	if db_key then
		frame.db_key = db_key
	end
	
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
		tab.backdrop = T.setStripBD(tab)
	else
		tab.backdrop = T.createBackdrop(tab, 0)
	end
	
	tab.text = T.createtext(tab, "OVERLAY", 12, "OUTLINE", "LEFT")
	tab.text:SetText(title)
	
	table.insert(parent.tabs, tab)
	
	tab.owner = frame
	tab.index = #parent.tabs	
	frame.hooked_tab = tab
	
	if orientation == "VERTICAL" then	
		tab:SetSize(130, 20)
		tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2, -30*tab.index)
		
		tab.text:SetJustifyH("LEFT")
		tab.text:SetPoint("LEFT", 10, 0)
		
		tab:SetScript("OnMouseDown", function()
			tab.owner:Show()
			tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 8, -30*tab.index)
			tab.backdrop:SetBackdropBorderColor(unpack(G.addon_color))
			for i, t in pairs(parent.tabs) do
				if t ~= tab then
					t.owner:Hide()
					t:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2,  -30*t.index)
					t.backdrop:SetBackdropBorderColor(0, 0, 0)
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
			tab.owner:Show()
			tab.backdrop:SetBackdropBorderColor(unpack(G.addon_color))
			for i, t in pairs(parent.tabs) do
				if t ~= tab then
					t.owner:Hide()
					t.backdrop:SetBackdropBorderColor(0, 0, 0)
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
	
	parent.line:Hide()
	
	return frame
end

--====================================================--
--[[            -- Interface Options --            ]]--
--====================================================--
local SkinOptions = CreateOptionPage("Interface Options", L["界面"], GUI, "VERTICAL")
local SInnerframe = CreateInnerFrame(SkinOptions)

-- 界面风格
SInnerframe.theme = CreateOptionPage("Interface Options theme", L["界面风格"], SInnerframe, "VERTICAL", "SkinOptions")

T.RadioButtonGroup_db(SInnerframe.theme, 30, 60, L["样式"], "style", {
	{1, L["透明样式"]},
	{2, L["深色样式"]},
	{3, L["普通样式"]},
})

SInnerframe.theme.style.apply = function()
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
end

T.RadioButtonGroup_db(SInnerframe.theme, 30, 90, L["数字缩写样式"], "formattype", {
	{"k", "k m"},
	{"w", "w kw"},
	{"w_chinese", "万 千万"},
	{"none", "不缩写"},
})

T.Checkbutton_db(SInnerframe.theme, 30, 120, L["上方"].." "..L["边缘装饰"], "showtopbar")
SInnerframe.theme.showtopbar.apply = G.BGFrame.Apply
T.Checkbutton_db(SInnerframe.theme, 200, 120, L["上方"].." "..L["两侧装饰"], "showtopconerbar")
SInnerframe.theme.showtopconerbar.apply = G.BGFrame.Apply
T.Checkbutton_db(SInnerframe.theme, 30, 150, L["下方"].." "..L["边缘装饰"], "showbottombar")
SInnerframe.theme.showbottombar.apply = G.BGFrame.Apply
T.Checkbutton_db(SInnerframe.theme, 200, 150, L["下方"].." "..L["两侧装饰"], "showbottomconerbar")
SInnerframe.theme.showbottomconerbar.apply = G.BGFrame.Apply

local addonskin_title = SInnerframe.theme:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
addonskin_title:SetPoint("TOPLEFT", 35, -183)
addonskin_title:SetText(L["插件皮肤"])

CreateDividingLine(SInnerframe.theme, -210)

local function CreateApplySettingButton(addon)
	local Button = CreateFrame("Button", G.uiname..addon.."ApplySettingButton", SInnerframe.theme, "UIPanelButtonTemplate")
	Button:SetPoint("LEFT", SInnerframe.theme[addon], "RIGHT", 150, 0)
	Button:SetSize(120, 25)
	Button:SetText(L["更改设置"])
	
	T.ReskinButton(Button)
	
	Button:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(L["更改设置提示"])
			GameTooltip:Show() 
		end)
	Button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	
	SInnerframe.theme[addon]:HookScript("OnClick", function(self)
		if self:GetChecked() then
			Button:Enable()
		else
			Button:Disable()
		end
	end)
	
	SInnerframe.theme[addon]:HookScript("OnShow", function(self)
		if self:GetChecked() then
			Button:Enable()
		else
			Button:Disable()
		end
	end)
	
	return Button
end

T.Checkbutton_db(SInnerframe.theme, 30, 220, "ClassColor", "setClassColor")
local SetClassColorButton = CreateApplySettingButton("setClassColor")

T.Checkbutton_db(SInnerframe.theme, 30, 250, "DBM", "setDBM")
local SetDBMButton = CreateApplySettingButton("setDBM")

T.Checkbutton_db(SInnerframe.theme, 30, 280, "BigWigs", "setBW")
local SetBWButton = CreateApplySettingButton("setBW")

T.Checkbutton_db(SInnerframe.theme, 30, 310, "Skada", "setSkada")
local SetSkadaButton = CreateApplySettingButton("setSkada")

-- 界面布局
SInnerframe.layout = CreateOptionPage("Interface Options Layout", L["界面布局"], SInnerframe, "VERTICAL", "SkinOptions")

T.Checkbutton_db(SInnerframe.layout, 30, 60, L["信息条"], "infobar")
SInnerframe.layout.infobar.apply = G.InfoFrame.Apply

T.Slider_db(SInnerframe.layout, "long", 30, 110, L["信息条尺寸"], "infobarscale", 100, 50, 200, 5)
SInnerframe.layout.infobarscale.apply = G.InfoFrame.Apply

T.createDR(SInnerframe.layout.infobar, SInnerframe.layout.infobarscale)

CreateDividingLine(SInnerframe.layout, -150)

T.Checkbutton_db(SInnerframe.layout, 30, 170, L["在副本中收起任务追踪"], "collapseWF", L["在副本中收起任务追踪提示"])
T.Checkbutton_db(SInnerframe.layout, 30, 200, L["暂离屏幕"], "afkscreen", L["暂离屏幕"])
T.Checkbutton_db(SInnerframe.layout, 50, 230, L["显示插件使用小提示"], "showAFKtips", L["显示插件使用小提示提示"])
T.createDR(SInnerframe.layout.afkscreen, SInnerframe.layout.showAFKtips)
--====================================================--
--[[              -- Chat Options --                ]]--
--====================================================--
local ChatOptions = CreateOptionPage("Chat Options", SOCIAL_LABEL, GUI, "VERTICAL", "ChatOptions")

T.Checkbutton_db(ChatOptions, 30, 60, L["频道缩写"], "channelreplacement")
ChatOptions.channelreplacement.apply = T.UpdateChannelReplacement

T.CVarCheckbutton(ChatOptions, 230, 60, "showTimestamps", SHOW_TIMESTAMP, "|cff64C2F5%H:%M|r ", "none")

T.Checkbutton_db(ChatOptions, 30, 90, L["滚动聊天框"], "autoscroll", L["滚动聊天框提示"])

T.Checkbutton_db(ChatOptions, 230, 90, L["显示聊天框背景"], "showbg")
ChatOptions.showbg.apply = T.UpdateChatFrameBg

CreateDividingLine(ChatOptions, -130)

T.Checkbutton_db(ChatOptions, 30, 140, L["聊天过滤"], "nogoldseller", L["聊天过滤提示"])

T.Slider_db(ChatOptions, "long", 30, 190, L["过滤阈值"], "goldkeywordnum", 1, 1, 5, 1, L["过滤阈值"])

T.EditboxMultiLine_db(ChatOptions, 200, 100, 35, 225, L["关键词"], "goldkeywordlist", L["关键词输入"])
ChatOptions.goldkeywordlist.apply = T.Update_Chat_Filter

T.createDR(ChatOptions.nogoldseller, ChatOptions.goldkeywordnum, ChatOptions.goldkeywordlist)

CreateDividingLine(ChatOptions, -360)

T.Checkbutton_db(ChatOptions, 30, 370, L["自动邀请"], "autoinvite", L["自动邀请提示"])

T.EditboxWithButton_db(ChatOptions, 40, 405, L["关键词"], "autoinvitekeywords",  L["关键词输入"])
ChatOptions.autoinvitekeywords.apply = T.Update_Invite_Keyword

T.createDR(ChatOptions.autoinvite, ChatOptions.autoinvitekeywords)

--====================================================--
--[[          -- Bag and Items Options --           ]]--
--====================================================--
local ItemOptions = CreateOptionPage("Item Options", ITEMS, GUI, "VERTICAL", "ItemOptions")

T.Checkbutton_db(ItemOptions, 30, 60, L["已会配方着色"], "alreadyknown", L["已会配方着色提示"])

CreateDividingLine(ItemOptions, -110)

T.Checkbutton_db(ItemOptions, 30, 120, L["自动修理"], "autorepair", L["自动修理提示"])
T.Checkbutton_db(ItemOptions, 30, 150, L["优先使用公会修理"], "autorepair_guild", L["优先使用公会修理提示"])

CreateDividingLine(ItemOptions, -200)

T.Checkbutton_db(ItemOptions, 30, 210, L["自动售卖"], "autosell", L["自动售卖提示"])
T.Checkbutton_db(ItemOptions, 30, 240, L["自动购买"], "autobuy", L["自动购买提示"])

ItemOptions.autobuy_list = T.CreateItemListOption(ItemOptions, {"TOPLEFT", 35, -270}, 260, L["自动购买"]..L["设置"], "autobuylist", L["数量"])

T.createDR(ItemOptions.autobuy, ItemOptions.autobuy_list)
--====================================================--
--[[               -- Unit Frames --                ]]--
--====================================================--
local UFOptions = CreateOptionPage("UF Options", L["单位框架"], GUI, "VERTICAL")
local UFInnerframe = CreateInnerFrame(UFOptions)

-- 样式
UFInnerframe.style = CreateOptionPage("UF Options style", L["样式"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(UFInnerframe.style, 30, 60, L["条件渐隐"], "enablefade", L["条件渐隐提示"])
UFInnerframe.style.enablefade.apply = function()
	T.EnableUFSettings({"Fader"})
end

T.Slider_db(UFInnerframe.style, "long", 30, 110, L["渐隐透明度"], "fadingalpha", 100, 0, 80, 5, L["渐隐透明度提示"])
UFInnerframe.style.fadingalpha.apply = function()
	T.ApplyUFSettings({"Fader"})
	T.ApplyActionbarFadeAlpha()
end

T.createDR(UFInnerframe.style.enablefade, UFInnerframe.style.fadingalpha)

CreateDividingLine(UFInnerframe.style, -140)

T.Checkbutton_db(UFInnerframe.style, 30, 150, T.split_words(L["显示"],L["肖像"]), "portrait")
UFInnerframe.style.portrait.apply = function()
	T.EnableUFSettings({"Portrait"})
end

CreateDividingLine(UFInnerframe.style, -180)

T.Checkbutton_db(UFInnerframe.style, 30, 190, L["总是显示生命值"], "alwayshp", L["总是显示生命值提示"])
UFInnerframe.style.alwayshp.apply = function()
	T.ApplyUFSettings({"Health"})
end

T.Checkbutton_db(UFInnerframe.style, 30, 220, L["总是显示能量值"], "alwayspp", L["总是显示能量值提示"])
UFInnerframe.style.alwayspp.apply = function()
	T.ApplyUFSettings({"Power"})
end

T.Slider_db(UFInnerframe.style, "long", 30, 270, L["数值字号"], "valuefontsize", 1, 10, 25, 1, L["数值字号提示"])
UFInnerframe.style.valuefontsize.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Castbar"})
end

-- 尺寸
UFInnerframe.size = CreateOptionPage("UF Options size", L["尺寸"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Slider_db(UFInnerframe.size, "long", 30, 80, L["高度"], "height", 1, 5, 50, 1)
UFInnerframe.size.height.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana", "PVPSpecIcon", "Trinket"})
end

T.Slider_db(UFInnerframe.size, "long", 30, 120, L["宽度"], "width", 1, 50, 500, 1, L["宽度提示"])
UFInnerframe.size.width.apply = function()
	T.ApplyUFSettings({"Health", "Auras", "ClassPower", "Runes", "Stagger", "Dpsmana"})
end

T.Slider_db(UFInnerframe.size, "long", 30, 160, L["能量条高度"], "ppheight", 100, 5, 100, 5)
UFInnerframe.size.ppheight.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana"})
end

CreateDividingLine(UFInnerframe.size, -190)

T.Slider_db(UFInnerframe.size, "long", 30, 220, L["宠物框体宽度"], "widthpet", 1, 50, 500, 1)
UFInnerframe.size.widthpet.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
end

T.Slider_db(UFInnerframe.size, "long", 30, 260, L["首领框体和PVP框体的宽度"], "widthboss", 1, 50, 500, 1)
UFInnerframe.size.widthboss.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
end

-- 施法条
UFInnerframe.castbar = CreateOptionPage("UF Options castbar", L["施法条"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(UFInnerframe.castbar, 30, 60, L["启用"], "castbars")
UFInnerframe.castbar.castbars.apply = function()
	T.EnableUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "long", 30, 100, L["图标大小"], "cbIconsize", 1, 10, 50, 1)
UFInnerframe.castbar.cbIconsize.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Checkbutton_db(UFInnerframe.castbar, 30, 130, L["独立施法条"], "independentcb")
UFInnerframe.castbar.independentcb.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "short", 30, 180, T.split_words(PLAYER,L["施法条"],L["高度"]), "cbheight", 1, 5, 30, 1)
UFInnerframe.castbar.cbheight.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "short", 230, 180, T.split_words(PLAYER,L["施法条"],L["宽度"]), "cbwidth", 1, 50, 500, 5)
UFInnerframe.castbar.cbwidth.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "short", 30, 220, T.split_words(TARGET,L["施法条"],L["高度"]), "target_cbheight", 1, 5, 30, 1)
UFInnerframe.castbar.target_cbheight.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "short", 230, 220, T.split_words(TARGET,L["施法条"],L["宽度"]), "target_cbwidth", 1, 50, 500, 5)
UFInnerframe.castbar.target_cbwidth.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "short", 30, 260, T.split_words(L["焦点"],L["施法条"],L["宽度"]), "focus_cbheight", 1, 5, 30, 1)
UFInnerframe.castbar.focus_cbheight.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.Slider_db(UFInnerframe.castbar, "short", 230, 260, T.split_words(L["焦点"],L["施法条"],L["宽度"]), "focus_cbwidth", 1, 50, 500, 5)
UFInnerframe.castbar.focus_cbwidth.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

local CBtextpos_group = {
	{"LEFT", 		L["左"]},
	{"TOPLEFT", 	L["左上"]},
	{"RIGHT", 		L["右"]},
	{"TOPRIGHT",	L["右上"]},
}

T.RadioButtonGroup_db(UFInnerframe.castbar, 30, 290, L["法术名称位置"], "namepos", CBtextpos_group)
UFInnerframe.castbar.namepos.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.RadioButtonGroup_db(UFInnerframe.castbar, 30, 320, L["施法时间位置"], "timepos", CBtextpos_group)
UFInnerframe.castbar.timepos.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createDR(UFInnerframe.castbar.independentcb, UFInnerframe.castbar.cbheight, UFInnerframe.castbar.cbwidth, UFInnerframe.castbar.target_cbheight, UFInnerframe.castbar.target_cbwidth, UFInnerframe.castbar.focus_cbheight, UFInnerframe.castbar.focus_cbwidth, UFInnerframe.castbar.namepos, UFInnerframe.castbar.timepos)

T.Colorpicker_db(UFInnerframe.castbar, 30, 355, T.split_words(L["可打断"],L["施法条"],L["颜色"]), "Interruptible_color")

T.Colorpicker_db(UFInnerframe.castbar, 230, 355, T.split_words(L["不可打断"],L["施法条"],L["颜色"]), "notInterruptible_color")

T.Checkbutton_db(UFInnerframe.castbar, 30, 390, L["引导法术分段"], "channelticks")
T.Checkbutton_db(UFInnerframe.castbar, 30, 420, L["隐藏玩家施法条图标"], "hideplayercastbaricon")
UFInnerframe.castbar.hideplayercastbaricon.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createDR(UFInnerframe.castbar.castbars, UFInnerframe.castbar.cbIconsize, UFInnerframe.castbar.independentcb, UFInnerframe.castbar.cbheight, UFInnerframe.castbar.cbwidth, 
UFInnerframe.castbar.target_cbheight, UFInnerframe.castbar.target_cbwidth, UFInnerframe.castbar.focus_cbheight, UFInnerframe.castbar.focus_cbwidth, UFInnerframe.castbar.namepos, 
UFInnerframe.castbar.timepos, UFInnerframe.castbar.channelticks, UFInnerframe.castbar.hideplayercastbaricon, UFInnerframe.castbar.Interruptible_color, UFInnerframe.castbar.notInterruptible_color)

-- 平砍计时条
UFInnerframe.swingtimer = CreateOptionPage("UF Options swingtimer", L["平砍计时条"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(UFInnerframe.swingtimer, 30, 60, L["启用"], "swing")
UFInnerframe.swingtimer.swing.apply = function()
	T.EnableUFSettings({"Swing"})
end

T.Slider_db(UFInnerframe.swingtimer, "long", 30, 110, L["高度"], "swheight", 1, 5, 30, 1)
UFInnerframe.swingtimer.swheight.apply = function()
	T.ApplyUFSettings({"Swing"})
end

T.Slider_db(UFInnerframe.swingtimer, "long", 30, 150, L["宽度"], "swwidth", 1, 50, 500, 5)
UFInnerframe.swingtimer.swwidth.apply = function()
	T.ApplyUFSettings({"Swing"})
end

CreateDividingLine(UFInnerframe.swingtimer, -180)

T.Checkbutton_db(UFInnerframe.swingtimer, 30, 200, T.split_words(L["显示"],L["时间"]), "swtimer")
UFInnerframe.swingtimer.swtimer.apply = function()
	T.ApplyUFSettings({"Swing"})
end

T.Slider_db(UFInnerframe.swingtimer, "long", 30, 240, L["字体大小"], "swtimersize", 1, 8, 20, 1)
UFInnerframe.swingtimer.swtimersize.apply = function()
	T.ApplyUFSettings({"Swing"})
end

T.createDR(UFInnerframe.swingtimer.swing, UFInnerframe.swingtimer.swheight, UFInnerframe.swingtimer.swwidth, UFInnerframe.swingtimer.swtimer, UFInnerframe.swingtimer.swtimersize)
T.createDR(UFInnerframe.swingtimer.swtimer, UFInnerframe.swingtimer.swtimersize)

-- 光环
UFInnerframe.aura = CreateOptionPage("UF Options aura", AURAS, UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Slider_db(UFInnerframe.aura, "long", 30, 80, L["图标大小"], "aura_size", 1, 15, 30, 1)
UFInnerframe.aura.aura_size.apply = function()
	T.ApplyUFSettings({"Auras"})
end

T.Checkbutton_db(UFInnerframe.aura, 30, 100, T.split_words(PLAYER, L["减益"]), "playerdebuffenable", L["玩家减益提示"])
UFInnerframe.aura.playerdebuffenable.apply = function()
	T.EnableUFSettings({"Auras"})
end

CreateDividingLine(UFInnerframe.aura, -140)

T.Checkbutton_db(UFInnerframe.aura, 30, 150, L["过滤增益"], "AuraFilterignoreBuff", L["过滤增益提示"])
UFInnerframe.aura.AuraFilterignoreBuff.apply = function()
	T.ApplyUFSettings({"Auras"})
end

T.Checkbutton_db(UFInnerframe.aura, 30, 180, L["过滤减益"], "AuraFilterignoreDebuff", L["过滤减益提示"])
UFInnerframe.aura.AuraFilterignoreDebuff.apply = function()
	T.ApplyUFSettings({"Auras"})
end

UFInnerframe.aura.aurafliter_list = T.CreateAuraListOption(UFInnerframe.aura, {"TOPLEFT", 30, -215}, 230, L["白名单"]..AURAS, "AuraFilterwhitelist")
UFInnerframe.aura.aurafliter_list.apply = function()
	T.ApplyUFSettings({"Auras"})
end

-- 图腾
UFInnerframe.totembar = CreateOptionPage("UF Options totembar", L["图腾条"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(UFInnerframe.totembar, 30, 60, L["启用"], "totems")
UFInnerframe.totembar.totems.apply = T.ApplyTotemsBarSettings

T.Slider_db(UFInnerframe.totembar, "long", 30, 110, L["图标大小"], "totemsize", 1, 15, 40, 1)
UFInnerframe.totembar.totemsize.apply = T.ApplyTotemsBarSettings

T.RadioButtonGroup_db(UFInnerframe.totembar, 30, 140, L["排列方向"], "growthDirection", {
	{"HORIZONTAL", L["水平"]},
	{"VERTICAL", L["垂直"]},
})
UFInnerframe.totembar.growthDirection.apply = T.ApplyTotemsBarSettings

T.RadioButtonGroup_db(UFInnerframe.totembar, 30, 170, L["排列方向"], "sortDirection", {
	{"ASCENDING", L["正向"]},
	{"DESCENDING", L["反向"]},
})
UFInnerframe.totembar.sortDirection.apply = T.ApplyTotemsBarSettings

-- 小队
UFInnerframe.party = CreateOptionPage("UF Options party", PARTY, UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Slider_db(UFInnerframe.party, "long", 30, 80, PARTY..L["宽度"], "widthparty", 1, 50, 500, 1)
UFInnerframe.party.widthparty.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
end

T.Checkbutton_db(UFInnerframe.party, 30, 100, T.split_words(L["显示"], PET), "showpartypet")
UFInnerframe.party.showpartypet.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

-- 其他
UFInnerframe.other = CreateOptionPage("UF Options other", OTHER, UFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(UFInnerframe.other, 30, 60, L["启用仇恨条"], "showthreatbar")
UFInnerframe.other.showthreatbar.apply = function()
	T.EnableUFSettings({"ThreatBar"})
end

T.Checkbutton_db(UFInnerframe.other, 30, 90, T.split_words(L["显示"],L["PvP标记"]), "pvpicon", L["PvP标记提示"])
UFInnerframe.other.showthreatbar.apply = function()
	T.EnableUFSettings({"PvPIndicator"})
end

T.Checkbutton_db(UFInnerframe.other, 30, 120, L["启用首领框体"], "bossframes")
UFInnerframe.other.bossframes.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.Checkbutton_db(UFInnerframe.other, 30, 150, L["启用PVP框体"], "arenaframes")
UFInnerframe.other.arenaframes.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

if G.myClass == "DEATHKNIGHT" then
    CreateDividingLine(UFInnerframe.other, -180)
	T.Checkbutton_db(UFInnerframe.other, 30, 190, format(L["显示冷却"], RUNES), "runecooldown")
	UFInnerframe.other.runecooldown.apply = function()
		T.ApplyUFSettings({"Runes"})
	end

	T.Slider_db(UFInnerframe.other, "long", 30, 240, L["字体大小"], "valuefs", 1, 8, 16, 1)
	UFInnerframe.other.valuefs.apply = function()
		T.ApplyUFSettings({"Runes"})
	end
end

if G.myClass == "SHAMAN" or G.myClass == "PRIEST" or G.myClass == "DRUID" then
	CreateDividingLine(UFInnerframe.other, -180)
    T.Checkbutton_db(UFInnerframe.other, 30, 190, T.split_words(L["显示"],L["法力条"]), "dpsmana", L["显示法力条提示"])
	UFInnerframe.other.dpsmana.apply = function()
		T.EnableUFSettings({"Dpsmana"})
		T.ApplyUFSettings({"ClassPower"})
	end
end

if G.myClass == "MONK" then
	CreateDividingLine(UFInnerframe.other, -180)
    T.Checkbutton_db(UFInnerframe.other, 30, 190, L["显示醉拳条"], "stagger")
	UFInnerframe.other.dpsmana.apply = function()
		T.EnableUFSettings({"Stagger"})
	end
end

--====================================================--
--[[               -- Raid Frames --                ]]--
--====================================================--
local RFOptions = CreateOptionPage("RF Options", L["团队框架"], GUI, "VERTICAL")
local RFInnerframe = CreateInnerFrame(RFOptions)

-- 启用
RFInnerframe.common = CreateOptionPage("RF Options common", L["启用"], RFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(RFInnerframe.common, 30, 60, L["启用"], "enableraid")
RFInnerframe.common.enableraid.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.Slider_db(RFInnerframe.common, "long", 30, 110, L["团队规模"], "party_num", 1, 4, 8, 2)
RFInnerframe.common.party_num.apply = function()
	T.UpdateGroupSize()
	T.UpdateGroupfilter()
end

T.Checkbutton_db(RFInnerframe.common, 30, 150, COMPACT_UNIT_FRAME_PROFILE_HORIZONTALGROUPS, "hor_party")
RFInnerframe.common.hor_party.apply = function()
	T.UpdateGroupAnchor()
	T.UpdateGroupSize()
end

T.Checkbutton_db(RFInnerframe.common, 30, 180, COMPACT_UNIT_FRAME_PROFILE_KEEPGROUPSTOGETHER, "party_connected")
RFInnerframe.common.party_connected.apply = function()
	T.UpdateGroupfilter()
end

T.Checkbutton_db(RFInnerframe.common, 30, 210, L["未进组时显示"], "showsolo")
RFInnerframe.common.showsolo.apply = function()
	T.UpdateGroupfilter()
end

T.Checkbutton_db(RFInnerframe.common, 30, 240, USE_RAID_STYLE_PARTY_FRAMES, "raidframe_inparty")
RFInnerframe.common.raidframe_inparty.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.Checkbutton_db(RFInnerframe.common, 30, 270, T.split_words(L["显示"],PET), "showraidpet")
RFInnerframe.common.showraidpet.apply = function()
	T.UpdateGroupfilter()
end

T.Checkbutton_db(RFInnerframe.common, 30, 300, L["团队工具"], "raidtool")
RFInnerframe.common.raidtool.apply = function()
	T.UpdateRaidTools()
end

-- 样式
RFInnerframe.style = CreateOptionPage("RF Options style", L["样式"], RFInnerframe, "VERTICAL", "UnitframeOptions")

T.Slider_db(RFInnerframe.style, "long", 30, 80, L["高度"], "raidheight", 1, 10, 150, 1)
RFInnerframe.style.raidheight.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
	T.UpdateGroupSize()
end

T.Slider_db(RFInnerframe.style, "long", 30, 120, L["宽度"], "raidwidth", 1, 10, 150, 1)
RFInnerframe.style.raidwidth.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
	T.UpdateGroupSize()
end

T.Checkbutton_db(RFInnerframe.style, 30, 140, L["治疗法力条"], "raidmanabars")
RFInnerframe.style.raidmanabars.apply = T.UpdateHealManabar

T.Slider_db(RFInnerframe.style, "long", 30, 190, L["治疗法力条高度"], "raidppheight", 100, 5, 100, 5)
RFInnerframe.style.raidppheight.apply = function()
	T.ApplyUFSettings({"Power"})
end

T.createDR(RFInnerframe.style.raidmanabars, RFInnerframe.style.raidppheight)

T.Slider_db(RFInnerframe.style, "long", 30, 230, L["名字长度"], "namelength", 1, 2, 10, 1)
RFInnerframe.style.namelength.apply = function()
	T.UpdateUFTags('Altz_Healerraid')
end

T.Slider_db(RFInnerframe.style, "long", 30, 270, L["字体大小"], "raidfontsize", 1, 8, 20, 1)
RFInnerframe.style.raidfontsize.apply = function()
	T.ApplyUFSettings({"Tag_LFD", 'Tag_Name', 'Tag_Status'}, 'Altz_Healerraid')
end

T.Checkbutton_db(RFInnerframe.style, 30, 310, L["GCD"], "showgcd", L["GCD提示"])
RFInnerframe.style.showgcd.apply = function()
	T.EnableUFSettings({"GCD"})
end

T.Checkbutton_db(RFInnerframe.style, 30, 340, L["治疗和吸收预估"], "healprediction", L["治疗和吸收预估提示"])
RFInnerframe.style.healprediction.apply = function()
	T.EnableUFSettings({"HealthPrediction"})
end

T.Checkbutton_db(RFInnerframe.style, 30, 370, L["主坦克和主助手"], "raidrole_icon", L["主坦克和主助手提示"])
RFInnerframe.style.raidrole_icon.apply = function()
	T.EnableUFSettings({"RaidRoleIndicator"})
end

T.RadioButtonGroup_db(RFInnerframe.style, 30, 400, T.split_words(NAME,L["样式"]), "name_style", {
	{"missing_hp", NAME.."/"..L["缺失生命值"], L["缺失生命值提示"]},
	{"name", NAME},
	{"none", L["隐藏"]},
})
RFInnerframe.style.name_style.apply = function()
	T.UpdateUFTags('Altz_Healerraid')
end

-- 治疗指示器
RFInnerframe.ind = CreateOptionPage("RF Options indicators", L["治疗指示器"], RFInnerframe, "VERTICAL", "UnitframeOptions")

T.Slider_db(RFInnerframe.ind, "long", 30, 80, L["尺寸"], "hotind_size", 1, 10, 25, 1)
RFInnerframe.ind.hotind_size.apply = function()
	T.ApplyUFSettings({"AltzIndicators", "Auras"})
end

T.RadioButtonGroup_db(RFInnerframe.ind, 30, 100, L["样式"], "hotind_style", {
	{"number_ind", L["数字指示器"]},
	{"icon_ind", L["图标指示器"]},
})

RFInnerframe.ind.hotind_style.hook = function()
	if aCoreCDB["UnitframeOptions"]["hotind_style"] == "icon_ind" then
		RFInnerframe.ind.hotind_list:Show()
	else
		RFInnerframe.ind.hotind_list:Hide()
	end
end

RFInnerframe.ind.hotind_style.apply = function()
	T.EnableUFSettings({"AltzIndicators", "Auras"})
	RFInnerframe.ind.hotind_style.hook()
end
RFInnerframe.ind.hotind_style:HookScript("OnShow", RFInnerframe.ind.hotind_style.hook)

CreateDividingLine(RFInnerframe.ind, -135)

RFInnerframe.ind.hotind_list = T.CreateAuraListOption(RFInnerframe.ind, {"TOPLEFT", 30, -150}, 270,  L["图标指示器"]..L["设置"], "hotind_auralist")
RFInnerframe.ind.hotind_list.apply = function()
	T.ApplyUFSettings({"Auras"})
end

T.RadioButtonGroup_db(RFInnerframe.ind.hotind_list, -5, 40, L["过滤方式"], "hotind_filtertype", {
	{"whitelist", L["白名单"]..AURAS},
	{"blacklist", L["黑名单"]..AURAS},
})
table.insert(RFInnerframe.ind.hotind_list.options, RFInnerframe.ind.hotind_list.hotind_filtertype)

RFInnerframe.ind.hotind_list.reset.apply = function()
	aCoreCDB["UnitframeOptions"]["hotind_filtertype"] = nil
end

RFInnerframe.ind.hotind_list.option_list:ClearAllPoints()
RFInnerframe.ind.hotind_list.option_list:SetPoint("TOPLEFT", 0, -65)

-- 点击施法
RFInnerframe.clickcast = CreateOptionPage("RF Options clickcast", L["点击施法"], RFInnerframe, "VERTICAL", "UnitframeOptions")

T.Checkbutton_db(RFInnerframe.clickcast, 30, 60, L["启用"], "enableClickCast")
RFInnerframe.clickcast.enableClickCast.apply = function()
	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		T.RegisterClicksforAll()
	else
		T.UnregisterClicksforAll()
	end
end

-- 重置
RFInnerframe.clickcast.reset = T.ClickTexButton(RFInnerframe.clickcast, {"LEFT", RFInnerframe.clickcast.title, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])	
RFInnerframe.clickcast.reset:SetScript("OnClick", function(self)
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(L["点击施法"]))
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		aCoreCDB[RFInnerframe.clickcast.db_key]["ClickCast"] = nil
		ReloadUI()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

local clickcastframe = CreateFrame("Frame", G.uiname.."ClickCast Options", RFInnerframe.clickcast, "BackdropTemplate")
clickcastframe:SetPoint("TOPLEFT", 30, -120)
clickcastframe:SetPoint("BOTTOMRIGHT", -30, 20)
T.setBackdrop(clickcastframe, 0)

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
	value = aCoreCDB["UnitframeOptions"]["ClickCast"][arg1][arg2][key]
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
	aCoreCDB["UnitframeOptions"]["ClickCast"][arg1][arg2][key] = value
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
	macro_input.expand_bu = T.ClickTexButton(macro_input, {"LEFT", macro_input, "RIGHT", 0, 0}, [[Interface\AddOns\AltzUI\media\icons\EJ.tga]], nil, 20, EDIT)		
	
	local macro_box = T.EditboxMultiLine(macro_input, nil, 150)
	macro_box.bg:SetBackdropColor(0, 0, 0, 1)
	macro_box:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	macro_box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -25, -10)
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
		macro_box:Show()
	end)
end

local function CreateClickcastKeyOptions(bu_tag, text)
	local frame = CreateOptionPage("ClickCast Button"..bu_tag, text, clickcastframe, "HORIZONTAL", "UnitframeOptions")
	frame.title:Hide()
	frame.line:Hide()
	frame.options = {}
	
	for mod_ind, mod_name in pairs(G.modifier) do
		frame.options[mod_ind] = {}
		
		local mod_text = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
		mod_text:SetPoint("TOPLEFT", 25, 10-mod_ind*35)
		mod_text:SetText(mod_name)
		mod_text:SetWidth(40)
		frame.options[mod_ind].mod_text = mod_text
		
		-- 动作
		local action_select = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
		action_select:SetPoint("LEFT", mod_text, "RIGHT", -5, -3)
		action_select.Text:SetFont(G.norFont, 12, "OUTLINE")
		T.ReskinDropDown(action_select)
		UIDropDownMenu_SetWidth(action_select, 100)

		UIDropDownMenu_Initialize(action_select, function()
			for i, t in pairs(actions) do
				local info = UIDropDownMenu_CreateInfo()
				info.value = t[1]
				info.text = t[2]
				info.func = function()
					UIDropDownMenu_SetSelectedValue(action_select, info.value)
					ApplyClickcastValue(bu_tag, mod_ind, "action", info.value)					
					UpdateClickCast(bu_tag, mod_ind)
					frame.options[mod_ind].spell_select:SetShown(info.value == "spell")
					frame.options[mod_ind].item_input:SetShown(info.value == "item")
					frame.options[mod_ind].macro_input:SetShown(info.value == "macro")
				end
				UIDropDownMenu_AddButton(info)
			end
			
			local action = GetClickcastValue(bu_tag, mod_ind, "action")
			UIDropDownMenu_SetSelectedValue(action_select, action)
		end)
		
		frame.options[mod_ind].action_select = action_select
		
		-- 法术
		local spell_select = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
		spell_select:SetPoint("LEFT", action_select, "RIGHT", -25, 0)
		spell_select.Text:SetFont(G.norFont, 12, "OUTLINE")
		T.ReskinDropDown(spell_select)
		UIDropDownMenu_SetWidth(spell_select, 130)
		
		UIDropDownMenu_Initialize(spell_select, function()
			for i, spellID in pairs(G.ClickCastSpells) do
				local spellName, _, spellIcon = GetSpellInfo(spellID)
				local info = UIDropDownMenu_CreateInfo()
				info.value = spellName
				info.text = T.GetSpellIcon(spellID).." "..spellName
				info.func = function()
					UIDropDownMenu_SetSelectedValue(spell_select, info.value)
					ApplyClickcastValue(bu_tag, mod_ind, "spell", info.value)
					UpdateClickCast(bu_tag, mod_ind)
				end
				UIDropDownMenu_AddButton(info)
			end

			local spell = GetClickcastValue(bu_tag, mod_ind, "spell")
			UIDropDownMenu_SetSelectedValue(spell_select, spell)		
		end)
		
		frame.options[mod_ind].spell_select = spell_select
		
		-- 物品
		local item_input = T.EditboxWithText(frame, {"LEFT", action_select, "RIGHT", -14, 2}, L["物品名称ID链接"], 140, true)
		
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
		local macro_input = T.EditboxWithText(frame, {"LEFT", action_select, "RIGHT", -14, 2}, L["输入一个宏"], 140)
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
	
	T.createDR(RFInnerframe.clickcast.enableClickCast, frame)
end

T.RegisterInitCallback(function()
	for i, info in pairs(click_buttons) do
		CreateClickcastKeyOptions(unpack(info))
	end
end)

-- 光环图标
RFInnerframe.icon_display = CreateOptionPage("RF Options Icon Display", L["光环"]..L["图标"], RFInnerframe, "VERTICAL", "UnitframeOptions")

CreateTitle(RFInnerframe.icon_display, 50, -65, L["Debuffs"], 18, {1, .5, .3})

T.Slider_db(RFInnerframe.icon_display, "short", 60, 100, "X", "raid_debuff_anchor_x", 1, -50, 50, 1)
RFInnerframe.icon_display.raid_debuff_anchor_x.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

T.Slider_db(RFInnerframe.icon_display, "short", 260, 100, "Y", "raid_debuff_anchor_y", 1, -50, 50, 1)
RFInnerframe.icon_display.raid_debuff_anchor_y.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

T.Slider_db(RFInnerframe.icon_display, "short", 60, 140, L["图标大小"], "raid_debuff_icon_size", 1, 10, 40, 1)
RFInnerframe.icon_display.raid_debuff_icon_size.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

T.Slider_db(RFInnerframe.icon_display, "short", 260, 140, L["图标数量"], "raid_debuff_num", 1, 1, 5, 1)
RFInnerframe.icon_display.raid_debuff_num.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

CreateTitle(RFInnerframe.icon_display, 50, -175, L["Buffs"], 18, {.3, 1, .5})

T.Slider_db(RFInnerframe.icon_display, "short", 60, 210, "X", "raid_buff_anchor_x", 1, -50, 50, 1)
RFInnerframe.icon_display.raid_buff_anchor_x.apply = function()
	T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
end

T.Slider_db(RFInnerframe.icon_display, "short", 260, 210, "Y", "raid_buff_anchor_y", 1, -50, 50, 1)
RFInnerframe.icon_display.raid_buff_anchor_y.apply = function()
	T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
end

T.Slider_db(RFInnerframe.icon_display, "short", 60, 250, L["图标大小"], "raid_buff_icon_size", 1, 10, 40, 1)
RFInnerframe.icon_display.raid_buff_icon_size.apply = function()
	T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
end

T.Slider_db(RFInnerframe.icon_display, "short", 260, 250, L["图标数量"], "raid_buff_num", 1, 1, 5, 1)
RFInnerframe.icon_display.raid_buff_num.apply = function()
	T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
end

CreateDividingLine(RFInnerframe.icon_display, -280)

T.Checkbutton_db(RFInnerframe.icon_display, 60, 300, L["自动添加团队减益"], "debuff_auto_add", L["自动添加团队减益提示"])
T.Slider_db(RFInnerframe.icon_display, "long", 60, 350, L["自动添加的图标层级"], "debuff_auto_add_level", 1, 1, 20, 1)

-- 团队减益
RFInnerframe.raiddebuff = CreateOptionPage("RF Options Raid Debuff", L["副本减益"], RFInnerframe, "VERTICAL", "UnitframeOptions")

RFInnerframe.raiddebuff.debuff_list = T.createscrolllist(RFInnerframe.raiddebuff, {"TOPLEFT", 10, -85}, false, 395, 400)

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
		local frame = T.createscrollbutton("spell", option_list, nil, nil, spellID)
		frame:SetWidth(380)
		
		frame.close:SetScript("OnClick", function() 
			frame:Hide()
			aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID][spellID] = nil
			option_list.apply()
		end)
		
		frame:SetScript("OnMouseDown", function(self)
			UIDropDownMenu_SetSelectedValue(option_list.encounterDD, encounterID)	
			option_list.spell_input:SetText(spellID)
			option_list.spell_input.current_spellID = spellID
			option_list.level_input:SetText(level)
		end)
		
		option_list.spells["icon"..encounterID.."_"..spellID] = frame
	end
	
	local spellName, _, spellIcon = GetSpellInfo(spellID)
	
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
		if aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID] and aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID] then
			for spellID, level in pairs (aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID]) do
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
	option_list.apply = function()
		DisplayRaidDebuffList()
		T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
	end
	
	-- 重置
	option_list.reset = T.ClickTexButton(option_list, {"LEFT", parent.title, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])	
	option_list.reset:SetScript("OnClick", function(self)
		local InstanceName = EJ_GetInstanceInfo(parent.selected_InstanceID)
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(InstanceName))
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID] = nil
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)
	
	-- 返回
	option_list.back = T.ClickTexButton(option_list, {"LEFT", parent.title, "RIGHT", 270, 0}, [[Interface\AddOns\AltzUI\media\refresh.tga]], BACK)
	T.SetupArrow(option_list.back.tex, "left")
	T.SetupArrow(option_list.back.hl_tex, "left")
	
	option_list.back:SetScript("OnClick", function() 
		option_list:Hide()
		parent.instance_list:Show()
	end)
	
	-- 首领下拉菜单
	option_list.encounterDD = CreateFrame("Frame", nil, option_list, "UIDropDownMenuTemplate")
	option_list.encounterDD:SetPoint("BOTTOMLEFT", option_list, "TOPLEFT", 0, 2)
	option_list.encounterDD.Text:SetFont(G.norFont, 12, "OUTLINE")
	T.ReskinDropDown(option_list.encounterDD)
	UIDropDownMenu_SetWidth(option_list.encounterDD, 120)
	
	-- 法术ID输入框
	option_list.spell_input = T.EditboxWithText(option_list, {"LEFT", option_list.encounterDD, "RIGHT", -5, 2}, L["输入法术ID"], 100)
	function option_list.spell_input:apply()
		if self.current_spellID then
			return true
		else
			local spellText = self:GetText()		
			local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(spellText)
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
	option_list.level_input = T.EditboxWithText(option_list, {"LEFT", option_list.spell_input, "RIGHT", 5, 0}, L["优先级"], 100)
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
	option_list.add = T.ClickButton(option_list, 0, {"LEFT", option_list.level_input, "RIGHT", 5, 0}, ADD)
	option_list.add:SetScript("OnClick", function(self)
		option_list.spell_input:GetScript("OnEnterPressed")(option_list.spell_input)
		option_list.level_input:GetScript("OnEnterPressed")(option_list.level_input)
		if not option_list.spell_input:apply() or not option_list.level_input:apply() then return end
		
		local encounterID = UIDropDownMenu_GetSelectedValue(option_list.encounterDD)
		local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(option_list.spell_input.current_spellID)
		local level = option_list.level_input:GetText()
		
		if not aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID] then
			aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID] = {}
		end
		
		aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID][spellID] = level		
		option_list.apply()
		
		option_list.spell_input:SetText(L["输入法术ID"])
		option_list.spell_input.current_spellID = nil
		option_list.level_input:SetText(L["优先级"])
	end)
end

local CreateInstanceButton = function(frame, instanceID, instanceName, bgImage)
	local parent = RFInnerframe.raiddebuff
	local bu = T.ClickButton(frame.anchor, 150, nil, instanceName, bgImage)
	
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
		
		UIDropDownMenu_Initialize(option_list.encounterDD, function()
			local dataIndex = 1
			EJ_SelectInstance(parent.selected_InstanceID)
			local encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(dataIndex, parent.selected_InstanceID)
			
			while encounterName ~= nil do
				local info = UIDropDownMenu_CreateInfo()
				info.text = encounterName
				info.value = encounterID
				info.func = function()
					UIDropDownMenu_SetSelectedValue(option_list.encounterDD, info.value)
				end
				UIDropDownMenu_AddButton(info)
				
				dataIndex = dataIndex + 1
				encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(dataIndex, parent.selected_InstanceID)
			end
			
			local info = UIDropDownMenu_CreateInfo()
			info.text = L["杂兵"]
			info.value = 1
			info.func = function()
				UIDropDownMenu_SetSelectedValue(option_list.encounterDD, 1)
			end
			UIDropDownMenu_AddButton(info)
		end)
		
		local first_encounterID = select(3, EJ_GetEncounterInfoByIndex(1, parent.selected_InstanceID))
		UIDropDownMenu_SetSelectedValue(option_list.encounterDD, first_encounterID)
		
		DisplayRaidDebuffList()
	end)
	
	if not aCoreCDB[parent.db_key]["raid_debuffs"][instanceID] then
		aCoreCDB[parent.db_key]["raid_debuffs"][instanceID] = {}
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
		if i ~= tier_num then -- 当前赛季没有团本
			instanceID, instanceName, _, _, _, _, bgImage = EJ_GetInstanceByIndex(raid_i, true)
			while instanceID ~= nil do
				CreateInstanceButton(self, instanceID, instanceName, bgImage)
			
				raid_i = raid_i + 1
				instanceID, instanceName, _, _, _, _, bgImage = EJ_GetInstanceByIndex(raid_i, true)
			end
		end
		
		self.y = self.y - 10
	end
	
	self.init = true
end)

-- 待测试
hooksecurefunc("SetItemRef", function(link, text)
  if link:find("garrmission:altz") then
	local InstanceID, encounterID, spellID = string.match(text, "altz::([^%]]+)%::([^%]]+)%::([^%]]+)%|h|c")
	
	InstanceID = tonumber(InstanceID)
	encounterID = tonumber(encounterID)
	spellID = tonumber(spellID)

	if string.find(text, "config") then	
		GUI:Show()
		GUI.df:Show()
		GUI.scale:Show()
		
		RFOptions.hooked_tab:GetScript("OnMouseDown")()	
		RFInnerframe.raiddebuff.hooked_tab:GetScript("OnMouseDown")()
		RFInnerframe.raiddebuff.instance_list.list[InstanceID]:GetScript("OnMouseDown")()
		RFInnerframe.raiddebuff.debuff_list.spells["icon"..encounterID.."_"..spellID]:GetScript("OnMouseDown")()
				
	elseif string.find(text, "delete") then
		if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] then
			aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] = nil
			aCoreCDB["UnitframeOptions"]["debuff_list_black"][spellID] = true
			print(string.format(L["已删除并加入黑名单"], T.GetIconLink(spellID)))
		end
	end
  end
end)

-- 全局减益
RFInnerframe.globaldebuff = CreateOptionPage("RF Options Raid Debuff Fliter List", T.split_words(L["全局"], L["减益"]), RFInnerframe, "VERTICAL", "UnitframeOptions")

RFInnerframe.globaldebuff.whitelist = T.CreateAuraListOption(RFInnerframe.globaldebuff, {"TOPLEFT", 30, -55}, 200,  L["白名单"]..AURAS, "debuff_list", L["优先级"])
RFInnerframe.globaldebuff.whitelist.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

CreateDividingLine(RFInnerframe.globaldebuff, -250)

RFInnerframe.globaldebuff.blacklist = T.CreateAuraListOption(RFInnerframe.globaldebuff, {"TOPLEFT", RFInnerframe.globaldebuff.whitelist, "BOTTOMLEFT", 0, -10}, 200, L["黑名单"]..AURAS, "debuff_list_black")
RFInnerframe.globaldebuff.blacklist.apply = function()
	T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
end

-- 全局增益
RFInnerframe.globalbuff = CreateOptionPage("RF Options Cooldown Aura", T.split_words(L["全局"], L["增益"]), RFInnerframe, "VERTICAL", "UnitframeOptions")

RFInnerframe.globalbuff.whitelist = T.CreateAuraListOption(RFInnerframe.globalbuff, {"TOPLEFT", 30, -60}, 380, L["白名单"]..AURAS, "buff_list", L["优先级"])
RFInnerframe.globalbuff.whitelist.apply = function()
	T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
end
--====================================================--
--[[           -- Actionbar Options --              ]]--
--====================================================--
local ActionbarOptions = CreateOptionPage("Actionbar Options", ACTIONBARS_LABEL, GUI, "VERTICAL")
local ActionbarInnerframe = CreateInnerFrame(ActionbarOptions)

-- 样式
ActionbarInnerframe.common = CreateOptionPage("Actionbar Options common", L["样式"], ActionbarInnerframe, "VERTICAL", "ActionbarOptions")

T.Checkbutton_db(ActionbarInnerframe.common, 30, 60, L["显示冷却时间"], "cooldown_number", L["显示冷却时间提示"])

T.Checkbutton_db(ActionbarInnerframe.common, 30, 90, L["显示冷却时间"].." (Weakauras)", "cooldown_number_wa", L["显示冷却时间提示WA"])

T.Slider_db(ActionbarInnerframe.common, "long", 30, 140, L["冷却时间数字大小"], "cooldownsize", 1, 18, 35, 1, L["冷却时间数字大小提示"])
ActionbarInnerframe.common.cooldownsize.apply = T.CooldownNumber_Edit

T.createDR(ActionbarInnerframe.common.cooldown_number, ActionbarInnerframe.common.cooldown_number_wa, ActionbarInnerframe.common.cooldownsize)

CreateDividingLine(ActionbarInnerframe.common, -165)

T.Checkbutton_db(ActionbarInnerframe.common, 30, 180, L["不可用颜色"], "rangecolor", L["不可用颜色提示"])

T.Slider_db(ActionbarInnerframe.common, "long", 30, 230, L["键位字体大小"], "keybindsize", 1, 8, 20, 1)
ActionbarInnerframe.common.keybindsize.apply = function()
	T.UpdateActionbarsFontSize()
end

T.Slider_db(ActionbarInnerframe.common, "long", 30, 270, L["宏名字字体大小"], "macronamesize", 1, 8, 20, 1)
ActionbarInnerframe.common.macronamesize.apply = function()
	T.UpdateActionbarsFontSize()
end

T.Slider_db(ActionbarInnerframe.common, "long", 30, 310, L["可用次数字体大小"], "countsize", 1, 8, 20, 1)
ActionbarInnerframe.common.countsize.apply = function()
	T.UpdateActionbarsFontSize()
end

CreateDividingLine(ActionbarInnerframe.common, -335)

T.Checkbutton_db(ActionbarInnerframe.common, 30, 350, L["条件渐隐"], "enablefade", L["条件渐隐提示"])
ActionbarInnerframe.common.enablefade.apply = T.ApplyActionbarFadeEnable

T.RadioButtonGroup_db(ActionbarInnerframe.common, 40, 380, "", "fadingalpha_type", {
	{"uf", T.split_words(USE, L["单位框架"], L["渐隐透明度"])},
	{"custom", T.split_words(CUSTOM, L["渐隐透明度"])},
})

T.Slider_db(ActionbarInnerframe.common, "long", 50, 430, L["渐隐透明度"], "fadingalpha", 100, 0, 80, 5, L["渐隐透明度提示"])
ActionbarInnerframe.common.fadingalpha.apply = T.ApplyActionbarFadeAlpha

ActionbarInnerframe.common.fadingalpha_type.hook = function()
	if aCoreCDB["ActionbarOptions"]["fadingalpha_type"] == "custom" then
		ActionbarInnerframe.common.fadingalpha:Show()
	else
		ActionbarInnerframe.common.fadingalpha:Hide()
	end
end

ActionbarInnerframe.common.fadingalpha_type.apply = function()
	T.ApplyActionbarFadeAlpha()
	ActionbarInnerframe.common.fadingalpha_type.hook()
end
ActionbarInnerframe.common.fadingalpha_type:HookScript("OnShow", ActionbarInnerframe.common.fadingalpha_type.hook)

T.createDR(ActionbarInnerframe.common.enablefade, ActionbarInnerframe.common.fadingalpha_type, ActionbarInnerframe.common.fadingalpha)


-- 冷却提示
ActionbarInnerframe.cdflash = CreateOptionPage("Actionbar Options cdflash", L["冷却提示"], ActionbarInnerframe, "VERTICAL", "ActionbarOptions")
T.Checkbutton_db(ActionbarInnerframe.cdflash, 30, 60, L["启用"], "cdflash_enable")

T.Slider_db(ActionbarInnerframe.cdflash, "short", 30, 100, L["图标大小"], "cdflash_size", 1, 15, 100, 1)

CreateDividingLine(ActionbarInnerframe.cdflash, -120)

ActionbarInnerframe.cdflash.ignorespell_list = T.CreateAuraListOption(ActionbarInnerframe.cdflash, {"TOPLEFT", 30, -125}, 185, L["黑名单"]..SPELLS, "cdflash_ignorespells")

CreateDividingLine(ActionbarInnerframe.cdflash, -290)

ActionbarInnerframe.cdflash.ignoreitem_list = T.CreateItemListOption(ActionbarInnerframe.cdflash, {"TOPLEFT", 30, -300}, 185, L["黑名单"]..ITEMS, "cdflash_ignoreitems")

T.createDR(ActionbarInnerframe.cdflash.cdflash_enable, ActionbarInnerframe.cdflash.cdflash_size, 
ActionbarInnerframe.cdflash.ignorespell_list, ActionbarInnerframe.cdflash.ignoreitem_list)

--====================================================--
--[[           -- NamePlates Options --             ]]--
--====================================================--
local PlateOptions = CreateOptionPage("Plate Options", UNIT_NAMEPLATES, GUI, "VERTICAL")
local PlateInnerframe = CreateInnerFrame(PlateOptions)

-- 通用
PlateInnerframe.common = CreateOptionPage("Nameplates Options common", L["通用设置"], PlateInnerframe, "VERTICAL", "PlateOptions")

T.Checkbutton_db(PlateInnerframe.common, 30, 60, L["启用"], "enableplate")
PlateInnerframe.common.enableplate.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.Slider_db(PlateInnerframe.common, "long", 30, 110, T.split_words(NAME,L["字体大小"]), "namefontsize", 1, 5, 25, 1)
PlateInnerframe.common.namefontsize.apply = function()
	T.ApplyUFSettings({"Tag_Name", "Health", "Power"}, "Altz_Nameplates")
end

T.Slider_db(PlateInnerframe.common, "long", 30, 150, T.split_words(L["光环"],L["图标数量"]), "plateauranum", 1, 3, 10, 1)
PlateInnerframe.common.plateauranum.apply = function()
	T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
end

T.Slider_db(PlateInnerframe.common, "long", 30, 190, T.split_words(L["光环"],L["图标大小"]), "plateaurasize", 1, 10, 30, 1)
PlateInnerframe.common.plateaurasize.apply = function()
	T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
end

T.Colorpicker_db(PlateInnerframe.common, 30, 220, T.split_words(L["可打断"],L["施法条"],L["颜色"]), "Interruptible_color")

T.Colorpicker_db(PlateInnerframe.common, 230, 220, T.split_words(L["不可打断"],L["施法条"],L["颜色"]), "notInterruptible_color")

T.Checkbutton_db(PlateInnerframe.common, 30, 250, L["焦点染色"], "focuscolored")
PlateInnerframe.common.focuscolored.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

T.Colorpicker_db(PlateInnerframe.common, 230, 250, T.split_words(L["焦点"],L["颜色"]), "focus_color")
PlateInnerframe.common.focus_color.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

T.createDR(PlateInnerframe.common.focuscolored, PlateInnerframe.common.focus_color)

T.Checkbutton_db(PlateInnerframe.common, 30, 280, L["仇恨染色"], "threatcolor")
PlateInnerframe.common.threatcolor.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

T.CVarCheckbutton(PlateInnerframe.common, 30, 310, "nameplateShowAll", UNIT_NAMEPLATES_AUTOMODE, "1", "0")

T.Checkbutton_db(PlateInnerframe.common, 30, 340, L["友方只显示名字"], "bar_onlyname")
PlateInnerframe.common.bar_onlyname.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
	T.PostUpdateAllPlates()
end

T.createDR(PlateInnerframe.common.enableplate,
PlateInnerframe.common.namefontsize, PlateInnerframe.common.plateauranum, PlateInnerframe.common.plateaurasize,
PlateInnerframe.common.Interruptible_color, PlateInnerframe.common.notInterruptible_color,
PlateInnerframe.common.focuscolored, PlateInnerframe.common.focus_color, 
PlateInnerframe.common.threatcolor, PlateInnerframe.common.nameplateShowAll, PlateInnerframe.common.bar_onlyname)

-- 样式
PlateInnerframe.style = CreateOptionPage("Nameplates Options common", L["样式"], PlateInnerframe, "VERTICAL", "PlateOptions")

T.RadioButtonGroup_db(PlateInnerframe.style, 30, 60, L["样式"], "theme", {
	{"class", L["职业色-条形"]},
	{"dark", L["深色-条形"]},
	{"number", L["数字样式"]},
})

PlateInnerframe.style.theme.hook = function()
	if aCoreCDB["PlateOptions"]["theme"] == "number" then
		PlateInnerframe.style.bar_width:Hide()
		PlateInnerframe.style.bar_height:Hide()
		PlateInnerframe.style.valuefontsize:Hide()
		PlateInnerframe.style.bar_hp_perc:Hide()
		PlateInnerframe.style.bar_alwayshp:Hide()
		
		PlateInnerframe.style.number_size:Show()
		PlateInnerframe.style.number_alwayshp:Show()
		PlateInnerframe.style.number_colorheperc:Show()
	else
		PlateInnerframe.style.bar_width:Show()
		PlateInnerframe.style.bar_height:Show()
		PlateInnerframe.style.valuefontsize:Show()
		PlateInnerframe.style.bar_hp_perc:Show()
		PlateInnerframe.style.bar_alwayshp:Show()
	
		PlateInnerframe.style.number_size:Hide()
		PlateInnerframe.style.number_alwayshp:Hide()
		PlateInnerframe.style.number_colorheperc:Hide()
	end
end

PlateInnerframe.style.theme.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Castbar", "Auras", "ClassPower", "Runes", "Tag_Name"}, "Altz_Nameplates")	
	T.PostUpdateAllPlates()
	PlateInnerframe.style.theme.hook()
end
PlateInnerframe.style.theme:HookScript("OnShow", PlateInnerframe.style.theme.hook)

CreateDividingLine(PlateInnerframe.style, -95)

-- 条形样式的选项
T.Slider_db(PlateInnerframe.style, "long", 30, 125, L["宽度"], "bar_width", 1, 70, 150, 5)
PlateInnerframe.style.bar_width.apply = function()
	T.ApplyUFSettings({"Health", "Castbar", "Auras"}, "Altz_Nameplates")
end

T.Slider_db(PlateInnerframe.style, "long", 30, 165, L["高度"], "bar_height", 1, 5, 25, 1)
PlateInnerframe.style.bar_height.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Castbar"}, "Altz_Nameplates")
end

T.Slider_db(PlateInnerframe.style, "long", 30, 205, L["数值"]..L["字体大小"], "valuefontsize", 1, 5, 25, 1)
PlateInnerframe.style.valuefontsize.apply = function()
	T.ApplyUFSettings({"Tag_Name", "Health", "Power"}, "Altz_Nameplates")
end

T.RadioButtonGroup_db(PlateInnerframe.style, 30, 225, L["数值"]..L["样式"], "bar_hp_perc", {
	{"perc", L["百分比"]},
	{"value_perc", L["数值"].."+"..L["百分比"]},
})
PlateInnerframe.style.bar_hp_perc.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

T.Checkbutton_db(PlateInnerframe.style, 30, 255, L["总是显示生命值"], "bar_alwayshp", L["总是显示生命值提示"])
PlateInnerframe.style.bar_alwayshp.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

-- 数值样式的选项
T.Slider_db(PlateInnerframe.style, "long", 30, 125, string.format("%s(%s)", L["字体大小"], L["数字样式"]), "number_size", 1, 15, 35, 1)
PlateInnerframe.style.number_size.apply = function()
	T.ApplyUFSettings({"Health", "Power", "ClassPower"}, "Altz_Nameplates")
end

T.Checkbutton_db(PlateInnerframe.style, 30, 165, string.format("%s(%s)", L["总是显示生命值"],L["数字样式"]), "number_alwayshp", L["总是显示生命值提示"])
PlateInnerframe.style.number_alwayshp.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

T.Checkbutton_db(PlateInnerframe.style, 30, 195, string.format("%s(%s)", L["根据血量染色"],L["数字样式"]), "number_colorheperc")
PlateInnerframe.style.number_colorheperc.apply = function()
	T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
end

-- 玩家姓名板
PlateInnerframe.playerresource = CreateOptionPage("Player Resource Bar Options", L["玩家姓名板"], PlateInnerframe, "VERTICAL", "PlateOptions")

T.Checkbutton_db(PlateInnerframe.playerresource, 30, 60, T.split_words(L["显示"],L["玩家姓名板"]), "playerplate")
PlateInnerframe.playerresource.playerplate.apply = function()
	if aCoreCDB["PlateOptions"]["playerplate"] then
		SetCVar("nameplateShowSelf", 1)
	else
		SetCVar("nameplateShowSelf", 0)
	end
	T.PostUpdateAllPlates()
end

T.Checkbutton_db(PlateInnerframe.playerresource, 50, 90, T.split_words(L["显示"],PLAYER,L["施法条"]), "platecastbar")
PlateInnerframe.playerresource.platecastbar.apply = T.PostUpdateAllPlates

T.Checkbutton_db(PlateInnerframe.playerresource, 50, 120, DISPLAY_PERSONAL_RESOURCE, "classresource_show")
PlateInnerframe.playerresource.classresource_show.apply = T.PostUpdateAllPlates

T.createDR(PlateInnerframe.playerresource.playerplate, PlateInnerframe.playerresource.platecastbar, PlateInnerframe.playerresource.classresource_show)

-- 光环过滤列表
PlateInnerframe.auralist = CreateOptionPage("Plate Options Aura", L["光环"], PlateInnerframe, "VERTICAL", "PlateOptions")

PlateInnerframe.auralist.my_filter = T.CreateAuraListOption(PlateInnerframe.auralist, {"TOPLEFT", 30, -55}, 200, L["我施放的光环"], "myplateauralist")

T.RadioButtonGroup_db(PlateInnerframe.auralist.my_filter, -5, 40, L["过滤方式"], "myfiltertype", {
	{"none", L["全部隐藏"]},
	{"whitelist", L["白名单"]..AURAS},
	{"blacklist", L["黑名单"]..AURAS},
})

PlateInnerframe.auralist.my_filter.apply = function()
	T.ApplyUFSettings({"Auras"})
end
PlateInnerframe.auralist.my_filter.reset.apply = function()
	aCoreCDB["PlateOptions"]["myfiltertype"] = nil
end

PlateInnerframe.auralist.my_filter.option_list:ClearAllPoints()
PlateInnerframe.auralist.my_filter.option_list:SetPoint("TOPLEFT", 0, -65)

CreateDividingLine(PlateInnerframe.auralist, -260)

PlateInnerframe.auralist.other_filter = T.CreateAuraListOption(PlateInnerframe.auralist, {"TOPLEFT", 30, -265}, 200, L["其他人施放的光环"], "otherplateauralist")

T.RadioButtonGroup_db(PlateInnerframe.auralist.other_filter, -5, 40, L["过滤方式"], "otherfiltertype", {
	{"none", L["全部隐藏"]},
	{"whitelist", L["白名单"]..AURAS},
})

PlateInnerframe.auralist.other_filter.apply = function()
	T.ApplyUFSettings({"Auras"})
end
PlateInnerframe.auralist.other_filter.reset.apply = function()
	aCoreCDB["PlateOptions"]["otherfiltertype"] = nil
end

PlateInnerframe.auralist.other_filter.option_list:ClearAllPoints()
PlateInnerframe.auralist.other_filter.option_list:SetPoint("TOPLEFT", 0, -65)

-- 自定义
PlateInnerframe.custom = CreateOptionPage("Plate Options Custom", CUSTOM, PlateInnerframe, "VERTICAL", "PlateOptions")

PlateInnerframe.custom.color = T.CreatePlateColorListOption(PlateInnerframe.custom,  {"TOPLEFT", 30, -55}, 200, L["自定义颜色"], "customcoloredplates")
PlateInnerframe.custom.color.apply = T.PostUpdateAllPlates

PlateInnerframe.custom.power = T.CreatePlatePowerListOption(PlateInnerframe.custom,  {"TOPLEFT", PlateInnerframe.custom.color, "BOTTOMLEFT", 0, -10}, 200, L["自定义能量"], "custompowerplates")
PlateInnerframe.custom.power.apply = T.PostUpdateAllPlates

--====================================================--
--[[             -- Combattext Options --              ]]--
--====================================================--
local CombattextOptions = CreateOptionPage("CombatText Options", L["战斗数字"], GUI, "VERTICAL", "CombattextOptions")

CreateTitle(CombattextOptions, 30, -70, L["滚动战斗数字"])

T.Checkbutton_db(CombattextOptions, 30, 90, L["承受伤害/治疗"], "showreceivedct")
CombattextOptions.showreceivedct.apply = function()
	if aCoreCDB["CombattextOptions"]["showreceivedct"] then
		T.RestoreDragFrame(G.CombatText_Frames.damagetaken)
		T.RestoreDragFrame(G.CombatText_Frames.healingtaken)
		G.CombatText_Frames:RegisterEvent("COMBAT_TEXT_UPDATE")
	else
		T.ReleaseDragFrame(G.CombatText_Frames.damagetaken)
		T.RestoreDragFrame(G.CombatText_Frames.healingtaken)
		G.CombatText_Frames:RegisterEvent("COMBAT_TEXT_UPDATE")
	end
end

T.Checkbutton_db(CombattextOptions, 230, 90, L["输出伤害/治疗"], "showoutputct")
CombattextOptions.showoutputct.apply = function()
	if aCoreCDB["CombattextOptions"]["showoutputct"] then
		T.RestoreDragFrame(G.CombatText_Frames.outputdamage)
		T.RestoreDragFrame(G.CombatText_Frames.outputhealing)
		G.CombatText_Frames:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		T.ReleaseDragFrame(G.CombatText_Frames.outputdamage)
		T.RestoreDragFrame(G.CombatText_Frames.outputhealing)
		G.CombatText_Frames:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

T.Checkbutton_db(CombattextOptions, 30, 120, L["显示DOT"], "ctshowdots")
T.Checkbutton_db(CombattextOptions, 230, 120, L["显示HOT"], "ctshowhots")
T.Checkbutton_db(CombattextOptions, 30, 150, T.split_words(L["显示"],PET), "ctshowpet")

CreateDividingLine(CombattextOptions, -190)
CreateTitle(CombattextOptions, 30, -200, L["浮动战斗数字"])

T.CVarCheckbutton(CombattextOptions, 30, 220, "floatingCombatTextCombatDamage", T.split_words(L["显示"], L["受到伤害"], L["战斗数字"]), "1", "0")
T.CVarCheckbutton(CombattextOptions, 30, 250, "floatingCombatTextCombatHealing", T.split_words(L["显示"], L["受到治疗"], L["战斗数字"]), "1", "0")
T.CVarCheckbutton(CombattextOptions, 30, 280, "enableFloatingCombatText", T.split_words(L["显示"], L["造成伤害和治疗"], L["战斗数字"]), "1", "0")

local combattextfont_group = {
	{"none", DEFAULT},
	{"combat1", "1234"},
	{"combat2", "1234"},
	{"combat3", "1234"},
}

T.RadioButtonGroup_db(CombattextOptions, 30, 310, L["字体"], "combattext_font", combattextfont_group)
for i, info in pairs(combattextfont_group) do
	local bu = CombattextOptions.combattext_font.buttons[i]
	local index = string.match(info[1], "%d")
	if index then
		bu.text:SetFont(G["combatFont"..index], 12, "OUTLINE")
	end
end

CombattextOptions.combattext_font.apply = function()
	if not CombattextOptions.combattext_font.alert then
		StaticPopup_Show("CLIENT_RESTART_ALERT")
		CombattextOptions.combattext_font.alert = true
	end
end
--====================================================--
--[[              -- Other Options --                ]]--
--====================================================--
local OtherOptions = CreateOptionPage("Other Options", OTHER, GUI, "VERTICAL", "OtherOptions")

CreateTitle(OtherOptions, 30, -70, L["鼠标提示"])
T.Checkbutton_db(OtherOptions, 30, 90, T.split_words(L["鼠标提示"],L["显示"],L["法术编号"]), "show_spellID")
T.Checkbutton_db(OtherOptions, 230, 90, T.split_words(L["鼠标提示"],L["显示"],L["物品编号"]), "show_itemID")
T.Checkbutton_db(OtherOptions, 30, 120, T.split_words(L["战斗中隐藏"],L["鼠标提示"]), "combat_hide")

CreateDividingLine(OtherOptions, -160)
CreateTitle(OtherOptions, 30, -170, L["讯息提示"])

T.Checkbutton_db(OtherOptions, 30, 190, L["任务栏闪动"], "flashtaskbar", L["任务栏闪动提示"])
T.Checkbutton_db(OtherOptions, 230, 190, L["隐藏错误提示"], "hideerrors", L["隐藏错误提示提示"])
T.Checkbutton_db(OtherOptions, 30, 220, L["随机奖励"], "LFGRewards", L["随机奖励提示"])
T.Checkbutton_db(OtherOptions, 230, 220, L["稀有警报"], "vignettealert", L["稀有警报提示"])

CreateDividingLine(OtherOptions, -260)
CreateTitle(OtherOptions, 30, -270, L["辅助功能"])

T.Checkbutton_db(OtherOptions, 30, 290, L["成就截图"], "autoscreenshot", L["成就截图提示"])
T.CVarCheckbutton(OtherOptions, 230, 290, "screenshotQuality", L["提升截图画质"], "10", "1")
T.Checkbutton_db(OtherOptions, 30, 320, L["战场自动释放灵魂"], "battlegroundres", L["战场自动释放灵魂提示"])
T.Checkbutton_db(OtherOptions, 230, 320, L["自动接受复活"], "acceptres", L["自动接受复活提示"])
T.Checkbutton_db(OtherOptions, 30, 350, L["自动召宝宝"], "autopet", L["自动召宝宝提示"])
T.Checkbutton_db(OtherOptions, 230, 350, L["优先偏爱宝宝"], "autopet_favorite", L["优先偏爱宝宝提示"])

T.createDR(OtherOptions.autopet, OtherOptions.autopet_favorite)

if G.Client == "zhCN" then
	T.CVarCheckbutton(OtherOptions, 30, 380, "overrideArchive", "反和谐(大退生效)", "0", "1")
end
--====================================================--
--[[               -- Commands --               ]]--
--====================================================--
local Comands = CreateOptionPage("Comands", L["命令"], GUI, "VERTICAL")

Comands.text = T.createtext(Comands, "OVERLAY", 12, "OUTLINE", "LEFT")
Comands.text:SetPoint("TOPLEFT", 30, -60)
Comands.text:SetText(L["指令"])

Comands.mem = T.createtext(Comands, "OVERLAY", 12, "OUTLINE", "RIGHT")
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
MinimapButton.icon:SetTexture(348547)
MinimapButton.icon:SetSize(18,18)
MinimapButton.icon:SetPoint("CENTER")
MinimapButton.icon:SetTexCoord(.1, .9, .1, .9)

MinimapButton.icon2 = MinimapButton:CreateTexture(nil, "BORDER")
MinimapButton.icon2:SetTexture(348547)
MinimapButton.icon2:SetSize(18,18)
MinimapButton.icon2:SetPoint("CENTER")
MinimapButton.icon2:SetTexCoord(.1, .9, .1, .9)
MinimapButton.icon2:SetVertexColor(1, .5, .5, 1)
MinimapButton.icon2:Hide()

MinimapButton.anim = MinimapButton:CreateAnimationGroup()
MinimapButton.anim:SetLooping("BOUNCE")
MinimapButton.timer = MinimapButton.anim:CreateAnimation()
MinimapButton.timer:SetDuration(2)

MinimapButton:SetScript("OnEnter",function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
	GameTooltip:AddLine(G.addon_cname)
	GameTooltip:Show()
	
	self.timer:SetScript("OnUpdate", function(s, elapsed) 
		local v = s:GetProgress()
		self.icon2:SetVertexColor(v, .5, 1-v)
	end)
	self.anim:Play()
	self.icon:Hide()
	self.icon2:Show()
end)

MinimapButton:SetScript("OnLeave", function(self)    
	GameTooltip:Hide()
	
	self.timer:SetScript("OnUpdate", nil)
	self.anim:Stop()
	self.icon:Show()
	self.icon2:Hide()
end)

local AddonConfigMenu = CreateFrame("Frame", G.uiname.."AddonConfigMenu", UIParent, "UIDropDownMenuTemplate")

local AddonConfigMenuList = {
	{ text = L["设置向导"], notCheckable = true, func = function() T.RunSetup() end},
}

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
		EasyMenu(AddonConfigMenuList, AddonConfigMenu, "cursor", 0, 0, "MENU", 2)
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

	SetClassColorButton:SetScript("OnClick", function() T.ResetClasscolors(true) end)
	SetDBMButton:SetScript("OnClick", function() T.ResetDBM(true) end)
	SetBWButton:SetScript("OnClick", function() T.ResetBW(true) end)
	SetSkadaButton:SetScript("OnClick", function() T.ResetSkada(true) end)	
	
	eventframe:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

--====================================================--
--[[                  -- Game menu --               ]]--
--====================================================--

local GameMenuButton = CreateFrame("Button", G.uiname.."GameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
GameMenuButton:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -1)
GameMenuButton:SetText(T.color_text("AltzUI"))
T.ReskinButton(GameMenuButton, 14)

GameMenuButton:SetScript("OnClick", function()
	GUI:Show()
	GUI.df:Show()
	GUI.scale:Show()
	HideUIPanel(GameMenuFrame)
end)

GameMenuFrame:HookScript("OnShow", function()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GameMenuButtonRatings:SetPoint("TOP", GameMenuButton, "BOTTOM", 0, -1)

function GameMenuFrame_UpdateVisibleButtons(self)
	local height = 332;

	local buttonToReanchor = GameMenuButtonWhatsNew
	local reanchorYOffset = -1

	if IsCharacterNewlyBoosted() or not C_SplashScreen.CanViewSplashScreen() then
		GameMenuButtonWhatsNew:Hide()
		height = height - 20
		buttonToReanchor = GameMenuButtonSettings
		reanchorYOffset = -16
	else
		GameMenuButtonWhatsNew:Show()
	end

	if ( C_StorePublic.IsEnabled() ) then
		height = height + 20
		GameMenuButtonStore:Show()
		buttonToReanchor:SetPoint("TOP", GameMenuButtonStore, "BOTTOM", 0, reanchorYOffset)
	else
		GameMenuButtonStore:Hide()
		buttonToReanchor:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, reanchorYOffset)
	end
	
	if ( GameMenuButtonRatings:IsShown() ) then
		height = height + 20;
		GameMenuButtonLogout:SetPoint("TOP", GameMenuButtonRatings, "BOTTOM", 0, -16)
	else
		GameMenuButtonLogout:SetPoint("TOP", GameMenuButton, "BOTTOM", 0, -16)
	end

	self:SetHeight(height)
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
