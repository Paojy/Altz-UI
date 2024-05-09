local T, C, L, G = unpack(select(2, ...))

-- 开关编辑模式后+占用

G.dragFrameList = {}

local CurrentRole = "NONE"
local SpecMover

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

local anchor_types = {
	{"Screen", L["屏幕"]},
	{"ChooseFrame", T.split_words(CHOOSE,L["锚点框体"])},
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

--====================================================--
--[[               -- Frame Chooser --              ]]--
--====================================================--
local FrameChooseInProgress
local frameChooserFrame = CreateFrame("Frame")
local frameChooserBox = CreateFrame("Frame", nil, frameChooserFrame, "BackdropTemplate")
frameChooserBox:SetFrameStrata("TOOLTIP")
frameChooserBox:SetBackdrop({
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 12,
	insets = {left = 0, right = 0, top = 0, bottom = 0}
})
frameChooserBox:SetBackdropBorderColor(0, 1, 0)
frameChooserBox:Hide()

local StopFrameChooser = function(editbox, parent)	
	FrameChooseInProgress = false
	
	frameChooserFrame:SetScript("OnUpdate", nil)
	frameChooserBox:Hide()
	ResetCursor()
	
	if editbox and parent then
		editbox:SetText(parent)
		editbox:GetScript("OnEnterPressed")(editbox)
	end
end

local StartFrameChooser = function(editbox, name, old_parent)
	FrameChooseInProgress = true

	local currentFocus, currentFocusName
	
	frameChooserFrame:SetScript("OnUpdate", function()
		if IsMouseButtonDown("LeftButton") and currentFocusName then
			StopFrameChooser(editbox, currentFocusName)
		elseif IsMouseButtonDown("RightButton") then
			StopFrameChooser(editbox, old_parent)
		else
			SetCursor("CAST_CURSOR")
	
			local focus = GetMouseFocus()
			local focusName
			
			if currentFocus ~= focus then
				if focus then
					if focus.anchor_parent then
						focusName = focus.anchor_parent:GetName()
						if focusName == name then -- 不能是自身
							focusName = nil
						end
					elseif focus.highlightTextureKit and focus.selectedTextureKit then
						focusName = focus.parent:GetName()
					else
						focusName = focus:GetName()
						if focusName == "WorldFrame" then -- 不能是屏幕
							focusName = nil
						end
					end
				end
				
				if focusName then
					if focusName ~= currentFocusName then
						frameChooserBox:ClearAllPoints()
						frameChooserBox:SetPoint("bottomleft", focus, "bottomleft", -4, -4)
						frameChooserBox:SetPoint("topright", focus, "topright", 4, 4)
						frameChooserBox:Show()
						editbox:SetText(focusName)
						currentFocusName = focusName
					end
				else
					frameChooserBox:Hide()
					editbox:SetText("")
					currentFocusName = nil
				end
				
				currentFocus = focus
			end
		end
	end)

	editbox.button:Hide()
	editbox:ClearFocus()
end

--====================================================--
--[[                   -- API --                    ]]--
--====================================================--
local UIDropDownMenu_SetSelectedValueText = function(dd, t, value)
	UIDropDownMenu_SetSelectedValue(dd, value)
	for i, info in pairs(t) do
		if info[1] == value then
			UIDropDownMenu_SetText(dd, info[2])
			break
		end
	end
end

local GetSelected = function()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		if frame.df.isSelected then
			return frame
		end
	end
end

local RemoveSelected = function()
	for i = 1, #G.dragFrameList do
		local df = G.dragFrameList[i].df
		df.isSelected = false
		NineSliceUtil.ApplyLayout(df, EditModeSystemSelectionLayout, "editmode-actionbar-highlight")
		df.Label:Hide()
	end
	SpecMover:Hide()
end

local GetDefaultPositions = function(frame, name)
	if aCoreCDB["FramePoints"][name] == nil then
		aCoreCDB["FramePoints"][name] = {}
		for role, info in pairs(frame.point) do
			if aCoreCDB["FramePoints"][name][role] == nil then
				aCoreCDB["FramePoints"][name][role] = {}
			end
			if aCoreCDB["FramePoints"][name][role]["a1"] == nil then
				aCoreCDB["FramePoints"][name][role]["a1"] = info.a1
			end
			if aCoreCDB["FramePoints"][name][role]["a2"] == nil then
				aCoreCDB["FramePoints"][name][role]["a2"] = info.a2
			end
			if aCoreCDB["FramePoints"][name][role]["anchor_type"] == nil then
				aCoreCDB["FramePoints"][name][role]["anchor_type"] = info.anchor_type
			end
			if aCoreCDB["FramePoints"][name][role]["parent"] == nil then
				aCoreCDB["FramePoints"][name][role]["parent"] = info.parent
			end
			if aCoreCDB["FramePoints"][name][role]["x"] == nil then
				aCoreCDB["FramePoints"][name][role]["x"] = info.x
			end
			if aCoreCDB["FramePoints"][name][role]["y"] == nil then
				aCoreCDB["FramePoints"][name][role]["y"] = info.y
			end
		end
	end
end

local DisplayFramePoint = function(frame, name)	
	SpecMover.Title:SetText(T.color_text(frame.movingname))
	
	local points = aCoreCDB["FramePoints"][name][CurrentRole]
	UIDropDownMenu_SetSelectedValueText(SpecMover.a1dd, anchors, points.a1)
	UIDropDownMenu_SetSelectedValueText(SpecMover.anchor_type, anchor_types, points.anchor_type)
	SpecMover.parentbox:SetText(points.parent)
	UIDropDownMenu_SetSelectedValueText(SpecMover.a2dd, anchors, points.a2)
	SpecMover.xbox:SetText(points.x)
	SpecMover.ybox:SetText(points.y)
	
	if points.anchor_type == "Screen" then
		SpecMover.parentbox:Hide()
	else
		SpecMover.parentbox:Show()
	end
	
	SpecMover.ArrangeOptions()
	
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
	GetDefaultPositions(frame, name)
	local points = aCoreCDB["FramePoints"][name][CurrentRole]
	if points and frame.df.enable then
		frame:ClearAllPoints()
		if points.anchor_type == "Screen" then
			frame:SetPoint(points.a1, UIParent, points.a2, points.x, points.y)
		else
			frame:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
		end
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
	
	for role, info in pairs(frame.point) do
		info.anchor_type = (info.parent == "UIParent") and "Screen" or "ChooseFrame"
	end	
	
	table.insert(G.dragFrameList, frame) --add frame object to the list
	
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	
	frame.df = CreateFrame("Frame", name.."DragFrame", UIParent, "NineSliceCodeTemplate")
	frame.df:SetAllPoints(frame)
	frame.df:SetFrameStrata("HIGH")
	frame.df:EnableMouse(true)
	frame.df:RegisterForDrag("LeftButton")
	frame.df:SetClampedToScreen(true)
	frame.df:Hide()
	
	frame.df.Label = T.createtext(frame.df, "OVERLAY", 20, "OUTLINE", "CENTER")
	frame.df.Label:SetAllPoints()
	frame.df.Label:SetText(frame.movingname)
	frame.df.Label:Hide()
	
	NineSliceUtil.ApplyLayout(frame.df, EditModeSystemSelectionLayout, "editmode-actionbar-highlight")
	
	frame.df.enable = true
	frame.df.isSelected = false
	frame.df.anchor_parent = frame
	
	frame.df:SetScript("OnMouseDown", function(self)
		if not FrameChooseInProgress and not self.isSelected then
			EditModeManagerFrame:ClearSelectedSystem()
			RemoveSelected()
			self.isSelected = true
			
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
		if EditModeManagerFrame:IsShown() then
			frame.df:Show()
		end
	end
end

--====================================================--
--[[                -- 移动控制面板 --              ]]--
--====================================================--

local function CreateInputBox(parent, name, value, numeric)
	local box = T.EditboxWithButton(parent, 193, points, name)
	box:ClearAllPoints()
	
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

local function CreateDropDown(parent, name, value, option_table)
	local dd = CreateFrame("Frame", nil, SpecMover, "UIDropDownMenuTemplate")
	
	T.ReskinDropDown(dd)
	
	dd.name = T.createtext(dd, "OVERLAY", 14, "OUTLINE", "RIGHT")
	dd.name:SetPoint("RIGHT", dd, "LEFT", 12, 2)
	dd.name:SetText(name)
	
	UIDropDownMenu_SetWidth(dd, 180)
	UIDropDownMenu_Initialize(dd, function(self, level)
		for i = 1, #option_table do
			local info = UIDropDownMenu_CreateInfo()
			info.value = option_table[i][1]
			info.text = option_table[i][2]
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
					DisplayFramePoint(frame, name)
				end
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	
	return dd
end

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

SpecMover.options_info = {
	{tag = "a1dd", option_type = "dd", text = L["锚点"].."1", key = "a1", option_table = anchors},
	{tag = "anchor_type", option_type = "dd", text = L["对齐到"], key = "anchor_type", option_table = anchor_types},
	{tag = "parentbox", option_type = "box", text = L["锚点框体"], key = "parent"},
	{tag = "a2dd", option_type = "dd", text = L["锚点"].."2", key = "a2", option_table = anchors},
	{tag = "xbox", option_type = "box", text = "X", key = "x", numeric = true},
	{tag = "ybox", option_type = "box", text = "Y", key = "y", numeric = true},
}

for i, info in pairs(SpecMover.options_info) do
	if info.option_type == "dd" then
		SpecMover[info.tag] = CreateDropDown(SpecMover, info.text, info.key, info.option_table)
	elseif info.option_type == "box" then
		SpecMover[info.tag] = CreateInputBox(SpecMover, info.text, info.key, info.numeric)
	end
end

SpecMover.ArrangeOptions = function()
	local index = 1
	for i, info in pairs(SpecMover.options_info) do
		local option = SpecMover[info.tag]
		if option:IsVisible() then
			option:ClearAllPoints()
			if info.option_type == "dd" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 80, -50-index*30+3)
			elseif info.option_type == "box" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 97, -50-index*30)
			end
			index = index + 1
		end
	end
end

SpecMover.parentbox.frameselect_button = T.ClickTexButton(SpecMover.parentbox, {"LEFT", SpecMover.parentbox, "RIGHT", 0, 0}, [[Interface\AddOns\AltzUI\media\icons\search.tga]], nil, 20, T.split_words(CHOOSE,L["锚点框体"]))		
SpecMover.parentbox.frameselect_button:SetScript("OnClick", function(self)	
	local frame = GetSelected()
	if frame then
		local name = frame:GetName()
		local value = aCoreCDB["FramePoints"][name][CurrentRole]["parent"]
		if not FrameChooseInProgress then
			StartFrameChooser(SpecMover.parentbox, name, value)
		else
			StopFrameChooser(SpecMover.parentbox, value)
		end
	end
end)
SpecMover.parentbox.frameselect_button:HookScript("OnHide", StopFrameChooser)

-- reset
SpecMover.ResetButton = T.ClickButton(SpecMover, 340, {"BOTTOM", SpecMover, "BOTTOM", 0, 10}, HUD_EDIT_MODE_RESET_POSITION)
SpecMover.ResetButton:SetScript("OnClick", function()
	local frame = GetSelected()
	if frame then
		ResetFramePoint(frame)
		DisplayFramePoint(frame, frame:GetName())
	end
end)

local function ProcessMovementKey(key)
	local deltaAmount = IsModifierKeyDown() and 10 or 1;
	local xDelta, yDelta = 0, 0
	
	if key == "UP" then
		yDelta = deltaAmount
	elseif key == "DOWN" then
		yDelta = -deltaAmount
	elseif key == "LEFT" then
		xDelta = -deltaAmount
	elseif key == "RIGHT" then
		xDelta = deltaAmount
	end
	
	local frame = GetSelected()
	local name = frame:GetName()
	
	frame:StopMovingOrSizing()
	aCoreCDB["FramePoints"][name][CurrentRole].x = aCoreCDB["FramePoints"][name][CurrentRole].x + xDelta
	aCoreCDB["FramePoints"][name][CurrentRole].y = aCoreCDB["FramePoints"][name][CurrentRole].y + yDelta
	
	PlaceFrame(frame) -- 重新连接到锚点	
	DisplayFramePoint(frame, name)	
end

local movementKeys = {
	UP = true,
	DOWN = true,
	LEFT = true,
	RIGHT = true,
}

SpecMover:SetScript("OnKeyDown", function(self, key)
	if key == "ESCAPE" then
		RemoveSelected()
	elseif movementKeys[key] then
		ProcessMovementKey(key)
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

SpecMover:SetScript("OnShow", SpecMover.ArrangeOptions)
--====================================================--
--[[            -- Edit Mode Settings --            ]]--
--====================================================--

function EditModeManagerFrame.AccountSettings:RefreshPartyFrames()
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

function EditModeManagerFrame.AccountSettings:RefreshRaidFrames()
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

function EditModeManagerFrame.AccountSettings:RefreshBossFrames()
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

function EditModeManagerFrame.AccountSettings:RefreshArenaFrames()
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

function EditModeManagerFrame.AccountSettings:RefreshPetFrame()
	local showPetFrame = self.settingsCheckButtons.PetFrame:IsControlChecked()	
	if showPetFrame then
		T.RestoreDragFrame(G.petframe)
	else
		T.ReleaseDragFrame(G.petframe)	
	end
end

function EditModeManagerFrame.AccountSettings:RefreshCastBar()
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

function EditModeManagerFrame.AccountSettings:RefreshStatusTrackingBar2()
	local showStatusTrackingBar2 = self.settingsCheckButtons.StatusTrackingBar2:IsControlChecked()
	if aCoreCDB["SkinOptions"]["infobar"] then
		if showStatusTrackingBar2 then
			T.RestoreDragFrame(G.InfoFrame)
		else
			T.ReleaseDragFrame(G.InfoFrame)	
		end
	end
end

local frame_choose_hooked
EditModeManagerFrame:HookScript("OnShow", function()
	if not frame_choose_hooked then
		for _, system in pairs(EditModeManagerFrame.registeredSystemFrames) do		
			system.Selection:SetScript("OnMouseDown", function(self)
				if not FrameChooseInProgress then
					EditModeManagerFrame:SelectSystem(self.parent)
				end
			end)
		end
		frame_choose_hooked = true
	end
	UnlockAll()
end)

EditModeManagerFrame:HookScript("OnHide", LockAll)

EditModeSystemSettingsDialog:HookScript("OnShow", RemoveSelected)

