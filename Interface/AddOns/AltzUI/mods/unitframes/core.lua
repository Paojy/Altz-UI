local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

oUF.colors.power["MANA"] = {0, 0.8, 1}
oUF.colors.power["RAGE"] = {.9, .1, .1}
oUF.colors.power["FUEL"] = {0, 0.55, 0.5}
oUF.colors.power["FOCUS"] = {.9, .5, .1}
oUF.colors.power["ENERGY"] = {.9, .9, .1}
oUF.colors.power["AMMOSLOT"] = {0.8, 0.6, 0}
oUF.colors.power["RUNIC_POWER"] = {.1, .9, .9}
oUF.colors.power["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61}
oUF.colors.power["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17}
oUF.colors.power["MEALSTORM"] = {0.4, 0.7, 1}

oUF.colors.reaction[1] = {1, .1, .2}
oUF.colors.reaction[2] = {1, .1, .2}
oUF.colors.reaction[3] = {1, .1, .2}
oUF.colors.reaction[4] = {1, 1, 0}
oUF.colors.reaction[5] = {0.26, 1, 0.22}
oUF.colors.reaction[6] = {0.26, 1, 0.22}
oUF.colors.reaction[7] = {0.26, 1, 0.22}
oUF.colors.reaction[8] = {0.26, 1, 0.22}

oUF.colors.threat[0] = {.1, .7, .9}
oUF.colors.threat[1] = {.4, .1, .9}
oUF.colors.threat[2] = {.9, .1, .9}
oUF.colors.threat[3] = {.9, .1, .4}

oUF.colors.smooth = {1,0,0, 1,1,0, 1,1,0}

local classicon_colors = { --monk/paladin/preist
	{.6, 0, .1},
	{.9, .1, .2},
	{1, .2, .3},
	{1, .3, .4},
	{1, .4, .5},
	{1, .5, .6},
	{1, 1, 0},
}

local cpoints_colors = { -- combat points
	{1, 0, 0},
	{1, 1, 0},
}

local nameplate_callbacks = {}
local function RegisterNameplateEventCallback(func)
	table.insert(nameplate_callbacks, func)
end
--=============================================--
--[[ Functions ]]--
--=============================================--
local function GetUnitColorforNameplate(unit)	
	local r, g, b = 1, 1, 1
	local name = GetUnitName(unit, false)
	if aCoreCDB["PlateOptions"]["focuscolored"] and UnitIsUnit(unit, "focus") then -- 焦点颜色
		r, g, b = aCoreCDB["PlateOptions"]["focus_color"].r, aCoreCDB["PlateOptions"]["focus_color"].g, aCoreCDB["PlateOptions"]["focus_color"].b
	elseif  aCoreCDB["PlateOptions"]["customcoloredplates"][name] then -- 自定义颜色
		r, g, b = aCoreCDB["PlateOptions"]["customcoloredplates"][name].r, aCoreCDB["PlateOptions"]["customcoloredplates"][name].g, aCoreCDB["PlateOptions"]["customcoloredplates"][name].b
	elseif not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	elseif not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit) and aCoreCDB["PlateOptions"]["threatcolor"] then
		r, g, b = unpack(oUF.colors.threat[UnitThreatSituation('player', unit)])
	elseif UnitIsPlayer(unit) and UnitClass(unit) then
		local _, unitclass = UnitClass(unit)
		r, g, b = unpack(oUF.colors.class[unitclass]) 
	elseif UnitReaction(unit, "player") then
		r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player")])
	else
		r, g, b = unpack(oUF.colors.reaction[5])
	end
	return r, g, b
end
T.GetUnitColorforNameplate = GetUnitColorforNameplate

local function GetUnitColorforNameplateTarget(unit)	
	local r, g, b = 1, 1, 1
	local name = GetUnitName(unit, false)
	
	if UnitIsPlayer(unit) and UnitClass(unit) then
		local _, unitclass = UnitClass(unit)
		r, g, b = unpack(oUF.colors.class[unitclass]) 
	elseif UnitReaction(unit, "player") then
		r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player")])
	else
		r, g, b = unpack(oUF.colors.reaction[5])
	end
	return r, g, b
end
T.GetUnitColorforNameplateTarget = GetUnitColorforNameplateTarget

local function GetUnitColor(unit)
	local r, g, b = 1, 1, 1
	if not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	elseif UnitIsPlayer(unit) and UnitClass(unit) then
		local _, unitclass = UnitClass(unit)
		r, g, b = unpack(oUF.colors.class[unitclass]) 
	elseif UnitReaction(unit, "player") then
		r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player")])
	else
		r, g, b = oUF.colors.reaction[5]
	end
	return r, g, b
end
T.GetUnitColor = GetUnitColor
--=============================================--
--[[ MouseOn update ]]--
--=============================================--

T.OnMouseOver = function(self)
	self:SetAttribute("shift-type1", "focus")
	
	self:SetScript("OnEnter", function(self)
		UnitFrame_OnEnter(self)
		self.isMouseOver = true
		for _, element in ipairs(self.mouseovers) do
			element:ForceUpdate()
		end
	end)
	
	self:SetScript("OnLeave", function(self)
		UnitFrame_OnLeave(self)
		self.isMouseOver = false
		for _, element in ipairs(self.mouseovers) do
			element:ForceUpdate()
		end
	end)
end

--=============================================--
--[[ Some update ]]--
--=============================================--
local PostUpdate_AltPower = function(altpp, unit, cur, min, max)
	altpp.value:SetText(cur)
end

local PostUpdate_CombatIndicator = function(self, inCombat)
	if inCombat then
		self.__owner.RestingIndicator:Hide()
	elseif IsResting() then
		self.__owner.RestingIndicator:Show()
	end
end

local Override_QusetUpdate = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local element = self.QuestIndicator
	
	if C_QuestLog.UnitIsRelatedToActiveQuest(unit) then
		element:Show()
		element:SetWidth(element.width)
	else
		element:Hide()
		element:SetWidth(1)
	end
end

local ICONS = {
	[Enum.PvPUnitClassification.FlagCarrierHorde or 0] = "nameplates-icon-flag-horde",
	[Enum.PvPUnitClassification.FlagCarrierAlliance or 1] = "nameplates-icon-flag-alliance",
	[Enum.PvPUnitClassification.FlagCarrierNeutral or 2] = "nameplates-icon-flag-neutral",
	[Enum.PvPUnitClassification.CartRunnerHorde or 3] = "nameplates-icon-cart-horde",
	[Enum.PvPUnitClassification.CartRunnerAlliance or 4] = "nameplates-icon-cart-alliance",
	[Enum.PvPUnitClassification.AssassinHorde or 5] = "nameplates-icon-bounty-horde",
	[Enum.PvPUnitClassification.AssassinAlliance or 6] = "nameplates-icon-bounty-alliance",
	[Enum.PvPUnitClassification.OrbCarrierBlue or 7] = "nameplates-icon-orb-blue",
	[Enum.PvPUnitClassification.OrbCarrierGreen or 8] = "nameplates-icon-orb-green",
	[Enum.PvPUnitClassification.OrbCarrierOrange or 9] = "nameplates-icon-orb-orange",
	[Enum.PvPUnitClassification.OrbCarrierPurple or 10] = "nameplates-icon-orb-purple",
}

local Override_PvPUpdate = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local element = self.PvPClassificationIndicator
	
	local class = UnitPvpClassification(unit)
	local icon = ICONS[class]
	if(icon) then
		element:SetAtlas(icon)
		element:Show()
		element:SetWidth(element.width)
	else
		element:Hide()
		element:SetWidth(1)
	end
end
--=============================================--
--[[ 	    	治疗预估和吸收 				 ]]--
--=============================================--

local function CreateHealPreditionBar(self, ...)
	local hpb = CreateFrame('StatusBar', nil, self.Health)
	hpb:SetFrameLevel(self:GetFrameLevel()+2)
	hpb:SetStatusBarTexture(G.media.blank)
	hpb:SetStatusBarColor(...)
	hpb:SetPoint('TOP')
	hpb:SetPoint('BOTTOM')
	
	hpb:SetWidth(aCoreCDB["UnitframeOptions"]["raidwidth"])
	return hpb
end
T.CreateHealPreditionBar = CreateHealPreditionBar

--=============================================--
--[[ Health ]]--
--=============================================--

local ApplyHealthThemeSettings = function(self, hp)
	if aCoreCDB["SkinOptions"]["style"] == 1 then
		hp:SetStatusBarTexture(G.media.blank)			
		self.bg:SetTexture(G.media.blank)
		self.bg:SetVertexColor(0, 0, 0, 0)
		hp.cover:SetGradient("VERTICAL", CreateColor(.5, .5, .5, .5), CreateColor(0, 0, 0, 0))
		
		hp.colorSmooth = true				
	elseif aCoreCDB["SkinOptions"]["style"] == 2 then
		hp:SetStatusBarTexture(G.media.ufbar)
		self.bg:SetTexture(G.media.ufbar)
		self.bg:SetVertexColor(.05, .05, .05, 1)
		hp.cover:SetGradient("VERTICAL", CreateColor(.2, .2, .2, .5), CreateColor(0, 0, 0, 0))
		
		hp.colorSmooth = true			
	elseif aCoreCDB["SkinOptions"]["style"] == 3 then
		hp:SetStatusBarTexture(G.media.ufbar)
		hp:SetStatusBarColor(.3, .3, .3)
		self.bg:SetTexture(G.media.ufbar)
		hp.cover:SetGradient("VERTICAL", CreateColor(.5, .5, .5, .5), CreateColor(0, 0, 0, 0))
		
		hp.colorSmooth = false
	end
end
T.ApplyHealthThemeSettings = ApplyHealthThemeSettings

local PostUpdate_HealthColor = function(self, unit)
	if aCoreCDB["SkinOptions"]["style"] == 3 then
		local r, g, b
		if unit == "pet" then
			r, g, b = unpack(oUF.colors.class[G.myClass])
		elseif UnitIsPlayer(unit) and UnitClass(unit) then
			local unitclass = select(2, UnitClass(unit))
			r, g, b = unpack(oUF.colors.class[unitclass]) 
		elseif UnitReaction(unit, 'player') then
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player") or 5])
		else
			r, g, b = 1, 1, 1
		end
		self.__owner.bg:SetVertexColor(r, g, b, 1)
	end
end
T.PostUpdate_HealthColor = PostUpdate_HealthColor

local Override_Health = function(self, event, unit)
	if (not unit or self.unit ~= unit) then return end
	
	local element = self.Health	
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	
	element.cur = cur
	element.max = max
	
	element:SetMinMaxValues(0, max)
	
	if (UnitIsConnected(unit)) then
		element:SetValue(max - cur)
	else
		element:SetValue(0)
	end
	
	-- 数值
	if element.value then
		if (cur > 0 and self.isMouseOver and UnitIsConnected(unit)) then
			element.value:SetText(T.ShortValue(cur))
		elseif (cur ~= 0 and cur ~= max) or aCoreCDB["UnitframeOptions"]["alwayshp"] then
			element.value:SetText(T.ShortValue(cur).." "..T.hex_str(math.floor(cur/max*100+.5), 1, 1, 0))
		else
			element.value:SetText("")
		end
	end
end
T.Override_Health = Override_Health

local UpdateColorArenaPreparation = function(self, event, specID)	
	if aCoreCDB["SkinOptions"]["style"] == 3 then
		local _, _, _, _, _, class = GetSpecializationInfoByID(specID)
		local r, g, b = unpack(oUF.colors.class[unitclass]) 
		self.__owner.bg:SetVertexColor(r, g, b, 1)
	end
end

local Override_PlateHealthColor = function(self, event, unit)
	if (not unit or self.unit ~= unit) then return end
	local hp = self.Health
	
	local r, g, b = GetUnitColorforNameplate(unit)
	local r2, g2, b2 = self:ColorGradient(hp.cur or 1, hp.max or 1, unpack(self.colors.smooth))
	
	if aCoreCDB["PlateOptions"]["theme"] == "number" and aCoreCDB["PlateOptions"]["number_colorheperc"] and r2 and g2 and b2 then
		hp.value:SetTextColor(r2, g2, b2)
	else
		hp.value:SetTextColor(1, 1, 1)
	end
	
	if aCoreCDB["PlateOptions"]["theme"] == "dark" and r2 and g2 and b2 then		
		hp:SetStatusBarColor(r2, g2, b2)
	elseif aCoreCDB["PlateOptions"]["theme"] == "class" and r and g and b then
		hp:SetStatusBarColor(r, g, b)
		hp.backdrop:SetBackdropColor(r*.2, g*.2, b*.2, 1)
	end
end

local Override_PlateHealth = function(self, event, unit)
	if (not unit or not UnitIsUnit(self.unit, unit)) then return end
	
	local element = self.Health	
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	
	element.cur = cur
	element.max = max
	
	element:SetMinMaxValues(0, max)
		
	if (UnitIsConnected(unit)) then
		if aCoreCDB["PlateOptions"]["theme"] == "dark" then
			element:SetValue(max - cur)
		else
			element:SetValue(cur)
		end
	else
		element:SetValue(max)
	end
	
	-- 数值
	if aCoreCDB["PlateOptions"]["theme"] == "number" then
		if (cur ~= 0 and cur ~= max) or aCoreCDB["PlateOptions"]["number_alwayshp"] then
			element.value:SetText(math.floor(cur/max*100+.5))
		else
			element.value:SetText(nil)
		end
	else
		if (cur > 0 and self.isMouseOver and UnitIsConnected(unit)) then
			element.value:SetText(T.ShortValue(cur))
		elseif (cur ~= 0 and cur ~= max) or aCoreCDB["PlateOptions"]["bar_alwayshp"] then
			if aCoreCDB["PlateOptions"]["bar_hp_perc"] == "perc" then
				element.value:SetText(T.hex_str(math.floor(cur/max*100+.5), 1, 1, 0))
			else
				element.value:SetText(T.ShortValue(cur).." "..T.hex_str(math.floor(cur/max*100+.5), 1, 1, 0))
			end
		else
			element.value:SetText(nil)
		end
	end
end

--=============================================--
--[[ Power ]]--
--=============================================--
local ApplyPowerThemeSettings = function(pp)
	if aCoreCDB["SkinOptions"]["style"] == 1 then
		pp:SetStatusBarTexture(G.media.blank)
		pp.bg:SetTexture(G.media.blank)
	else
		pp:SetStatusBarTexture(G.media.ufbar)
		pp.bg:SetTexture(G.media.ufbar)
	end
	
	if aCoreCDB["SkinOptions"]["style"] == 3 then
		pp.colorPower = true
		pp.colorClass = false
		pp.colorReaction = false
	else
		pp.colorPower = false
		pp.colorClass = true
		pp.colorReaction = true	
	end
end
T.ApplyPowerThemeSettings = ApplyPowerThemeSettings

local PostUpdate_PowerColor = function(self, unit)
	local type = select(2, UnitPowerType(unit))
	local powercolor = oUF.colors.power[type] or oUF.colors.power.FUEL
	if self.value then
		self.value:SetTextColor(unpack(powercolor))
	end
end
T.PostUpdate_PowerColor = PostUpdate_PowerColor

local PostUpdate_Power = function(self, unit, cur, min, max)
	local type = select(2, UnitPowerType(unit))
	
	if self.value then
		if self.__owner.isMouseOver and type == 'MANA' and UnitIsConnected(unit) then
			self.value:SetText(T.ShortValue(cur))
		elseif (cur > 0 and cur < max) or aCoreCDB["UnitframeOptions"]["alwayspp"] or (self.__owner.style == 'Altz_Nameplates') then
			if type == 'MANA' then
				self.value:SetText(math.floor(cur/max*100+.5))
			else
				self.value:SetText(T.ShortValue(cur))
			end
		else
			self.value:SetText(nil)
		end
	end
end
T.PostUpdate_Power = PostUpdate_Power

--=============================================--
--[[ Castbars ]]--
--=============================================--
local UpdateCastbarColor = function(castbar, unit)
	local u = unit:match("[^%d]+")
	local category = (u == "nameplate" and "PlateOptions") or (T.multicheck(u, "target", "player", "focus") and (aCoreCDB["UnitframeOptions"]["cbstyle"] == "independent") and "UnitframeOptions")
	if category then		
		local color = aCoreCDB[category]["Interruptible_color"]
		local r, g, b = color.r, color.g, color.b
		local color2 = aCoreCDB[category]["notInterruptible_color"]
		local r2, g2, b2 = color2.r, color2.g, color2.b
		
		if unit == "player" then
			castbar:SetStatusBarColor(r, g, b)		
		else
			if castbar.notInterruptible then	
				castbar:SetStatusBarColor(r2, g2, b2)
			else
				castbar:SetStatusBarColor(r, g, b)
			end
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

local CustomDelayText = function(castbar, duration)
	if castbar.casting then
		castbar.Time:SetFormattedText("|cff97FFFF%.1f/%.1f|r|cff8A8A8A(%.1f)|r", duration, castbar.max, -castbar.delay)
	elseif castbar.channeling then
		castbar.Time:SetFormattedText("|cff97FFFF%.1f/%.1f|r|cff8A8A8A(%.1f)|r", castbar.max - duration, castbar.max, -castbar.delay)
	end
end

local CreatePip = function(element, stage)
	local frame = CreateFrame('Frame', nil, element)
	frame:SetSize(1, 10)
	
	frame.tex = frame:CreateTexture(nil, "OVERLAY")
	frame.tex:SetTexture(G.media.blank)
	frame.tex:SetVertexColor(0, 0, 0)
	frame.tex:SetAllPoints(frame)
	
	frame.text = T.createnumber(frame, "OVERLAY", 12, "OUTLINE", "CENTER")
	frame.text:SetPoint("BOTTOM", frame, "TOP", 0, 2)
	frame.text:SetText(stage)
	
	return frame
end

local CreateCastbars = function(self, unit)
	local u = unit:match("[^%d]+")
	if T.multicheck(u, "target", "player", "focus", "boss", "arena") then
		
		local cb = CreateFrame("StatusBar", G.uiname..unit.."Castbar", self)
		cb:SetFrameLevel(self:GetFrameLevel()+2)
		cb:SetStatusBarTexture(G.media.blank)
		
		-- 独立施法条锚点
		if T.multicheck(u, "target", "player", "focus") then	
			if unit == "player" then
				cb.movingname = T.split_words(PLAYER,L["施法条"])
				cb.point = {
					healer = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 450},
					dpser = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 450},
				}
			elseif unit == "target" then	
				cb.movingname = T.split_words(TARGET,L["施法条"])
				cb.point = {
					healer = {a1 = "TOPLEFT", parent = "oUF_AltzTarget", a2 = "BOTTOMLEFT", x = 0, y = -10},
					dpser = {a1 = "TOPLEFT", parent = "oUF_AltzTarget", a2 = "BOTTOMLEFT", x = 0, y = -10},
				}
			elseif unit == "focus" then	
				cb.movingname = T.split_words(L["焦点"],L["施法条"])
				cb.point = {
					healer = {a1 = "TOPLEFT", parent = "oUF_AltzFocus", a2 = "BOTTOMLEFT", x = 0, y = -10},
					dpser = {a1 = "TOPLEFT", parent = "oUF_AltzFocus", a2 = "BOTTOMLEFT", x = 0, y = -10},
				}
			end

			T.CreateDragFrame(cb)
		end
		
		-- 背景		
		cb.backdrop = T.createBackdrop(cb, 1)
		
		-- 法术名字和时间
		cb.Text = T.createtext(cb, "OVERLAY", u == "nameplate" and 8 or 14, "OUTLINE", "CENTER")
		cb.Time = T.createnumber(cb, "OVERLAY", 16, "OUTLINE", "CENTER") -- 施法时间		
		
		-- 光标
		cb.Spark = cb:CreateTexture(nil, "OVERLAY")
		cb.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		cb.Spark:SetBlendMode("ADD")
		cb.Spark:SetVertexColor(1,1,1)
		cb.Spark:SetPoint('CENTER', cb:GetStatusBarTexture(), 'RIGHT', 0, 0)
		
		-- 图标
		cb.Icon = cb:CreateTexture(nil, "OVERLAY", nil, 3)
		cb.Icon:SetTexCoord(.1, .9, .1, .9)		
		cb.Icon_bd = T.createBackdrop(cb.Icon, 1, 2, cb)

		-- 打断记号
		cb.Shield = cb:CreateTexture(nil, "OVERLAY")
		cb.Shield:SetAtlas("nameplates-InterruptShield")
		cb.Shield:SetSize(14, 15)
		cb.Shield:SetPoint("RIGHT", cb.Text, "LEFT", -3, 0)
	
		if unit == "player" then -- 延迟
			cb.SafeZone = cb:CreateTexture(nil, "OVERLAY")
			cb.SafeZone:SetTexture(G.media.blank)
			cb.SafeZone:SetVertexColor( 1, 1, 1, .5)
		end

		cb.CustomTimeText = CustomTimeText
		cb.CustomDelayText = CustomDelayText
		cb.PostCastStart = UpdateCastbarColor
		cb.CreatePip = CreatePip
		
		cb.EnableSettings = function(object)
			if not object or object == self then	
				if aCoreCDB["UnitframeOptions"]["castbars"] then
					self:EnableElement("Castbar")
					self.Castbar:ForceUpdate()
				else
					self:DisableElement("Castbar")
				end
			end
		end
		oUF:RegisterInitCallback(cb.EnableSettings)
	
		cb.ApplySettings = function()		
			if unit == "player" and aCoreCDB["UnitframeOptions"]["hideplayercastbaricon"] then
				cb.Icon:Hide()
				cb.Icon_bd:Hide()
			else
				cb.Icon:Show()
				cb.Icon_bd:Show()
			end
			
			cb.Icon:SetSize(aCoreCDB["UnitframeOptions"]["cbIconsize"], aCoreCDB["UnitframeOptions"]["cbIconsize"])
			cb.Time:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE")
			
			if T.multicheck(u, "target", "player", "focus") and (aCoreCDB["UnitframeOptions"]["cbstyle"] == "independent") then -- 独立施法条		
				if u == "player" or u == "target" or u == "focus" then
					T.RestoreDragFrame(cb)
				end
				
				cb:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
				cb:SetStatusBarColor(1, 1, 1, 1)
				cb.backdrop:Show()
				
				if unit == "player" then
					cb:SetSize(aCoreCDB["UnitframeOptions"]["cbwidth"], aCoreCDB["UnitframeOptions"]["cbheight"])
					cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["cbheight"]*2)
				elseif unit == "target" then
					cb:SetSize(aCoreCDB["UnitframeOptions"]["target_cbwidth"], aCoreCDB["UnitframeOptions"]["target_cbheight"])
					cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["target_cbheight"]*2)
				elseif unit == "focus" then
					cb:SetSize(aCoreCDB["UnitframeOptions"]["focus_cbwidth"], aCoreCDB["UnitframeOptions"]["focus_cbheight"])	
					cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["focus_cbheight"]*2)
				end
				
				cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -7, 0)
				
				cb.Time:ClearAllPoints()				
				if aCoreCDB["UnitframeOptions"]["timepos"] == "TOPLEFT" then
					cb.Time:SetPoint("BOTTOMLEFT", cb, "TOPLEFT", 0, 3)
					cb.Time:SetJustifyH("LEFT")
				elseif aCoreCDB["UnitframeOptions"]["timepos"] == "LEFT" then
					cb.Time:SetPoint("LEFT", cb, "LEFT", 0, 0)
					cb.Time:SetJustifyH("LEFT")
				elseif aCoreCDB["UnitframeOptions"]["timepos"] == "TOPRIGHT" then
					cb.Time:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", 0, 3)
					cb.Time:SetJustifyH("RIGHT")
				else -- RIGHT
					cb.Time:SetPoint("RIGHT", cb, "RIGHT", 0, 0)
					cb.Time:SetJustifyH("RIGHT")
				end
		
				cb.Text:ClearAllPoints()
				if aCoreCDB["UnitframeOptions"]["namepos"] == "TOPLEFT" then
					cb.Text:SetPoint("BOTTOMLEFT", cb, "TOPLEFT", 0, 3)
					cb.Text:SetJustifyH("LEFT")
				elseif aCoreCDB["UnitframeOptions"]["namepos"] == "LEFT" then
					cb.Text:SetPoint("LEFT", cb, "LEFT", 0, 0)
					cb.Text:SetJustifyH("LEFT")
				elseif aCoreCDB["UnitframeOptions"]["namepos"] == "TOPRIGHT" then
					cb.Text:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", 0, 3)
					cb.Text:SetJustifyH("RIGHT")
				else -- RIGHT
					cb.Text:SetPoint("RIGHT", cb, "RIGHT", 0, 0)
					cb.Text:SetJustifyH("RIGHT")
				end				
			else -- 附着施法条
				T.ReleaseDragFrame(cb)	
				cb:ClearAllPoints()
				cb:SetAllPoints(self)
				
				cb:SetStatusBarColor(0, 0, 0, 0)
				cb.backdrop:Hide()
				
				cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["height"]*2)
				
				cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -7, -aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"])
				
				cb.Time:ClearAllPoints()
				cb.Time:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", -3, -3)

				cb.Text:ClearAllPoints()				
				if u == "boss" or u == "arena" then
					cb.Text:SetPoint("BOTTOMLEFT", cb, "BOTTOMLEFT", 3, -3)					
				elseif aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
					cb.Text:SetPoint("BOTTOM", cb, "BOTTOM", 0, 0)
				else
					cb.Text:SetPoint("TOP", cb, "BOTTOM", 0,  -2-(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]))	
				end
			end		
		end

		self.Castbar = cb
		self.Castbar.ApplySettings()
	end
