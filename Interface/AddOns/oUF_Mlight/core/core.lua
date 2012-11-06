local addon, ns = ...

local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"
local texture = "Interface\\Buttons\\WHITE8x8"
local highlighttexture = "Interface\\AddOns\\oUF_Mlight\\media\\highlight"
local reseting = "Interface\\AddOns\\oUF_Mlight\\media\\resting"
local combat = "Interface\\AddOns\\oUF_Mlight\\media\\combat"

oUF.colors.power["MANA"] = {0, 0.8, 1}
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

local classicon_colors = { --monk/paladin/preist
	{150/255, 0/255, 40/255},
	{220/255, 20/255, 40/255},
	{255/255, 50/255, 90/255},
	{255/255, 80/255, 120/255},
	{255/255, 110/255, 160/255},
}

local cpoints_colors = { -- combat points
	{220/255, 40/255, 0/255},
	{255/255, 110/255, 0/255},
	{255/255, 150/255, 0/130},
	{255/255, 200/255, 0/255},
	{255/255, 255/255, 0/255},
}

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
		frame:SetBackdropColor(.15, .15, .15, a)
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

local createFont = function(parent, layer, f, fs, r, g, b, justify)
    local string = parent:CreateFontString(nil, layer)
    string:SetFont(f, fs, oUF_MlightDB.fontflag)
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
			self.value:SetText(FormatValue(min).." "..hex(1, 1, 0)..math.floor(min/max*100+.5).."|r")
		elseif min > 0 and self.__owner.isMouseOver and UnitIsConnected(unit) then
			self.value:SetText(FormatValue(min))
		else
			self.value:SetText(nil)
		end
	end
	
	if min > 0 and min < max then
		self.ind:Show()
	else
		self.ind:Hide()
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
	elseif UnitIsPlayer(unit) then
		local _, unitclass = UnitClass(unit)
		if unitclass then r, g, b = unpack(oUF.colors.class[unitclass]) else r, g, b = 1, 1, 1 end
	else
		r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, 'player') or 5])
	end
	
	self:GetStatusBarTexture():SetGradient('VERTICAL', r, g, b, r/3, g/3, b/3)
end
ns.Updatepowerbar = Updatepowerbar

local PostAltUpdate = function(altpp, min, cur, max)
	altpp.value:SetText(cur)
	
	local self = altpp.__owner
    local tPath, r, g, b = UnitAlternatePowerTextureInfo(self.unit, 2)
	
	if not tPath then return end
	
    if tPath:match("STONEGUARDAMETHYST_HORIZONTAL_FILL.BLP") then
		altpp:SetStatusBarColor(.7, .3, 1)
	elseif tPath:match("STONEGUARDCOBALT_HORIZONTAL_FILL.BLP") then
		altpp:SetStatusBarColor(.1, .8, 1)
	elseif tPath:match("STONEGUARDJADE_HORIZONTAL_FILL.BLP") then
		altpp:SetStatusBarColor(.5, 1, .2)
	elseif tPath:match("STONEGUARDJASPER_HORIZONTAL_FILL.BLP") then
        altpp:SetStatusBarColor(1, 0, 0)
    end
end

local PostEclipseUpdate = function(self, unit)
    if self.hasSolarEclipse then
        self.bd:SetBackdropBorderColor(1, .6, 0)
        self.bd:SetBackdropColor(1, .6, 0)
    elseif self.hasLunarEclipse then
        self.bd:SetBackdropBorderColor(0, .4, 1)
        self.bd:SetBackdropColor(0, .4, 1)
    else
        self.bd:SetBackdropBorderColor(0, 0, 0)
        self.bd:SetBackdropColor(0, 0, 0)
    end
end

local CpointsPostUpdate = function(element, cur)
	for i = 1, 5 do
		if cur == MAX_COMBO_POINTS then
			element[i]:SetStatusBarColor(unpack(cpoints_colors[cur]))
		else
			element[i]:SetStatusBarColor(unpack(cpoints_colors[i]))
		end
	end
