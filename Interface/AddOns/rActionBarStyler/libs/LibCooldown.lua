local lib = LibStub:NewLibrary("LibCooldown", 1.0)
if not lib then return end

lib.startcalls = {}
lib.stopcalls = {}

function lib:RegisterCallback(event, func)
	assert(type(event)=="string" and type(func)=="function", "Usage: lib:RegisterCallback(event{string}, func{function})")
	if event=="start" then
		tinsert(lib.startcalls, func)
	elseif event=="stop" then
		tinsert(lib.stopcalls, func)
	else
		error("Argument 1 must be a string containing \"start\" or \"stop\"")
	end
end

local addon = CreateFrame("Frame")
local band = bit.band
local petflags = COMBATLOG_OBJECT_TYPE_PET
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
local spells = {}
local pets = {}
local items = {}
local watched = {}
local nextupdate, lastupdate = 0, 0

local function stop(id, class)
	watched[id] = nil

	for _, func in next, lib.stopcalls do
		func(id, class)
	end
end

local function update()
	for id, tab in next, watched do
		local duration = watched[id].dur - lastupdate
		if duration < 0 then
			stop(id, watched[id].class)
		else
			watched[id].dur = duration
			if nextupdate <= 0 or duration < nextupdate then
				nextupdate = duration
			end
		end
	end
	lastupdate = 0
	
	if nextupdate < 0 then addon:Hide() end
end

local function start(id, starttime, duration, class)
	update()

	watched[id] = {
		["start"] = starttime,
		["dur"] = duration,
		["class"] = class,
	}
	addon:Show()
	
	for _, func in next, lib.startcalls do
		func(id, duration, class)
	end
	
	update()
end

local function parsespellbook(spellbook)
	i = 1
	while true do
		skilltype, id = GetSpellBookItemInfo(i, spellbook)
		if not id then break end
		
		name = GetSpellBookItemName(i, spellbook)
		if name and skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL and not IsPassiveSpell(i, spellbook) then
			spells[id] = true
		elseif name and skilltype == "PETACTION" and spellbook == BOOKTYPE_PET and not IsPassiveSpell(i, spellbook) then
			pets[id] = true
		end		
		i = i + 1
		if (id == 88625 or id == 88625 or id == 88625) and (skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL) then
		   spells[88625] = true
		   spells[88684] = true
		   spells[88685] = true
		end
	end
end

-- events --
function addon:LEARNED_SPELL_IN_TAB()
	parsespellbook(BOOKTYPE_SPELL)
	parsespellbook(BOOKTYPE_PET)
end

function addon:SPELL_UPDATE_COOLDOWN()
	now = GetTime()

	for id in next, spells do
		local starttime, duration, enabled = GetSpellCooldown(id)
		
		if starttime == nil then
			watched[id] = nil
		elseif starttime == 0 and watched[id] then
			stop(id, "spell")
		elseif starttime ~= 0 then
			local timeleft = starttime + duration - now
		
			if enabled == 1 and timeleft > 1.51 then
				if not watched[id] or watched[id].start ~= starttime then
					start(id, starttime, timeleft, "spell")
				end
			elseif enabled == 1 and watched[id] and timeleft <= 0 then
				stop(id, "spell")
			end
		end
	end
	
	for id in next, pets do
		local starttime, duration, enabled = GetSpellCooldown(id)

		if starttime == nil then
			watched[id] = nil
		elseif starttime == 0 and watched[id] then
			stop(id, "pet")
		elseif starttime ~= 0 then
			local timeleft = starttime + duration - now
		
			if enabled == 1 and timeleft > 1.51 then
				if not watched[id] or watched[id].start ~= starttime then
					start(id, starttime, timeleft, "pet")
				end
			elseif enabled == 1 and watched[id] and timeleft <= 0 then
				stop(id, "pet")
			end
		end
	end
end

function addon:BAG_UPDATE_COOLDOWN()
	for id  in next, items do
		local starttime, duration, enabled = GetItemCooldown(id)
		if enabled == 1 and duration > 10 then
			start(id, starttime, duration, "item")
		elseif enabled == 1 and watched[id] and duration <= 0 then
			stop(id, "item")
		end
	end
end

function addon:PLAYER_ENTERING_WORLD()
	addon:LEARNED_SPELL_IN_TAB()
	addon:BAG_UPDATE_COOLDOWN()
	addon:SPELL_UPDATE_COOLDOWN()
end

hooksecurefunc("UseInventoryItem", function(slot)
	local link = GetInventoryItemLink("player", slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id and not items[id] then
		items[id] = true
	end
end)

hooksecurefunc("UseContainerItem", function(bag, slot)
	local link = GetContainerItemLink(bag, slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	if id and not items[id] then
		items[id] = true
	end
end)

for slot=1, 120 do
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

function addon:ACTION_BAR_SLOT_CHANGED(slot)
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

local function onupdate(self, elapsed)
	nextupdate = nextupdate - elapsed
	lastupdate = lastupdate + elapsed
	if nextupdate > 0 then return end
	
	update(self)
end

addon:Hide()
addon:SetScript("OnUpdate", onupdate)
addon:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

addon:RegisterEvent("LEARNED_SPELL_IN_TAB")
addon:RegisterEvent("SPELL_UPDATE_COOLDOWN")
addon:RegisterEvent("BAG_UPDATE_COOLDOWN")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
