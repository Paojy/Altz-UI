local addon, ns = ...

local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"
local texture = "Interface\\Buttons\\WHITE8x8"
local highlighttexture = "Interface\\AddOns\\oUF_Mlight\\media\\highlight"

oUF.colors.power["MANA"] = {.3, .8, 1}
oUF.colors.power["RAGE"] = {.9, .1, .1}
oUF.colors.power["FUEL"] = {0, 0.55, 0.5}
oUF.colors.power["FOCUS"] = {.9, .5, .1}
oUF.colors.power["ENERGY"] = {.9, .9, .1}
oUF.colors.power["AMMOSLOT"] = {0.8, 0.6, 0}
oUF.colors.power["RUNIC_POWER"] = {.1, .9, .9}
oUF.colors.power["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61}
oUF.colors.power["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17}

oUF.colors.reaction[1] = {255/255, 30/255, 60/255}
oUF.colors.reaction[2] = {255/255, 30/255, 60/255}
oUF.colors.reaction[3] = {255/255, 30/255, 60/255}
oUF.colors.reaction[4] = {1, 1, 0}
oUF.colors.reaction[5] = {0.26, 1, 0.22}
oUF.colors.reaction[6] = {0.26, 1, 0.22}
oUF.colors.reaction[7] = {0.26, 1, 0.22}
oUF.colors.reaction[8] = {0.26, 1, 0.22}

oUF.colors.smooth = {1,0,0, 1,1,0, 1,1,0}	

local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local frameBD = {
    edgeFile = [=[Interface\AddOns\oUF_Mlight\media\grow]=], edgeSize = 3,
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local FormatValue = ns.FormatValue
local FormatTime = ns.FormatTime
local hex = ns.hex
--=============================================--
--[[                 Functions               ]]--
--=============================================--
local function multicheck(check, ...)
    for i=1, select("#", ...) do
        if check == select(i, ...) then return true end
    end
    return false
end

local createBackdrop = function(parent, anchor, a) 
    local frame = CreateFrame("Frame", nil, parent)

	local flvl = parent:GetFrameLevel()
	if flvl - 1 >= 0 then frame:SetFrameLevel(flvl-1) end

	frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -3, 3)
    frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 3, -3)

    frame:SetBackdrop(frameBD)
	if a then
		frame:SetBackdropColor(.25, .25, .25, a)
		frame:SetBackdropBorderColor(0, 0, 0)
	end

    return frame
end
ns.createBackdrop = createBackdrop

local fixStatusbar = function(bar)
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
end

local createStatusbar = function(parent, tex, layer, height, width, r, g, b, alpha)
    local bar = CreateFrame"StatusBar"
    bar:SetParent(parent)
    if height then
        bar:SetHeight(height)
    end
    if width then
        bar:SetWidth(width)
    end
    bar:SetStatusBarTexture(tex, layer)
    bar:SetStatusBarColor(r, g, b, alpha)
    fixStatusbar(bar)

    return bar
end
ns.createStatusbar = createStatusbar

local createFont = function(parent, layer, f, fs, outline, r, g, b, justify)
    local string = parent:CreateFontString(nil, layer)
    string:SetFont(f, fs, outline)
    string:SetShadowOffset(0, 0)
    string:SetTextColor(r, g, b)
    if justify then
        string:SetJustifyH(justify)
    end
    return string
end
ns.createFont = createFont
--=============================================--
--[[    Dropdown menu and MouseOn update     ]]--
--=============================================--
local dropdown = CreateFrame("Frame", addon .. "DropDown", UIParent, "UIDropDownMenuTemplate")

local menu = function(self)
    dropdown:SetParent(self)
    return ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end

local init = function(self)
    local unit = self:GetParent().unit
    local menu, name, id

    if(not unit) then
        return
    end

    if(UnitIsUnit(unit, "player")) then
        menu = "SELF"
    elseif(UnitIsUnit(unit, "vehicle")) then
        menu = "VEHICLE"
    elseif(UnitIsUnit(unit, "pet")) then
        menu = "PET"
    elseif(UnitIsPlayer(unit)) then
        id = UnitInRaid(unit)
        if(id) then
            menu = "RAID_PLAYER"
            name = GetRaidRosterInfo(id)
        elseif(UnitInParty(unit)) then
            menu = "PARTY"
        else
            menu = "PLAYER"
        end
    else
        menu = "TARGET"
        name = RAID_TARGET_ICON
    end

    if(menu) then
        UnitPopup_ShowMenu(self, menu, unit, name, id)
    end
end
UIDropDownMenu_Initialize(dropdown, init, "MENU")

local OnMouseOver = function(self)
    local OnEnter = function(self)
		UnitFrame_OnEnter(self)
		self.isMouseOver = true
		for _, element in ipairs(self.mouseovers) do
			element:ForceUpdate()
		end
    end
    local OnLeave = function(self)
		UnitFrame_OnLeave(self)
		self.isMouseOver = false
		for _, element in ipairs(self.mouseovers) do
			element:ForceUpdate()
		end
    end
    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)
