local T, C, L, G = unpack(select(2, ...))

if not (aCoreCDB["ItemOptions"]["enablebag"] and aCoreCDB["ItemOptions"]["showitemlevel"]) then return end

local WEAPON = WEAPON
local ARMOR = ARMOR

local inventorySlotNames = {
  "HeadSlot",
  "NeckSlot",
  "ShoulderSlot",
  "BackSlot",
  "ChestSlot",
  "WristSlot",
  "HandsSlot",
  "WaistSlot",
  "LegsSlot",
  "FeetSlot",
  "Finger0Slot",
  "Finger1Slot",
  "Trinket0Slot",
  "Trinket1Slot",
  "MainHandSlot",
  "SecondaryHandSlot"
}

local function AddText(Button)
	Button.level = T.createtext(Button, "OVERLAY", 12, "OUTLINE", "LEFT")
	Button.level:SetPoint("BOTTOMLEFT")
end

local upgradeTable = {
	[  1] = { upgrade = 1, max = 1, ilevel = 8 },
	[373] = { upgrade = 1, max = 3, ilevel = 4 },
	[374] = { upgrade = 2, max = 3, ilevel = 8 },
	[375] = { upgrade = 1, max = 3, ilevel = 4 },
	[376] = { upgrade = 2, max = 3, ilevel = 4 },
	[377] = { upgrade = 3, max = 3, ilevel = 4 },
	[378] = {                       ilevel = 7 },
	[379] = { upgrade = 1, max = 2, ilevel = 4 },
	[380] = { upgrade = 2, max = 2, ilevel = 4 },
	[445] = { upgrade = 0, max = 2, ilevel = 0 },
	[446] = { upgrade = 1, max = 2, ilevel = 4 },
	[447] = { upgrade = 2, max = 2, ilevel = 8 },
	[451] = { upgrade = 0, max = 1, ilevel = 0 },
	[452] = { upgrade = 1, max = 1, ilevel = 8 },
	[453] = { upgrade = 0, max = 2, ilevel = 0 },
	[454] = { upgrade = 1, max = 2, ilevel = 4 },
	[455] = { upgrade = 2, max = 2, ilevel = 8 },
	[456] = { upgrade = 0, max = 1, ilevel = 0 },
	[457] = { upgrade = 1, max = 1, ilevel = 8 },
	[458] = { upgrade = 0, max = 4, ilevel = 0 },
	[459] = { upgrade = 1, max = 4, ilevel = 4 },
	[460] = { upgrade = 2, max = 4, ilevel = 8 },
	[461] = { upgrade = 3, max = 4, ilevel = 12 },
	[462] = { upgrade = 4, max = 4, ilevel = 16 },
	[465] = { upgrade = 0, max = 2, ilevel = 0 },
	[466] = { upgrade = 1, max = 2, ilevel = 4 },
	[467] = { upgrade = 2, max = 2, ilevel = 8 },
	[468] = { upgrade = 0, max = 4, ilevel = 0 },
	[469] = { upgrade = 1, max = 4, ilevel = 4 },
	[470] = { upgrade = 2, max = 4, ilevel = 8 },
	[471] = { upgrade = 3, max = 4, ilevel = 12 },
	[472] = { upgrade = 4, max = 4, ilevel = 16 },
	[491] = { upgrade = 0, max = 4, ilevel = 0 },
	[492] = { upgrade = 1, max = 4, ilevel = 4 },
	[493] = { upgrade = 2, max = 4, ilevel = 8 },
	[494] = { upgrade = 0, max = 6, ilevel = 0 },
	[495] = { upgrade = 1, max = 6, ilevel = 4 },
	[496] = { upgrade = 2, max = 6, ilevel = 8 },
	[497] = { upgrade = 3, max = 6, ilevel = 12 },
	[498] = { upgrade = 4, max = 6, ilevel = 16 },
	[503] = { upgrade = 3, max = 3, ilevel = 1 },
	[504] = { upgrade = 3, max = 4, ilevel = 12 },
	[505] = { upgrade = 4, max = 4, ilevel = 16 },
	[506] = { upgrade = 5, max = 6, ilevel = 20 },
	[507] = { upgrade = 6, max = 6, ilevel = 24 },
	[529] = { upgrade = 0, max = 2, ilevel = 0 },
	[530] = { upgrade = 1, max = 2, ilevel = 5 },
	[531] = { upgrade = 2, max = 2, ilevel = 10 },

}

