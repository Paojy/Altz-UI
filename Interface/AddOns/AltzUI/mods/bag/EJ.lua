local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- 装备筛选 --                 ]]--
--====================================================--

local stats = {
	{"NONE", STAT_CATEGORY_ENHANCEMENTS},
	{"CRITCHANCE", STAT_CRITICAL_STRIKE},
	{"HASTE", STAT_HASTE},
	{"MASTERY", STAT_MASTERY},
	{"VERSATILITY", STAT_VERSATILITY},
}

local item_stats = {
	["ITEM_MOD_CRIT_RATING_SHORT"] = "CRITCHANCE",
	["ITEM_MOD_HASTE_RATING_SHORT"] = "HASTE",
	["ITEM_MOD_MASTERY_RATING_SHORT"] = "MASTERY",
	["ITEM_MOD_VERSATILITY"] = "VERSATILITY",
}

local select_stat = "NONE"

local function SetStatFilter(stat)
	select_stat = stat
end

local function EncounterJournal_RefreshStatFilterText(self)
	local text = STAT_CATEGORY_ENHANCEMENTS
	if select_stat ~= "NONE" then
		for _, info in pairs(stats) do
			if ( info[1] == select_stat ) then
				text = info[2]
				break
			end
		end
	end

	EncounterJournal.encounter.info.LootContainer.StatsFilter:SetText(text)
end

local function EncounterJournal_SetStatFilter(self, stat)
	SetStatFilter(stat)
	EncounterJournal_RefreshStatFilterText(self)
	EncounterJournal_OnFilterChanged(self)
end

local function StatsFilter_Initialize(self, level)
	local info = UIDropDownMenu_CreateInfo()
	for i, stat_info in pairs(stats) do
		info.arg1 = stat_info[1]
		info.text = stat_info[2]
		info.checked = false
		info.func = EncounterJournal_SetStatFilter
		UIDropDownMenu_AddButton(info)
	end
end

local function FilterItemStat(stats)
	if select_stat == "NONE" then
		return true
	elseif stats then
		for key in pairs(stats) do
			if item_stats[key] == select_stat then
				return true
			end
		end
	end
end

