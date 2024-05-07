local T, C, L, G = unpack(select(2, ...))

local TutorialsFrame = CreateFrame("Frame", nil, UIParent)
TutorialsFrame:SetFrameStrata("FULLSCREEN")
TutorialsFrame:SetSize(700, 230)
TutorialsFrame:SetPoint("CENTER")
TutorialsFrame:Hide()

T.setStripBD(TutorialsFrame)

local step = 0
local function CreateTutorialsStepFrame(title, text)
	step = step + 1
	
	local frame = CreateFrame("Frame", nil, TutorialsFrame)
	frame:SetAllPoints(TutorialsFrame)
	frame:SetFrameLevel(2)
	
	frame.index = step
	
	local step_text = T.createtext(frame, "OVERLAY", 14, "NONE", "CENTER")
	step_text:SetPoint("BOTTOM", frame, "BOTTOM", 0, 5)
	frame.step_text = step_text
	
	local previous_step = T.ClickButton(frame, 100, {"BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 5}, L["上一步"])
	frame.previous_step = previous_step
	
	local next_step = T.ClickButton(frame, 100, {"BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 5}, L["下一步"])
	next_step:SetScript("OnClick", function(self)
		frame:Hide()
		TutorialsFrame[frame.index+1]:Show()
	end)
	frame.next_step = next_step
	
	if step == 1 then
		frame.title = T.createtext(frame, "OVERLAY", 35, "NONE", "CENTER")
		frame.title:SetPoint("BOTTOM", frame, "CENTER", 0, 50)
		frame.title:SetText(title)
		
		frame.text = T.createtext(frame, "OVERLAY", 15, "NONE", "CENTER")
		frame.text:SetPoint("TOP", frame.title, "BOTTOM", 0, -10)
		frame.text:SetText(text)
		
		frame.model = T.CreateCreatureModel(frame, 700, 230, {"CENTER", TutorialsFrame, "CENTER"}, 41039, {-12.5, .2, -6.2}, .7)
		frame.model:SetFrameLevel(1)
		
		previous_step:SetText(L["跳过"])
		previous_step:SetScript("OnClick", function(self)
			TutorialsFrame:Hide()
			StaticPopup_Show(G.uiname.."Run Setup")
		end)
	else
		frame.title = T.createtext(frame, "OVERLAY", 15, "NONE", "CENTER")
		frame.title:SetPoint("TOP", frame, "TOP", 80, -5)
		frame.title:SetText(title)
		
		frame.text = T.createtext(frame, "OVERLAY", 15, "NONE", "LEFT")
		frame.text:SetPoint("TOPLEFT", frame, "TOP", -150, -40)
		frame.text:SetSize(480, 150)
		frame.text:SetJustifyV("TOP")
		frame.text:SetText(text)
		
		frame.model = T.CreateCreatureModel(frame, 400, 400, {"RIGHT", TutorialsFrame, "CENTER"}, 42522, {-2, 0, 0}, .7)
		frame.model:SetFrameLevel(1)
		
		previous_step:SetScript("OnClick", function(self) 
			frame:Hide()
			TutorialsFrame[frame.index-1]:Show()
		end)	
	end

	TutorialsFrame[step] = frame
	
	return frame
end

--====================================================--
--[[                -- 1 欢迎使用 --                ]]--
--====================================================--
CreateTutorialsStepFrame(L["欢迎使用"], "ver"..G.Version.." "..L["小泡泡"])

--====================================================--
--[[                  -- 2 简介 --                  ]]--
--====================================================--
CreateTutorialsStepFrame(L["欢迎使用"], L["简介"])

--====================================================--
--[[               -- 3 UI 缩放  --                 ]]--
--====================================================--
local TF_UIScale = CreateTutorialsStepFrame(UI_SCALE, T.split_words(OPTION_TOOLTIP_UI_SCALE,OPTION_TOOLTIP_USE_UISCALE))

T.CVarCheckbutton(TF_UIScale, 200, 80, USE_UISCALE, "useUiScale", "1", "0", nil, true)

TF_UIScale.uiScale = T.SliderWithValueText(TF_UIScale, nil, "short", {"TOPLEFT", TF_UIScale, "TOPLEFT", 190, -110}, 65, 115, 1, nil, true)

TF_UIScale.uiScale:SetScript("OnShow", function(self)
	local value = floor(GetCVar("uiScale")*100)
	self:SetValue(value)
	self.Text:SetText(value)	
end)

TF_UIScale.uiScale:SetScript("OnValueChanged", function(self, getvalue)
	local value = self:GetValue()
	self.Text:SetText(value)
	self.button:Show()
end)

TF_UIScale.uiScale.button:SetScript("OnClick", function(self)
	if not InCombatLockdown() then
		local value = TF_UIScale.uiScale:GetValue()
		SetCVar("uiScale", value/100)
		self:Hide()
	end
end)

T.createDR(TF_UIScale.useUiScale, TF_UIScale.uiScale)
--====================================================--
--[[               -- 4 界面风格 --                 ]]--
--====================================================--
local TF_Theme = CreateTutorialsStepFrame(L["界面风格"], L["界面风格tip"])

TF_Theme.style = T.ButtonGroup(TF_Theme, 450, 200, 60, {
	{1, L["透明样式"]},
	{2, L["深色样式"]},
	{3, L["普通样式"]},
})

TF_Theme.style.updateOnShow = function()
	for i, bu in pairs(TF_Theme.style.buttons) do
		bu.selected = (aCoreCDB["SkinOptions"]["style"] == bu.value_key)
	end
end

TF_Theme.style.apply = function(key)
	aCoreCDB["SkinOptions"]["style"] = key
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
end

--====================================================--
--[[               -- 5 界面布局 --                 ]]--
--====================================================--
local TF_Layout = CreateTutorialsStepFrame(L["界面布局"], L["界面布局tip"])

local Default_Layout = {
	frames = {
		{
			f = "oUF_AltzPlayer",
			a1 = "TOPRIGHT",	
			parent = "UIParent",
			anchor_type = "Screen",
			a2 = "BOTTOM",
			x = -250,
			y = 450,		
		},
		{
			f = "oUF_AltzTarget",
			a1 = "TOPLEFT",	
			parent = "UIParent",
			anchor_type = "Screen",
			a2 = "BOTTOM",
			x = 250,
			y = 450,
		},
		{
			f = "Altz_Raid_Holder",
			role = "healer",
			a1 = "BOTTOM",
			anchor_type = "Screen",
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = 0,
			y = 200,
		},
		{
			f = "AltzUI_playerCastbar",
			a1 = "BOTTOM",
			anchor_type = "Screen",
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = 0,
			y = 450,
		},
	},
	options = {
		{
			db_t = "SkinOptions", 
			db_v = "showtopbar",
			value = true,	
		},
		{
			db_t = "SkinOptions", 
			db_v = "showbottombar",
			value = true,
		},
		{
			db_t = "SkinOptions", 
			db_v = "showtopconerbar",
			value = true,
		},
		{
			db_t = "SkinOptions", 
			db_v = "showbottomconerbar",
			value = true,
		},
	},
}

local Centralized_Layout = {
	frames = {
		{
			f = "oUF_AltzPlayer",
			a1 = "TOP",	
			parent = "UIParent",
			anchor_type = "Screen",
			a2 = "CENTER",
			x = 0,
			y = -160,		
		},
		{
			f = "oUF_AltzTarget",
			a1 = "TOPLEFT",
			anchor_type = "Screen",
			parent = "UIParent",	
			a2 = "CENTER",
			x = 200,
			y = 0,
		},
		{
			f = "Altz_Raid_Holder",
			role = "healer",
			a1 = "TOPLEFT",
			anchor_type = "Screen",
			parent = "UIParent",	
			a2 = "CENTER",
			x = 200,
			y = -50,
		},
		{
			f = "AltzUI_playerCastbar",
			a1 = "TOP",
			anchor_type = "ChooseFrame",
			parent = "oUF_AltzPlayer",	
			a2 = "BOTTOM",
			x = 0,
			y = -10,
		},
	},
	options = {
		{
			db_t = "SkinOptions", 
			db_v = "showtopbar",
			value = true,	
		},
		{
			db_t = "SkinOptions", 
			db_v = "showbottombar",
			value = true,
		},
		{
			db_t = "SkinOptions", 
			db_v = "showtopconerbar",
			value = false,
		},
		{
			db_t = "SkinOptions", 
			db_v = "showbottomconerbar",
			value = false,
		},
	},
}

local ApplySizeAndPostions = function(group)
	-- 位置
	local role = T.CheckRole()
	for i, info in pairs(group.frames) do
		if not info.role or role == info.role then
			aCoreCDB["FramePoints"][info.f][role]["a1"] = info.a1
			aCoreCDB["FramePoints"][info.f][role]["anchor_type"] = info.anchor_type
			aCoreCDB["FramePoints"][info.f][role]["parent"] = info.parent
			aCoreCDB["FramePoints"][info.f][role]["a2"] = info.a2
			aCoreCDB["FramePoints"][info.f][role]["x"] = info.x
			aCoreCDB["FramePoints"][info.f][role]["y"] = info.y
			T.PlaceFrame(_G[info.f])
		end
	end
	-- 选项
	for i, info in pairs(group.options) do
		aCoreCDB[info.db_t][info.db_v] = info.value
	end
end

TF_Layout.layout = T.ButtonGroup(TF_Layout, 450, 200, 60, {
	{1, L["对称布局"]},
	{2, L["聚合布局"]},
})

TF_Layout.layout.apply = function(key)
	if key == 1 then
		ApplySizeAndPostions(Default_Layout)
	elseif key == 2 then
		ApplySizeAndPostions(Centralized_Layout)
	end
	G.BGFrame.Apply()
end

TF_Layout.unlock = T.Checkbutton(TF_Layout, {"TOPLEFT", TF_Layout, "TOPLEFT", 200, -100}, HUD_EDIT_MODE_MENU)

TF_Layout.unlock:SetScript("OnShow", function(self)
	self:SetEnabled(EditModeManagerFrame:CanEnterEditMode())
	self:SetChecked(EditModeManagerFrame:IsShown())
end)

TF_Layout.unlock:SetScript("OnClick", function(self)
	if self:GetChecked() then
		EditModeManagerFrame.AccountSettings:SetExpandedState(false, true)
		ShowUIPanel(EditModeManagerFrame)
	else
		HideUIPanel(EditModeManagerFrame)
	end
end)

TF_Layout.unlock:SetScript("OnHide", function(self)
	if EditModeManagerFrame:IsShown() then
		HideUIPanel(EditModeManagerFrame)
	end
end)
--====================================================--
--[[               -- 6 渐隐 --                   ]]--
--====================================================--
local TF_Fade = CreateTutorialsStepFrame(T.split_words(L["界面"], L["条件渐隐"]), gsub(L["条件渐隐提示"], "\n", ""))

TF_Fade.enable = T.Checkbutton(TF_Fade, {"TOPLEFT", TF_Fade, "TOPLEFT", 200, -80}, L["条件渐隐"])

TF_Fade.enable:SetScript("OnShow", function(self)
	if aCoreCDB["UnitframeOptions"]["enablefade"] and aCoreCDB["ActionbarOptions"]["enablefade"] then
		self:SetChecked(true)
	else
		self:SetChecked(false)
	end
end)

TF_Fade.enable:SetScript("OnClick", function(self)
	aCoreCDB["UnitframeOptions"]["enablefade"] = self:GetChecked()
	aCoreCDB["ActionbarOptions"]["enablefade"] = self:GetChecked()
	T.EnableUFSettings({"Fader"})
	T.ApplyUFSettings({"Fader"})
	T.ApplyActionbarFadeEnable()	
end)
--====================================================--
--[[               -- 7 姓名板 --                   ]]--
--====================================================--
local TF_Nameplate = CreateTutorialsStepFrame(UNIT_NAMEPLATES, L["姓名板tip"])

TF_Nameplate.theme = T.ButtonGroup(TF_Nameplate, 450, 200, 60, {
	{"class", L["职业色-条形"]},
	{"dark", L["深色-条形"]},
	{"number", L["数字样式"]},
})

TF_Nameplate.theme.updateOnShow = function()
	for i, bu in pairs(TF_Nameplate.theme.buttons) do
		bu.selected = (aCoreCDB["PlateOptions"]["theme"] == bu.value_key)
	end
end

TF_Nameplate.theme.apply = function(key)
	aCoreCDB["PlateOptions"]["theme"] = key
	T.ApplyUFSettings({"Health", "Power", "Castbar", "Auras", "ClassPower", "Runes", "Tag_Name"}, 'Altz_Nameplates')	
	T.PostUpdateAllPlates()
end

--====================================================--
--[[               -- 8 更新日志 --                 ]]--
--====================================================--
if L["更新日志tip"] then
	CreateTutorialsStepFrame(G.Version.." "..L["更新日志"], L["更新日志tip"])
end

--====================================================--
--[[                 -- INIT --                     ]]--
--====================================================--

for i = 1, step do
	local frame = TutorialsFrame[i]
	frame.step_text:SetText(string.format("%d / %d", frame.index, step))
	if i == step then
		frame.next_step:SetText(L["完成"])
		frame.next_step:SetScript("OnClick", function(self)
			TutorialsFrame:Hide()
		end)
	end
end

function TutorialsFrame:ShowFrame(page)
	for i = 1, step do
		local frame = TutorialsFrame[i]
		frame:Hide()
	end
	TutorialsFrame:Show()
	TutorialsFrame[page]:Show()

	if page == step then
		TutorialsFrame[step].previous_step:Hide()
		TutorialsFrame[step].next_step:SetText(OKAY)
	else
		TutorialsFrame[step].previous_step:Show()
		TutorialsFrame[step].next_step:SetText(L["完成"])
	end
end

T.RegisterEnteringWorldCallback(function()
	if not aCoreCDB.meet then
		T.ResetEditModeLayout()
		T.ResetAllAddonSettings()
		TF_Layout.layout.buttons[1].selected = true
		TutorialsFrame:ShowFrame(1)
		aCoreDB.ver = G.Version
		aCoreCDB.meet = true
	elseif aCoreDB.ver ~= G.Version then
		if L["更新日志tip"] then
			TutorialsFrame:ShowFrame(step)
		end
		aCoreDB.ver = G.Version
	end
end)

T.RunSetup = function()
	TutorialsFrame:ShowFrame(1)
end

SlashCmdList['Setup'] = T.RunSetup
SLASH_Setup1 = "/setup"