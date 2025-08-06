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

local function HideAll()	
	for i, itemButton in ContainerFrameCombinedBags:EnumerateValidItems() do		
		if itemButton and itemButton.itemLeveltext then
			itemButton.itemLeveltext:Hide()
		end
	end
end

local function UpdateItemButtonLevel(itemButton)
	local bagID = itemButton:GetBagID()
	local buttonID = itemButton:GetID()
	local itemLoc = ItemLocation:CreateFromBagAndSlot(bagID, buttonID)
	
	local show_level
	
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

hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", function(self)
	if aCoreCDB.ItemOptions.itemLevel then
		for i, itemButton in self:EnumerateValidItems() do			
			UpdateItemButtonLevel(itemButton)
		end
	end
end)

local function UpdateBankItemButtonLevel(itemButton)
	local BankTabID = itemButton:GetBankTabID()
	local ContainerSlotID = itemButton:GetContainerSlotID()
	local itemLoc = ItemLocation:CreateFromBagAndSlot(BankTabID, ContainerSlotID)
	
	local show_level
	
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

hooksecurefunc(BankPanel, "GenerateItemSlotsForSelectedTab", function(self)
	if aCoreCDB.ItemOptions.itemLevel then
		for itemButton in BankPanel:EnumerateValidItems() do
			UpdateBankItemButtonLevel(itemButton)
		end
	end
end)

hooksecurefunc(BankPanel, "RefreshAllItemsForSelectedTab", function(self)
	if aCoreCDB.ItemOptions.itemLevel then
		for itemButton in BankPanel:EnumerateValidItems() do
			UpdateBankItemButtonLevel(itemButton)
		end
	end
end)

local ToggleItemLevel = function()
	if aCoreCDB.ItemOptions.itemLevel then
		if ContainerFrameCombinedBags:IsShown() then
			ContainerFrameCombinedBags:UpdateItems()
		end
	else
		HideAll()
	end
end
T.ToggleItemLevel = ToggleItemLevel

T.RegisterEnteringWorldCallback(ToggleItemLevel)