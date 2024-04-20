﻿local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local function CreateDividingLine(frame, y, width)
	local tex = frame:CreateTexture(nil, "ARTWORK")
	tex:SetSize(width or frame:GetWidth()-50, 1)
	tex:SetPoint("TOP", 0, y)
	tex:SetColorTexture(1, 1, 1, .2)
end

--====================================================--
--[[             -- GUI Main Frame --               ]]--
--====================================================--
local GUI = CreateFrame("Frame", G.uiname.."GUI Main Frame", UIParent)
GUI:SetSize(650, 550)
GUI:SetPoint("TOPRIGHT", UIParent, "CENTER", 300, 300)
GUI:SetFrameStrata("HIGH")
GUI:SetFrameLevel(2)
GUI:Hide()
F.SetBD(GUI)
G.GUI = GUI

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
F.ReskinSlider(GUI.scale)
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
GUI.scale.Text:SetFontObject(GameFontHighlight)
T.resize_font(GUI.scale.Text)

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
GUI.title = T.createtext(GUI, "OVERLAY", 25, "OUTLINE", "CENTER")
GUI.title:SetPoint("BOTTOM", GUI, "TOP", 0, -8)
GUI.title:SetText(G.classcolor.."Altz UI  "..G.Version.."|r")

-- 输入框和按钮
GUI.editbox = T.createeditbox(GUI, nil, nil, L["复制粘贴"])

GUI.editbox.name:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", 5, -13)
GUI.editbox:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", GUI.editbox.name:GetWidth()+10, -7)
GUI.editbox:SetPoint("BOTTOMRIGHT", GUI, "BOTTOMRIGHT", -5, -33)
GUI.editbox:Hide()

GUI.editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
GUI.editbox:SetScript("OnEditFocusLost", function(self) self:HighlightText(0,0) end)
GUI.editbox:SetScript("OnHide", function(self) self.button:Hide() end)

GUI.editbox.bg = CreateFrame("Frame", nil, GUI.editbox, "BackdropTemplate")
GUI.editbox.bg:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", 0, -3)
GUI.editbox.bg:SetPoint("BOTTOMRIGHT", GUI, "BOTTOMRIGHT", 0, -36)
GUI.editbox.bg:SetFrameLevel(GUI:GetFrameLevel()-1)
F.SetBD(GUI.editbox.bg)

GUI.editbox.button = T.createclickbutton(GUI.editbox, 0, {"RIGHT", GUI.editbox, "RIGHT", -2, 0}, OKAY)
GUI.editbox.button:Hide()
	
GUI.GitHub = T.createclicktexbutton(GUI, {"BOTTOMLEFT", GUI, "BOTTOMLEFT", 5, 0}, [[Interface\AddOns\AltzUI\media\icons\GitHub.tga]], "GitHub")
GUI.GitHub:SetScript("OnClick", function()
	if GUI.editbox.type ~= "GitHub" then
		GUI.editbox:Show()
		GUI.editbox.button:Hide()
		GUI.editbox:SetText(G.links["GitHub"])
		GUI.editbox.type = "GitHub"
	else
		GUI.editbox:Hide()
		GUI.editbox.type = nil
	end
end)

GUI.wowi = T.createclicktexbutton(GUI, {"LEFT", GUI.GitHub, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\EJ.tga]], "WoWInterface", 20)
GUI.wowi:SetScript("OnClick", function()
	if GUI.editbox.type ~= "WoWInterface" then
		GUI.editbox:Show()
		GUI.editbox.button:Hide()
		GUI.editbox:SetText(G.links["WoWInterface"])
		GUI.editbox.type = "WoWInterface"
	else
		GUI.editbox:Hide()
		GUI.editbox.type = nil
	end
end)

GUI.curse = T.createclicktexbutton(GUI, {"LEFT", GUI.wowi, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\Spellbook.tga]], "Curse", 20)
GUI.curse:SetScript("OnClick", function()
	if GUI.editbox.type ~= "Curse" then
		GUI.editbox:Show()
		GUI.editbox.button:Hide()
		GUI.editbox:SetText(G.links["Curse"])
		GUI.editbox.type = "Curse"
	else
		GUI.editbox:Hide()
		GUI.editbox.type = nil
	end
end)

GUI.export = T.createclicktexbutton(GUI, {"LEFT", GUI.curse, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\arrow.tga]], L["导出"], 20)
GUI.export:SetScript("OnClick", function()	
	if GUI.editbox.type ~= "export" then
		GUI.editbox:Show()
		GUI.editbox.button:Hide()
		T.ExportSettings(GUI.editbox)
		GUI.editbox.type = "export"
	else
		GUI.editbox:Hide()
		GUI.editbox.type = nil
	end
end)
T.SetupArrow(GUI.export.tex, "down")

GUI.import = T.createclicktexbutton(GUI, {"LEFT", GUI.export, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\arrow.tga]], L["导入"], 20)
GUI.import:SetScript("OnClick", function()	
	if GUI.editbox.type ~= "import" then
		GUI.editbox:Show()
		GUI.editbox.button:Show()
		GUI.editbox.button:SetScript("OnClick", function()
			T.ImportSettings(GUI.editbox:GetText())
		end)
		GUI.editbox:SetText("")
		GUI.editbox.type = "import"
	else
		GUI.editbox:Hide()
		GUI.editbox.type = nil
	end
end)
T.SetupArrow(GUI.import.tex, "up")

GUI.reset = T.createclicktexbutton(GUI, {"LEFT", GUI.import, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])
GUI.reset:SetScript("OnClick", function()
	GUI.editbox:Hide()
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

GUI.unlock = T.createclicktexbutton(GUI, {"LEFT", GUI.reset, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\lock.tga]], L["解锁框体"], 20)
GUI.unlock:SetScript("OnClick", function()	
	GUI.editbox:Hide()
	GUI.editbox.type = nil
	
	T.UnlockAll()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI.reload = T.createclicktexbutton(GUI, {"LEFT", GUI.unlock, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\RaidTool.tga]], RELOADUI, 20)
GUI.reload:SetScript("OnClick", ReloadUI)

GUI.close = T.createclicktexbutton(GUI, {"BOTTOMRIGHT", GUI, "BOTTOMRIGHT", -5, 0}, [[Interface\AddOns\AltzUI\media\icons\exit.tga]], nil, 20)
GUI.close:SetScript("OnClick", function()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI:HookScript("OnHide", function()
	StaticPopup_Hide(G.uiname.."Import Confirm")
	StaticPopup_Hide(G.uiname.."Reset Confirm")
	GUI.editbox:Hide()
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
	
	local tab = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	tab:SetFrameLevel(parent:GetFrameLevel()+2)
	tab:EnableMouse(true)
	F.CreateBD(tab, .2)
	
	tab.text = T.createtext(tab, "OVERLAY", 12, "OUTLINE", "LEFT")
	tab.text:SetText(title)
	
	table.insert(parent.tabs, tab)
	
	tab.owner = frame
	tab.index = #parent.tabs	
	frame.hooked_tab = tab
	
	if orientation == "VERTICAL" then	
		tab:SetSize(130, 25)
		tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2, -30*tab.index)
		
		tab.text:SetJustifyH("LEFT")
		tab.text:SetPoint("LEFT", 10, 0)
		
		tab:SetScript("OnMouseDown", function()
			tab.owner:Show()
			tab:SetPoint("TOPLEFT", parent, "TOPRIGHT", 8, -30*tab.index)
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			for i, t in pairs(parent.tabs) do
				if t ~= tab then
					t.owner:Hide()
					t:SetPoint("TOPLEFT", parent, "TOPRIGHT", 2,  -30*t.index)
					t:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end)
	else
		tab:SetSize(tab.text:GetWidth()+10, 25)
		if tab.index == 1 then
			tab:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 15, 2)
		else
			tab:SetPoint("LEFT", parent.tabs[tab.index-1], "RIGHT", 4, 0)
		end
		
		tab.text:SetJustifyH("CENTER")
		tab.text:SetPoint("CENTER")
		
		tab:SetScript("OnMouseDown", function()
			tab.owner:Show()
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			for i, t in pairs(parent.tabs) do
				if t ~= tab then
					t.owner:Hide()
					t:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end)
	end

	return frame
end

local function CreateInnerFrame(parent)
	local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	frame:SetPoint("TOPLEFT", 40, -60)
	frame:SetPoint("BOTTOMLEFT", -20, 25)
	frame:SetWidth(parent:GetWidth()-200)
	
	F.CreateBD(frame, .2)
	
	return frame
end

--====================================================--
--[[            -- Interface Options --            ]]--
--====================================================--
local SkinOptions = CreateOptionPage("Interface Options", L["界面"], GUI, "VERTICAL")
local SInnerframe = CreateInnerFrame(SkinOptions)

-- 界面风格
SInnerframe.theme = CreateOptionPage("Interface Options theme", L["界面风格"], SInnerframe, "VERTICAL", "SkinOptions")

