local T, C, L, G = unpack(select(2, ...))
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

-- 控制台标签
GUI.tabindex = 1
GUI.tabnum = 20
for i = 1, 20 do
	GUI["tab"..i] = CreateFrame("Frame", G.uiname.."GUI Tab"..i, GUI, "BackdropTemplate")
	GUI["tab"..i]:SetScript("OnMouseDown", function() end)
end

-- 输入框和按钮
GUI.editbox = T.createeditbox(GUI, nil, nil, L["复制粘贴"])
GUI.editbox:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", 155, -8)
GUI.editbox:SetPoint("BOTTOMRIGHT", GUI, "BOTTOMRIGHT", -5, -28)
GUI.editbox:Hide()

GUI.editbox.name:ClearAllPoints()
GUI.editbox.name:SetPoint("RIGHT", GUI.editbox, "LEFT", -5, 1)

GUI.editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
GUI.editbox:SetScript("OnEditFocusLost", function(self) self:HighlightText(0,0) end)
GUI.editbox:SetScript("OnHide", function(self) self.button:Hide() end)

GUI.editbox.bg = CreateFrame("Frame", nil, GUI.editbox, "BackdropTemplate")
GUI.editbox.bg:SetPoint("TOPLEFT", GUI, "BOTTOMLEFT", 0, -3)
GUI.editbox.bg:SetPoint("BOTTOMRIGHT", GUI, "BOTTOMRIGHT", 0, -31)
GUI.editbox.bg:SetFrameLevel(GUI:GetFrameLevel()-1)
F.SetBD(GUI.editbox.bg)

GUI.editbox.button = T.createclickbutton(GUI.editbox, {"RIGHT", GUI.editbox, "RIGHT", -2, 0}, OKAY)
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

GUI.wowi = T.createclicktexbutton(GUI, {"LEFT", GUI.GitHub, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\Guild.tga]], "WoWInterface", 20)
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

