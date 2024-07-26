local T, C, L, G = unpack(select(2, ...))
local LCG = LibStub("LibCustomGlow-1.0")

--C_SpellBook.ContainsAnyDisenchantSpell()

local action_spells = {
	51005, --milling
	31252, --prospecting
	13262, --disenchanting
	1804, --lock picking (thanks to Kaisoul)
}

local colors = {
	[51005] = {181/255, 230/255, 29/255},	--milling
	[31252] = {1, 127/255, 138/255},  	--prospecting
	[13262] = {128/255, 128/255, 1},   	--disenchant
    [1804] = {200/255, 75/255, 75/255},   --lock picking  (Thanks to kaisoul)
}

local spells = {}
local setInCombat = 0
local lastItem
local ARMOR, WEAPON = ARMOR, WEAPON

--[[------------------------
	CREATE BUTTON
--------------------------]]

--this will assist us in checking if we are in combat or not
local function checkCombat(btn, force)
	if setInCombat == 0 and InCombatLockdown() then
		setInCombat = 1
		btn:SetAlpha(0)
		btn:RegisterEvent('PLAYER_REGEN_ENABLED')
	elseif force or (setInCombat == 1 and not InCombatLockdown()) then
		setInCombat = 0
		btn:UnregisterEvent('PLAYER_REGEN_ENABLED')
		btn:ClearAllPoints()
		btn:SetAlpha(1)
		btn:Hide()
	end
end

local button = CreateFrame("Button", "xMP_ButtonFrame", UIParent, "SecureActionButtonTemplate,SecureHandlerEnterLeaveTemplate")
button:RegisterEvent('MODIFIER_STATE_CHANGED')
button:Hide()

button:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...) 
end)

button:SetAttribute('alt-type1', 'macro')
button:RegisterForClicks("LeftButtonUp")
button:RegisterForDrag("LeftButton")
button:SetFrameStrata("TOOLTIP")

--secured on leave function to hide the frame when we are in combat
button:SetAttribute("_onleave", "self:ClearAllPoints() self:SetAlpha(0) self:Hide()") 

button:HookScript("OnLeave", function(self)
	LCG.PixelGlow_Stop(self)
	if InCombatLockdown() then --prevent combat errors
		checkCombat(self) 
	else
		self:ClearAllPoints()
		self:Hide()
	end
end)

button:HookScript("OnReceiveDrag", function(self)
	LCG.PixelGlow_Stop(self)
	if InCombatLockdown() then --prevent combat errors
		checkCombat(self)
	else
		self:ClearAllPoints()
		self:Hide() 
	end
end)

button:HookScript("OnDragStop", function(self, button)
	LCG.PixelGlow_Stop(self)
	if InCombatLockdown() then --prevent combat errors
		checkCombat(self)
	else
		self:ClearAllPoints()
		self:Hide()
	end
end)

function button:MODIFIER_STATE_CHANGED(event, modi)
	if modi and (modi == "LALT" or modi == "RALT") and self:IsShown() then
		--clear the auto shine if alt key has been released
		if not IsAltKeyDown() and not InCombatLockdown() then
			LCG.PixelGlow_Stop(self)
			self:ClearAllPoints()
			self:Hide()
		elseif InCombatLockdown() then
			checkCombat(self)
		end
	end
end

function button:PLAYER_REGEN_ENABLED()
	--player left combat
	checkCombat(self, true)
end

--if the lootframe is showing then disable everything
LootFrame:HookScript("OnShow", function(self)
	if button:IsShown() and not InCombatLockdown() then
		LCG.PixelGlow_Stop(button)
		button:ClearAllPoints()
		button:Hide()
	end
end)

--[[------------------------
	CORE
--------------------------]]
local processCheck = function(itemID, EquipLoc, qual, link, bag, slot)
	if not spells then return end
	
	local classID, subclassID = select(12, GetItemInfo(itemID))
	
	--first check milling
	if classID == 7 and subclassID == 9 and spells[51005] then
		return 51005
	end
	
	--second checking prospecting
	if classID == 7 and subclassID == 7 and spells[31252] then
		return 31252
	end

	--third checking lock picking  (thanks to Kailsoul)
	local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
	if containerInfo and containerInfo.isLocked and spells[1804] then
		return 1804
	end
	
	--otherwise check disenchat
	if EquipLoc and qual and spells[13262] then
		--only allow if the type of item is a weapon or armor, and it's a specific quality
		if EquipLoc ~= "" and qual > 1 and qual < 5 and IsEquippableItem(link) then
			return 13262
		elseif IsArtifactRelicItem(itemID) and qual > 1 and qual < 5 then
			return 13262
		end
	end
end

T.RegisterEnteringWorldCallback(function()	
	for i, spellID in pairs(action_spells) do
		if(IsSpellKnown(spellID)) then
			spells[spellID] = GetSpellInfo(spellID)
		end
	end

	hooksecurefunc(GameTooltip, "ProcessLines", function(self)
		local getterName = self.processingInfo and self.processingInfo.getterName
		if getterName == "GetBagItem" or getterName == "GetInventoryItem" then
			--do some checks before we do anything
			if InCombatLockdown() then return end	--if were in combat then exit
			if not IsAltKeyDown() then return end	--if the modifier is not down then exit
			if CursorHasItem() then return end	--if the mouse has an item then exit
			if MailFrame:IsVisible() then return end --don't continue if the mailbox is open.  For addons such as Postal.
			if AuctionFrame and AuctionFrame:IsShown() then return end --dont enable if were at the auction house
			if LootFrame and LootFrame:IsShown() then return end --make sure the darn lootframe isn't showing
			
			local owner = self:GetOwner() --get the owner of the tooltip
	
			--if it's the character frames <alt> equipment switch then ignore it
			if owner and owner:GetName() and strfind(string.lower(owner:GetName()), "character") and strfind(string.lower(owner:GetName()), "slot") then return end
			if owner and owner:GetParent() and owner:GetParent():GetName() and strfind(string.lower(owner:GetParent():GetName()), "paperdoll") then return end
			if owner and owner:GetName() and strfind(string.lower(owner:GetName()), "equipmentflyout") then return end
				
			local tooltipData = self:GetPrimaryTooltipData()
			local itemID = tooltipData.id
			local item, link = self:GetItem()		
			
			--make sure we have an item to work with
			if not itemID or not item or not link then return end		
			
			lastItemID = nil
			
			--get the bag slot info
			local bag = owner:GetBagID()
			local slot = owner:GetID()
			local _, _, qual, itemLevel, _, itemType, _, _, EquipLoc = GetItemInfo(link)
						
			local spellID = processCheck(itemID, EquipLoc, qual, link, bag, slot)

			--check to show or hide the button
			if spellID then
				if spellID == 13262 then
					lastItemID = itemID
				end
				button:SetAttribute('macrotext', string.format('/cast %s\n/use %s %s', spells[spellID], bag, slot))
				button:SetAllPoints(owner)
				button:SetAlpha(1)
				button:Show()
				
				LCG.PixelGlow_Start(button, colors[spellID])
			else
				button:ClearAllPoints()
				button:Hide()
			end
		end
	end)
end)