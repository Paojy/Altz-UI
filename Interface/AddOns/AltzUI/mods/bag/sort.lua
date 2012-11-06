local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB.enablebag then return end

--category constants
--number indicates sort priority (1 is highest)
BS_SOULBOUND   = 1
BS_REAGENT     = 2
BS_CONSUMABLE  = 3
BS_QUEST       = 4
BS_TRADE       = 5
BS_QUALITY     = 6
BS_COMMON      = 7
BS_TRASH       = 8

local _G = _G
local BS_bagGroups --bag group definitions
local BS_itemSwapGrid --grid of item data based on destination inventory location
		
local BS_sorting = false     --indicates bag rearrangement is in progress
local BS_pauseRemaining = 0  --how much longer to wait before running the OnUpdate code again

local function BS_clearData()
 	BS_itemSwapGrid = {}
	BS_bagGroups = {}
end

local function BS_OnUpdate(parentFrame, tElapsed)
	if not BS_sorting then return end
	
	BS_pauseRemaining = BS_pauseRemaining - tElapsed
	if BS_pauseRemaining > 0 then return end

	local changesThisRound = false
	local blockedThisRound = false
	
	--for each bag in the grid
	for bagIndex in pairs(BS_itemSwapGrid) do
	    --for each slot in this bag
	    for slotIndex in pairs(BS_itemSwapGrid[bagIndex]) do
			--(for readability)
			local destinationBag  = BS_itemSwapGrid[bagIndex][slotIndex].destinationBag
			local destinationSlot = BS_itemSwapGrid[bagIndex][slotIndex].destinationSlot

			--see if either item slot is currently locked
	        local _, _, locked1 = GetContainerItemInfo(bagIndex, slotIndex)
	        local _, _, locked2 = GetContainerItemInfo(destinationBag, destinationSlot)
	        
	        if locked1 or locked2 then
	            blockedThisRound = true
			--if item not already where it belongs, move it
			elseif bagIndex ~= destinationBag or slotIndex ~= destinationSlot then
               	PickupContainerItem(bagIndex, slotIndex)
				PickupContainerItem(destinationBag, destinationSlot)
				
				local tempItem = BS_itemSwapGrid[destinationBag][destinationSlot]
				BS_itemSwapGrid[destinationBag][destinationSlot] = BS_itemSwapGrid[bagIndex][slotIndex]
				BS_itemSwapGrid[bagIndex][slotIndex] = tempItem

				changesThisRound = true
	        end
		end
	end
	
	if not changesThisRound and not blockedThisRound then
	    BS_sorting = false
	    BS_clearData()
	end
	
	BS_pauseRemaining = .05
end

