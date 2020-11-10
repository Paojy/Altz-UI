local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

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

local CustomFilter = function(...)
    local name, _, _, _, _, caster, spellID = ...
	
    local priority = 0
	local asc = false
	
    --if ascending[name] then
        --asc = true
    --end

	if aCoreCDB["CooldownAura"]["Buffs"][name] then
		priority = aCoreCDB["CooldownAura"]["Buffs"][name].level
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

	local active_buffs = {}
	local auras = self.AltzTankbuff
	local numBuffs = auras.numBuffs
	local Icon_size = auras.Icon_size
	local anchor_x = auras.anchor_x
	local anchor_y = auras.anchor_y
	
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

	if index > 1 then
		local t = {}
		for name, info in pairs(active_buffs) do
			table.insert(t, info)
		end
		
		sort(t, function(a,b) return a.priority > b.priority or (a.priority == b.priority and a.spellID > b.spellID) end)
		
		for k, info in pairs(t) do
			if k <= numBuffs then
				if not auras["button"..k] then
					if k == 1 then
						auras["button"..k] = CreateAuraIcon(auras, Icon_size, "LEFT", self, "CENTER", anchor_x, anchor_y)
					else
						auras["button"..k] = CreateAuraIcon(auras, Icon_size, "LEFT", auras["button"..(k-1)], "RIGHT", 3, 0)
					end
				end
				updateBuff(auras["button"..k], info["texture"], info["count"], info["dtype"], info["duration"], info["expires"])
				auras["button"..k]:Show()
			end
		end
		
		auras.num_shown = #t
	else
		auras.num_shown = 0
	end
	
    if auras.num_shown < numBuffs then
        for i = numBuffs, auras.num_shown+1, -1 do
			if auras["button"..i] and auras["button"..i]:IsShown() then
				auras["button"..i]:Hide()
			end
		end
    end
end

local Enable = function(self)
    local auras = self.AltzTankbuff

    if(auras) then
		auras.num_shown = auras.num_shown or 0
        self:RegisterEvent("UNIT_AURA", Update, true)
        return true
    end
end

local Disable = function(self)
    local auras = self.AltzTankbuff

    if(auras) then
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement("AltzTankbuff", Update, Enable, Disable)