GUI.export = T.createclicktexbutton(GUI, {"LEFT", GUI.wowi, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["导出"])
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

GUI.import = T.createclicktexbutton(GUI, {"LEFT", GUI.export, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["导入"])
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

GUI.reset = T.createclicktexbutton(GUI, {"LEFT", GUI.import, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])
GUI.reset:SetScript("OnClick", function()
	GUI.editbox:Hide()
	GUI.editbox.type = nil
	
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

GUI.unlock = T.createclicktexbutton(GUI, {"LEFT", GUI.reset, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["解锁框体"])
GUI.unlock:SetScript("OnClick", function()	
	GUI.editbox:Hide()
	GUI.editbox.type = nil
	
	T.UnlockAll()
	GUI:Hide()
	GUI.df:Hide()
	GUI.scale:Hide()
end)

GUI.reload = T.createclicktexbutton(GUI, {"LEFT", GUI.unlock, "RIGHT", 2, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], RELOADUI)
GUI.reload:SetScript("OnClick", ReloadUI)

GUI.close = T.createclicktexbutton(GUI, {"BOTTOMRIGHT", GUI, "BOTTOMRIGHT", -5, 0}, [[Interface\AddOns\AltzUI\media\icons\exit.tga]])
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
	Options.line:SetColorTexture(1, 1, 1, .2)
	
	if scroll then -- 需要修改
		--print(name)
		Options.SF = CreateFrame("ScrollFrame", G.uiname..name.." ScrollFrame", Options, "UIPanelScrollFrameTemplate")
		Options.SF:SetPoint("TOPLEFT", Options, "TOPLEFT", 10, -80)
		Options.SF:SetPoint("BOTTOMRIGHT", Options, "BOTTOMRIGHT", -45, 35)
		Options.SF:SetFrameLevel(Options:GetFrameLevel()+1)
		Options.SF.bg = CreateFrame("Frame", nil, Options.SF, "BackdropTemplate")
		Options.SF.bg:SetAllPoints(Options.SF)
	
		Options.SFAnchor = CreateFrame("Frame", G.uiname..name.."ScrollAnchor", Options.SF)
		Options.SFAnchor:SetPoint("TOPLEFT", Options.SF, "TOPLEFT", 0, -3)
		Options.SFAnchor:SetWidth(Options.SF:GetWidth()-30)
		Options.SFAnchor:SetHeight(Options.SF:GetHeight()+200)
		Options.SFAnchor:SetFrameLevel(Options.SF:GetFrameLevel()+1)
		
		Options.SF:SetScrollChild(Options.SFAnchor)
		
		F.ReskinScroll(Options.SF.ScrollBar)
		
		Options.SF.Cover = CreateFrame("Frame", nil, Options.SF)
		Options.SF.Cover:SetAllPoints()
		Options.SF.Cover:SetFrameLevel(Options.SFAnchor:GetFrameLevel()+10)
		Options.SF.Cover.tex = Options.SF.Cover:CreateTexture(nil, "OVERLAY")
		Options.SF.Cover.tex:SetAllPoints()
		Options.SF.Cover.tex:SetColorTexture(.3, .3, .3, .7)
		Options.SF.Cover:EnableMouse(true)
		Options.SF.Cover:Hide()
		
		Options.SF.Enable = function()
			Options.SF.Cover:Hide()
		end
		
		Options.SF.Disable = function()
			Options.SF.Cover:Show()
		end
	end
	
	return Options
end

--====================================================--
--[[            -- Interface Options --            ]]--
--====================================================--
local SkinOptions = CreateOptionPage("Interface Options", L["界面"], GUI, "VERTICAL")
SkinOptions:Show()

local SInnerframe = CreateFrame("Frame", G.uiname.."Interface Options Innerframe", SkinOptions, "BackdropTemplate")
SInnerframe:SetPoint("TOPLEFT", 40, -60)
SInnerframe:SetPoint("BOTTOMLEFT", -20, 25)
SInnerframe:SetWidth(SkinOptions:GetWidth()-200)
F.CreateBD(SInnerframe, .3)

SInnerframe.tabindex = 1
SInnerframe.tabnum = 20
for i = 1, 20 do
	SInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."SInnerframe Tab"..i, SInnerframe, "BackdropTemplate")
	SInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

SInnerframe.theme = CreateOptionPage("Interface Options theme", L["界面风格"], SInnerframe, "VERTICAL", .3)
SInnerframe.theme:Show()

local style_group = {
	[1] = L["透明样式"],
	[2] = L["深色样式"],
	[3] = L["普通样式"],
}
T.createradiobuttongroup(SInnerframe.theme, 30, 60, L["样式"], "UnitframeOptions", "style", style_group)
SInnerframe.theme.style.apply = function()
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
end

local combattextfont_group = {
	["none"] = DEFAULT,
	["combat1"] = "1234",
	["combat2"] = "1234",
	["combat3"] = "1234",
}
T.createradiobuttongroup(SInnerframe.theme, 30, 90, L["战斗字体"], "SkinOptions", "combattext", combattextfont_group)
local CLIENT_RESTART_ALERT_SHOW
for index, v in pairs(combattextfont_group) do
	if index ~= "none" then
		SInnerframe.theme.combattext[index].text:SetFont(G.combatFont[index], 10, "OUTLINE")	
	end
	SInnerframe.theme.combattext[index]:HookScript("OnClick", function()
		if not CLIENT_RESTART_ALERT_SHOW then
			StaticPopup_Show("CLIENT_RESTART_ALERT")
			CLIENT_RESTART_ALERT_SHOW = true
		end
	end)
end

local textformattype_group = {
	["k"] = "k m",
	["w"] = "w kw",
	["w_chinese"] = "万 千万",
	["none"] = "不缩写",
}

local textformattype_order = {
	["k"] = 1,
	["w"] = 2,
	["w_chinese"] = 3,
	["none"] = 4,
}

T.createradiobuttongroup(SInnerframe.theme, 30, 120, L["数字缩写样式"], "SkinOptions", "formattype", textformattype_group, nil, textformattype_order)

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

-- 布局
SInnerframe.layout = CreateOptionPage("Interface Options Layout", L["界面布局"], SInnerframe, "VERTICAL", .3)
T.createcheckbutton(SInnerframe.layout, 30, 60, L["信息条"], "SkinOptions", "infobar")
SInnerframe.layout.infobar.apply = G.InfoFrame.Apply

T.createslider(SInnerframe.layout, 30, 110, L["信息条尺寸"], "SkinOptions", "infobarscale", 100, 50, 200, 5)
SInnerframe.layout.infobarscale.apply = G.InfoFrame.Apply

T.createDR(SInnerframe.layout.infobar, SInnerframe.layout.infobarscale)

CreateDividingLine(SInnerframe.layout, -150)

T.createcheckbutton(SInnerframe.layout, 30, 170, L["在副本中收起任务追踪"], "SkinOptions", "collapseWF", L["在副本中收起任务追踪提示"])
T.createcheckbutton(SInnerframe.layout, 30, 200, L["登陆屏幕"], "SkinOptions", "afklogin", L["登陆屏幕"])
T.createcheckbutton(SInnerframe.layout, 30, 230, L["暂离屏幕"], "SkinOptions", "afkscreen", L["暂离屏幕"])

--====================================================--
--[[              -- Chat Options --                ]]--
--====================================================--
local ChatOptions = CreateOptionPage("Chat Options", SOCIAL_LABEL, GUI, "VERTICAL")

T.createcheckbutton(ChatOptions, 30, 60, L["频道缩写"], "ChatOptions", "channelreplacement")
ChatOptions.channelreplacement.apply = T.UpdateChannelReplacement
T.CVartogglebox(ChatOptions, 230, 60, "showTimestamps", SHOW_TIMESTAMP, "|cff64C2F5%H:%M|r ", "none")
T.createcheckbutton(ChatOptions, 30, 90, L["滚动聊天框"], "ChatOptions", "autoscroll", L["滚动聊天框提示"])
T.createcheckbutton(ChatOptions, 230, 90, L["显示聊天框背景"], "ChatOptions", "showbg")
ChatOptions.showbg.apply = T.UpdateChatFrameBg

CreateDividingLine(ChatOptions, -130)

T.createcheckbutton(ChatOptions, 30, 140, L["聊天过滤"], "ChatOptions", "nogoldseller", L["聊天过滤提示"])
T.createslider(ChatOptions, 30, 190, L["过滤阈值"], "ChatOptions", "goldkeywordnum", 1, 1, 5, 1, L["过滤阈值"])

T.createmultilinebox(ChatOptions, 200, 100, 35, 235, L["关键词"], "ChatOptions", "goldkeywordlist", L["关键词输入"])
ChatOptions.goldkeywordlist.edit:SetScript("OnShow", function(self) 
	self:SetText(aCoreDB["goldkeywordlist"])
end)
ChatOptions.goldkeywordlist.edit:SetScript("OnEscapePressed", function(self)
	self:SetText(aCoreDB["goldkeywordlist"])
	self:ClearFocus()
end)
ChatOptions.goldkeywordlist.edit:SetScript("OnEnterPressed", function(self) 
	self:ClearFocus() 
	aCoreDB["goldkeywordlist"] = self:GetText()
	T.Update_Chat_Filter()
end)
T.createDR(ChatOptions.nogoldseller, ChatOptions.goldkeywordnum, ChatOptions.goldkeywordlist)

CreateDividingLine(ChatOptions, -360)

T.createcheckbutton(ChatOptions, 30, 370, L["自动邀请"], "OtherOptions", "autoinvite", L["自动邀请提示"])
T.createeditbox(ChatOptions, 40, 400, "", "OtherOptions", "autoinvitekeywords", L["关键词输入"])
ChatOptions.autoinvitekeywords.apply = T.Update_Invite_Keyword
T.createDR(ChatOptions.autoinvite, ChatOptions.autoinvitekeywords)

--====================================================--
--[[          -- Bag and Items Options --           ]]--
--====================================================--
local ItemOptions = CreateOptionPage("Item Options", ITEMS, GUI, "VERTICAL")

T.createcheckbutton(ItemOptions, 30, 60, L["已会配方着色"], "ItemOptions", "alreadyknown", L["已会配方着色提示"])

CreateDividingLine(ItemOptions, -110)

T.createcheckbutton(ItemOptions, 30, 120, L["自动修理"], "ItemOptions", "autorepair", L["自动修理提示"])
T.createcheckbutton(ItemOptions, 30, 150, L["自动公会修理"], "ItemOptions", "autorepair_guild", L["自动公会修理提示"])
T.createcheckbutton(ItemOptions, 230, 150, L["灵活公会修理"], "ItemOptions", "autorepair_guild_auto", L["灵活公会修理提示"])

CreateDividingLine(ItemOptions, -200)

T.createcheckbutton(ItemOptions, 30, 210, L["自动售卖"], "ItemOptions", "autosell", L["自动售卖提示"])
T.createcheckbutton(ItemOptions, 30, 240, L["自动购买"], "ItemOptions", "autobuy", L["自动购买提示"])

ItemOptions.autobuy_list = T.createscrolllist(ItemOptions, {"TOPLEFT", ItemOptions, "TOPLEFT", 40, -310}, true, nil, 215)

local CreateAutobuyButton = function(itemID)
	local bu = T.createlistbutton(ItemOptions.autobuy_list.anchor)
	
	bu:SetScript("OnEnter", function(self)	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(itemID)
		GameTooltip:Show()
	end)
	
	bu:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	bu.on_delete = function()
		aCoreCDB["ItemOptions"]["autobuylist"][itemID] = nil
		T.lineuplist(aCoreCDB["ItemOptions"]["autobuylist"], ItemOptions.autobuy_list.list, ItemOptions.autobuy_list.anchor)
	end
	
	ItemOptions.autobuy_list.list[itemID] = bu
	
	return bu
end

ItemOptions.autobuy_list:SetScript("OnShow", function()
	for itemID, quantity in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
		local name = GetItemInfo(itemID)
		local icon = select(10, GetItemInfo(itemID))
		local bu = ItemOptions.autobuy_list.list[itemID] or CreateAutobuyButton(itemID)
		bu.display(icon, name, nil, quantity)
	end
	T.lineuplist(aCoreCDB["ItemOptions"]["autobuylist"], ItemOptions.autobuy_list.list, ItemOptions.autobuy_list.anchor)
end)

ItemOptions.autobuy_iteminput = T.createinputbox(ItemOptions, {"TOPLEFT", 40, -280}, L["物品名称ID链接"], 150, true)
function ItemOptions.autobuy_iteminput:apply()
	local text = self:GetText()
	local itemID, _, _, _, itemTexture = GetItemInfoInstant(text)
	if itemID then
		local itemName = GetItemInfo(itemID)
		self:SetText(itemName)
	else
		StaticPopupDialogs[G.uiname.."incorrect item ID"].text = "|cff7FFF00"..text.." |r"..L["不正确的物品ID"]
		StaticPopup_Show(G.uiname.."incorrect item ID")
		self:SetText(L["物品名称ID链接"])
	end
end
	
ItemOptions.autobuy_quantityinput = T.createinputbox(ItemOptions, {"LEFT", ItemOptions.autobuy_iteminput, "RIGHT", 15, 0}, L["数量"], 80)
function ItemOptions.autobuy_quantityinput:apply()
	local quantity = self:GetText()
	if tonumber(quantity) then
		self:SetText(quantity)
	else
		StaticPopupDialogs[G.uiname.."incorrect item quantity"].text = "|cff7FFF00"..quantity.." |r"..L["不正确的数量"]
		StaticPopup_Show(G.uiname.."incorrect item quantity")
		self:SetText(L["数量"])
	end
end

ItemOptions.autobuy_additembutton = T.createclickbutton(ItemOptions, {"LEFT", ItemOptions.autobuy_quantityinput, "RIGHT", 15, 0}, ADD)
ItemOptions.autobuy_additembutton:SetScript("OnClick", function(self)
	local text = ItemOptions.autobuy_iteminput:GetText()
	local quantity = ItemOptions.autobuy_quantityinput:GetText()
	local itemID, _, _, _, itemTexture = GetItemInfoInstant(text) 

	if itemID and tonumber(quantity) then
		local itemName = GetItemInfo(itemID)
		aCoreCDB["ItemOptions"]["autobuylist"][itemID] = quantity

		local bu = ItemOptions.autobuy_list.list[itemID] or CreateAutobuyButton(itemID)
		bu.display(itemTexture, itemName, nil, quantity)
		bu:Show()
		
		T.lineuplist(aCoreCDB["ItemOptions"]["autobuylist"], ItemOptions.autobuy_list.list, ItemOptions.autobuy_list.anchor)
	else
		if not itemID then
			StaticPopupDialogs[G.uiname.."incorrect item ID"].text = "|cff7FFF00"..((text == L["物品名称ID链接"] and "") or text).." |r"..L["不正确的物品ID"]
			StaticPopup_Show(G.uiname.."incorrect item ID")
		elseif not tonumber(quantity) then
			StaticPopupDialogs[G.uiname.."incorrect item quantity"].text = "|cff7FFF00"..((quantity == L["数量"] and "") or quantity).." |r"..L["不正确的数量"]
			StaticPopup_Show(G.uiname.."incorrect item quantity")
		end
	end
	ItemOptions.autobuy_iteminput:SetText(L["物品名称ID链接"])
	ItemOptions.autobuy_quantityinput:SetText(L["数量"])
end)

T.createDR(ItemOptions.autobuy, ItemOptions.autobuy_list, ItemOptions.autobuy_iteminput, ItemOptions.autobuy_quantityinput, ItemOptions.autobuy_additembutton)
--====================================================--
--[[               -- Unit Frames --                ]]--
--====================================================--
local UFOptions = CreateOptionPage("UF Options", L["单位框体"], GUI, "VERTICAL")

local UFInnerframe = CreateFrame("Frame", G.uiname.."UF Options Innerframe", UFOptions, "BackdropTemplate")
UFInnerframe:SetPoint("TOPLEFT", 40, -60)
UFInnerframe:SetPoint("BOTTOMLEFT", -20, 25)
UFInnerframe:SetWidth(UFOptions:GetWidth()-200)
F.CreateBD(UFInnerframe, .3)

UFInnerframe.tabindex = 1
UFInnerframe.tabnum = 20
for i = 1, 20 do
	UFInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."UFInnerframe Tab"..i, UFInnerframe, "BackdropTemplate")
	UFInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

-- 样式
UFInnerframe.style = CreateOptionPage("UF Options style", L["样式"], UFInnerframe, "VERTICAL", .3)
UFInnerframe.style:Show()

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
UFInnerframe.size = CreateOptionPage("UF Options size", L["尺寸"], UFInnerframe, "VERTICAL", .3)

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
UFInnerframe.castbar = CreateOptionPage("UF Options castbar", L["施法条"], UFInnerframe, "VERTICAL", .3)

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
	["LEFT"] = L["左"],
	["TOPLEFT"] = L["左上"],
	["RIGHT"] = L["右"],
	["TOPRIGHT"] = L["右上"],
}
T.createradiobuttongroup(UFInnerframe.castbar, 30, 290, L["法术名称位置"], "UnitframeOptions", "namepos", CBtextpos_group)
UFInnerframe.castbar.namepos.apply = function()
	T.ApplyUFSettings({"Castbar"})
end

T.createradiobuttongroup(UFInnerframe.castbar, 30, 320, L["施法时间位置"], "UnitframeOptions", "timepos", CBtextpos_group)
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
UFInnerframe.swingtimer = CreateOptionPage("UF Options swingtimer", L["平砍计时条"], UFInnerframe, "VERTICAL", .3)

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
UFInnerframe.aura = CreateOptionPage("UF Options aura", AURAS, UFInnerframe, "VERTICAL", .3)

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

UFInnerframe.aura.aurafliter_title = T.createtext(UFInnerframe.aura, "OVERLAY", 14, "OUTLINE", "LEFT")
UFInnerframe.aura.aurafliter_title:SetPoint("TOPLEFT", UFInnerframe.aura, "TOPLEFT", 30, -215)
UFInnerframe.aura.aurafliter_title:SetText(AURAS..L["白名单"])

UFInnerframe.aura.aura_list = T.createscrolllist(UFInnerframe.aura, {"TOPLEFT", UFInnerframe.aura, "TOPLEFT", 30, -265}, true, nil, 160)

local CreateAuraFilterButton = function(spellID)
	local bu = T.createlistbutton(UFInnerframe.aura.aura_list.anchor)
	
	bu:SetScript("OnEnter", function(self)	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	
	bu:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	bu.on_delete = function()		
		aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = nil	
		T.lineuplist(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"], UFInnerframe.aura.aura_list.list, UFInnerframe.aura.aura_list.anchor)
	end
	
	UFInnerframe.aura.aura_list.list[spellID] = bu
	
	return bu
end

UFInnerframe.aura.aura_list:SetScript("OnShow", function()
	for spellID, _ in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do
		local spellName, _, spellIcon = GetSpellInfo(spellID)
		local bu = UFInnerframe.aura.aura_list.list[spellID] or CreateAuraFilterButton(spellID)
		bu.display(spellIcon, spellName, spellID)
	end
	T.lineuplist(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"], UFInnerframe.aura.aura_list.list, UFInnerframe.aura.aura_list.anchor)
end)

UFInnerframe.aura.aurafilter_spellIDinput = T.createinputbox(UFInnerframe.aura, {"TOPLEFT", 30, -235}, L["输入法术ID"], 320)
function UFInnerframe.aura.aurafilter_spellIDinput:apply()
	local text = self:GetText()
	local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(text)
	if spellName then
		aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][spellID] = true
		local bu = UFInnerframe.aura.aura_list.list[spellID] or CreateAuraFilterButton(spellID)
		bu.display(spellIcon, spellName, spellID)
		bu:Show()
		T.lineuplist(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"], UFInnerframe.aura.aura_list.list, UFInnerframe.aura.aura_list.anchor)
	else
		StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..text.." |r"..L["不是一个有效的法术ID"]
		StaticPopup_Show(G.uiname.."incorrect spellid")
	end
	self:SetText(L["输入法术ID"])
end

UFInnerframe.aura.aurafilter_spellIDinput:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
	GameTooltip:AddLine(L["白名单提示"])
	GameTooltip:Show() 
end)

UFInnerframe.aura.aurafilter_spellIDinput:SetScript("OnLeave", function(self) 
	GameTooltip:Hide()
end)

-- 图腾
UFInnerframe.totembar = CreateOptionPage("UF Options totembar", L["图腾条"], UFInnerframe, "VERTICAL", .3)

T.createcheckbutton(UFInnerframe.totembar, 30, 60, L["启用"], "UnitframeOptions", "totems")
UFInnerframe.totembar.totems.apply = T.ApplyTotemsBarSettings

T.createslider(UFInnerframe.totembar, 30, 110, L["图标大小"], "UnitframeOptions", "totemsize", 1, 15, 40, 1)
UFInnerframe.totembar.totemsize.apply = T.ApplyTotemsBarSettings

local totembargrowthdirection_group = {
	["HORIZONTAL"] = L["水平"],
	["VERTICAL"] = L["垂直"],
}
T.createradiobuttongroup(UFInnerframe.totembar, 30, 140, L["排列方向"], "UnitframeOptions", "growthDirection", totembargrowthdirection_group)
UFInnerframe.totembar.growthDirection.apply = T.ApplyTotemsBarSettings

local totembarinneranchor_group = {
	["ASCENDING"] = L["正向"],
	["DESCENDING"] = L["反向"],
}
T.createradiobuttongroup(UFInnerframe.totembar, 30, 170, L["排列方向"], "UnitframeOptions", "sortDirection", totembarinneranchor_group)
UFInnerframe.totembar.sortDirection.apply = T.ApplyTotemsBarSettings

-- 小队
UFInnerframe.party = CreateOptionPage("UF Options party", PARTY, UFInnerframe, "VERTICAL", .3)

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
UFInnerframe.other = CreateOptionPage("UF Options other", OTHER, UFInnerframe, "VERTICAL", .3)

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

local RFInnerframe = CreateFrame("Frame", G.uiname.."RF Options Innerframe", RFOptions, "BackdropTemplate")
RFInnerframe:SetPoint("TOPLEFT", 40, -60)
RFInnerframe:SetPoint("BOTTOMLEFT", -20, 25)
RFInnerframe:SetWidth(RFOptions:GetWidth()-200)
F.CreateBD(RFInnerframe, .3)

RFInnerframe.tabindex = 1
RFInnerframe.tabnum = 20
for i = 1, 20 do
	RFInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."RFInnerframe Tab"..i, RFInnerframe, "BackdropTemplate")
	RFInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

-- 通用
RFInnerframe.common = CreateOptionPage("RF Options common", L["启用"], RFInnerframe, "VERTICAL", .3)
RFInnerframe.common:Show()

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
RFInnerframe.style = CreateOptionPage("RF Options style", L["样式"], RFInnerframe, "VERTICAL", .3)

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
RFInnerframe.ind = CreateOptionPage("RF Options indicators", L["治疗指示器"], RFInnerframe, "VERTICAL", .3)

T.createslider(RFInnerframe.ind, 30, 80, L["尺寸"], "UnitframeOptions", "hotind_size", 1, 10, 25, 1)
RFInnerframe.ind.hotind_size.apply = function()
	T.ApplyUFSettings({"AltzIndicators", "Auras"})
end

local indicatorstyle_group = {
	["number_ind"] = L["数字指示器"],
	["icon_ind"] = L["图标指示器"],
}
T.createradiobuttongroup(RFInnerframe.ind, 30, 100, L["样式"], "UnitframeOptions", "hotind_style", indicatorstyle_group)

local function Updateindsettings()
	if aCoreCDB["UnitframeOptions"]["hotind_style"] == "icon_ind" then
		RFInnerframe.ind.aurafliter_title:SetTextColor(1, 1, 1)	
		RFInnerframe.ind.hotind_filtertype:Enable()
		RFInnerframe.ind.hotind_spellIDinput:Enable()
		RFInnerframe.ind.hotind_list:Enable()
	else
		RFInnerframe.ind.aurafliter_title:SetTextColor(.5, .5, .5)
		RFInnerframe.ind.hotind_filtertype:Disable()
		RFInnerframe.ind.hotind_spellIDinput:Disable()
		RFInnerframe.ind.hotind_list:Disable()
	end
end

RFInnerframe.ind.hotind_style.apply = function()
	T.EnableUFSettings({"AltzIndicators", "Auras"})
	Updateindsettings()
end
RFInnerframe.ind.hotind_style:HookScript("OnShow", Updateindsettings)

CreateDividingLine(RFInnerframe.ind, -135)

RFInnerframe.ind.aurafliter_title = T.createtext(RFInnerframe.ind, "OVERLAY", 14, "OUTLINE", "LEFT")
RFInnerframe.ind.aurafliter_title:SetPoint("TOPLEFT", RFInnerframe.ind, "TOPLEFT", 30, -150)
RFInnerframe.ind.aurafliter_title:SetText(L["图标指示器"]..L["设置"])

RFInnerframe.ind.reset = T.createclicktexbutton(RFInnerframe.ind, {"LEFT", RFInnerframe.ind.aurafliter_title, "RIGHT", 10, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])
RFInnerframe.ind.reset:SetScript("OnClick", function(self)
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = string.format(L["重置确认"], L["治疗指示器"])
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
		aCoreCDB["UnitframeOptions"]["hotind_style"] = "icon_ind"
		aCoreCDB["UnitframeOptions"]["hotind_size"] = 15
		aCoreCDB["UnitframeOptions"]["hotind_filtertype"] = "whitelist"
		aCoreCDB["UnitframeOptions"]["hotind_auralist"] = nil
		ReloadUI()
	end
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

local indicatorfiltertype_group = {
	["whitelist"] = L["白名单"],
	["blacklist"] = L["黑名单"],
}
T.createradiobuttongroup(RFInnerframe.ind, 25, 165, L["过滤方式"], "UnitframeOptions", "hotind_filtertype", indicatorfiltertype_group)

RFInnerframe.ind.hotind_list = T.createscrolllist(RFInnerframe.ind, {"TOPLEFT", 30, -220}, true, nil, 200)

local CreatehotindauralistButton = function(spellID)
	local bu = T.createlistbutton(RFInnerframe.ind.hotind_list.anchor)
	
	bu:SetScript("OnEnter", function(self)	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	
	bu:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	bu.on_delete = function()		
		aCoreCDB["UnitframeOptions"]["hotind_auralist"][spellID] = nil
		T.lineuplist(aCoreCDB["UnitframeOptions"]["hotind_auralist"], RFInnerframe.ind.hotind_list.list, RFInnerframe.ind.hotind_list.anchor)
	end
	
	RFInnerframe.ind.hotind_list.list[spellID] = bu
	
	return bu
end

RFInnerframe.ind.hotind_list:SetScript("OnShow", function()
	for spellID, _ in pairs(aCoreCDB["UnitframeOptions"]["hotind_auralist"]) do
		local spellName, _, spellIcon = GetSpellInfo(spellID)
		if spellName then
			local bu = RFInnerframe.ind.hotind_list.list[spellID] or CreatehotindauralistButton(spellID)
			bu.display(spellIcon, spellName, spellID)
		else
			print("spell ID "..spellID.." is gone, delete it.")
			aCoreCDB["UnitframeOptions"]["hotind_auralist"][spellID] = nil
		end
	end
	T.lineuplist(aCoreCDB["UnitframeOptions"]["hotind_auralist"], RFInnerframe.ind.hotind_list.list, RFInnerframe.ind.hotind_list.anchor)
end)

local function Createhotindauralist(parent)
	for spellID, info in T.pairsByKeys(aCoreCDB["UnitframeOptions"]["hotind_auralist"]) do
		if GetSpellInfo(spellID) then
			CreatehotindauralistButton(spellID, parent)
		else
			print("spell ID "..spellID.." is gone, delete it.")
			aCoreCDB["UnitframeOptions"]["hotind_auralist"][spellID] = nil
		end
	end
	LineUphotindauralist(parent)
end

RFInnerframe.ind.hotind_spellIDinput = T.createinputbox(RFInnerframe.ind, {"TOPLEFT", 30, -195}, L["输入法术ID"], 320)
function RFInnerframe.ind.hotind_spellIDinput:apply()
	local text = self:GetText()
	local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(text)
	if spellName then
		aCoreCDB["UnitframeOptions"]["hotind_auralist"][spellID] = true
		local bu = RFInnerframe.ind.hotind_list.list[spellID] or CreatehotindauralistButton(spellID)
		bu.display(spellIcon, spellName, spellID)
		bu:Show()
		T.lineuplist(aCoreCDB["UnitframeOptions"]["hotind_auralist"], RFInnerframe.ind.hotind_list.list, RFInnerframe.ind.hotind_list.anchor)
	else
		StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..text.." |r"..L["不是一个有效的法术ID"]
		StaticPopup_Show(G.uiname.."incorrect spellid")
	end
	self:SetText(L["输入法术ID"])
end

-- 点击施法
RFInnerframe.clickcast = CreateOptionPage("RF Options clickcast", L["点击施法"], RFInnerframe, "VERTICAL", .3)

local enableClickCastbu = T.createcheckbutton(RFInnerframe.clickcast, 30, 60, L["启用"], "UnitframeOptions", "enableClickCast", format(L["点击施法提示"], G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor))

local clickcastframe = CreateFrame("Frame", G.uiname.."ClickCast Options", RFInnerframe.clickcast, "BackdropTemplate")
clickcastframe:SetPoint("TOPLEFT", 30, -120)
clickcastframe:SetPoint("BOTTOMRIGHT", -30, 20)
F.CreateBD(clickcastframe, 0)
clickcastframe.tabindex = 1
clickcastframe.tabnum = 20
for i = 1, 20 do
	clickcastframe["tab"..i] = CreateFrame("Frame", G.uiname.."clickcastframe Tab"..i, clickcastframe, "BackdropTemplate")
	clickcastframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

local MacroPop = CreateFrame("Frame", G.uiname.."give macro", clickcastframe)
MacroPop:SetPoint("TOPLEFT", clickcastframe, "TOPLEFT", 10, -150)
MacroPop:SetPoint("BOTTOMRIGHT", clickcastframe, "BOTTOMRIGHT", -10, 20)

F.SetBD(MacroPop)
MacroPop:Hide()
MacroPop:SetScript("OnHide", function(self) self:Hide() end)

MacroPop.scrollBG = CreateFrame("ScrollFrame", G.uiname.."give macro MultiLineEditBox_BG", MacroPop, "UIPanelScrollFrameTemplate")
MacroPop.scrollBG:SetPoint("TOPLEFT", 10, -30)
MacroPop.scrollBG:SetSize(330, 80)
MacroPop.scrollBG:SetFrameLevel(MacroPop:GetFrameLevel()+1)
MacroPop.scrollBG.bg = CreateFrame("Frame", nil, MacroPop.scrollBG, "BackdropTemplate")
MacroPop.scrollBG.bg:SetAllPoints(MacroPop.scrollBG)
F.CreateBD(MacroPop.scrollBG.bg, 0)
	
MacroPop.scrollBG.gradient = F.CreateGradient(MacroPop.scrollBG)
MacroPop.scrollBG.gradient:SetPoint("TOPLEFT", MacroPop.scrollBG, 1, -1)
MacroPop.scrollBG.gradient:SetPoint("BOTTOMRIGHT", MacroPop.scrollBG, -1, 1)
	
MacroPop.scrollBG.name = MacroPop.scrollBG:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
MacroPop.scrollBG.name:SetPoint("BOTTOMLEFT", MacroPop.scrollBG, "TOPLEFT", 5, 8)
MacroPop.scrollBG.name:SetJustifyH("LEFT")
MacroPop.scrollBG.name:SetText(L["输入一个宏"])

MacroPop.scrollAC = CreateFrame("Frame", G.uiname.."give macro MultiLineEditBox_ScrollAC", MacroPop.scrollBG)
MacroPop.scrollAC:SetPoint("TOP", MacroPop.scrollBG, "TOP", 0, -3)
MacroPop.scrollAC:SetWidth(MacroPop.scrollBG:GetWidth())
MacroPop.scrollAC:SetHeight(MacroPop.scrollBG:GetHeight())
MacroPop.scrollAC:SetFrameLevel(MacroPop.scrollBG:GetFrameLevel()+1)
MacroPop.scrollBG:SetScrollChild(MacroPop.scrollAC)

MacroPop.scrollBG.edit = CreateFrame("EditBox", G.uiname.."give macro MultiLineEditBox", MacroPop.scrollAC)
MacroPop.scrollBG.edit:SetTextInsets(3, 3, 3, 3)
MacroPop.scrollBG.edit:SetFrameLevel(MacroPop.scrollAC:GetFrameLevel()+1)
MacroPop.scrollBG.edit:SetAllPoints()
MacroPop.scrollBG.edit:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
MacroPop.scrollBG.edit:SetMultiLine(true)
MacroPop.scrollBG.edit:EnableMouse(true)
MacroPop.scrollBG.edit:SetAutoFocus(false)
MacroPop.scrollBG.edit:SetMaxLetters(255)

MacroPop.scrollBG.limit = MacroPop.scrollBG:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
MacroPop.scrollBG.limit:SetPoint("TOP", MacroPop.scrollBG, "BOTTOM", 0, -3)
MacroPop.scrollBG.limit:SetJustifyH("CENTER")

MacroPop.scrollBG.edit:SetScript("OnChar", function(self)
	MacroPop.scrollBG.limit:SetText(format(MACROFRAME_CHAR_LIMIT, self:GetNumLetters()))
end)

MacroPop.Accept = CreateFrame("Button", G.uiname.."MacroPop Accept", MacroPop, "UIPanelButtonTemplate")
MacroPop.Accept:SetPoint("BOTTOMRIGHT", MacroPop, "BOTTOM", -30, 7)
MacroPop.Accept:SetSize(100, 25)
MacroPop.Accept:SetText(ACCEPT)
F.Reskin(MacroPop.Accept)

local selectid, selectv

MacroPop.Accept:SetScript("OnClick", function()
	local m = MacroPop.scrollBG.edit:GetText()
	aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"] = m
	MacroPop:Hide()
end)

MacroPop.Cancel = CreateFrame("Button", G.uiname.."MacroPop Cancel", MacroPop, "UIPanelButtonTemplate")
MacroPop.Cancel:SetPoint("BOTTOMLEFT", MacroPop, "BOTTOM", 30, 7)
MacroPop.Cancel:SetSize(100, 25)
MacroPop.Cancel:SetText(CANCEL)
F.Reskin(MacroPop.Cancel)

MacroPop.Cancel:SetScript("OnClick", function()
	MacroPop:Hide()
end)

MacroPop:SetScript("OnShow", function(self)
	if not aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"] then
		aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"] = ""
	end
	self.scrollBG.edit:SetText(aCoreCDB["UnitframeOptions"]["ClickCast"][selectid][selectv]["macro"])
	self.scrollBG.limit:SetText(format(MACROFRAME_CHAR_LIMIT, self.scrollBG.edit:GetNumLetters()))
end)

local modifier = {"Click", "shift-", "ctrl-", "alt-"}
local active

for i = 1, 5 do
	local index = tostring(i)
	clickcastframe["Button"..index] = CreateOptionPage("ClickCast Button"..index, L["Button"..index], clickcastframe, "HORIZONTAL", .3)
	clickcastframe["Button"..index].title:Hide()
	clickcastframe["Button"..index].line:Hide()
	if i == 1 then
		clickcastframe["Button"..index]:Show()
	end
	for k, v in pairs(modifier) do
		local inputbox = CreateFrame("EditBox", "ClickCast Button"..index..v.."EditBox", clickcastframe["Button"..index], "BackdropTemplate")
		inputbox.id = "frame"..i.."index"..index.."value"..v
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
		inputbox:SetScript("OnEditFocusGained", function(self)
			active = self.id
			if MacroPop.id ~= active then
				MacroPop:Hide()
			end
		end)
		inputbox:SetScript("OnHide", function() MacroPop:Hide() end)
		
		inputbox:SetScript("OnEnterPressed", function(self)
			local var = self:GetText()
			if (var == "target" or var == "tot" or var == "follow" or var == "macro" or var == "focus") then
				aCoreCDB["UnitframeOptions"]["ClickCast"][index][v]["action"] = var
				if var == "macro" then
					selectid, selectv = index, v
					MacroPop:Show()
					MacroPop.id = self.id
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
	local inputbox = CreateFrame("EditBox", "ClickCast MouseUp"..v.."EditBox", clickcastframe["MouseUp"], "BackdropTemplate")
	inputbox.id = "MouseUp".."index"..k.."value"..v
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
	inputbox:SetScript("OnEditFocusGained", function(self)
		active = self.id
		if MacroPop.id ~= active then
			MacroPop:Hide()
		end
	end)
	inputbox:SetScript("OnHide", function() MacroPop:Hide() end)
		
	inputbox:SetScript("OnEnterPressed", function(self)
		local var = self:GetText()
		if (var == "target" or var == "tot" or var == "follow" or var == "macro" or var == "focus") then
			aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+5)]["Click"]["action"] = var
			if var == "macro" then
				selectid, selectv = tostring(k+5), "Click"
				MacroPop:Show()
				MacroPop.id = self.id
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
	local inputbox = CreateFrame("EditBox", "ClickCast MouseDown"..v.."EditBox", clickcastframe["MouseDown"], "BackdropTemplate")
	inputbox.id = "MouseDown".."index"..k.."value"..v
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
	inputbox:SetScript("OnEditFocusGained", function(self)
		active = self.id
		if MacroPop.id ~= active then
			MacroPop:Hide()
		end
	end)
	inputbox:SetScript("OnHide", function() MacroPop:Hide() end)
	
	inputbox:SetScript("OnEnterPressed", function(self)
		local var = self:GetText()
		if (var == "target" or var == "tot" or var == "follow" or var == "macro" or var == "focus") then
			aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(k+9)]["Click"]["action"] = var
			if var == "macro" then
				selectid, selectv = tostring(k+9), "Click"
				MacroPop:Show()
				MacroPop.id = self.id
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

RFInnerframe.Icon_Display = CreateOptionPage("RF Options Icon Display", L["光环"]..L["图标"], RFInnerframe, "VERTICAL", .3)

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

-- 副本列表
RFInnerframe.raiddebuff = CreateOptionPage("RF Options Raid Debuff", L["团队减益"], RFInnerframe, "VERTICAL", .3, true)

local Selected_InstanceID
local Selected_Encounter

local function CreateEncounterDebuffButton(InstanceID, encounterID, spellID, level)
	local frame = RFInnerframe.raiddebuff.debufflist.SFAnchor
	if not frame.spells["icon"..encounterID.."_"..spellID] then
		local bu = CreateFrame("Frame", nil, frame)
		bu.encounterID = encounterID
	
		bu:SetSize(330, 20)
		
		local name, _, icon = GetSpellInfo(spellID)
		bu.icon = CreateFrame("Button", nil, bu, "BackdropTemplate")
		bu.icon:SetSize(18, 18)
		bu.icon:SetNormalTexture(icon)
		bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
		bu.icon:SetPoint"LEFT"
		
		bu.icon.bg = bu.icon:CreateTexture(nil, "BACKGROUND")
		bu.icon.bg:SetPoint("TOPLEFT", -1, 1)
		bu.icon.bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bu.icon.bg:SetTexture(G.media.blank)
		bu.icon.bg:SetVertexColor(0, 0, 0)
		
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
			aCoreCDB["RaidDebuff"][InstanceID][encounterID][spellID] = nil
			T.DisplayRaidDebuffList()
		end)
		
		bu:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(spellID)
			GameTooltip:Show()
		end)
		bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
		bu:SetScript("OnMouseDown", function(self)
			local frame = RFInnerframe.raiddebuff.debufflist
			if frame.selectdebuff ~= spellID then
				local encounterName = EJ_GetEncounterInfo(encounterID)
				UIDropDownMenu_SetText(frame.BossDD, encounterName)
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
		
		frame.spells["icon"..encounterID.."_"..spellID] = bu
		
		return bu
	end
end

local function DisplayRaidDebuffList()
	if Selected_InstanceID then
		local frame = RFInnerframe.raiddebuff.debufflist.SFAnchor
		
		local y = 0
		local bosstable = {}
		local dataIndex = 1
		EJ_SelectInstance(Selected_InstanceID)
		local encounterID = select(3, EJ_GetEncounterInfoByIndex(dataIndex, Selected_InstanceID))
		while encounterID ~= nil do
			table.insert(bosstable, encounterID)
			dataIndex = dataIndex + 1
			EJ_SelectInstance(Selected_InstanceID)
			encounterID = select(3, EJ_GetEncounterInfoByIndex(dataIndex, Selected_InstanceID))
		end
		table.insert(bosstable, 1)
		
		for k, v in pairs(frame.titles) do
			v:Hide()			
		end
		
		for k, v in pairs(frame.spells) do
			v:Hide()
		end
		
		for i, encounterID in pairs (bosstable) do
			local encounterName = encounterID == 1 and L["杂兵"] or EJ_GetEncounterInfo(encounterID)
			if not frame.titles[i] then
				frame.titles[i] = T.createtext(frame, "OVERLAY", 16, "OUTLINE", "LEFT")
			end
			frame.titles[i]:Show()
			frame.titles[i]:SetText(encounterName)
			frame.titles[i]:ClearAllPoints()
			frame.titles[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, y)
			y = y - 20
			if aCoreCDB["RaidDebuff"][Selected_InstanceID] and aCoreCDB["RaidDebuff"][Selected_InstanceID][encounterID] then
				for spellID, level in pairs (aCoreCDB["RaidDebuff"][Selected_InstanceID][encounterID]) do
					if not frame.spells["icon"..encounterID.."_"..spellID] then
						CreateEncounterDebuffButton(Selected_InstanceID, encounterID, spellID, level)
					end
					local bu = frame.spells["icon"..encounterID.."_"..spellID]
					bu.level:SetText(level)
					bu:ClearAllPoints()
					bu:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, y)
					bu:Show()
					y = y - 20
				end
			end
			y = y - 10
		end
	end
end
T.DisplayRaidDebuffList = DisplayRaidDebuffList

local function CreateEncounterDebuffList()
	if Selected_InstanceID then
		local BossDD = RFInnerframe.raiddebuff.debufflist.BossDD
		UIDropDownMenu_Initialize(BossDD, function()
			local dataIndex = 1	
			EJ_SelectInstance(Selected_InstanceID)
			local encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(dataIndex, Selected_InstanceID)
			while encounterName ~= nil do
				local info = UIDropDownMenu_CreateInfo()
				info.text = encounterName
				info.value = encounterID
				info.checked = function()
					return (Selected_Encounter == info.value)
				end
				info.func = function()
					UIDropDownMenu_SetText(BossDD, info.text)
					CloseDropDownMenus()
					Selected_Encounter = info.value
				end
				UIDropDownMenu_AddButton(info)
				dataIndex = dataIndex + 1
				EJ_SelectInstance(Selected_InstanceID)
				encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(dataIndex, Selected_InstanceID)
			end
			
			local info = UIDropDownMenu_CreateInfo()
			info.text = L["杂兵"]
			info.checked = function()
				return (Selected_Encounter == 1)
			end
			info.func = function()
				UIDropDownMenu_SetText(BossDD, L["杂兵"])
				CloseDropDownMenus()
				Selected_Encounter = 1
			end
			UIDropDownMenu_AddButton(info)
		end)
		
		Selected_Encounter = 1
		UIDropDownMenu_SetText(BossDD, L["杂兵"])
		
		DisplayRaidDebuffList()
	end
end

local function CreateRaidDebuffOptions()
	local frame = RFInnerframe.raiddebuff
	
	-- 光环列表 --
	frame.debufflist = CreateFrame("ScrollFrame", G.uiname.."Raiddebuff Frame List", frame, "UIPanelScrollFrameTemplate")
	frame.debufflist:SetPoint("TOPLEFT", 40, -95)
	frame.debufflist:SetPoint("BOTTOMRIGHT", -50, 20)
	frame.debufflist:Hide()
	frame.debufflist:SetScript("OnShow", function()
		CreateEncounterDebuffList()
	end)
	
	frame.debufflist.SFAnchor = CreateFrame("Frame", G.uiname.."Raiddebuff Frame ListScrollAnchor", frame.debufflist)
	frame.debufflist.SFAnchor:SetPoint("TOPLEFT", frame.debufflist, "TOPLEFT", 0, -3)
	frame.debufflist.SFAnchor:SetWidth(frame.debufflist:GetWidth()-30)
	frame.debufflist.SFAnchor:SetHeight(frame.debufflist:GetHeight()+200)
	frame.debufflist.SFAnchor:SetFrameLevel(frame.debufflist:GetFrameLevel()+1)
	
	frame.debufflist.SFAnchor.titles = {}
	frame.debufflist.SFAnchor.spells = {}
	
	frame.debufflist:SetScrollChild(frame.debufflist.SFAnchor)
	F.ReskinScroll(_G[G.uiname.."Raiddebuff Frame ListScrollBar"])
	
	-- BOSS下拉菜单
	local BossDD = CreateFrame("Frame", G.uiname.."RaidDebuff SelectBossDropdown", frame.debufflist, "UIDropDownMenuTemplate")
	BossDD:SetPoint("BOTTOMLEFT", frame.debufflist, "TOPLEFT", 10, 5)	
	UIDropDownMenu_SetWidth(BossDD, 100)
	F.ReskinDropDown(BossDD)
	
	BossDD.name = T.createtext(BossDD, "OVERLAY", 13, "OUTLINE", "LEFT")
	BossDD.name:SetPoint("BOTTOMRIGHT", BossDD, "BOTTOMLEFT", 15, 12)
	BossDD.name:SetText("BOSS")
	
	frame.debufflist.BossDD = BossDD

	-- SpellID输入框
	local Spellinput = CreateFrame("EditBox", G.uiname.."RaidDebuff SpellInput", frame.debufflist, "BackdropTemplate")
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
	
	frame.debufflist.Spellinput = Spellinput

	-- 法术层级输入框
	local Levelinput = CreateFrame("EditBox", G.uiname.."RaidDebuff Level Input", frame.debufflist, "BackdropTemplate")
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
	
	frame.debufflist.Levelinput = Levelinput	
	
	-- 添加按钮
	local Add = CreateFrame("Button", G.uiname.."RaidDebuff Add Debuff Button", frame.debufflist, "UIPanelButtonTemplate")
	Add:SetPoint("LEFT", Levelinput, "RIGHT", 10, 0)
	Add:SetSize(70, 20)
	Add:SetText(ADD)
	T.resize_font(Add.Text)
	F.Reskin(Add)
	
	Add:SetScript("OnClick", function(self)
		local spellID = tonumber(Spellinput:GetText())
		local level = tonumber(Levelinput:GetText())
		if not spellID then
			StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00".."/".." |r"..L["不是一个有效的法术ID"]
			StaticPopup_Show(G.uiname.."incorrect spellid")
		elseif not GetSpellInfo(spellID) then
			StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID.." |r"..L["不是一个有效的法术ID"]
			StaticPopup_Show(G.uiname.."incorrect spellid")
		elseif not level then
			StaticPopupDialogs[G.uiname.."incorrect level"].text = "|cff7FFF00"..Levelinput:GetText().." |r"..L["必须是一个数字"]
			StaticPopup_Show(G.uiname.."incorrect level")	
		else
			if not aCoreCDB["RaidDebuff"][Selected_InstanceID] then
				aCoreCDB["RaidDebuff"][Selected_InstanceID] = {}
			end
			
			if not aCoreCDB["RaidDebuff"][Selected_InstanceID][Selected_Encounter] then
				aCoreCDB["RaidDebuff"][Selected_InstanceID][Selected_Encounter] = {}
			end
			
			aCoreCDB["RaidDebuff"][Selected_InstanceID][Selected_Encounter][spellID] = level
			DisplayRaidDebuffList()
		end
	end)
	
	frame.debufflist.Add = Add
	
	-- 返回按钮
	local Back = CreateFrame("Button", nil, frame.debufflist)
	Back:SetSize(26, 26)
	Back:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Up")
	Back:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Down")
	Back:SetPoint("LEFT", Add, "RIGHT", 2, 0)
	Back:SetScript("OnClick", function() 
		frame.debufflist:Hide()
		frame.SF:Show()
	end)
	
	-- 重置按钮
	local Reset = CreateFrame("Button", nil, frame.debufflist, "UIPanelButtonTemplate")
	Reset:SetPoint("BOTTOM", GUI.reload, "TOP", 0, 10)
	Reset:SetSize(100, 25)
	Reset:SetText(L["重置"])
	T.resize_font(Reset.Text)
	F.Reskin(Reset)
	Reset:SetScript("OnClick", function(self)
		if Selected_InstanceID then
			local InstanceName = EJ_GetInstanceInfo(Selected_InstanceID)
			StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], InstanceName)
			StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
				aCoreCDB["RaidDebuff"][Selected_InstanceID] = nil
				ReloadUI()
			end
			StaticPopup_Show(G.uiname.."Reset Confirm")
		end
	end)
	
	-- 副本列表 --
	local tier_num = EJ_GetNumTiers()
	local y = 0
	for i = tier_num, 1, -1 do
		local tier_title = T.createtext(frame.SFAnchor, "OVERLAY", 16, "OUTLINE", "LEFT")
		tier_title:SetPoint("TOPLEFT", frame.SFAnchor, "TOPLEFT", 20, y)
		tier_title:SetText(EJ_GetTierInfo(i))
		y = y - 20
		CreateDividingLine(frame.SFAnchor, y, 400)
		y = y - 10
		EJ_SelectTier(i)
		local ind = 0
		-- 地下城
		local dataIndex = 1
		local instanceID, name = EJ_GetInstanceByIndex(dataIndex, false)
		while instanceID ~= nil do
			ind = ind + 1
			local tab = CreateFrame("Button", G.uiname.."Raiddebuff Tab"..instanceID, frame.SFAnchor, "UIPanelButtonTemplate")
			tab.instanceID = instanceID
			tab:SetFrameLevel(frame.SFAnchor:GetFrameLevel()+2)
			tab:SetSize(150, 25)
			tab:SetText(name)		
			if mod(ind,2) == 1 then
				tab:SetPoint("TOPLEFT", frame.SFAnchor, "TOPLEFT", 20+mod(ind+1,2)*200, y)
				y = y - 30
			else
				tab:SetPoint("TOPLEFT", frame.SFAnchor, "TOPLEFT", 20+mod(ind+1,2)*200, y + 30)
			end
			T.resize_font(tab.Text)
			F.Reskin(tab)

			tab:HookScript("OnMouseDown", function(self)
				Selected_InstanceID = self.instanceID
				frame.SF:Hide()
				frame.debufflist:Show()
			end)
			
			if not aCoreCDB["RaidDebuff"][instanceID] then
				aCoreCDB["RaidDebuff"][instanceID] = {}
			end
			
			dataIndex = dataIndex + 1
			instanceID, name = EJ_GetInstanceByIndex(dataIndex, false)
		end
		-- 团本
		if i ~= tier_num then
			dataIndex = 1
			instanceID, name = EJ_GetInstanceByIndex(dataIndex, true)
			while instanceID ~= nil do
				ind = ind + 1
				local tab = CreateFrame("Button", G.uiname.."Raiddebuff Tab"..instanceID, frame.SFAnchor, "UIPanelButtonTemplate")
				tab.instanceID = instanceID
				tab:SetFrameLevel(frame.SFAnchor:GetFrameLevel()+2)
				tab:SetSize(150, 25)
				tab:SetText(name)		
				if mod(ind,2) == 1 then
					tab:SetPoint("TOPLEFT", frame.SFAnchor, "TOPLEFT", 20+mod(ind+1,2)*200, y)
					y = y - 30
				else
					tab:SetPoint("TOPLEFT", frame.SFAnchor, "TOPLEFT", 20+mod(ind+1,2)*200, y + 30)
				end
				T.resize_font(tab.Text)
				F.Reskin(tab)
	
				tab:HookScript("OnMouseDown", function(self)
					Selected_InstanceID = self.instanceID
					frame.SF:Hide()
					frame.debufflist:Show()
				end)
				
				if not aCoreCDB["RaidDebuff"][instanceID] then
					aCoreCDB["RaidDebuff"][instanceID] = {}
				end
			
				dataIndex = dataIndex + 1
				instanceID, name = EJ_GetInstanceByIndex(dataIndex, true)
			end
		end
		y = y - 10
	end
