local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ActionbarOptions"]["cdflash_enable"] then return end

local minalpha = aCoreCDB["ActionbarOptions"]["cdflash_alpha"]
local size = aCoreCDB["ActionbarOptions"]["cdflash_size"]

local backdrop = {
	  bgFile = G.media.blank,
	  edgeFile = G.media.glow,
	  tile = false, tileSize = 0, edgeSize = 3,
	  insets = { left = 3, right = 3, top = 3, bottom = 3}
}

local flash = CreateFrame("Frame", G.uiname.."Cooldown Flash", UIParent)

flash:SetSize(size,size)
flash:SetBackdrop(backdrop)
flash:SetBackdropColor( 0, 0, 0)
flash:SetBackdropBorderColor(0, 0, 0)

flash.movingname = L["冷却提示"]
flash.point = {
	healer = {a1 = "CENTER", parent = "UIParent", a2 = "CENTER", x = 0, y = 0},
	dpser = {a1 = "CENTER", parent = "UIParent", a2 = "CENTER", x = 0, y = 0},
}
T.CreateDragFrame(flash)

flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash.icon:SetPoint("TOPLEFT", 3, -3)
flash.icon:SetPoint("BOTTOMRIGHT", -3, 3)
flash.icon:SetTexCoord(.08, .92, .08, .92)

flash:Hide()

flash:SetScript("OnUpdate", function(self, e)
	flash.e = flash.e + e
	if flash.e > .75 then
		flash:Hide()
	elseif flash.e < .25 then
		flash:SetAlpha(flash.e*4*minalpha/100)
	elseif flash.e > .5 then
		flash:SetAlpha((1-(flash.e*2))*minalpha/100)
	end
end)

local startcalls = {}
local stopcalls = {}

local addon = CreateFrame("Frame")
local spells = {}
local items = {}
local watched = {}
local nextupdate, lastupdate = 0, 0

local function stop(id, class)
	watched[id] = nil

	for _, func in next, stopcalls do
		func(id, class)
	end

	if aCoreCDB["ActionbarOptions"]["caflash_bl"][class][id] then return end

	flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
	flash.e = 0
	flash:Show()
end

local function update()
	for id in next, watched do
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

	for _, func in next, startcalls do
		func(id, duration, class)
	end

	update()
end

local numTabs, totalspellnum

local function parsespellbook(spellbook)
	i = 1
	while true do
		skilltype, id = GetSpellBookItemInfo(i, spellbook)
		name = GetSpellBookItemName(i, spellbook)
		if name and skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL and not IsPassiveSpell(i, spellbook) then
			spells[id] = true
		end
		i = i + 1
		if i >= totalspellnum then i = 1 break end

		if (id == 88625 or id == 88625 or id == 88625) and (skilltype == "SPELL" and spellbook == BOOKTYPE_SPELL) then
		   spells[88625] = true
		   spells[88684] = true
		   spells[88685] = true
		end
	end
end

-- events --
function addon:LEARNED_SPELL_IN_TAB()
	numTabs = GetNumSpellTabs()
	totalspellnum = 0
	for i=1,numTabs do
		local numSpells = select(4, GetSpellTabInfo(i))
	totalspellnum = totalspellnum + numSpells
	end
	parsespellbook(BOOKTYPE_SPELL)
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