end
ns.OnMouseOver = OnMouseOver
--=============================================--
--[[               Some update               ]]--
--=============================================--
local Updatehealthbar = function(self, unit, min, max)
	local r, g, b
	local perc
	
	if max ~= 0 then perc = min/max else perc = 1 end
	
	if self.value then
		if min > 0 and min < max then
			self.value:SetText(FormatValue(min).." "..hex(1, 0, 1).."|r"..hex(1, 1, 0)..math.floor(min/max*100+.5).."|r")
		elseif min > 0 and self.__owner.isMouseOver and UnitIsConnected(unit) then
			self.value:SetText(FormatValue(min))
		else
			self.value:SetText(nil)
		end
	end
	
	if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		r, g, b = .6, .6, .6
	elseif not UnitIsConnected(unit) then
		r, g, b = .3, .3, .3
	elseif UnitIsGhost(unit) then
		r, g, b = .6, .6, .6
	elseif UnitIsDead(unit) then
		r, g, b = 1, 0, 0
	elseif (unit == "pet") then
		local _, playerclass = UnitClass("player")
		if oUF_MlightDB.classcolormode then
			r, g, b = unpack(oUF.colors.class[playerclass])
		else
			r, g, b = oUF.ColorGradient(perc, 1, unpack(oUF.colors.smooth))
		end
	elseif(UnitIsPlayer(unit)) then
		local _, unitclass = UnitClass(unit)
		if oUF_MlightDB.classcolormode then
			if unitclass then r, g, b = unpack(oUF.colors.class[unitclass]) else r, g, b = 1, 1, 1 end
		else
			r, g, b = oUF.ColorGradient(perc, 1, unpack(oUF.colors.smooth))
		end
	elseif unit then
		if oUF_MlightDB.classcolormode then
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player") or 5])
		else
			r, g, b = oUF.ColorGradient(perc, 1, unpack(oUF.colors.smooth))
		end
	end

	self:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/3, g/3, b/3)
	
	if oUF_MlightDB.transparentmode then
		self:SetValue(max - self:GetValue()) 
	end
end
ns.Updatehealthbar = Updatehealthbar

local Updatepowerbar = function(self, unit, min, max)
	local r, g, b
	local type = select(2, UnitPowerType(unit))
	local powercolor = oUF.colors.power[type] or oUF.colors.power.FUEL
	
	if self.value then 	
		if self.__owner.isMouseOver and type == 'MANA' and UnitIsConnected(unit) then
			self.value:SetText(hex(unpack(powercolor))..FormatValue(min)..'|r')
		elseif min > 0 and min < max then
			if type == 'MANA' then
				self.value:SetText(hex(1, 1, 1)..math.floor(min/max*100+.5)..'|r'..hex(1, .4, 1)..'%|r')
			else
				self.value:SetText(hex(unpack(powercolor))..FormatValue(min)..'|r')
			end
		else
			self.value:SetText(nil)
		end
	end
	
	if oUF_MlightDB.classcolormode then
		r, g, b = unpack(powercolor)
	elseif(UnitIsPlayer(unit)) then
		local _, unitclass = UnitClass(unit)
		r, g, b = unpack(oUF.colors.class[unitclass])
	else
		r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, 'player') or 5])
	end
	
	self:GetStatusBarTexture():SetGradient('VERTICAL', r, g, b, r/3, g/3, b/3)