end

local function Click(b)
	local func = b:GetScript("OnMouseDown") or b:GetScript("OnClick")
	func(b)
end

hooksecurefunc("SetItemRef", function(link, text)
  if link:find("garrmission:altz") then
	local InstanceID, encounterID, spellID = string.match(text, "altz::([^%]]+)%::([^%]]+)%::([^%]]+)%|h|c")
	InstanceID = tonumber(InstanceID)
	encounterID = tonumber(encounterID)
	spellID = tonumber(spellID)
	if string.find(text, "config") then	
		Click(GUI.tab6)
		Click(RFInnerframe.tab8)
		Click(_G[G.uiname.."Raiddebuff Tab"..InstanceID])
		GUI:Show()
		GUI.df:Show()
		GUI.scale:Show()
			
		local frame = RFInnerframe.raiddebuff.debufflist
		if encounterID == 1 then
			UIDropDownMenu_SetText(frame.BossDD, L["杂兵"])
		else
			local encounterName = EJ_GetEncounterInfo(encounterID)
			UIDropDownMenu_SetText(frame.BossDD, encounterName)
		end		
		frame.Spellinput:SetText(spellID)
		frame.Levelinput:SetText(aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"])		
	elseif string.find(text, "delete") then
		if aCoreCDB["RaidDebuff"][InstanceID][encounterID][spellID] then
			aCoreCDB["RaidDebuff"][InstanceID][encounterID][spellID] = nil
			DisplayRaidDebuffList()
			local spell = GetSpellInfo(spellID)
			aCoreCDB["CooldownAura"]["Debuffs_Black"][spell] = {}
			aCoreCDB["CooldownAura"]["Debuffs_Black"][spell]["id"] = spellID
			print(string.format(L["已删除并加入黑名单"], T.GetIconLink(spellID)))
		end
	end
  end
end)

local function LineUpCooldownAuraList(parent, auratype)
	local t = {}
	for spell, info in pairs(aCoreCDB["CooldownAura"][auratype]) do
		table.insert(t, info)
	end
	if auratype == "Buffs" or auratype == "Debuffs" then
		sort(t, function(a,b) return a.level > b.level or (a.level == b.level and a.id > b.id) end)
	else
		sort(t, function(a,b) return a.id > b.id end)
	end
	for i = 1, #t do
		_G[G.uiname.."Cooldown"..auratype..t[i].id]:Show()
		_G[G.uiname.."Cooldown"..auratype..t[i].id]:SetPoint("TOPLEFT", parent, "TOPLEFT", auratype == "Buffs" and 16 or 10, 20-i*30)
	end
end

local function CreateCooldownAuraButton(parent, auratype, name, spellID, level)
	local bu = CreateFrame("Frame", G.uiname.."Cooldown"..auratype..spellID, parent)
	bu:SetSize(330, 20)
	
	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(18, 18)
	bu.icon:SetNormalTexture(select(3, GetSpellInfo(spellID)))
	if bu.icon:GetNormalTexture() then
		bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	end
	bu.icon:SetPoint"LEFT"
	bu.icon.bg = bu.icon:CreateTexture(nil, "BACKGROUND")
	bu.icon.bg:SetPoint("TOPLEFT", -1, 1)
	bu.icon.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bu.icon.bg:SetTexture(G.media.blank)
	bu.icon.bg:SetVertexColor(0, 0, 0)
	
	if auratype == "Buffs" or auratype == "Debuffs" then
		bu.level = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
		bu.level:SetPoint("LEFT", 40, 0)
		bu.level:SetTextColor(1, .2, .6)
		bu.level:SetText(level)
	end
	
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
			if auratype == "Buffs" or auratype == "Debuffs" then
				frame.Levelinput:ClearFocus()
				frame.Levelinput:SetText(level)	
			end
			frame.selectdebuff = spellID
		else
			frame.Spellinput:ClearFocus()
			frame.Spellinput:SetText("")
			if auratype == "Buffs" or auratype == "Debuffs" then
				frame.Levelinput:ClearFocus()
				frame.Levelinput:SetText("")	
			end
			frame.selectdebuff = nil
		end
	end)
	
	return bu
