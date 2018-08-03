local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)
--[[
	SortBags
	GetSortBagsRightToLeft 
	SetSortBagsRightToLeft
	
	true 4/28→4/27→....3/28....0/16....0/1
	false 0/16→0/15→....1/28...4/28...4/1

	GetInsertItemsLeftToRight
	SetInsertItemsLeftToRight
	
	true 4/28→4/27→....3/28....0/16....0/1
	false 0/16→0/15→....1/28...4/28...4/1
]]

if not aCoreCDB["ItemOptions"]["enablebag"] then return end

local BFrame = CreateFrame('frame')
local bank_shown = 0

config = {
	spacing = 4,
	["bank"] = {
		buttons_per_row = aCoreCDB["ItemOptions"]["bagiconperrow"],
		button_size = aCoreCDB["ItemOptions"]["bagiconsize"],
	},
	["bag"] = {
		buttons_per_row = aCoreCDB["ItemOptions"]["bagiconperrow"],
		button_size = aCoreCDB["ItemOptions"]["bagiconsize"],
	}
}

BFrame.bags = CreateFrame("frame")
BFrame.bags:RegisterEvent("ADDON_LOADED")

local bags = {
	['bag'] = {
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot
	},
	['bank'] = {
	
	}
}

local function StripTextures(object, text)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif (text) then
			region:Hide(0)
			region:SetAlpha(0)
		end
	end
end

local function skin(frame)
	if not frame.skin then
		local f = _G[frame:GetName().."IconTexture"]
		local q = _G[frame:GetName().."IconQuestTexture"]
		
		frame:SetAlpha(1)
		frame:SetFrameStrata("HIGH")

		frame:SetNormalTexture("")
		frame:SetPushedTexture("")
		frame.IconBorder:SetAlpha(0)
		frame:SetBackdrop({bgFile = G.media.blank, edgeFile = G.media.blank, edgeSize = 1})
		frame:SetBackdropColor(0,0,0,.1)
		frame:SetBackdropBorderColor(0,0,0,1)
		
		f:SetPoint("TOPLEFT", frame, 1, -1)
		f:SetPoint("BOTTOMRIGHT", frame, -1, 1)
		f:SetTexCoord(.1, .9, .1, .9)
		
		if (q) then
			q:SetPoint("TOPLEFT", frame, -1, 1)
			q:SetPoint("BOTTOMRIGHT", frame, 1, -1)
			q:SetTexture(G.media.blank)
			q:SetVertexColor(1, 1, 0)
			q:SetDrawLayer("BACKGROUND")
			q.SetTexture = T.dummy
		end
		frame.skin = true
	end
end

local function hideCrap()
	for i = 1, 12 do
		_G["ContainerFrame"..i.."CloseButton"]:Hide()
		for p = 1, 7 do
			select(p, _G["ContainerFrame"..i]:GetRegions()):SetAlpha(0)
		end
	end
	for i = 1, 5 do				
		select(i, _G['BankFrame']:GetRegions()):Hide()
	end
	_G["BackpackTokenFrame"]:GetRegions():SetAlpha(0)
	
	BankFrameCloseButton:Hide()
	BankSlotsFrame:Hide()
	BankFrameMoneyFrame:Hide()
	StripTextures(BankFrameMoneyFrameInset)
	StripTextures(BankFrameMoneyFrameBorder)
	StripTextures(BankFrameMoneyFrame)
	StripTextures(BankFrame, true)
	StripTextures(BankSlotsFrame, true)
	StripTextures(ReagentBankFrame)
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")
end

