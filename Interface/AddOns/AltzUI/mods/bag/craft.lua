local T, C, L, G = unpack(select(2, ...))

local action_spells = {
	51005, --milling
	31252, --prospecting
	13262, --disenchanting
	1804, --lock picking (thanks to Kaisoul)
}

local colors = {
	[51005] = {r=181/255, g=230/255, b=29/255},	--milling
	[31252] = {r=1, g=127/255, b=138/255},  	--prospecting
	[13262] = {r=128/255, g=128/255, b=1},   	--disenchant
    [1804] = {r=200/255, g=75/255, b=75/255},   --lock picking  (Thanks to kaisoul)
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

local button = CreateFrame("Button", "xMP_ButtonFrame", UIParent, "SecureActionButtonTemplate,SecureHandlerEnterLeaveTemplate,AutoCastShineTemplate")
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
	AutoCastShine_AutoCastStop(self)
	if InCombatLockdown() then --prevent combat errors
		checkCombat(self) 
	else
		self:ClearAllPoints()
		self:Hide()
	end
end)

button:HookScript("OnReceiveDrag", function(self)
	AutoCastShine_AutoCastStop(self)
	if InCombatLockdown() then --prevent combat errors
		checkCombat(self)
	else
		self:ClearAllPoints()
		self:Hide() 
	end
end)

button:HookScript("OnDragStop", function(self, button)
	AutoCastShine_AutoCastStop(self)
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
			AutoCastShine_AutoCastStop(self)
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

--AutoCastShineTemplate
--set the sparkles otherwise it will throw an error
--increase the sparkles a bit for clarity
for _, sparks in pairs(button.sparkles) do
	sparks:SetHeight(sparks:GetHeight() * 3)
	sparks:SetWidth(sparks:GetWidth() * 3)
end

--if the lootframe is showing then disable everything
LootFrame:HookScript("OnShow", function(self)
	if button:IsShown() and not InCombatLockdown() then
		AutoCastShine_AutoCastStop(button)
		button:ClearAllPoints()
		button:Hide()
	end
end)

--[[------------------------
	CORE
--------------------------]]
--this update is JUST IN CASE the autoshine is still going even after the alt press is gone
local TimerOnUpdate = function(self, time)
	if self.active and not IsAltKeyDown() then
		self.OnUpdateCounter = (self.OnUpdateCounter or 0) + time
		if self.OnUpdateCounter < 0.5 then return end
		self.OnUpdateCounter = 0

		self.tick = (self.tick or 0) + 1
		if self.tick >= 1 then
			AutoCastShine_AutoCastStop(self)
			self.active = false
			self.tick = 0
			self:SetScript("OnUpdate", nil)
		end
	end
end

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
			local bag = owner:GetParent():GetID()
			local slot = owner:GetID()
			local _, _, qual, itemLevel, _, itemType, _, _, EquipLoc = GetItemInfo(link)
						
			local spellID = processCheck(itemID, EquipLoc, qual, link, bag, slot)

			--check to show or hide the button
			if spellID then
				if spellID == 13262 then
					lastItemID = itemID
				end
				button:SetScript("OnUpdate", TimerOnUpdate)
				button.tick = 0
				button.active = true
				button:SetAttribute('macrotext', string.format('/cast %s\n/use %s %s', spells[spellID], bag, slot))
				button:SetAllPoints(owner)
				button:SetAlpha(1)
				button:Show()
				
				AutoCastShine_AutoCastStart(button, colors[spellID].r, colors[spellID].g, colors[spellID].b)
			else
				button:SetScript("OnUpdate", nil)
				button.tick = 0
				button.active = false
				button:ClearAllPoints()
				button:Hide()
			end
		end
	end)
end)