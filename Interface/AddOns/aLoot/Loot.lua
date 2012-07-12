local addon = CreateFrame("Button", "aLootFrame")

local aMeida = "Interface\\AddOns\\aCore\\media\\"
local bordertex = aMeida.."iconborder"
local iconSize = 45
local frameScale = 1
local sq, ss, sn

local OnEnter = function(self)
	local slot = self:GetID()

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetLootItem(slot)
	CursorUpdate(self)
	
	LootFrame.selectedSlot = self:GetID()
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		local loot = {GameTooltip:GetRegions()}
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = loot[1]
		LootSlot(ss)
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local createSlot = function(id)
	local iconsize = iconSize-2
	local frame = CreateFrame("Button", 'aLootFrameSlot'..id, addon)
	frame:SetPoint("LEFT", 8, 0)
	frame:SetSize(iconsize, iconsize)
	frame:SetID(id)
	
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("RIGHT", frame)
	
	local overlay = iconFrame:CreateTexture(nil, "OVERLAY")
    overlay:SetTexture(bordertex)
	overlay:SetPoint("TOPLEFT",iconFrame,"TOPLEFT",0,0)
	overlay:SetPoint("BOTTOMRIGHT",iconFrame,"BOTTOMRIGHT",0,0)
	frame.overlay = overlay

	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(.8)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetPoint("TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", -2, 2)
	frame.icon = icon

	local count = createtext(iconFrame, 12, "OUTLINE", false)
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, -1, 2)
	count:SetText(1)
	frame.count = count

	addon.slots[id] = frame
	return frame
end

local anchorSlots = function(self)
	local iconsize = iconSize
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint("LEFT", addon, (shownSlots-1) * iconsize, 4)
		end
	end

	self:SetHeight(iconsize + 8)
end

addon:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:StartMoving() end end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)

addon:SetMovable(true)
addon:RegisterForClicks"anyup"
addon:SetParent(UIParent)
addon:SetUserPlaced(true)
addon:SetPoint("TOPRIGHT", UIParent, "CENTER", -150, -100)
addon:SetWidth(200)
addon:SetHeight(50)
addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata"HIGH"
addon:SetToplevel(true)

addon.slots = {}
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x - 40, y + 20)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetUserPlaced(false)
		self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 172, 125)		
	end

	local w = 0
	if(items > 0) then
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			
			if texture then
				local color = ITEM_QUALITY_COLORS[quality]
				if(quantity > 1) then
					slot.count:SetText(quantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end

				slot.icon:SetTexture(texture)
				slot.overlay:SetVertexColor(color.r, color.g, color.b, 1)
				
				w = math.max(w, items*iconSize)

				slot:Enable()
				slot:Show()
			end
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]
		slot.overlay:SetVertexColor(color.r, color.g, color.b, 1)
		
		items = 1
		w = math.max(w, iconSize)

		slot.count:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(self)

	self:SetWidth(w)
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end

	addon.slots[slot]:Hide()
	anchorSlots(self)
end

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
end

addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon.ADDON_LOADED = function(self, event, addon)
		self:SetScale(frameScale)
		-- clean up.
		self[event] = nil
		self:UnregisterEvent(event)
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

addon:RegisterEvent"LOOT_OPENED"
addon:RegisterEvent"LOOT_SLOT_CLEARED"
addon:RegisterEvent"LOOT_CLOSED"
addon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
addon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
addon:RegisterEvent"ADDON_LOADED"
addon:Hide()

-- Fuzz
LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "aLootFrame")

function _G.GroupLootDropDown_GiveLoot(self)
	if ( sq >= MASTER_LOOT_THREHOLD ) then
		local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[sq].hex..sn..FONT_COLOR_CODE_CLOSE, self:GetText())
		if (dialog) then
			dialog.data = self.value
		end
	else
		GiveMasterLoot(ss, self.value)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(ss, data)
end