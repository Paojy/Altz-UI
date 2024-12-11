local T, C, L, G = unpack(select(2, ...))

local knowncolor = { r = 0.1, g = 1.0, b = 0.2 }

-- merchant frame
local function IsMerchantItemAlreadyKnown(index)
	for _, v in pairs(C_TooltipInfo.GetMerchantItem(index)["lines"]) do
		if v.leftText and v.leftText == ITEM_SPELL_KNOWN then
			return true
		end
	end
end

local function MerchantFrame_UpdateMerchantInfo()
	local numItems = GetMerchantNumItems()

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if ( index > numItems ) then
			return
		end

		local button = _G['MerchantItem' .. i .. 'ItemButton']

		if ( button and button:IsShown() ) then
			local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)
			
			if ( isUsable and IsMerchantItemAlreadyKnown(index) ) then
				local r, g, b = knowncolor.r, knowncolor.g, knowncolor.b
				
				if ( numAvailable == 0 ) then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end

				SetItemButtonTextureVertexColor(button, r, g, b)
			end
		end
	end
end

hooksecurefunc('MerchantFrame_UpdateMerchantInfo', MerchantFrame_UpdateMerchantInfo)

local function IsBuyBackItemAlreadyKnown(index)
	for _, v in pairs(C_TooltipInfo.GetBuybackItem(index)["lines"]) do
		if v.leftText and v.leftText == ITEM_SPELL_KNOWN then
			return true
		end
	end
end

local function MerchantFrame_UpdateBuybackInfo ()
	local numItems = GetNumBuybackItems()

	for index = 1, BUYBACK_ITEMS_PER_PAGE do
		if ( index > numItems ) then
			return
		end

		local button = _G['MerchantItem' .. index .. 'ItemButton']

		if ( button and button:IsShown() ) then
			local _, _, _, _, _, isUsable = GetBuybackItemInfo(index)

			if ( isUsable and IsBuyBackItemAlreadyKnown(index) ) then
				SetItemButtonTextureVertexColor(button, knowncolor.r, knowncolor.g, knowncolor.b)
			end
		end
	end
end

hooksecurefunc('MerchantFrame_UpdateBuybackInfo', MerchantFrame_UpdateBuybackInfo)

-- auction frame
local function IsItemAlreadyKnownbyID(itemID)
	for _, v in pairs(C_TooltipInfo.GetItemByID(itemID)["lines"]) do
		if v.leftText and v.leftText == ITEM_SPELL_KNOWN then
			return true
		end
	end
end

local function AuctionFrameBrowse_Update ()
	for i = 1, 22 do
		local row = AuctionHouseFrame.BrowseResultsFrame.ItemList.tableBuilder.rows[i]
		if row then
			for j = 1, 4 do
				local cell = row.cells and row.cells[j]
				if cell and cell.Icon then
					if IsItemAlreadyKnownbyID(cell.rowData.itemKey.itemID) then
						cell.Icon:SetVertexColor(knowncolor.r, knowncolor.g, knowncolor.b)
					else
						cell.Icon:SetVertexColor(1, 1, 1)
					end
				end
			end
		end
	end
end

local event_frame = CreateFrame("Frame")

event_frame:SetScript('OnEvent', function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...
		
		if addonName == 'Blizzard_AuctionHouseUI' then
			hooksecurefunc(AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox, 'Update', AuctionFrameBrowse_Update)			
			self:UnregisterEvent(event)
		end		
	end	
end)

event_frame:RegisterEvent('ADDON_LOADED')
