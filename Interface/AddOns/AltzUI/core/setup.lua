local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local TutorialsFrame = CreateFrame("Frame", G.uiname.."TutorialsFrame", UIParent, "BackdropTemplate")
TutorialsFrame:SetFrameStrata("FULLSCREEN")
TutorialsFrame:SetSize(700, 230)
TutorialsFrame:SetPoint("CENTER")
F.CreateBD(TutorialsFrame)

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
		p_bu:SetText(L["上一步"])
		T.resize_font(p_bu.Text)
		F.Reskin(p_bu)
		p_bu:SetScript("OnClick", function() 
			frame:Hide()
			TutorialsFrame[step-1]:Show()
		end)
		frame.p = p_bu
		
		local n_bu = CreateFrame("Button", G.uiname.."TutorialsStepFrameNext", frame, "UIPanelButtonTemplate")
		n_bu:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -15, 5)
		n_bu:SetSize(100, 25)
		n_bu:SetText(L["下一步"])
		T.resize_font(n_bu.Text)
		F.Reskin(n_bu)
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

local function CreateOptions(parent, type, text, table, value, group, order)
	if type == "check" then
		T.createcheckbutton(parent, 200, 30+parent.index*30, text, table, value)
	elseif type == "group" then
		T.createbuttongroup(parent, 450, 200, 30+parent.index*30, text, table, value, group, order)
	elseif type == "editbox" then
		T.createeditbox(parent, 200, 30+parent.index*30, text, table, value)
		parent[value]:SetText(G.links[text])
		parent[value]:SetWidth(400)
		parent[value]:SetScript("OnEditFocusGained", function(self)
			self:HighlightText()
		end)
		parent[value]:SetScript("OnEditFocusLost", function(self)
			self:HighlightText(0,0)
		end)
		parent[value].name:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	end
	parent.index = parent.index + 1
end

--====================================================--
--[[           -- 欢迎使用 和 简介 --               ]]--
--====================================================--

CreateTutorialsStepFrame(L["欢迎使用"], "ver"..G.Version.." "..L["小泡泡"])

CreateTutorialsStepFrame(L["欢迎使用"], L["简介"])
local skip = CreateFrame("Button", G.uiname.."TutorialsSkip", TutorialsFrame[2], "UIPanelButtonTemplate")
skip:SetPoint("BOTTOM", TutorialsFrame[2], "BOTTOM", 0, 5)
skip:SetSize(120, 25)
skip:SetText(L["跳过"])
T.resize_font(skip.Text)
F.Reskin(skip)
skip:SetScript("OnClick", function()
	TutorialsFrame[2]:Hide()
	TutorialsFrame:Hide()
	StaticPopup_Show(G.uiname.."Run Setup")
end)
		
--====================================================--
--[[               -- 界面风格 --                   ]]--
--====================================================--

CreateTutorialsStepFrame(L["界面风格"], L["界面风格tip"])
CreateOptions(TutorialsFrame[3], "group", true, "SkinOptions", "style", {L["透明样式"],L["深色样式"],L["普通样式"]})

for i = 1, 3 do
	TutorialsFrame[3]["style"][i]:HookScript("OnClick", function()
		G.BGFrame.Apply()
		T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
	end)
end


--====================================================--
--[[               -- 界面布局 --                   ]]--
--====================================================--

CreateTutorialsStepFrame(L["界面布局"], L["界面布局tip"])
CreateOptions(TutorialsFrame[4], "group", false, nil, "layout", {L["默认布局"],L["极简布局"],L["聚合布局"]})

Default_Layout = {
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
		{
			db_t = "UnitframeOptions", 
			db_v = "raidmanabars",
			value = true,	
		},
	},
}

Simplicity_Layout = {
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
		{
			db_t = "UnitframeOptions", 
			db_v = "raidmanabars",
			value = false,
		},
	},
}