end
		
local PostEclipseUpdate = function(element, unit)
    if element.hasSolarEclipse then
        element.bd:SetBackdropBorderColor(1, .6, 0)
        element.bd:SetBackdropColor(1, .6, 0)
    elseif element.hasLunarEclipse then
        element.bd:SetBackdropBorderColor(0, .4, 1)
        element.bd:SetBackdropColor(0, .4, 1)
    else
        element.bd:SetBackdropBorderColor(0, 0, 0)
        element.bd:SetBackdropColor(0, 0, 0)
    end
end

local PostAltUpdate = function(altpp, min, cur, max)
    local self = altpp.__owner
	
	altpp.value:SetText(cur)
	
    local tPath, r, g, b = UnitAlternatePowerTextureInfo(self.unit, 2)
    if(r) then
        altpp:SetStatusBarColor(r, g, b, 1)
    else
        altpp:SetStatusBarColor(1, 1, 1, .8)
    end 
end

local HarmonyOverride = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "LIGHT_FORCE")) then return end
	
	local cholder = self.Harmony
	
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	local maxchi = UnitPowerMax("player", SPELL_POWER_LIGHT_FORCE)
	
	if not cholder.maxchi then cholder.maxchi = 5 end
	
	if cholder.maxchi ~= maxchi then
		for i = 1, 5 do
			cholder[i]:SetWidth((oUF_MlightDB.width+3)/maxchi-3)
		end
		
		cholder.maxchi = maxchi
	end

	for i = 1, 5 do
		if i <= chi then
			cholder[i]:SetAlpha(1)
		else
			cholder[i]:SetAlpha(0)
		end
	end
end

local HolyPowerOverride = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end
	
	local hholder = self.HolyPower
	
	local holypower = UnitPower("player", SPELL_POWER_HOLY_POWER)
	local maxholypower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
	
	if not hholder.maxholypower then hholder.maxholypower = 5 end
	
	if hholder.maxholypower ~= maxholypower then
		for i = 1, 5 do
			hholder[i]:SetWidth((oUF_MlightDB.width+3)/maxholypower-3)
		end
		
		hholder.maxholypower = maxholypower
	end

	for i = 1, 5 do
		if i <= holypower then
			hholder[i]:SetAlpha(1)
		else
			hholder[i]:SetAlpha(0)
		end
	end
end
--=============================================--
--[[                 Castbars                ]]--
--=============================================--
local PostCastStart = function(castbar, unit)
	local uc = {1, 0, 0}
    if unit == "player" then
		castbar.IBackdrop:SetBackdropBorderColor(0, 0, 0)
	else
		if castbar.interrupt then
		    castbar.IBackdrop:SetBackdropBorderColor(uc[1], uc[2], uc[3])
        else
            castbar.IBackdrop:SetBackdropBorderColor(0, 0, 0)
        end
    end
end

local CustomTimeText = function(castbar, duration)
    if castbar.casting then
        castbar.Time:SetFormattedText("|cff97FFFF%.1f/%.1f|r", duration, castbar.max)
    elseif castbar.channeling then
        castbar.Time:SetFormattedText("|cff97FFFF%.1f/%.1f|r", castbar.max - duration, castbar.max)
    end
end

