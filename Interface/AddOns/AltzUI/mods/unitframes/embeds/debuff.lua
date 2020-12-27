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

local CreateAuraIcon = function(auras, size, ...)
    local button = CreateFrame("Button", nil, auras)
    button:EnableMouse(false)
	button:SetSize(size, size)
    button:SetPoint(...)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(button)
    icon:SetTexCoord(.07, .93, .07, .93)

    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetFont(G.norFont, auras.cfontsize+2, "THINOUTLINE")
	count:ClearAllPoints()
    count:SetPoint("TOPLEFT", -4, 4)
	count:SetJustifyH("LEFT")
	count:SetTextColor(1, .5, .8)
	
    local border = CreateFrame("Frame", nil, button, "BackdropTemplate")
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    border:SetFrameLevel(4)
    border:SetBackdrop(glowBorder)
    border:SetBackdropColor(0,0,0,1)
    border:SetBackdropBorderColor(0,0,0,1)
    button.border = border

    local remaining = button:CreateFontString(nil, "OVERLAY")
    remaining:SetFont(G.norFont, auras.tfontsize, "THINOUTLINE")
    remaining:SetPoint("BOTTOMRIGHT", 4, -2)
	remaining:SetJustifyH("RIGHT")
    remaining:SetTextColor(1, 1, 0)

    button.parent = auras
    button.icon = icon
    button.count = count
	button.remaining = remaining
    button.cd = cd
    button:Hide()

    return button
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
	local encounterID, encounterName = ...
	if event == "ENCOUNTER_START" then
		current_encounter = encounterName
	else
		current_encounter = ""
	end
end)

local gold_str = "|Hgarrmission:altz_config_altz::%s::%s::%s::%s|h|cFFFFD700[%s]|r|h"
local red_str = "|Hgarrmission:altz_delete_altz::%s::%s::%s::%s|h|cFFDC143C[%s]|r|h"

local CustomFilter = function(...)
    local name, _, _, dtype, _, _, caster, spellID, _, castByPlayer = ...
	
    local priority = 0
	local asc = false
	
    --if ascending[name] then
        --asc = true
    --end
	if aCoreCDB["CooldownAura"]["Debuffs_Black"][name] then -- 黑名单不显示
		return 0, false
	elseif IsInInstance() and aCoreCDB["UnitframeOptions"]["debuff_auto_add"] then
		local ins = EJ_GetInstanceInfo(EJ_GetInstanceForMap(C_Map.GetBestMapForUnit("player")))
		if ins and aCoreCDB["RaidDebuff"][ins] then	
			if not castByPlayer then --小怪
				if aCoreCDB["RaidDebuff"][ins]["Trash"] and not aCoreCDB["RaidDebuff"][ins]["Trash"][name] then
					aCoreCDB["RaidDebuff"][ins]["Trash"][name] = {id = spellID, level = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]}
					print(format(L["添加团队减益"], L["杂兵"], T.GetIconLink(spellID)), format(gold_str, ins, "Trash", name, spellID, L["设置"]), format(red_str, ins, "Trash", name, spellID, L["删除并加入黑名单"]))
					priority = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
				end				
			end
		end
	elseif aCoreCDB["CooldownAura"]["Debuffs"][name] then -- 白名单显示
		priority = aCoreCDB["CooldownAura"]["Debuffs"][name].level
	elseif dispellist[dtype] then -- 可驱散
        priority = dispelPriority[dtype]
	elseif IsInInstance() then -- 副本列表中
        local ins = EJ_GetInstanceInfo(EJ_GetInstanceForMap(C_Map.GetBestMapForUnit("player")))
        if aCoreCDB["RaidDebuff"][ins] then
			for boss, debufflist in pairs(aCoreCDB["RaidDebuff"][ins]) do
				if debufflist[name] then
					priority = debufflist[name].level
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

local updateDebuff = function(backdrop, icon, texture, count, dtype, duration, expires)
    local color = DebuffTypeColor[dtype] or DebuffTypeColor.none

    icon.border:SetBackdropBorderColor(color.r, color.g, color.b)
	
	if backdrop then
		if dispellist[dtype] then
			backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			backdrop:SetBackdropBorderColor(0, 0, 0)
		end
	end
	
    icon.icon:SetTexture(texture)
    icon.count:SetText((count > 1 and count))

    icon.expires = expires
    icon.duration = duration

    if icon.asc then
        icon:SetScript("OnUpdate", AuraTimerAsc)
    else
        icon:SetScript("OnUpdate", AuraTimer)
    end
end

local Update = function(self, event, unit)
    if(self.unit ~= unit) then
	return end

	local active_dubuffs = {}
    local auras = self.AltzAuras2
	local numDebuffs = auras.numDebuffs
	local Icon_size = auras.Icon_size
	local anchor_x = auras.anchor_x
	local anchor_y = auras.anchor_y
	local backdrop = self.backdrop
	
    local index = 1
    while true do
        local name, texture, count, dtype, duration, expires, caster, _, _, spellID, _, isBossDebuff, castByPlayer = UnitDebuff(unit, index)
        if not name then break end
		
		local priority, asc = CustomFilter(name, texture, count, dtype, duration, expires, caster, spellID, isBossDebuff, castByPlayer)
		
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
	
	if index > 1 then
		local t = {}
		for name, info in pairs(active_dubuffs) do
			table.insert(t, info)
		end
		
		sort(t, function(a,b) return a.priority > b.priority or (a.priority == b.priority and a.spellID > b.spellID) end)
		
		for k, info in pairs(t) do
			if k <= numDebuffs then
				if not auras["button"..k] then
					if k == 1 then
						auras["button"..k] = CreateAuraIcon(auras, Icon_size, "LEFT", self, "CENTER", anchor_x, anchor_y)
					else
						auras["button"..k] = CreateAuraIcon(auras, Icon_size, "LEFT", auras["button"..(k-1)], "RIGHT", 3, 0)
					end
				end
				if k == 1 then
					updateDebuff(backdrop, auras["button"..k], info["texture"], info["count"], info["dtype"], info["duration"], info["expires"])
				else
					updateDebuff(nil, auras["button"..k], info["texture"], info["count"], info["dtype"], info["duration"], info["expires"])
				end
				auras["button"..k]:Show()
			end
		end
		
		auras.num_shown = #t
	else
		auras.num_shown = 0
	end
	
    if auras.num_shown < numDebuffs then
        for i = numDebuffs, auras.num_shown+1, -1 do
			if auras["button"..i] and auras["button"..i]:IsShown() then
				auras["button"..i]:Hide()
				if i == 1 then
					backdrop:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
    end
end

local Enable = function(self)
    local auras = self.AltzAuras2

    if auras then
		auras.num_shown = auras.num_shown or 0
        self:RegisterEvent("UNIT_AURA", Update, true)
        return true
    end
end

local Disable = function(self)
    local auras = self.AltzAuras2

    if auras then
		self.auras:Hide()
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement("AltzAuras2", Update, Enable, Disable)