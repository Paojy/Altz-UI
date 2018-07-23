local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

local CreateAuraIcon = function(auras)
    local button = CreateFrame("Button", nil, auras)
    button:EnableMouse(false)
    button:SetAllPoints(auras)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(button)
    icon:SetTexCoord(.07, .93, .07, .93)

    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetFont(G.norFont, auras.cfontsize, "THINOUTLINE")
	count:ClearAllPoints()
    count:SetPoint("TOPLEFT", -2, 2)
	count:SetJustifyH("LEFT")
	
    local border = CreateFrame("Frame", nil, button)
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

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype, _, _, caster, spellID = ...

    icon.priority = 0

	if aCoreCDB["CooldownAura"]["Buffs"][name] then
		icon.priority = aCoreCDB["CooldownAura"]["Buffs"][name].level
		icon.buff = true
		return true
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
local updateBuff = function(icon, texture, count, dtype, duration, expires, buff)
    local color = buffcolor

    icon.border:SetBackdropBorderColor(color.r, color.g, color.b)

    icon.icon:SetTexture(texture)
    icon.count:SetText((count > 1 and count))

    icon.expires = expires
    icon.duration = duration

    icon:SetScript("OnUpdate", AuraTimer)
end

local Update = function(self, event, unit)
    if(self.unit ~= unit) then
	return end

    local cur
    local hide = true
    local auras = self.AltzTankbuff
    local icon = auras.button

    local index = 1
    while true do
        local name, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitBuff(unit, index)
        if not name then break end
        
        local show = CustomFilter(auras, unit, icon, name, texture, count, dtype, duration, expires, caster, spellID)

        if(show) and icon.buff then
			--print(name)
            if not cur then
                cur = icon.priority
                updateBuff(icon, texture, count, dtype, duration, expires, true)
            else
                if icon.priority > cur then
                    updateBuff(icon, texture, count, dtype, duration, expires, true)
                end
            end

            icon:Show()
            hide = false
        end

        index = index + 1
    end

    if hide then
        icon:Hide()
    end
end

local Enable = function(self)
    local auras = self.AltzTankbuff

    if(auras) then
        auras.button = CreateAuraIcon(auras)
        self:RegisterEvent("UNIT_AURA", Update)
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