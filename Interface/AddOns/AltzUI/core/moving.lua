﻿local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local CurrentFrame = "NONE"
local anchors = {"CENTER", "LEFT", "RIGHT", "TOP", "BOTTOM", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}
local role, selected

local function PlaceCurrentFrame(df)
	local f = _G[CurrentFrame]
	local points = aCoreCDB["FramePoints"][CurrentFrame][role]
	f:ClearAllPoints()
	f:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	if df then
		f.df:ClearAllPoints() -- 拖动框重新连接到锚点
		f.df:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	end
end

local function Reskinbox(box, name, value, anchor, x, y)
	box:SetPoint("LEFT", anchor, "RIGHT", x, y)

	box.name = T.createtext(box, "OVERLAY", 12, "OUTLINE", "LEFT")
	box.name:SetPoint("BOTTOMLEFT", box, "TOPLEFT", 5, 8)
	box.name:SetText(G.classcolor..name.."|r")

	local bd = CreateFrame("Frame", nil, box, "BackdropTemplate")
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(box:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(box)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)

	box:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)

	box:SetScript("OnShow", function(self)
		if CurrentFrame ~= "NONE" then
			self:SetText(aCoreCDB["FramePoints"][CurrentFrame][role][value])
		else
			self:SetText("")
		end
	end)

	box:SetScript("OnEscapePressed", function(self)
		if CurrentFrame ~= "NONE" then
			self:SetText(aCoreCDB["FramePoints"][CurrentFrame][role][value])
		else
			self:SetText("")
		end
		self:ClearFocus()
	end)

	box:SetScript("OnEnterPressed", function(self)
		if CurrentFrame ~= "NONE" then
			aCoreCDB["FramePoints"][CurrentFrame][role][value] = self:GetText()
			PlaceCurrentFrame(true)
		else
			self:SetText("")
		end
		self:ClearFocus()
	end)
end

local SpecMover = CreateFrame("Frame", G.uiname.."SpecMover", UIParent, "BackdropTemplate")
SpecMover:SetPoint("CENTER", 0, -300)
SpecMover:SetSize(540, 140)
SpecMover:SetFrameStrata("HIGH")
SpecMover:SetFrameLevel(30)
SpecMover:Hide()

SpecMover:RegisterForDrag("LeftButton")
SpecMover:SetScript("OnDragStart", function(self) self:StartMoving() end)
SpecMover:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
SpecMover:SetClampedToScreen(true)
SpecMover:SetMovable(true)
SpecMover:EnableMouse(true)

F.CreateBD(SpecMover, 1)
T.CreateSD(SpecMover, 2, 0, 0, 0, 0, -1)
SpecMover:SetBackdropColor(.05, .05, .05)

SpecMover.title = T.createtext(SpecMover, "OVERLAY", 16, "OUTLINE", "CENTER")
SpecMover.title:SetPoint("TOP", SpecMover, "TOP", 0, -2)
SpecMover.title:SetText(G.classcolor..L["界面移动工具"].."|r")

SpecMover.curmode = T.createtext(SpecMover, "OVERLAY", 12, "OUTLINE", "LEFT")
SpecMover.curmode:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 10, -15)

SpecMover.curframe = T.createtext(SpecMover, "OVERLAY", 12, "OUTLINE", "LEFT")
SpecMover.curframe:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 10, -30)

-- align
SpecMover.align = CreateFrame('Frame', G.uiname.."Align", SpecMover)
SpecMover.align:SetAllPoints(UIParent)

local width = G.screenwidth/10
if width > 200 then width = G.screenwidth/20 end

local h = math.floor(G.screenheight/width)
local w = math.floor(G.screenwidth/width)

for i = 0, h do
	SpecMover.align["vertical"..i] = SpecMover.align:CreateTexture(nil, 'BACKGROUND')
	SpecMover.align["vertical"..i]:SetTexture(0, 0.8, 1, 0.5)
	SpecMover.align["vertical"..i]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -width*i + 1)
	SpecMover.align["vertical"..i]:SetPoint('BOTTOMRIGHT', UIParent, 'TOPRIGHT', 0, -width*i - 1)
end

for i = 0, w do
	SpecMover.align["horizontal"..i] = SpecMover.align:CreateTexture(nil, 'BACKGROUND')
	SpecMover.align["horizontal"..i]:SetTexture(0, 0.8, 1, 0.5)
	SpecMover.align["horizontal"..i]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", width*i -1, 0)
	SpecMover.align["horizontal"..i]:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMLEFT', width*i + 1, 0)
end

