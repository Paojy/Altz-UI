local T, C, L, G = unpack(select(2, ...))

local TutorialsFrame = CreateFrame("Frame", G.uiname.."TutorialsFrame", UIParent)
TutorialsFrame:SetFrameStrata("FULLSCREEN")
TutorialsFrame:SetSize(700, 230)
TutorialsFrame:SetPoint("CENTER")

TutorialsFrame.bd = T.createBackdrop(TutorialsFrame, .5)
T.setStripeBg(TutorialsFrame.bd)

TutorialsFrame.step = 1
TutorialsFrame:Hide()

Model = {
	{
		height = TutorialsFrame:GetHeight(),
		width = TutorialsFrame:GetWidth(),
		points = {"CENTER", TutorialsFrame, "CENTER"},
		displayinfo = 41039,
		position = {-12.5, 0, -6.2},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
	{
		height = 400,
		width = 400,
		points = {"RIGHT", TutorialsFrame, "CENTER"},
		displayinfo = 42522,
		position = {-2, 0, 0},
		camdistancescale = 0.7,
	},
}

local function CreateTutorialsStepFrame(title, text)
	local step = TutorialsFrame.step
	local frame = CreateFrame("Frame", G.uiname.."TutorialsStepFrame"..step, TutorialsFrame)
	frame:SetAllPoints(TutorialsFrame)
	frame:SetFrameLevel(2)
	frame:Hide()
	
	frame.model = CreateFrame("PlayerModel", G.uiname.."TutorialsStepFrameModel"..step, frame)
	frame.model:SetPoint(unpack(Model[step]["points"]))
	frame.model:SetSize(Model[step]["width"], Model[step]["height"])
	frame.model:SetFrameLevel(1)
	frame.model:SetDisplayInfo(Model[step]["displayinfo"])
	frame.model:SetCamDistanceScale(Model[step]["camdistancescale"])
	frame.model:SetPosition(unpack(Model[step]["position"]))
	
	if step == 1 then
		frame.title = T.createtext(frame, "OVERLAY", 35, "NONE", "CENTER")
		frame.title:SetPoint("BOTTOM", frame, "CENTER", 0, 50)

		frame.text = T.createtext(frame, "OVERLAY", 15, "NONE", "CENTER")
		frame.text:SetPoint("TOP", frame.title, "BOTTOM", 0, -10)
		
		frame:SetScript("OnMouseDown", function()
			frame:Hide()
			TutorialsFrame[step+1]:Show()
		end)
	else
		frame.title = T.createtext(frame, "OVERLAY", 15, "NONE", "CENTER")
		frame.title:SetPoint("TOP", frame, "TOP", 80, -5)

		frame.text = T.createtext(frame, "OVERLAY", 15, "NONE", "LEFT")
		frame.text:SetPoint("TOPLEFT", frame, "TOP", -150, -40)
		frame.text:SetSize(480, 150)
		frame.text:SetJustifyV("TOP")
		
		local p_bu = CreateFrame("Button", G.uiname.."TutorialsStepFramePrevious", frame, "UIPanelButtonTemplate")
		p_bu:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 5)
		p_bu:SetSize(100, 25)
		T.ReskinButton(p_bu)
		
		p_bu:SetText(L["上一步"])
		
		p_bu:SetScript("OnClick", function() 
			frame:Hide()
			TutorialsFrame[step-1]:Show()
		end)
		frame.p = p_bu
		
		local n_bu = CreateFrame("Button", G.uiname.."TutorialsStepFrameNext", frame, "UIPanelButtonTemplate")
		n_bu:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 5)
		n_bu:SetSize(100, 25)
		T.ReskinButton(n_bu)
		
		n_bu:SetText(L["下一步"])

		n_bu:SetScript("OnClick", function()
			frame:Hide()
			TutorialsFrame[step+1]:Show()
		end)
		frame.n = n_bu
	end
	
	frame.title:SetText(title)
	frame.text:SetText(text)
	
	frame.index = 1
	TutorialsFrame[TutorialsFrame.step] = frame
	TutorialsFrame.step = TutorialsFrame.step + 1
end

--====================================================--
--[[           -- 欢迎使用 和 简介 --               ]]--
--====================================================--

CreateTutorialsStepFrame(L["欢迎使用"], "ver"..G.Version.." "..L["小泡泡"])

