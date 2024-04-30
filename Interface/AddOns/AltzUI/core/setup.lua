local T, C, L, G = unpack(select(2, ...))

local TutorialsFrame = CreateFrame("Frame", nil, UIParent)
TutorialsFrame:SetFrameStrata("FULLSCREEN")
TutorialsFrame:SetSize(700, 230)
TutorialsFrame:SetPoint("CENTER")
TutorialsFrame:Hide()

TutorialsFrame.backdrop = T.createBackdrop(TutorialsFrame, .5)
T.setStripeBg(TutorialsFrame.backdrop)

local step = 0
local function CreateTutorialsStepFrame(title, text)
	step = step + 1
	
	local frame = CreateFrame("Frame", nil, TutorialsFrame)
	frame:SetAllPoints(TutorialsFrame)
	frame:SetFrameLevel(2)
	
	frame.index = step
	
	frame.model = CreateFrame("PlayerModel", nil, frame)
	frame.model:SetFrameLevel(1)

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
		
		frame.model:SetPoint("CENTER", TutorialsFrame, "CENTER")
		frame.model:SetSize(700, 230)
		frame.model:SetDisplayInfo(41039)
		frame.model:SetCamDistanceScale(.7)
		frame.model:SetPosition(-12.5, .2, -6.2)
			
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
		
		frame.model:SetPoint("RIGHT", TutorialsFrame, "CENTER")
		frame.model:SetSize(400, 400)
		frame.model:SetDisplayInfo(42522)
		frame.model:SetCamDistanceScale(.7)
		frame.model:SetPosition(-2, 0, 0)
		
		previous_step:SetScript("OnClick", function(self) 
			frame:Hide()
			TutorialsFrame[frame.index-1]:Show()
		end)	
	end

	TutorialsFrame[step] = frame
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
--[[               -- 3 界面风格 --                   ]]--
--====================================================--
CreateTutorialsStepFrame(L["界面风格"], L["界面风格tip"])

TutorialsFrame[3].style = T.ButtonGroup(TutorialsFrame[3], 450, 200, 60, {
	{1, L["透明样式"]},
	{2, L["深色样式"]},
	{3, L["普通样式"]},
})

TutorialsFrame[3].style.pre_update = function()
	for i, bu in pairs(TutorialsFrame[3].style.buttons) do
		bu.selected = (aCoreCDB["SkinOptions"]["style"] == bu.value_key)
	end
end

TutorialsFrame[3].style.apply = function(key)
	aCoreCDB["SkinOptions"]["style"] = key
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
end

--====================================================--
--[[               -- 4 界面布局 --                 ]]--
--====================================================--
CreateTutorialsStepFrame(L["界面布局"], L["界面布局tip"])