end

local ClassIconsPostUpdate = function(element, cur, max, maxchange)
	for i = 1, 5 do
		if cur == max then
			element[i]:SetStatusBarColor(unpack(classicon_colors[cur]))
		else
			element[i]:SetStatusBarColor(unpack(classicon_colors[i]))
		end
		if maxchange then
			element[i]:SetWidth((oUF_MlightDB.width+3)/max-3)
		end		
	end
end

local CombatPostUpdate = function(self, inCombat)
	if inCombat then
		self.__owner.Resting:Hide()
	elseif IsResting() then 
		self.__owner.Resting:Show()
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
        cb:SetFrameLevel(2)

        cb.Spark = cb:CreateTexture(nil, "OVERLAY")
		cb.Spark:SetTexture("Interface\\UnitPowerBarAlt\\Generic1Player_Pill_Flash")
        cb.Spark:SetBlendMode("ADD")
        cb.Spark:SetAlpha(1)
        cb.Spark:SetSize(8, oUF_MlightDB.height*2)

        cb.Time = createFont(cb, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, 1, 1, 1)
		if (unit == "player") then
			cb.Time:SetFont(oUF_MlightDB.fontfile, oUF_MlightDB.fontsize+2, oUF_MlightDB.fontflag)
			cb.Time:SetPoint("TOP", cb, "BOTTOM", 0, -10)
		else
			cb.Time:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", -3, -3)
		end
        cb.CustomTimeText = CustomTimeText

        cb.Text = createFont(cb, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, 1, 1, 1)
		if u == "boss" then
			cb.Text:SetPoint("BOTTOMLEFT", 3, -3)
		else
			cb.Text:SetPoint("BOTTOM", 0, -3)
		end
		
        cb.Icon = cb:CreateTexture(nil, "ARTWORK")
        cb.Icon:SetSize(oUF_MlightDB.cbIconsize, oUF_MlightDB.cbIconsize)
        cb.Icon:SetTexCoord(.1, .9, .1, .9)
		cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -7, -oUF_MlightDB.height*(1-oUF_MlightDB.hpheight)-6)

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
    icon.count:SetFont(oUF_MlightDB.fontfile, 12, oUF_MlightDB.fontflag)
    icon.count:SetTextColor(.9, .9, .1)

	icon.overlay:SetTexture(texture)
	icon.overlay:SetDrawLayer("BACKGROUND")
    icon.overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
    icon.overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)

	icon.bd = createBackdrop(icon, icon, 0)

	icon.remaining = createFont(icon, "OVERLAY", oUF_MlightDB.fontfile, 12, 1, 1, 1)
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

blacklist ={
	["36032"] = true, -- Arcane Charge
}

local PlayerDebuffFilter = function(icons, unit, icon, ...)
	local SpellID = select(11, ...)
	if blacklist[tostring(SpellID)] then
		return false
	else
		return true
	end
end