end

local function CreateCooldownAuraList(frame, auratype, auratable)
	for spell, info in pairs (auratable) do
		if info.id then
			if GetSpellInfo(info.id) then
				CreateCooldownAuraButton(frame, auratype, spell, info.id, info.level)
			else
				print(spell.." is gone, delete it.")
				aCoreCDB["CooldownAura"][auratype][spell] = nil
			end		
		end
	end
	LineUpCooldownAuraList(frame, auratype)
end

local function CreateCooldownAuraOption(auratype, auratable, name, parent, show)
	local frame
	
	for spell, info in pairs(aCoreCDB["CooldownAura"][auratype]) do
		if tonumber(info.id) then
			aCoreCDB["CooldownAura"][auratype][spell]["id"] = tonumber(info.id)
		else
			aCoreCDB["CooldownAura"][auratype][spell] = nil
		end	
	end
	
	if name then
		frame = CreateOptionPage("Cooldown "..auratype.." Options", name, parent, "HORIZONTAL", .3, true)
		frame.title:Hide()
		frame.line:Hide()
		if show then
			frame:Show()
		end
		
		frame.SF:SetPoint("TOPLEFT", 10, -40)
		frame.SF:SetPoint("BOTTOMRIGHT", -30, 20)
	else
		frame = parent
	end
	
	frame:SetScript("OnShow", function()
		CreateCooldownAuraList(frame.SFAnchor, auratype, auratable)
	end)
	
	local Spellinput = CreateFrame("EditBox", G.uiname..auratype.."Spell Input", frame, "BackdropTemplate")
	Spellinput:SetSize(120, 20)
	Spellinput:SetPoint("TOPLEFT", frame, "TOPLEFT", name and 15 or 25,  name and -10 or -60)
	F.CreateBD(Spellinput)
	
	Spellinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	Spellinput:SetAutoFocus(false)
	Spellinput:SetTextInsets(3, 0, 0, 0)

	Spellinput:SetScript("OnShow", function(self) self:SetText(L["输入法术ID"]) end)
	Spellinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	Spellinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入法术ID"]) end)
	Spellinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	
	frame.Spellinput = Spellinput
	
	local Levelinput
	if auratype == "Buffs" or auratype == "Debuffs" then
		Levelinput = CreateFrame("EditBox", G.uiname..auratype.."Level Input", frame, "BackdropTemplate")
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
	end
	
	local Add = CreateFrame("Button", G.uiname..auratype.."Add CooldownAura Button", frame, "UIPanelButtonTemplate")
	if auratype == "Buffs" or auratype == "Debuffs" then
		Add:SetPoint("LEFT", Levelinput, "RIGHT", 10, 0)
	else
		Add:SetPoint("LEFT", Spellinput, "RIGHT", 10, 0)
	end
	Add:SetSize(70, 20)
	Add:SetText(ADD)
	T.resize_font(Add.Text)
	F.Reskin(Add)
	Add:SetScript("OnClick", function(self)
		local spellID, level, name
		if auratype == "Buffs" or auratype == "Debuffs" then
			spellID = tonumber(Spellinput:GetText())
			level = tonumber(Levelinput:GetText())
			if not spellID or not GetSpellInfo(spellID) then
				StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID.." |r"..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellid")
			elseif not level then
				StaticPopupDialogs[G.uiname.."incorrect level"].text = "|cff7FFF00"..Levelinput:GetText().." |r"..L["必须是一个数字"]
				StaticPopup_Show(G.uiname.."incorrect level")
			else
				name = GetSpellInfo(spellID)
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
		else -- 黑名单
			spellID = tonumber(Spellinput:GetText())
			if not spellID or not GetSpellInfo(spellID) then
				StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..spellID or "?".." |r"..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellid")
			else
				name = GetSpellInfo(spellID)
				if _G[G.uiname.."Cooldown"..auratype..spellID] then -- 已经有这个框体
					aCoreCDB["CooldownAura"][auratype][name] = {id = spellID}		
					_G[G.uiname.."Cooldown"..auratype..spellID]:Show()
					LineUpCooldownAuraList(frame.SFAnchor, auratype)
				else
					aCoreCDB["CooldownAura"][auratype][name] = {id = spellID}
					CreateCooldownAuraButton(frame.SFAnchor, auratype, name, spellID)
					LineUpCooldownAuraList(frame.SFAnchor, auratype)
				end
			end
		end
	end)
	
	frame.Add = Add
	
	local Reset = CreateFrame("Button", G.uiname..auratype.."Reset CooldownAura Button", frame, "UIPanelButtonTemplate")
	Reset:SetPoint("BOTTOM", GUI.reload, "TOP", 0, 10)
	Reset:SetSize(100, 25)
	Reset:SetText(L["重置"])
	T.resize_font(Reset.Text)
	F.Reskin(Reset)
	Reset:SetScript("OnClick", function(self)
		print(L[auratype])
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], L[auratype])
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			aCoreCDB["CooldownAura"][auratype] = nil
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)
	
	parent[auratype.."Options"] = frame
