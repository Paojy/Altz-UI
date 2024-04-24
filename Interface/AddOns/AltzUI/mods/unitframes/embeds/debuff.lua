local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

local function multicheck(check, ...)
    for i=1, select("#", ...) do
        if check == select(i, ...) then return true end
    end
    return false
end

local CreateAuraIcon = function(auras, tag, icon_size, icon_fsize, ...)
	if not auras[tag] then
		local button = CreateFrame("Button", nil, auras)
		button:EnableMouse(false)
		button:SetSize(22, 22)
	
		local icon = button:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(button)
		icon:SetTexCoord(.07, .93, .07, .93)
		button.icon = icon
		
		local count = button:CreateFontString(nil, "OVERLAY")
		count:SetFont(G.norFont, 10, "THINOUTLINE")
		count:ClearAllPoints()
		count:SetPoint("TOPLEFT", -4, 4)
		count:SetJustifyH("LEFT")
		count:SetTextColor(1, .5, .8)
		button.count = count
		
		local border = CreateFrame("Frame", nil, button, "BackdropTemplate")
		border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
		border:SetFrameLevel(4)
		border:SetBackdrop(glowBorder)
		border:SetBackdropColor(0,0,0,1)
		border:SetBackdropBorderColor(0,0,0,1)
		button.border = border
	
		local remaining = button:CreateFontString(nil, "OVERLAY")
		remaining:SetFont(G.norFont, 8, "THINOUTLINE")
		remaining:SetPoint("BOTTOMRIGHT", 4, -2)
		remaining:SetJustifyH("RIGHT")
		remaining:SetTextColor(1, 1, 0)
		button.remaining = remaining
		
		button.parent = auras
		button:Hide()
		
		auras[tag] = button
	end
	
	local bu = auras[tag]
	bu:ClearAllPoints()
	bu:SetPoint(...)
	bu:SetSize(icon_size, icon_size)
	bu.count:SetFont(G.norFont, icon_fsize+2, "THINOUTLINE")
	bu.remaining:SetFont(G.norFont, icon_fsize, "THINOUTLINE")
end

local dispelClass = {
	PRIEST = {Disease = true},
    SHAMAN = {Curse = true},
    PALADIN = {Poison = true, Disease = true},
    DRUID = {Curse = true, Poison = true},
    MONK = {Disease = true, Poison = true},	
}

local dispellist = dispelClass[G.myClass] or {}

local checkTalents = CreateFrame"Frame"
checkTalents:RegisterEvent("PLAYER_ENTERING_WORLD")
checkTalents:SetScript("OnEvent", function(self, event)
    if multicheck(G.myClass, "SHAMAN", "PALADIN", "DRUID", "PRIEST", "MONK") then
		local tree = GetSpecialization()
		
        if G.myClass == "SHAMAN" then
			if tree == 3 then
				dispellist.Magic = true
			else
				dispellist.Magic = false
			end
        elseif G.myClass == "PALADIN" then
			if tree == 1 then
				dispellist.Magic = true
			else
				dispellist.Magic = false
			end
        elseif G.myClass == "DRUID" then
            if tree == 4 then
				dispellist.Magic = true
			else
				dispellist.Magic = false
			end
        elseif G.myClass == "PRIEST" then
			if tree == 1 or tree == 2 then
				dispellist.Magic = true
			else
				dispellist.Magic = false
			end
        elseif G.myClass == "MONK" then
            if tree == 2 then
				dispellist.Magic = true
			else
				dispellist.Magic = false
			end
        end
    end
 
	--for k, v in pairs(dispellist) do
		--print(k,v)
	--end
	
    if event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
    end
end)

local dispelPriority = {
    Magic = 4,
    Curse = 3,
    Poison = 2,
    Disease = 1,
}

--local ascending = { }

local current_encounter
local checkEncounter = CreateFrame"Frame"
checkEncounter:RegisterEvent("ENCOUNTER_START")
checkEncounter:RegisterEvent("ENCOUNTER_END")
checkEncounter:RegisterEvent("PLAYER_ENTERING_WORLD")
checkEncounter:SetScript("OnEvent", function(self, event, ...)
	local encounterID = ...
	if event == "ENCOUNTER_START" then
		current_encounter = encounterID
	else
		current_encounter = 1
	end
end)

local gold_str = "|Hgarrmission:altz_config_altz::%s::%s::%s|h|cFFFFD700[%s]|r|h"
local red_str = "|Hgarrmission:altz_delete_altz::%s::%s::%s|h|cFFDC143C[%s]|r|h"

