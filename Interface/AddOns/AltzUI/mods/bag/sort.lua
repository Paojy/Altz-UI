local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ItemOptions"]["enablebag"] then return end

G.bag_sorting = false

local power_spell = GetSpellInfo(255176)
--category constants
--number indicates sort priority (1 is highest)
local FirstItems = {
	[6948] = "!!!1", -- 炉石
	[140192] = "!!!2", -- 达拉然炉石
	[110560] = "!!!3", -- 要塞炉石
}

BS_ARTIFACT    = 0
BS_LEGENDARY   = 1
BS_ARMOR	   = 2
BS_REAGENT     = 3
BS_TRADE       = 4
BS_POWER       = 5
BS_QUEST       = 3
BS_CONSUMABLES = 7
BS_POWER       = 8
BS_TRASH       = 9

local _G = _G
local BS_bagGroups --bag group definitions
local BS_itemSwapGrid --grid of item data based on destination inventory location
		
local BS_sorting = false     --indicates bag rearrangement is in progress
local BS_pauseRemaining = 0.05  --how much longer to wait before running the OnUpdate code again
local BS_delay = 1 -- 留给系统整理的时间

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
	        local _, count1, locked1, _, _, _, _, _, _, itemID1  = GetContainerItemInfo(bagIndex, slotIndex)
	        local _, count2, locked2, _, _, _, _, _, _, itemID2  = GetContainerItemInfo(destinationBag, destinationSlot)
	        
	        if locked1 or locked2 then
	            blockedThisRound = true
			--if item not already where it belongs, move it
			elseif bagIndex ~= destinationBag or slotIndex ~= destinationSlot then
				if itemID1 ~= itemID2 or count1 ~= count2 then
					
					ClearCursor()
					PickupContainerItem(bagIndex, slotIndex)
					PickupContainerItem(destinationBag, destinationSlot)
					ClearCursor()
					
					local tempItem = BS_itemSwapGrid[destinationBag][destinationSlot]
					BS_itemSwapGrid[destinationBag][destinationSlot] = BS_itemSwapGrid[bagIndex][slotIndex]
					BS_itemSwapGrid[bagIndex][slotIndex] = tempItem

					changesThisRound = true
				end
	        end
		end
	end
	
	if not changesThisRound and not blockedThisRound then
	    BS_sorting = false
	    BS_clearData()
	end
	
	BS_pauseRemaining = 0.05
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
				if family == 0 then
					family = 'default'
				end
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
			for itemSlot= 1, GetContainerNumSlots(bagSlot) do
			
				--get a reference for the item in this location
				local texture, count, locked, quality, readable, lootable, itemLink, isFiltered, hasNoValue, itemID = GetContainerItemInfo(bagSlot, itemSlot)
				
				--if this slot is non-empty
				if itemLink ~= nil then
				
					--collect important data about the item
					local newItem   = {}
					
					--initialize the sorting string for this item
					newItem.sortString = ""
					
					--use reference from above to request more detailed information
					local itemName, _, itemRarity, _, _, itemType, itemSubType, _, itemEquipLoc, _, _, itemClass, itemSubclass = GetItemInfo(itemLink)
					
					if not itemName then
						itemName = itemLink
						itemRarity = 5
						itemType = "Pet"
						itemSubType = "Pet"
						itemEquipLoc = 0
					end -- fix for battle pets
					
					newItem.name = itemName
					
					--determine category		
					if FirstItems[itemID] then
						newItem.sortString = newItem.sortString .. FirstItems[itemID]
					--artifact
					elseif itemRarity == 6 then
						newItem.sortString = newItem.sortString .. BS_ARTIFACT
					--legendary
					elseif itemRarity == 5 then
						newItem.sortString = newItem.sortString .. BS_LEGENDARY	
					-- armor
					elseif itemClass == 2 or itemClass == 4 or (itemClass == 3 and itemSubclass == 11) then
						newItem.sortString = newItem.sortString .. BS_ARMOR
					--reagents
					elseif itemClass == 7 then
						newItem.sortString = newItem.sortString .. BS_REAGENT
					--trade goods
					elseif itemClass == 8 then
						newItem.sortString = newItem.sortString .. BS_TRADE
					--quest items
					elseif itemClass == 12 then
						newItem.sortString = newItem.sortString .. BS_QUEST
					--power
					elseif GetItemSpell(itemLink) == power_spell then
						newItem.sortString = newItem.sortString .. BS_POWER						
					--consumables
					elseif itemClass == 0 then
						newItem.sortString = newItem.sortString .. BS_CONSUMABLES
					--junk
					elseif itemRarity == 0 then
						newItem.sortString = newItem.sortString .. BS_TRASH		
					end
					
					--finish the sort string, placing more important information
					--closer to the start of the string
					
					newItem.sortString = newItem.sortString .. itemType .. itemSubType .. itemEquipLoc .. itemID  .. itemName
					--print(newItem.sortString)
					newItem.count = count
					
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
		table.sort(group.itemList, function(a, b)
			if a.sortString < b.sortString then
				return true
			elseif a.sortString == b.sortString and a.count > b.count then
				return true
			end
		end)
		
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


