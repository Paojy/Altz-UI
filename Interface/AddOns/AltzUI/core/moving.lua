local T, C, L, G = unpack(select(2, ...))

G.dragFrameList = {}

local CurrentFrame, CurrentRole = "NONE"

local anchors = {
	{"CENTER", L["中间"]},
	{"LEFT", L["左"]},
	{"RIGHT", L["右"]},
	{"TOP", L["上"]},
	{"BOTTOM", L["下"]},
	{"TOPLEFT", L["左上"]},
	{"TOPRIGHT", L["右上"]},
	{"BOTTOMLEFT", L["左下"]},
	{"BOTTOMRIGHT", L["右下"]},
}

local function GetAnchorName(anchor)
	for i, info in pairs(anchors) do
		if info[1] == anchor then
			return info[2]
		end
	end
end
------------------
------- API ------
------------------
local SpecMover
G.SpecMover = SpecMover

local function GetDefaultPositions(frame, name)
	if aCoreCDB["FramePoints"][name] == nil then
		aCoreCDB["FramePoints"][name] = {}
	end
	for role in pairs(frame.point) do
		if aCoreCDB["FramePoints"][name][role] == nil then
			aCoreCDB["FramePoints"][name][role] = {}
		end
		if aCoreCDB["FramePoints"][name][role]["a1"] == nil then
			aCoreCDB["FramePoints"][name][role]["a1"] = frame.point[role].a1
		end
		if aCoreCDB["FramePoints"][name][role]["a2"] == nil then
			aCoreCDB["FramePoints"][name][role]["a2"] = frame.point[role].a2
		end
		if aCoreCDB["FramePoints"][name][role]["parent"] == nil then
			aCoreCDB["FramePoints"][name][role]["parent"] = frame.point[role].parent
		end
		if aCoreCDB["FramePoints"][name][role]["x"] == nil then
			aCoreCDB["FramePoints"][name][role]["x"] = frame.point[role].x
		end
		if aCoreCDB["FramePoints"][name][role]["y"] == nil then
			aCoreCDB["FramePoints"][name][role]["y"] = frame.point[role].y
		end
	end
end

local function DisplayCurrentFramePoint()
	if CurrentFrame == "NONE" then
		SpecMover.curframe:SetText(L["选中的框体"].." "..T.color_text("NONE"))
		
		UIDropDownMenu_DisableDropDown(SpecMover.a1box)
		UIDropDownMenu_DisableDropDown(SpecMover.a2box)
		SpecMover.parentbox:Disable()
		SpecMover.xbox:Disable()
		SpecMover.ybox:Disable()
		SpecMover.ResetButton:Disable()
		
		UIDropDownMenu_SetText(SpecMover.a1box, "")
		SpecMover.parentbox:SetText("")
		UIDropDownMenu_SetText(SpecMover.a2box, "")
		SpecMover.xbox:SetText("")
		SpecMover.ybox:SetText("")
	else
		local frame = _G[CurrentFrame]
		SpecMover.curframe:SetText(L["选中的框体"].." "..T.color_text(gsub(frame.movingname, "\n", "")))
		
		UIDropDownMenu_EnableDropDown(SpecMover.a1box)
		UIDropDownMenu_EnableDropDown(SpecMover.a2box)
		SpecMover.parentbox:Enable()
		SpecMover.xbox:Enable()
		SpecMover.ybox:Enable()
		SpecMover.ResetButton:Enable()
		
		local points = aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]
		UIDropDownMenu_SetSelectedValue(SpecMover.a1box, points.a1)
		UIDropDownMenu_SetText(SpecMover.a1box, GetAnchorName(points.a1))
		SpecMover.parentbox:SetText(points.parent)
		UIDropDownMenu_SetSelectedValue(SpecMover.a2box, points.a2)
		UIDropDownMenu_SetText(SpecMover.a2box, GetAnchorName(points.a2))
		SpecMover.xbox:SetText(points.x)
		SpecMover.ybox:SetText(points.y)
	end
end

local UnlockAll = function()
	if not InCombatLockdown() then
		for i = 1, #G.dragFrameList do
			local frame = G.dragFrameList[i]
			if frame.df.enable then
				frame.df:Show()
			end		
		end
		SpecMover:Show()
		DisplayCurrentFramePoint()
	else
		SpecMover:RegisterEvent("PLAYER_REGEN_ENABLED")
		print(T.color_text(L["进入战斗锁定"]))
	end
end
T.UnlockAll = UnlockAll

local LockAll = function()
	CurrentFrame = "NONE"

	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		frame.df.mask:SetBackdropBorderColor(0, 0, 0)
		frame.df:Hide()
	end
	
	SpecMover:Hide()
end
T.LockAll = LockAll

local function PlaceFrame(frame)
	local name = frame:GetName()
	
	if not aCoreCDB["FramePoints"][name] then
		GetDefaultPositions(frame, name)
	end

	local points = aCoreCDB["FramePoints"][name][CurrentRole]
	
	if points and frame.df.enable then
		frame:ClearAllPoints()
		frame:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	end
end
T.PlaceFrame = PlaceFrame

