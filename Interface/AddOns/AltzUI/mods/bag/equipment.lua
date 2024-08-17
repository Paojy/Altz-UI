local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- API --                      ]]--
--====================================================--
local equiment_slots = {
	{ name = HEADSLOT, slot = INVSLOT_HEAD},
	{ name = NECKSLOT, slot = INVSLOT_NECK},
	{ name = SHOULDERSLOT, slot = INVSLOT_SHOULDER},
	{ name = BACKSLOT, slot = INVSLOT_BACK, enchant = true},	
	{ name = CHESTSLOT, slot = INVSLOT_CHEST, enchant = true},	
	{ name = WAISTSLOT, slot = INVSLOT_WAIST},
	{ name = LEGSSLOT, slot = INVSLOT_LEGS, enchant = true},
	{ name = FEETSLOT, slot = INVSLOT_FEET, enchant = true},
	{ name = WRISTSLOT,	slot = INVSLOT_WRIST, enchant = true},
	{ name = HANDSSLOT, slot = INVSLOT_HAND},
	{ name = FINGER0SLOT, slot = INVSLOT_FINGER1, compare = true, enchant = true},
	{ name = FINGER1SLOT, slot = INVSLOT_FINGER2, compare = true, enchant = true},
	{ name = TRINKET0SLOT, slot = INVSLOT_TRINKET1, compare = true},
	{ name = TRINKET1SLOT, slot = INVSLOT_TRINKET2, compare = true}, -- 14
	{ name = MAINHANDSLOT, slot = INVSLOT_MAINHAND, enchant = true},
	{ name = SECONDARYHANDSLOT, slot = INVSLOT_OFFHAND},
}

local statsInfo = {
	{ key = "ITEM_MOD_CRIT_RATING_SHORT", name = ITEM_MOD_CRIT_RATING_SHORT, color = {1,0,0}},
	{ key = "ITEM_MOD_HASTE_RATING_SHORT", name = ITEM_MOD_HASTE_RATING_SHORT, color = {0,1,0}},
	{ key = "ITEM_MOD_MASTERY_RATING_SHORT", name = ITEM_MOD_MASTERY_RATING_SHORT, color = {0,1,1}},
	{ key = "ITEM_MOD_VERSATILITY", name = ITEM_MOD_VERSATILITY, color = {1,1,0}},
}

local frame_width = 400
local enchantformat = string.gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "([^.]+)")
local itemlevelfomat = string.gsub(ITEM_LEVEL, "%%d", "([^.]+)")

local function GetTooltipData(unit, slot, itemLink)	
	local data = C_TooltipInfo.GetInventoryItem(unit, slot, true)
	
	local level
	for k, v in pairs(data.lines) do
		for a, b in pairs(v) do
			if a == "leftText" and string.match(b, itemlevelfomat) then
				level = tonumber(string.match(b, itemlevelfomat))
				break
			end
		end
	end
	
	local enchant_str
	local enchantID = select(3, string.split(":", string.match(itemLink, "item[%-?%d:]+")))	
	
	if enchantID and enchantID ~= "" then
		for k, v in pairs(data.lines) do
			for a, b in pairs(v) do
				if a == "enchantID" then
					enchant_str = string.match(v.leftText, enchantformat)
					break
				end
			end
		end
	end
	
	return level, enchant_str
end

local function ShouldShowSecondHand(parent)
	local itemID = GetInventoryItemID(parent.unit, INVSLOT_MAINHAND)
	
	if not itemID then return true end
	
	local itemEquipLoc = select(9, GetItemInfo(itemID))
	if itemEquipLoc == "INVTYPE_2HWEAPON" then
		return false
	else
		return true
	end
end