function BFrame.bags:setUp(frameName, ...)
	local bagconfig = config[frameName]
	local frame = CreateFrame("Frame", G.uiname..frameName, UIParent)
	frame:SetWidth(((bagconfig.button_size+config.spacing)*bagconfig.buttons_per_row)+20-config.spacing)
	if frameName == "bag" then
		frame.movingname = L["背包框"]
		frame.point = {
				healer = {a1 = "BOTTOMRIGHT", parent = "Minimap", a2 = "BOTTOMLEFT", x = -4, y = -1},
				dpser = {a1 = "BOTTOMRIGHT", parent = "Minimap", a2 = "BOTTOMLEFT", x = -4, y = -1},
			}
		T.CreateDragFrame(frame)
	else
		frame.movingname = L["银行框"]
		frame.point = {
				healer = {a1 = "BOTTOM", parent = "AltzUI_bag", a2 = "TOP", x = 0, y = 0},
				dpser = {a1 = "BOTTOM", parent = "AltzUI_bag", a2 = "TOP", x = 0, y = 0},
			}
		T.CreateDragFrame(frame)
	end
	
	frame:SetFrameStrata("HIGH")
	frame.bg = T.CreateThinSD(frame, 1, 0, 0, 0, 0.5, -1)
	frame.bg:SetFrameStrata("MEDIUM")
	frame.bg:SetFrameLevel(99)
	frame:Hide()
	
	frame.bags = CreateFrame('Frame', nil, frame)
	F.CreateBD(frame.bags, 0.3)
	frame.bags:Hide()

	frame.bags.toggle = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.bags.toggle:SetSize(38, 18)
	frame.bags.toggle:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)	
	frame.bags.toggle:SetText(L["背包"])
	F.Reskin(frame.bags.toggle)
	
	frame.bags.toggle:SetScript('OnMouseUp', function()
		if (togglebag ~= 1) then
			togglebag = 1
			frame.bags:Show()
		else
			togglebag= 0
			frame.bags:Hide()
		end
	end)
	
	local bagsort = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	bagsort:SetSize(38, 18)
	bagsort:SetPoint("RIGHT", frame.bags.toggle, "LEFT", -5, 0)
	bagsort:SetText(L["整理"])
	F.Reskin(bagsort)
	bagsort:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(bagsort, "ANCHOR_LEFT", -10, 10)
		GameTooltip:AddLine(BAG_CLEANUP_BAGS)
		GameTooltip:Show()
	end)
	bagsort:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bagsort:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	bagsort:SetScript('OnClick', function(self, button)
		PlaySound(43937)
		if button == "LeftButton" then
			if frameName == "bag" then
				T.BagSort(0)
			elseif ReagentBankFrame:IsShown() then
				T.ReagentBankSort(0)
			else
				T.BankSort(0)
			end
		else
			if frameName == "bag" then
				T.BagSort(1)
			elseif ReagentBankFrame:IsShown() then
				T.ReagentBankSort(1)
			else
				T.BankSort(1)
			end
		end
	end)
	
	if (frameName == "bag") then	
		for _, f in pairs(bags[frameName]) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(frame.bags)
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbutton then
				f:SetPoint("LEFT", lastbutton, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", frame.bags, "TOPLEFT", 12, -8)
			end
			count.Show = function() end
			count:Hide()
			
			f:GetRegions():Hide()

			icon:SetTexCoord(.08, .92, .08, .92)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetHighlightTexture("")
			f.IconBorder:SetTexture("")
			F.SetBD(f)
			lastbutton = f
			frame.bags:SetWidth((24+config.spacing)*(getn(bags[frameName]))+18)
			frame.bags:SetHeight(40)
			frame.bags:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 2)
		end
	else
		BankFramePurchaseInfo:ClearAllPoints()
		BankFramePurchaseInfo:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0 ,30)
		BankFramePurchaseInfo:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0 ,30)
		F.SetBD(BankFramePurchaseInfo)
		F.Reskin(BankFramePurchaseButton)
		
		ReagentBankFrameUnlockInfo:ClearAllPoints()
		ReagentBankFrameUnlockInfo:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0 ,30)
		ReagentBankFrameUnlockInfo:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0 ,30)
		ReagentBankFrameUnlockInfo:SetHeight(150)
		F.Reskin(ReagentBankFrame.DespositButton)
		
		lastbutton = nil
		
		local tab1 = CreateFrame("frame", nil, _G[G.uiname.."bank"])
		local tab2 = CreateFrame("frame", nil, _G[G.uiname.."bank"])
		
		tab1:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 2)
		tab1:SetPoint("BOTTOMRIGHT", frame, "TOP", 0, 2)
		tab1:SetHeight(24)
		F.SetBD(tab1)
		tab1.text = T.createtext(tab1, "OVERLAY", 12, "OUTLINE", "CENTER")
		tab1.text:SetPoint("CENTER", tab1, "CENTER", 2, 0)
		tab1.text:SetText(BANK)
		tab1.text:SetTextColor(1, 1, 1)
		tab1:SetScript("OnMouseUp", function(self) 
			BankFrameTab1:Click()
			tab1.text:SetTextColor(1, 1, 1)
			tab2.text:SetTextColor(.4,.4,.4)
		end)
		tab1:SetScript("OnHide", function(self) 
			tab1.text:SetTextColor(1, 1, 1)
		end)
		
		tab2:SetPoint("BOTTOMLEFT", frame, "TOP", 0, 2)
		tab2:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 2)
		tab2:SetHeight(24)
		F.SetBD(tab2)
		tab2.text = T.createtext(tab2, "OVERLAY", 12, "OUTLINE", "CENTER")
		tab2.text:SetPoint("CENTER", tab2, "CENTER", 2, 0)
		tab2.text:SetText(REAGENT_BANK)
		tab2.text:SetTextColor(.4,.4,.4)
		tab2:SetScript("OnMouseUp", function(self) 
			BankFrameTab2:Click()
			tab2.text:SetTextColor(1, 1, 1)
			tab1.text:SetTextColor(.4,.4,.4)
		end)
		tab2:SetScript("OnHide", function(self) 
			tab2.text:SetTextColor(.4,.4,.4)
		end)
		
		for i = 1, 2 do
			local tab = _G["BankFrameTab"..i]
			StripTextures(tab)
			tab:ClearAllPoints()
			tab:Hide()
		end
		
		for i = 1, 7 do
			local bankbag = BankSlotsFrame["Bag"..i]
			local icon = bankbag.icon
			local highlight = bankbag.HighlightFrame.HighlightTexture
			
			bankbag:SetParent(frame.bags)
			bankbag:GetChildren():Hide()
			bankbag:ClearAllPoints()
			bankbag:SetWidth(24)
			bankbag:SetHeight(24)
			
			if lastbutton then
				bankbag:SetPoint("LEFT", lastbutton, "RIGHT", config.spacing, 0)
			else
				bankbag:SetPoint("TOPLEFT", frame.bags, "TOPLEFT", 8, -8)
			end
			lastbutton = bankbag
			F.SetBD(bankbag)
			
			bankbag:SetNormalTexture("")
			bankbag:SetPushedTexture("")
			bankbag:SetHighlightTexture("")
			bankbag.IconBorder:SetTexture("")
			
			StripTextures(bankbag)
			
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			
			if highlight and not highlight.skinned then
				highlight:SetTexture(1, 1, 1, 0.3)
				highlight:SetTexture("")
				highlight:ClearAllPoints()
				highlight:SetPoint("TOPLEFT", 2, -2)
				highlight:SetPoint("BOTTOMRIGHT", -2, 2)
				highlight.skinned = true
			end
			
			frame.bags:SetWidth((24+config.spacing)*(7)+16)
			frame.bags:SetHeight(40)
			frame.bags:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 25)
		end
		
		frame:RegisterEvent('BANKFRAME_CLOSED')
		frame:SetScript("OnEvent", function(self, event, arg)
			if event == "BANKFRAME_CLOSED" then
				bank_shown = 0
			end
		end)
	end
	return frame