local CreateCastbars = function(self, unit)
    local u = unit:match("[^%d]+")
    if multicheck(u, "target", "player", "focus", "boss") then
        local cb = createStatusbar(self, texture, "ARTWORK", nil, nil, 0, 0, 0, 0) -- transparent
		cb:SetAllPoints(self)
        cb:SetFrameLevel(1)

        cb.Spark = cb:CreateTexture(nil, "OVERLAY")
		cb.Spark:SetTexture("Interface\\UnitPowerBarAlt\\Generic1Player_Pill_Flash")
        cb.Spark:SetBlendMode("ADD")
        cb.Spark:SetAlpha(1)
        cb.Spark:SetSize(8, oUF_MlightDB.height*2)

        cb.Time = createFont(cb, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, "OUTLINE", 1, 1, 1)
		if (unit == "player") then
			cb.Time:SetFont(oUF_MlightDB.fontfile, oUF_MlightDB.fontsize+2, "OUTLINE")
			cb.Time:SetPoint("TOP", cb, "BOTTOM", 0, -10)
		else
			cb.Time:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", -3, -3)
		end
        cb.CustomTimeText = CustomTimeText

        cb.Text = createFont(cb, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, "OUTLINE", 1, 1, 1)
		if u == "boss" then
			cb.Text:SetPoint("BOTTOMLEFT", 3, -3)
		else
			cb.Text:SetPoint("BOTTOM", 0, -3)
		end
		
        cb.Icon = cb:CreateTexture(nil, "ARTWORK")
        cb.Icon:SetSize(oUF_MlightDB.cbIconsize, oUF_MlightDB.cbIconsize)
        cb.Icon:SetTexCoord(.1, .9, .1, .9)
		cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -7, -oUF_MlightDB.height*(1-oUF_MlightDB.hpheight)-3)

		cb.IBackdrop = createBackdrop(cb, cb.Icon)
		
		--safezone for castbar of player
        if (unit == "player") then
            cb.SafeZone = cb:CreateTexture(nil, "OVERLAY")
            cb.SafeZone:SetTexture(texture)
            cb.SafeZone:SetVertexColor( .3, .8, 1, .3)
        end

        cb.PostCastStart = PostCastStart
        cb.PostChannelStart = PostCastStart

        self.Castbar = cb
    end
end

--=============================================--
--[[                   Auras                 ]]--
--=============================================--
local PostCreateIcon = function(auras, icon)
    icon.icon:SetTexCoord(.07, .93, .07, .93)

    icon.count:ClearAllPoints()
    icon.count:SetPoint("BOTTOMRIGHT", 3, -3)
    icon.count:SetFontObject(nil)
    icon.count:SetFont(oUF_MlightDB.fontfile, 12, "OUTLINE")
    icon.count:SetTextColor(.9, .9, .1)

	icon.overlay:SetTexture(texture)
	icon.overlay:SetDrawLayer("BACKGROUND")
    icon.overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
    icon.overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)

	icon.bd = createBackdrop(icon, icon, 0)

	icon.remaining = createFont(icon, "OVERLAY", oUF_MlightDB.fontfile, 12, "OUTLINE", 1, 1, 1)
    icon.remaining:SetPoint("TOPLEFT", -3, 2)

    if oUF_MlightDB.auraborders then
        auras.showDebuffType = true
	else
		auras.showDebuffType = false
	end
end

local CreateAuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < .2 then return end
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        self.remaining:SetText(FormatTime(timeLeft))
    end
end

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local name, _, _, _, _, duration, expirationTime, _, _, _, SpellID = UnitAura(unit, index, icon.filter)

	if icon.isPlayer or UnitIsFriend("player", unit) or not icon.isDebuff or oUF_MlightDB.AuraFilterwhitelist[tostring(SpellID)] then
		icon.icon:SetDesaturated(false)
		if duration and duration > 0 then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon.count:Show()
	else
		icon.icon:SetDesaturated(true) -- grey other's debuff casted on enemy.
		icon.overlay:Hide()
		icon.remaining:Hide()
		icon.count:Hide()
	end
		
	if duration then
		icon.bd:Show() -- if the aura is not a gap icon show it"s bd
	end
		
	icon.expires = expirationTime
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

local PostUpdateGapIcon = function(auras, unit, icon, visibleBuffs)
	icon.bd:Hide()
	icon.remaining:Hide()
end

local CustomFilter = function(icons, unit, icon, ...)
	local SpellID = select(11, ...)
	if icon.isPlayer then -- show all my auras
		return true
	elseif UnitIsFriend("player", unit) and (not oUF_MlightDB.AuraFilterignoreBuff or icon.isDebuff) then
		return true
	elseif not UnitIsFriend("player", unit) and (not oUF_MlightDB.AuraFilterignoreDebuff or not icon.isDebuff) then
		return true
	elseif oUF_MlightDB.AuraFilterwhitelist[tostring(SpellID)] then
		return true
	end
