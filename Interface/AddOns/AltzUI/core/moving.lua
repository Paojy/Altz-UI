local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local CurrentFrame, CurrentRole = "NONE"
local anchors = {"CENTER", "LEFT", "RIGHT", "TOP", "BOTTOM", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}

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
			T.PlaceFrame(CurrentFrame)
		else
			self:SetText("")
		end
		self:ClearFocus()
	end)
end

------------------
-- 移动控制面板 --
------------------
local SpecMover = CreateFrame("Frame", G.uiname.."SpecMover", UIParent, "BackdropTemplate")
SpecMover:SetPoint("CENTER", 0, -300)
SpecMover:SetSize(540, 140)
SpecMover:SetFrameStrata("HIGH")
SpecMover:SetFrameLevel(30)
SpecMover:Hide()
G.SpecMover = SpecMover

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
local Point1dropDown = CreateFrame("Frame", G.uiname.."SpecMoverPoint1DropDown", SpecMover, "UIDropDownMenuTemplate")
Point1dropDown:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 0, -70)
F.ReskinDropDown(Point1dropDown)

Point1dropDown.name = T.createtext(Point1dropDown, "OVERLAY", 12, "OUTLINE", "LEFT")
Point1dropDown.name:SetPoint("BOTTOMLEFT", Point1dropDown, "TOPLEFT", 15, 5)
Point1dropDown.name:SetText(G.classcolor.."Point1|r")

UIDropDownMenu_SetWidth(Point1dropDown, 100)
UIDropDownMenu_SetText(Point1dropDown, "")

UIDropDownMenu_Initialize(Point1dropDown, function(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	for i = 1, #anchors do
		info.text = anchors[i]
		info.checked = function()
			if CurrentFrame ~= "NONE" then
				return (aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]["a1"] == info.text)
			end
		end
		info.func = function(self)
			aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]["a1"] = anchors[i]
			T.PlaceFrame(CurrentFrame)
			if CurrentFrame == "Altz_HealerRaid_Holder" then
				T.PlaceRaidFrame()
			end
			UIDropDownMenu_SetSelectedName(Point1dropDown, anchors[i], true)
			UIDropDownMenu_SetText(Point1dropDown, anchors[i])
		end
		UIDropDownMenu_AddButton(info)
	end
end)

-- parent
local ParentBox = CreateFrame("EditBox", G.uiname.."SpecMoverParentBox", SpecMover)
ParentBox:SetSize(120, 20)
Reskinbox(ParentBox, L["锚点框体"], "parent", Point1dropDown, -2, 2)

-- a2
local Point2dropDown = CreateFrame("Frame", G.uiname.."SpecMoverPoint2dropDown", SpecMover, "UIDropDownMenuTemplate")
Point2dropDown:SetPoint("LEFT", ParentBox, "RIGHT", -4, -2)
F.ReskinDropDown(Point2dropDown)

Point2dropDown.name = T.createtext(Point2dropDown, "OVERLAY", 12, "OUTLINE", "LEFT")
Point2dropDown.name:SetPoint("BOTTOMLEFT", Point2dropDown, "TOPLEFT", 15, 5)
Point2dropDown.name:SetText(G.classcolor.."Point2|r")

UIDropDownMenu_SetWidth(Point2dropDown, 100)
UIDropDownMenu_SetText(Point2dropDown, "")

UIDropDownMenu_Initialize(Point2dropDown, function(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	for i = 1, #anchors do
		info.text = anchors[i]
		info.checked = function()
			if CurrentFrame ~= "NONE" then
				return (aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]["a2"] == info.text)
			end
		end
		info.func = function(self)
			aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]["a2"] = anchors[i]
			T.PlaceFrame(CurrentFrame)
			UIDropDownMenu_SetSelectedName(Point2dropDown, anchors[i], true)
			UIDropDownMenu_SetText(Point2dropDown, anchors[i])
		end
		UIDropDownMenu_AddButton(info)
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
	local points = aCoreCDB["FramePoints"][CurrentFrame][CurrentRole]
	UIDropDownMenu_SetText(Point1dropDown, points.a1)
	ParentBox:SetText(points.parent)
	UIDropDownMenu_SetText(Point2dropDown, points.a2)
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

		aCoreCDB["FramePoints"][CurrentFrame][CurrentRole].a1 = frame["point"][CurrentRole].a1
		aCoreCDB["FramePoints"][CurrentFrame][CurrentRole].parent = frame["point"][CurrentRole].parent
		aCoreCDB["FramePoints"][CurrentFrame][CurrentRole].a2 = frame["point"][CurrentRole].a2
		aCoreCDB["FramePoints"][CurrentFrame][CurrentRole].x = frame["point"][CurrentRole].x
		aCoreCDB["FramePoints"][CurrentFrame][CurrentRole].y = frame["point"][CurrentRole].y

		T.PlaceFrame(CurrentFrame)
		DisplayCurrentFramePoint()
	end
end)

-- lock
local LockButton = CreateFrame("Button", G.uiname.."SpecMoverLockButton", SpecMover, "UIPanelButtonTemplate")
LockButton:SetPoint("LEFT", ResetButton, "RIGHT", 10, 0)
LockButton:SetSize(250, 25)
LockButton:SetText(L["锁定框体"])
F.Reskin(LockButton)
LockButton:SetScript("OnClick", function()
	T.LockAll()
end)
------------------
--     API      --
------------------
local function GetDefaultPositions(frame)
	local name = frame:GetName()
	
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

