local T, C, L, G = unpack(select(2, ...))

local columns = 10
local bank_columns = 14
local space_x = 3
local space_y = 3
local title_height = 12

local classIDs = {
	[0] = true, -- Consumable
	[2] = true, -- Weapon
	[4] = true, -- Armor
	[5] = true, -- Reagent
	[7] = true, -- Tradegoods
	[19] = true, -- Profession
}

local classOrder = {0, 2, 4, 5, 7, 19}

local Items = {
	bag = {
		favoriteItems = {},
		newItems = {},
		classItems = {},
		otherItems = {},
		emptyButtons = {},
	},
	bank = {
		favoriteItems = {},
		classItems = {},
		otherItems = {},
		emptyButtons = {},
	},
}

--====================================================--
--[[                    -- API --                   ]]--
--====================================================--
local function SortItems(item1, item2)
	local bag1 = item1:GetBagID()
	local id1 = item1:GetID()
	local itemID1 = C_Container.GetContainerItemID(bag1, id1)	
	local subclassID1 = select(13, GetItemInfo(itemID1))
	
	local id2 = item2:GetID()
	local bag2 = item2:GetBagID()
	local itemID2 = C_Container.GetContainerItemID(bag2, id2)
	local subclassID2 = select(13, GetItemInfo(itemID2))
		
	if subclassID1 and subclassID2 and subclassID1 ~= subclassID2 then
		return subclassID1 > subclassID2
	end
	
	if bag1 ~= bag2 then
		return bag1 > bag2
	end
	
	return id1 > id2
end

local function CreateTitle(self, container_tag, str)
	local frame = self.title_frames[self.class_index]
	local isbank = container_tag == "bank"
	local y = isbank and -50 or -25
	
	if not frame then
		frame = CreateFrame("Frame", nil, self)
		frame:SetSize(isbank and 555 or 397, title_height)
		
		frame.text = T.createtext(frame, "OVERLAY", 10, "NONE", "LEFT")
		frame.text:SetPoint("LEFT", frame, "LEFT")
		frame.text:SetTextColor(.3, .3, .3)
		
		frame.tex = frame:CreateTexture(nil, "ARTWORK")
		frame.tex:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 1)
		frame.tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		frame.tex:SetColorTexture(.15, .15, .15)
		
		self.title_frames[self.class_index] = frame
	end
	
	frame:ClearAllPoints()
	if self.class_index == 1 then
		frame:SetPoint("TOPLEFT", self, "TOPLEFT", 18, y)
	else
		frame:SetPoint("TOPLEFT", self.anchor_button, "BOTTOMLEFT", 0, -2)
	end
	
	frame.text:SetText(str)
end

local function LayoutItemButtons(self, container_tag, itemButtons)
	local isbank = container_tag == "bank"
	local col = isbank and bank_columns or columns
	
	for i, bu in pairs(itemButtons) do
		bu:ClearAllPoints()
		if i == 1 then
			bu:SetPoint("TOPLEFT", self.title_frames[self.class_index], "BOTTOMLEFT", 0, -space_y)
			self.anchor_button = bu
			self.rows = self.rows + 1
		elseif i%col == 1 then
			bu:SetPoint("TOPLEFT", itemButtons[i-col], "BOTTOMLEFT", 0, -space_y)
			self.anchor_button = bu
			self.rows = self.rows + 1
		else
			bu:SetPoint("TOPLEFT", itemButtons[i-1], "TOPRIGHT", space_x, 0)
		end
	end
end

local function GridLayout(self, container_tag)
	if not self.title_frames then
		self.title_frames = {}
	end
	
	self.class_index = 0
	self.rows = 1
	
	if #Items[container_tag]["favoriteItems"] > 0 then
		self.class_index = self.class_index + 1
		CreateTitle(self, container_tag, L["收藏"])
		LayoutItemButtons(self, container_tag, Items[container_tag]["favoriteItems"])
	end
	
	if Items[container_tag]["newItems"] and #Items[container_tag]["newItems"] > 0 then
		self.class_index = self.class_index + 1
		CreateTitle(self, container_tag, L["新物品"])
		LayoutItemButtons(self, container_tag, Items[container_tag]["newItems"])
	end
	
	for i, classID in pairs(classOrder) do
		if Items[container_tag]["classItems"][classID] then
			self.class_index = self.class_index + 1
			CreateTitle(self, container_tag, GetItemClassInfo(classID))
			LayoutItemButtons(self, container_tag, Items[container_tag]["classItems"][classID])
		end
	end
	
	if #Items[container_tag]["otherItems"] + #Items[container_tag]["emptyButtons"] > 0 then
		local buttons = {}
		for i, bu in pairs(Items[container_tag]["otherItems"]) do
			table.insert(buttons, bu)
		end
		for i, bu in pairs(Items[container_tag]["emptyButtons"]) do
			table.insert(buttons, bu)
		end
		self.class_index = self.class_index + 1
		CreateTitle(self, container_tag, OTHER)
		LayoutItemButtons(self, container_tag, buttons)		
	end
	
	for i = self.class_index + 1, #self.title_frames do
		self.title_frames[i]:Hide()
	end
end

local function CalculateHeight(self, container_tag)
	local isbank = container_tag == "bank"
	local titles = self.class_index or 1
	local titlesHeight = titles*(title_height+space_y)
	
	local itemButton = isbank and self.Item1 or self.Items[1]
	local itemsHeight = (self.rows * itemButton:GetHeight()) + ((self.rows - 1) * space_y)

	return itemsHeight + titlesHeight + (isbank and 70 or self:CalculateExtraHeight())