-- Convert the ITEM_LEVEL constant into a pattern for our use
local itemLevelPattern = _G["ITEM_LEVEL"]:gsub("%%d", "(%%d+)")

local scanningTooltip = CreateFrame("GameTooltip", "LibItemUpgradeInfoTooltip", nil, "GameTooltipTemplate")
scanningTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function GetHeirloomTrueLevel(itemString)
	local name, itemLink, rarity, itemLevel = GetItemInfo(itemString)
	if not rarity then return end
	if rarity>1 then
		local ilvl = aCoreCDB["ItemOptions"]["itemlevels"][itemLink]
		if rarity == 6 then
			C_Timer.After(.5, function()
				scanningTooltip:ClearLines()
				scanningTooltip:SetHyperlink(itemLink)
				for i = 2, 4 do
					local label, text = _G["LibItemUpgradeInfoTooltipTextLeft"..i]
					if label then 
						text = label:GetText()
						if text then
							ilvl = tonumber(text:match(itemLevelPattern))
							if ilvl ~= nil then
								--print(itemLink,  ilvl, "神器")
								scanningTooltip:ClearLines()
								return ilvl, true
							end
						end
					end
				end
			end)
		elseif ilvl then
			--print(itemLink,  ilvl, "已经存在")
			scanningTooltip:ClearLines()
			return ilvl, true
		else
			scanningTooltip:ClearLines()
			scanningTooltip:SetHyperlink(itemLink)
			for i = 2, 4 do
				local label, text = _G["LibItemUpgradeInfoTooltipTextLeft"..i]
				if label then 
					text = label:GetText()
					if text then
						ilvl = tonumber(text:match(itemLevelPattern))
						if ilvl ~= nil then
							aCoreCDB["ItemOptions"]["itemlevels"][itemLink] = ilvl
							--print(itemLink,  ilvl, "新增")
							scanningTooltip:ClearLines()
							return ilvl, true
						end
					end
				end
			end
		end
		scanningTooltip:ClearLines()
		return itemLevel, false
	end
end

local function GetUpgradeID(itemString)
	--local instaid,upgradeid =itemString:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:(%d+):%d:%d:(%d)")
	--local instaid,upgradeid =itemString:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:%d+:(%d+):%d+:%d+:(%d+)")
	if itemString then
		local itemString = itemString:match("itemLink[%-?%d:]+") or ""-- Standardize itemlink to itemstring
		local instaid, _, numBonuses, affixes = select(12, strsplit(":", itemString, 15))
		instaid=tonumber(instaid) or 7
		if instaid >0 and (instaid-4)%8==0 then
			return tonumber(select(numBonuses + 1, strsplit(":", affixes)))
		end
	end
end

local function GetItemLevelUpgrade(id)
	return upgradeTable[id].ilevel
end

local function GetUpgradedItemLevel(itemString)
	-- check for heirlooms first
	local ilvl, isTrue = GetHeirloomTrueLevel(itemString)
	if isTrue then
		return ilvl
	end
	-- not an heirloom? fall back to the regular item logic
	local id = GetUpgradeID(itemString)
	if ilvl and id then
		ilvl = ilvl + GetItemLevelUpgrade(id)
	end
	return ilvl
end