end

local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
local banknumrows, banklastrowbutton, banknumbuttons, banklastbutton = 0, BankFrameItem1, 1, BankFrameItem1

function ContainerFrame_GenerateFrame(frame, size, id)
	BACKPACK_HEIGHT = BACKPACK_HEIGHT or 14 -- 防bug
	
	frame.size = size
	
	for i= 1, size, 1 do
		local itemButton = _G[frame:GetName().."Item"..i]
		itemButton:SetID(size - i + 1)
		itemButton:Show()
	end
	
	frame:SetID(id)
	frame:Show()
	
	if bank_shown == 0 then
		BankFrameMoneyFrame:Hide()
		banknumrows, banklastrowbutton, banknumbuttons, banklastbutton = 0, BankFrameItem1, 1, BankFrameItem1
		for bank = 1, 28 do
			local bankitems = _G["BankFrameItem"..bank]
			
			bankitems:ClearAllPoints()
			bankitems:SetWidth(config.bank.button_size)
			bankitems:SetHeight(config.bank.button_size)
			skin(bankitems)
			
			--if not bankitems.idtext then
				--bankitems.idtext = T.createtext(bankitems, "OVERLAY", 10, "OUTLINE", "CENTER")
				--bankitems.idtext:SetPoint("TOP")
				--bankitems.idtext:SetText("B/"..bank)
			--end
			
			if bank==1 then
				bankitems:SetPoint("TOPLEFT", _G[G.uiname.."bank"], "TOPLEFT", 10, -30)
				banklastrowbutton = bankitems
				banklastbutton = bankitems
			elseif banknumbuttons == config.bank.buttons_per_row then
				bankitems:SetPoint("TOP", banklastrowbutton, "BOTTOM", 0, -config.spacing)
				banklastrowbutton = bankitems
				banknumrows = banknumrows + 1
				banknumbuttons = 1
			else
				bankitems:SetPoint("LEFT", banklastbutton, "RIGHT", config.spacing, 0)
				banknumbuttons = banknumbuttons + 1
			end
			banklastbutton = bankitems
		end
		bank_shown = 1
	end
	

	if  id >= 0 and id <= 4 then
		local slots = GetContainerNumSlots(id)
		
		for item = slots, 1, -1 do
			local itemframes = _G["ContainerFrame"..(id+1).."Item"..item]
			itemframes:ClearAllPoints()
			itemframes:SetWidth(config.bag.button_size)
			itemframes:SetHeight(config.bag.button_size)
			skin(itemframes)
			
			--if not itemframes.idtext then
				--itemframes.idtext = T.createtext(itemframes, "OVERLAY", 10, "OUTLINE", "CENTER")
				--itemframes.idtext:SetPoint("TOP")
				--itemframes.idtext:SetText(1+id.."/"..item)
			--end
			
			if id == 0 and item == GetContainerNumSlots(0) then
				numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
				itemframes:SetPoint("TOPLEFT", _G[G.uiname.."bag"], "TOPLEFT", 10, -30)
				lastrowbutton = itemframes
				lastbutton = itemframes
			elseif numbuttons==config.bag.buttons_per_row then
				itemframes:SetPoint("TOP", lastrowbutton, "BOTTOM", 0, -config.spacing)
				lastrowbutton = itemframes
				numrows = numrows + 1
				numbuttons = 1
			else
				itemframes:SetPoint("LEFT", lastbutton, "RIGHT", config.spacing, 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = itemframes
		end

		_G[G.uiname.."bag"]:SetHeight(((config.bag.button_size+config.spacing)*(numrows+1)+60)-config.spacing)
		
		for i = 1, 3 do
			_G["BackpackTokenFrameToken"..i.."Icon"]:SetSize(12,12) 
			_G["BackpackTokenFrameToken"..i.."Icon"]:SetTexCoord(.1,.9,.1,.9) 
				_G["BackpackTokenFrameToken"..i.."Icon"]:SetPoint("LEFT", _G["BackpackTokenFrameToken"..i], "RIGHT", -8, 2) 
			_G["BackpackTokenFrameToken"..i.."Count"]:SetFont(G.numFont, 14)
			_G["BackpackTokenFrameToken"..i]:ClearAllPoints()
			if (i == 1) then
				_G["BackpackTokenFrameToken"..i]:SetPoint("BOTTOMLEFT", _G[G.uiname.."bag"], "BOTTOMLEFT", 0, 8)
			else
				_G["BackpackTokenFrameToken"..i]:SetPoint("LEFT", _G["BackpackTokenFrameToken"..(i-1)], "RIGHT", 10, 0)
			end
		end
		
	else
	
		local slots = GetContainerNumSlots(id)
		for item = slots, 1, -1 do
			local itemframes = _G["ContainerFrame"..(id+1).."Item"..item]
			itemframes:ClearAllPoints()
			itemframes:SetWidth(config.bank.button_size)
			itemframes:SetHeight(config.bank.button_size)
			skin(itemframes)
			
			--if not itemframes.idtext then
				--itemframes.idtext = T.createtext(itemframes, "OVERLAY", 10, "OUTLINE", "CENTER")
				--itemframes.idtext:SetPoint("TOP")
				--itemframes.idtext:SetText(1+id.."/"..item)
			--end
			
			if banknumbuttons == config.bank.buttons_per_row then
				itemframes:SetPoint("TOP", banklastrowbutton, "BOTTOM", 0, -config.spacing)
				banklastrowbutton = itemframes
				banknumrows = banknumrows + 1
				banknumbuttons = 1
			else
				itemframes:SetPoint("LEFT", banklastbutton, "RIGHT", config.spacing, 0)
				banknumbuttons = banknumbuttons + 1
			end
			banklastbutton = itemframes
		end
		
		_G[G.uiname.."bank"]:SetHeight(((config.bank.button_size+config.spacing)*(banknumrows+1)+40)-config.spacing)
	end
	
	hideCrap()
end

function OpenBag() end
function ToggleBag() end

function OpenBackpack() end
function ToggleBackpack() end

function UpdateContainerFrameAnchors() end

function OpenAllBags(frame) ToggleAllBags("open") end

local function OpenOneBag(id)
	if ( not CanOpenPanels() ) then
		if ( UnitIsDead("player") ) then
			NotWhileDeadError();
		end
		return;
	end

	local size = GetContainerNumSlots(id);
	if ( size > 0 ) then
		local containerShowing;
		for i=1, NUM_CONTAINER_FRAMES, 1 do
			local frame = _G["ContainerFrame"..i];
			if ( frame:IsShown() and frame:GetID() == id ) then
				containerShowing = i;
			end
		end
		if ( not containerShowing ) then
			ContainerFrame_GenerateFrame(ContainerFrame_GetOpenFrame(), size, id);
		end
		if (not ContainerFrame1.allBags) then
			CheckBagSettingsTutorial();
		end
	end
end

function ToggleAllBags(func)
	if (func == "open") then
		togglemain = 1
		OpenBackpack()
		_G[G.uiname.."bag"]:Show()
		for i=0, NUM_BAG_FRAMES, 1 do OpenOneBag(i) end
	else
		if (togglemain == 1) then
			if (not _G[G.uiname.."bank"]:IsShown()) then
				togglemain = 0
				CloseBackpack()
				_G[G.uiname.."bag"]:Hide()
				for i=0, NUM_BAG_FRAMES, 1 do CloseBag(i) end
			end
		else
			if(not BankFrame:IsShown()) then 
				togglemain = 1
				OpenBackpack()
				_G[G.uiname.."bag"]:Show()
				for i=0, NUM_BAG_FRAMES, 1 do OpenOneBag(i) end
			end
		end
	end

	if BankFrame:IsShown() then
		_G[G.uiname.."bank"]:Show()
		for i=1, NUM_CONTAINER_FRAMES, 1 do
			OpenOneBag(i)
		end
	end
end
BackpackTokenFrame:Hide();

local function quickbank(show)
	local numrows, numbuttons = 0, 1
	
	for i = 1, 28 do
		local name = _G["BankFrameItem"..i]
		if (show) then
			name:Show()
		else
			name:Hide()
		end
		if numbuttons == config.bank.buttons_per_row then
			numrows = numrows + 1
			numbuttons = 1
		end
		numbuttons = numbuttons + 1
	end
	
	for b = 6, 16 do
		local slots = GetContainerNumSlots(b-1)
		for t = 1, slots do
			local name = _G["ContainerFrame"..b.."Item"..t]
			if (show) then
				name:Show()
			else
				name:Hide()
			end
			if numbuttons == config.bank.buttons_per_row then
				numrows = numrows + 1
				numbuttons = 1
			end
			numbuttons = numbuttons + 1
		end
	end

	if (show) then
		_G[G.uiname.."bank"]:SetHeight(((config.bank.button_size+config.spacing)*(numrows+1)+40)-config.spacing)
	end

	_G[G.uiname.."bank"]:Show()
end
local function quickreagent(show)
	local numrows, lastrowbutton, numbuttons, lastbutton = 0, ReagentBankFrameItem, 1, ReagentBankFrameItem
	for r = 1, 98 do
		local itemframe = _G["ReagentBankFrameItem"..r]
			if (itemframe) then
			itemframe:ClearAllPoints()
			itemframe:SetWidth(config.bank.button_size)
			itemframe:SetHeight(config.bank.button_size)
			skin(itemframe)
			
			if r == 1 then
				itemframe:SetPoint("TOPLEFT", _G[G.uiname.."bank"], "TOPLEFT", 10, -30)
				lastrowbutton = itemframe
				lastbutton = itemframe
			elseif numbuttons==config.bank.buttons_per_row then
				itemframe:SetPoint("TOP", lastrowbutton, "BOTTOM", 0, -config.spacing)
				lastrowbutton = itemframe
				numrows = numrows + 1
				numbuttons = 1
			else
				itemframe:SetPoint("LEFT", lastbutton, "RIGHT", config.spacing, 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = itemframe
		end
	end
	if (show) then
		_G[G.uiname.."bank"]:SetHeight(((config.bank.button_size+config.spacing)*(numrows+1)+70)-config.spacing)

		local children = {ReagentBankFrame:GetChildren()}
		children[1]:SetPoint("BOTTOM", _G[G.uiname.."bank"], "BOTTOM", 0, 10)
	end
end

-- I have to keep stealing blizzard functions, because they are doing so far from what I want they are actually making bag coding near impossible. 
function BankFrame_ShowPanel(sidePanelName, selection)
	local self = BankFrame;
	-- find side panel
	local tabIndex;
	ShowUIPanel(self);
	for index, data in pairs(BANK_PANELS) do
		local panel = _G[data.name];

		if ( data.name == sidePanelName ) then
			panel:Show()
			tabIndex = index;
			self.activeTabIndex = tabIndex;
			
			if (data.name == "ReagentBankFrame") then
				-- Redraw reagent in bank
				quickbank(false)
				quickreagent(true)
			else
				-- Redraw bank in rank
				quickbank(true)
				quickreagent(false)
			end
		else
			panel:Hide()
		end
	end
end

ContainerFrame1Item1:SetScript("OnHide", function() 
	_G[G.uiname.."bag"]:Hide() 
end)
BankFrameItem1:SetScript("OnHide", function() 
	_G[G.uiname.."bank"]:Hide()
end)
BankFrameItem1:SetScript("OnShow", function() 
	_G[G.uiname.."bank"]:Show()
end)
ReagentBankFrame:SetScript("OnHide", function()
	if not BankFrameItem1:IsShown() then
		_G[G.uiname.."bank"]:Hide()
	end
end)

BankPortraitTexture:Hide()
BankFrame:EnableMouse(0)
function SkinEditBox(frame)
	frame.Left:Hide()
	frame.Right:Hide()
	frame.Middle:Hide()
	frame:GetChildren():SetAlpha(0)
	frame:SetWidth(200)
	frame.bg = CreateFrame('frame', nil, frame)
	frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 0)
	frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    frame.bg:SetBackdrop({bgFile = G.media.blank, edgeFile = G.media.blank, edgeSize = 1, insets = {top = 1, left = 1, bottom = 1, right = 1}})
    frame.bg:SetBackdropColor(1,1,1,.02)
    frame.bg:SetBackdropBorderColor(0,0,0,1)
end

SkinEditBox(BagItemSearchBox)
SkinEditBox(BankItemSearchBox)

hooksecurefunc("ContainerFrame_Update", function(frame)
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetParent(_G[G.uiname.."bag"])
	BagItemSearchBox:SetPoint("TOPRIGHT", _G[G.uiname.."bag"], "TOPRIGHT", -100, -6)
	BagItemAutoSortButton:Hide();
	
	BankItemSearchBox:ClearAllPoints()
	BankItemSearchBox:SetParent(_G[G.uiname.."bank"])
	BankItemSearchBox:SetPoint("TOPRIGHT", _G[G.uiname.."bank"], "TOPRIGHT", -100, -6)
	BankItemAutoSortButton:Hide();
	
	ContainerFrame1MoneyFrame:ClearAllPoints()
	ContainerFrame1MoneyFrame:Show()
	ContainerFrame1MoneyFrame:SetPoint("TOPLEFT", _G[G.uiname.."bag"], "TOPLEFT", 6, -10)
	
	ContainerFrame2MoneyFrame:Show()
	ContainerFrame2MoneyFrame:ClearAllPoints()
	ContainerFrame2MoneyFrame:SetPoint("TOPLEFT", _G[G.uiname.."bank"], "TOPLEFT", 6, -10)
	ContainerFrame2MoneyFrame:SetParent(_G[G.uiname.."bank"])
	
	ContainerFrame1:EnableMouse(false);
	ContainerFrame2:EnableMouse(false);
	ContainerFrame3:EnableMouse(false);
	ContainerFrame4:EnableMouse(false);
	ContainerFrame5:EnableMouse(false);
	BankFrame:EnableMouse(false);
end)

BFrame.bags:SetScript("OnEvent", function(self, event, addon)
	if (addon == "AltzUI") then
		bags = BFrame.bags:setUp("bag", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)
		bank = BFrame.bags:setUp("bank", "TOPLEFT", UIParent, "TOPLEFT", 10, -134)
		SetInsertItemsLeftToRight(false)
	end
end)