local Default_Layout = {
	frames = {
		{
			f = "oUF_AltzPlayer",
			a1 = "TOPRIGHT",	
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = -250,
			y = 350,		
		},
		{
			f = "oUF_AltzTarget",
			a1 = "TOPLEFT",	
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = 250,
			y = 350,		
		},
		{
			f = "Altz_Raid_Holder",
			a1 = "TOP",	
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = 0,
			y = 350,
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
		{
			db_t = "UnitframeOptions", 
			db_v = "width",
			value = 230,			
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "height",
			value = 18,		
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "ppheight",
			value = .25,			
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "hideplayercastbaricon",
			value = false,	
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "independentcb",
			value = true,			
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "cbheight",
			value = 16,			
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "cbwidth",
			value = 230,		
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "target_cbheight",
			value = 6,	
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "target_cbwidth",
			value = 230,		
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "focus_cbheight",
			value = 6,		
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "focus_cbwidth",
			value = 230,	
		},
	},
}

local Simplicity_Layout = {
	frames = {
		{
			f = "oUF_AltzPlayer",
			a1 = "TOPRIGHT",	
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = -250,
			y = 520,		
		},
		{
			f = "oUF_AltzTarget",
			a1 = "TOPLEFT",	
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = 250,
			y = 520,		
		},
		{
			f = "Altz_Raid_Holder",
			a1 = "TOPLEFT",	
			parent = "UIParent",	
			a2 = "BOTTOM",
			x = 250,
			y = 500,
		},
	},
	options = {
		{
			db_t = "SkinOptions", 
			db_v = "showtopbar",
			value = false,		
		},
		{
			db_t = "SkinOptions", 
			db_v = "showbottombar",
			value = false,
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
		{
			db_t = "UnitframeOptions", 
			db_v = "width",
			value = 180,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "height",
			value = 5,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "ppheight",
			value = .5,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "hideplayercastbaricon",
			value = false,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "independentcb",
			value = false,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "cbheight",
			value = 5,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "cbwidth",
			value = 180,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "target_cbheight",
			value = 5,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "target_cbwidth",
			value = 180,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "focus_cbheight",
			value = 5,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "focus_cbwidth",
			value = 190,
		},
	},
}

local Centralized_Layout = {
	frames = {
		{
			f = "oUF_AltzPlayer",
			a1 = "TOP",	
			parent = "UIParent",	
			a2 = "CENTER",
			x = 0,
			y = -200,		
		},
		{
			f = "oUF_AltzTarget",
			a1 = "TOPLEFT",	
			parent = "UIParent",	
			a2 = "CENTER",
			x = 250,
			y = -100,
		},
		{
			f = "Altz_Raid_Holder",
			a1 = "TOPLEFT",	
			parent = "UIParent",	
			a2 = "CENTER",
			x = 250,
			y = -130,
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
		{
			db_t = "UnitframeOptions", 
			db_v = "width",
			value = 230,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "height",
			value = 18,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "ppheight",
			value = .25,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "hideplayercastbaricon",
			value = false,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "independentcb",
			value = true,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "cbheight",
			value = 16,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "cbwidth",
			value = 230,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "target_cbheight",
			value = 6,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "target_cbwidth",
			value = 230,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "focus_cbheight",
			value = 6,
		},
		{
			db_t = "UnitframeOptions", 
			db_v = "focus_cbwidth",
			value = 230,
		},
	},
}

local ApplySizeAndPostions = function(group)
	-- 位置
	local role = T.CheckRole()
	for i, t in pairs(group.frames) do
		aCoreCDB["FramePoints"][t.f][role]["a1"] = t.a1
		aCoreCDB["FramePoints"][t.f][role]["parent"] = t.parent
		aCoreCDB["FramePoints"][t.f][role]["a2"] = t.a2
		aCoreCDB["FramePoints"][t.f][role]["x"] = t.x
		aCoreCDB["FramePoints"][t.f][role]["y"] = t.y
		T.PlaceFrame(_G[t.f])
	end
	-- 选项
	for i, t in pairs(group.options) do
		aCoreCDB[t.db_t][t.db_v] = t.value
	end
end

TutorialsFrame[4].layout = T.ButtonGroup(TutorialsFrame[4], 450, 200, 60, {
	{1, L["默认布局"]},
	{2, L["极简布局"]},
	{3, L["聚合布局"]},
})

TutorialsFrame[4].layout.apply = function(key)
	if key == 1 then
		ApplySizeAndPostions(Default_Layout)
	elseif key == 2 then
		ApplySizeAndPostions(Simplicity_Layout)
	elseif key == 3 then
		ApplySizeAndPostions(Centralized_Layout)
	end
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana", "PVPSpecIcon", "Trinket"})
end
--====================================================--
--[[               -- 5 姓名板 --                   ]]--
--====================================================--
CreateTutorialsStepFrame(UNIT_NAMEPLATES, L["姓名板tip"])

TutorialsFrame[5].theme = T.ButtonGroup(TutorialsFrame[5], 450, 200, 60, {
	{"class", L["职业色-条形"]},
	{"dark", L["深色-条形"]},
	{"number", L["数字样式"]},
})

TutorialsFrame[5].theme.pre_update = function()
	for i, bu in pairs(TutorialsFrame[5].theme.buttons) do
		bu.selected = (aCoreCDB["PlateOptions"]["theme"] == bu.value_key)
	end
end

TutorialsFrame[5].theme.apply = function(key)
	aCoreCDB["PlateOptions"]["theme"] = key
	T.ApplyUFSettings({"Health", "Power", "Castbar", "Auras", "ClassPower", "Runes", "Tag_Name"}, 'Altz_Nameplates')	
	T.PostUpdateAllPlates()
end

--====================================================--
--[[               -- 6 更新日志 --                 ]]--
--====================================================--
CreateTutorialsStepFrame(G.Version.." "..L["更新日志"], L["更新日志tip"])

--====================================================--
--[[                 -- INIT --                     ]]--
--====================================================--

for i = 1, step do
	local frame = TutorialsFrame[i]
	frame.step_text:SetText(string.format("%d / %d", frame.index, step))
	if i == step then
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

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function(self, event, arg1)
	if not aCoreCDB.meet then
		TutorialsFrame[4].layout.buttons[1].selected = true
		TutorialsFrame:ShowFrame(1)
		aCoreDB.ver = G.Version
		aCoreCDB.meet = true
	elseif aCoreDB.ver ~= G.Version then
		TutorialsFrame:ShowFrame(step)
		aCoreDB.ver = G.Version
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

T.RunSetup = function()
	TutorialsFrame:ShowFrame(1)
end

SlashCmdList['Setup'] = T.RunSetup

SLASH_Setup1 = "/Setup"