end

local BossAuraFilter = function(icons, unit, icon, ...)
	if icon.isPlayer or not icon.isDebuff then -- show buff and my auras
		return true
	end
end

local CreateAuras = function(self, unit)
	local u = unit:match("[^%d]+")
    if multicheck(u, "target", "focus", "boss") then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetHeight(oUF_MlightDB.height*2)
		Auras:SetWidth(oUF_MlightDB.width-2)
		Auras.gap = true
		Auras.disableCooldown = true
		if select(2, UnitClass("player")) == "MAGE" then
			Auras.showStealableBuffs = true 
		end
		Auras.size = (oUF_MlightDB.width+3)/oUF_MlightDB.auraperrow-3
		Auras.spacing = 3
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		Auras.PostUpdateGapIcon = PostUpdateGapIcon
		
		if unit == "target" or unit == "focus" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 12)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = oUF_MlightDB.auraperrow
			Auras.numBuffs = oUF_MlightDB.auraperrow
			if unit == "target" and (oUF_MlightDB.AuraFilterignoreBuff or oUF_MlightDB.AuraFilterignoreDebuff) then
				Auras.CustomFilter = CustomFilter
			end
		else -- boss 1-5
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 12)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"	
			Auras.numDebuffs = 4
			Auras.numBuffs = 3
			Auras.CustomFilter = BossAuraFilter
		end
		self.Auras = Auras
	end
end

local CreateDebuffs = function(self, unit)
    if unit == "player" or unit == "pet" then
		local Debuff = CreateFrame("Frame", nil, self)
		Debuff:SetHeight(oUF_MlightDB.height*2)
		Debuff:SetWidth(oUF_MlightDB.width-2)
		Debuff.disableCooldown = true
		Debuff.spacing = 3
		Debuff.PostCreateIcon = PostCreateIcon
		Debuff.PostUpdateIcon = PostUpdateIcon
	    if oUF_MlightDB.playerdebuffenable and unit == "player" then
			Debuff:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 8)
			Debuff.initialAnchor = "BOTTOMLEFT"
			Debuff["growth-x"] = "RIGHT"
			Debuff["growth-y"] = "UP"
			Debuff.size = (oUF_MlightDB.width+3)/oUF_MlightDB.playerdebuffnum-3
			Debuff.num = oUF_MlightDB.playerdebuffnum
		elseif unit == "pet" then
			Debuff:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 5, 0)
			Debuff.initialAnchor = "BOTTOMLEFT"
			Debuff["growth-x"] = "RIGHT"
			Debuff["growth-y"] = "DOWN"
			Debuff.size = (oUF_MlightDB.width+3)/oUF_MlightDB.auraperrow-3
			Debuff.num = 5
		end
		self.Debuffs = Debuff
	end
end
--=============================================--
--[[              Unit Frames                ]]--
--=============================================--