T.CreateDragFrame = function(frame)
	local name = frame:GetName()	
	table.insert(G.dragFrameList, frame) --add frame object to the list
	
	frame.df = CreateFrame("Frame", name.."DragFrame", UIParent)
	frame.df:SetMovable(true)
	frame.df:SetFrameStrata("HIGH")
	frame.df:EnableMouse(true)
	frame.df:RegisterForDrag("LeftButton")
	frame.df:SetClampedToScreen(true)
	
	frame.df:SetScript("OnShow", function(self, event)		
		frame.df:SetSize(frame:GetWidth(), frame:GetHeight())
		local points = aCoreCDB["FramePoints"][name][CurrentRole]
		frame.df:ClearAllPoints()
		frame.df:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	end)
	
	frame.df:SetScript("OnDragStart", function(self)	
		frame.df:StartMoving()
	end)
	
	frame.df:SetScript("OnDragStop", function(self)
		local x, y = GetCursorPosition() -- 结束的位置
		local x1, y1 = ("%d"):format((x - self.x)*GetScreenWidth()/1364.8), ("%d"):format((y -self.y)*GetScreenHeight()/780) -- 计算偏移量
		aCoreCDB["FramePoints"][name][CurrentRole].x = aCoreCDB["FramePoints"][name][CurrentRole].x + x1
		aCoreCDB["FramePoints"][name][CurrentRole].y = aCoreCDB["FramePoints"][name][CurrentRole].y + y1
		T.PlaceFrame(CurrentFrame) -- 重新连接到锚点
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
		if CurrentFrame == "NONE" then
			UIDropDownMenu_EnableDropDown(Point1dropDown)
			UIDropDownMenu_EnableDropDown(Point2dropDown)
			ParentBox:Enable()
			XBox:Enable()
			YBox:Enable()
		end
		CurrentFrame = name
		SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..gsub(frame.movingname, "\n", "").."|r")
		DisplayCurrentFramePoint()
		
		for i = 1, #G.dragFrameList do
			if G.dragFrameList[i]:GetName() == name then
				G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 1, 1)
			else
				G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end)
end

T.PlaceFrame = function(name, force)
	local frame = _G[name]	
	if not frame then return end
	
	GetDefaultPositions(frame)
	local role = CurrentRole or T.CheckRole()
	local points = aCoreCDB["FramePoints"][name][role]
	
	if force then 
		frame.moving_locked = false
	end
	
	if frame.moving_locked then
		return
	end
	
	frame:ClearAllPoints()
	frame:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	
	if name == "Altz_HealerRaid_Holder" then
		T.PlaceRaidFrame()
	end
	
	frame.df:ClearAllPoints() -- 拖动框重新连接到锚点
	frame.df:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
end

T.ReleaseFrame = function(name)
	local frame = _G[name]
	frame.moving_locked = true
	frame:ClearAllPoints()
end

T.UnlockAll = function()
	if not InCombatLockdown() then
		if CurrentFrame ~= "NONE" then
			SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..gsub(_G[CurrentFrame].movingname, "\n", "").."|r")
		else
			SpecMover.curframe:SetText(L["选中的框体"].." "..G.classcolor..CurrentFrame.."|r")
		end
		for i = 1, #G.dragFrameList do
			if not G.dragFrameList[i].moving_locked then 
				G.dragFrameList[i].df:Show()
			end
		end
		SpecMover:Show()
	else
		SpecMover:RegisterEvent("PLAYER_REGEN_ENABLED")
		print(G.classcolor..L["进入战斗锁定"].."|r")
	end
end

T.LockAll = function()
	-- reset
	CurrentFrame = "NONE"
	UIDropDownMenu_SetText(Point1dropDown, "")
	UIDropDownMenu_SetText(Point2dropDown, "")
	UIDropDownMenu_DisableDropDown(Point1dropDown)
	UIDropDownMenu_DisableDropDown(Point2dropDown)
	ParentBox:Disable()
	XBox:Disable()
	YBox:Disable()

	for i = 1, #G.dragFrameList do
		G.dragFrameList[i].df.mask:SetBackdropBorderColor(0, 0, 0)
		G.dragFrameList[i].df:Hide()
	end
	SpecMover:Hide()
end

T.OnSpecChanged = function(event)
	CurrentRole = T.CheckRole()
	SpecMover.curmode:SetText(L["当前模式"].." "..L[CurrentRole])
	
	for i = 1, #G.dragFrameList do
		local name = G.dragFrameList[i]:GetName()
		
		if not aCoreCDB["FramePoints"][name] then
			GetDefaultPositions(G.dragFrameList[i])
		end
		
		if aCoreCDB and name and CurrentRole and aCoreCDB["FramePoints"][name] and aCoreCDB["FramePoints"][name][CurrentRole] then
			local points = aCoreCDB["FramePoints"][name][CurrentRole]
			
			if not G.dragFrameList[i].moving_locked then
				if event == "PLAYER_SPECIALIZATION_CHANGED" then
					G.dragFrameList[i]:ClearAllPoints()
				end
				G.dragFrameList[i]:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
			end
			--print(">", i, name, "OK")
		else
			--print(i, name, aCoreCDB["FramePoints"][name])
		end
	end
end

SpecMover:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
		T.OnSpecChanged(event)
	elseif event == "PLAYER_REGEN_DISABLED" then
		if SpecMover:IsShown() then
			T.LockAll()
			print(G.classcolor..L["进入战斗锁定"].."|r")
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		T.UnlockAll()
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	elseif event == "PLAYER_LOGIN" then
		T.OnSpecChanged(event)
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end)
SpecMover:RegisterEvent("PLAYER_LOGIN")
