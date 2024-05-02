local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[               -- Flash Icon --                 ]]--
--====================================================--

local flash = CreateFrame("Frame", G.uiname.."Cooldown Flash", UIParent, "BackdropTemplate")
flash:SetSize(50,50)
flash:Hide()

flash.icon = flash:CreateTexture(nil, "OVERLAY")	
flash.icon:SetAllPoints()
flash.icon:SetTexCoord(0.1,0.9,0.1,0.9)

flash.backdrop = T.createBackdrop(flash)

flash.movingname = L["冷却提示"]
flash.point = {
	healer = {a1 = "CENTER", parent = "UIParent", a2 = "CENTER", x = 0, y = 0},
	dpser = {a1 = "CENTER", parent = "UIParent", a2 = "CENTER", x = 0, y = 0},
}
T.CreateDragFrame(flash)

flash.e = 0
flash:SetScript("OnUpdate", function(self, e)
	flash.e = flash.e + e
	if flash.e > .75 then
		flash:Hide()
	elseif flash.e < .1 then
		flash:SetAlpha(flash.e*10)
	elseif flash.e > .65 then
		flash:SetAlpha((.75-flash.e)*10)
	end
end)

T.UpdateCooldownFlashSize = function()
	flash:SetSize(aCoreCDB["ActionbarOptions"]["cdflash_size"],aCoreCDB["ActionbarOptions"]["cdflash_size"])
end

T.RegisterInitCallback(T.UpdateCooldownFlashSize)

--====================================================--
--[[                 -- Update --                   ]]--
--====================================================--

local nextupdate, lastupdate = 0, 0
local numTabs, totalspellnum
local spells = {}
local items = {}
local watched = {}

local addon = CreateFrame("Frame")
addon:Hide()

local function stopCooldown(id, class)
	watched[id] = nil
	
	local icon
	if class=="item" then
		icon = GetItemIcon(id)
	elseif class=="spell" then
		icon = select(3, GetSpellInfo(id))
	end
	flash.icon:SetTexture(icon)
	
	flash.e = 0
	flash:Show()
end

local function UpdateWatchedCooldowns()
	for id, info in pairs(watched) do
		local duration = info.dur - lastupdate
		if duration < 0 then
			stopCooldown(id, info.class)
		else
			info.dur = duration
			if nextupdate <= 0 or duration < nextupdate then
				nextupdate = duration
			end
		end		
	end
	lastupdate = 0
	
	if nextupdate < 0 then addon:Hide() end
end

local function startCooldown(id, starttime, duration, class)	
	UpdateWatchedCooldowns() -- lastupdate 重置为0
	watched[id] = {
		["start"] = starttime,
		["dur"] = duration,
		["class"] = class,
	}
	UpdateWatchedCooldowns() -- 同步 nextupdate 为最短CD 
	addon:Show()
end

local function parsespellbook(spellbook)
	i = 1
	while true do
		skilltype, id = GetSpellBookItemInfo(i, spellbook)
		name = GetSpellBookItemName(i, spellbook)		
		cd_id = FindSpellOverrideByID(id)

		if name and skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL and not IsPassiveSpell(i, spellbook) then
			spells[id] = cd_id
		end
		i = i + 1
		if i >= totalspellnum then i = 1 break end
		
		if (id == 88625 or id == 88684 or id == 88685) and (skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL) then
		   spells[88625] = cd_id
		   spells[88684] = cd_id
		   spells[88685] = cd_id
		end
	end
end

--====================================================--
--[[                 -- Events --                   ]]--
--====================================================--

addon:SetScript("OnUpdate", function(self, elapsed)	
	nextupdate = nextupdate - elapsed
	lastupdate = lastupdate + elapsed
	if nextupdate > 0 then 
		return 
	end
	UpdateWatchedCooldowns(self)
end)

hooksecurefunc("UseInventoryItem", function(slot)
	local link = GetInventoryItemLink("player", slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id and not items[id] then
		items[id] = true
	end
end)

hooksecurefunc(C_Container, "UseContainerItem", function(bag, slot)
	local link = C_Container.GetContainerItemLink(bag, slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id and not items[id] then
		items[id] = true
	end
end)

function addon:ACTION_BAR_SLOT_CHANGED(slot)
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

function addon:LEARNED_SPELL_IN_TAB()
	numTabs = GetNumSpellTabs()
	totalspellnum = 0
	for i=1, numTabs do
		local numSpells = select(4, GetSpellTabInfo(i))
		totalspellnum = totalspellnum + numSpells
	end
	parsespellbook(BOOKTYPE_SPELL)
end

function addon:SPELL_UPDATE_COOLDOWN()
	local now = GetTime()

	for id, cd_id in pairs(spells) do
		local starttime, duration, enabled = GetSpellCooldown(cd_id)
		
		if starttime == nil then
			watched[id] = nil
		elseif starttime == 0 and watched[id] then
			stopCooldown(id, "spell")
		elseif starttime ~= 0 then		
			local timeleft = starttime + duration - now
			if enabled == 1 and timeleft > 1.51 then
				if not aCoreCDB["ActionbarOptions"]["cdflash_ignorespells"][id] and (not watched[id] or watched[id].start ~= starttime) then
					startCooldown(id, starttime, timeleft, "spell")
				end
			elseif enabled == 1 and watched[id] and timeleft <= 0 then
				stopCooldown(id, "spell")
			end
		end
	end
end

function addon:BAG_UPDATE_COOLDOWN()
	for id in next, items do
		local starttime, duration, enabled = GetItemCooldown(id)
		if not aCoreCDB["ActionbarOptions"]["cdflash_ignoreitems"][id] and enabled == 1 and duration > 10 then
			startCooldown(id, starttime, duration, "item")
		elseif enabled == 1 and watched[id] and duration <= 0 then
			stopCooldown(id, "item")
		end
	end
end

function addon:PLAYER_ENTERING_WORLD()
	addon:LEARNED_SPELL_IN_TAB()
	addon:BAG_UPDATE_COOLDOWN()
	addon:SPELL_UPDATE_COOLDOWN()
	
	for slot=1, 120 do
		local action, id = GetActionInfo(slot)
		if action == "item" then
			items[id] = true
		end
	end
end

addon:SetScript("OnEvent", function(self, event, ...)
	if not aCoreCDB["ActionbarOptions"]["cdflash_enable"] then return end
	self[event](self, ...) 
end)

addon:RegisterEvent("LEARNED_SPELL_IN_TAB")
addon:RegisterEvent("SPELL_UPDATE_COOLDOWN")
addon:RegisterEvent("BAG_UPDATE_COOLDOWN")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