CreateTutorialsStepFrame(L["欢迎使用"], L["简介"])
local skip = CreateFrame("Button", G.uiname.."TutorialsSkip", TutorialsFrame[2], "UIPanelButtonTemplate")
skip:SetPoint("BOTTOM", TutorialsFrame[2], "BOTTOM", 0, 5)
skip:SetSize(120, 25)
T.ReskinButton(skip)

skip:SetText(L["跳过"])

skip:SetScript("OnClick", function()
	TutorialsFrame[2]:Hide()
	TutorialsFrame:Hide()
	StaticPopup_Show(G.uiname.."Run Setup")
end)
		
--====================================================--
--[[               -- 界面风格 --                   ]]--
--====================================================--

CreateTutorialsStepFrame(L["界面风格"], L["界面风格tip"])

TutorialsFrame[3].style = T.ButtonGroup(TutorialsFrame[3], 450, 200, 30, {
	{1, L["透明样式"]},
	{2, L["深色样式"]},
	{3, L["普通样式"]},
})

TutorialsFrame[3].style.apply = function(key)
	aCoreCDB["SkinOptions"]["style"] = key
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
end

--====================================================--
--[[               -- 界面布局 --                   ]]--
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

TutorialsFrame[4].layout = T.ButtonGroup(TutorialsFrame[4], 450, 200, 30, {
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
--[[               -- 姓名板 --                   ]]--
--====================================================--

CreateTutorialsStepFrame(UNIT_NAMEPLATES, L["姓名板tip"])

TutorialsFrame[5].theme = T.ButtonGroup(TutorialsFrame[5], 450, 200, 30, {
	{"class", L["职业色-条形"]},
	{"dark", L["深色-条形"]},
	{"number", L["数字样式"]},
})

TutorialsFrame[5].theme.apply = function(key)
	aCoreCDB["PlateOptions"]["theme"] = key
	T.ApplyUFSettings({"Health", "Power", "Castbar", "Auras", "ClassPower", "Runes", "Tag_Name"}, 'Altz_Nameplates')	
	T.PostUpdateAllPlates()
end

T.Checkbutton_db(TutorialsFrame[5], 450, 200, 60, T.split_words(L["显示"],PLAYER,UNIT_NAMEPLATES), "playerplate")
TutorialsFrame[5].apply = function()
	if aCoreCDB["PlateOptions"]["playerplate"] then
		SetCVar("nameplateShowSelf", 1)
	else
		SetCVar("nameplateShowSelf", 0)
	end
	T.PostUpdateAllPlates()
end

--====================================================--
--[[               -- 快捷指令 --                   ]]--
--====================================================--
CreateTutorialsStepFrame(L["命令"], L["指令"])

--====================================================--
--[[               -- 更新日志 --                   ]]--
--====================================================--
CreateTutorialsStepFrame(G.Version.." "..L["更新日志"], L["更新日志tip"])

--====================================================--
--[[                 -- INIT --                     ]]--
--====================================================--
function TutorialsFrame:ShowFrame(page, reload)
	TutorialsFrame:Show()
	TutorialsFrame[page]:Show()
	local last = TutorialsFrame.step-1
	if page == last then
		TutorialsFrame[last].p:Hide()
		TutorialsFrame[last].n:Hide()
		TutorialsFrame[last]:SetScript("OnMouseDown", function(self)
			TutorialsFrame[last]:Hide()
			TutorialsFrame:Hide()
		end)
	else
		TutorialsFrame[last].p:Show()
		TutorialsFrame[last].n:Show()
		TutorialsFrame[last]:SetScript("OnMouseDown", nil)
		TutorialsFrame[last].n:SetText(L["完成"])
		if reload then
			TutorialsFrame[last].n:SetScript("OnClick", ReloadUI)
		else
			TutorialsFrame[last].n:SetScript("OnClick", function()
				TutorialsFrame[last]:Hide()
				TutorialsFrame:Hide()
			end)
		end
	end
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function(self, event, arg1) 
	if not aCoreCDB.meet then
		if not aCoreDB.meet then
			T.ResetAllAddonSettings()
			SetCVar("useUiScale", 0)
			aCoreDB.meet = true
		end
		T.SetChatFrame()
		TutorialsFrame:ShowFrame(1, true)
		aCoreDB.ver = G.Version
		aCoreCDB.meet = true
	elseif aCoreDB.ver ~= G.Version then
		TutorialsFrame:ShowFrame(9)
		aCoreDB.ver = G.Version
	end
end)

T.RunSetup = function()
	TutorialsFrame:ShowFrame(1)
end

SlashCmdList['Setup'] = T.RunSetup

SLASH_Setup1 = "/Setup"