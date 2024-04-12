local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local CurrentFrame, CurrentRole = "NONE"
local anchors = {"CENTER", "LEFT", "RIGHT", "TOP", "BOTTOM", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}

------------------
------- API ------
------------------
local SpecMover
G.SpecMover = SpecMover

local function GetDefaultPositions(frame, name)
	if aCoreCDB["FramePoints"][name] == nil then
		aCoreCDB["FramePoints"][name] = frame.point
	else
		for role, points in pairs(frame.point) do
			if aCoreCDB["FramePoints"][name][role] == nil then
				aCoreCDB["FramePoints"][name][role] = frame.point[role]
			else
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
	end
end

local function DisplayCurrentFramePoint()
	if CurrentFrame == "NONE" then
		SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor.."NONE|r")
		
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
		SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..gsub(frame.movingname, "\n", "").."|r")
		
		UIDropDownMenu_EnableDropDown(SpecMover.a1box)
		UIDropDownMenu_EnableDropDown(SpecMover.a2box)
		SpecMover.parentbox:Enable()
		SpecMover.xbox:Enable()
		SpecMover.ybox:Enable()
		SpecMover.ResetButton:Enable()
		
		local points = aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]
		UIDropDownMenu_SetText(SpecMover.a1box, points.a1)
		SpecMover.parentbox:SetText(points.parent)
		UIDropDownMenu_SetText(SpecMover.a2box, points.a2)
		SpecMover.xbox:SetText(points.x)
		SpecMover.ybox:SetText(points.y)
	end
end

local UnlockAll = function()
	if not InCombatLockdown() then
		if CurrentFrame ~= "NONE" then
			SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..gsub(_G[CurrentFrame].movingname, "\n", "").."|r")
		else
			SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..CurrentFrame.."|r")
		end
		for i = 1, #G.dragFrameList do
			local frame = G.dragFrameList[i]
			if frame.df.enable then
				frame.df:Show()
			end		
		end
		SpecMover:Show()
	else
		SpecMover:RegisterEvent("PLAYER_REGEN_ENABLED")
		print(G.classcolor..L["进入战斗锁定"].."|r")
	end
end
T.UnlockAll = UnlockAll

local LockAll = function()
	CurrentFrame = "NONE"
	DisplayCurrentFramePoint()

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
		if name == "Altz_Raid_Holder" then
			T.PlaceRaidFrame()
		end		
	end
end
T.PlaceFrame = PlaceFrame

local PlaceAllFrames = function(event)
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

local PlaceAllFramesPoint = function()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		ResetFramePoint(frame)
	end
	CurrentFrame = "NONE"
end
T.PlaceAllFramesPoint = PlaceAllFramesPoint

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
	frame.df.mask = F.CreateBDFrame(frame.df, 0.5)
	T.CreateSD(frame.df.mask, 2, 0, 0, 0, 0, -1)
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

local function Reskinbox(box, name, value, width, height, ...)
	box:SetSize(width, height)
	box:SetPoint(...)

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
end

local function ReskinDropDown(frame, name, value, ...)
	frame:SetPoint(...)
	
	F.ReskinDropDown(frame)
	
	frame.name = T.createtext(frame, "OVERLAY", 12, "OUTLINE", "LEFT")
	frame.name:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 15, 5)
	frame.name:SetText(G.classcolor..name.."|r")
	
	UIDropDownMenu_SetWidth(frame, 100)
	UIDropDownMenu_SetText(frame, "")

	UIDropDownMenu_Initialize(frame, function(self, level, menuList)
		local info = UIDropDownMenu_CreateInfo()
		for i = 1, #anchors do
			info.text = anchors[i]
			info.checked = function()
				if CurrentFrame ~= "NONE" then
					return (aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value] == info.text)
				end
			end
			info.func = function(self)
				aCoreCDB["FramePoints"][CurrentFrame][CurrentRole][value] = anchors[i]
				local frame = _G[CurrentFrame]
				PlaceFrame(frame)
				if CurrentFrame == "Altz_Raid_Holder" then
					T.PlaceRaidFrame()
				end
				UIDropDownMenu_SetSelectedName(frame, anchors[i], true)
				UIDropDownMenu_SetText(frame, anchors[i])
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
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

-- a1
SpecMover.a1box = CreateFrame("Frame", G.uiname.."SpecMoverPoint1DropDown", SpecMover, "UIDropDownMenuTemplate")
ReskinDropDown(SpecMover.a1box, "Point1", "a1", "TOPLEFT", SpecMover, "TOPLEFT", 0, -70)

-- parent
SpecMover.parentbox = CreateFrame("EditBox", G.uiname.."SpecMoverParentBox", SpecMover)
Reskinbox(SpecMover.parentbox, L["锚点框体"], "parent", 120, 20, "LEFT", SpecMover.a1box, "RIGHT", -2, 2)

-- a2
SpecMover.a2box = CreateFrame("Frame", G.uiname.."SpecMoverPoint2dropDown", SpecMover, "UIDropDownMenuTemplate")
ReskinDropDown(SpecMover.a2box, "Point2", "a2", "LEFT", SpecMover.parentbox, "RIGHT", -4, -2)

-- x
SpecMover.xbox = CreateFrame("EditBox", G.uiname.."SpecMoverXBox", SpecMover)
Reskinbox(SpecMover.xbox, "X", "x", 50, 20, "LEFT", SpecMover.a2box, "RIGHT", -2, 2)

-- y
SpecMover.ybox = CreateFrame("EditBox", G.uiname.."SpecMoverYBox", SpecMover)
Reskinbox(SpecMover.ybox, "Y", "y", 50, 20, "LEFT", SpecMover.xbox, "RIGHT", 10, 0)

-- reset
SpecMover.ResetButton = CreateFrame("Button", G.uiname.."SpecMoverResetButton", SpecMover, "UIPanelButtonTemplate")
SpecMover.ResetButton:SetPoint("BOTTOMLEFT", SpecMover, "BOTTOMLEFT", 20, 10)
SpecMover.ResetButton:SetSize(250, 25)
SpecMover.ResetButton:SetText(L["重置位置"])
F.Reskin(SpecMover.ResetButton)
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
F.Reskin(SpecMover.LockButton)
SpecMover.LockButton:SetScript("OnClick", LockAll)

SpecMover:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
		PlaceAllFrames(event)
	elseif event == "PLAYER_REGEN_DISABLED" then
		if SpecMover:IsShown() then
			LockAll()
			print(G.classcolor..L["进入战斗锁定"].."|r")
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		UnlockAll()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	elseif event == "PLAYER_LOGIN" then
		PlaceAllFrames(event)
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end)

SpecMover:RegisterEvent("PLAYER_LOGIN")
