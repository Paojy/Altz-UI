local addon, ns = ...
local L = ns.L

local config = {
	enable = 1,
	spacing = 4,
	bpr = 10,
	bapr = 16,
	size = 28,
	scale = 1,
}

if (config.enable ~= 1) then return end

-- bug fix
UpdateContainerFrameAnchors = function() end

local function Kill(object)
	if object.IsProtected then 
		if object:IsProtected() then
			error("Attempted to kill a protected object: <"..object:GetName()..">")
		end
	end
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = function() return end
	object:Hide()
end

local bags = {
	bag = {
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot
	},
	bank = {
		BankFrameBag1,
		BankFrameBag2,
		BankFrameBag3,
		BankFrameBag4,
		BankFrameBag5,
		BankFrameBag6,
		BankFrameBag7
	}
}

function SetUp(framen, ...)
	local frame = CreateFrame("Frame", "aBag_"..framen, UIParent)
	frame:SetScale(config.scale)
	if framen == "bag" then 
		frame:SetWidth(((config.size+config.spacing)*config.bpr)+10-config.spacing)
		frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -18, 20)
	else
		frame:SetWidth(((config.size+config.spacing)*config.bapr)+16-config.spacing)
		frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 85)
	end
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(1)

	frame:Hide()
	
	creategrowBD(frame, 0, 0, 0, 0.4, 1)
	
	frame:SetClampedToScreen(true)
    frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton","RightButton")
	frame:SetScript("OnDragStart", function(self) self:StartMoving() frame:SetUserPlaced(false) end)
	frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	local frame_bags = CreateFrame('Frame', "aBag_"..framen.."_bags")
	frame_bags:SetParent("aBag_"..framen)
	frame_bags:SetSize(10, 10)
	frame_bags:SetPoint("BOTTOMRIGHT", "aBag_"..framen, "TOPRIGHT", 0, 18)
	frame_bags:Hide()
	creategrowBD(frame_bags, 0, 0, 0, 0.4, 1)
	
	local frame_bags_toggle = CreateFrame('Frame')
	frame_bags_toggle:SetParent("aBag_"..framen)
	frame_bags_toggle:SetSize(13, 13)
	frame_bags_toggle:SetPoint("TOPRIGHT", "aBag_"..framen, "TOPRIGHT", -28, -5)
	frame_bags_toggle:EnableMouse(true)
	
	local frame_bags_toggle_text = createtext(frame_bags_toggle, "OVERLAY", 12, "OUTLINE", "RIGHT")
	frame_bags_toggle_text:SetAllPoints()
	frame_bags_toggle_text:SetText(L["Bag"])
	frame_bags_toggle_text:SetTextColor(.4, .4, .4)
	frame_bags_toggle:SetScript('OnMouseUp', function()
		if not frame_bags:IsShown() then
			frame_bags:Show()
		else
			frame_bags:Hide()
		end
	end)
	frame_bags_toggle:SetScript('OnEnter', function() frame_bags_toggle_text:SetTextColor(1, 1, 1) end)
	frame_bags_toggle:SetScript('OnLeave', function() frame_bags_toggle_text:SetTextColor(.4, .4,.4) end)
	
	local bagsort = CreateFrame('Frame')
	bagsort:SetParent("aBag_"..framen)
	bagsort:SetSize(13, 13)
	bagsort:SetPoint("LEFT", frame_bags_toggle, "RIGHT", -2, 0)
	bagsort:EnableMouse(true)
	
	local bagsortt = createtext(bagsort, "OVERLAY", 12, "OUTLINE", "RIGHT")
	bagsortt:SetAllPoints()
	bagsortt:SetText(L["Sort"])
	bagsortt:SetTextColor(.4, .4, .4)
	bagsort:SetScript('OnMouseUp', function()
		if framen == "bag" then
			BS_slashBagSortHandler()
		else
			BS_slashBankSortHandler()
		end
	end)
	bagsort:SetScript('OnEnter', function() bagsortt:SetTextColor(1, 1, 1) end)
	bagsort:SetScript('OnLeave', function() bagsortt:SetTextColor(.4, .4, .4) end)
	
	local close = CreateFrame('Frame')
	close:SetParent("aBag_"..framen)
	close:SetSize(13, 13)
	close:SetPoint("LEFT", bagsort, "RIGHT", 0, 0)
	close:EnableMouse(true)
	
	local closet = createtext(close, "OVERLAY", 12, "OUTLINE", "RIGHT")
	closet:SetAllPoints()
	closet:SetText("X")
	closet:SetTextColor(.4, .4, .4)
	close:SetScript('OnMouseUp', function()
		if framen == "bag" then
			ToggleAllBags()
		else
			CloseBankFrame()
		end
	end)
	close:SetScript('OnEnter', function() closet:SetTextColor(1, 1, 1) end)
	close:SetScript('OnLeave', function() closet:SetTextColor(.4, .4, .4) end)
	
	if (framen == "bag") then
		for _, f in pairs(bags.bag) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["aBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbag then
				f:SetPoint("LEFT", lastbuttonbag, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["aBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()
			icon:SetTexCoord(.1, .9, .1, .9)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetCheckedTexture("")
			lastbuttonbag = f
			_G["aBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bag))+14)
			_G["aBag_"..framen.."_bags"]:SetHeight(40)
		end
	else
		for _, f in pairs(bags.bank) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["aBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbank then
				f:SetPoint("LEFT", lastbuttonbank, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["aBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()
			icon:SetTexCoord(.06, .94, .06, .94)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetHighlightTexture("")
			lastbuttonbank = f
			_G["aBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bank))+14)
			_G["aBag_"..framen.."_bags"]:SetHeight(40)
		end
	end
end

local function skin(index, frame)
      for i = 1, index do
        local bag = _G[frame..i]
		local f = _G[bag:GetName().."IconTexture"]
        bag:SetNormalTexture("")
        bag:SetPushedTexture("")
		createpxBD(bag, 0.7, 1)
        f:SetPoint("TOPLEFT", bag, 1, -1)
		f:SetPoint("BOTTOMRIGHT", bag, -1, 1)
        f:SetTexCoord(.1, .9, .1, .9)
		bag.border = bag
    end
end

for i = 1, 12 do
	_G["ContainerFrame"..i..'CloseButton']:Hide()
	_G["ContainerFrame"..i..'PortraitButton']:Hide()
	_G["ContainerFrame"..i]:EnableMouse(false)
	skin(36, "ContainerFrame"..i.."Item")
	for p = 1, 7 do
		select(p, _G["ContainerFrame"..i]:GetRegions()):SetAlpha(0)
    end
end

ContainerFrame1Item1:SetScript("OnHide", function() 
	_G["aBag_bag"]:Hide()
end)

BankFrameItem1:SetScript("OnHide", function() 
	_G["aBag_bank"]:Hide()
end)

BankFrameItem1:SetScript("OnShow", function() 
	_G["aBag_bank"]:Show()
end)

for a = 1, 80 do
	select(a, BankFrame:GetRegions()):Hide()
end

BankFrame:EnableMouse(0)
BankFrame:SetSize(0,0)

SetUp("bag", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 100)
SetUp("bank", "TOPLEFT", UIParent, "TOPLEFT", 100, -50)
skin(28, "BankFrameItem")
skin(7, "BankFrameBag")

BagItemSearchBox:SetScript("OnUpdate", function()
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetSize(5*(config.spacing+config.size)-3, 14)
	BagItemSearchBox:SetPoint("LEFT", ContainerFrame1MoneyFrame, "RIGHT", -3, 0)
end)

BankItemSearchBox:SetScript("OnUpdate", function()
	BankItemSearchBox:ClearAllPoints()
	BankItemSearchBox:SetSize(5*(config.spacing+config.size)-3, 14)
	BankItemSearchBox:SetPoint("LEFT", ContainerFrame2MoneyFrame, "RIGHT", -3, 0)
end)

function SkinEditBox(frame)
	if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Hide() end
	if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Hide() end
	if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Hide() end
	if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Hide() end
	
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(2)
	frame:SetWidth(200)
	createpxBD(frame, 0.5, 1)
end

SkinEditBox(BagItemSearchBox)
SkinEditBox(BankItemSearchBox)

-- Centralize and rewrite bag rendering function
function ContainerFrame_GenerateFrame(frame, size, id)
	frame.size = size;
	for i=1, size, 1 do
		local index = size - i + 1;
		local itemButton = _G[frame:GetName().."Item"..i];
		itemButton:SetID(index);
		itemButton:Show();
	end
	frame:SetID(id);
	frame:Show()
	updateContainerFrameAnchors();
	
	local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
	for bag = 1, 5 do
		local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(config.size)
				itemframes:SetHeight(config.size)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				ContainerFrame1MoneyFrame:ClearAllPoints()
				ContainerFrame1MoneyFrame:SetScale(.7)
				ContainerFrame1MoneyFrame:Show()
				ContainerFrame1MoneyFrame:SetPoint("TOPLEFT", _G["aBag_bag"], "TOPLEFT", 8, -10)
				ContainerFrame1MoneyFrame:SetFrameStrata("HIGH")
				ContainerFrame1MoneyFrame:SetFrameLevel(2)
				if bag==1 and item==16 then
					itemframes:SetPoint("TOPLEFT", _G["aBag_bag"], "TOPLEFT", 5, -30)
					lastrowbutton = itemframes
					lastbutton = itemframes
				elseif numbuttons==config.bpr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["aBag_bag"]:SetHeight(((config.size+config.spacing)*(numrows+1)+40)-config.spacing)
	local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
		for bank = 1, 28 do
			local bankitems = _G["BankFrameItem"..bank]
			bankitems:ClearAllPoints()
			bankitems:SetWidth(config.size)
			bankitems:SetHeight(config.size)
			bankitems:SetFrameStrata("HIGH")
			bankitems:SetFrameLevel(2)
			ContainerFrame2MoneyFrame:Show()
			ContainerFrame2MoneyFrame:ClearAllPoints()
			ContainerFrame2MoneyFrame:SetScale(.7)
			ContainerFrame2MoneyFrame:SetPoint("TOPLEFT", _G["aBag_bank"], "TOPLEFT", 8, -10)
			ContainerFrame2MoneyFrame:SetFrameStrata("HIGH")
			ContainerFrame2MoneyFrame:SetFrameLevel(2)
			ContainerFrame2MoneyFrame:SetParent(_G["aBag_bank"])
			BankFrameMoneyFrame:Hide()
			if bank==1 then
				bankitems:SetPoint("TOPLEFT", _G["aBag_bank"], "TOPLEFT", 8, -30)
				lastrowbutton = bankitems
				lastbutton = bankitems
			elseif numbuttons==config.bapr then
				bankitems:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
				bankitems:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
				lastrowbutton = bankitems
				numrows = numrows + 1
				numbuttons = 1
			else
				bankitems:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
				bankitems:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = bankitems
		end
		for bag = 6, 12 do
			local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(config.size)
				itemframes:SetHeight(config.size)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				if numbuttons==config.bapr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+config.size))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+config.size))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+config.size), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+config.size), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["aBag_bank"]:SetHeight(((config.size+config.spacing)*(numrows+1)+40)-config.spacing)
	end
function updateContainerFrameAnchors() end

function ToggleAllBags()
	if (not UIParent:IsShown()) then return end

	local bagsOpen = 0
	local totalBags = 1
	if ( IsBagOpen(0) ) then
		bagsOpen = bagsOpen +1
		CloseBackpack()
	end

	for i=1, NUM_BAG_FRAMES, 1 do
		if ( GetContainerNumSlots(i) > 0 ) then		
			totalBags = totalBags +1
		end
		if ( IsBagOpen(i) ) then
			CloseBag(i)
			bagsOpen = bagsOpen +1
		end
	end
	if (bagsOpen < totalBags) then
		OpenBackpack()
		for i=1, NUM_BAG_FRAMES, 1 do
			OpenBag(i)
			_G["aBag_bag"]:Show()
		end
	end
end

function OpenAllBags(frame)
	if ( not UIParent:IsShown() ) then
		return;
	end
	
	for i=0, NUM_BAG_FRAMES, 1 do
		if (IsBagOpen(i)) then
			return;
		end
	end

	if( frame and not FRAME_THAT_OPENED_BAGS ) then
		FRAME_THAT_OPENED_BAGS = frame:GetName();
	end

	OpenBackpack()
	for i=1, NUM_BAG_FRAMES, 1 do
		OpenBag(i)
		_G["aBag_bag"]:Show()
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("BANKFRAME_OPENED")

EventFrame:SetScript("OnEvent", function()
	for i=NUM_BAG_FRAMES+1, NUM_CONTAINER_FRAMES, 1 do
		OpenBag(i)
	end
end)

hooksecurefunc("ContainerFrame_Update", function(frame)
		local id = frame:GetID()
		local name = frame:GetName()
		local isQuestItem, questId, isActive, questTexture
		for i=1, frame.size, 1 do
			itemButton = _G[name.."Item"..i]
			questTexture = _G[name.."Item"..i.."IconQuestTexture"]
			Kill(questTexture)	
			isQuestItem, questId, isActive = GetContainerItemQuestInfo(id, itemButton:GetID())
			if ( questId and not isActive ) then
				itemButton.border:SetBackdropBorderColor(1, 1, 0, 1)
			elseif ( questId or isQuestItem ) then
				itemButton.border:SetBackdropBorderColor(1, 1, 0, 1)
			else
				itemButton.border:SetBackdropBorderColor(0, 0, 0, 1)
			end
		end
end)

hooksecurefunc("BankFrameItemButton_Update", function(button)
		local questTexture = _G[button:GetName().."IconQuestTexture"]
		if questTexture then Kill(questTexture)	end
		local isQuestItem, questId, isActive = GetContainerItemQuestInfo(BANK_CONTAINER, button:GetID())
		if ( questId and not isActive ) then
			button.border:SetBackdropBorderColor(1, 1, 0, 1)
		elseif ( questId or isQuestItem ) then
			button.border:SetBackdropBorderColor(1, 1, 0, 1)
		else
			button.border:SetBackdropBorderColor(0, 0, 0, 1)
		end
end)

local numSlots,full = GetNumBankSlots();
local button;
	for i=1, NUM_BANKBAGSLOTS, 1 do
		button = _G["BankFrameBag"..i];
		if ( button ) then
			if ( i > numSlots ) then
				button:HookScript("OnMouseUp", function()
					StaticPopup_Show("BUY_BANK_SLOT")
				end)
			end
		end
	end

StaticPopupDialogs["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		PurchaseSlot()
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
	preferredIndex = 3
}