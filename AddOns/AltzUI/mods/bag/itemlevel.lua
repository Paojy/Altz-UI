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

T.UpdateItemLevel_CharacterInventorySlot = function()
	for index, name in ipairs (inventorySlotNames) do
		local Button = _G["Character" .. name]
		if not Button.level then
			AddText(Button)
		end
		
		local SlotNumber = select(1, GetInventorySlotInfo(name))		
		local ItemLink = GetInventoryItemLink("player", SlotNumber)
		
		if ItemLink then
			local Name, Link, Rarity, Level, MinLevel, Type, SubType, StackCount, EquipLoc, Texture, SellPrice = GetItemInfo(ItemLink)
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
		local Name, Link, Rarity, Level, MinLevel, Type, SubType, StackCount, EquipLoc, Texture, SellPrice = GetItemInfo(ItemLink)
		if Rarity and Rarity > 1 and (Type == ARMOR or Type == WEAPON) then
			Button.level:SetText(Level)
			Button.level:SetTextColor(GetItemQualityColor(Rarity))
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

T.UpdateItemLevel_Bags = function()
	for BagID = 0 , 11 do
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
EventFrame:RegisterEvent("BANKFRAME_OPENED")
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
		EventFrame:SetScript("OnUpdate", function(self, elapsed)
			self.t = self.t + elapsed
			if self.t > 2 then
				T.UpdateItemLevel_CharacterInventorySlot()
				T.UpdateItemLevel_Bags()
				EventFrame:SetScript("OnUpdate", nil)
				ToggleAllBags()
				ToggleAllBags()
			end
		end)
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		T.UpdateItemLevel_CharacterInventorySlot()
	else
		T.UpdateItemLevel_Bags()
	end
end)