end

RFInnerframe.raiddebuff_fliter = CreateOptionPage("RF Options Raid Debuff Fliter List", L["减益过滤"], RFInnerframe, "VERTICAL", .3)

local raiddebuff_fliterframe = CreateFrame("Frame", G.uiname.."Raid Debuff Fliter Options", RFInnerframe.raiddebuff_fliter, "BackdropTemplate")
raiddebuff_fliterframe:SetPoint("TOPLEFT", 30, -85)
raiddebuff_fliterframe:SetPoint("BOTTOMRIGHT", -30, 20)
F.CreateBD(raiddebuff_fliterframe, 0)
raiddebuff_fliterframe.tabindex = 1
raiddebuff_fliterframe.tabnum = 2
for i = 1, 2 do
	raiddebuff_fliterframe["tab"..i] = CreateFrame("Frame", G.uiname.."raiddebuff_fliterframe Tab"..i, raiddebuff_fliterframe, "BackdropTemplate")
	raiddebuff_fliterframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

RFInnerframe.cooldownaura = CreateOptionPage("RF Options Cooldown Aura", L["团队增益"], RFInnerframe, "VERTICAL", .3, true)

local function CreateCooldownAuraOptions()
	CreateCooldownAuraOption("Debuffs", aCoreCDB["CooldownAura"]["Debuffs"], L["白名单"], raiddebuff_fliterframe, true)
	CreateCooldownAuraOption("Debuffs_Black", aCoreCDB["CooldownAura"]["Debuffs_Black"], L["黑名单"], raiddebuff_fliterframe)

	CreateCooldownAuraOption("Buffs", aCoreCDB["CooldownAura"]["Buffs"], nil, RFInnerframe.cooldownaura, true)
