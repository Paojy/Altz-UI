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

	local parent = EncounterJournal.encounter.info.LootContainer
	parent.slotFilter:ClearAllPoints()
	parent.slotFilter:SetPoint("LEFT", parent.filter, "RIGHT", 0, 0)
	
	local StatsFilter = CreateFrame("DropDownToggleButton", nil, parent, "EJButtonTemplate")
	StatsFilter:SetText(STAT_CATEGORY_ENHANCEMENTS)
	StatsFilter:SetPoint("LEFT", parent.slotFilter, "RIGHT", 0, 0)
	T.ReskinFilterToggle(StatsFilter)

	StatsFilter.DropDown = CreateFrame("Frame", nil, StatsFilter, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(StatsFilter.DropDown, StatsFilter_Initialize, "MENU")
	
	StatsFilter:SetScript("OnMouseDown", function(self)
		self.DropDown.point = "TOPLEFT"
		self.DropDown.relativePoint = "BOTTOMLEFT"
		ToggleDropDownMenu(1, nil, self.DropDown, self, 0, 5)	
	end)
	
	parent.StatsFilter = StatsFilter
end

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("ADDON_LOADED")
eventframe:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_EncounterJournal" then
		EJ_init()
	end
end)