end

local CreatePlateCastbar = function(self, unit)	
	local cb = CreateFrame("StatusBar", nil, self)
	cb:SetStatusBarTexture(G.media.blank)
	
	-- 背景
	cb.backdrop = T.createBackdrop(cb, 1, 2)
		
	-- 法术名字
	cb.Text = T.createtext(cb, "OVERLAY", 8, "OUTLINE", "CENTER")
	cb.Text:SetPoint("TOP", cb, "BOTTOM", 0, -3)
	
	-- 光标
	cb.Spark = cb:CreateTexture(nil, "OVERLAY")
	cb.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	cb.Spark:SetBlendMode("ADD")
	cb.Spark:SetVertexColor(1,1,1)
	cb.Spark:SetPoint('CENTER', cb:GetStatusBarTexture(), 'RIGHT', 0, 0)
	
	-- 图标
	cb.Icon = cb:CreateTexture(nil, "OVERLAY", nil, 3)
	cb.Icon:SetTexCoord(.1, .9, .1, .9)	
	cb.Icon_bd = T.createBackdrop(cb.Icon, 1, 2, cb)	
	cb.Icon_bg = T.createTexBackdrop(cb, cb.Icon, "ARTWORK")
	
	-- 打断记号
	cb.Shield = cb:CreateTexture(nil, "OVERLAY")
	cb.Shield:SetAtlas("nameplates-InterruptShield")
	cb.Shield:SetSize(14, 15)
	cb.Shield:SetPoint("RIGHT", cb.Text, "LEFT", -3, 0)
		
	cb.PostCastStart = UpdateCastbarColor
	
	cb.Callback = function(self, event, unit)	
		if UnitIsUnit(unit, 'player') then
			if aCoreCDB["PlateOptions"]["playerplate"] and aCoreCDB["PlateOptions"]["platecastbar"] then
				self:EnableElement("Castbar")
				self.Castbar:ForceUpdate()
			else
				self:DisableElement("Castbar")
				self.Castbar:Hide()
			end
		elseif UnitReaction(unit, 'player') and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字
			if not aCoreCDB["PlateOptions"]["bar_onlyname"] then
				self:EnableElement("Castbar")
				self.Castbar:ForceUpdate()
			else
				self:DisableElement("Castbar")
				self.Castbar:Hide()
			end
		else
			self:EnableElement("Castbar")
			self.Castbar:ForceUpdate()
		end
	end
	RegisterNameplateEventCallback(cb.Callback)
	
	cb.ApplySettings = function()		
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			cb:SetStatusBarTexture(G.textureFile.."iconcastbar.tga")
			cb:SetSize(25, 25)
			
			cb:ClearAllPoints()	
			cb:SetPoint("TOP", self, "BOTTOM", 0, -aCoreCDB["PlateOptions"]["namefontsize"]-3)
							
			cb.Spark:SetSize(8, 35)
			
			cb.Icon:SetSize(20, 20)
			cb.Icon:ClearAllPoints()
			cb.Icon:SetPoint("CENTER", cb, "CENTER")
			cb.Icon_bd:Hide()
		else
			cb:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
			
			cb:ClearAllPoints()
			cb:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
			cb:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
			cb:SetHeight(aCoreCDB["PlateOptions"]["castbar_height"])
			
			cb.Spark:SetSize(8, aCoreCDB["PlateOptions"]["castbar_height"]*2)
			
			local icon_size = aCoreCDB["PlateOptions"]["bar_height"]+aCoreCDB["PlateOptions"]["castbar_height"]+3
			cb.Icon:SetSize(icon_size, icon_size)
			cb.Icon:ClearAllPoints()
			cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -5, 0)
			cb.Icon_bd:Show()
		end
	end

	self.Castbar = cb
	self.Castbar.ApplySettings()