T.createradiobuttongroup(SInnerframe.theme, 30, 60, L["样式"], "style", {
	{1, L["透明样式"]},
	{2, L["深色样式"]},
	{3, L["普通样式"]},
})

SInnerframe.theme.style.apply = function()
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
end

local combattextfont_group = {
	{"none", DEFAULT},
	{"combat1", "1234"},
	{"combat2", "1234"},
	{"combat3", "1234"},
}

T.createradiobuttongroup(SInnerframe.theme, 30, 90, L["战斗字体"], "combattext", combattextfont_group)
for i, info in pairs(combattextfont_group) do
	local bu = SInnerframe.theme.combattext.buttons[i]
	if info[1] ~= "none" then
		bu.text:SetFont(G.combatFont[info[1]], 10, "OUTLINE")
	end
end
SInnerframe.theme.combattext.apply = function()
	if not SInnerframe.theme.combattext.alert then
		StaticPopup_Show("CLIENT_RESTART_ALERT")
		SInnerframe.theme.combattext.alert = true
	end
end
	
T.createradiobuttongroup(SInnerframe.theme, 30, 120, L["数字缩写样式"], "formattype", {
	{"k", "k m"},
	{"w", "w kw"},
	{"w_chinese", "万 千万"},
	{"none", "不缩写"},
})

T.createcheckbutton(SInnerframe.theme, 30, 150, L["上方"].." "..L["边缘装饰"], "SkinOptions", "showtopbar")
SInnerframe.theme.showtopbar.apply = G.BGFrame.Apply
T.createcheckbutton(SInnerframe.theme, 200, 150, L["上方"].." "..L["两侧装饰"], "SkinOptions", "showtopconerbar")
SInnerframe.theme.showtopconerbar.apply = G.BGFrame.Apply
T.createcheckbutton(SInnerframe.theme, 30, 180, L["下方"].." "..L["边缘装饰"], "SkinOptions", "showbottombar")
SInnerframe.theme.showbottombar.apply = G.BGFrame.Apply
T.createcheckbutton(SInnerframe.theme, 200, 180, L["下方"].." "..L["两侧装饰"], "SkinOptions", "showbottomconerbar")
SInnerframe.theme.showbottomconerbar.apply = G.BGFrame.Apply

SInnerframe.theme.title = SInnerframe.theme:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
SInnerframe.theme.title:SetPoint("TOPLEFT", 35, -213)
SInnerframe.theme.title:SetText(L["插件皮肤"])

SInnerframe.theme.DividingLine = SInnerframe.theme:CreateTexture(nil, "ARTWORK")
SInnerframe.theme.DividingLine:SetSize(SInnerframe.theme:GetWidth()-50, 1)
SInnerframe.theme.DividingLine:SetPoint("TOP", 0, -240)
SInnerframe.theme.DividingLine:SetColorTexture(1, 1, 1, .2)

local function CreateApplySettingButton(addon)
	local Button = CreateFrame("Button", G.uiname..addon.."ApplySettingButton", SInnerframe.theme, "UIPanelButtonTemplate")
	Button:SetPoint("LEFT", SInnerframe.theme[addon], "RIGHT", 150, 0)
	Button:SetSize(120, 25)
	Button:SetText(L["更改设置"])
	T.resize_font(Button.Text)
	Button:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(L["更改设置提示"])
			GameTooltip:Show() 
		end)
	Button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	F.Reskin(Button)
	
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

T.createcheckbutton(SInnerframe.theme, 30, 250, "ClassColor", "SkinOptions", "setClassColor")
local SetClassColorButton = CreateApplySettingButton("setClassColor")

T.createcheckbutton(SInnerframe.theme, 30, 280, "DBM", "SkinOptions", "setDBM")
local SetDBMButton = CreateApplySettingButton("setDBM")

T.createcheckbutton(SInnerframe.theme, 30, 310, "BigWigs", "SkinOptions", "setBW")
local SetBWButton = CreateApplySettingButton("setBW")

T.createcheckbutton(SInnerframe.theme, 30, 340, "Skada", "SkinOptions", "setSkada")
local SetSkadaButton = CreateApplySettingButton("setSkada")

-- 界面布局
SInnerframe.layout = CreateOptionPage("Interface Options Layout", L["界面布局"], SInnerframe, "VERTICAL", "SkinOptions")

T.createcheckbutton(SInnerframe.layout, 30, 60, L["信息条"], "SkinOptions", "infobar")
SInnerframe.layout.infobar.apply = G.InfoFrame.Apply

T.createslider(SInnerframe.layout, 30, 110, L["信息条尺寸"], "SkinOptions", "infobarscale", 100, 50, 200, 5)
SInnerframe.layout.infobarscale.apply = G.InfoFrame.Apply

T.createDR(SInnerframe.layout.infobar, SInnerframe.layout.infobarscale)

CreateDividingLine(SInnerframe.layout, -150)

T.createcheckbutton(SInnerframe.layout, 30, 170, L["在副本中收起任务追踪"], "SkinOptions", "collapseWF", L["在副本中收起任务追踪提示"])
T.createcheckbutton(SInnerframe.layout, 30, 200, L["暂离屏幕"], "SkinOptions", "afkscreen", L["暂离屏幕"])
T.createcheckbutton(SInnerframe.layout, 30, 230, L["显示插件使用小提示"], "SkinOptions", "showAFKtips", L["显示插件使用小提示提示"])
T.createDR(SInnerframe.layout.afkscreen, SInnerframe.layout.showAFKtips)
--====================================================--
--[[              -- Chat Options --                ]]--
--====================================================--
local ChatOptions = CreateOptionPage("Chat Options", SOCIAL_LABEL, GUI, "VERTICAL", "ChatOptions")

T.createcheckbutton(ChatOptions, 30, 60, L["频道缩写"], "ChatOptions", "channelreplacement")
ChatOptions.channelreplacement.apply = T.UpdateChannelReplacement
T.CVartogglebox(ChatOptions, 230, 60, "showTimestamps", SHOW_TIMESTAMP, "|cff64C2F5%H:%M|r ", "none")
T.createcheckbutton(ChatOptions, 30, 90, L["滚动聊天框"], "ChatOptions", "autoscroll", L["滚动聊天框提示"])
T.createcheckbutton(ChatOptions, 230, 90, L["显示聊天框背景"], "ChatOptions", "showbg")
ChatOptions.showbg.apply = T.UpdateChatFrameBg

CreateDividingLine(ChatOptions, -130)

T.createcheckbutton(ChatOptions, 30, 140, L["聊天过滤"], "ChatOptions", "nogoldseller", L["聊天过滤提示"])
T.createslider(ChatOptions, 30, 190, L["过滤阈值"], "ChatOptions", "goldkeywordnum", 1, 1, 5, 1, L["过滤阈值"])
T.createmultilinebox(ChatOptions, 200, 100, 35, 225, L["关键词"], "ChatOptions", "goldkeywordlist", L["关键词输入"])
ChatOptions.goldkeywordlist.apply = T.Update_Chat_Filter
T.createDR(ChatOptions.nogoldseller, ChatOptions.goldkeywordnum, ChatOptions.goldkeywordlist)

CreateDividingLine(ChatOptions, -360)

T.createcheckbutton(ChatOptions, 30, 370, L["自动邀请"], "ChatOptions", "autoinvite", L["自动邀请提示"])
T.createeditbox(ChatOptions, 40, 405, L["关键词"], "ChatOptions", "autoinvitekeywords",  L["关键词输入"])
ChatOptions.autoinvitekeywords.apply = T.Update_Invite_Keyword
T.createDR(ChatOptions.autoinvite, ChatOptions.autoinvitekeywords)

--====================================================--
--[[          -- Bag and Items Options --           ]]--
--====================================================--
local ItemOptions = CreateOptionPage("Item Options", ITEMS, GUI, "VERTICAL", "ItemOptions")

T.createcheckbutton(ItemOptions, 30, 60, L["已会配方着色"], "ItemOptions", "alreadyknown", L["已会配方着色提示"])

CreateDividingLine(ItemOptions, -110)

T.createcheckbutton(ItemOptions, 30, 120, L["自动修理"], "ItemOptions", "autorepair", L["自动修理提示"])
T.createcheckbutton(ItemOptions, 30, 150, L["自动公会修理"], "ItemOptions", "autorepair_guild", L["自动公会修理提示"])
T.createcheckbutton(ItemOptions, 230, 150, L["灵活公会修理"], "ItemOptions", "autorepair_guild_auto", L["灵活公会修理提示"])

CreateDividingLine(ItemOptions, -200)

T.createcheckbutton(ItemOptions, 30, 210, L["自动售卖"], "ItemOptions", "autosell", L["自动售卖提示"])
T.createcheckbutton(ItemOptions, 30, 240, L["自动购买"], "ItemOptions", "autobuy", L["自动购买提示"])

ItemOptions.autobuy_list = T.CreateItemListOption(ItemOptions, {"TOPLEFT", 35, -270}, 260, L["自动购买"]..L["设置"], "autobuylist", L["数量"])