local PlaceAllFrames = function()
	CurrentRole = CurrentRole or T.CheckRole()
	SpecMover.curmode:SetText(L["当前模式"].." "..L[CurrentRole])
	
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		PlaceFrame(frame)
	end
end
T.PlaceAllFrames = PlaceAllFrames

local ResetFramePoint = function(frame)
	local name = frame:GetName()
	
	aCoreCDB["FramePoints"][name] = nil
	
	PlaceFrame(frame)
end
T.ResetFramePoint = ResetFramePoint

local ResetAllFramesPoint = function()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		ResetFramePoint(frame)
	end
	CurrentFrame = "NONE"
end
T.ResetAllFramesPoint = ResetAllFramesPoint

-- 创建移动框
T.CreateDragFrame = function(frame)
	local name = frame:GetName()
	
	table.insert(G.dragFrameList, frame) --add frame object to the list
	
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	
	frame.df = CreateFrame("Frame", name.."DragFrame", UIParent)
	frame.df:SetAllPoints(frame)
	frame.df:SetFrameStrata("HIGH")
	frame.df:EnableMouse(true)
	frame.df:RegisterForDrag("LeftButton")
	frame.df:SetClampedToScreen(true)
	frame.df.enable = true
	frame.df:Hide()
	
	--overlay texture
	frame.df.mask = T.createBackdrop(frame.df, .5)	
	frame.df.mask.text = T.createtext(frame.df, "OVERLAY", 13, "OUTLINE", "LEFT")
	frame.df.mask.text:SetPoint("TOPLEFT")
	frame.df.mask.text:SetText(frame.movingname)
	
	frame.df:SetScript("OnMouseDown", function(self)
		CurrentFrame = name
		DisplayCurrentFramePoint()
		
		for i = 1, #G.dragFrameList do
			if G.dragFrameList[i]:GetName() == name then
				G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 1, 1)
			else
				G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 0, 0)
			end
		end	
	end)
	
	frame.df:SetScript("OnDragStart", function(self)	
		frame:StartMoving()
		self.x, self.y = frame:GetCenter() -- 开始的位置
	end)
	
	frame.df:SetScript("OnDragStop", function(self)
		frame:StopMovingOrSizing()
		local x, y = frame:GetCenter() -- 结束的位置
		local x1, y1 = ("%d"):format(x - self.x), ("%d"):format(y -self.y)
		aCoreCDB["FramePoints"][name][CurrentRole].x = aCoreCDB["FramePoints"][name][CurrentRole].x + x1
		aCoreCDB["FramePoints"][name][CurrentRole].y = aCoreCDB["FramePoints"][name][CurrentRole].y + y1
		
		PlaceFrame(frame) -- 重新连接到锚点
		
		DisplayCurrentFramePoint()
	end)
end

-- 禁用移动框
T.ReleaseDragFrame = function(frame)
	if frame.df then
		frame.df.enable = false
		frame.df:Hide()
	end
end

-- 恢复移动框
T.RestoreDragFrame = function(frame)
	if frame.df then
		frame.df.enable = true
		PlaceFrame(frame)
		if SpecMover:IsShown() then
			frame.df:Show()
		end
	end
end

local function CreateInputBox(parent, width, points, name, value)
	local box = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	box:SetSize(width, 20)
	box:SetPoint(unpack(points))
	
	T.setPXBackdrop(box, .3)
	box:SetBackdropBorderColor(.5, .5, .5)
	
	box.name = T.createtext(box, "OVERLAY", 12, "OUTLINE", "LEFT")
	box.name:SetPoint("BOTTOMLEFT", box, "TOPLEFT", 5, 8)
	box.name:SetText(T.color_text(name))
	
	box:SetFont(G.norFont, 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	
	box:SetScript("OnChar", function(self) 
		self:SetBackdropBorderColor(1, 1, 0)		
	end)
	
	box:SetScript("OnEditFocusGained", function(self)
		self:SetBackdropBorderColor(1, 1, 1)
	end)
	
	box:SetScript("OnEditFocusLost", function(self)
		self:SetBackdropBorderColor(.5, .5, .5)
	end)

	box:SetScript("OnShow", function(self)
		if CurrentFrame ~= "NONE" then
			self:SetText(aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value])
		else
			self:SetText("")
		end
	end)

	box:SetScript("OnEscapePressed", function(self)
		if CurrentFrame ~= "NONE" then
			self:SetText(aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value])
		else
			self:SetText("")
		end
		self:ClearFocus()
	end)

	box:SetScript("OnEnterPressed", function(self)
		if CurrentFrame ~= "NONE" then
			aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value] = self:GetText()
			local frame = _G[CurrentFrame]
			PlaceFrame(frame)
		else
			self:SetText("")
		end
		self:ClearFocus()
	end)
	
	box:SetScript("OnEnable", function(self)	
		self:SetTextColor(1, 1, 1, 1)	
	end)
	
	box:SetScript("OnDisable", function(self)	
		self:SetTextColor(.7, .7, .7, .5)
	end)
	
	return box
end

