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

local CreateAuraIcon = function(auras)
    local button = CreateFrame("Button", nil, auras)
    button:EnableMouse(false)
    button:SetAllPoints(auras)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(button)
    icon:SetTexCoord(.07, .93, .07, .93)

    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetFont(G.norFont, auras.cfontsize+2, "THINOUTLINE")
	count:ClearAllPoints()
    count:SetPoint("TOPLEFT", -4, 4)
	count:SetJustifyH("LEFT")
	count:SetTextColor(1, .5, .8)
	
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

local dispelClass = {
	PRIEST = {},
    SHAMAN = { Curse = true },
    PALADIN = { Poison = true, Disease = true },
    MAGE = { Curse = true, },
    DRUID = { Curse = true, Poison = true },
    MONK = { Disease = true, Poison = true},
}

local dispellist = dispelClass[G.myClass] or {}

local checkTalents = CreateFrame"Frame"
checkTalents:RegisterEvent("PLAYER_ENTERING_WORLD")
checkTalents:SetScript("OnEvent", function(self, event)
    if multicheck(G.myClass, "SHAMAN", "PALADIN", "DRUID", "PRIEST", "MONK") then
 
        if G.myClass == "SHAMAN" then
            local tree = GetSpecialization()
 
            dispelClass[G.myClass].Magic = tree == 1 and true
 
        elseif G.myClass == "PALADIN" then
            local tree = GetSpecialization()
 
            dispelClass[G.myClass].Magic = tree == 1 and true
 
        elseif G.myClass == "DRUID" then
            local tree = GetSpecialization()
 
            dispelClass[G.myClass].Magic = tree == 4 and true
 
        elseif G.myClass == "PRIEST" then
            local tree = GetSpecialization()
  
            dispelClass[G.myClass].Magic = (tree == 1 or tree == 2) and true
            dispelClass[G.myClass].Disease = (tree == 1 or tree == 2) and true
			
        elseif G.myClass == "MONK" then
            local tree = GetSpecialization()
			
			dispelClass[G.myClass].Magic = tree == 2 and true
			
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

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype, _, _, caster, spellID = ...

    icon.asc = false
    icon.priority = 0

    --if ascending[name] then
        --icon.asc = true
    --end


	if aCoreCDB["CooldownAura"]["Debuffs"][name] then
		icon.priority = aCoreCDB["CooldownAura"]["Debuffs"][name].level
		return true
	end
	
	if IsInInstance() then
        local ins = GetInstanceInfo()
        if aCoreCDB["RaidDebuff"][ins] then
			for boss, debufflist in pairs(aCoreCDB["RaidDebuff"][ins]) do
				if debufflist[name] then
					icon.priority = debufflist[name].level
					return true
				end
			end
        end
	end
	
    if dispellist[dtype] then
        icon.priority = dispelPriority[dtype]
        return true
    end
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
	
    if dispellist[dtype] then
		backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		backdrop:SetBackdropBorderColor(0, 0, 0)
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

    local cur
    local hide = true
    local auras = self.AltzAuras
    local icon = auras.button
	local backdrop = self.backdrop
	
    local index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitDebuff(unit, index)
        if not name then break end
        
        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster, spellID)

        if(show) then
            if not cur then
                cur = icon.priority
                updateDebuff(backdrop, icon, texture, count, dtype, duration, expires)
            else
                if icon.priority > cur then
                    updateDebuff(backdrop, icon, texture, count, dtype, duration, expires)
                end
            end

            icon:Show()
            hide = false
        end

        index = index + 1
    end

    if hide then
        icon:Hide()
		backdrop:SetBackdropBorderColor(0, 0, 0)
    end
end

local Enable = function(self)
    local auras = self.AltzAuras

    if(auras) then
        auras.button = CreateAuraIcon(auras)
        self:RegisterEvent("UNIT_AURA", Update)
        return true
    end
end

local Disable = function(self)
    local auras = self.AltzAuras

    if(auras) then
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement("AltzAuras", Update, Enable, Disable)