end
--====================================================--
--[[           -- Actionbar Options --              ]]--
--====================================================--
local ActionbarOptions = CreateOptionPage("Actionbar Options", ACTIONBARS_LABEL, GUI, "VERTICAL")

local ActionbarInnerframe = CreateFrame("Frame", G.uiname.."Actionbar Options Innerframe", ActionbarOptions, "BackdropTemplate")
ActionbarInnerframe:SetPoint("TOPLEFT", 40, -60)
ActionbarInnerframe:SetPoint("BOTTOMLEFT", -20, 25)
ActionbarInnerframe:SetWidth(ActionbarOptions:GetWidth()-200)
F.CreateBD(ActionbarInnerframe, .3)

ActionbarInnerframe.tabindex = 1
ActionbarInnerframe.tabnum = 20
for i = 1, 20 do
	ActionbarInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."ActionbarInnerframe Tab"..i, ActionbarInnerframe, "BackdropTemplate")
	ActionbarInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

ActionbarInnerframe.common = CreateOptionPage("Actionbar Options common", L["通用设置"], ActionbarInnerframe, "VERTICAL", .3)
ActionbarInnerframe.common:Show()

T.createcheckbutton(ActionbarInnerframe.common, 30, 60, L["显示冷却时间"], "ActionbarOptions", "cooldown", L["显示冷却时间提示"])
T.createcheckbutton(ActionbarInnerframe.common, 30, 90, L["显示冷却时间"].." (Weakauras)", "ActionbarOptions", "cooldown_wa", L["显示冷却时间提示WA"])
T.createslider(ActionbarInnerframe.common, 30, 140, L["冷却时间数字大小"], "ActionbarOptions", "cooldownsize", 1, 18, 25, 1, L["冷却时间数字大小提示"])
T.createcheckbutton(ActionbarInnerframe.common, 30, 170, L["不可用颜色"], "ActionbarOptions", "rangecolor", L["不可用颜色提示"])
T.createslider(ActionbarInnerframe.common, 30, 220, L["键位字体大小"], "ActionbarOptions", "keybindsize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 260, L["宏名字字体大小"], "ActionbarOptions", "macronamesize", 1, 8, 20, 1)
T.createslider(ActionbarInnerframe.common, 30, 300, L["可用次数字体大小"], "ActionbarOptions", "countsize", 1, 8, 20, 1)
T.createDR(ActionbarInnerframe.common.cooldown, ActionbarInnerframe.common.cooldown_wa, ActionbarInnerframe.common.cooldownsize)

ActionbarInnerframe.cooldownflash = CreateOptionPage("Actionbar Options cooldownflash", L["冷却提示"], ActionbarInnerframe, "VERTICAL", .3)
T.createcheckbutton(ActionbarInnerframe.cooldownflash, 30, 60, L["启用"], "ActionbarOptions", "cdflash_enable")
T.createslider(ActionbarInnerframe.cooldownflash, 30, 100, L["图标大小"], "ActionbarOptions", "cdflash_size", 1, 15, 100, 1)
T.createslider(ActionbarInnerframe.cooldownflash, 30, 140, L["透明度"], "ActionbarOptions", "cdflash_alpha", 1, 30, 100, 1)
T.createDR(ActionbarInnerframe.cooldownflash.cdflash_enable, ActionbarInnerframe.cooldownflash.cdflash_size, ActionbarInnerframe.cooldownflash.cdflash_alpha)

local cooldownflashframe = CreateFrame("Frame", G.uiname.."Cooldown flash Options", ActionbarInnerframe.cooldownflash, "BackdropTemplate")
cooldownflashframe:SetPoint("TOPLEFT", 30, -190)
cooldownflashframe:SetPoint("BOTTOMRIGHT", -30, 20)
F.CreateBD(cooldownflashframe, 0)
cooldownflashframe.tabindex = 1
cooldownflashframe.tabnum = 2
for i = 1, 2 do
	cooldownflashframe["tab"..i] = CreateFrame("Frame", G.uiname.."cooldownflashframe Tab"..i, cooldownflashframe, "BackdropTemplate")
	cooldownflashframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

local function LineUpcooldownflashlist(parent, list)
	local index = 1
	for spellid, info in T.pairsByKeys(aCoreCDB["ActionbarOptions"]["caflash_bl"][list]) do
		_G[G.uiname.."caflash_bl"..list..spellid]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, 20-index*30)
		index =  index + 1
	end
end
	
local function CreatecooldownflashlistButton(spellID, parent, list)
	local bu = CreateFrame("Frame", G.uiname.."caflash_bl"..list..spellID, parent)
	bu:SetSize(330, 20)
	
	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(18, 18)
	if list == "item" and GetItemInfo(spellID) then
		bu.icon:SetNormalTexture(select(10, GetItemInfo(spellID)))
	elseif list == "spell" and GetSpellInfo(spellID) then
		bu.icon:SetNormalTexture(select(3, GetSpellInfo(spellID)))
	end
	if bu.icon:GetNormalTexture() then
		bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	end
	bu.icon:SetPoint"LEFT"
	
	bu.icon.bg = bu.icon:CreateTexture(nil, "BACKGROUND")
	bu.icon.bg:SetPoint("TOPLEFT", -1, 1)
	bu.icon.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bu.icon.bg:SetTexture(G.media.blank)
	bu.icon.bg:SetVertexColor(0, 0, 0)
	
	bu.spellname = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.spellname:SetPoint("LEFT", 140, 0)
	bu.spellname:SetTextColor(1, 1, 0)
	if list == "item" then
		bu.spellname:SetText(GetItemInfo(spellID))
	elseif list == "spell" then	
		bu.spellname:SetText(GetSpellInfo(spellID))
	end
	
	bu.close = CreateFrame("Button", nil, bu)
	bu.close:SetSize(22,22)
	bu.close:SetPoint("LEFT", 310, 0)
	bu.close.text = T.createtext(bu.close, "OVERLAY", 12, "OUTLINE", "CENTER")
	bu.close.text:SetPoint("CENTER")
	bu.close.text:SetText("x")
	
	bu.close:SetScript("OnClick", function() 
		bu:Hide()
		aCoreCDB["ActionbarOptions"]["caflash_bl"][list][spellID] = nil
		LineUpcooldownflashlist(parent, list)
	end)
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	return bu
end

local function Createcooldownflashlist(list, parent)
	for spellID, info in T.pairsByKeys(aCoreCDB["ActionbarOptions"]["caflash_bl"][list]) do
		CreatecooldownflashlistButton(spellID, parent, list)
	end
	LineUpcooldownflashlist(parent, list)
end
	
local function CreateCooldownFlashOptions(name, list)
	local cooldownflashlist = CreateOptionPage(list.."Options", name, cooldownflashframe, "HORIZONTAL", .3, true)
	cooldownflashlist.title:Hide()
	cooldownflashlist.line:Hide()
	if list == "spell" then
		cooldownflashlist:Show()
	end
	cooldownflashlist.SF:SetPoint("TOPLEFT", 10, -20)
	cooldownflashlist.SF:SetPoint("BOTTOMRIGHT", -30, 20)
	
	Createcooldownflashlist(list, cooldownflashlist.SFAnchor)
	
	cooldownflashlist.Spellinput = CreateFrame("EditBox", G.uiname.."caflash_bl"..list.."Spell Input", cooldownflashlist, "BackdropTemplate")
	cooldownflashlist.Spellinput:SetSize(120, 20)
	cooldownflashlist.Spellinput:SetPoint("TOPLEFT", cooldownflashlist, "TOPLEFT", 20, -5)
	F.CreateBD(cooldownflashlist.Spellinput)
	
	cooldownflashlist.Spellinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	cooldownflashlist.Spellinput:SetAutoFocus(false)
	cooldownflashlist.Spellinput:SetTextInsets(3, 0, 0, 0)
	
	local inputword
	if list == "item" then
		inputword = L["输入物品ID"]
	elseif list == "spell" then
		inputword = L["输入法术ID"]
	end	
	cooldownflashlist.Spellinput:SetScript("OnShow", function(self) self:SetText(inputword) end)
	cooldownflashlist.Spellinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	cooldownflashlist.Spellinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(inputword) end)
	cooldownflashlist.Spellinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	
	cooldownflashlist.Add = CreateFrame("Button", G.uiname.."caflash_bl"..list.."Add Button", cooldownflashlist, "UIPanelButtonTemplate")
	cooldownflashlist.Add:SetPoint("LEFT", cooldownflashlist.Spellinput, "RIGHT", 10, 0)
	cooldownflashlist.Add:SetSize(70, 20)
	cooldownflashlist.Add:SetText(ADD)
	T.resize_font(cooldownflashlist.Add.Text)
	F.Reskin(cooldownflashlist.Add)
	
	cooldownflashlist.Add:SetScript("OnClick", function(self)
		local ID = tonumber(cooldownflashlist.Spellinput:GetText())
		if list == "item" then
			if not ID then
				StaticPopupDialogs[G.uiname.."incorrect item ID"].text = L["不正确的物品ID"]
				StaticPopup_Show(G.uiname.."incorrect item ID")
			elseif not GetItemInfo(ID) then
				StaticPopupDialogs[G.uiname.."incorrect item ID"].text = "|cff7FFF00"..ID.." |r"..L["不正确的物品ID"]
				StaticPopup_Show(G.uiname.."incorrect item ID")
			elseif not aCoreCDB["ActionbarOptions"]["caflash_bl"][list][ID] then
				aCoreCDB["ActionbarOptions"]["caflash_bl"][list][ID] = true
				if _G[G.uiname.."caflash_bl"..list..ID] then
					_G[G.uiname.."caflash_bl"..list..ID]:Show()
				else
					CreatecooldownflashlistButton(ID, cooldownflashlist.SFAnchor, list)	
				end
				LineUpcooldownflashlist(cooldownflashlist.SFAnchor, list)
			end
		elseif list == "spell" then
			if not ID then
				StaticPopupDialogs[G.uiname.."incorrect spellid"].text = L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellid")
			elseif not GetSpellInfo(ID) then
				StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..ID.." |r"..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellid")
			elseif not aCoreCDB["ActionbarOptions"]["caflash_bl"][list][ID] then
				aCoreCDB["ActionbarOptions"]["caflash_bl"][list][ID] = true
				if _G[G.uiname.."caflash_bl"..list..ID] then
					_G[G.uiname.."caflash_bl"..list..ID]:Show()
				else
					CreatecooldownflashlistButton(ID, cooldownflashlist.SFAnchor, list)	
				end
				LineUpcooldownflashlist(cooldownflashlist.SFAnchor, list)
			end
		end
	end)