end
--=============================================--
--[[ Swing Timer ]]--
--=============================================--
local CreateSwingTimer = function(self, unit) -- only for player
	if unit ~= "player" then return end
	
	local bar = CreateFrame("Frame", G.uiname.."SwingTimer", self)
	bar:SetSize(aCoreCDB["UnitframeOptions"]["swwidth"], aCoreCDB["UnitframeOptions"]["swheight"])
	bar.movingname = L["平砍计时条"]
	bar.point = {
		healer = {a1 = "TOP", parent = "AltzUI_playerCastbar", a2 = "BOTTOM", x = 0, y = -10},
		dpser = {a1 = "TOP", parent = "AltzUI_playerCastbar", a2 = "BOTTOM", x = 0, y = -10},
	}
	T.CreateDragFrame(bar)
	bar.hideOoc = true -- 脱战隐藏
	
	local normTex = aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar

	bar.Twohand = CreateFrame("StatusBar", nil, bar)
	bar.Twohand:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
	bar.Twohand:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
	bar.Twohand:SetStatusBarTexture(normTex)
	bar.Twohand:SetStatusBarColor(1, 1, .2, 1)
	
	bar.Twohand.backdrop = T.createBackdrop(bar.Twohand, 1)
	bar.Twohand:Hide()
	bar.Text = T.createtext(bar.Twohand, "OVERLAY", 12, "OUTLINE", "CENTER")
	bar.Text:SetPoint("CENTER")
	
	bar.Mainhand = CreateFrame("StatusBar", nil, bar)
	bar.Mainhand:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
	bar.Mainhand:SetPoint("BOTTOMRIGHT", bar, "RIGHT", 0, 0)
	bar.Mainhand:SetStatusBarTexture(normTex)
	bar.Mainhand:SetStatusBarColor(1, 1, .2, 1)
	
	bar.Mainhand.backdrop = T.createBackdrop(bar.Mainhand, 1)
	bar.Mainhand:Hide()
	bar.TextMH = T.createtext(bar.Mainhand, "OVERLAY", 12, "OUTLINE", "CENTER")
	bar.TextMH:SetPoint("CENTER")
	
	bar.Offhand = CreateFrame("StatusBar", nil, bar)
	bar.Offhand:SetPoint("TOPLEFT", bar, "LEFT", 0, -2)
	bar.Offhand:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -2)
	bar.Offhand:SetStatusBarTexture(normTex)
	bar.Offhand:SetStatusBarColor(.2, 1, .2, 1)

	bar.Offhand.backdrop = T.createBackdrop(bar.Offhand, 1)
	bar.Offhand:Hide()
	bar.TextOH = T.createtext(bar.Offhand, "OVERLAY", 12, "OUTLINE", "CENTER")
	bar.TextOH:SetPoint("CENTER")
	
	bar.EnableSettings = function(object)
		if object == self then
			if aCoreCDB["UnitframeOptions"]["swing"] then	
				self:EnableElement("Swing")
				T.RestoreDragFrame(object.Swing)
			else
				self:DisableElement("Swing")
				T.ReleaseDragFrame(object.Swing)
			end
		end
	end
	oUF:RegisterInitCallback(bar.EnableSettings)
	
	bar.ApplySettings = function()		
		-- texture
		bar.Twohand:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
		bar.Mainhand:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
		bar.Offhand:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
				
		-- height, width --
		bar:SetSize(aCoreCDB["UnitframeOptions"]["swwidth"], aCoreCDB["UnitframeOptions"]["swheight"])
		
		-- timer --
		bar.Text:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE")
		bar.TextMH:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE")
		bar.TextOH:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE")
	end

	self.Swing = bar
	self.Swing.ApplySettings()
end

--=============================================--
--[[ Auras ]]--
--=============================================--
local PostCreateIcon = function(auras, icon)
	icon.Icon:SetTexCoord(.2, .8, .2, .8)
	
	icon.Count:ClearAllPoints()
	icon.Count:SetPoint("BOTTOMRIGHT", 0, -3)
	icon.Count:SetFont(G.numFont, 8, "OUTLINE")		
	icon.Count:SetTextColor(.9, .9, .1)
	
	icon.Overlay:SetTexture(G.media.blank)
	icon.Overlay:SetDrawLayer("BACKGROUND")
	icon.Overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.Overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)

	icon.backdrop = T.createBackdrop(icon, nil, 2)
	
	icon.Cooldown:SetSize(auras.size, auras.size)
	icon.Cooldown:SetReverse(true)	