local CustomFilter = function(name, dtype, spellID, castByPlayer)
    local priority = 0
	local asc = false

    --if ascending[name] then
        --asc = true
    --end
	if aCoreCDB["UnitframeOptions"]["debuff_list_black"][spellID] then -- 黑名单不显示
		return 0, false
	elseif aCoreCDB["UnitframeOptions"]["debuff_list"][spellID] then -- 白名单显示
		priority = aCoreCDB["UnitframeOptions"]["debuff_list"][spellID]
	elseif dispellist[dtype] then -- 可驱散
        priority = dispelPriority[dtype]
	elseif IsInInstance() then -- 副本
	
		local map = C_Map.GetBestMapForUnit("player")
		local InstanceID = map and EJ_GetInstanceForMap(map)
		if map and InstanceID and aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID] then -- 排除非手册副本、如场景战役
			if current_encounter == 1 then
				if not aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1] then
					aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1] = {}
				end
				
				if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1][spellID] then -- 找到了
					priority = aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1][spellID]
				elseif aCoreCDB["UnitframeOptions"]["debuff_auto_add"] and not castByPlayer then -- 没有找到，可以添加
					aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1][spellID] = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
					print(format(L["添加团队减益"], L["杂兵"], T.GetIconLink(spellID)), format(gold_str, InstanceID, 1, spellID, L["设置"]), format(red_str, InstanceID, 1, spellID, L["删除并加入黑名单"]))
					priority = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
				end
			elseif current_encounter then -- BOSS战斗中
				local dataIndex = 1
				EJ_SelectInstance(InstanceID)
				local encounterName, _, encounterID, _, _, _, dungeonEncounterID = EJ_GetEncounterInfoByIndex(dataIndex, InstanceID)
				while encounterName ~= nil do
					if dungeonEncounterID == current_encounter then
						if not aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID] then
							aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID] = {}
						end
						if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] then -- 找到了
							priority = aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID]
						elseif aCoreCDB["UnitframeOptions"]["debuff_auto_add"] and not castByPlayer then -- 没有找到，可以添加
							aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
							print(format(L["添加团队减益"], encounterName, T.GetIconLink(spellID)), format(gold_str, InstanceID, encounterID, spellID, L["设置"]), format(red_str, InstanceID, encounterID, spellID, L["删除并加入黑名单"]))
							priority = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
						end
						break
					end
					dataIndex = dataIndex + 1
					EJ_SelectInstance(InstanceID)
					encounterName, _, encounterID, _, _, _, dungeonEncounterID = EJ_GetEncounterInfoByIndex(dataIndex, InstanceID)
				end
			end
		end
    end
	
	return priority, asc
end

local AuraTimerAsc = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < .2 then return end
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        local duration = self.duration - timeLeft
        self.remaining:SetText(T.FormatTime(duration))
    end
end

local AuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < .2 then return end
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        self.remaining:SetText(T.FormatTime(timeLeft))
    end
end

local updateDebuff = function(icon, texture, count, dtype, duration, expires)
    local color = DebuffTypeColor[dtype] or DebuffTypeColor.none

    icon.border:SetBackdropBorderColor(color.r, color.g, color.b)
    icon.icon:SetTexture(texture)
	
	if count and count> 1 then
		icon.count:SetText()
	else
		icon.count:SetText("")
	end

    icon.expires = expires
    icon.duration = duration

    if icon.asc then
        icon:SetScript("OnUpdate", AuraTimerAsc)
    else
        icon:SetScript("OnUpdate", AuraTimer)
    end
end

local Update = function(self, event, unit)
    if(self.unit ~= unit) then return end

	local active_dubuffs = {}
    local auras = self.AltzAuras2
	
	local numDebuffs = aCoreCDB["UnitframeOptions"]["raid_debuff_num"]
	local anchor_x = aCoreCDB["UnitframeOptions"]["raid_debuff_anchor_x"]
	local anchor_y = aCoreCDB["UnitframeOptions"]["raid_debuff_anchor_y"]
	local icon_size = aCoreCDB["UnitframeOptions"]["raid_debuff_icon_size"]
	local icon_fsize = aCoreCDB["UnitframeOptions"]["raid_debuff_icon_fontsize"]
	
    local index = 1
    while true do
        local name, texture, count, dtype, duration, expires, caster, _, _, spellID, _, isBossDebuff, castByPlayer = UnitDebuff(unit, index)
        if not name then break end
		
		local priority, asc = CustomFilter(name, dtype, spellID, castByPlayer)
		
		if priority > 0 then
			active_dubuffs[name] = {}
			active_dubuffs[name]["priority"] = priority
			active_dubuffs[name]["spellID"] = spellID
			active_dubuffs[name]["asc"] = asc
			active_dubuffs[name]["texture"] = texture
			active_dubuffs[name]["count"] = count
			active_dubuffs[name]["dtype"] = dtype
			active_dubuffs[name]["duration"] = duration
			active_dubuffs[name]["expires"] = expires
		end

		index = index + 1
    end

	local k = 1
	while auras["button"..k] do
		auras["button"..k].active = false
		k = k + 1
	end
	
	local show_dispel_border
	if index > 1 then
		local t = {}
		for name, info in pairs(active_dubuffs) do
			table.insert(t, info)
		end
		
		sort(t, function(a,b) return a.priority > b.priority or (a.priority == b.priority and a.spellID > b.spellID) end)
		
		for k, info in pairs(t) do
			if k <= numDebuffs then
				if k == 1 then
					CreateAuraIcon(auras, "button"..k, icon_size, icon_fsize, "LEFT", self, "CENTER", anchor_x, anchor_y)
				else
					CreateAuraIcon(auras, "button"..k, icon_size, icon_fsize, "LEFT", auras["button"..(k-1)], "RIGHT", 3, 0)
				end
				updateDebuff(auras["button"..k], info["texture"], info["count"], info["dtype"], info["duration"], info["expires"])
				auras["button"..k]:Show()
				auras["button"..k].active = true

				if not show_dispel_border and info.dtype and dispellist[info.dtype] then -- 可驱散，只取第一个
					local color = DebuffTypeColor[info.dtype]
					self.Health.backdrop:SetBackdropBorderColor(color.r, color.g, color.b) -- 单位框架边框
					show_dispel_border = true
				end
			end
		end
	end
	
	if not show_dispel_border then
		self.Health.backdrop:SetBackdropBorderColor(0, 0, 0)
	end
	
	local k = 1
	while auras["button"..k] do
		if not auras["button"..k].active then
			auras["button"..k]:Hide()
		end
		k = k + 1
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
    local auras = self.AltzAuras2
    if (auras) then
		auras.__owner = self
		auras.ForceUpdate = ForceUpdate

        self:RegisterEvent("UNIT_AURA", Update, true)
		
        return true
    end
end

local Disable = function(self)
    local auras = self.AltzAuras2

    if auras then
		auras:Hide()
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement("AltzAuras2", Update, Enable, Disable)