-- a1
local Point1dropDown = CreateFrame("Frame", G.uiname.."SpecMoverPoint1DropDown", SpecMover, "L_UIDropDownMenuTemplate")
Point1dropDown:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 0, -70)
F.ReskinDropDown(Point1dropDown)

Point1dropDown.name = T.createtext(Point1dropDown, "OVERLAY", 12, "OUTLINE", "LEFT")
Point1dropDown.name:SetPoint("BOTTOMLEFT", Point1dropDown, "TOPLEFT", 15, 5)
Point1dropDown.name:SetText(G.classcolor.."Point1|r")

L_UIDropDownMenu_SetWidth(Point1dropDown, 100)
L_UIDropDownMenu_SetText(Point1dropDown, "")

L_UIDropDownMenu_Initialize(Point1dropDown, function(self, level, menuList)
	local info = L_UIDropDownMenu_CreateInfo()
	for i = 1, #anchors do
		info.text = anchors[i]
		info.checked = function()
			if CurrentFrame ~= "NONE" then
				return (aCoreCDB["FramePoints"][CurrentFrame][role]["a1"] == info.text)
			end
		end
		info.func = function(self)
			aCoreCDB["FramePoints"][CurrentFrame][role]["a1"] = anchors[i]
			PlaceCurrentFrame()
			if CurrentFrame == "Altz_HealerRaid_Holder" then
				T.PlaceRaidFrame()
			end
			L_UIDropDownMenu_SetSelectedName(Point1dropDown, anchors[i], true)
			L_UIDropDownMenu_SetText(Point1dropDown, anchors[i])
			L_CloseDropDownMenus()
		end
		L_UIDropDownMenu_AddButton(info)
	end
end)

-- parent
local ParentBox = CreateFrame("EditBox", G.uiname.."SpecMoverParentBox", SpecMover)
ParentBox:SetSize(120, 20)
Reskinbox(ParentBox, L["锚点框体"], "parent", Point1dropDown, -2, 2)

-- a2
local Point2dropDown = CreateFrame("Frame", G.uiname.."SpecMoverPoint2dropDown", SpecMover, "L_UIDropDownMenuTemplate")
Point2dropDown:SetPoint("LEFT", ParentBox, "RIGHT", -4, -2)
F.ReskinDropDown(Point2dropDown)

Point2dropDown.name = T.createtext(Point2dropDown, "OVERLAY", 12, "OUTLINE", "LEFT")
Point2dropDown.name:SetPoint("BOTTOMLEFT", Point2dropDown, "TOPLEFT", 15, 5)
Point2dropDown.name:SetText(G.classcolor.."Point2|r")

L_UIDropDownMenu_SetWidth(Point2dropDown, 100)
L_UIDropDownMenu_SetText(Point2dropDown, "")

L_UIDropDownMenu_Initialize(Point2dropDown, function(self, level, menuList)
	local info = L_UIDropDownMenu_CreateInfo()
	for i = 1, #anchors do
		info.text = anchors[i]
		info.checked = function()
			if CurrentFrame ~= "NONE" then
				return (aCoreCDB["FramePoints"][CurrentFrame][role]["a2"] == info.text)
			end
		end
		info.func = function(self)
			aCoreCDB["FramePoints"][CurrentFrame][role]["a2"] = anchors[i]
			PlaceCurrentFrame()
			L_UIDropDownMenu_SetSelectedName(Point2dropDown, anchors[i], true)
			L_UIDropDownMenu_SetText(Point2dropDown, anchors[i])
			L_CloseDropDownMenus()
		end
		L_UIDropDownMenu_AddButton(info)
	end
end)

-- x
local XBox = CreateFrame("EditBox", G.uiname.."SpecMoverXBox", SpecMover)
XBox:SetSize(50, 20)
Reskinbox(XBox, "X", "x", Point2dropDown, -2, 2)

-- y
local YBox = CreateFrame("EditBox", G.uiname.."SpecMoverYBox", SpecMover)
YBox:SetSize(50, 20)
Reskinbox(YBox, "Y", "y", XBox, 10, 0)

local function DisplayCurrentFramePoint()
	local points = aCoreCDB["FramePoints"][CurrentFrame][role]
	L_UIDropDownMenu_SetText(Point1dropDown, points.a1)
	ParentBox:SetText(points.parent)
	L_UIDropDownMenu_SetText(Point2dropDown, points.a2)
	XBox:SetText(points.x)
	YBox:SetText(points.y)
end