T.UpdateItemLevel_CharacterInventorySlot = function()
	for index, name in ipairs (inventorySlotNames) do
		local Button = _G["Character" .. name]
		if not Button.level then
			AddText(Button)
		end
		
		local SlotNumber = select(1, GetInventorySlotInfo(name))		
		local ItemLink = GetInventoryItemLink("player", SlotNumber)
		
		if ItemLink then
			local Name, Link, Rarity = GetItemInfo(ItemLink)
			local Level = GetUpgradedItemLevel(ItemLink)
			if Rarity and Rarity > 1 then
				Button.level:SetText(Level)
				Button.level:SetTextColor(GetItemQualityColor(Rarity))
			else
				Button.level:SetText()
			end
		else
			Button.level:SetText()
		end
	end
end

local function BagSlotUpdate(id, Button)
	if not Button.level then
		AddText(Button)
	end
	local ItemLink = GetContainerItemLink(id, Button:GetID())
	if ItemLink then
		local Name, Link, Rarity, fLevel, MinLevel, Type, SubType, StackCount, EquipLoc, Texture, SellPrice, Type_i, SubType_i = GetItemInfo(ItemLink)
		
		if Rarity and Rarity > 1 and (EquipLoc ~= "" or (Type_i == 3 and SubType_i == 11)) then
			local Level = GetUpgradedItemLevel(ItemLink)
			Button.level:SetText(Level)
			Button.level:SetTextColor(GetItemQualityColor(Rarity))
			Button.level:Show()
			--print("update"..Level)
		else
			Button.level:SetText()
			--print("delete because of rarity or type")
		end
	else
		Button.level:SetText()
		--print("delete because of no item")
	end
end

T.UpdateItemLevel_Bag = function(BagID)
	local Size = GetContainerNumSlots(BagID)
	for Slot = 1, Size do
		local Button = _G["ContainerFrame"..(BagID+1).."Item"..Slot]
		BagSlotUpdate(BagID, Button)
	end
end

T.UpdateItemLevel_Bags = function()
	for BagID = 0 , 4 do
		local Size = GetContainerNumSlots(BagID)
		for Slot = 1, Size do
			local Button = _G["ContainerFrame"..(BagID+1).."Item"..Slot]
			BagSlotUpdate(BagID, Button)
		end
	end
end

T.UpdateItemLevel_Bank = function()
	for BagID = 5 , 11 do
		local Size = GetContainerNumSlots(BagID)
		for Slot = 1, Size do
			local Button = _G["ContainerFrame"..(BagID+1).."Item"..Slot]
			BagSlotUpdate(BagID, Button)
		end
	end
	
	for BankID = 1, 28 do
		local Button = _G["BankFrameItem"..BankID]
		BagSlotUpdate(-1, Button)
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame.t = 0

EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("BAG_UPDATE")
EventFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
EventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
EventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "AltzUI" then
	
		local MyBag = _G[G.uiname.."bag"]
		if MyBag then
			MyBag:HookScript("OnShow", function() 
				T.UpdateItemLevel_Bags()
			end)
		else
			print("Bag Item Level Error")
		end
		
		local MyBank = _G[G.uiname.."bank"]
		if MyBank then
			MyBank:HookScript("OnShow", function() 
				T.UpdateItemLevel_Bank()
			end)
		else
			print("Bank Item Level Error")
		end
		
		EventFrame:SetScript("OnUpdate", function(self, elapsed)
			self.t = self.t + elapsed
			if self.t > 2 then
				T.UpdateItemLevel_CharacterInventorySlot()
				T.UpdateItemLevel_Bags()
				T.UpdateItemLevel_Bank()
				ToggleAllBags()
				ToggleAllBags()				
				EventFrame:SetScript("OnUpdate", nil)
			end
		end)
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		T.UpdateItemLevel_CharacterInventorySlot()
	elseif event == "PLAYERBANKSLOTS_CHANGED" then
		T.UpdateItemLevel_Bank()
	elseif event == "UNIT_INVENTORY_CHANGED" then
		T.UpdateItemLevel_Bags()
		T.UpdateItemLevel_Bank()
	elseif event == "BAG_UPDATE" then
		T.UpdateItemLevel_Bag(arg1)
	end
end)