local func = function(self, unit)
	local u = unit:match("[^%d]+")
	
	OnMouseOver(self)
    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	self.menu = menu
	
	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture(highlighttexture)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- backdrop --
	self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetAllPoints()
    self.bg:SetTexture(texture)
	if oUF_MlightDB.transparentmode then
		self.bg:SetGradientAlpha("VERTICAL", .5, .5, .5, .5, 0, 0, 0, .2)
	else
		self.bg:SetGradientAlpha("VERTICAL", .3, .3, .3, 1, .1, .1, .1, 1)
	end
	
    -- height, width and scale --
	if multicheck(u, "targettarget", "focustarget", "pet") then
        self:SetSize(oUF_MlightDB.widthpet, oUF_MlightDB.height)
	elseif u == "boss" then
		self:SetSize(oUF_MlightDB.widthboss, oUF_MlightDB.height)
	else
	    self:SetSize(oUF_MlightDB.width, oUF_MlightDB.height)
    end
    self:SetScale(oUF_MlightDB.scale)
	
	-- shadow border for health bar --
    self.backdrop = createBackdrop(self, self, 0) -- this also use for dispel border
	
	-- health bar --
    local hp = createStatusbar(self, texture, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(1)
	hp:SetAllPoints(self)
    hp.frequentUpdates = true

	-- health text --
	if not (unit == "targettarget" or unit == "focustarget" or unit == "pet") then
		hp.value = createFont(hp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, "OUTLINE", 1, 1, 1)
		hp.value:SetPoint("BOTTOMRIGHT", self, -4, -3)
	end
	
	-- reverse fill health --
	if oUF_MlightDB.transparentmode then
		hp:SetReverseFill(true)
	end

    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	tinsert(self.mouseovers, self.Health)

	-- power bar --
    if not (unit == "targettarget" or unit == "focustarget") then
		local pp = createStatusbar(self, texture, "ARTWORK", oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), nil, 1, 1, 1, 1)
		pp:SetFrameLevel(1)
		pp:SetPoint"LEFT"
		pp:SetPoint"RIGHT"
		pp:SetPoint("TOP", self, "BOTTOM", 0, -3)
		pp.frequentUpdates = true

		-- backdrop for power bar --	
		pp.bd = createBackdrop(pp, pp, 1)
		
		-- power text --
		if not multicheck(u, "pet", "boss") then
			pp.value = createFont(pp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, "OUTLINE", 1, 1, 1)
			pp.value:SetPoint("BOTTOMLEFT", self, 4, -3)
		end

		self.Power = pp
		self.Power.PostUpdate = Updatepowerbar
		tinsert(self.mouseovers, self.Power)
    end

	-- altpower bar --
    if multicheck(u, "player", "boss") then
		local altpp = createStatusbar(self, texture, "ARTWORK", 2, nil, 1, 1, 1, 1)
		altpp:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -3)
		altpp:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -3)
		altpp.bd = createBackdrop(altpp, altpp, 1)

		altpp.value = createFont(altpp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize-2, "OUTLINE", 1, 1, 1)
		altpp.value:SetPoint"CENTER"

		self.AltPowerBar = altpp
		self.AltPowerBar.PostUpdate = PostAltUpdate
    end

	-- little thing around unit frames --
    local leader = hp:CreateTexture(nil, "OVERLAY")
    leader:SetSize(12, 12)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
    self.Leader = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY")
    assistant:SetSize(12, 12)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.Assistant = assistant
	
    local masterlooter = hp:CreateTexture(nil, "OVERLAY")
    masterlooter:SetSize(12, 12)
    masterlooter:SetPoint("LEFT", leader, "RIGHT")
    self.MasterLooter = masterlooter

    local Combat = hp:CreateTexture(nil, "OVERLAY")
    Combat:SetSize(20, 20)
    Combat:SetPoint( "LEFT", hp, "RIGHT", 1, 0)
    self.Combat = Combat
	
    local ricon = hp:CreateTexture(nil, "OVERLAY")
    ricon:SetPoint("CENTER", hp, "CENTER", 0, 0)
    ricon:SetSize(16, 16)
    self.RaidIcon = ricon
	
	-- name --
    local name = createFont(self.Health, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, "OUTLINE", 1, 1, 1)
	name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 3, 9)
    if unit == "player" or unit == "pet" then
        name:Hide()
	elseif multicheck(u, "targettarget", "focustarget", "boss") then
		if oUF_MlightDB.nameclasscolormode then
			self:Tag(name, "[Mlight:color][Mlight:shortname]")
		else
			self:Tag(name, "[Mlight:shortname]")
		end
    elseif oUF_MlightDB.nameclasscolormode then
		self:Tag(name, "[difficulty][level][shortclassification]|r [Mlight:color][name] [status]")
    else
		self:Tag(name, "[difficulty][level][shortclassification]|r [name] [status]")
    end
    self.Name = name
	
    if oUF_MlightDB.castbars then
        CreateCastbars(self, unit)
    end
	
	if oUF_MlightDB.auras then
		CreateAuras(self, unit)
		CreateDebuffs(self, unit)
	end

	self.FadeMinAlpha = oUF_MlightDB.fadingalpha
	self.FadeInSmooth = 0.4
	self.FadeOutSmooth = 1.5
	self.FadeCasting = true
	self.FadeCombat = true
	self.FadeTarget = true
	self.FadeHealth = true
	self.FadePower = true
	self.FadeHover = true