local function CreateDropDown(parent, points, name, value)
	local dd = CreateFrame("Frame", G.uiname.."SpecMoverPoint1DropDown", SpecMover, "UIDropDownMenuTemplate")
	dd:SetPoint(unpack(points))
	
	T.ReskinDropDown(dd)
	
	dd.name = T.createtext(dd, "OVERLAY", 12, "OUTLINE", "LEFT")
	dd.name:SetPoint("BOTTOMLEFT", dd, "TOPLEFT", 15, 5)
	dd.name:SetText(T.color_text(name))
	
	UIDropDownMenu_SetWidth(dd, 100)
	UIDropDownMenu_Initialize(dd, function(self, level, menuList)
		local info = UIDropDownMenu_CreateInfo()
		for i = 1, #anchors do
			info.value = anchors[i][1]
			info.text = anchors[i][2]
			info.checked = function()
				if CurrentFrame ~= "NONE" then
					return (aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value] == info.value)
				end
			end
			info.func = function(self)
				aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value] = info.value
				local frame = _G[CurrentFrame]
				PlaceFrame(frame)
				UIDropDownMenu_SetSelectedValue(dd, info.value)
				UIDropDownMenu_SetText(dd, info.text)
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	
	return dd
end

------------------
-- 移动控制面板 --
------------------
SpecMover = CreateFrame("Frame", G.uiname.."SpecMover", UIParent, "BackdropTemplate")
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

SpecMover.backdrop = T.createBackdrop(SpecMover, .5)
T.setStripeBg(SpecMover.backdrop)

SpecMover.reset_all = T.ClickTexButton(SpecMover, {"TOPRIGHT", SpecMover, "TOPRIGHT", -3, -3}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])
SpecMover.reset_all:SetScript("OnClick", function()
	StaticPopupDialogs[G.uiname.."Reset Confirm"].text = string.format(L["重置确认"], L["框体位置"])
	StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = T.ResetAllFramesPoint
	StaticPopup_Show(G.uiname.."Reset Confirm")
end)

SpecMover.title = T.createtext(SpecMover, "OVERLAY", 16, "OUTLINE", "CENTER")
SpecMover.title:SetPoint("TOP", SpecMover, "TOP", 0, -2)
SpecMover.title:SetText(T.color_text(L["界面移动工具"]))

SpecMover.curmode = T.createtext(SpecMover, "OVERLAY", 12, "OUTLINE", "LEFT")
SpecMover.curmode:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 10, -15)

SpecMover.curframe = T.createtext(SpecMover, "OVERLAY", 12, "OUTLINE", "LEFT")
SpecMover.curframe:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 10, -30)

-- a1
SpecMover.a1box = CreateDropDown(SpecMover, {"TOPLEFT", SpecMover, "TOPLEFT", 0, -70}, L["锚点"].."1", "a1")

-- parent
SpecMover.parentbox = CreateInputBox(SpecMover, 120, {"LEFT", SpecMover.a1box, "RIGHT", -2, 2}, L["锚点框体"], "parent")

-- a2
SpecMover.a2box = CreateDropDown(SpecMover, {"LEFT", SpecMover.parentbox, "RIGHT", -4, -2}, L["锚点"].."2", "a2")

-- x
SpecMover.xbox = CreateInputBox(SpecMover, 50, {"LEFT", SpecMover.a2box, "RIGHT", -2, 2}, "X", "x")

-- y
SpecMover.ybox = CreateInputBox(SpecMover, 50, {"LEFT", SpecMover.xbox, "RIGHT", 10, 0}, "Y", "y")

-- reset
SpecMover.ResetButton = CreateFrame("Button", G.uiname.."SpecMoverResetButton", SpecMover, "UIPanelButtonTemplate")
SpecMover.ResetButton:SetPoint("BOTTOMLEFT", SpecMover, "BOTTOMLEFT", 20, 10)
SpecMover.ResetButton:SetSize(250, 25)
SpecMover.ResetButton:SetText(L["重置位置"])
T.ReskinButton(SpecMover.ResetButton)
SpecMover.ResetButton:SetScript("OnClick", function()
	if CurrentFrame ~= "NONE" then
		local frame = _G[CurrentFrame]
		ResetFramePoint(frame)
		DisplayCurrentFramePoint()
	end
end)

-- lock
SpecMover.LockButton = CreateFrame("Button", G.uiname.."SpecMoverLockButton", SpecMover, "UIPanelButtonTemplate")
SpecMover.LockButton:SetPoint("LEFT", SpecMover.ResetButton, "RIGHT", 10, 0)
SpecMover.LockButton:SetSize(250, 25)
SpecMover.LockButton:SetText(L["锁定框体"])
T.ReskinButton(SpecMover.LockButton)
SpecMover.LockButton:SetScript("OnClick", LockAll)

SpecMover:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
		PlaceAllFrames()
	elseif event == "PLAYER_REGEN_DISABLED" then
		if SpecMover:IsShown() then
			LockAll()
			print(T.color_text(L["进入战斗锁定"]))
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		UnlockAll()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	elseif event == "PLAYER_LOGIN" then
		PlaceAllFrames()
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end)

SpecMover:RegisterEvent("PLAYER_LOGIN")