end
T.PostCreateIcon = PostCreateIcon

local PostUpdateGapButton = function(auras, unit, gapButton, position)
	gapButton.backdrop:Hide()
end

local PostUpdateIcon = function(icons, icon, unit, data, position)
	if data.sourceUnit and UnitIsUnit(data.sourceUnit, "player") or (UnitIsFriend("player", unit) and data.isHarmful) or aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][data.spellId] then
		icon.Icon:SetDesaturated(false)		
		icon.Count:Show()
	else
		icon.Icon:SetDesaturated(true) -- grey other's debuff casted on enemy.
		icon.Overlay:Hide()
		icon.Count:Hide()
	end
	
	icon.backdrop:Show()
end

local OverrideAurasSetPosition = function(auras, from, to)
	for i = from, to do
		local button = auras[i]
		if button and button:IsShown() then
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("LEFT", auras, "CENTER", -((aCoreCDB["PlateOptions"]["plateaurasize"]+4)*to-4)/2, 0)
			else
				button:SetPoint("LEFT", auras[i-1], "RIGHT", 4, 0)		
			end
		end
	end
end

local Target_AuraFilter = function(icons, unit, data)
	if data.sourceUnit and UnitIsUnit(data.sourceUnit, "player") then -- show all my auras
		return true
	elseif UnitIsFriend("player", unit) and (not aCoreCDB["UnitframeOptions"]["AuraFilterignoreBuff"] or data.isHarmful) then
		return true
	elseif not UnitIsFriend("player", unit) and (not aCoreCDB["UnitframeOptions"]["AuraFilterignoreDebuff"] or data.isHelpful) then
		return true
	elseif aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][data.spellId] then
		return true
	end
end

local Boss_AuraFilter = function(icons, unit, data)
	if data.sourceUnit and UnitIsUnit(data.sourceUnit, "player") or data.isHelpful then -- show buffs and my auras
		return true
	end
end

local Party_AuraFilter = function(icons, unit, data)
	if data.sourceUnit and UnitIsUnit(data.sourceUnit, "player") or data.isHarmful then -- show debuffs and my auras
		return true
	end
end

local NamePlate_AuraFilter = function(icons, unit, data)
	if data.sourceUnit and UnitIsUnit(data.sourceUnit, "player") then
		if aCoreCDB["PlateOptions"]["myfiltertype"] == "none" then
			return false
		elseif aCoreCDB["PlateOptions"]["myfiltertype"] == "whitelist" and aCoreCDB["PlateOptions"]["myplateauralist"][data.spellId] then
			return true
		elseif aCoreCDB["PlateOptions"]["myfiltertype"] == "blacklist" and not aCoreCDB["PlateOptions"]["myplateauralist"][data.spellId] then
			return true
		end
	else
		if aCoreCDB["PlateOptions"]["otherfiltertype"] == "whitelist" and aCoreCDB["PlateOptions"]["otherplateauralist"][data.spellId] then
			return true
		end
	end
end

local CreateAuras = function(self, unit)
	if not unit then return end
	local u = unit:match("[^%d]+")
	
	if T.multicheck(u, "target", "focus", "boss", "arena", "party", "player", "pet") then
		local auras = CreateFrame("Frame", nil, self)		
		auras:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -1, 14)
		auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
		auras.initialAnchor = "BOTTOMLEFT"
		auras["growth-x"] = "RIGHT"
		auras["growth-y"] = "UP"
		auras.spacing = 3
		auras.gap = true
		
		auras.showStealableBuffs = (G.myClass == "MAGE")
		auras.showDebuffType = true
		
		auras.PostCreateButton = PostCreateIcon
		auras.PostUpdateButton = PostUpdateIcon
		auras.PostUpdateGapButton = PostUpdateGapButton
		
		if unit == "player" or unit == "pet" then	
			auras.numBuffs = 0
			auras.numDebuffs = 6
		elseif unit == "target" then
			auras.numTotal = 9
			auras.FilterAura = Target_AuraFilter
		elseif u == "boss" or u == "arena" then -- boss 1-5
			auras.numTotal = 9
			auras.FilterAura = Boss_AuraFilter
		elseif u == "party" or u == "partypet" then
			auras.numTotal = 9
			auras.FilterAura = Party_AuraFilter
		end
		
		auras.EnableSettings = function(object)
			if not object or object == self then
				if self.unit == "player" then
					if aCoreCDB["UnitframeOptions"]["playerdebuffenable"] then
						self:EnableElement("Auras")
						self.Auras:ForceUpdate()
					else
						self:DisableElement("Auras")
					end
				end
			end
		end
		oUF:RegisterInitCallback(auras.EnableSettings)
		
		auras.ApplySettings =  function()			
			auras:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*2)		
			auras.size = aCoreCDB["UnitframeOptions"]["aura_size"]
			
			if unit == "player" then
				auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]+8)			
			end
		end

		self.Auras = auras
		self.Auras.ApplySettings()
	end	
end
T.CreateAuras = CreateAuras

local CreatePlateAuras = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -1, 14)
	auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
	auras.initialAnchor = "BOTTOMLEFT"
	auras["growth-x"] = "RIGHT"
	auras["growth-y"] = "UP"
	auras.spacing = 3
	auras.gap = true

	auras.showStealableBuffs = (G.myClass == "MAGE")
	auras.disableMouse = true
	auras.showDebuffType = true
	auras.reanchorIfVisibleChanged = true
	
	auras.PostCreateButton = PostCreateIcon
	auras.PostUpdateButton = PostUpdateIcon		
	auras.PostUpdateGapButton = PostUpdateGapButton	
	auras.SetPosition = OverrideAurasSetPosition
	auras.FilterAura = NamePlate_AuraFilter

	auras.Callback = function(self, event, unit)	
		if UnitIsUnit(unit, 'player') then
			self:DisableElement("Auras")
		elseif UnitReaction(unit, 'player') and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字
			if not aCoreCDB["PlateOptions"]["bar_onlyname"] then
				self:EnableElement("Auras")
				self.Auras:ForceUpdate()
			else
				self:DisableElement("Auras")
			end
		else
			self:EnableElement("Auras")
			self.Auras:ForceUpdate()
		end
	end
	RegisterNameplateEventCallback(auras.Callback)
	
	auras.ApplySettings =  function()
		auras:SetHeight(aCoreCDB["PlateOptions"]["plateaurasize"])		
		auras.numTotal = aCoreCDB["PlateOptions"]["plateauranum"]
		auras.size = aCoreCDB["PlateOptions"]["plateaurasize"]

		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			auras:SetPoint("BOTTOM", self.Health.value, "TOP", 0, -5)
		else
			auras:SetPoint("BOTTOM", self, "TOP", 0, aCoreCDB["PlateOptions"]["namefontsize"]+3)
		end
	end
	
	self.Auras = auras
	self.Auras.ApplySettings()
end

--=============================================--
--[[ Class Resource ]]--
--=============================================--
local PostUpdate_ClassPower = function(element, cur, max, hasMaxChanged)
	if not max or not cur then return end	
	
	if max <= 7 then
		for i = 1, max do
			if cur == max then
				element[i]:SetStatusBarColor(unpack(classicon_colors[max]))
			else
				element[i]:SetStatusBarColor(unpack(classicon_colors[i]))
			end
		end
	else
		for i = 1, 5 do
			if cur <= 5 then
				element[i]:SetStatusBarColor(unpack(cpoints_colors[1]))
			else
				if cur - 5 >= i then
					element[i]:SetStatusBarColor(unpack(cpoints_colors[2]))
				else
					element[i]:SetStatusBarColor(unpack(cpoints_colors[1]))
				end
			end
		end
	end
	
	if hasMaxChanged then
		for i = 1, 7 do
			if max == 5 or max == 10 then
				element[i]:SetWidth((element:GetWidth()+3)/5-3)
				if i > 5 then
					element[i]:Hide()
				end
			else
				element[i]:SetWidth((element:GetWidth()+3)/max-3)
				if i > max then
					element[i]:Hide()
				end
			end
		end
	end
end

local PostUpdate_Runes = function(self, runemap)
	for index, runeID in next, runemap do
		local rune = self[index]
		if (not rune) then break end
		if not UnitHasVehicleUI('player') then
			local start, duration, runeReady = GetRuneCooldown(runeID)
			if(runeReady) then
				rune.value:SetText("")
			elseif(start) then
				rune.dur = GetTime() - start
				rune:SetMinMaxValues(0, duration)
				rune:SetValue(0)
				rune:SetScript('OnUpdate', function(self, elapsed)
					local dur = self.dur + elapsed
					self.dur = dur
					self:SetValue(dur)
					if dur >= duration or dur <= 0 then
						self.value:SetText("")
					else
						self.value:SetText(T.FormatTime(duration - dur))
					end
				end)
			end
		end
	end
end

local function CreateClassResources(self)
	if T.multicheck(G.myClass, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID","EVOKER") then
		local count = (G.myClass == "DEATHKNIGHT") and 6 or 7
		local bars = CreateFrame("Frame", self:GetName().."SpecOrbs", self)
		
		for i = 1, count do
			bars[i] = T.createStatusbar(bars)
			
			if i == 1 then
				bars[i]:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT", 0, 0)
			else
				bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
			end
			
			bars[i].bg = bars[i]:CreateTexture(nil, 'BACKGROUND')
			bars[i].bg:SetAllPoints(bars[i])
			bars[i].bg.multiplier = .2
			
			bars[i].backdrop = T.createBackdrop(bars[i], 1)
			
			bars[i].value = T.createtext(bars[i], "OVERLAY", 12, "OUTLINE", "CENTER")
			bars[i].value:SetPoint("CENTER", bars[i], "CENTER")
		end
		
		bars.ApplySettings = function()
			local width, height = aCoreCDB["UnitframeOptions"]["width"], aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]
			
			bars:SetSize(width, height)
			
			for i = 1, count do
				bars[i]:SetSize((width+3)/count-3, height)
				if G.myClass == "DEATHKNIGHT" then
					if aCoreCDB["UnitframeOptions"]["runecooldown"] then
						bars[i].value:Show()
					else
						bars[i].value:Hide()
					end
					bars[i].value:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["valuefs"], "OUTLINE")
				end
			end
			
			bars:ClearAllPoints()
			
			if G.myClass == "DRUID" and aCoreCDB["UnitframeOptions"]["dpsmana"] then
				bars:SetPoint("BOTTOM", self, "TOP", 0, 6+height)
			else
				bars:SetPoint("BOTTOM", self, "TOP", 0, 3)
			end
		end
		
		if G.myClass == "DEATHKNIGHT" then	
			bars.PostUpdate = PostUpdate_Runes
			
			self.Runes = bars
			self.Runes.ApplySettings()
		elseif T.multicheck(G.myClass , "PALADIN","MONK","WARLOCK","MAGE","ROGUE","DRUID","EVOKER") then
			bars.PostUpdate = PostUpdate_ClassPower
			
			self.ClassPower = bars
			self.ClassPower.ApplySettings()
		end
	end
end