local function CreateEnchantSocket(bu, frame)
	frame.Enchant = CreateFrame("Frame", nil, frame)
	frame.Enchant:SetSize(14, 14)
	
	frame.Enchant.border = frame.Enchant:CreateTexture(nil, "OVERLAY")
	frame.Enchant.border:SetAtlas("Adventurers-Followers-Frame")
	frame.Enchant.border:SetAllPoints()
	
	frame.Enchant.tex_mask = frame.Enchant:CreateMaskTexture(nil, "ARTWORK")
	frame.Enchant.tex_mask:SetTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]])
	frame.Enchant.tex_mask:SetAllPoints()
	
	frame.Enchant.icon = frame.Enchant:CreateTexture(nil, "ARTWORK")
	frame.Enchant.icon:SetTexCoord(.1, .9, .1, .9)
	frame.Enchant.icon:SetAllPoints()
	frame.Enchant.icon:SetTexture(136244)
	frame.Enchant.icon:AddMaskTexture(frame.Enchant.tex_mask)
	
	frame.Enchant.text = T.createtext(frame.Enchant, "OVERLAY", 12, "OUTLINE", "LEFT")
	frame.Enchant.text:SetPoint("LEFT", frame.Enchant, "RIGHT", 0, 0)
	frame.Enchant.text:SetTextColor(.12, 1, 0)
	frame.Enchant.text:SetHeight(14)
	frame.Enchant.text:SetPoint("RIGHT", bu, "RIGHT", -70, 0)
end

local function CreateSockets(bu)
	local frame = CreateFrame("Frame", nil, bu)
	frame:SetSize(42, 14)
	frame:SetPoint("LEFT", bu.mid, "RIGHT", 0, 0)
	frame.Slots = {}
	
	for i = 1, 3 do
		local f = CreateFrame("Frame", nil, frame)
		f:SetSize(14, 14)
		f:SetPoint("LEFT", 14*(i-1), 0)
		
		f.Slot = f:CreateTexture(nil, "BORDER")
		f.Slot:SetAtlas("Adventurers-Followers-Frame")
		f.Slot:SetAllPoints(true)

		f.Gem_mask = f:CreateMaskTexture(nil, "ARTWORK")
		f.Gem_mask:SetTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]])
		f.Gem_mask:SetPoint("TOPLEFT", 2, -2)
		f.Gem_mask:SetPoint("BOTTOMRIGHT", -2, 2)
		
		f.Gem = f:CreateTexture(nil, "ARTWORK")
		f.Gem:SetTexCoord(.2, .8, .2, .8)
		f.Gem:SetPoint("TOPLEFT", 2, -2)
		f.Gem:SetPoint("BOTTOMRIGHT", -2, 2)
		f.Gem:AddMaskTexture(f.Gem_mask)
		f.Gem:Hide()
		
		table.insert(frame.Slots, f)
	end
	
	if bu.enchant then
		CreateEnchantSocket(bu, frame)
	end
	
	function frame:SetItem(item, slot_index, enchant_str)
		local numSockets = C_Item.GetItemNumSockets(item)	
		local anchor = 0
		
		if numSockets > 0 then
			for index, slot in ipairs(self.Slots) do
				slot:SetShown(index <= numSockets)
				
				local gemID = C_Item.GetItemGemID(item, index)
				local hasGem = gemID ~= nil
		
				slot.Gem:SetShown(hasGem)
				
				if hasGem then
					local gemItem = Item:CreateFromItemID(gemID)
				
					if not gemItem:IsItemDataCached() then
						slot.Gem:SetTexture()
					end
				
					gemItem:ContinueOnItemLoad(function()
						local gemIcon = C_Item.GetItemIconByID(gemID)
						slot.Gem:SetTexture(gemIcon)
					end)
				end
				
				if index <= numSockets then
					anchor = anchor + 14
				end
			end
		else
			for index, slot in ipairs(self.Slots) do
				slot:Hide()
			end
		end
		
		if bu.enchant then
			frame.Enchant:ClearAllPoints()
			frame.Enchant:SetPoint("LEFT", frame, "LEFT", anchor, 0)
			if enchant_str then
				frame.Enchant.icon:SetDesaturated(false)
				frame.Enchant.text:SetText(enchant_str)
			else
				frame.Enchant.icon:SetDesaturated(true)
				frame.Enchant.text:SetText(T.hex_str(T.split_words(NONE,ENCHANTS), .5, .5, .5))
			end
		end
		
		frame:Show()
	end
	
	bu.sockets = frame
end

