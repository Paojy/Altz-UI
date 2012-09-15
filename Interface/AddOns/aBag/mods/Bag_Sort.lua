--================
--GLOBAL VARIABLES
--================

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

--bag group definitions
BS_bagGroups = {}
	
--grid of item data based on destination inventory location
BS_itemSwapGrid = {}
					
BS_sorting = false     --indicates bag rearrangement is in progress
BS_pauseRemaining = 0  --how much longer to wait before running the OnUpdate code again
    
--========================

--INTERFACE EVENT HANDLERS

--========================

function BS_OnLoad()

	--register slash commands
	SlashCmdList["BSbagsort"] = BS_slashBagSortHandler
  	SLASH_BSbagsort1 = '/bs'

	SlashCmdList["BSbanksort"] = BS_slashBankSortHandler
  	SLASH_BSbanksort1 = '/bks'

	--initialize data
	BS_clearData()
end

function BS_OnUpdate(parentFrame, tElapsed)

	--if true then return end

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

function BS_slashBankSortHandler()
	sortBagRange({-1, 5, 6, 7, 8, 9, 10, 11})
end

function BS_slashBagSortHandler()

	sortBagRange({0, 1, 2, 3, 4})
end

function sortBagRange(bagList)

	--clear any data from previous sorts
	BS_clearData()
	local family

	--assign bags to bag groups
	for slotNumIndex, slotNum in pairs(bagList) do
	
		--if bag exists
		if GetContainerNumSlots(slotNum) > 0 then
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
					newItem.name = itemName
					
					--determine category
					
					--soulbound items
                   	local tooltip = getglobal("BS_toolTip")
					local owner = getglobal("Bag_Sort_Core")
                    tooltip:SetOwner(owner, ANCHOR_NONE)
					tooltip:ClearLines()
					tooltip:SetBagItem(bagSlot, itemSlot)
					local tooltipLine2 = getglobal("BS_toolTipTextLeft2"):GetText()
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
		--say(group.keywords[1])
		for index, item in pairs(group.itemList) do
		
			local gridSlot = index
		
   			--record items in a grid according to their intended final placement
			for bagSlotNumberIndex, bagSlotNumber in pairs(group.bagSlotNumbers) do
		
				if gridSlot <= GetContainerNumSlots(bagSlotNumber) then
				
					BS_itemSwapGrid[item.startBag][item.startSlot].destinationBag  = bagSlotNumber
					BS_itemSwapGrid[item.startBag][item.startSlot].destinationSlot = gridSlot
					--say(BS_itemSwapGrid[item.startBag][item.startSlot].sortString .. bagSlotNumber .. ' ' .. gridSlot)
					break

				else
				
					gridSlot = gridSlot - GetContainerNumSlots(bagSlotNumber)
					
				end
	
	        end
	
	    end
	
	end
	
	--signal for sorting to begin
	BS_sorting = true
	
end

--=================

--UTILITY FUNCTIONS

--=================

function BS_clearData()
 	BS_itemSwapGrid = {}
	BS_bagGroups = {}
end

function say(text)

  DEFAULT_CHAT_FRAME:AddMessage(text)

end