local function CreatePlateClassResources(self)
	if T.multicheck(G.myClass, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
		local count = (G.myClass == "DEATHKNIGHT") and 6 or 7
		local bars = CreateFrame("Frame", self:GetName().."SpecOrbs", self)
				
		for i = 1, count do
			bars[i] = T.createStatusbar(bars)
	
			if i == 1 then
				bars[i]:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT", 0, 0)
			else
				bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
			end
			
			bars[i].bg = bars[i]:CreateTexture(nil, 'BACKGROUND')
			bars[i].bg:SetAllPoints(bars[i])
			bars[i].bg.multiplier = .2
			
			bars[i].backdrop = T.createBackdrop(bars[i], 1)
			
			bars[i].value = T.createtext(bars[i], "OVERLAY", 12, "OUTLINE", "CENTER")
			bars[i].value:SetPoint("CENTER", bars[i], "CENTER")
		end
		
		bars.Callback = function(self, event, unit)
			local element = (G.myClass == "DEATHKNIGHT" and "Runes") or "ClassPower"
			if not self[element] then return end
			
			if UnitIsUnit(unit, 'player') and aCoreCDB["PlateOptions"]["playerplate"] and aCoreCDB["PlateOptions"]["classresource_show"] then
				self:EnableElement(element)
				self[element]:ForceUpdate()
				self[element]:Show()		
			else
				self:DisableElement(element)
				self[element]:Hide()
			end
		end
		RegisterNameplateEventCallback(bars.Callback)
	
		bars.ApplySettings = function()
			local width, height
					
			if aCoreCDB["PlateOptions"]["theme"] == "number" then
				width = 60
				height = 2
				bars:ClearAllPoints()
				bars:SetPoint("TOP", self.Health.value, "BOTTOM", 0, -3)
			else
				width = aCoreCDB["PlateOptions"]["bar_width"]
				height = aCoreCDB["PlateOptions"]["bar_height"]/4
				bars:ClearAllPoints()
				bars:SetPoint("TOP", self.Tag_Name, "BOTTOM", 0, -1)
			end
	
			bars:SetSize(width, height)
			
			for i = 1, count do
				bars[i]:SetSize((width+3)/count-3, height)
				if G.myClass == "DEATHKNIGHT" then
					if aCoreCDB["UnitframeOptions"]["runecooldown"] then
						bars[i].value:Show()
					else
						bars[i].value:Hide()
					end
					bars[i].value:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["valuefs"], "OUTLINE")
				end
			end
		end

		if G.myClass == "DEATHKNIGHT" then	
			bars.PostUpdate = PostUpdate_Runes
			
			self.Runes = bars
			self.Runes.ApplySettings()
		elseif T.multicheck(G.myClass , "PALADIN","MONK","WARLOCK","MAGE","ROGUE","DRUID") then
			bars.PostUpdate = PostUpdate_ClassPower
			
			self.ClassPower = bars
			self.ClassPower.ApplySettings()
		end
	end
end

--=============================================--
--[[ Unit Frames ]]--
--=============================================--
local func = function(self, unit)
	local u = unit:match("[^%d]+")
	
	if T.multicheck(u, "boss", "party", "partypet") then
		T.RaidOnMouseOver(self)
		T.CreateClickSets(self)
	else
		T.OnMouseOver(self)
	end
	
	self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- 文字/标记框体层
	self.cover = CreateFrame("Frame", nil, self)
	self.cover:SetAllPoints(self)
	self.cover:SetFrameLevel(self:GetFrameLevel()+5)
	
	-- 高亮
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
	self.hl:SetAllPoints()
	self.hl:SetTexture(G.textureFile.."highlight.tga")
	self.hl:SetVertexColor( 1, 1, 1, .3)
	self.hl:SetBlendMode("ADD")
	
	-- 背景
	self.bg = self:CreateTexture(nil, 'BACKGROUND')
    self.bg:SetAllPoints(self)
	
	-- 目标边框
	if T.multicheck(u, "party", "partypet", "boss", "arena") then
		local targetborder = T.createPXBackdrop(self, nil, 2)
		targetborder:SetBackdropBorderColor(1, 1, .4)
		targetborder:SetFrameLevel(self:GetFrameLevel()+4)
		targetborder:Hide()
		targetborder.ShowPlayer =  true
		
		self.TargetIndicator = targetborder
	end
	
	-- 仇恨边框
	if u == "party" then
		local threatborder = T.createPXBackdrop(self, nil, 2)
		threatborder:SetFrameLevel(self:GetFrameLevel()+3)
		threatborder:Hide()
		
		threatborder.Override = T.Override_ThreatUpdate
		self.ThreatIndicator = threatborder
	end
	
	-- 生命条
	local hp = T.createStatusbar(self)
	hp:SetAllPoints(self)
	hp:SetFrameLevel(self:GetFrameLevel()+1)
	hp:SetReverseFill(true)

	hp.backdrop = T.createBackdrop(hp)
	
	hp.cover = hp:CreateTexture(nil, "BACKGROUND")
    hp.cover:SetAllPoints(hp)
	hp.cover:SetTexture(G.media.blank)
	
	if not T.multicheck(u, "targettarget", "focustarget", "pet", "partypet") then
		hp.value = T.createnumber(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "RIGHT")
	end
	
	T.CreateTextureIndforStatusbar(hp)
	
	hp.ApplySettings = function()
		T.ApplyHealthThemeSettings(self, hp)
				
		-- height, width --
		if T.multicheck(u, "targettarget", "focustarget", "pet", "partypet") then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthpet"], aCoreCDB["UnitframeOptions"]["height"])
		elseif u == "boss" then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthboss"], aCoreCDB["UnitframeOptions"]["height"])
		elseif u == "arena" then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widtharena"], aCoreCDB["UnitframeOptions"]["height"])	
		elseif u == "party" then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"])
		else
			self:SetSize(aCoreCDB["UnitframeOptions"]["width"], aCoreCDB["UnitframeOptions"]["height"])
		end
		
		-- value --
		if hp.value then
			hp.value:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE")
			hp.value:ClearAllPoints()
			if aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
				hp.value:SetPoint("BOTTOMRIGHT", self, -4, -2)
			else
				hp.value:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -4, -2-(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]))
			end
		end
	end
		
	hp.PostUpdateColor = PostUpdate_HealthColor
	hp.Override = Override_Health
	hp.UpdateColorArenaPreparation = (u == "arena" and UpdateColorArenaPreparation)

	tinsert(self.mouseovers, hp)
	
	self.Health = hp
	self.Health.ApplySettings()	
	
	-- 治疗预估和吸收
	if T.multicheck(u, "player", "target", "focus") then
		local hp_predict = {
			myBar = CreateHealPreditionBar(self, .4, .8, 0),
			otherBar = CreateHealPreditionBar(self, 0, .4, 0),
			absorbBar = CreateHealPreditionBar(self, .2, 1, 1, .7),
			healAbsorbBar = CreateHealPreditionBar(self, 1, 0, 1, .7),		
			maxOverflow = 1.05,
		}
		
		hp_predict.otherBar:SetPoint('LEFT', hp_predict.myBar:GetStatusBarTexture(), 'RIGHT')
		hp_predict.absorbBar:SetPoint('LEFT', hp_predict.otherBar:GetStatusBarTexture(), 'RIGHT')
	
		hp_predict.EnableSettings = function(object)
			if not object or object == self then	
				if aCoreCDB["UnitframeOptions"]["uf_healprediction"] then
					self:EnableElement("HealthPrediction")				
				else
					self:DisableElement("HealthPrediction")
				end
			end
		end
		oUF:RegisterInitCallback(hp_predict.EnableSettings)
		
		hp_predict.ApplySettings = function()
			if aCoreCDB["SkinOptions"]["style"] ~= 3 then
				hp_predict.myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
				hp_predict.healAbsorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
			else
				hp_predict.myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
				hp_predict.healAbsorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
			end
		end
		
		self.HealthPrediction = hp_predict
		self.HealthPrediction.ApplySettings()
	end
	
	-- 肖像
	if T.multicheck(u, "player", "target", "focus", "party", "boss", "arena") then
		local portrait = CreateFrame('PlayerModel', nil, self)	
		portrait:SetFrameLevel(self:GetFrameLevel())
		portrait:SetAllPoints(hp)

		portrait.EnableSettings = function(object)
			if not object or object == self then	
				if aCoreCDB["UnitframeOptions"]["portrait"] then
					self:EnableElement("Portrait")
					self.Portrait:ForceUpdate()
				else
					self:DisableElement("Portrait")
				end
			end
		end
		oUF:RegisterInitCallback(portrait.EnableSettings)
		
		self.Portrait = portrait
	end

	-- 能量
	if not T.multicheck(u, "targettarget", "focustarget", "partypet") then
		local pp = T.createStatusbar(self)
		pp:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
		pp:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
		pp:SetFrameLevel(self:GetFrameLevel()+2)
		
		pp.backdrop = T.createBackdrop(pp)
		
		pp.bg = pp:CreateTexture(nil, 'BACKGROUND')
		pp.bg:SetAllPoints(pp)
		pp.bg.multiplier = .2
		
		if not T.multicheck(u, "pet", "boss", "arena") then
			pp.value = T.createnumber(pp, "OVERLAY", 16, "OUTLINE", "LEFT")
		end

		pp.ApplySettings = function()		
			pp:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"])
			
			ApplyPowerThemeSettings(pp)
		
			if pp.value then
				pp.value:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE")
				pp.value:ClearAllPoints()
				if aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
					pp.value:SetPoint("BOTTOMLEFT", self, 4, -2)
				else
					pp.value:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 4, -2-(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]))
				end
			end
		end
		
		pp.PostUpdateColor = PostUpdate_PowerColor
		pp.PostUpdate = PostUpdate_Power
		tinsert(self.mouseovers, pp)
		
		self.Power = pp
		self.Power.ApplySettings()
	end

	-- Alt能量
	if T.multicheck(u, "player", "boss", "pet") then
		local altpp = T.createStatusbar(self, 5, nil, 1, 1, 0, 1)
		
		if unit == "pet" then
			altpp:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -5)
			altpp:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -5)
		else
			altpp:SetPoint("TOPLEFT", _G["oUF_AltzPlayer"].Power, "BOTTOMLEFT", 0, -5)
			altpp:SetPoint("TOPRIGHT", _G["oUF_AltzPlayer"].Power, "BOTTOMRIGHT", 0, -5)
		end

		altpp.backdrop = T.createBackdrop(altpp, 1)

		altpp.value = T.createtext(altpp, "OVERLAY", 11, "OUTLINE", "CENTER")
		altpp.value:SetPoint"CENTER"

		self.AlternativePower = altpp
		self.AlternativePower.PostUpdate = PostUpdate_AltPower
	end
		
	-- 施法条
	CreateCastbars(self, unit)
	
	-- 平砍计时条
	CreateSwingTimer(self, unit)
	
	-- 光环
	CreateAuras(self, unit)
	
	-- 名字
	if unit ~= "player" and unit ~= "pet" then
		local name = T.createtext(self.cover, "OVERLAY", 13, "OUTLINE", "LEFT")
		name:SetPoint("TOPLEFT", self.cover, "TOPLEFT", 3, 9)
		name:SetPoint("TOPRIGHT", self.cover, "TOPRIGHT", -3, 9)
		name:SetHeight(13)
		
		if T.multicheck(u, "targettarget", "focustarget", "boss", "arena") then
			self:Tag(name, "[Altz:shortname]")
		else
			self:Tag(name, "[Altz:longname]")
		end
	end
	
	-- 团队领袖
	local leader = self.cover:CreateTexture(nil, "OVERLAY")
	leader:SetSize(12, 12)
	leader:SetPoint("BOTTOMLEFT", self.cover, "BOTTOMLEFT", 5, -5)
	self.LeaderIndicator = leader
	
	-- 团队助手
	local assistant = self.cover:CreateTexture(nil, "OVERLAY")
	assistant:SetSize(12, 12)
	assistant:SetPoint("BOTTOMLEFT", self.cover, "BOTTOMLEFT", 5, -5)
	self.AssistantIndicator = assistant
	
	-- 团队拾取
	local masterlooter = self.cover:CreateTexture(nil, "OVERLAY")
	masterlooter:SetSize(12, 12)
	masterlooter:SetPoint("LEFT", leader, "RIGHT")
	self.MasterLooterIndicator = masterlooter
	
	-- 团队标记
	local ricon = self.cover:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("CENTER", self.cover, "CENTER", 0, 0)
	ricon:SetSize(40, 40)
	ricon:SetTexture(G.textureFile.."raidicons.blp")
	self.RaidTargetIndicator = ricon
	
	-- 召唤标记
	local summonIndicator = self.cover:CreateTexture(nil, 'OVERLAY')
	summonIndicator:SetSize(32, 32)
	summonIndicator:SetPoint('TOPRIGHT')
	summonIndicator:SetAtlas('Raid-Icon-SummonPending', true)
	summonIndicator:Hide()	
	self.SummonIndicator = summonIndicator

	-- 渐隐
	if T.multicheck(unit, "player", "focus", "pet", "focustarget") then
		local fader = {
			FadeInSmooth = 0.4,
			FadeOutSmooth = 1.5,
			FadeCasting = true,
			FadeCombat = true,
			FadeTarget = true,
			FadeHealth = true,
			FadePower = true,
			FadeHover = true,			
		}
		
		fader.EnableSettings = function(object)
			if not object or object == self then	
				if aCoreCDB["UnitframeOptions"]["enablefade"] then
					self:EnableElement("Fader")
					self.Fader:ForceUpdate()
				else
					self:DisableElement("Fader")
					if self.Portrait then self.Portrait:SetAlpha(1) end
				end
			end
		end
		oUF:RegisterInitCallback(fader.EnableSettings)
		
		self.Fader = fader
	end
