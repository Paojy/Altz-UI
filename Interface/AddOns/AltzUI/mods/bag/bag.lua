local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- 背包分类 --                 ]]--
--====================================================--

local columns, space_x, space_y, title_height = 10, 3, 3, 12

local classIDs = {
	[0] = true, -- Consumable
	[2] = true, -- Weapon
	[4] = true, -- Armor
	[5] = true, -- Reagent
	[7] = true, -- Tradegoods
	[19] = true, -- Profession
}

local classOrder = {0, 2, 4, 5, 7, 19}

local favoriteItems = {}
local classItems = {}
local otherItems = {}
local emptyButtons = {}

for k, v in pairs({ContainerFrameCombinedBags:GetChildren()}) do
	local object_type = v:GetObjectType()
	if object_type == "Button" and v.routeToSibling then
		v:Hide()
	end
end

local function SortItems(item1, item2)
	local bag1 = item1:GetBagID()
	local id1 = item1:GetID()
	local itemID1 = C_Container.GetContainerItemID(bag1, id1)	
	local subclassID1 = select(13, GetItemInfo(itemID1))
	
	local id2 = item2:GetID()
	local bag2 = item2:GetBagID()
	local itemID2 = C_Container.GetContainerItemID(bag2, id2)
	local subclassID2 = select(13, GetItemInfo(itemID2))
		
	if subclassID1 ~= subclassID2 then
		return subclassID1 > subclassID2
	end
	
	if bag1 ~= bag2 then
		return bag1 > bag2
	end
	
	return id1 > id2
end

local function CreateTitle(self, str)
	local frame = self.title_frames[self.class_index]
	
	if not frame then
		frame = CreateFrame("Frame", nil, self)
		frame:SetSize(self:GetWidth()-33, title_height)
		
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
		frame:SetPoint("TOPLEFT", self, "TOPLEFT", 18, -25)
	else
		frame:SetPoint("TOPLEFT", self.anchor_button, "BOTTOMLEFT", 0, -2)
	end
	
	frame.text:SetText(str)
end

local function LayoutItemButtons(self, itemButtons)
	for i, bu in pairs(itemButtons) do
		bu:ClearAllPoints()
		if i == 1 then
			bu:SetPoint("TOPLEFT", self.title_frames[self.class_index], "BOTTOMLEFT", 0, -space_y)
			self.anchor_button = bu
			self.rows = self.rows + 1
		elseif i%columns == 1 then
			bu:SetPoint("TOPLEFT", itemButtons[i-columns], "BOTTOMLEFT", 0, -space_y)
			self.anchor_button = bu
			self.rows = self.rows + 1
		else
			bu:SetPoint("TOPLEFT", itemButtons[i-1], "TOPRIGHT", space_x, 0)
		end
	end
end

local function GridLayout(self, favoriteItems, classItems, otherItems, emptyButtons)	
	if not self.title_frames then
		self.title_frames = {}
	end
	
	self.class_index = 0
	self.rows = 1
	
	if #favoriteItems > 0 then
		self.class_index = self.class_index + 1
		CreateTitle(self, L["收藏"])
		LayoutItemButtons(self, favoriteItems)
	end
	
	for i, classID in pairs(classOrder) do
		if classItems[classID] then
			self.class_index = self.class_index + 1
			CreateTitle(self, GetItemClassInfo(classID))
			LayoutItemButtons(self, classItems[classID])
		end
	end
	
	if #otherItems + #emptyButtons > 0 then
		local buttons = {}
		for i, bu in pairs(otherItems) do
			table.insert(buttons, bu)
		end
		for i, bu in pairs(emptyButtons) do
			table.insert(buttons, bu)
		end
		self.class_index = self.class_index + 1
		CreateTitle(self, OTHER)
		LayoutItemButtons(self, buttons)		
	end
	
	for i = self.class_index + 1, #self.title_frames do
		self.title_frames[i]:Hide()
	end
end

local function CalculateHeight(self)
	local rows = self.rows or math.ceil(self:GetBagSize() / self:GetColumns())
	
	local titles = self.class_index or 1
	local titlesHeight = titles*(title_height+space_y)
	
	local itemButton = self.Items[1]
	local itemsHeight = (rows * itemButton:GetHeight()) + ((rows - 1) * space_y)

	return itemsHeight + titlesHeight + self:CalculateExtraHeight()
end

local function CalculateWidth(self)
	local columns = self:GetColumns()
	
	local itemButton = self.Items[1]
	local itemsWidth = (columns * itemButton:GetWidth()) + ((columns - 1) * 5)

	return itemsWidth + self:GetPaddingWidth()
end

hooksecurefunc(ContainerFrameCombinedBags, "UpdateItemLayout", function(self)
	favoriteItems = table.wipe(favoriteItems)
	classItems = table.wipe(classItems)
	otherItems = table.wipe(otherItems)
	emptyButtons = table.wipe(emptyButtons)
	
	for i, bu in self:EnumerateValidItems() do
		local bagID = bu:GetBagID()
		local buttonID = bu:GetID()
		local itemID = C_Container.GetContainerItemID(bagID, buttonID)
		bu:SetSize(aCoreCDB["ItemOptions"]["bagbuttonsize"], aCoreCDB["ItemOptions"]["bagbuttonsize"])
		
		if itemID then
			if aCoreCDB and aCoreCDB["ItemOptions"]["favoriteitemIDs"][itemID] then				
				table.insert(favoriteItems, bu)
			else
				local itemQuality = select(3, GetItemInfo(itemID))
				local classID = select(12, GetItemInfo(itemID))
				if itemQuality == 0 then
					table.insert(otherItems, bu)
				elseif classIDs[classID] then
					if not classItems[classID] then
						classItems[classID] = {}
					end
					table.insert(classItems[classID], bu)
				else
					table.insert(otherItems, bu)
				end
			end
		else
			table.insert(emptyButtons, bu)
		end
	end
	
	table.sort(favoriteItems, SortItems)
	table.sort(otherItems, SortItems)
	
	for classID, buttons in pairs(classItems) do
		table.sort(buttons, SortItems)
	end
	
	GridLayout(self, favoriteItems, classItems, otherItems, emptyButtons)
	
	self:SetSize(CalculateWidth(self), CalculateHeight(self))
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
		self.bagIcon:SetSize(18, 18)
		self.bagIcon:ClearAllPoints()
		self.bagIcon:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -5)
		
		self.PortraitButton:SetAllPoints(self.bagIcon)
		
		BagItemAutoSortButton:ClearAllPoints()
		BagItemAutoSortButton:SetPoint("LEFT", self.bagIcon, "RIGHT", 5, 0)
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