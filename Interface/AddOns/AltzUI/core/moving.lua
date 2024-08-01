local T, C, L, G = unpack(select(2, ...))

-- 开关编辑模式后+占用

G.dragFrameList = {}

local CurrentRole = "NONE"
local SpecMover

local anchors = {
	{"CENTER", L["中间"]},
	{"LEFT", L["左"]},
	{"RIGHT", L["右"]},
	{"TOP", L["上方"]},
	{"BOTTOM", L["下方"]},
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

local function GetMouseOver()
	local mouseFoci = GetMouseFoci()
	for _, mouseFocus in ipairs(mouseFoci) do
		if mouseFocus then
			return mouseFocus
		end
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
	
			local focus = GetMouseOver()
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
local GetSelected = function()
	for i = 1, #G.dragFrameList do
		local frame = G.dragFrameList[i]
		if frame.df.isSelected then
			return frame, frame:GetName()
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

local DisplayFramePoint = function(name)
	local points = T.ValueFromPath(aCoreCDB, {"FramePoints", name, CurrentRole})
	T.UIDropDownMenu_SetSelectedValueText(SpecMover.a1dd, anchors, points.a1)
	T.UIDropDownMenu_SetSelectedValueText(SpecMover.anchor_typedd, anchor_types, points.anchor_type)
	SpecMover.parentbox.box:SetText(points.parent)
	T.UIDropDownMenu_SetSelectedValueText(SpecMover.a2dd, anchors, points.a2)
	SpecMover.xbox.box:SetText(points.x)
	SpecMover.ybox.box:SetText(points.y)
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
			
			SpecMover.Title:SetText(frame.movingname)
			SpecMover:ClearAllPoints()
			SpecMover:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -250, 200)
			SpecMover:Show()
			
			DisplayFramePoint(name)
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
		DisplayFramePoint(name)
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

local EM_options_info = {
	{tag = "a1dd", option_type = "dd", text = L["锚点"].."1", key = "a1", option_table = anchors},
	{tag = "anchor_typedd", option_type = "dd", text = L["对齐到"], key = "anchor_type", option_table = anchor_types},
	{tag = "parentbox", option_type = "box", text = L["锚点框体"], key = "parent"},
	{tag = "a2dd", option_type = "dd", text = L["锚点"].."2", key = "a2", option_table = anchors},
	{tag = "xbox", option_type = "box", text = "X", key = "x", numeric = true},
	{tag = "ybox", option_type = "box", text = "Y", key = "y", numeric = true},
}

for OptionCategroy, t in pairs(G.Options) do
	for i, info in pairs(t) do
		if info.relatedFrames and (not info.class or info.class[G.myClass]) then
			table.insert(EM_options_info, {tag = info.key, option_type = info.option_type, path = {OptionCategroy, info.key}, rely = info.rely})
		end
	end
end

local function CreateInputBox(parent, name, key, numeric)
	local anchor = T.EditFrame(parent, 190, name)
	
	anchor.box:SetScript("OnEscapePressed", function(self)
		local frame, name = GetSelected()
		self:SetText(T.ValueFromPath(aCoreCDB, {"FramePoints", name, CurrentRole, key}))
		self:ClearFocus()
	end)
	
	if numeric then
		anchor.box:SetNumericFullRange(true)
	end
	
	anchor.box:SetScript("OnEnterPressed", function(self)
		local frame, name = GetSelected()
		local text = self:GetText()
		T.ValueToPath(aCoreCDB, {"FramePoints", name, CurrentRole, key}, numeric and tonumber(text) or text)
		PlaceFrame(frame)
		
		self.button:Hide()
		self:ClearFocus()
	end)
	
	return anchor
end

local function CreateDropDown(parent, name, key, option_table)
	local anchor = T.UIDropDownMenuFrame(SpecMover, "long", name)
	
	local function DD_UpdateChecked(self, value)
		local frame, name = GetSelected()
		return (T.ValueFromPath(aCoreCDB, {"FramePoints", name, CurrentRole, key}) == value)
	end
	
	local function DD_SetChecked(self, value)
		local frame, name = GetSelected()
		T.ValueToPath(aCoreCDB, {"FramePoints", name, CurrentRole, key}, value)
		T.UIDropDownMenu_SetSelectedValueText(anchor, option_table, value)
		if key == "anchor_type" then
			SpecMover:ArrangeOptions()
		end
		PlaceFrame(frame)
	end
	
	UIDropDownMenu_Initialize(anchor.DropDown, function(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for i = 1, #option_table do
			info.value = option_table[i][1]
			info.arg1 = option_table[i][1]
			info.text = option_table[i][2]
			info.checked = DD_UpdateChecked
			info.func = DD_SetChecked
			UIDropDownMenu_AddButton(info)
		end
	end)
	
	return anchor
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
SpecMover.curmode:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 20, -50)