end

--====================================================--
--[[           -- NamePlates Options --             ]]--
--====================================================--
local PlateOptions = CreateOptionPage("Plate Options", UNIT_NAMEPLATES, GUI, "VERTICAL")

local PlateInnerframe = CreateFrame("Frame", G.uiname.."Actionbar Options Innerframe", PlateOptions, "BackdropTemplate")
PlateInnerframe:SetPoint("TOPLEFT", 40, -60)
PlateInnerframe:SetPoint("BOTTOMLEFT", -20, 25)
PlateInnerframe:SetWidth(PlateOptions:GetWidth()-200)
F.CreateBD(PlateInnerframe, .3)

PlateInnerframe.tabindex = 1
PlateInnerframe.tabnum = 20
for i = 1, 20 do
	PlateInnerframe["tab"..i] = CreateFrame("Frame", G.uiname.."PlateInnerframe Tab"..i, PlateInnerframe, "BackdropTemplate")
	PlateInnerframe["tab"..i]:SetScript("OnMouseDown", function() end)
end
-- 通用 --
PlateInnerframe.common = CreateOptionPage("Nameplates Options common", L["通用设置"], PlateInnerframe, "VERTICAL", .3)
PlateInnerframe.common:Show()

T.createcheckbutton(PlateInnerframe.common, 30, 60, L["启用"], "PlateOptions", "enableplate")
T.CVartogglebox(PlateInnerframe.common, 160, 60, "nameplateShowAll", UNIT_NAMEPLATES_AUTOMODE, "1", "0")

local plate_theme_group = {
	["class"] = L["职业色-条形"],
	["dark"] =  L["深色-条形"],
	["number"] =  L["数字样式"],
}
T.createradiobuttongroup(PlateInnerframe.common, 30, 100, L["样式"], "PlateOptions", "theme", plate_theme_group)
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

-- 样式 --
PlateInnerframe.style = CreateOptionPage("Nameplates Options common", L["样式"], PlateInnerframe, "VERTICAL", .3)
PlateInnerframe.style.title:SetText(L["条形样式"])

T.createslider(PlateInnerframe.style, 30, 80, L["宽度"], "PlateOptions", "bar_width", 1, 70, 150, 5)
T.createslider(PlateInnerframe.style, 230, 80, L["高度"], "PlateOptions", "bar_height", 1, 5, 25, 1)
PlateInnerframe.style.bar_width:SetWidth(160)
PlateInnerframe.style.bar_height:SetWidth(160)
local plate_bar_hp_perc_group = {
	["perc"] = L["百分比"],
	["value_perc"] =  L["数值和百分比"],
}
T.createradiobuttongroup(PlateInnerframe.style, 30, 100, L["数值样式"], "PlateOptions", "bar_hp_perc", plate_bar_hp_perc_group)
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

-- 玩家姓名板 --
PlateInnerframe.playerresource = CreateOptionPage("Player Resource Bar Options", L["玩家姓名板"], PlateInnerframe, "VERTICAL", .3)

T.createcheckbutton(PlateInnerframe.playerresource, 30, 60, L["显示玩家姓名板"], "PlateOptions", "playerplate")
T.createcheckbutton(PlateInnerframe.playerresource, 70, 90, L["显示玩家姓名板光环"], "PlateOptions", "plateaura")
T.createcheckbutton(PlateInnerframe.playerresource, 70, 120, L["显示玩家施法条"], "PlateOptions", "platecastbar")
T.createcheckbutton(PlateInnerframe.playerresource, 30, 150, DISPLAY_PERSONAL_RESOURCE, "PlateOptions", "classresource_show")
local classresource_group = {
	["target"] = L["目标姓名板"],
	["player"] = L["玩家姓名板"],
}
T.createradiobuttongroup(PlateInnerframe.playerresource, 70, 180, L["姓名板资源位置"], "PlateOptions", "classresource_pos", classresource_group)

T.createDR(PlateInnerframe.playerresource.playerplate, PlateInnerframe.playerresource.plateaura)
T.createDR(PlateInnerframe.playerresource.classresource_show, PlateInnerframe.playerresource.classresource_pos)

-- 光环过滤列表 --
PlateInnerframe.auralist = CreateOptionPage("Plate Options Aura", L["光环"], PlateInnerframe, "VERTICAL", .3)

local plateauralistframe = CreateFrame("Frame", G.uiname.."Plate Aura List Options", PlateInnerframe.auralist, "BackdropTemplate")
plateauralistframe:SetPoint("TOPLEFT", 30, -85)
plateauralistframe:SetPoint("BOTTOMRIGHT", -30, 20)
F.CreateBD(plateauralistframe, 0)
plateauralistframe.tabindex = 1
plateauralistframe.tabnum = 2
for i = 1, 2 do
	plateauralistframe["tab"..i] = CreateFrame("Frame", G.uiname.."plateauralistframe Tab"..i, plateauralistframe, "BackdropTemplate")
	plateauralistframe["tab"..i]:SetScript("OnMouseDown", function() end)
end

local function LineUpplateauralist(parent, list)
	local index = 1
	for spellid, info in T.pairsByKeys(aCoreCDB["PlateOptions"][list]) do
		_G[G.uiname..list..spellid]:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, 20-index*30)
		index =  index + 1
	end
end
	
local function CreateplateauralistButton(spellID, parent, list)
	local bu = CreateFrame("Frame", G.uiname..list..spellID, parent)
	bu:SetSize(330, 20)

	bu.icon = CreateFrame("Button", nil, bu)
	bu.icon:SetSize(18, 18)
	bu.icon:SetNormalTexture(select(3, GetSpellInfo(spellID)))
	bu.icon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetPoint"LEFT"
	
	bu.icon.bg = bu.icon:CreateTexture(nil, "BACKGROUND")
	bu.icon.bg:SetPoint("TOPLEFT", -1, 1)
	bu.icon.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bu.icon.bg:SetTexture(G.media.blank)
	bu.icon.bg:SetVertexColor(0, 0, 0)	
	
	bu.spellname = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.spellname:SetPoint("LEFT", 140, 0)
	bu.spellname:SetTextColor(1, 1, 0)
	bu.spellname:SetText(GetSpellInfo(spellID))

	bu.close = CreateFrame("Button", nil, bu)
	bu.close:SetSize(22,22)
	bu.close:SetPoint("LEFT", 310, 0)
	bu.close.text = T.createtext(bu.close, "OVERLAY", 12, "OUTLINE", "CENTER")
	bu.close.text:SetPoint("CENTER")
	bu.close.text:SetText("x")
	
	bu.close:SetScript("OnClick", function() 
		bu:Hide()
		aCoreCDB["PlateOptions"][list][spellID] = nil
		LineUpplateauralist(parent, list)
	end)
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end)
	bu:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	return bu
end

local function Createplateauralist(list, parent)
	for spellID, info in T.pairsByKeys(aCoreCDB["PlateOptions"][list]) do
		if GetSpellInfo(spellID) then
			CreateplateauralistButton(spellID, parent, list)
		else
			print("spell ID "..spellID.." is gone, delete it.")
			aCoreCDB["PlateOptions"][list][spellID] = nil
		end
	end
	LineUpplateauralist(parent, list)
end
	
local function CreatePlateAuraOptions(name, flitertype, list)
	local plateauralist = CreateOptionPage(list.."Options", name, plateauralistframe, "HORIZONTAL", .3, true)
	plateauralist.title:Hide()
	plateauralist.line:Hide()
	if list == "myplateauralist" then
		plateauralist:Show()
	end
	
	local filtertype_group = {}
	local filtertype_order = {}
	
	filtertype_group["none"] = L["全部隐藏"]
	filtertype_order["none"] = 1
	filtertype_group["whitelist"] = L["白名单"]
	filtertype_order["whitelist"] = 2
	
	if list == "myplateauralist" then
		filtertype_group["blacklist"] = L["黑名单"]
		filtertype_order["blacklist"] = 3
	end
	
	T.createradiobuttongroup(plateauralist, 10, 0, L["过滤方式"], "PlateOptions", flitertype, filtertype_group, nil, filtertype_order)
	
	plateauralist.SF:SetPoint("TOPLEFT", 10, -50)
	plateauralist.SF:SetPoint("BOTTOMRIGHT", -30, 20)
	
	Createplateauralist(list, plateauralist.SFAnchor)
	
	plateauralist.Spellinput = CreateFrame("EditBox", G.uiname..list.."Spell Input", plateauralist, "BackdropTemplate")
	plateauralist.Spellinput:SetSize(120, 20)
	plateauralist.Spellinput:SetPoint("TOPLEFT", plateauralist, "TOPLEFT", 20, -30)
	F.CreateBD(plateauralist.Spellinput)
	
	plateauralist.Spellinput:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	plateauralist.Spellinput:SetAutoFocus(false)
	plateauralist.Spellinput:SetTextInsets(3, 0, 0, 0)
	
	plateauralist.Spellinput:SetScript("OnShow", function(self) self:SetText(L["输入法术ID"]) end)
	plateauralist.Spellinput:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	plateauralist.Spellinput:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(L["输入法术ID"]) end)
	plateauralist.Spellinput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	
	plateauralist.Add = CreateFrame("Button", G.uiname..list.."Add Button", plateauralist, "UIPanelButtonTemplate")
	plateauralist.Add:SetPoint("LEFT", plateauralist.Spellinput, "RIGHT", 10, 0)
	plateauralist.Add:SetSize(70, 20)
	plateauralist.Add:SetText(ADD)
	T.resize_font(plateauralist.Add.Text)
	F.Reskin(plateauralist.Add)
	
	plateauralist.Add:SetScript("OnClick", function(self)
		local spellID = tonumber(plateauralist.Spellinput:GetText())

		if not spellID or not GetSpellInfo(spellID) then
			StaticPopupDialogs[G.uiname.."incorrect spellid"].text = "|cff7FFF00"..plateauralist.Spellinput:GetText().." |r"..L["不是一个有效的法术ID"]
			StaticPopup_Show(G.uiname.."incorrect spellid")
		elseif not aCoreCDB["PlateOptions"][list][spellID] then
			aCoreCDB["PlateOptions"][list][spellID] = true
			if _G[G.uiname..list..spellID] then
				_G[G.uiname..list..spellID]:Show()
				LineUpplateauralist(plateauralist.SFAnchor, list)
			else
				CreateplateauralistButton(spellID, plateauralist.SFAnchor, list)
				LineUpplateauralist(plateauralist.SFAnchor, list)
			end
		end
	end)
	
	plateauralist.Reset = CreateFrame("Button", G.uiname..list.."Reset Button", plateauralist, "UIPanelButtonTemplate")
	plateauralist.Reset:SetPoint("BOTTOM", GUI.reload, "TOP", 0, 10)
	plateauralist.Reset:SetSize(100, 25)
	plateauralist.Reset:SetText(L["重置"])	
	T.resize_font(plateauralist.Reset.Text)
	F.Reskin(plateauralist.Reset)
	
	plateauralist.Reset:SetScript("OnClick", function(self)
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], name)
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			aCoreCDB["PlateOptions"][list] = nil
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)
end