end

local UnitSpecific = {

	--========================--
	-- Player
	--========================--
	player = function(self, ...)
		func(self, ...)

		-- Runes, Shards, HolyPower and so on --
		CreateClassResources(self)

		-- Stagger
		if G.myClass == "MONK" then
			local stagger = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
			stagger:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 1)
			stagger:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 1)
			
			stagger.backdrop = T.createBackdrop(stagger)
			
			stagger.bg = stagger:CreateTexture(nil, 'BACKGROUND')
			stagger.bg:SetAllPoints(stagger)
			stagger.bg.multiplier = .2
	
			stagger.EnableSettings = function(object)
				if not object or object == self then
					if aCoreCDB["UnitframeOptions"]["stagger"] then
						self:EnableElement("Stagger")
						self.Stagger:ForceUpdate()
					else
						self:DisableElement("Stagger")
					end
				end
			end
			oUF:RegisterInitCallback(stagger.EnableSettings)
			
			stagger.ApplySettings = function()
				stagger:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"])
				
				if aCoreCDB["SkinOptions"]["style"] == 1 then
					stagger:SetStatusBarTexture(G.media.blank)
					stagger.bg:SetTexture(G.media.blank)
				else
					stagger:SetStatusBarTexture(G.media.ufbar)
					stagger.bg:SetTexture(G.media.ufbar)
				end
			end
			
			self.Stagger = stagger
			stagger.ApplySettings()
		end

		-- Shaman mana
		if T.multicheck(G.myClass, "SHAMAN", "PRIEST", "DRUID") then
			local dpsmana = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
			dpsmana:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 1)
			dpsmana:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 1)

			dpsmana:SetMinMaxValues(0, 2)
			dpsmana:SetValue(1)
			
			dpsmana.backdrop = T.createBackdrop(dpsmana, 1)

			dpsmana.bg = dpsmana:CreateTexture(nil, 'BACKGROUND')
			dpsmana.bg:SetAllPoints(dpsmana)
			dpsmana.bg.multiplier = .2

			dpsmana.EnableSettings = function(object)
				if not object or object == self then
					if aCoreCDB["UnitframeOptions"]["dpsmana"] then
						self:EnableElement("Dpsmana")
						self.Dpsmana:ForceUpdate()
					else
						self:DisableElement("Dpsmana")
					end
				end
			end
			oUF:RegisterInitCallback(dpsmana.EnableSettings)
	
			dpsmana.ApplySettings = function()
				dpsmana:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"])
				if aCoreCDB["SkinOptions"]["style"] == 1 then
					dpsmana:SetStatusBarTexture(G.media.blank)
					dpsmana.bg:SetTexture(G.media.blank)
				else
					dpsmana:SetStatusBarTexture(G.media.ufbar)
					dpsmana.bg:SetTexture(G.media.ufbar)
				end
			end
			
			self.Dpsmana = dpsmana
			dpsmana.ApplySettings()			
		end

		-- Zzz
		local Resting = self.cover:CreateTexture(nil, 'OVERLAY')
		Resting:SetSize(18, 18)
		Resting:SetTexture(G.textureFile.."resting.tga")
		Resting:SetDesaturated(true)
		Resting:SetVertexColor( 0, 1, 0)
		Resting:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		self.RestingIndicator = Resting

		-- Combat
		local Combat = self.cover:CreateTexture(nil, "OVERLAY")
		Combat:SetSize(18, 18)
		Combat:SetTexture(G.textureFile.."combat.tga")
		Combat:SetDesaturated(true)
		Combat:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		Combat:SetVertexColor( 1, 1, 0)
		
		self.CombatIndicator = Combat
		self.CombatIndicator.PostUpdate = PostUpdate_CombatIndicator

		-- PvP
		local PvP = self.cover:CreateTexture(nil, 'OVERLAY')
		PvP:SetSize(35, 35)
		PvP:SetPoint("CENTER", self, "TOPRIGHT", 5, -5)
		
		PvP.EnableSettings = function(object)
			if not object or object == self then	
				if aCoreCDB["UnitframeOptions"]["pvpicon"] then
					self:EnableElement("PvPIndicator")
					self.PvPIndicator:ForceUpdate()
				else
					self:DisableElement("PvPIndicator")
				end
			end
		end
		oUF:RegisterInitCallback(PvP.EnableSettings)
		
		self.PvPIndicator = PvP
	end,

	--========================--
	-- Target
	--========================--
	target = function(self, ...)
		func(self, ...)
	end,

	--========================--
	-- Focus
	--========================--
	focus = function(self, ...)
		func(self, ...)
	end,

	--========================--
	-- Focus Target
	--========================--
	focustarget = function(self, ...)
		func(self, ...)
	end,

	--========================--
	-- Pet
	--========================--
	pet = function(self, ...)
		func(self, ...)
	end,

	--========================--
	-- Target Target
	--========================--
	targettarget = function(self, ...)
		func(self, ...)
	end,

	--========================--
	-- Party
	--========================--
	praty = function(self, ...)
		func(self, ...)
	end,
	
	--========================--
	-- PartyPet
	--========================--
	partypet = function(self, ...)
		func(self, ...)
	end,
		
	--========================--
	-- Boss
	--========================--
	boss = function(self, ...)
		func(self, ...)
	end,

	--========================--
	-- Arena
	--========================--
	arena = function(self, ...)
		func(self, ...)

		local specIcon = CreateFrame("Frame", nil, self)
		specIcon:SetPoint("LEFT", self, "RIGHT", 5, 0)
		specIcon.backdrop = T.createBackdrop(specIcon)
		
		specIcon.ApplySettings = function()		
			self.PVPSpecIcon:SetSize(aCoreCDB["UnitframeOptions"]["height"], aCoreCDB["UnitframeOptions"]["height"])	
		end
		
		self.PVPSpecIcon = specIcon
		self.PVPSpecIcon.ApplySettings()
		
		local trinkets = CreateFrame("Frame", nil, self)
		trinkets:SetPoint("LEFT", specIcon, "RIGHT", 5, 0)
		trinkets.backdrop = T.createBackdrop(trinkets)
		trinkets.trinketUseAnnounce = true
		trinkets.trinketUpAnnounce = true
		
		trinkets.ApplySettings = function()
			self.Trinket:SetSize(aCoreCDB["UnitframeOptions"]["height"], aCoreCDB["UnitframeOptions"]["height"])
		end
		
		self.Trinket = trinkets
		self.Trinket.ApplySettings()
		
		local PvPClassificationIndicator = self:CreateTexture(nil, 'OVERLAY')
		PvPClassificationIndicator:SetSize(24, 24)
		PvPClassificationIndicator:SetPoint('CENTER')
		
		self.PvPClassificationIndicator = PvPClassificationIndicator
	end,
}

