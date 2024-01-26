local T, C, L, G = unpack(select(2, ...))

local knowncolor = { r = 0.1, g = 1.0, b = 0.2 }
local tooltip = CreateFrame('GameTooltip')
tooltip:SetOwner(WorldFrame, 'ANCHOR_NONE')

local IsAlreadyKnown
do
	local knowns = {}

	-- things we have to care. please let me know if any lack or surplus here.
	local consumable, glyph, recipe, miscallaneous = AUCTION_CATEGORY_CONSUMABLES, AUCTION_CATEGORY_GLYPHS, AUCTION_CATEGORY_RECIPES, AUCTION_CATEGORY_MISCELLANEOUS
	local knowables = { [consumable] = true, [glyph] = true, [recipe] = true, [miscallaneous] = true, }

	local lines = {}
	for i = 1, 40 do
		lines[i] = tooltip:CreateFontString()
		tooltip:AddFontStrings(lines[i], tooltip:CreateFontString())
	end

	function IsAlreadyKnown (itemLink)
		if not aCoreCDB["ItemOptions"]["alreadyknown"] then return end
		if ( not itemLink ) then
			return
		end

		local itemID = itemLink:match('item:(%d+):')
		if ( knowns[itemID] ) then
			return true
		end

		local _, _, _, _, _, itemType = GetItemInfo(itemLink)
		if ( not knowables[itemType] ) then
			return
		end

		tooltip:ClearLines()
		if tooltip.SetHyperlink then
			tooltip:SetHyperlink(itemLink)
		end
		
		for i = 1, tooltip:NumLines() do
			if ( lines[i]:GetText() == ITEM_SPELL_KNOWN ) then
				knowns[itemID] = true
				return true
			end
		end
	end
end


-- merchant frame

local function MerchantFrame_UpdateMerchantInfo ()
	local numItems = GetMerchantNumItems()

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if ( index > numItems ) then
			return
		end

		local button = _G['MerchantItem' .. i .. 'ItemButton']

		if ( button and button:IsShown() ) then
			local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)

			if ( isUsable and IsAlreadyKnown(GetMerchantItemLink(index)) ) then
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

local function MerchantFrame_UpdateBuybackInfo ()
	local numItems = GetNumBuybackItems()

	for index = 1, BUYBACK_ITEMS_PER_PAGE do
		if ( index > numItems ) then
			return
		end

		local button = _G['MerchantItem' .. index .. 'ItemButton']

		if ( button and button:IsShown() ) then
			local _, _, _, _, _, isUsable = GetBuybackItemInfo(index)

			if ( isUsable and IsAlreadyKnown(GetBuybackItemLink(index)) ) then
				SetItemButtonTextureVertexColor(button, knowncolor.r, knowncolor.g, knowncolor.b)
			end
		end
	end
end

hooksecurefunc('MerchantFrame_UpdateBuybackInfo', MerchantFrame_UpdateBuybackInfo)


-- guild bank frame

local function GuildBankFrame_Update ()
	if ( GuildBankFrame.mode ~= 'bank' ) then
		return
	end

	local tab = GetCurrentGuildBankTab()

	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local button = _G['GuildBankColumn' .. math.ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP) .. 'Button' .. math.fmod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)]

		if ( button and button:IsShown() ) then
			local texture, _, locked = GetGuildBankItemInfo(tab, i)

			if ( texture and not locked ) then
				if ( IsAlreadyKnown(GetGuildBankItemLink(tab, i)) ) then
					SetItemButtonTextureVertexColor(button, knowncolor.r, knowncolor.g, knowncolor.b)
				else
					SetItemButtonTextureVertexColor(button, 1, 1, 1)
				end
			end
		end
	end
end

local isBlizzard_GuildBankUILoaded
if ( IsAddOnLoaded('Blizzard_GuildBankUI') ) then
	isBlizzard_GuildBankUILoaded = true

	hooksecurefunc('GuildBankFrame_Update', GuildBankFrame_Update)
end


-- auction frame

local function AuctionFrameBrowse_Update ()
	local numItems = GetNumAuctionItems('list')
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		local index = offset + i
		if ( index > numItems ) then
			return
		end

		local texture = _G['BrowseButton' .. i .. 'ItemIconTexture']

		if ( texture and texture:IsShown() ) then
			local _, _, _, _, canUse =  GetAuctionItemInfo('list', index)

			if ( canUse and IsAlreadyKnown(GetAuctionItemLink('list', index)) ) then
				texture:SetVertexColor(knowncolor.r, knowncolor.g, knowncolor.b)
			end
		end
	end
end

local function AuctionFrameBid_Update ()
	local numItems = GetNumAuctionItems('bidder')
	local offset = FauxScrollFrame_GetOffset(BidScrollFrame)

	for i = 1, NUM_BIDS_TO_DISPLAY do
		local index = offset + i
		if ( index > numItems ) then
			return
		end

		local texture = _G['BidButton' .. i .. 'ItemIconTexture']

		if ( texture and texture:IsShown() ) then
			local _, _, _, _, canUse =  GetAuctionItemInfo('bidder', index)

			if ( canUse and IsAlreadyKnown(GetAuctionItemLink('bidder', index)) ) then
				texture:SetVertexColor(knowncolor.r, knowncolor.g, knowncolor.b)
			end
		end
	end
end

local function AuctionFrameAuctions_Update ()
	local numItems = GetNumAuctionItems('owner')
	local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		local index = offset + i
		if ( index > numItems ) then
			return
		end

		local texture = _G['AuctionsButton' .. i .. 'ItemIconTexture']

		if ( texture and texture:IsShown() ) then
			local _, _, _, _, canUse, _, _, _, _, _, _, _, saleStatus = GetAuctionItemInfo('owner', index)

			if ( canUse and IsAlreadyKnown(GetAuctionItemLink('owner', index)) ) then
				local r, g, b = knowncolor.r, knowncolor.g, knowncolor.b
				if ( saleStatus == 1 ) then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end

				texture:SetVertexColor(r, g, b)
			end
		end
	end
end

local isBlizzard_AuctionUILoaded
if ( IsAddOnLoaded('Blizzard_AuctionUI') ) then
	isBlizzard_AuctionUILoaded = true

	hooksecurefunc('AuctionFrameBrowse_Update', AuctionFrameBrowse_Update)
	hooksecurefunc('AuctionFrameBid_Update', AuctionFrameBid_Update)
	hooksecurefunc('AuctionFrameAuctions_Update', AuctionFrameAuctions_Update)
end

-- for LoD addons

if ( not (isBlizzard_GuildBankUILoaded and isBlizzard_AuctionUILoaded) ) then
	local function OnEvent (self, event, addonName)
		if ( addonName == 'Blizzard_GuildBankUI' ) then
			isBlizzard_GuildBankUILoaded = true

			hooksecurefunc('GuildBankFrame_Update', GuildBankFrame_Update)
		elseif ( addonName == 'Blizzard_AuctionUI' ) then
			isBlizzard_AuctionUILoaded = true

			hooksecurefunc('AuctionFrameBrowse_Update', AuctionFrameBrowse_Update)
			hooksecurefunc('AuctionFrameBid_Update', AuctionFrameBid_Update)
			hooksecurefunc('AuctionFrameAuctions_Update', AuctionFrameAuctions_Update)
		end

		if ( isBlizzard_GuildBankUILoaded and isBlizzard_AuctionUILoaded ) then
			self:UnregisterEvent(event)
			self:SetScript('OnEvent', nil)
			OnEvent = nil
		end
	end

	tooltip:SetScript('OnEvent', OnEvent)
	tooltip:RegisterEvent('ADDON_LOADED')
end