local function CreateStats(bu)
	local frame = CreateFrame("Frame", nil, bu)
	frame:SetSize(80, 14)
	frame:SetPoint("LEFT", bu.right, "RIGHT", 0, 0)
	frame.buttons = {}
	frame.active_buttons = {}
	frame.stats_info = {}
	
	for i, info in pairs(statsInfo) do
		local f = CreateFrame("Frame", nil, frame)
		f:SetSize(20, 14)
		
		f.backdrop = T.createPXBackdrop(f)
		f.backdrop:SetBackdropBorderColor(info.color[1], info.color[2], info.color[3], .5)
		
		f.text = T.createtext(f, "OVERLAY", 8, "OUTLINE", "CENTER")
		f.text:SetAllPoints()
		f.text:SetTextColor(unpack(info.color))
		f.text:SetText(info.name)
		
		frame.buttons[info.key] = f
	end
	
	function frame:SetItemStats(item)
		frame.active_buttons = table.wipe(frame.active_buttons)
		frame.stats_info = table.wipe(frame.stats_info)
		frame.stats_info = C_Item.GetItemStats(item)
		
		for key, f in pairs(frame.buttons) do
			f:Hide()
		end
		
		if frame.stats_info then
			for key, value in pairs(frame.stats_info) do
				local f = frame.buttons[key]
				if f then
					f.v = value
					table.insert(frame.active_buttons, f)
				end
			end
			
			table.sort(frame.active_buttons, function(a, b) return a.v > b.v end)
					
			for i, f in pairs(frame.active_buttons) do
				f:Show()
				f:SetPoint("LEFT", frame, "LEFT", 4+(i-1)*24, 0)
			end		
		end
	end
	
	bu.stats = frame
end

local function CreateSlotButton(parent, index)
	local bu = CreateFrame("Frame", nil, parent)
	bu:SetSize(frame_width-10, 18)
	
	local info = equiment_slots[index]
	bu.slot_name = info.name
	bu.slot = info.slot
	bu.compare = info.compare
	bu.enchant = info.enchant
	bu.itemLevel = 0	
	
	bu.left = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.left:SetPoint("LEFT", bu, "LEFT", 0, 0)
	bu.left:SetWidth(30)
	bu.left:SetText(bu.slot_name)

	bu.icon = bu:CreateTexture(nil, "ARTWORK")
	bu.icon:SetSize(18, 18)
	bu.icon:SetTexCoord(.1, .9, .1, .9)
	bu.icon:SetPoint("LEFT", bu.left, "RIGHT", 0, 0)
	bu.iconbg = T.createTexBackdrop(bu, bu.icon)
	
	bu.mid = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.mid:SetPoint("LEFT", bu.icon, "RIGHT", 0, 0)
	
	bu.right = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "RIGHT")
	bu.right:SetPoint("RIGHT", bu, "RIGHT", -50, 0)
	
	CreateSockets(bu)
	CreateStats(bu)
	
	bu:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -18, 10)
		GameTooltip:SetInventoryItem(parent.unit, self.slot)
		if not self.compare then
			TooltipComparisonManager:Clear()
		end
		GameTooltip:Show()
	end)
	
	bu:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	table.insert(parent.buttons, bu)
end

local function CreateSetButton(parent)
	local bu = CreateFrame("Frame", nil, parent)
	bu:SetSize(frame_width-10, 18)
	
	bu.text = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.text:SetPoint("LEFT", bu, "LEFT", 0, 0)
		
	table.insert(parent.sets, bu)
	
	return bu
end

local function GetItemSetNum(setID)
	local setInfo = C_LootJournal.GetItemSetItems(setID)	
	return #setInfo
end

local function UpdateEquipSlot(parent, bu)
	local itemLink = GetInventoryItemLink(parent.unit, bu.slot)
	if itemLink then	
		local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, _, _, _, _, _, setID = C_Item.GetItemInfo(itemLink)
		local level, enchant_str = GetTooltipData(parent.unit, bu.slot, itemLink)
		
		bu.itemLevel = level or 0
		
		bu.icon:SetTexture(itemTexture)
		bu.icon:Show()
		bu.iconbg:Show()		
		bu.mid:SetText(itemLink)
		bu.right:SetText(level)
		bu.sockets:SetItem(itemLink, bu.slot, enchant_str)
		bu.stats:SetItemStats(itemLink)
		
		if setID then		
			if not parent.active_sets[setID] then			
				parent.SetIndex = parent.SetIndex + 1				
				local set_frame = parent.sets[parent.SetIndex] or CreateSetButton(parent)				
				set_frame.set_str = BOSS_BANNER_LOOT_SET:format(C_Item.GetItemSetInfo(setID))
				set_frame.equipped = 1
				set_frame.total = GetItemSetNum(setID)
				
				set_frame.text:SetText(string.format("%s %d/%d", set_frame.set_str, set_frame.equipped, set_frame.total))
				set_frame:Show()
				
				parent.active_sets[setID] = set_frame
			else
				local set_frame = parent.active_sets[setID]
				set_frame.equipped = set_frame.equipped + 1
				set_frame.text:SetText(string.format("%s %d/%d", set_frame.set_str, set_frame.equipped, set_frame.total))
			end
		end
	else		
		bu.itemLevel = 0
		
		bu.icon:Hide()
		bu.iconbg:Hide()		
		bu.mid:SetText("")
		bu.right:SetText("")		
		bu.sockets:Hide()
	end