T.createDR(ItemOptions.autobuy, ItemOptions.autobuy_list)
--====================================================--
--[[               -- Unit Frames --                ]]--
--====================================================--
local UFOptions = CreateOptionPage("UF Options", L["单位框体"], GUI, "VERTICAL")
local UFInnerframe = CreateInnerFrame(UFOptions)

-- 样式
UFInnerframe.style = CreateOptionPage("UF Options style", L["样式"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createcheckbutton(UFInnerframe.style, 30, 60, L["条件渐隐"], "UnitframeOptions", "enablefade", L["条件渐隐提示"])
UFInnerframe.style.enablefade.apply = function()
	T.EnableUFSettings({"Fader"})
end

T.createslider(UFInnerframe.style, 30, 110, L["渐隐透明度"], "UnitframeOptions", "fadingalpha", 100, 0, 80, 5, L["渐隐透明度提示"])
T.createDR(UFInnerframe.style.enablefade, UFInnerframe.style.fadingalpha)

CreateDividingLine(UFInnerframe.style, -140)

T.createcheckbutton(UFInnerframe.style, 30, 150, L["显示肖像"], "UnitframeOptions", "portrait")
UFInnerframe.style.portrait.apply = function()
	T.EnableUFSettings({"Portrait"})
end

CreateDividingLine(UFInnerframe.style, -180)

T.createcheckbutton(UFInnerframe.style, 30, 190, L["总是显示生命值"], "UnitframeOptions", "alwayshp", L["总是显示生命值提示"])
UFInnerframe.style.alwayshp.apply = function()
	T.ApplyUFSettings({"Health"})
end

T.createcheckbutton(UFInnerframe.style, 30, 220, L["总是显示能量值"], "UnitframeOptions", "alwayspp", L["总是显示能量值提示"])
UFInnerframe.style.alwayspp.apply = function()
	T.ApplyUFSettings({"Power"})
end

T.createslider(UFInnerframe.style, 30, 270, L["数值字号"], "UnitframeOptions", "valuefontsize", 1, 10, 25, 1, L["数值字号提示"])
UFInnerframe.style.valuefontsize.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Castbar"})
end

-- 尺寸
UFInnerframe.size = CreateOptionPage("UF Options size", L["尺寸"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createslider(UFInnerframe.size, 30, 80, L["高度"], "UnitframeOptions", "height", 1, 5, 50, 1)
UFInnerframe.size.height.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana", "PVPSpecIcon"})
	T.UpdatePartySize()
end

T.createslider(UFInnerframe.size, 30, 120, L["宽度"], "UnitframeOptions", "width", 1, 50, 500, 1, L["宽度提示"])
UFInnerframe.size.width.apply = function()
	T.ApplyUFSettings({"Health", "Auras", "ClassPower", "Runes", "Stagger", "Dpsmana"})
end

T.createslider(UFInnerframe.size, 30, 160, L["能量条高度"], "UnitframeOptions", "ppheight", 100, 5, 100, 5)
UFInnerframe.size.ppheight.apply = function()
	T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana"})
end

CreateDividingLine(UFInnerframe.size, -190)

T.createslider(UFInnerframe.size, 30, 220, L["宠物框体宽度"], "UnitframeOptions", "widthpet", 1, 50, 500, 1)
UFInnerframe.size.widthpet.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
end

T.createslider(UFInnerframe.size, 30, 260, L["首领框体和PVP框体的宽度"], "UnitframeOptions", "widthboss", 1, 50, 500, 1)
UFInnerframe.size.widthboss.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
end

-- 施法条
UFInnerframe.castbar = CreateOptionPage("UF Options castbar", L["施法条"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createcheckbutton(UFInnerframe.castbar, 30, 60, L["启用"], "UnitframeOptions", "castbars")
UFInnerframe.castbar.castbars.apply = function()
	T.EnableUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 30, 100, L["图标大小"], "UnitframeOptions", "cbIconsize", 1, 10, 50, 1)
UFInnerframe.castbar.cbIconsize.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createcheckbutton(UFInnerframe.castbar, 30, 130, L["独立施法条"], "UnitframeOptions", "independentcb")
UFInnerframe.castbar.independentcb.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 30, 180, L["玩家施法条"]..L["高度"], "UnitframeOptions", "cbheight", 1, 5, 30, 1)
UFInnerframe.castbar.cbheight:SetWidth(170)
UFInnerframe.castbar.cbheight.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 230, 180, L["玩家施法条"]..L["宽度"], "UnitframeOptions", "cbwidth", 1, 50, 500, 5)
UFInnerframe.castbar.cbwidth:SetWidth(170)
UFInnerframe.castbar.cbwidth.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 30, 220, L["目标施法条"]..L["高度"], "UnitframeOptions", "target_cbheight", 1, 5, 30, 1)
UFInnerframe.castbar.target_cbheight:SetWidth(170)
UFInnerframe.castbar.target_cbheight.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 230, 220, L["目标施法条"]..L["宽度"], "UnitframeOptions", "target_cbwidth", 1, 50, 500, 5)
UFInnerframe.castbar.target_cbwidth:SetWidth(170)
UFInnerframe.castbar.target_cbwidth.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 30, 260, L["焦点施法条"]..L["高度"], "UnitframeOptions", "focus_cbheight", 1, 5, 30, 1)
UFInnerframe.castbar.focus_cbheight:SetWidth(170)
UFInnerframe.castbar.focus_cbheight.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createslider(UFInnerframe.castbar, 230, 260, L["焦点施法条"]..L["宽度"], "UnitframeOptions", "focus_cbwidth", 1, 50, 500, 5)
UFInnerframe.castbar.focus_cbwidth:SetWidth(170)
UFInnerframe.castbar.focus_cbwidth.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

local CBtextpos_group = {
	{"LEFT", 		L["左"]},
	{"TOPLEFT", 	L["左上"]},
	{"RIGHT", 		L["右"]},
	{"TOPRIGHT",	L["右上"]},
}

T.createradiobuttongroup(UFInnerframe.castbar, 30, 290, L["法术名称位置"], "namepos", CBtextpos_group)
UFInnerframe.castbar.namepos.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createradiobuttongroup(UFInnerframe.castbar, 30, 320, L["施法时间位置"], "timepos", CBtextpos_group)
UFInnerframe.castbar.timepos.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createDR(UFInnerframe.castbar.independentcb, UFInnerframe.castbar.cbheight, UFInnerframe.castbar.cbwidth, UFInnerframe.castbar.target_cbheight, UFInnerframe.castbar.target_cbwidth, UFInnerframe.castbar.focus_cbheight, UFInnerframe.castbar.focus_cbwidth, UFInnerframe.castbar.namepos, UFInnerframe.castbar.timepos)

T.createcolorpickerbu(UFInnerframe.castbar, 30, 355, L["可打断施法条图标颜色"], "UnitframeOptions", "Interruptible_color")
T.createcolorpickerbu(UFInnerframe.castbar, 230, 355, L["不可打断施法条图标颜色"], "UnitframeOptions", "notInterruptible_color")
T.createcheckbutton(UFInnerframe.castbar, 30, 390, L["引导法术分段"], "UnitframeOptions", "channelticks")
T.createcheckbutton(UFInnerframe.castbar, 30, 420, L["隐藏玩家施法条图标"], "UnitframeOptions", "hideplayercastbaricon")
UFInnerframe.castbar.hideplayercastbaricon.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createDR(UFInnerframe.castbar.castbars, UFInnerframe.castbar.cbIconsize, UFInnerframe.castbar.independentcb, UFInnerframe.castbar.cbheight, UFInnerframe.castbar.cbwidth, 
UFInnerframe.castbar.target_cbheight, UFInnerframe.castbar.target_cbwidth, UFInnerframe.castbar.focus_cbheight, UFInnerframe.castbar.focus_cbwidth, UFInnerframe.castbar.namepos, 
UFInnerframe.castbar.timepos, UFInnerframe.castbar.channelticks, UFInnerframe.castbar.hideplayercastbaricon, UFInnerframe.castbar.Interruptible_color, UFInnerframe.castbar.notInterruptible_color)

