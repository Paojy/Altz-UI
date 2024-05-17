local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[             -- 背包物品等级 --                 ]]--
--====================================================--
local function SetItemButtonLevel(button, quality, level)
	if not button.itemLeveltext then
		button.itemLeveltext = T.createtext(button, "OVERLAY", 12, "OUTLINE", "CENTER")
		button.itemLeveltext:SetPoint("BOTTOM", button, "BOTTOM", 0, 0)
	end
	
	local color_str = select(4, GetItemQualityColor(quality))
	button.itemLeveltext:SetText("|c"..color_str..level.."|r")
	button.itemLeveltext:Show()
end

local function GetItemButton(bagID, slot_num, ind)
	local ContainerID = bagID + 1
	local SlotID = slot_num - ind + 1
	return _G["ContainerFrame"..ContainerID.."Item"..SlotID]
end

local function UpdateBag(bagID)
	local slot_num = C_Container.GetContainerNumSlots(bagID)
	for i = 1, slot_num do
		local itemButton = GetItemButton(bagID, slot_num, i)
		local show_level
		
		local itemLoc = ItemLocation:CreateFromBagAndSlot(bagID, i)
		if itemLoc:IsValid() then			
			local itemID = C_Item.GetItemID(itemLoc)
			local quality = C_Item.GetItemQuality(itemLoc)
			
			if itemID and quality and quality > 1 then
				local class = select(12, GetItemInfo(itemID))
				if class == 2 or class == 4 then -- 2 Weapon 4 Armor
					SetItemButtonLevel(itemButton, quality, C_Item.GetCurrentItemLevel(itemLoc))
					show_level = true
				end
			end	
		end
		
		if not show_level and itemButton.itemLeveltext then
			itemButton.itemLeveltext:Hide()
		end
	end
end

local function UpdateAll()
	for bagID = 0, 4 do
		UpdateBag(bagID)
	end
end

local function HideAll()
	for bagID = 0, 4 do
		local slot_num = C_Container.GetContainerNumSlots(bagID)
		for i = 1, slot_num do
			local itemButton = GetItemButton(bagID, slot_num, i)
			if itemButton.itemLeveltext then
				itemButton.itemLeveltext:Hide()
			end
		end
	end
end

local eventFrame = CreateFrame('Frame')
eventFrame:SetScript('OnEvent', function(self, event, bagID)
	if event == "BAG_UPDATE" then
		if bagID >= 0 and bagID <= 4 then
			UpdateBag(bagID)
		end
	end
end)

local ToggleItemLevel = function()
	if aCoreCDB.ItemOptions.itemLevel then
		eventFrame:RegisterEvent("BAG_UPDATE")
		UpdateAll()
	else
		eventFrame:UnregisterEvent("BAG_UPDATE")
		HideAll()
	end
end
T.ToggleItemLevel = ToggleItemLevel

T.RegisterEnteringWorldCallback(ToggleItemLevel)