end

local barcolor1 = { -- purple - pink
	[1] = {180/255, 140/255, 255/255, 1},
	[2] = {220/255, 130/255, 255/255, 1},
	[3] = {255/255, 60/255, 255/255, 1},
	[4] = {255/255, 10/255, 220/130, 1},
	[5] = {220/255, 10/255, 50/255, 1},
}

local barcolor2 = { -- lightblue - deepblue
	[1] = {125/255, 255/255, 245/255, 1},
	[2] = {55/255, 170/255, 255/255, 1},
	[3] = {0/255, 100/255, 180/255, 1},
	[4] = {0/255, 30/255, 220/255, 1},
	[5] = {0/255, 0/255, 150/255, 1},
}

local barcolor3 = { -- yellow - red
	[1] = {230/255, 230/255, 0/255, 1},
	[2] = {255/255, 180/255, 0/255, 1},
	[3] = {250/255, 120/255, 20/255, 1},
	[4] = {255/255, 70/255, 20/255, 1},
	[5] = {255/255, 0/255, 0/255, 1},
}

local UnitSpecific = {

    --========================--
    --  Player
    --========================--
    player = function(self, ...)
        func(self, ...)
        local _, class = UnitClass("player")
		
        -- Runes, Shards, HolyPower and so on --
        if multicheck(class, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "SHAMAN", "PRIEST", "ROGUE", "DRUID") then
            local count
            if class == "DEATHKNIGHT" then 
                count = 6
			elseif class == "SHAMAN" then
				count = 4
			elseif class == "MONK" then
				count = 5
			elseif class == "WARLOCK" then
				count = 4
            elseif class == "PALADIN" then
                count = 5
			elseif class == "PRIEST" then
				count = 3
			elseif class == "ROGUE" or class == "DRUID" then
				count = 5 -- combopoints
            end

            local bars = CreateFrame("Frame", nil, self)
			bars:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
            bars:SetSize(oUF_MlightDB.width, 10)

            for i = 1, count do
                bars[i] = createStatusbar(bars, texture, nil, oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), (oUF_MlightDB.width+3)/count-3, 1, 1, 1, 1)

                if class == "WARLOCK" or class == "PRIEST" then
                    bars[i]:SetStatusBarColor(unpack(barcolor1[i]))
                elseif class == "PALADIN" or class == "MONK" then
                    bars[i]:SetStatusBarColor(unpack(barcolor2[i]))
				elseif class == "ROGUE" or class == "DRUID" then
				    bars[i]:SetStatusBarColor(unpack(barcolor3[i]))
                end
				
                if i == 1 then
                    bars[i]:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT")
                else
                    bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
                end

                bars[i].bd = createBackdrop(bars[i], bars[i], 1)
            end

            if class == "DEATHKNIGHT" then
                bars[3], bars[4], bars[5], bars[6] = bars[5], bars[6], bars[3], bars[4]
                self.Runes = bars
            elseif class == "WARLOCK" then
                self.WarlockSpecBars = bars
            elseif class == "PALADIN" then
                self.HolyPower = bars
				self.HolyPower.Override = HolyPowerOverride
			elseif class == "MONK" then
				self.Harmony = bars
				self.Harmony.Override = HarmonyOverride
			elseif class == "SHAMAN" then
				self.TotemBar = bars
			elseif class == "PRIEST" then 
				self.ShadowOrbs = bars
			elseif class == "ROGUE" or class == "DRUID" then
			    self.CPoints = bars
            end
        end
	
		-- eclipse bar --
        if class == "DRUID" then
            local ebar = CreateFrame("Frame", nil, self)
		    local Ewidth,Eheight
			Ewidth = oUF_MlightDB.width
			Eheight = oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1)

            ebar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
			ebar:SetSize(Ewidth, Eheight)
            ebar.bd = createBackdrop(ebar, ebar, 1)

            local lbar = createStatusbar(ebar, texture, nil, Eheight, Ewidth, .2, .9, 1, 1)
            lbar:SetPoint("LEFT", ebar, "LEFT")
            ebar.LunarBar = lbar

            local sbar = createStatusbar(ebar, texture, nil, Eheight, Ewidth, 1, 1, 0.15, 1)
            sbar:SetPoint("LEFT", lbar:GetStatusBarTexture(), "RIGHT")
            ebar.SolarBar = sbar

            ebar.Spark = sbar:CreateTexture(nil, "OVERLAY")
            ebar.Spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
            ebar.Spark:SetBlendMode("ADD")
            ebar.Spark:SetAlpha(0.5)
            ebar.Spark:SetHeight(25)
            ebar.Spark:SetPoint("LEFT", sbar:GetStatusBarTexture(), "LEFT", -15, 0)
			
            self.EclipseBar = ebar
			self.EclipseBar.PostUnitAura = PostEclipseUpdate
        end
		
		-- resting Zzz and PvP---
		local playerstatus = createFont(self.Health, "OVERLAY", oUF_MlightDB.fontfile, 10, "OUTLINE", 1, 1, 1)
		playerstatus:SetPoint("CENTER", self.Health, "CENTER",0,-2)
		self:Tag(playerstatus, "[raidcolor][resting]|r")
		
    end,

    --========================--
    --  Target
    --========================--
    target = function(self, ...)
        func(self, ...)
			-- threat bar --	
		if oUF_MlightDB.showthreatbar then
			local threatbar = createStatusbar(UIParent, texture, "ARTWORK", nil, nil, 0.25, 0.25, 0.25, 1)
			threatbar:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -3)
			threatbar:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 0, -5)
			threatbar.bd = createBackdrop(threatbar, threatbar, 1)
			self.ThreatBar = threatbar
			self.ThreatBar.vertical = oUF_MlightDB.tbvergradient
		end
    end,

    --========================--
    --  Focus
    --========================--
    focus = function(self, ...)
        func(self, ...)
    end,

    --========================--
    --  Focus Target
    --========================--
    focustarget = function(self, ...)
        func(self, ...)
    end,

    --========================--
    --  Pet
    --========================--
    pet = function(self, ...)
        func(self, ...)
    end,

    --========================--
    --  Target Target
    --========================--
    targettarget = function(self, ...)
        func(self, ...)
    end,

    --========================--
    --  Boss
    --========================--
    boss = function(self, ...)
        func(self, ...)
    end,
}