function SpecMover:ArrangeOptions()
	local index = 0
	for i, info in pairs(EM_options_info) do
		if not SpecMover[info.tag] then
			if info.option_type == "dd" then
				SpecMover[info.tag] = CreateDropDown(SpecMover, info.text, info.key, info.option_table)	
			elseif info.option_type == "box" then
				SpecMover[info.tag] = CreateInputBox(SpecMover, info.text, info.key, info.numeric)
			elseif info.option_type == "check" then
				SpecMover[info.tag] = T.Checkbutton_DB(SpecMover, info.path)
			elseif info.option_type == "slider" then
				SpecMover[info.tag] = T.Slider_DB(SpecMover, "long", info.path)
			elseif info.option_type == "ddmenu" then
				SpecMover[info.tag] = T.UIDropDownMenuFrame_DB(SpecMover, "long", info.path)
			end
		end
		
		local option = SpecMover[info.tag]
		
		if info.rely and SpecMover[info.rely] then
			T.createDR(SpecMover[info.rely], option)
		end
		
		option:Hide()
		
		if info.tag == "parentbox" then
			if not option.frameselect_button then
				option.frameselect_button = T.ClickTexButton(option, {"LEFT", option.box, "RIGHT", 0, 0}, G.iconFile.."search.tga", nil, 20, T.split_words(CHOOSE,L["锚点框体"]))		
				option.frameselect_button:SetScript("OnClick", function(self)	
					local frame, name = GetSelected()
					if frame then
						local value = aCoreCDB["FramePoints"][name][CurrentRole]["parent"]
						if not FrameChooseInProgress then
							StartFrameChooser(option.box, name, value)
						else
							StopFrameChooser(option.box, value)
						end
					end
				end)
				option.frameselect_button:HookScript("OnHide", StopFrameChooser)
			end
			
			local frame, name = GetSelected()
			if T.ValueFromPath(aCoreCDB, {"FramePoints", name, CurrentRole, "anchor_type"}) == "ChooseFrame" then	
				option:Show()
			end
		elseif not info.path then
			option:Show()
		else
			local option_info = T.GetOptionInfo(info.path)
			for name in pairs(option_info.relatedFrames) do
				local frame = _G[name]
				if frame and frame.df.isSelected then
					option:Show()
					break
				end
			end
		end

		local adjust = info.path and -20 or 0
		if option:IsVisible() then
			index = index + 1
			if info.option_type == "dd" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 120, -50-index*30+adjust)
			elseif info.option_type == "box" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 20, -50-index*30+adjust)
			elseif info.option_type == "check" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 20, -57-index*30+adjust)
			elseif info.option_type == "slider" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 120, -50-index*30+adjust)
			elseif info.option_type == "ddmenu" then
				option:SetPoint("TOPLEFT", SpecMover, "TOPLEFT", 120, -50-index*30+adjust)
			end
		end
	end
	
	SpecMover:SetHeight(180+index*30)
end

SpecMover:SetScript("OnShow", function(self)
	self:ArrangeOptions()
end)

-- reset
SpecMover.ResetButton = T.ClickButton(SpecMover, 340, nil, {"BOTTOM", SpecMover, "BOTTOM", 0, 10}, HUD_EDIT_MODE_RESET_POSITION)
SpecMover.ResetButton:SetScript("OnClick", function()
	local frame, name = GetSelected()
	ResetFramePoint(frame)
	DisplayFramePoint(name)
end)

-- key move
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
	
	local frame, name = GetSelected()

	frame:StopMovingOrSizing()
	aCoreCDB["FramePoints"][name][CurrentRole].x = aCoreCDB["FramePoints"][name][CurrentRole].x + xDelta
	aCoreCDB["FramePoints"][name][CurrentRole].y = aCoreCDB["FramePoints"][name][CurrentRole].y + yDelta
	
	PlaceFrame(frame) -- 重新连接到锚点	
	DisplayFramePoint(name)	
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

-- event
SpecMover:RegisterEvent("PLAYER_LOGIN")
SpecMover:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 == "player" then
		PlaceAllFrames()
	elseif event == "PLAYER_LOGIN" then
		PlaceAllFrames()
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
end)

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
	if aCoreCDB["UnitframeOptions"]["cbstyle"] == "independent" then
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