Centralized_Layout = {
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
		{
			db_t = "UnitframeOptions", 
			db_v = "raidmanabars",
			value = true,
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
	G.BGFrame.Apply()
	T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana", "PVPSpecIcon"})
end

TutorialsFrame[4]["layout"][1]:SetScript("OnClick", function() ApplySizeAndPostions(Default_Layout) end)
TutorialsFrame[4]["layout"][2]:SetScript("OnClick", function() ApplySizeAndPostions(Simplicity_Layout) end)
TutorialsFrame[4]["layout"][3]:SetScript("OnClick", function() ApplySizeAndPostions(Centralized_Layout) end)

CreateOptions(TutorialsFrame[4], "group", false, nil, "unlock", {"unlock"})
TutorialsFrame[4]["unlock"][1]:SetScript("OnClick", function(self)
	G.SpecMover:SetScript("OnHide", function()
		TutorialsFrame:Show()
		G.SpecMover:SetScript("OnHide", nil)
	end)
	TutorialsFrame:Hide()
	T.UnlockAll()
end)
TutorialsFrame[4]["unlock"][1]:SetScript("OnShow", function(self) self:SetText(L["解锁框体"]) end)

local toggle_spec = {
	dpser = {
		["MONK"] = 2,
		["PRIEST"] = 1,
		["PALADIN"] = 1,
		["DRUID"] = 4,
		["SHAMAN"] = 3,
	},
	healer = {
		["MONK"] = 1,
		["PRIEST"] = 3,
		["PALADIN"] = 2,
		["DRUID"] = 1,
		["SHAMAN"] = 1,
	},
}

if toggle_spec.dpser[G.myClass] then -- 可治疗的职业才显示
	CreateOptions(TutorialsFrame[4], "group", false, nil, "layout_spec", {"spec"})
	TutorialsFrame[4]["layout_spec"][1]:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then
			self:SetText(L["当前模式"].." "..L[ T.CheckRole()])
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		elseif event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
			self:SetText(L["当前模式"].." "..L[T.CheckRole()])
		elseif event == "PLAYER_REGEN_ENABLED" then
			self:Enable()
		elseif event == "PLAYER_REGEN_DISABLED" then
			self:Disable()
		end
	end)
	TutorialsFrame[4]["layout_spec"][1]:RegisterEvent("PLAYER_LOGIN")
	
	TutorialsFrame[4]["layout_spec"][1]:SetScript("OnClick", function(self)
		local role = T.CheckRole()
		SetSpecialization(toggle_spec[role][G.myClass])
	end)
end

--====================================================--
--[[               -- 姓名板 --                   ]]--
--====================================================--
CreateTutorialsStepFrame(UNIT_NAMEPLATES, L["姓名板tip"])
local plate_theme_group = {
	["class"] = L["职业色-条形"],
	["dark"] =  L["深色-条形"],
	["number"] =  L["数字样式"],
}
CreateOptions(TutorialsFrame[5], "group", true, "PlateOptions", "theme", plate_theme_group)
for k, text in pairs(plate_theme_group) do
	TutorialsFrame[5]["theme"][k]:HookScript("OnClick", function()
		T.ApplyUFSettings({"Health", "Power", "Castbar", "Auras", "ClassPower", 
		"Runes", "RaidTargetIndicator", "Name", "PvPClassificationIndicator"}, 'Altz_Nameplates')	
		T.PostUpdateAllPlates()
		T.PlacePlateClassSource()
	end)
end

CreateOptions(TutorialsFrame[5], "check", L["显示玩家姓名板"], "PlateOptions", "playerplate")
TutorialsFrame[5]["playerplate"]:HookScript("OnClick", function()
	if aCoreCDB["PlateOptions"]["playerplate"] or aCoreCDB["PlateOptions"]["classresource_show"] then
		SetCVar("nameplateShowSelf", 1)
	else
		SetCVar("nameplateShowSelf", 0)
	end
	T.PostUpdateAllPlates()
end)

--====================================================--
--[[               -- 快捷指令 --                   ]]--
--====================================================--
CreateTutorialsStepFrame(L["命令"], format(L["指令"], G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor, G.classcolor))

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