oUF:RegisterStyle("Mlight", func)
for unit,layout in next, UnitSpecific do
    oUF:RegisterStyle("Mlight - " .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
    if(UnitSpecific[unit]) then
        self:SetActiveStyle("Mlight - " .. unit:gsub("^%l", string.upper))
    elseif(UnitSpecific[unit:match("[^%d]+")]) then -- boss1 -> boss
        self:SetActiveStyle("Mlight - " .. unit:match("[^%d]+"):gsub("^%l", string.upper))
    else
        self:SetActiveStyle"Mlight"
    end

    local object = self:Spawn(unit)
    object:SetPoint(...)
    return object
end

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("ADDON_LOADED")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function EventFrame:ADDON_LOADED(arg1)
	if arg1 ~= "oUF_Mlight" then return end
	oUF:Factory(function(self)
    spawnHelper(self, "player","BOTTOM","UIParent","CENTER", 0, -135)
    spawnHelper(self, "pet","BOTTOMLEFT","UIParent","CENTER", oUF_MlightDB.width/2 +10, -135)
    spawnHelper(self, "target","TOPLEFT","UIParent","CENTER", 150, -50)
    spawnHelper(self, "targettarget","TOPLEFT","UIParent","CENTER", 150 +oUF_MlightDB.width +10, -50)
    spawnHelper(self, "focus","TOPLEFT","UIParent","CENTER", 150, 50)
    spawnHelper(self, "focustarget","TOPLEFT","UIParent","CENTER", 150 +oUF_MlightDB.width +10, 50)

    if oUF_MlightDB.bossframes then
        for i = 1, MAX_BOSS_FRAMES do		
			spawnHelper(self,"boss" .. i, "TOPRIGHT","UIParent","TOPRIGHT", -10, -260-60*i)
        end
    end
	end)
end