end

local function UpdateItemLevel(parent)
	if parent.unit == "player" then
		local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
		local minItemLevel = C_PaperDollInfo.GetMinItemLevel()
		local displayItemLevel = math.max(minItemLevel or 0, avgItemLevelEquipped)
			
		parent.itemLevel:SetText("|cffFFFFFF"..STAT_AVERAGE_ITEM_LEVEL.."|r "..string.format("%.1f", displayItemLevel).."/"..string.format("%.1f", avgItemLevel))
		parent.itemLevel:SetTextColor(GetItemLevelColor())
	else
		local total_level = 0
		for i = 1, 14 do
			total_level = total_level + parent.buttons[i].itemLevel
		end
		if ShouldShowSecondHand(parent) then
			total_level = total_level + parent.buttons[15].itemLevel + parent.buttons[16].itemLevel
		else
			total_level = total_level + parent.buttons[15].itemLevel*2
		end
		parent.itemLevel:SetText("|cffFFFFFF"..STAT_AVERAGE_ITEM_LEVEL.."|r "..string.format("%.1f", total_level/16))		
	end
end

local function UpdateAll(parent)	
	local last_bu
	
	for i, bu in pairs(parent.sets) do
		bu:Hide()
	end
	parent.SetIndex = 0
	parent.active_sets = table.wipe(parent.active_sets)
	
	for i, bu in pairs(parent.buttons) do
		if bu:IsShown() then
			bu:ClearAllPoints()
			if not last_bu then
				bu:SetPoint("TOPLEFT", 5, -40)
			else
				bu:SetPoint("TOPLEFT", last_bu, "BOTTOMLEFT", 0, -2)
			end
			UpdateEquipSlot(parent, bu)
			last_bu = bu
		end
	end
	
	for i, bu in pairs(parent.sets) do
		bu:SetPoint("TOPLEFT", last_bu, "BOTTOMLEFT", 0, -18*i)
	end
	
	if parent.sets[1] and parent.sets[1]:IsShown() then
		parent.line2:SetPoint("BOTTOMLEFT", parent.sets[1], "TOPLEFT", 0, 5)
		parent.line2:Show()
	else
		parent.line2:Hide()
	end
	
	UpdateItemLevel(parent)	
end

local function UpdateDurability(parent)
	for i, bu in pairs(parent.buttons) do
		if GetInventoryItemLink(parent.unit, bu.slot) then
			bu.left:SetTextColor(1, 1, 1)
			local dur, dur_max = GetInventoryItemDurability(bu.slot)
			if dur then
				local perc = dur/dur_max			
				if perc <= .2 then				
					bu.left:SetTextColor(1, 0, 0)	
					bu.left:SetText(string.format("%d%%", perc*100))
				elseif perc <= .5 then
					bu.left:SetTextColor(1, .82, 0)
					bu.left:SetText(string.format("%d%%", perc*100))
				else
					bu.left:SetTextColor(1, 1, 1)
					bu.left:SetText(bu.slot_name)
				end
			else
				bu.left:SetTextColor(1, 1, 1)
				bu.left:SetText(bu.slot_name)
			end
		else
			bu.left:SetTextColor(.5, .5, .5)
			bu.left:SetText(bu.slot_name)
		end
	end
end