local EJ_init = function()
	hooksecurefunc("EncounterJournal_LootUpdate", function()	
		local scrollBox = EncounterJournal.encounter.info.LootContainer.ScrollBox
	
		local dataProvider = CreateDataProvider()
		local loot = {}
		local perPlayerLoot = {}
		local veryRareLoot = {}
		local extremelyRareLoot = {}
	
		for i = 1, EJ_GetNumLoot() do
			local itemInfo = C_EncounterJournal.GetLootInfoByIndex(i)
			if itemInfo.link then
				local stats = GetItemStats(itemInfo.link)
				if FilterItemStat(stats) then
					if itemInfo.displayAsPerPlayerLoot then
						tinsert(perPlayerLoot, i)
					elseif itemInfo.displayAsExtremelyRare then
						tinsert(extremelyRareLoot, i)
					elseif itemInfo.displayAsVeryRare then
						tinsert(veryRareLoot, i)
					else
						tinsert(loot, i)
					end
				end
			else
				--print("stats filter bug:no link"..i)
			end
		end
	
		for _,val in ipairs(loot) do
			dataProvider:Insert({index=val})
		end
	
		local lootCategories = { 
			{ loot=veryRareLoot,		headerTitle=EJ_ITEM_CATEGORY_VERY_RARE },
			{ loot=extremelyRareLoot,	headerTitle=EJ_ITEM_CATEGORY_EXTREMELY_RARE },
			{ loot=perPlayerLoot,		headerTitle=BONUS_LOOT_TOOLTIP_TITLE,			helpText=BONUS_LOOT_TOOLTIP_BODY },
		};
	
		for _,category in ipairs(lootCategories) do
			if #category.loot > 0 then
				dataProvider:Insert({header=true, text=category.headerTitle, helpText=category.helpText})
				for _,val in ipairs(category.loot) do
					dataProvider:Insert({index=val})
				end
			end
		end
		
		scrollBox:SetDataProvider(dataProvider)
	end)
	
	EncounterJournal.encounter.info.difficulty:SetWidth(80)
	
	local parent = EncounterJournal.encounter.info.LootContainer
	parent.filter:SetWidth(80)
	
	parent.slotFilter:ClearAllPoints()
	parent.slotFilter:SetPoint("LEFT", parent.filter, "RIGHT", 0, 0)
	parent.slotFilter:SetWidth(80)
	
	local StatsFilter = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
	StatsFilter:SetWidth(80)
	StatsFilter:SetText(STAT_CATEGORY_ENHANCEMENTS)
	StatsFilter:SetPoint("LEFT", parent.slotFilter, "RIGHT", 0, 0)
	T.ReskinDropDown(StatsFilter)
	
	StatsFilter.DropDown = CreateFrame("Frame", nil, StatsFilter, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(StatsFilter.DropDown, StatsFilter_Initialize, "MENU")
	
	StatsFilter:SetScript("OnMouseDown", function(self)
		self.DropDown.point = "TOPLEFT"
		self.DropDown.relativePoint = "BOTTOMLEFT"
		ToggleDropDownMenu(1, nil, self.DropDown, self, 0, 5)	
	end)
	
	parent.StatsFilter = StatsFilter
end

--====================================================--
--[[                 -- 拾取设置 --                 ]]--
--====================================================--
local AddElements = function(frame)
	frame.bu = CreateFrame("Button", nil, frame)
	frame.bu:SetSize(30, 30)	
	frame.bu.bg = T.createTexBackdrop(frame.bu)
	
	frame.bu.tex = frame.bu:CreateTexture(nil, "OVERLAY")
	frame.bu.tex:SetAllPoints()
	frame.bu.tex:SetTexCoord(.1, .9, .1, .9)

	frame.toggle = CreateFrame("Button", nil, frame)	
	frame.toggle:SetSize(25, 25)	
	
	frame.toggle.tex = frame.toggle:CreateTexture(nil, "ARTWORK")
	frame.toggle.tex:SetAllPoints()
	frame.toggle.tex:SetTexture(G.textureFile.."arrow.tga")
	frame.toggle.tex:SetRotation(rad(-135))
	
	frame.bu:SetScript("OnEnter", function(self)	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, 0)
		GameTooltip:AddLine(self.tooltip)
		GameTooltip:Show()
		self.bg:SetVertexColor(unpack(G.addon_color))
	end)
	
	frame.bu:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		self.bg:SetVertexColor(0, 0, 0)
	end)
	
	frame.toggle:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, 0)
		GameTooltip:AddLine(SELECT_LOOT_SPECIALIZATION)
		GameTooltip:Show()
		self.tex:SetVertexColor(unpack(G.addon_color))
	end)
	
	frame.toggle:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		self.tex:SetVertexColor(1, 1, 1)
	end)
end

