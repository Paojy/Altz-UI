local T, C, L, G = unpack(select(2, ...))

G.dragFrameList = {}

local EMF = EditModeManagerFrame
local CurrentRole = "NONE"

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

local EditModeSystemSelectionLayout = {
	["TopRightCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, x=8, y=8 },
	["TopLeftCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, x=-8, y=8 },
	["BottomLeftCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, x=-8, y=-8 },
	["BottomRightCorner"] = { atlas = "%s-NineSlice-Corner",  mirrorLayout = true, x=8, y=-8 },
	["TopEdge"] = { atlas = "_%s-NineSlice-EdgeTop" },
	["BottomEdge"] = { atlas = "_%s-NineSlice-EdgeBottom" },
	["LeftEdge"] = { atlas = "!%s-NineSlice-EdgeLeft" },
	["RightEdge"] = { atlas = "!%s-NineSlice-EdgeRight" },
	["Center"] = { atlas = "%s-NineSlice-Center", x = -8, y = 8, x1 = 8, y1 = -8, },
}

local function GetAnchorName(anchor)
	for i, info in pairs(anchors) do
		if info[1] == anchor then
			return info[2]
		end
	end
end

function EMF.AccountSettings:RefreshPartyFrames()
	local showPartyFrames = self.settingsCheckButtons.PartyFrames:IsControlChecked()
	if not aCoreCDB["UnitframeOptions"]["raidframe_inparty"] then
		for i, uf in pairs(G.partyframes) do
			if showPartyFrames then
				T.RestoreDragFrame(uf)
			else
				T.ReleaseDragFrame(uf)	
			end
		end
		if aCoreCDB["UnitframeOptions"]["showpartypet"] then
			for i, uf in pairs(G.partypetframes) do
				if showPartyFrames then
					T.RestoreDragFrame(uf)
				else
					T.ReleaseDragFrame(uf)	
				end
			end
		end
	else
		if showPartyFrames then
			PartyFrame:HighlightSystem()
			PartyFrame:Raise()
		else
			PartyFrame:ClearHighlight()
		end
	
		CompactPartyFrame:RefreshMembers()
		UpdateRaidAndPartyFrames()
	end
end

function EMF.AccountSettings:RefreshRaidFrames()
	local showRaidFrames = self.settingsCheckButtons.RaidFrames:IsControlChecked()
	if aCoreCDB["UnitframeOptions"]["enableraid"] then
		if showRaidFrames then
			T.RestoreDragFrame(G.RaidFrame)
		else
			T.ReleaseDragFrame(G.RaidFrame)	
		end
		if aCoreCDB["UnitframeOptions"]["showraidpet"] then
			if showRaidFrames then
				T.RestoreDragFrame(G.RaidPetFrame)
			else
				T.ReleaseDragFrame(G.RaidPetFrame)	
			end
		end
	else
		if showRaidFrames then
			CompactRaidFrameManager_SetSetting("IsShown", true)
			CompactRaidFrameContainer:HighlightSystem()
		else
			CompactRaidFrameContainer:ClearHighlight()
		end
		CompactRaidFrameContainer:ApplyToFrames("group", CompactRaidGroup_UpdateUnits)
		CompactRaidFrameContainer:TryUpdate()
		EditModeManagerFrame:UpdateRaidContainerFlow()
		UpdateRaidAndPartyFrames()
	end
end

function EMF.AccountSettings:RefreshBossFrames()
	local showBossFrames = self.settingsCheckButtons.BossFrames:IsControlChecked()
	if aCoreCDB["UnitframeOptions"]["bossframes"] then
		for i, uf in pairs(G.bossframes) do
			if showBossFrames then
				T.RestoreDragFrame(uf)
			else
				T.ReleaseDragFrame(uf)	
			end
		end
	else
		if showBossFrames then
			BossTargetFrameContainer.isInEditMode = true
			BossTargetFrameContainer:HighlightSystem()
		else
			BossTargetFrameContainer.isInEditMode = false
			BossTargetFrameContainer:ClearHighlight()
		end
	
		BossTargetFrameContainer:UpdateShownState()
	end
end

function EMF.AccountSettings:RefreshArenaFrames()
	local showArenaFrames = self.settingsCheckButtons.ArenaFrames:IsControlChecked()
	if aCoreCDB["UnitframeOptions"]["arenaframes"] then
		for i, uf in pairs(G.arenaframes) do
			if showArenaFrames then
				T.RestoreDragFrame(uf)
			else
				T.ReleaseDragFrame(uf)	
			end
		end
	else
		CompactArenaFrame:SetIsInEditMode(showArenaFrames)
	end
end

function EMF.AccountSettings:RefreshPetFrame()
	local showPetFrame = self.settingsCheckButtons.PetFrame:IsControlChecked()	
	if showPetFrame then
		T.RestoreDragFrame(G.petframe)
	else
		T.ReleaseDragFrame(G.petframe)	
	end
end

function EMF.AccountSettings:RefreshCastBar()
	local showCastBar = self.settingsCheckButtons.CastBar:IsControlChecked()
	if aCoreCDB["UnitframeOptions"]["independentcb"] then
		local oUF = AltzUF or oUF
		for _, obj in next, oUF.objects do
			if obj.Castbar and obj.unit and T.multicheck(obj.unit, "target", "player", "focus") then
				if showCastBar then
					T.RestoreDragFrame(obj.Castbar)
				else
					T.ReleaseDragFrame(obj.Castbar)	
				end
			end
		end
	end
end

function EMF.AccountSettings:RefreshStatusTrackingBar2()
	local showStatusTrackingBar2 = self.settingsCheckButtons.StatusTrackingBar2:IsControlChecked()
	if aCoreCDB["SkinOptions"]["infobar"] then
		if showStatusTrackingBar2 then
			T.RestoreDragFrame(G.InfoFrame)
		else
			T.ReleaseDragFrame(G.InfoFrame)	
		end
	end
end
--====================================================--
--[[                   -- API --                    ]]--
--====================================================--
local SpecMover

local GetSelected = function()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		if frame.df.selected then
			return frame
		end
	end
end

local RemoveSelected = function()
	for i = 1, #G.dragFrameList do
		local df = G.dragFrameList[i].df
		df.selected = false
		NineSliceUtil.ApplyLayout(df, EditModeSystemSelectionLayout, "editmode-actionbar-highlight")
		df.Label:Hide()
	end
	SpecMover:Hide()
end

local GetDefaultPositions = function(frame, name)
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

local DisplayFramePoint = function(frame, name)	
	SpecMover.Title:SetText(T.color_text(frame.movingname))
	
	local points = aCoreCDB["FramePoints"][name][CurrentRole]
	UIDropDownMenu_SetSelectedValue(SpecMover.a1box, points.a1)
	UIDropDownMenu_SetText(SpecMover.a1box, GetAnchorName(points.a1))
	SpecMover.parentbox:SetText(points.parent)
	UIDropDownMenu_SetSelectedValue(SpecMover.a2box, points.a2)
	UIDropDownMenu_SetText(SpecMover.a2box, GetAnchorName(points.a2))
	SpecMover.xbox:SetText(points.x)
	SpecMover.ybox:SetText(points.y)
	
	SpecMover:ClearAllPoints()
	SpecMover:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -250, 200)
	SpecMover:Show()
end

local UnlockAll = function()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		if frame.df.enable then
			frame.df:Show()
		end		
	end
end

local LockAll = function()
	RemoveSelected()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]	
		frame.df:Hide()
	end
end

local PlaceFrame = function(frame)
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
	CurrentRole = T.CheckRole()
	SpecMover.curmode:SetText(L["当前模式"].." "..L[CurrentRole])	
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		PlaceFrame(frame)
	end
end

local ResetFramePoint = function(frame)
	local name = frame:GetName()	
	aCoreCDB["FramePoints"][name] = nil
	PlaceFrame(frame)
end

local ResetAllFramesPoint = function()
	RemoveSelected()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		ResetFramePoint(frame)
	end
end
T.ResetAllFramesPoint = ResetAllFramesPoint

-- 创建移动框
T.CreateDragFrame = function(frame)
	local name = frame:GetName()
	
	table.insert(G.dragFrameList, frame) --add frame object to the list
	
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	
	frame.df = CreateFrame("Frame", name.."DragFrame", UIParent, "NineSliceCodeTemplate")
	frame.df:SetAllPoints(frame)
	frame.df:SetFrameStrata("HIGH")
	frame.df:EnableMouse(true)
	frame.df:RegisterForDrag("LeftButton")
	frame.df:SetClampedToScreen(true)
	frame.df.enable = true
	frame.df:Hide()
	
	frame.df.Label = T.createtext(frame.df, "OVERLAY", 20, "OUTLINE", "CENTER")
	frame.df.Label:SetAllPoints()
	frame.df.Label:SetText(frame.movingname)
	
	NineSliceUtil.ApplyLayout(frame.df, EditModeSystemSelectionLayout, "editmode-actionbar-highlight")
	frame.df.Label:Hide()
	frame.df.selected = false
	
	frame.df:SetScript("OnMouseDown", function(self)
		if not self.selected then
			EMF:ClearSelectedSystem()
			RemoveSelected()
			self.selected = true
			NineSliceUtil.ApplyLayout(self, EditModeSystemSelectionLayout, "editmode-actionbar-selected")
			frame.df.Label:Show()
			DisplayFramePoint(frame, name)
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
		DisplayFramePoint(frame, name)
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
		if EMF:IsShown() then
			frame.df:Show()
		end
	end
end

local function CreateInputBox(parent, points, name, value, numeric)
	local box = T.EditboxWithButton(parent, 133, points, name)
	box:ClearAllPoints()
	box:SetPoint(unpack(points))
	
	box.name:SetJustifyH("RIGHT")
	box.name:ClearAllPoints()
	box.name:SetPoint("RIGHT", box, "LEFT", -5, 0)
	
	box:SetScript("OnEscapePressed", function(self)
		local frame = GetSelected()
		if frame then
			local name = frame:GetName()
			self:SetText(aCoreCDB["FramePoints"][name][CurrentRole][value])
			self:ClearFocus()
		end
	end)
	
	if numeric then
		box:SetNumericFullRange(true)
	end
	
	box:SetScript("OnEnterPressed", function(self)
		local frame = GetSelected()
		if frame then
			local name = frame:GetName()
			local text = self:GetText()
			if numeric then
				aCoreCDB["FramePoints"][name][CurrentRole][value] = tonumber(text)
				PlaceFrame(frame)
			else
				aCoreCDB["FramePoints"][name][CurrentRole][value] = text
				PlaceFrame(frame)
			end
		end
		
		self.button:Hide()
		self:ClearFocus()
	end)
	
	return box
end

local function CreateDropDown(parent, points, name, value)
	local dd = CreateFrame("Frame", nil, SpecMover, "UIDropDownMenuTemplate")
	dd:SetPoint(unpack(points))
	
	T.ReskinDropDown(dd)
	
	dd.name = T.createtext(dd, "OVERLAY", 14, "OUTLINE", "RIGHT")
	dd.name:SetPoint("RIGHT", dd, "LEFT", 12, 2)
	dd.name:SetText(name)
	
	UIDropDownMenu_SetWidth(dd, 120)
	UIDropDownMenu_Initialize(dd, function(self, level, menuList)
		for i = 1, #anchors do
			local info = UIDropDownMenu_CreateInfo()
			info.value = anchors[i][1]
			info.text = anchors[i][2]
			info.checked = function()
				local frame = GetSelected()
				if frame then
					local name = frame:GetName()
					return (aCoreCDB["FramePoints"][name][CurrentRole][value] == info.value)
				end
			end
			info.func = function(self)
				local frame = GetSelected()
				if frame then
					local name = frame:GetName()
					aCoreCDB["FramePoints"][name][CurrentRole][value] = info.value
					PlaceFrame(frame)
					UIDropDownMenu_SetSelectedValue(dd, info.value)
					UIDropDownMenu_SetText(dd, info.text)
				end
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	
	return dd
end
--====================================================--
--[[                -- 移动控制面板 --              ]]--
--====================================================--
SpecMover = CreateFrame("Frame", G.uiname.."SpecMover", UIParent, "BackdropTemplate")
SpecMover:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -250, 220)
SpecMover:SetSize(370, 300)
SpecMover:SetFrameStrata("HIGH")
SpecMover:SetFrameLevel(30)
SpecMover:Hide()

SpecMover:RegisterForDrag("LeftButton")
SpecMover:SetScript("OnDragStart", function(self) self:StartMoving() end)
SpecMover:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
SpecMover:SetClampedToScreen(true)
SpecMover:SetMovable(true)
SpecMover:EnableMouse(true)
SpecMover:EnableKeyboard(true)

T.setStripBD(SpecMover)

SpecMover.close = CreateFrame("Button", nil, SpecMover, "UIPanelCloseButton")
SpecMover.close:SetPoint("TOPRIGHT", -5, -5)
T.ReskinClose(SpecMover.close)

SpecMover.close:SetScript("OnClick", RemoveSelected)

SpecMover.Title = T.createtext(SpecMover, "OVERLAY", 16, "OUTLINE", "LEFT")
SpecMover.Title:SetPoint("TOP", SpecMover, "TOP", 0, -15)

SpecMover.curmode = T.createtext(SpecMover, "OVERLAY", 14, "OUTLINE", "LEFT")
SpecMover.curmode:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 10, -50)

-- a1
SpecMover.a1box = CreateDropDown(SpecMover, {"TOPLEFT", SpecMover, "TOPLEFT", 80, -80}, L["锚点"].."1", "a1")

-- parent
SpecMover.parentbox = CreateInputBox(SpecMover, {"TOPLEFT", SpecMover.a1box, "BOTTOMLEFT", 17, -2}, L["锚点框体"], "parent")

-- a2
SpecMover.a2box = CreateDropDown(SpecMover, {"TOPLEFT", SpecMover.parentbox, "BOTTOMLEFT", -17, -7}, L["锚点"].."2", "a2")

-- x
SpecMover.xbox = CreateInputBox(SpecMover, {"TOPLEFT", SpecMover.a2box, "BOTTOMLEFT", 17, -2}, "X", "x", true)

-- y
SpecMover.ybox = CreateInputBox(SpecMover, {"TOPLEFT", SpecMover.xbox, "BOTTOMLEFT", 0, -12}, "Y", "y", true)

-- reset
SpecMover.ResetButton = CreateFrame("Button", G.uiname.."SpecMoverResetButton", SpecMover, "UIPanelButtonTemplate")
SpecMover.ResetButton:SetPoint("BOTTOM", SpecMover, "BOTTOM", 0, 10)
SpecMover.ResetButton:SetSize(190, 25)
SpecMover.ResetButton:SetText(HUD_EDIT_MODE_RESET_POSITION)
T.ReskinButton(SpecMover.ResetButton)
SpecMover.ResetButton:SetScript("OnClick", function()
	local frame = GetSelected()
	if frame then
		ResetFramePoint(frame)
		DisplayFramePoint(frame, frame:GetName())
	end
end)

SpecMover:SetScript("OnKeyDown", function(self, key)
	if key == "ESCAPE" then
		RemoveSelected()
	end
end)

SpecMover:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
		PlaceAllFrames()
	elseif event == "PLAYER_LOGIN" then
		PlaceAllFrames()
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
end)

SpecMover:RegisterEvent("PLAYER_LOGIN")

EMF:HookScript("OnShow", function()
	UnlockAll()
end)

EMF:HookScript("OnHide", function()
	LockAll()
end)

EditModeSystemSettingsDialog:HookScript("OnShow", function()
	RemoveSelected()
end)