local function CheckStacks(bagList)
	for slotNumIndex, slotNum in pairs(bagList) do
		for itemSlot = 1, GetContainerNumSlots(slotNum) do
			local texture, count, locked, quality, readable, lootable, itemLink, isFiltered, hasNoValue, itemID = GetContainerItemInfo(slotNum, itemSlot)
			if itemLink then
				local name, _, _, _, _, _, _, maxStack = GetItemInfo(itemID)
				
				if count < maxStack then -- 需要寻找可以堆的
					for slotNumIndex1, slotNum1 in pairs(bagList) do
						for itemSlot1 = 1, GetContainerNumSlots(slotNum1) do
							if (slotNum ~= slotNum1 or itemSlot ~= itemSlot1) and GetContainerItemLink(slotNum1, itemSlot1) == itemLink then
								local count1 = select(2, GetContainerItemInfo(slotNum1, itemSlot1))
								if count1 < maxStack then -- 找到一样的而且还没堆满
									return BS_delay
								end
							end
						end
					end
				end
			end
		end
	end
end

local function CleanStackItems(bagList, order, container)
	G.bag_sorting = true
	local delay = CheckStacks(bagList) or 0.1
	if delay > 0.1 then
		if container == "bank" then
			SortBankBags()
		elseif container == "reagents" then
			SortReagentBankBags()
		else
			SortBags()
		end
	end
	--print("total", delay)
	C_Timer.After(delay, function() sortBagRange(bagList, order) end)
	C_Timer.After(3, function() 
		G.bag_sorting = false
	end)
end

function T.BankSort(order)
	stackclean = false
	if order == 0 then
		CleanStackItems({11, 10, 9, 8, 7, 6, 5, -1}, 0, "bank")
	else
		CleanStackItems({-1, 5, 6, 7, 8, 9, 10, 11}, 1, "bank")
	end
end

function T.BagSort(order)
	stackclean = false
	if order == 0 then
		CleanStackItems({4, 3, 2, 1, 0}, 0, "bag")
	else
		CleanStackItems({0, 1, 2, 3, 4}, 1, "bag")
	end
end

function T.ReagentBankSort(order)
	stackclean = false
	if order == 0 then
		CleanStackItems({-3}, 0, "reagents")
	else
		CleanStackItems({-3}, 1, "reagents")
	end
end

local Core = CreateFrame("Frame", "Bag_Sort_Core")
Core:SetScript("OnLoad", BS_clearData)
Core:SetScript("OnUpdate", BS_OnUpdate)

local Tooltip = CreateFrame("GameTooltip", "BS_toolTip", UIParent, "GameTooltipTemplate")