local CreateEncounterSpecFrame = function(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOPRIGHT")
	frame:SetPoint("BOTTOMRIGHT")
	frame:SetWidth(60)
	
	AddElements(frame)
	frame.bu:SetPoint("LEFT")
	frame.toggle:SetPoint("BOTTOMRIGHT", 7, -7)
	
	function frame:Update()
		if parent.encounterID and EJ_InstanceIsRaid() then
			local dungeonEncounterID = select(7, EJ_GetEncounterInfo(parent.encounterID))
			local cur_spec = T.ValueFromPath(aCoreCDB, {"ItemOptions", "specloot_encounters", dungeonEncounterID})		
			if cur_spec then
				local _, name, _, icon = GetSpecializationInfo(cur_spec)
				frame.bu.tex:SetTexture(icon)
				frame.bu.tooltip = SELECT_LOOT_SPECIALIZATION..":"..name
				frame.bu:Show()	
				frame.toggle:Hide()
			else			
				frame.bu:Hide()
				frame.toggle:Show()
			end
			frame:Show()
		else
			frame:Hide()
		end
	end
	
	frame.bu:SetScript("OnClick", function(self)
		local numspec = GetNumSpecializations()
		local dungeonEncounterID = select(7, EJ_GetEncounterInfo(parent.encounterID))
		local cur_spec = T.ValueFromPath(aCoreCDB, {"ItemOptions", "specloot_encounters", dungeonEncounterID})
		local new_spec
		if cur_spec == numspec then
			new_spec = nil
		else
			new_spec = cur_spec + 1			
		end
		T.ValueToPath(aCoreCDB, {"ItemOptions", "specloot_encounters", dungeonEncounterID}, new_spec)
		frame:Update()
		if new_spec then
			GameTooltip:Hide()
			frame.bu:GetScript("OnEnter")(frame.bu)
		end
	end)
	
	frame.toggle:SetScript("OnClick", function(self)
		local dungeonEncounterID = select(7, EJ_GetEncounterInfo(parent.encounterID))
		T.ValueToPath(aCoreCDB, {"ItemOptions", "specloot_encounters", dungeonEncounterID}, 1)
		frame:Update()
	end)
	
	parent.spec_frame = frame
end

local CreateInstanceSpecFrame = function(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("BOTTOMLEFT")
	frame:SetPoint("BOTTOMRIGHT")
	frame:SetHeight(40)
	
	AddElements(frame)
	frame.bu:SetPoint("TOP")
	frame.toggle:SetPoint("BOTTOMRIGHT", 2, -4)
	
	function frame:Update()
		if not EncounterJournal_IsRaidTabSelected(EncounterJournal) then
			local cur_spec = T.ValueFromPath(aCoreCDB, {"ItemOptions", "specloot_instances", parent.instanceID})
			if cur_spec then
				local _, name, _, icon = GetSpecializationInfo(cur_spec)
				frame.bu.tex:SetTexture(icon)
				frame.bu.tooltip = SELECT_LOOT_SPECIALIZATION..":"..name
				frame.bu:Show()	
				frame.toggle:Hide()
			else			
				frame.bu:Hide()
				frame.toggle:Show()
			end
			frame:Show()
		else
			frame:Hide()
		end
	end
	
	frame.bu:SetScript("OnClick", function(self)
		local numspec = GetNumSpecializations()
		local cur_spec = T.ValueFromPath(aCoreCDB, {"ItemOptions", "specloot_instances", parent.instanceID})
		local new_spec
		if cur_spec == numspec then
			new_spec = nil
		else
			new_spec = cur_spec + 1			
		end
		T.ValueToPath(aCoreCDB, {"ItemOptions", "specloot_instances", parent.instanceID}, new_spec)
		frame:Update()
		if new_spec then
			GameTooltip:Hide()
			frame.bu:GetScript("OnEnter")(frame.bu)
		end
	end)
	
	frame.toggle:SetScript("OnClick", function(self)		
		T.ValueToPath(aCoreCDB, {"ItemOptions", "specloot_instances", parent.instanceID}, 1)
		frame:Update()
	end)
	
	parent.spec_frame = frame
end

local LootSpec_init = function()	
	hooksecurefunc("EncounterJournalBossButton_UpdateDifficultyOverlay", function(parent)
		if not parent.spec_frame then
			CreateEncounterSpecFrame(parent)
		end
		parent.spec_frame:Update()
	end)
	hooksecurefunc("EncounterJournal_ListInstances", function()		
		for i = 1, EncounterJournal.instanceSelect.ScrollBox.ScrollTarget:GetNumChildren() do
			local child = select(i, EncounterJournal.instanceSelect.ScrollBox.ScrollTarget:GetChildren())
			if not child.spec_frame then
				CreateInstanceSpecFrame(child)
			end
			child.spec_frame:Update()
		end
	end)
	
	local reset = T.ClickTexButton(EncounterJournal, {"TOPLEFT", EncounterJournal, "TOPLEFT", 2, -2}, G.iconFile.."refresh.tga", T.split_words(L["重置"],ALL,SELECT_LOOT_SPECIALIZATION))
	reset:SetScript("OnClick", function()
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(SELECT_LOOT_SPECIALIZATION))
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			aCoreCDB.ItemOptions.specloot_encounters = table.wipe(aCoreCDB.ItemOptions.specloot_encounters)
			aCoreCDB.ItemOptions.specloot_instances = table.wipe(aCoreCDB.ItemOptions.specloot_encounters)
			EncounterJournal:Hide()
			EncounterJournal:Show()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)
end

--====================================================--
--[[                 -- Events --                   ]]--
--====================================================--

local eventframe = CreateFrame("Frame")

eventframe:RegisterEvent("ENCOUNTER_START")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventframe:RegisterEvent("ADDON_LOADED")

eventframe:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_EncounterJournal" then
		EJ_init()
		LootSpec_init()
	elseif event == "ENCOUNTER_START" then
		if arg1 then
			
			local cur_spec = aCoreCDB.ItemOptions.specloot_encounters[arg1]
			if cur_spec then
				local id, name, _, icon = GetSpecializationInfo(cur_spec)
				SetLootSpecialization(id)					
			end
		end		
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID then
			local InstanceID = EJ_GetInstanceForMap(mapID)
			if InstanceID and InstanceID ~= 0 then
				local cur_spec = aCoreCDB.ItemOptions.specloot_instances[InstanceID]
				if cur_spec then
					local id, name, _, icon = GetSpecializationInfo(cur_spec)
					SetLootSpecialization(id)					
				end
			end
		end
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end
end)