local CreateAuras = function(self, unit)
	local u = unit:match("[^%d]+")
    if multicheck(u, "target", "focus", "boss", "player", "pet") then
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
		elseif oUF_MlightDB.playerdebuffenable and unit == "player" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1)+9)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = oUF_MlightDB.playerdebuffnum
			Auras.numBuffs = 0
			Auras.size = (oUF_MlightDB.width+3)/oUF_MlightDB.playerdebuffnum-3
			Auras.CustomFilter = PlayerDebuffFilter
		elseif unit == "pet" then
			Auras:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 5, 0)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "DOWN"
			Auras.numDebuffs = 5
			Auras.numBuffs = 0
		elseif u == "boss" then -- boss 1-5
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
		self.bg:SetGradientAlpha("VERTICAL", oUF_MlightDB.endcolor.r, oUF_MlightDB.endcolor.g, oUF_MlightDB.endcolor.b, oUF_MlightDB.endcolor.a, oUF_MlightDB.startcolor.r, oUF_MlightDB.startcolor.g, oUF_MlightDB.startcolor.b, oUF_MlightDB.startcolor.a)
	else
		self.bg:SetGradientAlpha("VERTICAL", oUF_MlightDB.endcolor.r, oUF_MlightDB.endcolor.g, oUF_MlightDB.endcolor.b, 1, oUF_MlightDB.startcolor.r, oUF_MlightDB.startcolor.g, oUF_MlightDB.startcolor.b, 1)
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
	hp:SetFrameLevel(2)
	hp:SetAllPoints(self)
    hp.frequentUpdates = true
	
	-- health text --
	if not (unit == "targettarget" or unit == "focustarget" or unit == "pet") then
		hp.value = createFont(hp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, 1, 1, 1)
		hp.value:SetPoint("BOTTOMRIGHT", self, -4, -5)
	end
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, self:GetHeight())
	if oUF_MlightDB.transparentmode then
		hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	else
		hp.ind:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT", 0, 0)
	end
	
	-- reverse fill health --
	if oUF_MlightDB.transparentmode then
		hp:SetReverseFill(true)
	end
	
    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	tinsert(self.mouseovers, self.Health)
	
	-- portrait --
	if oUF_MlightDB.portrait and multicheck(u, "player", "target", "focus", "boss") then
		local Portrait = CreateFrame('PlayerModel', nil, self)
		if oUF_MlightDB.transparentmode then
			Portrait:SetFrameLevel(1) -- below hp
		else
			Portrait:SetFrameLevel(2) -- over hp
		end
		Portrait:SetPoint("TOPLEFT", 1, 0)
		Portrait:SetPoint("BOTTOMRIGHT", -1, 1)
		Portrait:SetAlpha(oUF_MlightDB.portraitalpha)
		self.Portrait = Portrait
		--self.Portrait.PostUpdate = function() Portrait:SetPosition(-0.3, 0.3, 0) end
	end
	
	-- power bar --
    if not (unit == "targettarget" or unit == "focustarget") then
		local pp = createStatusbar(self, texture, "ARTWORK", oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), nil, 1, 1, 1, 1)
		pp:SetFrameLevel(2)
		pp:SetPoint"LEFT"
		pp:SetPoint"RIGHT"
		pp:SetPoint("TOP", self, "BOTTOM", 0, -5)
		pp.frequentUpdates = true

		-- backdrop for power bar --	
		pp.bd = createBackdrop(pp, pp, 1)
		
		-- power text --
		if not multicheck(u, "pet", "boss") then
			pp.value = createFont(pp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, 1, 1, 1)
			pp.value:SetPoint("BOTTOMLEFT", self, 4, -5)
		end

		self.Power = pp
		self.Power.PostUpdate = Updatepowerbar
		tinsert(self.mouseovers, self.Power)
    end

	-- altpower bar --
    if multicheck(u, "player", "boss", "pet") then
		local altpp = createStatusbar(self, texture, "ARTWORK", 5, nil, 1, 1, 0, 1)
		if unit == pet then
			altpp:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -5)
			altpp:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -5)
		else
			altpp:SetPoint("TOPLEFT", _G["oUF_MlightPlayer"].Power, "BOTTOMLEFT", 0, -5)
			altpp:SetPoint("TOPRIGHT", _G["oUF_MlightPlayer"].Power, "BOTTOMRIGHT", 0, -5)
		end
		altpp.bd = createBackdrop(altpp, altpp, 1)

		altpp.value = createFont(altpp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize-2, 1, 1, 1)
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
	
    local ricon = hp:CreateTexture(nil, "OVERLAY")
    ricon:SetPoint("CENTER", hp, "CENTER", 0, 0)
    ricon:SetSize(16, 16)
    self.RaidIcon = ricon
	
	-- name --
    local name = createFont(self.Health, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.fontsize, 1, 1, 1)
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