-- 平砍计时条
UFInnerframe.swingtimer = CreateOptionPage("UF Options swingtimer", L["平砍计时条"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createcheckbutton(UFInnerframe.swingtimer, 30, 60, L["启用"], "UnitframeOptions", "swing")
UFInnerframe.swingtimer.swing.apply = function()
	T.EnableUFSettings({"Swing"})
end

T.createslider(UFInnerframe.swingtimer, 30, 110, L["高度"], "UnitframeOptions", "swheight", 1, 5, 30, 1)
UFInnerframe.swingtimer.swheight.apply = function()
	T.ApplyUFSettings({"Swing"})
end

T.createslider(UFInnerframe.swingtimer, 30, 150, L["宽度"], "UnitframeOptions", "swwidth", 1, 50, 500, 5)
UFInnerframe.swingtimer.swwidth.apply = function()
	T.ApplyUFSettings({"Swing"})
end

CreateDividingLine(UFInnerframe.swingtimer, -180)

T.createcheckbutton(UFInnerframe.swingtimer, 30, 200, L["显示平砍计时"], "UnitframeOptions", "swtimer")
UFInnerframe.swingtimer.swtimer.apply = function()
	T.ApplyUFSettings({"Swing"})
end

T.createslider(UFInnerframe.swingtimer, 30, 240, L["字体大小"], "UnitframeOptions", "swtimersize", 1, 8, 20, 1)
UFInnerframe.swingtimer.swtimersize.apply = function()
	T.ApplyUFSettings({"Swing"})
end

T.createDR(UFInnerframe.swingtimer.swing, UFInnerframe.swingtimer.swheight, UFInnerframe.swingtimer.swwidth, UFInnerframe.swingtimer.swtimer, UFInnerframe.swingtimer.swtimersize)
T.createDR(UFInnerframe.swingtimer.swtimer, UFInnerframe.swingtimer.swtimersize)

-- 光环
UFInnerframe.aura = CreateOptionPage("UF Options aura", AURAS, UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createslider(UFInnerframe.aura, 30, 80, L["图标大小"], "UnitframeOptions", "aura_size", 1, 15, 30, 1)
UFInnerframe.aura.aura_size.apply = function()
	T.ApplyUFSettings({"Auras"})
end

T.createcheckbutton(UFInnerframe.aura, 30, 100, L["玩家减益"], "UnitframeOptions", "playerdebuffenable", L["玩家减益提示"])
UFInnerframe.aura.playerdebuffenable.apply = function()
	T.ApplyUFSettings({"Auras"})
end

CreateDividingLine(UFInnerframe.aura, -140)

T.createcheckbutton(UFInnerframe.aura, 30, 150, L["过滤增益"], "UnitframeOptions", "AuraFilterignoreBuff", L["过滤增益提示"])
UFInnerframe.aura.AuraFilterignoreBuff.apply = function()
	T.ApplyUFSettings({"Auras"})
end

T.createcheckbutton(UFInnerframe.aura, 30, 180, L["过滤减益"], "UnitframeOptions", "AuraFilterignoreDebuff", L["过滤减益提示"])
UFInnerframe.aura.AuraFilterignoreDebuff.apply = function()
	T.ApplyUFSettings({"Auras"})
end

UFInnerframe.aura.aurafliter_list = T.CreateAuraListOption(UFInnerframe.aura, {"TOPLEFT", 30, -215}, 230, L["白名单"]..AURAS, "AuraFilterwhitelist")

-- 图腾
UFInnerframe.totembar = CreateOptionPage("UF Options totembar", L["图腾条"], UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createcheckbutton(UFInnerframe.totembar, 30, 60, L["启用"], "UnitframeOptions", "totems")
UFInnerframe.totembar.totems.apply = T.ApplyTotemsBarSettings

T.createslider(UFInnerframe.totembar, 30, 110, L["图标大小"], "UnitframeOptions", "totemsize", 1, 15, 40, 1)
UFInnerframe.totembar.totemsize.apply = T.ApplyTotemsBarSettings

T.createradiobuttongroup(UFInnerframe.totembar, 30, 140, L["排列方向"], "growthDirection", {
	{"HORIZONTAL", L["水平"]},
	{"VERTICAL", L["垂直"]},
})
UFInnerframe.totembar.growthDirection.apply = T.ApplyTotemsBarSettings

T.createradiobuttongroup(UFInnerframe.totembar, 30, 170, L["排列方向"], "sortDirection", {
	{"ASCENDING", L["正向"]},
	{"DESCENDING", L["反向"]},
})
UFInnerframe.totembar.sortDirection.apply = T.ApplyTotemsBarSettings

-- 小队
UFInnerframe.party = CreateOptionPage("UF Options party", PARTY, UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createslider(UFInnerframe.party, 30, 80, PARTY..L["宽度"], "UnitframeOptions", "widthparty", 1, 50, 500, 1)
UFInnerframe.party.widthparty.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
	T.UpdatePartySize()
end

T.createcheckbutton(UFInnerframe.party, 30, 130, L["在小队中显示自己"], "UnitframeOptions", "showplayerinparty")
UFInnerframe.party.showplayerinparty.apply = function()
	T.UpdatePartyfilter()
end

T.createcheckbutton(UFInnerframe.party, 30, 160, L["显示宠物"], "UnitframeOptions", "showpartypet")
UFInnerframe.party.showpartypet.apply = function()
	T.UpdatePartyfilter()
end

-- 其他
UFInnerframe.other = CreateOptionPage("UF Options other", OTHER, UFInnerframe, "VERTICAL", "UnitframeOptions")

T.createcheckbutton(UFInnerframe.other, 30, 60, L["启用仇恨条"], "UnitframeOptions", "showthreatbar")
UFInnerframe.other.showthreatbar.apply = function()
	T.EnableUFSettings({"ThreatBar"})
end

T.createcheckbutton(UFInnerframe.other, 30, 90, L["显示PvP标记"], "UnitframeOptions", "pvpicon", L["显示PvP标记提示"])
UFInnerframe.other.showthreatbar.apply = function()
	T.EnableUFSettings({"PvPIndicator"})
end

T.createcheckbutton(UFInnerframe.other, 30, 120, L["启用首领框体"], "UnitframeOptions", "bossframes")
UFInnerframe.other.bossframes.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.createcheckbutton(UFInnerframe.other, 30, 150, L["启用PVP框体"], "UnitframeOptions", "arenaframes")
UFInnerframe.other.arenaframes.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

if G.myClass == "DEATHKNIGHT" then
    CreateDividingLine(UFInnerframe.other, -180)
	T.createcheckbutton(UFInnerframe.other, 30, 190, format(L["显示冷却"], RUNES), "UnitframeOptions", "runecooldown")
	UFInnerframe.other.runecooldown.apply = function()
		T.ApplyUFSettings({"Runes"})
	end

	T.createslider(UFInnerframe.other, 30, 240, L["字体大小"], "UnitframeOptions", "valuefs", 1, 8, 16, 1)
	UFInnerframe.other.valuefs.apply = function()
		T.ApplyUFSettings({"Runes"})
	end
end

if G.myClass == "SHAMAN" or G.myClass == "PRIEST" or G.myClass == "DRUID" then
	CreateDividingLine(UFInnerframe.other, -180)
    T.createcheckbutton(UFInnerframe.other, 30, 190, L["显示法力条"], "UnitframeOptions", "dpsmana", L["显示法力条提示"])
	UFInnerframe.other.dpsmana.apply = function()
		T.EnableUFSettings({"Dpsmana"})
		T.ApplyUFSettings({"ClassPower"})
	end
end

if G.myClass == "MONK" then
	CreateDividingLine(UFInnerframe.other, -180)
    T.createcheckbutton(UFInnerframe.other, 30, 190, L["显示醉拳条"], "UnitframeOptions", "stagger")
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

T.createcheckbutton(RFInnerframe.common, 30, 60, L["启用"], "UnitframeOptions", "enableraid")
RFInnerframe.common.enableraid.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.createslider(RFInnerframe.common, 30, 110, L["团队规模"], "UnitframeOptions", "party_num", 1, 2, 8, 2)
RFInnerframe.common.party_num.apply = function()
	T.UpdateGroupSize()
	T.UpdateGroupfilter()
end

T.createcheckbutton(RFInnerframe.common, 30, 150, COMPACT_UNIT_FRAME_PROFILE_HORIZONTALGROUPS, "UnitframeOptions", "hor_party")
RFInnerframe.common.hor_party.apply = function()
	T.UpdateGroupAnchor()
	T.UpdateGroupSize()
end

T.createcheckbutton(RFInnerframe.common, 30, 180, COMPACT_UNIT_FRAME_PROFILE_KEEPGROUPSTOGETHER, "UnitframeOptions", "party_connected")
RFInnerframe.common.party_connected.apply = function()
	T.UpdateGroupfilter()
end

T.createcheckbutton(RFInnerframe.common, 30, 210, L["未进组时显示"], "UnitframeOptions", "showsolo")
RFInnerframe.common.showsolo.apply = function()
	T.UpdateGroupfilter()
end

T.createcheckbutton(RFInnerframe.common, 30, 240, USE_RAID_STYLE_PARTY_FRAMES, "UnitframeOptions", "raidframe_inparty")
RFInnerframe.common.raidframe_inparty.apply = function()
	StaticPopup_Show(G.uiname.."Reload Alert")
end

T.createcheckbutton(RFInnerframe.common, 30, 270, L["显示宠物"], "UnitframeOptions", "showraidpet")
RFInnerframe.common.showraidpet.apply = function()
	T.UpdateGroupfilter()
end

T.createcheckbutton(RFInnerframe.common, 30, 300, L["团队工具"], "UnitframeOptions", "raidtool")
RFInnerframe.common.raidtool.apply = function()
	T.UpdateRaidTools()
end

-- 样式
RFInnerframe.style = CreateOptionPage("RF Options style", L["样式"], RFInnerframe, "VERTICAL", "UnitframeOptions")

T.createslider(RFInnerframe.style, 30, 80, L["高度"], "UnitframeOptions", "raidheight", 1, 10, 150, 1)
RFInnerframe.style.raidheight.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
	T.UpdateGroupSize()
end

T.createslider(RFInnerframe.style, 30, 120, L["宽度"], "UnitframeOptions", "raidwidth", 1, 10, 150, 1)
RFInnerframe.style.raidwidth.apply = function()
	T.ApplyUFSettings({"Health", "Auras"})
	T.UpdateGroupSize()
end

T.createcheckbutton(RFInnerframe.style, 30, 140, L["治疗法力条"], "UnitframeOptions", "raidmanabars")
RFInnerframe.style.raidmanabars.apply = function()
	T.EnableUFSettings({"Power"})
end

T.createslider(RFInnerframe.style,  30, 190, L["治疗法力条高度"], "UnitframeOptions", "raidppheight", 100, 5, 100, 5)
RFInnerframe.style.raidppheight.apply = function()
	T.ApplyUFSettings({"Power"})
end

T.createDR(RFInnerframe.style.raidmanabars, RFInnerframe.style.raidppheight)

T.createslider(RFInnerframe.style, 30, 230, L["名字长度"], "UnitframeOptions", "namelength", 1, 2, 10, 1)
RFInnerframe.style.namelength.apply = function()
	T.UpdateGroupTag("update")
end

T.createslider(RFInnerframe.style, 30, 270, L["字体大小"], "UnitframeOptions", "raidfontsize", 1, 8, 20, 1)
RFInnerframe.style.raidfontsize.apply = function()
	T.UpdateGroupTag("fontsize")
end

T.createcheckbutton(RFInnerframe.style, 30, 310, L["GCD"], "UnitframeOptions", "showgcd", L["GCD提示"])
RFInnerframe.style.showgcd.apply = function()
	T.EnableUFSettings({"GCD"})
end

T.createcheckbutton(RFInnerframe.style, 200, 310, L["主坦克和主助手"], "UnitframeOptions", "raidrole_icon", L["主坦克和主助手提示"])
RFInnerframe.style.raidrole_icon.apply = function()
	T.EnableUFSettings({"RaidRoleIndicator"})
end

T.createcheckbutton(RFInnerframe.style, 30, 340, L["显示缺失生命值"], "UnitframeOptions", "showmisshp", L["显示缺失生命值提示"])
RFInnerframe.style.showmisshp.apply = function()
	T.UpdateGroupTag("update")
end

T.createcheckbutton(RFInnerframe.style, 200, 340, L["治疗和吸收预估"], "UnitframeOptions", "healprediction", L["治疗和吸收预估提示"])
RFInnerframe.style.healprediction.apply = function()
	T.EnableUFSettings({"HealthPrediction"})
end

-- 治疗指示器
RFInnerframe.ind = CreateOptionPage("RF Options indicators", L["治疗指示器"], RFInnerframe, "VERTICAL", "UnitframeOptions")

T.createslider(RFInnerframe.ind, 30, 80, L["尺寸"], "UnitframeOptions", "hotind_size", 1, 10, 25, 1)
RFInnerframe.ind.hotind_size.apply = function()
	T.ApplyUFSettings({"AltzIndicators", "Auras"})
end

T.createradiobuttongroup(RFInnerframe.ind, 30, 100, L["样式"], "hotind_style", {
	{"number_ind", L["数字指示器"]},
	{"icon_ind", L["图标指示器"]},
})

local function Updateindsettings()
	if aCoreCDB["UnitframeOptions"]["hotind_style"] == "icon_ind" then
		RFInnerframe.ind.hotind_list:Enable()
	else
		RFInnerframe.ind.hotind_list:Disable()
	end
end

RFInnerframe.ind.hotind_style.apply = function()
	T.EnableUFSettings({"AltzIndicators", "Auras"})
	Updateindsettings()
end
RFInnerframe.ind.hotind_style:HookScript("OnShow", Updateindsettings)

CreateDividingLine(RFInnerframe.ind, -135)

RFInnerframe.ind.hotind_list = T.CreateAuraListOption(RFInnerframe.ind, {"TOPLEFT", 30, -150}, 270,  L["图标指示器"]..L["设置"], "hotind_auralist")

T.createradiobuttongroup(RFInnerframe.ind.hotind_list, -5, 40, L["过滤方式"], "hotind_filtertype", {
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

T.createcheckbutton(RFInnerframe.clickcast, 30, 60, L["启用"], "UnitframeOptions", "enableClickCast")
RFInnerframe.clickcast.enableClickCast.apply = function()
	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		T.RegisterClicksforAll()
	else
		T.UnregisterClicksforAll()
	end
end

-- 重置
RFInnerframe.clickcast.reset = T.createclicktexbutton(RFInnerframe.clickcast, {"LEFT", RFInnerframe.clickcast.title, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])	
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
F.CreateBD(clickcastframe, 0)

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
		arg1 = bu_tag
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
	macro_input.expand_bu = T.createclicktexbutton(macro_input, {"LEFT", macro_input, "RIGHT", 0, 0}, [[Interface\AddOns\AltzUI\media\icons\EJ.tga]], nil, 20)		
	macro_input.expand_bu:SetScript("OnEnter", function(self)	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(EDIT)
		GameTooltip:Show()
	end)
	macro_input.expand_bu:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	local macro_box = T.createmultilinebox(macro_input, nil, 150)
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
		F.ReskinDropDown(action_select)
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
		F.ReskinDropDown(spell_select)
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
		local item_input = T.createinputbox(frame, {"LEFT", action_select, "RIGHT", -8, 2}, L["物品名称ID链接"], 140, true)
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
		local macro_input = T.createinputbox(frame, {"LEFT", action_select, "RIGHT", -8, 2}, L["输入一个宏"], 140)
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
RFInnerframe.Icon_Display = CreateOptionPage("RF Options Icon Display", L["光环"]..L["图标"], RFInnerframe, "VERTICAL", "UnitframeOptions")

local raidicon_debufftitle = T.createtext(RFInnerframe.Icon_Display, "OVERLAY", 18, "OUTLINE", "LEFT")
raidicon_debufftitle:SetPoint("LEFT", RFInnerframe.Icon_Display, "TOPLEFT", 50, -75)
raidicon_debufftitle:SetTextColor(1, .5, .3)
raidicon_debufftitle:SetText(L["Debuffs"])

T.createslider(RFInnerframe.Icon_Display, 60, 100, "X", "UnitframeOptions", "raid_debuff_anchor_x", 1, -50, 50, 1)
T.createslider(RFInnerframe.Icon_Display, 260, 100, "Y", "UnitframeOptions", "raid_debuff_anchor_y", 1, -50, 50, 1)
T.createslider(RFInnerframe.Icon_Display, 60, 140, L["图标数量"], "UnitframeOptions", "raid_debuff_num", 1, 1, 5, 1)
T.createslider(RFInnerframe.Icon_Display, 260, 140, L["图标大小"], "UnitframeOptions", "raid_debuff_icon_size", 1, 10, 40, 1)
T.createslider(RFInnerframe.Icon_Display, 60, 180, L["字体大小"], "UnitframeOptions", "raid_debuff_icon_fontsize", 1, 5, 20, 1)

RFInnerframe.Icon_Display.raid_debuff_num:SetWidth(160)
RFInnerframe.Icon_Display.raid_debuff_icon_size:SetWidth(160)
RFInnerframe.Icon_Display.raid_debuff_icon_fontsize:SetWidth(160)
RFInnerframe.Icon_Display.raid_debuff_anchor_x:SetWidth(160)
RFInnerframe.Icon_Display.raid_debuff_anchor_y:SetWidth(160)

local raidicon_bufftitle = T.createtext(RFInnerframe.Icon_Display, "OVERLAY", 18, "OUTLINE", "LEFT")
raidicon_bufftitle:SetPoint("LEFT", RFInnerframe.Icon_Display, "TOPLEFT", 50, -225)
raidicon_bufftitle:SetTextColor(.3, 1, .5)
raidicon_bufftitle:SetText(L["Buffs"])

T.createslider(RFInnerframe.Icon_Display, 60, 250, "X", "UnitframeOptions", "raid_buff_anchor_x", 1, -50, 50, 1)
T.createslider(RFInnerframe.Icon_Display, 260, 250, "Y", "UnitframeOptions", "raid_buff_anchor_y", 1, -50, 50, 1)
T.createslider(RFInnerframe.Icon_Display, 60, 290, L["图标数量"], "UnitframeOptions", "raid_buff_num", 1, 1, 5, 1)
T.createslider(RFInnerframe.Icon_Display, 260, 290, L["图标大小"], "UnitframeOptions", "raid_buff_icon_size", 1, 10, 40, 1)
T.createslider(RFInnerframe.Icon_Display, 60, 330, L["字体大小"], "UnitframeOptions", "raid_buff_icon_fontsize", 1, 5, 20, 1)

RFInnerframe.Icon_Display.raid_buff_num:SetWidth(160)
RFInnerframe.Icon_Display.raid_buff_icon_size:SetWidth(160)
RFInnerframe.Icon_Display.raid_buff_icon_fontsize:SetWidth(160)
RFInnerframe.Icon_Display.raid_buff_anchor_x:SetWidth(160)
RFInnerframe.Icon_Display.raid_buff_anchor_y:SetWidth(160)

RFInnerframe.Icon_Display.DividingLine = RFInnerframe.Icon_Display:CreateTexture(nil, "ARTWORK")
RFInnerframe.Icon_Display.DividingLine:SetSize(RFInnerframe.Icon_Display:GetWidth()-50, 1)
RFInnerframe.Icon_Display.DividingLine:SetPoint("TOP", 0, -360)
RFInnerframe.Icon_Display.DividingLine:SetColorTexture(1, 1, 1, .2)

T.createcheckbutton(RFInnerframe.Icon_Display, 60, 380, L["自动添加团队减益"], "UnitframeOptions", "debuff_auto_add", L["自动添加团队减益提示"])
T.createslider(RFInnerframe.Icon_Display, 60, 430, L["自动添加的图标层级"], "UnitframeOptions", "debuff_auto_add_level", 1, 1, 20, 1)

-- 团队减益
RFInnerframe.raiddebuff = CreateOptionPage("RF Options Raid Debuff", L["副本减益"], RFInnerframe, "VERTICAL", "UnitframeOptions")

RFInnerframe.raiddebuff.debuff_list = T.createscrolllist(RFInnerframe.raiddebuff, {"TOPLEFT", 10, -85}, false, 400, 370)

local function UpdateEncounterTitle(option_list, i, encounterID, y)
	if not option_list.titles[i] then
		local frame = CreateFrame("Frame", nil, option_list)
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

local function UpdateEncounterButton(option_list, encounterID, spellID, level, y)
	if not option_list.spells["icon"..encounterID.."_"..spellID] then
		local parent = RFInnerframe.raiddebuff
		local frame = T.createscrollbutton("spell", option_list, nil, nil, spellID)
		frame:SetWidth(380)
		
		frame.close:SetScript("OnClick", function() 
			frame:Hide()
			aCoreCDB[parent.db_key]["raid_debuffs"][parent.selected_InstanceID][encounterID][spellID] = nil
			option_list.OptionListChanged()
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
				UpdateEncounterButton(option_list, encounterID, spellID, level, y)
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
	option_list.OptionListChanged = DisplayRaidDebuffList
	
	-- 重置
	option_list.reset = T.createclicktexbutton(option_list, {"LEFT", parent.title, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])	
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
	option_list.back = T.createclicktexbutton(option_list, {"LEFT", parent.title, "RIGHT", 270, 0}, [[Interface\AddOns\AltzUI\media\refresh.tga]], BACK)
	T.SetupArrow(option_list.back.tex, "left")
	option_list.back:SetScript("OnClick", function() 
		option_list:Hide()
		parent.instance_list:Show()
	end)
	
	-- 首领下拉菜单
	option_list.encounterDD = CreateFrame("Frame", nil, option_list, "UIDropDownMenuTemplate")
	option_list.encounterDD:SetPoint("BOTTOMLEFT", option_list, "TOPLEFT", 0, 2)
	option_list.encounterDD.Text:SetFont(G.norFont, 12, "OUTLINE")
	F.ReskinDropDown(option_list.encounterDD)
	UIDropDownMenu_SetWidth(option_list.encounterDD, 120)
	
	-- 法术ID输入框
	option_list.spell_input = T.createinputbox(option_list, {"LEFT", option_list.encounterDD, "RIGHT", -5, 2}, L["输入法术ID"], 100)
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
	option_list.level_input = T.createinputbox(option_list, {"LEFT", option_list.spell_input, "RIGHT", 5, 0}, L["优先级"], 100)
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
	option_list.add = T.createclickbutton(option_list, 0, {"LEFT", option_list.level_input, "RIGHT", 5, 0}, ADD)
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
		DisplayRaidDebuffList()
		
		option_list.spell_input:SetText(L["输入法术ID"])
		option_list.spell_input.current_spellID = nil
		option_list.level_input:SetText(L["优先级"])
	end)
end

local CreateInstanceButton = function(frame, instanceID, instanceName, bgImage)
	local parent = RFInnerframe.raiddebuff
	local bu = T.createclickbutton(frame.anchor, 150, nil, instanceName, bgImage)
	
	bu:SetFrameLevel(frame.anchor:GetFrameLevel()+2)
	bu.tex:SetTexCoord(0, 1, .4, .6)
	bu.tex:SetAlpha(.3)
	
	if mod(frame.button_i, 2) == 1 then
		bu:SetPoint("TOPLEFT", frame.anchor, "TOPLEFT", 20+mod(frame.button_i+1, 2)*200, frame.y)
		frame.y = frame.y - 30
	else
		bu:SetPoint("TOPLEFT", frame.anchor, "TOPLEFT", 20+mod(frame.button_i+1, 2)*200, frame.y + 30)
	end
	
	bu:HookScript("OnMouseDown", function()
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

RFInnerframe.raiddebuff.instance_list = T.createscrolllist(RFInnerframe.raiddebuff, {"TOPLEFT", 25, -55}, false, 400, 370)
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
		RFOptions.hooked_tab:GetScript("OnMouseDown")()
		RFInnerframe.raiddebuff.hooked_tab:GetScript("OnMouseDown")()
		RFInnerframe.raiddebuff.instance_list.list[InstanceID]:GetScript("OnMouseDown")()
		RFInnerframe.raiddebuff.debuff_list.spells["icon"..encounterID.."_"..spellID]:GetScript("OnMouseDown")()
		
		GUI:Show()
		GUI.df:Show()
		GUI.scale:Show()
	elseif string.find(text, "delete") then
		if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] then
			aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] = nil
			DisplayRaidDebuffList()
			local spell = GetSpellInfo(spellID)
			aCoreCDB["UnitframeOptions"]["debuff_list_black"][spellID] = true
			print(string.format(L["已删除并加入黑名单"], T.GetIconLink(spellID)))
		end
	end
  end
end)

-- 全局减益
RFInnerframe.globaldebuff = CreateOptionPage("RF Options Raid Debuff Fliter List", L["全局减益"], RFInnerframe, "VERTICAL", "UnitframeOptions")

RFInnerframe.globaldebuff.whitelist = T.CreateAuraListOption(RFInnerframe.globaldebuff, {"TOPLEFT", 30, -55}, 200,  L["白名单"]..AURAS, "debuff_list", L["优先级"])
CreateDividingLine(RFInnerframe.globaldebuff, -250)
RFInnerframe.globaldebuff.blacklist = T.CreateAuraListOption(RFInnerframe.globaldebuff, {"TOPLEFT", RFInnerframe.globaldebuff.whitelist, "BOTTOMLEFT", 0, -10}, 200, L["黑名单"]..AURAS, "debuff_list_black")

-- 全局增益
RFInnerframe.globalbuff = CreateOptionPage("RF Options Cooldown Aura", L["全局增益"], RFInnerframe, "VERTICAL", "UnitframeOptions")

RFInnerframe.globalbuff.whitelist = T.CreateAuraListOption(RFInnerframe.globalbuff, {"TOPLEFT", 30, -60}, 380, L["白名单"]..AURAS, "buff_list", L["优先级"])
--====================================================--
--[[           -- Actionbar Options --              ]]--
--====================================================--
local ActionbarOptions = CreateOptionPage("Actionbar Options", ACTIONBARS_LABEL, GUI, "VERTICAL")
local ActionbarInnerframe = CreateInnerFrame(ActionbarOptions)

-- 样式
ActionbarInnerframe.common = CreateOptionPage("Actionbar Options common", L["样式"], ActionbarInnerframe, "VERTICAL", "ActionbarOptions")

T.createcheckbutton(ActionbarInnerframe.common, 30, 60, L["显示冷却时间"], "ActionbarOptions", "cooldown", L["显示冷却时间提示"])
T.createcheckbutton(ActionbarInnerframe.common, 30, 90, L["显示冷却时间"].." (Weakauras)", "ActionbarOptions", "cooldown_wa", L["显示冷却时间提示WA"])
T.createslider(ActionbarInnerframe.common, 30, 140, L["冷却时间数字大小"], "ActionbarOptions", "cooldownsize", 1, 18, 25, 1, L["冷却时间数字大小提示"])
T.createcheckbutton(ActionbarInnerframe.common, 30, 170, L["不可用颜色"], "ActionbarOptions", "rangecolor", L["不可用颜色提示"])
T.createslider(ActionbarInnerframe.common, 30, 220, L["键位字体大小"], "ActionbarOptions", "keybindsize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 260, L["宏名字字体大小"], "ActionbarOptions", "macronamesize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 300, L["可用次数字体大小"], "ActionbarOptions", "countsize", 1, 8, 20, 1)
T.createDR(ActionbarInnerframe.common.cooldown, ActionbarInnerframe.common.cooldown_wa, ActionbarInnerframe.common.cooldownsize)

-- 冷却提示
ActionbarInnerframe.cdflash = CreateOptionPage("Actionbar Options cdflash", L["冷却提示"], ActionbarInnerframe, "VERTICAL", "ActionbarOptions")
T.createcheckbutton(ActionbarInnerframe.cdflash, 30, 60, L["启用"], "ActionbarOptions", "cdflash_enable")

T.createslider(ActionbarInnerframe.cdflash, 30, 100, L["图标大小"], "ActionbarOptions", "cdflash_size", 1, 15, 100, 1)
ActionbarInnerframe.cdflash.cdflash_size:SetWidth(170)

T.createslider(ActionbarInnerframe.cdflash, 230, 100, L["透明度"], "ActionbarOptions", "cdflash_alpha", 1, 30, 100, 1)
ActionbarInnerframe.cdflash.cdflash_alpha:SetWidth(170)

CreateDividingLine(ActionbarInnerframe.cdflash, -120)

T.createDR(ActionbarInnerframe.cdflash.cdflash_enable, ActionbarInnerframe.cdflash.cdflash_size, ActionbarInnerframe.cdflash.cdflash_alpha, ActionbarInnerframe.cdflash.ignorespell_list, ActionbarInnerframe.cdflash.ignoreitem_list)

ActionbarInnerframe.cdflash.ignorespell_list = T.CreateAuraListOption(ActionbarInnerframe.cdflash, {"TOPLEFT", 30, -125}, 185, L["黑名单"]..SPELLS, "cdflash_ignorespells")

CreateDividingLine(ActionbarInnerframe.cdflash, -290)

ActionbarInnerframe.cdflash.ignoreitem_list = T.CreateItemListOption(ActionbarInnerframe.cdflash, {"TOPLEFT", 30, -300}, 185, L["黑名单"]..ITEMS, "cdflash_ignoreitems")

--====================================================--
--[[           -- NamePlates Options --             ]]--
--====================================================--
local PlateOptions = CreateOptionPage("Plate Options", UNIT_NAMEPLATES, GUI, "VERTICAL")
local PlateInnerframe = CreateInnerFrame(PlateOptions)

-- 通用
PlateInnerframe.common = CreateOptionPage("Nameplates Options common", L["通用设置"], PlateInnerframe, "VERTICAL", "PlateOptions")

T.createcheckbutton(PlateInnerframe.common, 30, 60, L["启用"], "PlateOptions", "enableplate")
T.CVartogglebox(PlateInnerframe.common, 160, 60, "nameplateShowAll", UNIT_NAMEPLATES_AUTOMODE, "1", "0")

T.createradiobuttongroup(PlateInnerframe.common, 30, 100, L["样式"], "theme", {
	{"class", L["职业色-条形"]},
	{"dark", L["深色-条形"]},
	{"number", L["数字样式"]},
})

T.createslider(PlateInnerframe.common, 30, 150, L["字体大小"], "PlateOptions", "fontsize", 1, 5, 25, 1)
T.createslider(PlateInnerframe.common, 230, 150, L["图标数字大小"], "PlateOptions", "numfontsize", 1, 5, 25, 1)
T.createslider(PlateInnerframe.common, 30, 190, L["光环"].." "..L["图标数量"], "PlateOptions", "plateauranum", 1, 3, 10, 1)
T.createslider(PlateInnerframe.common, 230, 190, L["光环"].." "..L["图标大小"], "PlateOptions", "plateaurasize", 1, 10, 30, 1)
PlateInnerframe.common.fontsize:SetWidth(160)
PlateInnerframe.common.numfontsize:SetWidth(160)
PlateInnerframe.common.plateauranum:SetWidth(160)
PlateInnerframe.common.plateaurasize:SetWidth(160)
T.createcolorpickerbu(PlateInnerframe.common, 30, 220, L["可打断施法条颜色"], "PlateOptions", "Interruptible_color")
T.createcolorpickerbu(PlateInnerframe.common, 230, 220, L["不可打断施法条颜色"], "PlateOptions", "notInterruptible_color")

T.createcheckbutton(PlateInnerframe.common, 30, 250, L["焦点染色"], "PlateOptions", "focuscolored")
T.createcolorpickerbu(PlateInnerframe.common, 230, 250, L["焦点颜色"], "PlateOptions", "focus_color")
T.createcheckbutton(PlateInnerframe.common, 30, 280, L["仇恨染色"], "PlateOptions", "threatcolor")

T.createDR(PlateInnerframe.common.enableplate, PlateInnerframe.common.theme, PlateInnerframe.common.fontsize, 
PlateInnerframe.common.threatcolor, PlateInnerframe.common.plateauranum, PlateInnerframe.common.plateaurasize,
PlateInnerframe.common.Interruptible_color, PlateInnerframe.common.notInterruptible_color)

-- 样式
PlateInnerframe.style = CreateOptionPage("Nameplates Options common", L["样式"], PlateInnerframe, "VERTICAL", "PlateOptions")
PlateInnerframe.style.title:SetText(L["条形样式"])

T.createslider(PlateInnerframe.style, 30, 80, L["宽度"], "PlateOptions", "bar_width", 1, 70, 150, 5)
T.createslider(PlateInnerframe.style, 230, 80, L["高度"], "PlateOptions", "bar_height", 1, 5, 25, 1)
PlateInnerframe.style.bar_width:SetWidth(160)
PlateInnerframe.style.bar_height:SetWidth(160)

T.createradiobuttongroup(PlateInnerframe.style, 30, 100, L["数值样式"], "bar_hp_perc", {
	{"perc", L["百分比"]},
	{"value_perc", L["数值和百分比"]},
})

T.createcheckbutton(PlateInnerframe.style, 30, 140, L["总是显示生命值"], "PlateOptions", "bar_alwayshp", L["总是显示生命值提示"])
T.createcheckbutton(PlateInnerframe.style, 30, 170, L["友方只显示名字"], "PlateOptions", "bar_onlyname")

PlateInnerframe.style.title2 = PlateInnerframe.style:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
PlateInnerframe.style.title2:SetPoint("TOPLEFT", 35, -220)
PlateInnerframe.style.title2:SetText(L["数值样式"])

PlateInnerframe.style.DividingLine2 = PlateInnerframe.style:CreateTexture(nil, "ARTWORK")
PlateInnerframe.style.DividingLine2:SetSize(PlateInnerframe.style:GetWidth()-50, 1)
PlateInnerframe.style.DividingLine2:SetPoint("TOP", 0, -245)
PlateInnerframe.style.DividingLine2:SetColorTexture(1, 1, 1, .2)

T.createslider(PlateInnerframe.style, 30, 280, string.format("%s(%s)", L["字体大小"], L["数字样式"]), "PlateOptions", "number_size", 1, 15, 35, 1)
PlateInnerframe.style.number_size:SetWidth(160)
T.createslider(PlateInnerframe.style, 230, 280, string.format("%s(%s)", L["姓名板资源尺寸"], L["数字样式"]), "PlateOptions", "number_cpwidth", 1, 5, 30, 1)
PlateInnerframe.style.number_cpwidth:SetWidth(160)
T.createcheckbutton(PlateInnerframe.style, 30, 310, string.format("%s(%s)", L["总是显示生命值"],L["数字样式"]), "PlateOptions", "number_alwayshp", L["总是显示生命值提示"])
T.createcheckbutton(PlateInnerframe.style, 30, 340, string.format("%s(%s)", L["根据血量染色"],L["数字样式"]), "PlateOptions", "number_colorheperc")

-- 玩家姓名板
PlateInnerframe.playerresource = CreateOptionPage("Player Resource Bar Options", L["玩家姓名板"], PlateInnerframe, "VERTICAL", "PlateOptions")

T.createcheckbutton(PlateInnerframe.playerresource, 30, 60, L["显示玩家姓名板"], "PlateOptions", "playerplate")
T.createcheckbutton(PlateInnerframe.playerresource, 70, 90, L["显示玩家姓名板光环"], "PlateOptions", "plateaura")
T.createcheckbutton(PlateInnerframe.playerresource, 70, 120, L["显示玩家施法条"], "PlateOptions", "platecastbar")
T.createcheckbutton(PlateInnerframe.playerresource, 30, 150, DISPLAY_PERSONAL_RESOURCE, "PlateOptions", "classresource_show")

T.createradiobuttongroup(PlateInnerframe.playerresource, 70, 180, L["姓名板资源位置"], "classresource_pos", {
	{"target", L["目标姓名板"]},
	{"player", L["玩家姓名板"]},
})

T.createDR(PlateInnerframe.playerresource.playerplate, PlateInnerframe.playerresource.plateaura)
T.createDR(PlateInnerframe.playerresource.classresource_show, PlateInnerframe.playerresource.classresource_pos)

-- 光环过滤列表
PlateInnerframe.auralist = CreateOptionPage("Plate Options Aura", L["光环"], PlateInnerframe, "VERTICAL", "PlateOptions")

PlateInnerframe.auralist.my_filter = T.CreateAuraListOption(PlateInnerframe.auralist, {"TOPLEFT", 30, -55}, 200, L["我施放的光环"], "myplateauralist")

T.createradiobuttongroup(PlateInnerframe.auralist.my_filter, -5, 40, L["过滤方式"], "myfiltertype", {
	"none", L["全部隐藏"],
	"whitelist", L["白名单"]..AURAS,
	"blacklist", L["黑名单"]..AURAS,
})

PlateInnerframe.auralist.my_filter.reset.apply = function()
	aCoreCDB["PlateOptions"]["myfiltertype"] = nil
end

PlateInnerframe.auralist.my_filter.option_list:ClearAllPoints()
PlateInnerframe.auralist.my_filter.option_list:SetPoint("TOPLEFT", 0, -65)

CreateDividingLine(PlateInnerframe.auralist, -260)

PlateInnerframe.auralist.other_filter = T.CreateAuraListOption(PlateInnerframe.auralist, {"TOPLEFT", 30, -265}, 200, L["其他人施放的光环"], "otherplateauralist")

T.createradiobuttongroup(PlateInnerframe.auralist.other_filter, -5, 40, L["过滤方式"], "otherfiltertype", {
	{"none", L["全部隐藏"]},
	{"whitelist", L["白名单"]..AURAS},
})

PlateInnerframe.auralist.other_filter.reset.apply = function()
	aCoreCDB["PlateOptions"]["otherfiltertype"] = nil
end

PlateInnerframe.auralist.other_filter.option_list:ClearAllPoints()
PlateInnerframe.auralist.other_filter.option_list:SetPoint("TOPLEFT", 0, -65)

-- 自定义
PlateInnerframe.custom = CreateOptionPage("Plate Options Custom", CUSTOM, PlateInnerframe, "VERTICAL", "PlateOptions")

PlateInnerframe.custom.color = T.CreatePlateColorListOption(PlateInnerframe.custom,  {"TOPLEFT", 30, -55}, 200, L["自定义颜色"], "customcoloredplates")
PlateInnerframe.custom.color.reset.apply = function()
	aCoreCDB["UnitframeOptions"]["customcoloredplates"] = nil
end

PlateInnerframe.custom.power = T.CreatePlatePowerListOption(PlateInnerframe.custom,  {"TOPLEFT", PlateInnerframe.custom.color, "BOTTOMLEFT", 0, -10}, 200, L["自定义能量"], "custompowerplates")
PlateInnerframe.custom.power.reset.apply = function()
	aCoreCDB["UnitframeOptions"]["custompowerplates"] = nil
end
--====================================================--
--[[             -- Tooltip Options --              ]]--
--====================================================--
local TooltipOptions = CreateOptionPage("Tooltip Options", USE_UBERTOOLTIPS, GUI, "VERTICAL", "TooltipOptions")

T.createcheckbutton(TooltipOptions, 30, 60, L["启用"], "TooltipOptions", "enabletip")
T.createcheckbutton(TooltipOptions, 30, 120, L["战斗中隐藏"], "TooltipOptions", "combathide")

T.createDR(TooltipOptions.enabletip, TooltipOptions.combathide)
--====================================================--
--[[             -- Combattext Options --              ]]--
--====================================================--
local CombattextOptions = CreateOptionPage("CombatText Options", L["战斗信息"], GUI, "VERTICAL", "CombattextOptions")

T.createcheckbutton(CombattextOptions, 30, 60, L["启用"], "CombattextOptions", "combattext")
T.createcheckbutton(CombattextOptions, 30, 90, L["隐藏浮动战斗信息接受"], "CombattextOptions", "hidblz_receive")
T.createcheckbutton(CombattextOptions, 30, 120, L["隐藏浮动战斗信息输出"], "CombattextOptions", "hidblz")
T.createcheckbutton(CombattextOptions, 30, 150, L["承受伤害/治疗"], "CombattextOptions", "showreceivedct")
T.createcheckbutton(CombattextOptions, 30, 180, L["输出伤害/治疗"], "CombattextOptions", "showoutputct")
T.createslider(CombattextOptions, 30, 230, L["图标大小"], "CombattextOptions", "cticonsize", 1, 10, 30, 1)
T.createslider(CombattextOptions, 30, 270, L["暴击图标大小"], "CombattextOptions", "ctbigiconsize", 1, 10, 30, 1)
T.createcheckbutton(CombattextOptions, 30, 300, L["显示DOT"], "CombattextOptions", "ctshowdots")
T.createcheckbutton(CombattextOptions, 30, 330, L["显示HOT"], "CombattextOptions", "ctshowhots")
T.createcheckbutton(CombattextOptions, 30, 360, L["显示宠物"], "CombattextOptions", "ctshowpet")
T.createslider(CombattextOptions, 30, 410, L["隐藏时间"], "CombattextOptions", "ctfadetime", 10, 20, 100, 5, L["隐藏时间提示"])

T.createDR(CombattextOptions.combattext, CombattextOptions.hidblz_receive, CombattextOptions.hidblz, CombattextOptions.showreceivedct, CombattextOptions.showoutputct, CombattextOptions.cticonsize, CombattextOptions.ctbigiconsize, CombattextOptions.ctshowdots, CombattextOptions.ctshowhots, CombattextOptions.ctshowpet, CombattextOptions.ctfadetime)

--====================================================--
--[[              -- Other Options --                ]]--
--====================================================--
local OtherOptions = CreateOptionPage("Other Options", OTHER, GUI, "VERTICAL", "OtherOptions")

T.createcheckbutton(OtherOptions, 30, 60, L["自动召宝宝"], "OtherOptions", "autopet", L["自动召宝宝提示"])
T.createcheckbutton(OtherOptions, 300, 60, L["随机奖励"], "OtherOptions", "LFGRewards", L["随机奖励提示"])
T.createcheckbutton(OtherOptions, 30, 90, L["稀有警报"], "OtherOptions", "vignettealert", L["稀有警报提示"])
T.createcheckbutton(OtherOptions, 300, 90, L["自动交接任务"], "OtherOptions", "autoquests", L["自动交接任务提示"])
T.createcheckbutton(OtherOptions, 30, 120, L["战场自动释放灵魂"], "OtherOptions", "battlegroundres", L["战场自动释放灵魂提示"])
T.createcheckbutton(OtherOptions, 300, 120, L["自动接受复活"], "OtherOptions", "acceptres", L["自动接受复活提示"])

CreateDividingLine(OtherOptions, -230)

T.createcheckbutton(OtherOptions, 30, 240, L["任务栏闪动"], "OtherOptions", "flashtaskbar", L["任务栏闪动提示"])
T.createcheckbutton(OtherOptions, 300, 240, L["隐藏错误提示"], "OtherOptions", "hideerrors", L["隐藏错误提示提示"])	
T.createcheckbutton(OtherOptions, 300, 270, L["成就截图"], "OtherOptions", "autoscreenshot", L["成就截图提示"])
T.CVartogglebox(OtherOptions, 30, 300, "screenshotQuality", L["提升截图画质"], "10", "1")
T.CVartogglebox(OtherOptions, 300, 300, "screenshotFormat", L["截图保存为tga格式"], "tga", "jpg", "截图保存为tga提示")

if G.Client == "zhCN" then
	CreateDividingLine(OtherOptions, -350)
	T.CVartogglebox(OtherOptions, 30, 390, "overrideArchive", "反和谐(大退生效)", "0", "1")
end
--====================================================--
--[[               -- Commands --               ]]--
--====================================================--
local Comands = CreateOptionPage("Comands", L["命令"], GUI, "VERTICAL")

Comands.text = T.createtext(Comands, "OVERLAY", 12, "OUTLINE", "LEFT")
Comands.text:SetPoint("TOPLEFT", 30, -60)
Comands.text:SetText(format(L["指令"], G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor))

--====================================================--
--[[               -- Credits --               ]]--
--====================================================--
local Credits = CreateOptionPage("Credits", L["制作"], GUI, "VERTICAL")

Credits.text = T.createtext(Credits, "OVERLAY", 12, "OUTLINE", "CENTER")
Credits.text:SetPoint("CENTER")
Credits.text:SetText(format(L["制作说明"], G.Version, G.classcolor, "fgprodigal susnow Zork Haste Tukz Haleth Qulight Freebaser Monolit warbaby siweia"))

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
MinimapButton.icon:SetSize(20,20)
MinimapButton.icon:SetPoint("CENTER")
MinimapButton.icon:SetTexCoord(.1, .9, .1, .9)

MinimapButton.icon2 = MinimapButton:CreateTexture(nil, "BORDER")
MinimapButton.icon2:SetTexture(348547)
MinimapButton.icon2:SetSize(20,20)
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
