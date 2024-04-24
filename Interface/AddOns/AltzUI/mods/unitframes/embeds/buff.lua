local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

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

local CustomFilter = function(...)
    local name, _, _, _, _, caster, spellID = ...
	
    local priority = 0
	local asc = false
	
    --if ascending[name] then
        --asc = true
    --end

	if aCoreCDB["UnitframeOptions"]["buff_list"][spellID] then
		priority = aCoreCDB["UnitframeOptions"]["buff_list"][spellID]
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

local buffcolor = { r = 0.5, g = 1.0, b = 1.0 }
local updateBuff = function(icon, texture, count, dtype, duration, expires)
    local color = buffcolor

    icon.border:SetBackdropBorderColor(color.r, color.g, color.b)

    icon.icon:SetTexture(texture)
	if count and count > 1 then
		icon.count:SetText(count)
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

	local active_buffs = {}
	local auras = self.AltzTankbuff
	
	local numBuffs = aCoreCDB["UnitframeOptions"]["raid_buff_num"]
	local anchor_x = aCoreCDB["UnitframeOptions"]["raid_buff_anchor_x"]
	local anchor_y = aCoreCDB["UnitframeOptions"]["raid_buff_anchor_y"]
	local icon_size = aCoreCDB["UnitframeOptions"]["raid_buff_icon_size"]
	local icon_fsize = aCoreCDB["UnitframeOptions"]["raid_buff_icon_fontsize"]
	
    local index = 1
    while true do
        local name, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitBuff(unit, index)
        if not name then break end
        
        local priority, asc = CustomFilter(name, texture, count, duration, expires, caster, spellID)

		if priority > 0 then
			active_buffs[name] = {}
			active_buffs[name]["priority"] = priority
			active_buffs[name]["spellID"] = spellID
			active_buffs[name]["asc"] = asc
			active_buffs[name]["texture"] = texture
			active_buffs[name]["count"] = count
			active_buffs[name]["duration"] = duration
			active_buffs[name]["expires"] = expires
		end
		
		index = index + 1
    end
	
	local k = 1
	while auras["button"..k] do
		auras["button"..k].active = false
		k = k + 1
	end
	
	if index > 1 then
		local t = {}
		for name, info in pairs(active_buffs) do
			table.insert(t, info)
		end
		
		sort(t, function(a,b) return a.priority > b.priority or (a.priority == b.priority and a.spellID > b.spellID) end)
		
		for k, info in pairs(t) do
			if k <= numBuffs then
				if k == 1 then
					CreateAuraIcon(auras, "button"..k, icon_size, icon_fsize, "LEFT", self, "CENTER", anchor_x, anchor_y)
				else
					CreateAuraIcon(auras, "button"..k, icon_size, icon_fsize, "LEFT", auras["button"..(k-1)], "RIGHT", 3, 0)
				end
				updateBuff(auras["button"..k], info["texture"], info["count"], info["dtype"], info["duration"], info["expires"])
				auras["button"..k]:Show()
				auras["button"..k].active = true
			end
		end
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
    local auras = self.AltzTankbuff
    if(auras) then
		auras.__owner = self
		auras.ForceUpdate = ForceUpdate
	
        self:RegisterEvent("UNIT_AURA", Update, true)
		
        return true
    end
end

local Disable = function(self)
    local auras = self.AltzTankbuff

    if(auras) then
		auras:Hide()
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement("AltzTankbuff", Update, Enable, Disable)