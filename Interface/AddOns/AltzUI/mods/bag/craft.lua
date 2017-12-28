xMPDB = {}

--[[------------------------
	HERBS 草药
--------------------------]]

xMPDB.herbs = {
	[765] = true,
	[785] = true,
	[2447] = true,
	[2449] = true,
	[2450] = true,
	[2452] = true,
	[2453] = true,
	[3355] = true,
	[3356] = true,
	[3357] = true,
	[3369] = true,
	[3818] = true,
	[3819] = true,
	[3820] = true,
	[3821] = true,
	[3358] = true,
	[4625] = true,
	[8153] = true,
	[8831] = true,
	[8836] = true,
	[8838] = true,
	[8839] = true,
	[8845] = true,
	[8846] = true,
	[13463] = true,
	[13464] = true,
	[13465] = true,
	[13466] = true,
	[13467] = true,
	[22710] = true,
	[22785] = true,
	[22786] = true,
	[22787] = true,
	[22789] = true,
	[22790] = true,
	[22791] = true,
	[22792] = true,
	[22793] = true,
	[36901] = true,
	[36902] = true,
	[36903] = true,
	[36904] = true,
	[36905] = true,
	[36906] = true,
	[36907] = true,
	[37921] = true,
	[39970] = true,
	[52983] = true,
	[52984] = true,
	[52985] = true,
	[52986] = true,
	[52987] = true,
	[52988] = true,
	--MOP
	[72234] = true, -- Green Tea Leaf
	[72235] = true, -- Silkweed
	[72237] = true, -- Rain Poppy
	[72238] = true, -- Golden Lotus
	[79010] = true, -- Snow Lily
	[79011] = true, -- Fool's Cap
	[89639] = true, -- Desecrated Herb
	-- Warlords of Draenor
	[109124] = true, -- Frostweed
	[109125] = true, -- Fireweed 
	[109127] = true, -- Starflower
	[109128] = true, -- Nagrand Arrowbloom
	[109129] = true, -- Talador Orchid
	
	[124101] = true,
	[124102] = true,
	[124103] = true,
	[124104] = true,
	[124105] = true,
	[151565] = true,
}

--[[------------------------
	ORE 矿石
--------------------------]]

xMPDB.ore = {
	[2770] = true,
	[2771] = true,
	[2772] = true,
	[3858] = true,
	[10620] = true,
	[23424] = true,
	[23425] = true,
	[36909] = true,
	[36910] = true,
	[36912] = true,
	[53038] = true,
	[52183] = true,
	[52185] = true,
	--MOP
	[72092] = true, -- Ghost Iron Ore
	[72103] = true, -- White Trillium Ore
	[72094] = true, -- Black Trillium Ore
	[72093] = true, -- Kyparite Ore
	-- Warlords of Draenor
	[109119] = true, -- True Iron Ore
	[109118] = true, -- Blackrock Ore
	
	[123919] = true,
	[123918] = true,
	[151564] = true,
}


--[[------------------------
	LOCK 开锁
--------------------------]]
--Special thanks to kaisoul from WOWinterface.com

xMPDB.lock = {
	[4632] = true,
	[4633] = true,
	[4634] = true,
	[4636] = true,
	[4637] = true,
	[4638] = true,
	[5758] = true,
	[5759] = true,
	[5760] = true,
	[6354] = true,
	[6355] = true,
	[7209] = true,
	[6712] = true,
	[12033] = true,
	[13875] = true,
	[16882] = true,
	[16883] = true,
	[16884] = true,
	[16885] = true,
	[29569] = true,
	[31952] = true,
	[43575] = true,
	[43622] = true,
	[43624] = true,
	[45986] = true,
	[63349] = true,
	[68729] = true, --Elementium Lockbox
	[88165] = true, --vine-cracked junkbox (MOP)
	[88567] = true, --ghost iron box
	-- Warlords of Draenor
	[116920] = true, -- True Steel Lockbox
}

--A very special thanks to P3lim (Molinari) for the inspiration behind the AutoShine and Blightdavid for his work on Prospect Easy.

local spells = {}
local setInCombat = 0
local lastItem
local ARMOR, WEAPON = ARMOR, WEAPON

local colors = {
	[51005] = {r=181/255, g=230/255, b=29/255},	--milling
	[31252] = {r=1, g=127/255, b=138/255},  	--prospecting
	[13262] = {r=128/255, g=128/255, b=1},   	--disenchant
    [1804] = {r=200/255, g=75/255, b=75/255},       --lock picking  (Thanks to kaisoul)
}

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
button:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
button:RegisterEvent('MODIFIER_STATE_CHANGED')

button:SetAttribute('alt-type1', 'macro')
button:RegisterForClicks("LeftButtonUp")
button:RegisterForDrag("LeftButton")
button:SetFrameStrata("TOOLTIP")

--secured on leave function to hide the frame when we are in combat
button:SetAttribute("_onleave", "self:ClearAllPoints() self:SetAlpha(0) self:Hide()") 

button:HookScript("OnLeave", function(self)
	AutoCastShine_AutoCastStop(self)
	if InCombatLockdown() then checkCombat(self) else self:ClearAllPoints() self:Hide() end --prevent combat errors
end)

button:HookScript("OnReceiveDrag", function(self)
	AutoCastShine_AutoCastStop(self)
	if InCombatLockdown() then checkCombat(self) else self:ClearAllPoints() self:Hide() end --prevent combat errors
end)
button:HookScript("OnDragStop", function(self, button)
	AutoCastShine_AutoCastStop(self)
	if InCombatLockdown() then checkCombat(self) else self:ClearAllPoints() self:Hide() end --prevent combat errors
end)
button:Hide()