-- reset
local ResetButton = CreateFrame("Button", G.uiname.."SpecMoverResetButton", SpecMover, "UIPanelButtonTemplate")
ResetButton:SetPoint("BOTTOMLEFT", SpecMover, "BOTTOMLEFT", 20, 10)
ResetButton:SetSize(250, 25)
ResetButton:SetText(L["重置位置"])
F.Reskin(ResetButton)
ResetButton:SetScript("OnClick", function()
	if CurrentFrame ~= "NONE" then
		local frame = _G[CurrentFrame]

		aCoreCDB["FramePoints"][CurrentFrame][role].a1 = frame["point"][role].a1
		aCoreCDB["FramePoints"][CurrentFrame][role].parent = frame["point"][role].parent
		aCoreCDB["FramePoints"][CurrentFrame][role].a2 = frame["point"][role].a2
		aCoreCDB["FramePoints"][CurrentFrame][role].x = frame["point"][role].x
		aCoreCDB["FramePoints"][CurrentFrame][role].y = frame["point"][role].y

		PlaceCurrentFrame(true)
		DisplayCurrentFramePoint()
	end
end)

function T.CreateDragFrame(frame)
	local fname = frame:GetName()

	if aCoreCDB["FramePoints"][fname] == nil then
		aCoreCDB["FramePoints"][fname] = frame.point
	else
		for role, points in pairs(frame.point) do
			if aCoreCDB["FramePoints"][fname][role] == nil then
				aCoreCDB["FramePoints"][fname][role] = frame.point[role]
			else
				if aCoreCDB["FramePoints"][fname][role]["a1"] == nil then
					aCoreCDB["FramePoints"][fname][role]["a1"] = frame.point[role].a1
				end
				if aCoreCDB["FramePoints"][fname][role]["a2"] == nil then
					aCoreCDB["FramePoints"][fname][role]["a2"] = frame.point[role].a2
				end
				if aCoreCDB["FramePoints"][fname][role]["parent"] == nil then
					aCoreCDB["FramePoints"][fname][role]["parent"] = frame.point[role].parent
				end
				if aCoreCDB["FramePoints"][fname][role]["x"] == nil then
					aCoreCDB["FramePoints"][fname][role]["x"] = frame.point[role].x
				end
				if aCoreCDB["FramePoints"][fname][role]["y"] == nil then
					aCoreCDB["FramePoints"][fname][role]["y"] = frame.point[role].y
				end
			end
		end
	end

	table.insert(G.dragFrameList, frame) --add frame object to the list

	frame.df = CreateFrame("Frame", fname.."DragFrame", UIParent)
	frame.df:SetMovable(true)
	frame.df:SetFrameStrata("HIGH")
	frame.df:EnableMouse(true)
	frame.df:RegisterForDrag("LeftButton")
	frame.df:SetClampedToScreen(true)
	
	frame.df:SetScript("OnShow", function(self, event)		
		frame.df:SetSize(frame:GetWidth(), frame:GetHeight())
		local points = aCoreCDB["FramePoints"][fname][role]
		frame.df:ClearAllPoints()
		frame.df:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	end)
	
	frame.df:SetScript("OnDragStart", function(self)	
		frame.df:StartMoving()
	end)
	
	frame.df:SetScript("OnDragStop", function(self)
		local x, y = GetCursorPosition() -- 结束的位置
		local x1, y1 = ("%d"):format((x - self.x)*GetScreenWidth()/1364.8), ("%d"):format((y -self.y)*GetScreenHeight()/780) -- 计算偏移量
		aCoreCDB["FramePoints"][fname][role].x = aCoreCDB["FramePoints"][fname][role].x + x1
		aCoreCDB["FramePoints"][fname][role].y = aCoreCDB["FramePoints"][fname][role].y + y1
		PlaceCurrentFrame(true) -- 重新连接到锚点
		DisplayCurrentFramePoint()
		frame.df:StopMovingOrSizing()
	end)
	frame.df:Hide()

	--overlay texture
	frame.df.mask = F.CreateBDFrame(frame.df, 0.5)
	T.CreateSD(frame.df.mask, 2, 0, 0, 0, 0, -1)
	frame.df.mask.text = T.createtext(frame.df, "OVERLAY", 13, "OUTLINE", "LEFT")
	frame.df.mask.text:SetPoint("TOPLEFT")
	frame.df.mask.text:SetText(frame.movingname)

	frame.df:SetScript("OnMouseDown", function(self)
		self.x, self.y = GetCursorPosition() -- 开始的位置
		CurrentFrame = fname
		SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..gsub(frame.movingname, "\n", "").."|r")
		DisplayCurrentFramePoint()
		if not selected then
			L_UIDropDownMenu_EnableDropDown(Point1dropDown)
			L_UIDropDownMenu_EnableDropDown(Point2dropDown)
			ParentBox:Enable()
			XBox:Enable()
			YBox:Enable()
			selected = true
		end
		for i = 1, #G.dragFrameList do
			if G.dragFrameList[i]:GetName() == fname then
				G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 1, 1)
			else
				G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end)