local UnitSpecific = {

    --========================--
    --  Player
    --========================--
    player = function(self, ...)
        func(self, ...)
        local _, class = UnitClass("player")
		
        -- Runes, Shards, HolyPower and so on --
        if multicheck(class, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "SHAMAN", "PRIEST", "MAGE", "ROGUE", "DRUID") then
            local count
            if class == "DEATHKNIGHT" then 
                count = 6
			elseif class == "WARLOCK" then
				count = 4
            elseif class == "PALADIN" or class == "PRIEST" or class == "MONK" then
                count = 5
			elseif class == "SHAMAN" then
				count = 4
			elseif class == "MAGE" then
				count = 6
			elseif class == "ROGUE" or class == "DRUID" then
				count = 5 -- combopoints
            end

            local bars = CreateFrame("Frame", nil, self)
			bars:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
            bars:SetSize(oUF_MlightDB.width, 10)

            for i = 1, count do
				if class == "PALADIN" then
					bars[i] = createStatusbar(bars, texture, nil, oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), (oUF_MlightDB.width+2)/HOLY_POWER_FULL-3, 1, 1, 1, 1)
				elseif class == "PRIEST" then
					bars[i] = createStatusbar(bars, texture, nil, oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), (oUF_MlightDB.width+2)/PRIEST_BAR_NUM_ORBS-3, 1, 1, 1, 1)
				elseif class == "MONK" then
					bars[i] = createStatusbar(bars, texture, nil, oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), (oUF_MlightDB.width+2)/4-3, 1, 1, 1, 1)
				else
					bars[i] = createStatusbar(bars, texture, nil, oUF_MlightDB.height*-(oUF_MlightDB.hpheight-1), (oUF_MlightDB.width+2)/count-3, 1, 1, 1, 1)
				end
				
                if i == 1 then
                    bars[i]:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT")
                else
                    bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
                end

                bars[i].bd = createBackdrop(bars[i], bars[i], 1)
            end

            if class == "DEATHKNIGHT" then
                self.Runes = bars
            elseif class == "WARLOCK" then
                self.WarlockSpecBars = bars
            elseif class == "PALADIN" or class == "PRIEST" or class == "MONK" then
                self.ClassIcons = bars
				self.ClassIcons.UpdateTexture = function() end
				self.ClassIcons.PostUpdate = ClassIconsPostUpdate
			elseif class == "SHAMAN" then
				self.TotemBar = bars
			elseif class == "MAGE" then
				self.ArcaneCharge = bars
			elseif class == "ROGUE" or class == "DRUID" then
			    self.CPoints = bars
				self.CPoints.PostUpdate = CpointsPostUpdate
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
		
		-- Zzz
		local Resting = self.Power:CreateTexture(nil, 'OVERLAY')
		Resting:SetSize(18, 18)
		Resting:SetTexture(reseting)
		Resting:SetDesaturated(true)
		Resting:SetVertexColor( 0, 1, 0)
		Resting:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		self.Resting = Resting
		
		-- Combat
		local Combat = self.Power:CreateTexture(nil, "OVERLAY")
		Combat:SetSize(18, 18)
		Combat:SetTexture(combat)
		Combat:SetDesaturated(true)
		Combat:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		Combat:SetVertexColor( 1, 1, 0)
		self.Combat = Combat		
		self.Combat.PostUpdate = CombatPostUpdate
		
		-- PvP
		if oUF_MlightDB.pvpicon then
			local PvP = self:CreateTexture(nil, 'OVERLAY')
			PvP:SetSize(35, 35)
			PvP:SetPoint("CENTER", self, "TOPRIGHT", 5, -5)
			self.PvP = PvP
		end
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

local EventFrame = CreateFrame("Frame", nil, UIParent)
RegisterStateDriver(EventFrame, "visibility", "[petbattle] hide; show")

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
	object:SetParent(EventFrame)
    return object
end

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