--=============================================--
--[[ Nameplates ]]--
--=============================================--
local plate_func = function(self, unit)
	T.OnMouseOver(self)
	
	self:SetMouseClickEnabled(false)
	self.mouseovers = {}
	
	self:SetPoint("CENTER")
	
	-- 文字/标记框体层
	self.cover = CreateFrame("Frame", nil, self)
	self.cover:SetAllPoints(self)
	self.cover:SetFrameLevel(self:GetFrameLevel()+5)

	-- 生命条
	local hp = T.createStatusbar(self)
	hp:SetAllPoints(self)

	hp.backdrop = T.createBackdrop(hp, nil, 2)
	
	hp.value = T.createtext(hp, "OVERLAY", 10, "OUTLINE", "CENTER")
	
	T.CreateTextureIndforStatusbar(hp, true)
	
	hp.Callback = function(self, event, unit)
		if UnitIsUnit(unit, 'player') then
			if aCoreCDB["PlateOptions"]["playerplate"] then
				self:EnableElement("Health")	
				self.Health:ForceUpdate()			
			else
				self:DisableElement("Health")
			end
		elseif UnitReaction(unit, 'player') and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字
			if not aCoreCDB["PlateOptions"]["bar_onlyname"] then
				self:EnableElement("Health")
				self.Health:ForceUpdate()
			else
				self:DisableElement("Health")
			end
		else
			self:EnableElement("Health")
			self.Health:ForceUpdate()
		end
	end
	RegisterNameplateEventCallback(hp.Callback)
	
	hp.ApplySettings = function()
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			self:SetSize(aCoreCDB["PlateOptions"]["number_size"], aCoreCDB["PlateOptions"]["number_size"])
			
			hp:GetStatusBarTexture():SetAlpha(0)
			hp.backdrop:Hide()
			hp.ind:SetAlpha(0)
			
			hp.value:SetFont(G.plateFont, aCoreCDB["PlateOptions"]["number_size"], "OUTLINE")
			hp.value:ClearAllPoints()
			hp.value:SetPoint("BOTTOM")
			hp.value:SetJustifyH("CENTER")
			
		elseif aCoreCDB["PlateOptions"]["theme"] == "dark" then
			self:SetSize(aCoreCDB["PlateOptions"]["bar_width"], aCoreCDB["PlateOptions"]["bar_height"])
			
			hp:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)	
			hp:GetStatusBarTexture():SetAlpha(1)
			hp.backdrop:SetBackdropColor(.15, .15, .15, 1)
			hp.backdrop:Show()
			hp.ind:SetAlpha(1)
			
			hp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["valuefontsize"], "OUTLINE")			
			hp.value:ClearAllPoints()
			hp.value:SetPoint("BOTTOMRIGHT", hp, -4, -2)
			hp.value:SetJustifyH("RIGHT")
			
			hp:SetReverseFill(true)
			hp.colorClass = false
			hp.colorReaction = false
			hp.colorSmooth = true
		elseif aCoreCDB["PlateOptions"]["theme"] == "class" then
			self:SetSize(aCoreCDB["PlateOptions"]["bar_width"], aCoreCDB["PlateOptions"]["bar_height"])
			
			hp:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)		
			hp:GetStatusBarTexture():SetAlpha(1)
			hp.backdrop:Show()
			hp.ind:SetAlpha(1)
			
			hp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["valuefontsize"], "OUTLINE")
			hp.value:ClearAllPoints()			
			hp.value:SetPoint("BOTTOMRIGHT", hp, -4, -2)
			hp.value:SetJustifyH("RIGHT")
			
			hp:SetReverseFill(false)
			hp.colorClass = true
			hp.colorReaction = true
			hp.colorSmooth = false
		end
		
		if aCoreCDB["PlateOptions"]["threatcolor"] then
			hp.colorThreat = true
		else
			hp.colorThreat = false
		end
	end
	
	hp.UpdateColor = Override_PlateHealthColor
	hp.Override = Override_PlateHealth
	tinsert(self.mouseovers, hp)
	
	self.Health = hp
	self.Health.ApplySettings()
	
	-- 焦点变色
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', function()
		self.Health:ForceUpdate() 
	end, true)
	
	-- 能量
	local pp = T.createStatusbar(self)
	pp:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -3)
	pp:SetPoint("TOPRIGHT", hp, "BOTTOMRIGHT", 0, -3)
	
	pp.backdrop = T.createBackdrop(pp, nil, 2)
	
	pp.bg = pp:CreateTexture(nil, 'BACKGROUND')
	pp.bg:SetAllPoints(pp)
	pp.bg.multiplier = .2
		
	pp.value = T.createnumber(pp, "OVERLAY", 10, "OUTLINE", "LEFT")
	
	pp.Callback = function(self, event, unit)		
		if UnitIsUnit(unit, 'player') then
			if aCoreCDB["PlateOptions"]["playerplate"] then
				self:EnableElement("Power")	
				self.Power:ForceUpdate()			
			else
				self:DisableElement("Power")
			end		
		else
			local name = UnitName(unit)
			if aCoreCDB["PlateOptions"]["custompowerplates"][name] or UnitIsUnit(unit, "player") then	
				self:EnableElement('Power')
				self.Power:ForceUpdate()
			else
				self:DisableElement('Power')
			end
		end
	end
	RegisterNameplateEventCallback(pp.Callback)
	
	pp.ApplySettings = function()
		pp:SetHeight(aCoreCDB["PlateOptions"]["bar_height"]/4)
		
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			pp:GetStatusBarTexture():SetAlpha(0)
			pp.backdrop:Hide()
			pp.bg:Hide()
			
			pp.value:SetFont(G.plateFont, aCoreCDB["PlateOptions"]["number_size"]/2, "OUTLINE")
			pp.value:ClearAllPoints()
			pp.value:SetPoint("BOTTOMLEFT", hp.value, "BOTTOMRIGHT", 0, 2)
		else
			pp:GetStatusBarTexture():SetAlpha(1)
			pp.backdrop:Show()
			pp.bg:Show()
			
			pp:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
			pp.bg:SetTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)

			pp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["valuefontsize"], "OUTLINE")
			pp.value:ClearAllPoints()			
			pp.value:SetPoint("BOTTOMLEFT", self, 4, -2)
		end
		
		if aCoreCDB["PlateOptions"]["theme"] == "dark" then
			pp.colorPower = false
			pp.colorClass = true
			pp.colorReaction = true			
		else
			pp.colorPower = true
			pp.colorClass = false
			pp.colorReaction = false
		end
	end
	
	pp.PostUpdateColor = PostUpdate_PowerColor
	pp.PostUpdate = PostUpdate_Power
	tinsert(self.mouseovers, pp)

	self.Power = pp
	self.Power.ApplySettings()
	
	-- 施法条
	CreatePlateCastbar(self, unit)
	
	-- 光环
	CreatePlateAuras(self, unit)
	
	-- 连击点/个人资源
	CreatePlateClassResources(self)
	
	-- 名字
	local name = T.createtext(self.cover, "OVERLAY", 8, "OUTLINE", "CENTER")
	
	name.ApplySettings = function()
		name:SetFont(G.norFont, aCoreCDB["PlateOptions"]["namefontsize"], "OUTLINE")
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			name:ClearAllPoints()
			name:SetPoint("TOP", self, "BOTTOM")
		else
			name:ClearAllPoints()
			name:SetPoint("BOTTOM", self, "TOP", 0, 2)
		end
	end

	self:Tag(name, "[Altz:platename]")
	self.Tag_Name = name
	self.Tag_Name.ApplySettings()
	
	-- 目标名字
	local targetname = T.createtext(self.cover, "OVERLAY", 8, "OUTLINE", "LEFT")
	
	targetname.ApplySettings = function()
		targetname:SetFont(G.norFont, aCoreCDB["PlateOptions"]["targetnamefontsize"], "OUTLINE")
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			targetname:ClearAllPoints()
			targetname:SetJustifyH("CENTER")
			targetname:SetPoint("TOP", name, "BOTTOM", 0, 0)
		else
			targetname:ClearAllPoints()
			targetname:SetJustifyH("RIGHT")
			targetname:SetPoint("LEFT", self, "RIGHT", 0, 0)
		end
	end
	
	self:Tag(targetname, "[Altz:platetargetname]")
	self.Tag_TargetName = targetname
	self.Tag_TargetName.ApplySettings()
	
	-- 团队标记
	local ricon = self.cover:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("LEFT", self, "TOPLEFT", 5, 0)
	ricon:SetSize(20, 20)
	ricon:SetTexture(G.textureFile.."raidicons.blp")
	
	ricon.ApplySettings = function()		
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			ricon:ClearAllPoints()
			ricon:SetPoint("RIGHT", hp.value, "LEFT", 0, 0)
		else
			ricon:ClearAllPoints()
			ricon:SetPoint("LEFT", self, "TOPLEFT", 5, 0)
		end
	end
	
	self.RaidTargetIndicator = ricon
	self.RaidTargetIndicator.ApplySettings()
	
	-- 任务标记
	local qicon = self.cover:CreateTexture(nil, "OVERLAY")
	qicon:SetPoint("RIGHT", name, "LEFT", 3, 0)
	qicon:SetSize(10, 10)
	qicon:SetAtlas("QuestNormal")
	qicon.width = 10
	qicon.Override = Override_QusetUpdate
	self.QuestIndicator = qicon
	
	-- PVP标记
	local PvP = self.cover:CreateTexture(nil, 'OVERLAY')
	PvP:SetPoint("LEFT", name, "RIGHT", -3, 0)
	PvP:SetSize(12, 12)
	PvP.width = 12
	PvP.Override = Override_PvPUpdate
	self.PvPClassificationIndicator = PvP

	-- 目标箭头
	local arrow = CreateFrame("Frame", nil, self.cover)
	
	arrow.right = arrow:CreateTexture(nil, 'OVERLAY')
	arrow.right:SetPoint("LEFT", PvP, "RIGHT", 0, 0)
    arrow.right:SetSize(25, 20)
	arrow.right:SetRotation(rad(-90))  
	arrow.right:SetTexture(G.textureFile.."NeonRedArrow")
	
	arrow.left = arrow:CreateTexture(nil, 'OVERLAY')
	arrow.left:SetPoint("RIGHT", qicon, "LEFT", 0, 0)
    arrow.left:SetSize(25, 20)
	arrow.left:SetRotation(rad(90))  
	arrow.left:SetTexture(G.textureFile.."NeonRedArrow")
	
	self.TargetIndicator = arrow
end

local function PostUpdatePlate(self, event, unit)
	if event == "NAME_PLATE_UNIT_ADDED" then
		if not self then return end
		
		for _, func in pairs(nameplate_callbacks) do
			func(self, event, unit)
		end
	end
end

local function PostUpdateAllPlates()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.style == "Altz_Nameplates" and obj.unit then
			PostUpdatePlate(obj, "NAME_PLATE_UNIT_ADDED", obj.unit)
		end
	end
end
T.PostUpdateAllPlates = PostUpdateAllPlates
--=============================================--
--[[ Ctrl+Click EasyMenu ]]--
--=============================================--
local function RemovefromCPower(name)
	aCoreCDB["PlateOptions"]["custompowerplates"][name] = nil	
	PostUpdateAllPlates()
end

local function AddtoCPower(name)
	aCoreCDB["PlateOptions"]["custompowerplates"][name] = true
	PostUpdateAllPlates()
end

local function SetCColor(name)	
	if not aCoreCDB["PlateOptions"]["customcoloredplates"][name] then
		aCoreCDB["PlateOptions"]["customcoloredplates"][name] = {r = 1, g = 1, b = 1}
	end
	local color = aCoreCDB["PlateOptions"]["customcoloredplates"][name]
	T.ColorPicker_OnClick(color, function(r, g, b)
		T.TableValueToPath(aCoreCDB, {"PlateOptions", "customcoloredplates", name}, {r = r, g = g, b = b})
		PostUpdateAllPlates()
	end)
end

local function RemovefromCColor(name)
	aCoreCDB["PlateOptions"]["customcoloredplates"][name] = nil	
	PostUpdateAllPlates()
end

local menuFrame = CreateFrame("Frame", "NDui_EastMarking", UIParent, "UIDropDownMenuTemplate")

local rt_colors = {
	{1, .92, 0},
	{.98, .57, 0},
	{.83, .22, .9},
	{.04, .95, 0},
	{.7, .82, .875},
	{0, .71, 1},
	{1, .24, .17},
	{.98, .98, .98},
}