end

local function UnlockAll()
	if not InCombatLockdown() then
		if CurrentFrame ~= "NONE" then
			SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..gsub(_G[CurrentFrame].movingname, "\n", "").."|r")
		else
			SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..CurrentFrame.."|r")
		end
		for i = 1, #G.dragFrameList do
			G.dragFrameList[i].df:Show()
		end
		SpecMover:Show()
	else
		SpecMover:RegisterEvent("PLAYER_REGEN_ENABLED")
		print(G.classcolor..L["进入战斗锁定"].."|r")
	end
end

local function LockAll()
	-- reset
	CurrentFrame = "NONE"
	L_UIDropDownMenu_SetText(Point1dropDown, "")
	L_UIDropDownMenu_SetText(Point2dropDown, "")
	L_UIDropDownMenu_DisableDropDown(Point1dropDown)
	L_UIDropDownMenu_DisableDropDown(Point2dropDown)
	ParentBox:Disable()
	XBox:Disable()
	YBox:Disable()
	selected = false

	for i = 1, #G.dragFrameList do
		G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 0, 0)
		G.dragFrameList[i].df:Hide()
	end
	SpecMover:Hide()
end

local function OnSpecChanged()
	role = T.CheckRole()
	SpecMover.curmode:SetText(L["当前模式"].." "..L[role])

	for i = 1, #G.dragFrameList do
		local name = G.dragFrameList[i]:GetName()
		local points = aCoreCDB["FramePoints"][name][role]
		G.dragFrameList[i]:ClearAllPoints()
		G.dragFrameList[i]:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	end
end

SpecMover:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
		OnSpecChanged()
	elseif event == "PLAYER_REGEN_DISABLED" then
		if SpecMover:IsShown() then
			LockAll()
			print(G.classcolor..L["进入战斗锁定"].."|r")
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		UnlockAll()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	elseif event == "PLAYER_LOGIN" then
		OnSpecChanged()
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end)

SpecMover:RegisterEvent("PLAYER_LOGIN")

-- lock
local LockButton = CreateFrame("Button", G.uiname.."SpecMoverLockButton", SpecMover, "UIPanelButtonTemplate")
LockButton:SetPoint("LEFT", ResetButton, "RIGHT", 10, 0)
LockButton:SetSize(250, 25)
LockButton:SetText(L["锁定框体"])
F.Reskin(LockButton)
LockButton:SetScript("OnClick", function()
	LockAll()
end)

-- place buttons to GUI
local IntroOptions = _G[G.uiname.."Intro Frame"]
local resetposbutton = CreateFrame("Button", G.uiname.."ResetPosButton", IntroOptions, "UIPanelButtonTemplate")
resetposbutton:SetPoint("BOTTOMRIGHT", IntroOptions, "BOTTOM", -145, 80)
resetposbutton:SetSize(130, 25)
resetposbutton:SetText(L["重置框体位置"])
F.Reskin(resetposbutton)
resetposbutton:SetScript("OnClick", function()
	for i = 1, #G.dragFrameList do
		local f = G.dragFrameList[i]
		aCoreCDB["FramePoints"][f:GetName()] = {}
		for role, points in pairs (f.point) do
			aCoreCDB["FramePoints"][f:GetName()][role] = {}
			for k, v in pairs (points) do
				aCoreCDB["FramePoints"][f:GetName()][role][k] = v
			end
		end
		CurrentFrame = f:GetName()
		PlaceCurrentFrame()
	end
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetSize(300, 130)
	ChatFrame1:SetPoint("BOTTOMLEFT", _G[G.uiname.."chatframe_pullback"],"BOTTOMLEFT", 3, 5)

	FCF_SavePositionAndDimensions(ChatFrame1)
	CurrentFrame = "NONE"
end)

local unlockbutton = CreateFrame("Button", G.uiname.."UnlockAllFramesButton", IntroOptions, "UIPanelButtonTemplate")
unlockbutton:SetPoint("BOTTOMRIGHT", IntroOptions, "BOTTOM", -5, 80)
unlockbutton:SetSize(130, 25)
unlockbutton:SetText(L["解锁框体"])
F.Reskin(unlockbutton)
unlockbutton:SetScript("OnClick", function()
	UnlockAll()
	_G[G.uiname.."GUI Main Frame"]:Hide()
end)

local function slashCmdFunction(msg)
	local msg = string.lower(msg)
	if msg == "unlock" then
		UnlockAll()
	end
end

SlashCmdList["AltzUI"] = slashCmdFunction
AltzUI1 = "/altz"