--====================================================--
--[[               -- Frames --                     ]]--
--====================================================--
local function CreateEquipListFrame(parent, unit, path)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 5, -1)
	frame:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 5, 1)
	frame:SetWidth(frame_width)
	T.setStripBD(frame)
	
	frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	frame.close:SetPoint("TOPRIGHT", -6, -6)
	T.ReskinClose(frame.close)
	
	frame.toggle = CreateFrame("Button", nil, parent)
	frame.toggle:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 6, -6)
	frame.toggle:SetSize(25, 25)
	
	frame.toggle.tex = frame.toggle:CreateTexture(nil, "ARTWORK")
	frame.toggle.tex:SetAllPoints()
	frame.toggle.tex:SetTexture(G.textureFile.."arrow.tga")
	frame.toggle.tex:SetRotation(rad(-135))
	
	frame.toggle:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
		GameTooltip:AddLine(L["装备列表"])
		GameTooltip:Show()
		self.tex:SetVertexColor(unpack(G.addon_color))
	end)
	
	frame.toggle:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		self.tex:SetVertexColor(1, 1, 1)
	end)
	
	frame.close:SetScript("OnClick", function()
		T.ValueToPath(aCoreCDB, path, false)
		frame:Hide()
		frame.toggle:Show()
	end)

	frame.toggle:SetScript("OnClick", function()
		T.ValueToPath(aCoreCDB, path, true)
		frame:Show()
	end)
	
	frame:SetScript("OnShow", function()
		frame.toggle:Hide()
	end)
	
	frame.itemLevel = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.itemLevel:SetPoint("TOPLEFT", 5, -10)
	
	frame.line = frame:CreateTexture(nil, "ARTWORK")
	frame.line:SetSize(frame_width-10, 1)
	frame.line:SetPoint("TOPLEFT", frame.itemLevel, "BOTTOMLEFT", 0, -5)
	frame.line:SetColorTexture(1, 1, 1, .2)
	
	frame.line2 = frame:CreateTexture(nil, "ARTWORK")
	frame.line2:SetSize(frame_width-10, 1)
	frame.line2:SetColorTexture(1, 1, 1, .2)
	frame.line2:Hide()
	
	frame.buttons = {}
	frame.sets = {}
	frame.active_sets = {}

	for index, info in pairs(equiment_slots) do
		CreateSlotButton(frame, index)
	end
	
	frame.unit = unit

	return frame
end

local EquipFrame = CreateEquipListFrame(CharacterFrame, "player", {"ItemOptions", "equiplist"})
local in_progress

EquipFrame:SetScript('OnEvent', function(self, event)
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		if not in_progress then
			in_progress = true
			C_Timer.After(.5, function()
				self.buttons[16]:SetShown(ShouldShowSecondHand(self))
				UpdateAll(self)
				in_progress = false
			end)			
		end
	elseif event == "UPDATE_INVENTORY_DURABILITY" then
		UpdateDurability(self)
	end
end)

CharacterFrame:HookScript("OnShow", function()
	EquipFrame.buttons[16]:SetShown(ShouldShowSecondHand(EquipFrame))
	UpdateDurability(EquipFrame)
	UpdateAll(EquipFrame)
	EquipFrame:SetShown(aCoreCDB.ItemOptions.equiplist)
	EquipFrame.toggle:SetShown(not aCoreCDB.ItemOptions.equiplist)
	
	EquipFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	EquipFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")	
end)

CharacterFrame:HookScript("OnHide", function()
	EquipFrame:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	EquipFrame:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")	
end)

local ef = CreateFrame("Frame")
ef:RegisterEvent("ADDON_LOADED")
ef:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		local Inspect_EquipFrame = CreateEquipListFrame(InspectFrame, nil, {"ItemOptions", "equiplist_inspect"})
		Inspect_EquipFrame:SetScript("OnEvent", function(self, event)
			self.unit = InspectFrame.unit
			if self.unit then
				self.buttons[16]:SetShown(ShouldShowSecondHand(self))
				UpdateAll(self)
			end
		end)
		Inspect_EquipFrame:RegisterEvent("INSPECT_READY")
		Inspect_EquipFrame:SetShown(aCoreCDB.ItemOptions.equiplist_inspect)
		Inspect_EquipFrame.toggle:SetShown(not aCoreCDB.ItemOptions.equiplist_inspect)
	end
end)