local function sortBagRange(bagList, order)
	--clear any data from previous sorts
	BS_clearData()
	local family

	--assign bags to bag groups
	for slotNumIndex, slotNum in pairs(bagList) do
		
		if GetContainerNumSlots(slotNum) > 0 then --if bag exists
			--initialize the item grid for this bag (used later)
			BS_itemSwapGrid[slotNum] = {}
			family = select(2, GetContainerNumFreeSlots(slotNum))
		   if family then
			if family == 0 then family = 'default' end
			if not BS_bagGroups[family] then
				BS_bagGroups[family] = {}
				BS_bagGroups[family].bagSlotNumbers = {}
			 end
			table.insert(BS_bagGroups[family].bagSlotNumbers, slotNum)
		  end
		end
	end
	
	--for each bag group
	for groupKey, group in pairs(BS_bagGroups) do
		--initialize the list of items for this bag group
		group.itemList = {}
		--for each bag in this group
		for bagKey, bagSlot in pairs(group.bagSlotNumbers) do
		
			--for each item slot in this bag
			for itemSlot=1, GetContainerNumSlots(bagSlot) do
			
				--get a reference for the item in this location
				local itemLink = GetContainerItemLink(bagSlot, itemSlot)

				--if this slot is non-empty
				if itemLink ~= nil then
				
					--collect important data about the item
					local newItem   = {}
					
					--initialize the sorting string for this item
					newItem.sortString = ""
					
					--use reference from above to request more detailed information
					local itemName, _, itemRarity, _, _, itemType, itemSubType, _, itemEquipLoc, _ = GetItemInfo(itemLink)
					if not itemName then 
						itemName = itemLink
						itemRarity = 5
						itemType = "Pet"
						itemSubType = "Pet"
						itemEquipLoc = 0
					end -- fix for battle pets
					newItem.name = itemName
					
					--determine category
					
					--soulbound items
                   	local tooltip = _G["BS_toolTip"]
					local owner = _G["Bag_Sort_Core"]
                    tooltip:SetOwner(owner, ANCHOR_NONE)
					tooltip:ClearLines()
					tooltip:SetBagItem(bagSlot, itemSlot)
					local tooltipLine2 = _G["BS_toolTipTextLeft2"]:GetText()
					tooltip:Hide()

					if tooltipLine2 and tooltipLine2 == "Soulbound" then
						newItem.sortString = newItem.sortString .. BS_SOULBOUND
					--consumable items
					elseif itemType == "Consumable" then
						newItem.sortString = newItem.sortString .. BS_CONSUMABLE
					--reagents
					elseif itemType == "Reagent" then
						newItem.sortString = newItem.sortString .. BS_REAGENT
					--trade goods
					elseif itemType == "Trade Goods" then
						newItem.sortString = newItem.sortString .. BS_TRADE
					--quest items
					elseif itemType == "Quest" then
						newItem.sortString = newItem.sortString .. BS_QUEST
					--junk
					elseif itemRarity == 0 then
						newItem.sortString = newItem.sortString .. BS_TRASH
					--common quality
					elseif itemRarity == 1 then
						newItem.sortString = newItem.sortString .. BS_COMMON
					--higher quality
					else
						newItem.sortString = newItem.sortString .. BS_QUALITY
					end
					
					--finish the sort string, placing more important information
					--closer to the start of the string
					
					newItem.sortString = newItem.sortString .. itemType .. itemSubType .. itemEquipLoc .. itemName
					
					--add this item's accumulated data to the item list for this bag group
					tinsert(group.itemList, newItem)

					--record location
					BS_itemSwapGrid[bagSlot][itemSlot] = newItem
					newItem.startBag = bagSlot
					newItem.startSlot = itemSlot
				end
			end
		end
		
		--sort the item list for this bag group by sort strings
		table.sort(group.itemList, function(a, b) return a.sortString < b.sortString end)
		
		--show the results for this group
		for index, item in pairs(group.itemList) do
			local gridSlot = index
   			--record items in a grid according to their intended final placement
			for bagSlotNumberIndex, bagSlotNumber in pairs(group.bagSlotNumbers) do
				if gridSlot <= GetContainerNumSlots(bagSlotNumber) then
					if order == 0 then -- put their order them from bottomright
						BS_itemSwapGrid[item.startBag][item.startSlot].destinationBag  = bagSlotNumber
						BS_itemSwapGrid[item.startBag][item.startSlot].destinationSlot = GetContainerNumSlots(bagSlotNumber) - gridSlot + 1
						break
					else -- put their order them from topleft
						BS_itemSwapGrid[item.startBag][item.startSlot].destinationBag  = bagSlotNumber
						BS_itemSwapGrid[item.startBag][item.startSlot].destinationSlot = gridSlot
						break
					end
				else
					gridSlot = gridSlot - GetContainerNumSlots(bagSlotNumber)
				end
	        end
	    end
	end
	
	--signal for sorting to begin
	BS_sorting = true
end

function T.BankSort(order)
	if order == 0 then
		sortBagRange({11, 10, 9, 8, 7, 6, 5, -1}, 0)
	else
		sortBagRange({-1, 5, 6, 7, 8, 9, 10, 11}, 1)
	end
end

function T.BagSort(order)
	if order == 0 then
		sortBagRange({4, 3, 2, 1, 0}, 0)
	else
		sortBagRange({0, 1, 2, 3, 4}, 1)
	end
end

local Core = CreateFrame("Frame", "Bag_Sort_Core")
Core:SetScript("OnLoad", BS_clearData)
Core:SetScript("OnUpdate", BS_OnUpdate)

local Tooltip = CreateFrame("GameTooltip", "BS_toolTip", UIParent, "GameTooltipTemplate")