function button:MODIFIER_STATE_CHANGED(event, modi)
	if not modi then return end
	if modi ~= "LALT" or modi ~= "RALT" then return end
	if not self:IsShown() then return end
	
	--clear the auto shine if alt key has been released
	if not IsAltKeyDown() and not InCombatLockdown() then
		AutoCastShine_AutoCastStop(self)
		self:ClearAllPoints()
		self:Hide()
	elseif InCombatLockdown() then
		checkCombat(self)
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

local frm = CreateFrame("frame", "xanMortarPestle_Frame", UIParent)
frm:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

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

function frm:PLAYER_LOGIN()
	
	--check for DB
	if not XMP_DB then XMP_DB = {} end
	
	--milling
	if(IsSpellKnown(51005)) then
		spells[51005] = GetSpellInfo(51005)
	end

	--prospecting
	if(IsSpellKnown(31252)) then
		spells[31252] = GetSpellInfo(31252)
	end
	
	--disenchanting
	if(IsSpellKnown(13262)) then
		spells[13262] = GetSpellInfo(13262)
	end

	--lock picking (thanks to Kaisoul)
	if(IsSpellKnown(1804)) then
		spells[1804] = GetSpellInfo(1804)
	end
	
	GameTooltip:HookScript('OnTooltipSetItem', function(self)
		--do some checks before we do anything
		if InCombatLockdown() then return end	--if were in combat then exit
		if not IsAltKeyDown() then return end	--if the modifier is not down then exit
		if CursorHasItem() then return end	--if the mouse has an item then exit
		if MailFrame:IsVisible() then return end --don't continue if the mailbox is open.  For addons such as Postal.
		if AuctionFrame and AuctionFrame:IsShown() then return end --dont enable if were at the auction house
	
		local item, link = self:GetItem()

		--make sure we have an item to work with
		if not item and not link then return end
		
		local owner = self:GetOwner() --get the owner of the tooltip

		--if it's the character frames <alt> equipment switch then ignore it
		if owner and owner:GetName() and strfind(string.lower(owner:GetName()), "character") and strfind(string.lower(owner:GetName()), "slot") then return end
		if owner and owner:GetParent() and owner:GetParent():GetName() and strfind(string.lower(owner:GetParent():GetName()), "paperdoll") then return end
		if owner and owner:GetName() and strfind(string.lower(owner:GetName()), "equipmentflyout") then return end

		--reset if no item (link will be nil)
		lastItem = link
		--make sure we have an item, it's not an equipped one, and the darn lootframe isn't showing

		--if item and link and not IsEquippedItem(link) and not LootFrame:IsShown() then
		if item and link and not LootFrame:IsShown() then	
			--get the bag slot info
			local bag = owner:GetParent():GetID()
			local slot = owner:GetID()
			local id = type(link) == "number" and link or select(3, link:find("item:(%d+):"))
			id = tonumber(id)
		
			if not id then return end
			if not xMPDB then return end
		
			local _, _, qual, itemLevel, _, itemType, _, _, EquipLoc = GetItemInfo(link)
			local spellID = processCheck(id, EquipLoc, qual, link)

			--check to show or hide the button
			if spellID then
			
				--set the item for disenchant check
				lastItem = link

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
	
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function processCheck(id, EquipLoc, qual, link)
	if not spells then return nil end

	--first check milling
	if xMPDB.herbs[id] and spells[51005] then
		return 51005
	end
	
	--second checking prospecting
	if xMPDB.ore[id] and spells[31252] then
		return 31252
	end

	--third checking lock picking  (thanks to Kailsoul)
	if xMPDB.lock[id] and spells[1804] then
		return 1804
	end
	
	--otherwise check disenchat
	if EquipLoc and qual and XMP_DB and spells[13262] then
		--only allow if the type of item is a weapon or armor, and it's a specific quality
		if EquipLoc ~= "" and qual > 1 and qual < 5 and IsEquippableItem(link) and not XMP_DB[id] then
			return 13262
		elseif IsArtifactRelicItem(id) and qual > 1 and qual < 5 and not XMP_DB[id] then
			return 13262
		end
	end
	
	return nil
end

--instead of having a large array with all the possible non-disenchant items
--I decided to go another way around this.  Whenever a user tries to disenchant an item that can't be disenchanted
--it learns the item into a database.  That way in the future the user will not be able to disenchant it.
--A one time warning will be displayed for the user ;)

local originalOnEvent = UIErrorsFrame:GetScript("OnEvent")
UIErrorsFrame:SetScript("OnEvent", function(self, event, msg, r, g, b, ...)
	if event ~= "SYSMSG" then
		--it's not a system message so lets grab it and compare with non-disenchant
		if msg == SPELL_FAILED_CANT_BE_DISENCHANTED and XMP_DB and button:IsShown() and lastItem then
			--get the id from the previously stored link
			local id
			if type(lastItem) == "number" then
				id = lastItem
			else
				id = select(3, lastItem:find("item:(%d+):"))
			end
			id = tonumber(id)
			--check to see if it's already in the database, if it isn't then add it to the DE list.
			if id and not XMP_DB[id] then
				XMP_DB[id] = true
				DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33xanMortarPestle|r: %s added to database. %s", lastItem, SPELL_FAILED_CANT_BE_DISENCHANTED))
			end
		end
	end
	return originalOnEvent(self, event, msg, r, g, b, ...)
end)

if IsLoggedIn() then frm:PLAYER_LOGIN() else frm:RegisterEvent("PLAYER_LOGIN") end