local function TargetMenu_Initialize(self, level, menuList)
	local target_name = GetUnitName("target", false)
	local info = UIDropDownMenu_CreateInfo()
	info.text = RAID_TARGET_NONE
	info.func = function()
		SetRaidTarget("target", 0)
	end
	info.checked = function()
		return not GetRaidTargetIndex("target")
	end
	UIDropDownMenu_AddButton(info)
	
	for i = 1, 8 do
		local r, g, b = unpack(rt_colors[i])
		info.text = T.hex_str(_G["RAID_TARGET_"..i], r, g, b).." "..ICON_LIST[i].."12|t"
		info.func = function()
			SetRaidTarget("target", i)
		end
		info.checked = function()
			return GetRaidTargetIndex("target") == i
		end
		UIDropDownMenu_AddButton(info)
	end
	
	UIDropDownMenu_AddSeparator()
	
	info.notCheckable = true
	
	if aCoreCDB["PlateOptions"]["custompowerplates"][target_name] then -- 已经有了
		info.text = string.format(L["移除自定义能量"], target_name)	
	else
		info.text = string.format(L["添加自定义能量"], target_name)
	end	
		
	info.func = function()
		if aCoreCDB["PlateOptions"]["custompowerplates"][target_name] then -- 已经有了
			RemovefromCPower(target_name)
		else
			AddtoCPower(target_name)
		end
	end

	UIDropDownMenu_AddButton(info)
	
	if aCoreCDB["PlateOptions"]["customcoloredplates"][target_name] then -- 已经有了
		local r, g, b = aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].r, aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].g, aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].b
		info.text = string.format(L["替换自定义颜色"], r*255, g*255, b*255, target_name)
	else
		info.text = string.format(L["添加自定义颜色"], target_name)
	end
		
	info.func = function()
		SetCColor(target_name)
	end
	
	UIDropDownMenu_AddButton(info)
	
	if aCoreCDB["PlateOptions"]["customcoloredplates"][target_name] then -- 已经有了
		local r, g, b = aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].r, aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].g, aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].b
		info.text = string.format(L["移除自定义颜色"], r*255, g*255, b*255, target_name)
			
		info.func = function()
			RemovefromCColor(target_name)
		end
		
		UIDropDownMenu_AddButton(info)
	end
end

local function HookNameplateCtrlMenu()
	WorldFrame:HookScript("OnMouseDown", function(_, btn)
		if not IsShiftKeyDown() then
			C_Timer.After(0.3, function()
				if btn == "LeftButton" and IsControlKeyDown() and UnitExists("target") then
					if not IsInGroup() or (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
						UIDropDownMenu_Initialize(menuFrame, TargetMenu_Initialize, "MENU")
						ToggleDropDownMenu(1, nil, menuFrame, "cursor", 3, -3)
					end
				end
			end)
		end
	end)
end
--=============================================--
--[[ Init ]]--
--=============================================--
oUF:RegisterStyle("Altz", func)

local PartyToggle = CreateFrame('Frame', G.uiname..'PartyToggle', UIParent, 'SecureHandlerStateTemplate')
PartyToggle:SetAllPoints()
PartyToggle:SetFrameStrata('LOW')
RegisterStateDriver(PartyToggle, 'visibility', '[group:party,nogroup:raid,nopetbattle]show;hide')

for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle("Altz - "..unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle("Altz - "..unit:gsub("^%l", string.upper))
	elseif(UnitSpecific[unit:match("[^%d]+")]) then -- boss1 -> boss
		self:SetActiveStyle("Altz - "..unit:match("[^%d]+"):gsub("^%l", string.upper))
	else
		self:SetActiveStyle"Altz"
	end

	local object = self:Spawn(unit)
	
	return object
end

T.RegisterInitCallback(function()
	oUF:Factory(function(self)
		local playerframe = spawnHelper(self, "player")
		playerframe.movingname = T.split_words(PLAYER,L["单位框架"])
		playerframe.point = {
			healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "BOTTOM", x = -250, y = 450},
			dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "BOTTOM", x = -250, y = 450},
		}
		T.CreateDragFrame(playerframe)

		local petframe = spawnHelper(self, "pet")
		petframe.movingname = T.split_words(PET,L["单位框架"])
		petframe.point = {
			healer = {a1 = "RIGHT", parent = playerframe:GetName(), a2 = "LEFT", x = -10, y = 0},
			dpser = {a1 = "RIGHT", parent = playerframe:GetName(), a2 = "LEFT", x = -10, y = 0},
		}
		T.CreateDragFrame(petframe)
		G.petframe = petframe
		
		local targetframe = spawnHelper(self, "target")
		targetframe.movingname = T.split_words(TARGET,L["单位框架"])
		targetframe.point = {
			healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "BOTTOM", x = 250, y = 450},
			dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "BOTTOM", x = 250, y = 450},
		}
		T.CreateDragFrame(targetframe)

		local totframe = spawnHelper(self, "targettarget")
		totframe.movingname = T.split_words(L["目标的目标"],L["单位框架"])
		totframe.point = {
			healer = {a1 = "LEFT", parent = targetframe:GetName(), a2 = "RIGHT" , x = 10, y = 0},
			dpser = {a1 = "LEFT", parent = targetframe:GetName(), a2 = "RIGHT" , x = 10, y = 0},
		}
		T.CreateDragFrame(totframe)

		local focusframe = spawnHelper(self, "focus")
		focusframe.movingname = T.split_words(L["焦点"],L["单位框架"])
		focusframe.point = {
			healer = {a1 = "BOTTOM", parent = targetframe:GetName(), a2 = "BOTTOM" , x = 0, y = 180},
			dpser = {a1 = "BOTTOM", parent = targetframe:GetName(), a2 = "BOTTOM" , x = 0, y = 180},
		}
		T.CreateDragFrame(focusframe)

		local ftframe = spawnHelper(self, "focustarget")
		ftframe.movingname = T.split_words(L["焦点的目标"],L["单位框架"])
		ftframe.point = {
			healer = {a1 = "LEFT", parent = focusframe:GetName(), a2 = "RIGHT" , x = 10, y = 0},
			dpser = {a1 = "LEFT", parent = focusframe:GetName(), a2 = "RIGHT" , x = 10, y = 0},
		}
		T.CreateDragFrame(ftframe)
				
		if not aCoreCDB["UnitframeOptions"]["raidframe_inparty"] then
			local partyframes = {} -- 小队
			for i = 1, 4 do
				partyframes["party"..i] = spawnHelper(self, "party"..i)
				partyframes["party"..i]:SetParent(PartyToggle) -- 团队中隐藏小队
			end
			for i = 1, 4 do
				partyframes["party"..i].movingname = T.split_words(PARTY,L["单位框架"],i)
				if i == 1 then
					partyframes["party"..i].point = {
						healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT" , x = 40, y = -340},
						dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT" , x = 40, y = -340},
					}
				else
					partyframes["party"..i].point = {
						healer = {a1 = "TOP", parent = partyframes["party"..(i-1)]:GetName(), a2 = "BOTTOM" , x = 0, y = -60},
						dpser = {a1 = "TOP", parent = partyframes["party"..(i-1)]:GetName(), a2 = "BOTTOM" , x = 0, y = -60},
					}
				end
				T.CreateDragFrame(partyframes["party"..i])
			end
			G.partyframes = partyframes
			if aCoreCDB["UnitframeOptions"]["showpartypet"] then
				local partypetframes = {} -- 小队宠物
				for i = 1, 4 do
					partypetframes["partypet"..i] = spawnHelper(self,"partypet"..i)
					partypetframes["partypet"..i]:SetParent(PartyToggle) -- 团队中隐藏小队宠物
				end
				for i = 1, 4 do					
					partypetframes["partypet"..i].movingname = T.split_words(PARTY,PET,L["单位框架"],i)
					partypetframes["partypet"..i].point = {
						healer = {a1 = "LEFT", parent = partyframes["party"..i]:GetName(), a2 = "RIGHT" , x = 5, y = 0},
						dpser = {a1 = "LEFT", parent = partyframes["party"..i]:GetName(), a2 = "RIGHT" , x = 5, y = 0},
					}
					T.CreateDragFrame(partypetframes["party"..i])
				end
				G.partypetframes = partypetframes
			end
		end

		if aCoreCDB["UnitframeOptions"]["bossframes"] then
			local bossframes = {}
			for i = 1, MAX_BOSS_FRAMES do
				bossframes["boss"..i] = spawnHelper(self,"boss"..i)
			end
			for i = 1, MAX_BOSS_FRAMES do
				bossframes["boss"..i].movingname = T.split_words(BOSS,L["单位框架"],i)
				if i == 1 then
					bossframes["boss"..i].point = {
						healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT" , x = -80, y = -300},
						dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT" , x = -80, y = -300},
					}
				else
					bossframes["boss"..i].point = {
						healer = {a1 = "TOP", parent = bossframes["boss"..(i-1)]:GetName(), a2 = "BOTTOM" , x = 0, y = -90},
						dpser = {a1 = "TOP", parent = bossframes["boss"..(i-1)]:GetName(), a2 = "BOTTOM" , x = 0, y = -60},
					}
				end
			end
			for i = 1, MAX_BOSS_FRAMES do
				T.CreateDragFrame(bossframes["boss"..i])
			end
			G.bossframes = bossframes
		end

		if aCoreCDB["UnitframeOptions"]["arenaframes"] then
			local arenaframes = {}
			for i = 1, 5 do
				arenaframes["arena"..i] = spawnHelper(self,"arena"..i)
			end
			for i = 1, 5 do
				arenaframes["arena"..i].movingname = T.split_words(ARENA,L["单位框架"],i)
				if i == 1 then
					arenaframes["arena"..i].point = {
						healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT" , x = -140, y = -340},
						dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT" , x = -140, y = -340},
					}
				else
					arenaframes["arena"..i].point = {
						healer = {a1 = "TOP", parent = arenaframes["arena"..(i-1)]:GetName(), a2 = "BOTTOM" , x = 0, y = -60},
						dpser = {a1 = "TOP", parent = arenaframes["arena"..(i-1)]:GetName(), a2 = "BOTTOM" , x = 0, y = -60},
					}
				end
				T.CreateDragFrame(arenaframes["arena"..i])
			end
			G.arenaframes = arenaframes
		end

		if aCoreCDB["PlateOptions"]["enableplate"] then
			oUF:RegisterStyle("Altz_Nameplates", plate_func)
			oUF:SetActiveStyle("Altz_Nameplates")
			oUF:SpawnNamePlates("Altz_Nameplates", PostUpdatePlate)			
		end
	end)

	if aCoreCDB["PlateOptions"]["playerplate"] then
		SetCVar("nameplateShowSelf", 1)
	else
		SetCVar("nameplateShowSelf", 0)
	end
	
	ClassNameplateManaBarFrame:SetAlpha(0)
	DeathKnightResourceOverlayFrame:SetAlpha(0)
	ClassNameplateBarMageFrame:SetAlpha(0)
	ClassNameplateBarWindwalkerMonkFrame:SetAlpha(0)
	ClassNameplateBarPaladinFrame:SetAlpha(0)
	ClassNameplateBarWarlockFrame:SetAlpha(0)
	
	HookNameplateCtrlMenu()
end)

--=============================================--
--[[ API ]]--
--=============================================--
local function EnableUFSettings(elements, style)
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.style == style or not style then
			for k, e in pairs(elements) do
				if obj[e] then
					if obj[e].EnableSettings then
						obj[e].EnableSettings()
					end
				end
			end
		end
	end
end
T.EnableUFSettings = EnableUFSettings

local function ApplyUFSettings(elements, style)
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.style == style or not style then
			for k, e in pairs(elements) do
				if obj[e] then
					if obj[e].ApplySettings then
						obj[e].ApplySettings()
					end
					if obj[e].ForceUpdate then
						obj[e]:ForceUpdate()
					end
				end
			end
		end
	end
end
T.ApplyUFSettings = ApplyUFSettings

local function UpdateUFTags(style)
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.style == style or not style then
			obj:UpdateTags()			
		end
	end
end
T.UpdateUFTags = UpdateUFTags