-- 自定义颜色 --
PlateInnerframe.customcoloredplates = CreateOptionPage("Plate Options CColor", L["自定义颜色"], PlateInnerframe, "VERTICAL", .3, true)

PlateInnerframe.customcoloredplates.SF:ClearAllPoints()
PlateInnerframe.customcoloredplates.SF:SetPoint("TOPLEFT", PlateInnerframe.customcoloredplates, "TOPLEFT", 30, -60)
PlateInnerframe.customcoloredplates.SF:SetPoint("BOTTOMRIGHT", PlateInnerframe.customcoloredplates, "BOTTOMRIGHT", -50, 30)

local function CreateCColoredPlatesButton(parent, index, name, r, g, b)
	local bu = CreateFrame("Frame", G.uiname.."CColoredPlatesList Button"..index, parent, "BackdropTemplate")
	bu:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, 20-index*30)
	bu:SetSize(360, 28)
	F.CreateBD(bu, .2)
	
	bu.index = T.createtext(bu, "OVERLAY", 16, "OUTLINE", "LEFT")
	bu.index:SetPoint("LEFT", 10, 0)
	bu.index:SetTextColor(1, 1, 1)
	bu.index:SetText(index..".")
	
	bu.name_input = CreateFrame("EditBox", G.uiname.."CColoredPlatesList Button"..index.."NameInput", bu, "BackdropTemplate")
	bu.name_input:SetSize(200, 20)
	bu.name_input:SetPoint("LEFT", 40, 0)
	F.CreateBD(bu.name_input, 0)
	bu.name_input:SetBackdropColor(0, 0, 0, 0)
	bu.name_input:SetBackdropBorderColor(0, 0, 0, 0)
	
	bu.name_input:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	bu.name_input:SetAutoFocus(false)
	bu.name_input:SetTextInsets(3, 0, 0, 0)
	
	bu.name_input:SetScript("OnShow", function(self) self:SetText(aCoreCDB["PlateOptions"]["customcoloredplates"][index].name) end)
	bu.name_input:SetScript("OnEditFocusGained", function(self) 
		self:SetBackdropColor(0, 1, 1, .3)
		self:SetBackdropBorderColor(1, 1, 1, 1)
	end)
	bu.name_input:SetScript("OnEditFocusLost", function(self) 
		self:SetBackdropColor(0, 0, 0, 0)
		self:SetBackdropBorderColor(0, 0, 0, 0)
		self.new_value = self:GetText()
		self:SetText(aCoreCDB["PlateOptions"]["customcoloredplates"][index].name)	
	end)
	bu.name_input:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	bu.name_input:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		self:SetBackdropColor(0, 0, 0, 0)
		self:SetBackdropBorderColor(0, 0, 0, 0)
		aCoreCDB["PlateOptions"]["customcoloredplates"][index].name = self.new_value
		self:SetText(self.new_value)
	end)
	
	bu.cpb = CreateFrame("Button", G.uiname.."CColoredPlatesList Button"..index.."ColorPickerButton", bu, "UIPanelButtonTemplate")
	bu.cpb:SetPoint("RIGHT", -60, 0)
	bu.cpb:SetSize(55, 20)
	F.Reskin(bu.cpb)
	
	bu.cpb.ctex = bu.cpb:CreateTexture(nil, "OVERLAY")
	bu.cpb.ctex:SetTexture(G.media.blank)
	bu.cpb.ctex:SetPoint"CENTER"
	bu.cpb.ctex:SetSize(50, 18)
	
	bu.cpb:SetScript("OnShow", function(self) self.ctex:SetVertexColor(aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b) end)
	bu.cpb:SetScript("OnClick", function(self)
		local r, g, b = aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b
		
		ColorPickerFrame:ClearAllPoints()
		ColorPickerFrame:SetPoint("TOPLEFT", self, "TOPRIGHT", 20, 0)
		ColorPickerFrame.hasOpacity = false
		
		ColorPickerFrame.func = function()
			aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b = ColorPickerFrame:GetColorRGB()
			self.ctex:SetVertexColor(ColorPickerFrame:GetColorRGB())
		end
		
		ColorPickerFrame.previousValues = {r = r, g = g, b = b}
		
		ColorPickerFrame.cancelFunc = function()
			aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b = r, g, b
			self.ctex:SetVertexColor(aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r)
		end
		
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Hide()
		ColorPickerFrame:Show()
	end)
	
	bu.reset = CreateFrame("Button", nil, bu, "UIPanelButtonTemplate")
	bu.reset:SetSize(38,18)
	bu.reset:SetPoint("RIGHT", -5, 0)
	F.Reskin(bu.reset)
	bu.reset:SetText(L["重置"])
	T.resize_font(bu.reset.Text)
	
	bu.reset:SetScript("OnClick", function(self)
		table.wipe(aCoreCDB["PlateOptions"]["customcoloredplates"][index])
		aCoreCDB["PlateOptions"]["customcoloredplates"][index] = {
			name = L["空"],
			color = {r = 1, g = 1, b = 1},
		}
		bu.name_input:SetText(L["空"])
		bu.cpb.ctex:SetVertexColor(1, 1, 1)
	end)
	
	return bu
end

local function CreateCColoredPlatesList()
	for index, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
		local name = info.name
		local r, g, b =  info.color.r, info.color.g, info.color.b
		CreateCColoredPlatesButton(PlateInnerframe.customcoloredplates.SFAnchor, index, name, r, g, b)
	end
end

-- 自定义能量 --
PlateInnerframe.custompowerplates = CreateOptionPage("Plate Options CPower", L["自定义能量"], PlateInnerframe, "VERTICAL", .3, true)

PlateInnerframe.custompowerplates.SF:ClearAllPoints()
PlateInnerframe.custompowerplates.SF:SetPoint("TOPLEFT", PlateInnerframe.custompowerplates, "TOPLEFT", 30, -60)
PlateInnerframe.custompowerplates.SF:SetPoint("BOTTOMRIGHT", PlateInnerframe.custompowerplates, "BOTTOMRIGHT", -50, 30)

local function CreateCPowerPlatesButton(parent, index, name)
	local bu = CreateFrame("Frame", G.uiname.."CPowerPlatesList Button"..index, parent, "BackdropTemplate")
	bu:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, 20-index*30)
	bu:SetSize(360, 28)
	F.CreateBD(bu, .2)
	
	bu.index = T.createtext(bu, "OVERLAY", 16, "OUTLINE", "LEFT")
	bu.index:SetPoint("LEFT", 10, 0)
	bu.index:SetTextColor(1, 1, 1)
	bu.index:SetText(index..".")
	
	bu.name_input = CreateFrame("EditBox", G.uiname.."CPowerPlatesList Button"..index.."NameInput", bu, "BackdropTemplate")
	bu.name_input:SetSize(200, 20)
	bu.name_input:SetPoint("LEFT", 40, 0)
	F.CreateBD(bu.name_input, 0)
	bu.name_input:SetBackdropColor(0, 0, 0, 0)
	bu.name_input:SetBackdropBorderColor(0, 0, 0, 0)
	
	bu.name_input:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	bu.name_input:SetAutoFocus(false)
	bu.name_input:SetTextInsets(3, 0, 0, 0)
	
	bu.name_input:SetScript("OnShow", function(self) self:SetText(aCoreCDB["PlateOptions"]["custompowerplates"][index].name) end)
	bu.name_input:SetScript("OnEditFocusGained", function(self) 
		self:SetBackdropColor(0, 1, 1, .3)
		self:SetBackdropBorderColor(1, 1, 1, 1)
	end)
	bu.name_input:SetScript("OnEditFocusLost", function(self) 
		self:SetBackdropColor(0, 0, 0, 0)
		self:SetBackdropBorderColor(0, 0, 0, 0)
		self.new_value = self:GetText()
		self:SetText(aCoreCDB["PlateOptions"]["custompowerplates"][index].name)	
	end)
	bu.name_input:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	bu.name_input:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		self:SetBackdropColor(0, 0, 0, 0)
		self:SetBackdropBorderColor(0, 0, 0, 0)
		aCoreCDB["PlateOptions"]["custompowerplates"][index].name = self.new_value
		self:SetText(self.new_value)
	end)
	
	bu.reset = CreateFrame("Button", nil, bu, "UIPanelButtonTemplate")
	bu.reset:SetSize(38,18)
	bu.reset:SetPoint("RIGHT", -5, 0)
	F.Reskin(bu.reset)
	bu.reset:SetText(L["重置"])
	T.resize_font(bu.reset.Text)
	
	bu.reset:SetScript("OnClick", function(self)
		table.wipe(aCoreCDB["PlateOptions"]["custompowerplates"][index])
		aCoreCDB["PlateOptions"]["custompowerplates"][index] = {
			name = L["空"],
		}
		bu.name_input:SetText(L["空"])
	end)
	
	return bu
end

local function CreateCPowerPlatesList()
	for index, info in pairs(aCoreCDB["PlateOptions"]["custompowerplates"]) do
		local name = info.name
		CreateCPowerPlatesButton(PlateInnerframe.custompowerplates.SFAnchor, index, name)
	end
end

--====================================================--
--[[             -- Tooltip Options --              ]]--
--====================================================--
local TooltipOptions = CreateOptionPage("Tooltip Options", USE_UBERTOOLTIPS, GUI, "VERTICAL")

T.createcheckbutton(TooltipOptions, 30, 60, L["启用"], "TooltipOptions", "enabletip")
T.createcheckbutton(TooltipOptions, 30, 90, L["跟随光标"], "TooltipOptions", "cursor")
T.createcheckbutton(TooltipOptions, 30, 120, L["战斗中隐藏"], "TooltipOptions", "combathide")

T.createDR(TooltipOptions.enabletip, TooltipOptions.cursor, TooltipOptions.combathide)
--====================================================--
--[[             -- Combattext Options --              ]]--
--====================================================--
local CombattextOptions = CreateOptionPage("CombatText Options", L["战斗信息"], GUI, "VERTICAL")

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
local OtherOptions = CreateOptionPage("Other Options", OTHER, GUI, "VERTICAL")

T.createcheckbutton(OtherOptions, 30, 60, L["自动召宝宝"], "OtherOptions", "autopet", L["自动召宝宝提示"])
T.createcheckbutton(OtherOptions, 300, 60, L["随机奖励"], "OtherOptions", "LFGRewards", L["随机奖励提示"])
T.createcheckbutton(OtherOptions, 30, 90, L["稀有警报"], "OtherOptions", "vignettealert", L["稀有警报提示"])
T.createcheckbutton(OtherOptions, 300, 90, L["自动交接任务"], "OtherOptions", "autoquests", L["自动交接任务提示"])
T.createcheckbutton(OtherOptions, 30, 120, L["战场自动释放灵魂"], "OtherOptions", "battlegroundres", L["战场自动释放灵魂提示"])
T.createcheckbutton(OtherOptions, 300, 120, L["自动接受复活"], "OtherOptions", "acceptres", L["自动接受复活提示"])
T.createcheckbutton(OtherOptions, 30, 150, L["快速焦点"], "OtherOptions", "shiftfocus")
T.createcheckbutton(OtherOptions, 300, 150, L["快速标记"], "OtherOptions", "ctrlmenu")

CreateDividingLine(OtherOptions, -230)

T.createcheckbutton(OtherOptions, 30, 240, L["任务栏闪动"], "OtherOptions", "flashtaskbar", L["任务栏闪动提示"])
T.createcheckbutton(OtherOptions, 300, 240, L["隐藏错误提示"], "OtherOptions", "hideerrors", L["隐藏错误提示提示"])	
T.createcheckbutton(OtherOptions, 30, 270, L["显示插件使用小提示"], "OtherOptions", "showAFKtips", L["显示插件使用小提示提示"])
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

	CreateRaidDebuffOptions()
	CreateCooldownAuraOptions()

	CreateCooldownFlashOptions(L["忽略法术"], "spell")
	C_Timer.After(3, function() CreateCooldownFlashOptions(L["忽略物品"], "item") end)
	
	CreatePlateAuraOptions(L["我的法术"], "myfiltertype", "myplateauralist")
	CreatePlateAuraOptions(L["其他法术"], "otherfiltertype", "otherplateauralist")
	CreateCColoredPlatesList()
	CreateCPowerPlatesList()
	
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