end

local function CalculateWidth(self, container_tag)
	local isbank = container_tag == "bank"
	local col = isbank and bank_columns or columns
	
	local itemButton = isbank and self.Item1 or self.Items[1]
	local itemsWidth = (col * itemButton:GetWidth()) + ((col - 1) * 5)

	return itemsWidth + 15
end

local function InitItemsData(container_tag)
	for k, v in pairs(Items[container_tag]) do
		Items[container_tag][k] = table.wipe(Items[container_tag][k])
	end
end

local function SortButton(container_tag, bu)
	local bagID = bu:GetBagID()
	local buttonID = bu:GetID()
	local itemID = C_Container.GetContainerItemID(bagID, buttonID)
	bu:SetSize(aCoreCDB["ItemOptions"]["bagbuttonsize"], aCoreCDB["ItemOptions"]["bagbuttonsize"])
	
	if itemID then
		if aCoreCDB and aCoreCDB["ItemOptions"]["favoriteitemIDs"][itemID] then				
			table.insert(Items[container_tag].favoriteItems, bu)
		elseif container_tag == "bag" and C_NewItems.IsNewItem(bagID, buttonID) then
			table.insert(Items[container_tag].newItems, bu)			
		else
			local itemQuality = select(3, GetItemInfo(itemID))
			local classID = select(12, GetItemInfo(itemID))
			if itemQuality == 0 then
				table.insert(Items[container_tag].otherItems, bu)
			elseif classIDs[classID] then
				if not Items[container_tag]["classItems"][classID] then
					Items[container_tag]["classItems"][classID] = {}
				end
				table.insert(Items[container_tag]["classItems"][classID], bu)
			else
				table.insert(Items[container_tag].otherItems, bu)
			end
		end
	else	
		table.insert(Items[container_tag].emptyButtons, bu)
	end
end

local function SortItemsData(container_tag)
	for k, v in pairs(Items[container_tag]) do
		if k == "classItems" then
			for classID, buttons in pairs(Items[container_tag][k]) do
				table.sort(buttons, SortItems)
			end
		elseif k ~= "emptyButtons" then
			table.sort(Items[container_tag][k], SortItems)
		end
	end
end
--====================================================--
--[[                   -- 背包 --                   ]]--
--====================================================--

for k, v in pairs({ContainerFrameCombinedBags:GetChildren()}) do
	local object_type = v:GetObjectType()
	if object_type == "Button" and v.routeToSibling then
		v:Hide()
	end
end

hooksecurefunc(ContainerFrameCombinedBags, "UpdateItemLayout", function(self)
	InitItemsData("bag")
	
	for i, bu in self:EnumerateValidItems() do
		SortButton("bag", bu)
	end
	
	SortItemsData("bag")
	GridLayout(self, "bag")	
	self:SetSize(CalculateWidth(self, "bag"), CalculateHeight(self, "bag"))
end)

local function UpdateFavoriteItem()
	if CursorHasItem() then
		local item = C_Cursor.GetCursorItem()
		if item then
			local itemID = C_Item.GetItemID(item)
			if aCoreCDB["ItemOptions"]["favoriteitemIDs"][itemID] then
				aCoreCDB["ItemOptions"]["favoriteitemIDs"][itemID] = nil
			else
				aCoreCDB["ItemOptions"]["favoriteitemIDs"][itemID] = true
			end
			ToggleBackpack_Combined()
			ToggleBackpack_Combined()
			ClearCursor()
		end
	end
end

hooksecurefunc(ContainerFrameCombinedBags, "UpdateSearchBox", function(self)
	if self:IsBackpack() or self:IsCombinedBagContainer() then
		self.PortraitButton:SetSize(18, 18)
		self.PortraitButton:ClearAllPoints()
		self.PortraitButton:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -5)
		
		if self.bagIcon then
			self.bagIcon:SetAllPoints(self.PortraitButton)
		end
		
		BagItemAutoSortButton:ClearAllPoints()
		BagItemAutoSortButton:SetPoint("LEFT", self.PortraitButton, "RIGHT", 5, 0)
		BagItemAutoSortButton:SetSize(18, 18)

		if not self.addFavorite then
			local button = CreateFrame("Button", nil, self)
			button:SetPoint("LEFT", BagItemAutoSortButton, "RIGHT", 5, 0)
			button:SetSize(16, 16)
			T.createTexBackdrop(button)
			
			local tex = button:CreateTexture(nil, "ARTWORK")
			tex:SetAllPoints(button)
			tex:SetTexture(135453)
			tex:SetTexCoord(.1, .9, .1, .9)
			
			button:SetScript("OnEnter", function(self) 
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
				GameTooltip:AddLine(L["加入收藏"])
				GameTooltip:Show() 
			end)
			
			button:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			
			button:SetScript("OnClick", UpdateFavoriteItem)

			self.addFavorite = button
		end
		
		BagItemSearchBox:ClearAllPoints()
		BagItemSearchBox:SetPoint("TOPLEFT", self.addFavorite, "TOPRIGHT", 10, 0)
		BagItemSearchBox:SetWidth(320)
	end
end)

hooksecurefunc(ContainerFrameCombinedBags, "UpdateName", function(self)
	self:SetTitle("")
end)

hooksecurefunc("UpdateContainerFrameAnchors", function()
	ContainerFrameCombinedBags:ClearAllPoints()
	ContainerFrameCombinedBags:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -12, 17)
end)