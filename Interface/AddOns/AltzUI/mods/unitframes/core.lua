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

local function multicheck(check, ...)
	for i=1, select("#", ...) do
		if check == select(i, ...) then return true end
	end
	return false
end

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
	elseif UnitIsPlayer(unit)  then
		local _, unitclass = UnitClass(unit)
		r, g, b = unpack(oUF.colors.class[unitclass]) 
	elseif UnitReaction(unit, "player") then
		r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player")])
	else
		r, g, b = oUF.colors.reaction[5]
	end
	return r, g, b
end
T.GetUnitColorforNameplate = GetUnitColorforNameplate

local function GetUnitColor(unit)
	local r, g, b = 1, 1, 1
	if not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	elseif UnitIsPlayer(unit)  then
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

local PostAltUpdate = function(altpp, unit, cur, min, max)
	altpp.value:SetText(cur)
end

local CombopointsUpdate = function(self, event, unit, powerType)
	if(not (unit and (UnitIsUnit(unit, 'player') and (not powerType or powerType == 'COMBO_POINTS')
		or unit == 'vehicle' and powerType == 'COMBO_POINTS'))) then
		return
	end

	local element = self.ClassPower

	local cur, max, oldMax
	if(UnitHasVehicleUI'player') then
		cur = GetComboPoints('vehicle', 'target')
		max = UnitPowerMax('vehicle', Enum.PowerType.ComboPoints)
	else
		cur = UnitPower('player', Enum.PowerType.ComboPoints)
		max = UnitPowerMax('player', Enum.PowerType.ComboPoints)
	end

	if max <= 6 then
		for i = 1, max do
			element[i]:SetStatusBarColor(unpack(cpoints_colors[1]))
			if(i <= cur) then
				element[i]:Show()
			else
				element[i]:Hide()
			end
		end
	else
		for i = 1, 5 do
			if cur <= 5 then
				element[i]:SetStatusBarColor(unpack(cpoints_colors[1]))
				if(i <= cur) then
					element[i]:Show()
				else
					element[i]:Hide()
				end
			else
				for i = 1, cur - 5 do
					element[i]:SetStatusBarColor(unpack(cpoints_colors[2]))
				end
				for i = cur - 4, 5 do
					element[i]:SetStatusBarColor(unpack(cpoints_colors[1]))
				end
				element[i]:Show()
			end
		end
	end

	oldMax = element.__max
	if(max ~= oldMax) then
		for i = 1, 6 do
			if max == 5 or max == 10 then
				element[i]:SetWidth((element.width+3)/5-3)
				if i == 6 then
					element[i]:Hide()
				end
			else
				element[i]:SetWidth((element.width+3)/max-3)
				if i > max then
					element[i]:Hide()
				end
			end
		end
		element.__max = max
	end
end

local ClassIconsPostUpdate = function(element, cur, max, maxchange)
	for i = 1, 6 do
		if not max or not cur then return end
		if max > 0 and cur == max then
			element[i]:SetStatusBarColor(unpack(classicon_colors[max]))
		else
			element[i]:SetStatusBarColor(unpack(classicon_colors[i]))
		end
		if maxchange then
			element[i]:SetWidth((element:GetWidth()+3)/max-3)
		end
	end
end

local PostUpdateRunes = function(self, runemap)
	local rune, start, duration, runeReady
	for index, runeID in next, runemap do
		rune = self[index]
		if(not rune) then break end
		if not UnitHasVehicleUI('player') then
			start, duration, runeReady = GetRuneCooldown(runeID)
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

local CombatPostUpdate = function(self, inCombat)
	if inCombat then
		self.__owner.RestingIndicator:Hide()
	elseif IsResting() then
		self.__owner.RestingIndicator:Show()
	end
end

local function UpdatePrep()
	local numOpps = GetNumArenaOpponentSpecs()
	if numOpps > 0 then
		for i=1, 5 do
			if not _G["oUF_AltzArena"..i] then return end
			local s = GetArenaOpponentSpec(i)
			local _, spec, class, texture = nil, "UNKNOWN", "UNKNOWN", "INTERFACE\\ICONS\\INV_MISC_QUESTIONMARK"

			if s and s > 0 then
				_, spec, _, texture, _, _, class = GetSpecializationInfoByID(s)
			end

			if (i <= numOpps) then
				if class and spec then
					local color = oUF.colors.class[class]
					--print("职业"..class.."颜色"..color.r.." "..color.g.." "..color.b)
					_G["oUF_AltzArena"..i].prepFrame.SpecClass:SetText(spec.." - "..LOCALIZED_CLASS_NAMES_MALE[class])
					_G["oUF_AltzArena"..i].prepFrame.Health:SetStatusBarColor(color.r, color.g, color.b)
					_G["oUF_AltzArena"..i].prepFrame.Icon:SetTexture(G.media.blank)
					_G["oUF_AltzArena"..i].prepFrame:Show()
				end
			else
				_G["oUF_AltzArena"..i].prepFrame:Hide()
			end
		end
	else
		for i=1, 5 do
			if not _G["oUF_AltzArena"..i] then return end
			_G["oUF_AltzArena"..i].prepFrame:Hide()
		end
	end
end

local function RaidTargetIconPostUpdate(self)
	if UnitIsUnit(self.__owner.unit, "player") then
		self:Hide()
	end
end

local function TargetRedArrowupdate(self, event, unit)
	if event == "UNIT_AURA" and unit ~= self.unit then return end
	if UnitIsUnit('target', self.unit) and not UnitIsUnit('player', self.unit) then
		self.RedArrow:Show()
	else
		self.RedArrow:Hide()
	end
end

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

local PostUpdate_Health = function(self, unit, cur, max)
	local perc, status
	
	if max ~= 0 then
		perc = cur/max 
	else 
		perc = 1
	end
	
	if cur == 0 then
		status = "dead"
	elseif perc == 1 then
		status = "full"
	else
		status = "injured"
	end
	
	self:SetValue(max - cur)

	-- 标记
	if status == "injured" then
		self.ind:Show()
	else
		self.ind:Hide()
	end
		
	-- 数值
	if self.value then
		if status == "injured" or aCoreCDB["UnitframeOptions"]["alwayshp"] or (cur > 0 and self.__owner.isMouseOver and UnitIsConnected(unit)) then
			self.value:SetText(T.ShortValue(cur).." "..T.hex_str(math.floor(cur/max*100+.5), 1, 1, 0))
		else
			self.value:SetText(nil)
		end
	end
end
T.PostUpdate_Health = PostUpdate_Health

local Override_PlateHealthColor = function(self, event, unit)
	if(not unit or self.unit ~= unit) then return end
	local hp = self.Health
	
	local r, g, b = GetUnitColorforNameplate(unit)
	local r2, g2, b2 = self:ColorGradient(hp.cur or 1, hp.max or 1, unpack(self.colors.smooth))
	
	if aCoreCDB["PlateOptions"]["theme"] == "number" and aCoreCDB["PlateOptions"]["number_colorheperc"] then
		hp.value:SetTextColor(r2, g2, b2)
	else
		hp.value:SetTextColor(1, 1, 1)
	end
	
	if aCoreCDB["PlateOptions"]["theme"] == "dark" then		
		hp:SetStatusBarColor(r2, g2, b2)
	elseif aCoreCDB["PlateOptions"]["theme"] == "class" then
		hp:SetStatusBarColor(r, g, b)
		hp.backdrop:SetBackdropColor(r*.2, g*.2, b*.2, 1)
	end
end

local PostUpdate_PlateHealth = function(self, unit, cur, max)
	local perc, status

	if max ~= 0 then
		perc = cur/max 
	else 
		perc = 1 
	end
	
	if cur == 0 then
		status = "dead"
	elseif perc == 1 then
		status = "full"
	else
		status = "injured"
	end
	
	if aCoreCDB["PlateOptions"]["theme"] == "dark" then
		self:SetValue(max - cur)
	end
	
	-- 标记
	if aCoreCDB["PlateOptions"]["theme"] ~= "number" then
		if status == "injured" then
			self.ind:Show()
		else
			self.ind:Hide()
		end
	end
	
	-- 数值
	if aCoreCDB["PlateOptions"]["theme"] == "number" then
		if status == "injured" or aCoreCDB["PlateOptions"]["number_alwayshp"] then
			self.value:SetText(math.floor(perc*100+.5))
		else
			self.value:SetText(nil)
		end
	else
		if status == "injured" or aCoreCDB["PlateOptions"]["bar_alwayshp"] or (cur > 0 and self.__owner.isMouseOver and UnitIsConnected(unit))  then
			if aCoreCDB["PlateOptions"]["bar_hp_perc"] == "perc" then
				self.value:SetText(T.hex_str(math.floor(cur/max*100+.5), 1, 1, 0))
			else
				self.value:SetText(T.ShortValue(cur).." "..T.hex_str(math.floor(cur/max*100+.5), 1, 1, 0))
			end
		else
			self.value:SetText(nil)
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
				self.value:SetText("|cffFFFFFF"..math.floor(cur/max*100+.5)..'|r')
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
	if u == "nameplate" or (multicheck(u, "target", "player", "focus") and aCoreCDB["UnitframeOptions"]["independentcb"]) then
		local r, g, b = aCoreCDB["UnitframeOptions"]["Interruptible_color"].r, aCoreCDB["UnitframeOptions"]["Interruptible_color"].g, aCoreCDB["UnitframeOptions"]["Interruptible_color"].b
		local r2, g2, b2 = aCoreCDB["UnitframeOptions"]["notInterruptible_color"].r, aCoreCDB["UnitframeOptions"]["notInterruptible_color"].g, aCoreCDB["UnitframeOptions"]["notInterruptible_color"].b
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

local CreateCastbars = function(self, unit)
	local u = unit:match("[^%d]+")
	if multicheck(u, "target", "player", "focus", "boss", "arena") then
		local cb = CreateFrame("StatusBar", G.uiname..unit.."Castbar", self)
		cb:SetFrameLevel(self:GetFrameLevel()+2)
		cb:SetStatusBarTexture(G.media.blank)
		
		-- 独立施法条锚点
		if multicheck(u, "target", "player", "focus") then	
			if unit == "player" then
				cb.movingname = T.split_words(PLAYER,L["施法条"])
				cb.point = {
					healer = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -150},
					dpser = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -150},
				}
			elseif unit == "target" then	
				cb.movingname = T.split_words(TARGET,L["施法条"])
				cb.point = {
					healer = {a1 = "TOPLEFT", parent = "oUF_AltzTarget", a2 = "BOTTOMLEFT", x = 0, y = -10},
					dpser = {a1 = "TOPLEFT", parent = "oUF_AltzTarget", a2 = "BOTTOMLEFT", x = 0, y = -10},
				}
			elseif unit == "focus" then	
				cb.movingname = T.split_words(FOCUS,L["施法条"])
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
		cb.PostChannelStart = UpdateCastbarColor
		
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
			
			if multicheck(u, "target", "player", "focus") and aCoreCDB["UnitframeOptions"]["independentcb"] then -- 独立施法条	
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
				if u == "player" or u == "target" or u == "focus" then
					T.ReleaseDragFrame(cb)
					
					cb:ClearAllPoints()
					cb:SetAllPoints(self)
				end
				
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
	cb.PostChannelStart = UpdateCastbarColor
	
	cb.Callback = function(self, event, unit)	
		if UnitIsUnit(unit, 'player') then
			if aCoreCDB["PlateOptions"]["playerplate"] and aCoreCDB["PlateOptions"]["platecastbar"] then
				self:EnableElement("Castbar")
				self.Castbar:ForceUpdate()
			else
				self:DisableElement("Castbar")
				self.Castbar:Hide()
			end
		elseif UnitIsPlayer(unit) and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字
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
			cb:SetStatusBarTexture(G.media.iconcastbar)
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
			cb:SetHeight(aCoreCDB["PlateOptions"]["bar_height"]/4)
			
			cb.Spark:SetSize(8, aCoreCDB["PlateOptions"]["bar_height"]*2)
			
			cb.Icon:SetSize(aCoreCDB["PlateOptions"]["bar_height"]*1.25+3, aCoreCDB["PlateOptions"]["bar_height"]*1.25+3)
			cb.Icon:ClearAllPoints()
			cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -5, 0)
			cb.Icon_bd:Show()
		end
	end
	
	cb.ApplySettings()

	self.Castbar = cb
end

--=============================================--
--[[ Swing Timer ]]--
--=============================================--
local CreateSwingTimer = function(self, unit) -- only for player
	if unit ~= "player" then return end
	
	local bar = CreateFrame("Frame", G.uiname.."SwingTimer", self)
	bar:SetSize(aCoreCDB["UnitframeOptions"]["swwidth"], aCoreCDB["UnitframeOptions"]["swheight"])
	bar.movingname = L["玩家平砍计时条"]
	bar.point = {
		healer = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -160},
		dpser = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -160},
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
		if not object or object == self then
			if aCoreCDB["UnitframeOptions"]["swing"] then	
				self:EnableElement("Swing")
			else
				self:DisableElement("Swing")
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
		if aCoreCDB["UnitframeOptions"]["swtimer"] then
			bar.Text:Show()
			bar.TextMH:Show()
			bar.TextOH:Show()
		else
			bar.Text:Hide()
			bar.TextMH:Hide()
			bar.TextOH:Hide()
		end

		bar.Text:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE")
		bar.TextMH:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE")
		bar.TextOH:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE")
	end

	bar.ApplySettings()
	
	self.Swing = bar
end

--=============================================--
--[[ Auras ]]--
--=============================================--
local PostCreateIcon = function(auras, icon)
	icon.Icon:SetTexCoord(.2, .8, .2, .8)
	
	icon.Count:ClearAllPoints()
	icon.Count:SetPoint("BOTTOMRIGHT", 0, -3)
	icon.Count:SetFontObject(nil)	
	icon.Count:SetTextColor(.9, .9, .1)
	
	icon.Overlay:SetTexture(G.media.blank)
	icon.Overlay:SetDrawLayer("BACKGROUND")
	icon.Overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.Overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
	
	icon.backdrop = T.createBackdrop(icon, nil, 2)

	if auras.__owner.style == 'Altz_Nameplates' then
		icon.Count:SetFont(G.numFont, aCoreCDB["PlateOptions"]["numfontsize"], "OUTLINE")
		icon.remaining = T.createnumber(icon, "OVERLAY", aCoreCDB["PlateOptions"]["numfontsize"], "OUTLINE", "CENTER")
	else
		icon.Count:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["aura_size"]*.4, "OUTLINE")
		icon.remaining = T.createnumber(icon, "OVERLAY", aCoreCDB["UnitframeOptions"]["aura_size"]*.4, "OUTLINE", "CENTER")
	end
	
	icon.remaining:SetPoint("TOPLEFT", 0, 5)
	
	auras.showDebuffType = true
end

local CreateAuraTimer = function(self, elapsed)
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

local whitelist = {
	[123059] = true, -- 动摇意志
}

local PostUpdateIcon = function(icons, icon, unit, data, position)
	if icon.isPlayer or UnitIsFriend("player", unit) or not icon.isDebuff or aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][data.spellId] or whitelist[data.spellId] then
		icon.Icon:SetDesaturated(false)
		if data.duration and data.duration > 0 then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon.Count:Show()
	else
		icon.Icon:SetDesaturated(true) -- grey other's debuff casted on enemy.
		icon.overlay:Hide()
		icon.remaining:Hide()
		icon.Count:Hide()
	end
	
	if data.duration then
		icon.backdrop:Show() -- if the aura is not a gap icon show it"s backdrop
	end
	
	icon.expires = data.expirationTime
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

local PostUpdateGapButton = function(auras, unit, icon, visibleBuffs)
	icon.backdrop:Hide()
	icon.remaining:Hide()
end

local OverrideAurasSetPosition = function(auras, from, to)
	auras.iconnum = 1
	for i = from, to do
		local button = auras[i]
		
		if not button or not button:IsShown() then break end
		
		auras.iconnum = i
		button:ClearAllPoints()
		if i ~= 1 then
			button:SetPoint("LEFT", auras[i-1], "RIGHT", 4, 0)		
		end
	end
	
	if auras[1] then
		auras[1]:SetPoint("LEFT", auras, "CENTER", -((aCoreCDB["PlateOptions"]["plateaurasize"]+4)*auras.iconnum-4)/2, 5)
	end
	
	if auras[1] and auras[1]:IsShown() then
		auras.__owner.RedArrow:SetPoint('BOTTOM', auras.__owner, 'TOP', 0, 15+aCoreCDB["PlateOptions"]["plateaurasize"]) -- 有光环
	else
		auras.__owner.RedArrow:SetPoint('BOTTOM', auras.__owner, 'TOP', 0, 15)
	end
end

local CustomFilter = function(icons, unit, data)
	if data.sourceUnit == "player" then -- show all my auras
		return true
	elseif UnitIsFriend("player", unit) and (not aCoreCDB["UnitframeOptions"]["AuraFilterignoreBuff"] or data.isHarmful) then
		return true
	elseif not UnitIsFriend("player", unit) and (not aCoreCDB["UnitframeOptions"]["AuraFilterignoreDebuff"] or data.isHelpful) then
		return true
	elseif aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][data.spellId] then
		return true
	end
end

local BossAuraFilter = function(icons, unit, data)
	if data.sourceUnit == "player" or data.isHelpful then -- show buff and my auras
		return true
	elseif whitelist[tostring(data.spellId)] then
		return true
	end
end

blacklist ={
	["36032"] = true, -- Arcane Charge
	["134122"] = true, --Blue Beam
	["134123"] = true, --Red Beam
	["134124"] = true, --Yellow Beam
	["124275"] = true, --轻度醉拳
	["124274"] = true, --中度醉拳
	["124273"] = true, --重度醉拳
	--["80354"] = true, --时空错位
	--["124273"] = true, --心满意足
}

local PlayerDebuffFilter = function(icons, unit, data)
	if blacklist[tostring(data.spellId)] then
		return false
	else
		return true
	end
end

local NamePlate_AuraFilter = function(icons, unit, data)
	if data.sourceUnit == "player" then
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
	
	if multicheck(u, "target", "focus", "boss", "arena", "party", "player", "pet") then
		local Auras = CreateFrame("Frame", nil, self)
		Auras.disableCooldown = true
		Auras.showStealableBuffs = (G.myClass == "MAGE")
		Auras.spacing = 3
		Auras.PostCreateButton = PostCreateIcon
		Auras.PostUpdateButton = PostUpdateIcon

		if unit == "target" or unit == "focus" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.gap = true
			Auras.PostUpdateGapButton = PostUpdateGapButton
			if unit == "target" then
				Auras.FilterAura = CustomFilter
			end
		elseif unit == "player" then		
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.gap = true
			Auras.PostUpdateGapButton = PostUpdateGapButton
			Auras.numDebuffs = 8
			Auras.numBuffs = 0
			Auras.FilterAura = PlayerDebuffFilter
		elseif unit == "pet" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 5)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.gap = true
			Auras.PostUpdateGapButton = PostUpdateGapButton
			Auras.numDebuffs = 5
			Auras.numBuffs = 0
		elseif u == "boss" or u == "arena" then -- boss 1-5
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.gap = true
			Auras.PostUpdateGapButton = PostUpdateGapButton
			Auras.numDebuffs = 6
			Auras.numBuffs = 3
			Auras.FilterAura = BossAuraFilter
		elseif u == "party" or u == "partypet" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = 0
			Auras.numBuffs = 5
			Auras.onlyShowPlayer = true

			local Debuffs = CreateFrame("Frame", nil, self)
			Debuffs:SetPoint("BOTTOMLEFT", self.Power, "BOTTOMRIGHT", 8, -8)
			Debuffs.disableCooldown = true
			Debuffs.spacing = 3
			Debuffs.PostCreateButton = PostCreateIcon
			Debuffs.PostUpdateButton = PostUpdateIcon
			Debuffs.initialAnchor = "TOPLEFT"
			Debuffs["growth-x"] = "RIGHT"
			Debuffs["growth-y"] = "DOWN"
			Debuffs.num = 5
			self.Debuffs = Debuffs
		end
		
		Auras.ApplySettings =  function()			
			Auras:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*2)
			Auras:SetWidth(aCoreCDB["UnitframeOptions"]["width"]-2)		
			Auras.size = aCoreCDB["UnitframeOptions"]["aura_size"]
			
			if unit == "player" then
				Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]+8)
			elseif unit == "pet" then
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["widthpet"]-2)
			elseif u == "boss" then -- boss 1-5
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["widthboss"]-2)
			elseif u == "arena" then
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["widthboss"]-2)
			elseif u == "party" or u == "partypet" then			
				self.Debuffs:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*2)
				self.Debuffs:SetWidth(aCoreCDB["UnitframeOptions"]["widthparty"]-2)				
				self.Debuffs.size = aCoreCDB["UnitframeOptions"]["aura_size"]
			end
			
			-- enable --
			if unit == "player" then
				if aCoreCDB["UnitframeOptions"]["playerdebuffenable"] then
					self.Auras:SetAlpha(1)
				else
					self.Auras:SetAlpha(0)
				end
			end
		end

		self.Auras = Auras
		self.Auras.ApplySettings()
	end	
end
T.CreateAuras = CreateAuras

local CreatePlateAuras = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)		
	auras.disableCooldown = true
	auras.showStealableBuffs = (G.myClass == "MAGE")
	auras.spacing = 3
	auras.initialAnchor = "BOTTOMLEFT"
	auras["growth-x"] = "RIGHT"
	auras["growth-y"] = "UP"
	auras.gap = true
	auras.PostUpdateGapButton = PostUpdateGapButton	
	auras.PostCreateButton = PostCreateIcon
	auras.PostUpdateButton = PostUpdateIcon		
	auras.SetPosition = OverrideAurasSetPosition
	auras.FilterAura = NamePlate_AuraFilter
	auras.disableMouse = true
	
	auras.Callback = function(self, event, unit)	
		if UnitIsUnit(unit, 'player') then
			self:DisableElement("Auras")
		elseif UnitIsPlayer(unit) and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字
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
		auras:SetWidth(aCoreCDB["PlateOptions"]["bar_width"])
		auras.numDebuffs = aCoreCDB["PlateOptions"]["plateauranum"]
		auras.numBuffs = aCoreCDB["PlateOptions"]["plateauranum"]
		auras.size = aCoreCDB["PlateOptions"]["plateaurasize"]
		
		auras:ClearAllPoints()
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			auras:SetPoint("BOTTOM", self.Health.value, "TOP", 0, -5)
		else
			auras:SetPoint("BOTTOM", self, "TOP", 0, aCoreCDB["PlateOptions"]["namefontsize"]+7)
		end
		
		for i, button in pairs(auras) do
			if type(button) == "table" then
				if button.Count then
					button.Count:SetFont(G.numFont, aCoreCDB["PlateOptions"]["numfontsize"], "OUTLINE")
				end
				if button.remaining then
					button.remaining:SetFont(G.numFont, aCoreCDB["PlateOptions"]["numfontsize"], "OUTLINE")
				end
			end
		end
	end
	
	self.Auras = auras
	self.Auras.ApplySettings()
end
--=============================================--
--[[ Class Resource ]]--
--=============================================--

local function GetClassbarSize(self)
	local width, height
	
	if self.style == 'Altz_Nameplates' then
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			width = aCoreCDB["PlateOptions"]["number_cpwidth"]*5
			height = 2
		else
			if aCoreCDB["PlateOptions"]["classresource_pos"] == "target" then
				width = aCoreCDB["PlateOptions"]["bar_width"]*GetCVar("nameplateSelectedScale")
			else
				width = aCoreCDB["PlateOptions"]["bar_width"]
			end
			height = aCoreCDB["PlateOptions"]["bar_height"]/4
		end
	else
		width = aCoreCDB["UnitframeOptions"]["width"]
		height = aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]
	end
	
	return width, height
end

local function CreateClassResources(self)
	if multicheck(G.myClass, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
		local count = 6		
		local bars = CreateFrame("Frame", self:GetName().."SpecOrbs", self)
		
		for i = 1, count do
			bars[i] = T.createStatusbar(bars)
	
			if i == 1 then
				bars[i]:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT", 0, 0)
			else
				bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
			end
	
			bars[i].backdrop = T.createBackdrop(bars[i], 1)
			
			bars[i].value = T.createtext(bars[i], "OVERLAY", 12, "OUTLINE", "CENTER")
			bars[i].value:SetPoint("CENTER", bars[i], "CENTER")
		end
		
		bars.ApplySettings = function()
			local width, height = GetClassbarSize(self)
			
			bars:SetSize(width, height)
			for i = 1, count do
				bars[i]:SetSize((width+2)/count-3, height)
				if G.myClass == "DEATHKNIGHT" then
					if aCoreCDB["UnitframeOptions"]["runecooldown"] then
						bars[i].value:Show()
					else
						bars[i].value:Hide()
					end
					bars[i].value:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["valuefs"], "OUTLINE")
				end
			end
			
			if self.style ~= 'Altz_Nameplates' and G.myClass == "DRUID" and aCoreCDB["UnitframeOptions"]["dpsmana"] then
				bars:SetPoint("BOTTOM", self, "TOP", 0, 8)
			else
				bars:SetPoint("BOTTOM", self, "TOP", 0, 3)
			end
		end
		
		bars.ApplySettings()
		
		if G.myClass == "DEATHKNIGHT" then	
			for i = 1, 6 do
				bars[i]:SetStatusBarColor(.7, .7, 1)
			end
			self.Runes = bars
			self.Runes.PostUpdate = PostUpdateRunes
		elseif G.myClass == "PALADIN" or G.myClass == "MONK" or G.myClass == "WARLOCK" or G.myClass == "MAGE" then
			self.ClassPower = bars
			self.ClassPower.PostUpdate = ClassIconsPostUpdate
		elseif G.myClass == "ROGUE" or G.myClass == "DRUID" then			
			self.ClassPower = bars
			self.ClassPower.Override = CombopointsUpdate
		end
	end
end
	
--=============================================--
--[[ Unit Frames ]]--
--=============================================--
local func = function(self, unit)
	local u = unit:match("[^%d]+")
	
	if u == "boss" then
		T.RaidOnMouseOver(self)
		T.CreateClickSets(self)
	else
		T.OnMouseOver(self)
	end
	
	self:RegisterForClicks"AnyUp"
	self.mouseovers = {}

	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
	self.hl:SetAllPoints()
	self.hl:SetTexture(G.media.barhightlight)
	self.hl:SetVertexColor( 1, 1, 1, .3)
	self.hl:SetBlendMode("ADD")
	
	-- background --
	self.bg = self:CreateTexture(nil, 'BACKGROUND')
    self.bg:SetAllPoints(self)
	
	-- health bar --
	local hp = T.createStatusbar(self)
	hp:SetAllPoints(self)
	hp:SetFrameLevel(self:GetFrameLevel()+2) -- 高于肖像
	hp:SetReverseFill(true)

	hp.backdrop = T.createBackdrop(hp)
	
	hp.cover = hp:CreateTexture(nil, 'OVERLAY')
    hp.cover:SetAllPoints(hp)
	hp.cover:SetTexture(G.media.blank)
	
	if not (unit == "targettarget" or unit == "focustarget" or unit == "pet") then
		hp.value = T.createnumber(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "RIGHT")
	end

	hp.ind = hp:CreateTexture(nil, "OVERLAY", nil, 1)
	hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, 18)
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)

	hp.ApplySettings = function()
		T.ApplyHealthThemeSettings(self, hp)
		
		hp.ind:SetSize(1, aCoreCDB["UnitframeOptions"]["height"])
		
		-- height, width --
		if multicheck(u, "targettarget", "focustarget", "pet") then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthpet"], aCoreCDB["UnitframeOptions"]["height"])
		elseif u == "boss" or u == "arena" then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthboss"], aCoreCDB["UnitframeOptions"]["height"])
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
	hp.PostUpdate = PostUpdate_Health
	tinsert(self.mouseovers, hp)
	
	self.Health = hp	
	self.Health.ApplySettings()	
	
	-- portrait 肖像
	if multicheck(u, "player", "target", "focus", "boss", "arena") then
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

	-- power bar --
	if not (unit == "targettarget" or unit == "focustarget") then
		local pp = T.createStatusbar(self)
		pp:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
		pp:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
		
		pp.backdrop = T.createBackdrop(pp)
		
		pp.bg = pp:CreateTexture(nil, 'BACKGROUND')
		pp.bg:SetAllPoints(pp)
		pp.multiplier = .2
		
		if not multicheck(u, "pet", "boss", "arena") then
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

	-- altpower bar --
	if multicheck(u, "player", "boss", "pet") then
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
		self.AlternativePower.PostUpdate = PostAltUpdate
	end

	-- little thing around unit frames --
	local leader = hp:CreateTexture(nil, "OVERLAY")
	leader:SetSize(12, 12)
	leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.LeaderIndicator = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY")
	assistant:SetSize(12, 12)
	assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.AssistantIndicator = assistant

	local masterlooter = hp:CreateTexture(nil, "OVERLAY")
	masterlooter:SetSize(12, 12)
	masterlooter:SetPoint("LEFT", leader, "RIGHT")
	self.MasterLooterIndicator = masterlooter

	local ricon = hp:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("CENTER", hp, "CENTER", 0, 0)
	ricon:SetSize(40, 40)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
	self.RaidTargetIndicator = ricon

	-- name --
	if unit ~= "player" and unit ~= "pet" then
		local name = T.createtext(hp, "OVERLAY", 13, "OUTLINE", "LEFT")
		name:SetPoint("TOPLEFT", hp, "TOPLEFT", 3, 9)
		
		if multicheck(u, "targettarget", "focustarget", "boss", "arena") then
			self:Tag(name, "[Altz:shortname]")
		else
			self:Tag(name, "[Altz:longname]")
		end
	end
	
	CreateCastbars(self, unit)
	CreateSwingTimer(self, unit)
	CreateAuras(self, unit)
	
	-- fade --
	if multicheck(unit, "target", "player", "focus", "pet", "targettarget") then
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
		if multicheck(G.myClass, "SHAMAN", "PRIEST", "DRUID") then
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
		local Resting = self.Health:CreateTexture(nil, 'OVERLAY')
		Resting:SetSize(18, 18)
		Resting:SetTexture(G.media.reseting)
		Resting:SetDesaturated(true)
		Resting:SetVertexColor( 0, 1, 0)
		Resting:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		self.RestingIndicator = Resting

		-- Combat
		local Combat = self.Health:CreateTexture(nil, "OVERLAY")
		Combat:SetSize(18, 18)
		Combat:SetTexture(G.media.combat)
		Combat:SetDesaturated(true)
		Combat:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		Combat:SetVertexColor( 1, 1, 0)
		self.CombatIndicator = Combat
		self.CombatIndicator.PostUpdate = CombatPostUpdate

		-- PvP
		local PvP = self:CreateTexture(nil, 'OVERLAY')
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
		
		-- threat bar --	
		local threatbar = T.createStatusbar(UIParent, nil, nil, 0.25, 0.25, 0.25, 1)
		threatbar:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -3)
		threatbar:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 0, -5)
		
		threatbar.backdrop = T.createBackdrop(threatbar, 1)

		threatbar.EnableSettings = function(object)
			if not object or object == self then
				if aCoreCDB["UnitframeOptions"]["showthreatbar"] then
					self:EnableElement("ThreatBar")
					self.ThreatBar:ForceUpdate()
				else
					self:DisableElement("ThreatBar")
				end
			end
		end
		oUF:RegisterInitCallback(threatbar.EnableSettings)
		
		self.ThreatBar = threatbar
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

		if not self.prepFrame then
			self.prepFrame = CreateFrame("Frame", self:GetName().."PrepFrame", UIParent)
			self.prepFrame:SetFrameStrata("BACKGROUND")
			self.prepFrame:SetAllPoints(self)
			
			self.prepFrame.Health = T.createStatusbar(self.prepFrame, nil, nil, 1, 1, 1, 1)
			self.prepFrame.Health:SetAllPoints(self.prepFrame)
			self.prepFrame.Health.backdrop = T.createBackdrop(self.prepFrame.Health, nil)

			self.prepFrame.Icon = self.prepFrame:CreateTexture(nil, "OVERLAY")
			self.prepFrame.Icon:SetPoint("LEFT", self.prepFrame, "RIGHT", 5, 0)
			self.prepFrame.Icon:SetTexCoord(.08, .92, .08, .92)
			self.prepFrame.Icon.backdrop = T.createBackdrop(self.prepFrame.Icon, nil, nil, self.prepFrame)

			self.prepFrame.SpecClass = T.createtext(self.prepFrame.Health, "OVERLAY", 13, "OUTLINE", "CENTER")
			self.prepFrame.SpecClass:SetPoint("CENTER")
		end

		local specIcon = CreateFrame("Frame", nil, self)
		specIcon:SetPoint("LEFT", self, "RIGHT", 5, 0)
		specIcon.backdrop = T.createBackdrop(specIcon)
		self.PVPSpecIcon = specIcon

		local trinkets = CreateFrame("Frame", nil, self)
		trinkets:SetPoint("LEFT", specIcon, "RIGHT", 5, 0)
		trinkets.backdrop = T.createBackdrop(trinkets)
		trinkets.trinketUseAnnounce = true
		trinkets.trinketUpAnnounce = true
		self.Trinket = trinkets
		
		local PvPClassificationIndicator = self:CreateTexture(nil, 'OVERLAY')
		PvPClassificationIndicator:SetSize(24, 24)
		PvPClassificationIndicator:SetPoint('CENTER')
		self.PvPClassificationIndicator = PvPClassificationIndicator
		
		self.PVPSpecIcon.ApplySettings = function()
			self.prepFrame.Icon:SetSize(aCoreCDB["UnitframeOptions"]["height"], aCoreCDB["UnitframeOptions"]["height"])
			self.PVPSpecIcon:SetSize(aCoreCDB["UnitframeOptions"]["height"], aCoreCDB["UnitframeOptions"]["height"])
			self.Trinket:SetSize(aCoreCDB["UnitframeOptions"]["height"], aCoreCDB["UnitframeOptions"]["height"])
		end
		self.PVPSpecIcon.ApplySettings()
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
	
	-- health bar --
	local hp = T.createStatusbar(self)
	hp:SetAllPoints(self)

	hp.backdrop = T.createBackdrop(hp, nil, 2)

	hp.value = T.createtext(hp, "OVERLAY", 10, "OUTLINE", "CENTER")
	
	hp.ind = hp:CreateTexture(nil, "OVERLAY", nil, 1)
	hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, hp:GetHeight())
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
			
	hp.Callback = function(self, event, unit)
		if UnitIsUnit(unit, 'player') then
			if aCoreCDB["PlateOptions"]["playerplate"] then
				self:EnableElement("Health")	
				self.Health:ForceUpdate()			
			else
				self:DisableElement("Health")
			end
		elseif UnitIsPlayer(unit) and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字
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
			hp.ind:Hide()
			
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
			
			hp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["valuefontsize"], "OUTLINE")			
			hp.value:ClearAllPoints()
			hp.value:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", -5, -3)
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
			
			hp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["valuefontsize"], "OUTLINE")
			hp.value:ClearAllPoints()			
			hp.value:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", -5, -3)
			hp.value:SetJustifyH("RIGHT")
			
			hp:SetReverseFill(false)
			hp.colorClass = true
			hp.colorReaction = true
			hp.colorSmooth = false
		end
		
		if aCoreCDB["PlateOptions"]["threatcolor"] then
			hp.colorThreat = true
		end
	end
	
	hp.UpdateColor = Override_PlateHealthColor
	hp.PostUpdate = PostUpdate_PlateHealth
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
	pp.multiplier = .2
		
	pp.value = T.createnumber(pp, "OVERLAY", 10, "OUTLINE", "LEFT")
	
	pp.Callback = function(self, event, unit)		
		local name = UnitName(unit)
		if aCoreCDB["PlateOptions"]["custompowerplates"][name] or UnitIsUnit(unit, "player") then	
			self:EnableElement('Power')
			self.Power:ForceUpdate()
		else
			self:DisableElement('Power')
		end		
	end
	RegisterNameplateEventCallback(pp.Callback)
	
	pp.ApplySettings = function()
		pp:SetHeight(aCoreCDB["PlateOptions"]["bar_height"]/4)
		
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			pp:GetStatusBarTexture():SetAlpha(0)
			pp.backdrop:Hide()
			
			pp.value:SetFont(G.plateFont, aCoreCDB["PlateOptions"]["number_size"]/2, "OUTLINE")
			pp.value:ClearAllPoints()
			pp.value:SetPoint("BOTTOMLEFT", hp.value, "BOTTOMRIGHT")
		else
			pp:GetStatusBarTexture():SetAlpha(1)
			pp:SetStatusBarTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
			pp.bg:SetTexture(aCoreCDB["SkinOptions"]["style"] == 1 and G.media.blank or G.media.ufbar)
			pp.backdrop:Show()
			
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
	
	-- 施法条、光环、连击点/个人资源
	CreatePlateCastbar(self, unit)
	CreatePlateAuras(self, unit)
	CreateClassResources(self)
	
	-- 团队标记
	local ricon = self:CreateTexture(nil, "OVERLAY")
	ricon:SetSize(20, 20)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
	
	ricon.ApplySettings = function()	
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			ricon:ClearAllPoints()
			ricon:SetPoint("RIGHT", self, "LEFT")
		else
			ricon:ClearAllPoints()
			ricon:SetPoint("LEFT", self, "TOPLEFT", 5, 0)
		end
	end
	
	ricon.PostUpdate = RaidTargetIconPostUpdate
	
	self.RaidTargetIndicator = ricon
	ricon.ApplySettings()
	
	-- 名字
	local name = T.createtext(self, "OVERLAY", 8, "OUTLINE", "CENTER")
	
	name.ApplySettings = function()
		name:SetFont(G.norFont, aCoreCDB["PlateOptions"]["namefontsize"], "OUTLINE")
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			name:ClearAllPoints()
			name:SetPoint("TOP", self, "BOTTOM")
		else
			name:ClearAllPoints()
			name:SetPoint("TOPLEFT", self, "TOPLEFT", 5, aCoreCDB["PlateOptions"]["namefontsize"])
			name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -5, 5)
		end
	end
	
	self:Tag(name, "[Altz:platename]")
	self.Tag_Name = name
	name.ApplySettings()
	
	-- PVP标记
	local PvP = self:CreateTexture(nil, 'OVERLAY')
	PvP:SetSize(12, 12)
	
	PvP.ApplySettings = function()
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			PvP:ClearAllPoints()
			PvP:SetPoint("LEFT", name, "RIGHT")
		else
			PvP:ClearAllPoints()
			PvP:SetPoint("LEFT", self, "RIGHT", -8, 2)
		end
	end
	
	self.PvPClassificationIndicator = PvP
	PvP.ApplySettings()
	
	-- target RedArrow --
	local RedArrow = self:CreateTexture(nil, 'OVERLAY')
	RedArrow:SetTexture([[Interface\AddOns\AltzUI\media\NeonRedArrow]])
    RedArrow:SetSize(50, 40)
    RedArrow:SetPoint('BOTTOM', self, 'TOP', 0, 15)
	RedArrow:Hide()
	
	self.RedArrow = RedArrow
	
	self:RegisterEvent("PLAYER_TARGET_CHANGED", TargetRedArrowupdate, true)
	self:RegisterEvent("UNIT_AURA", TargetRedArrowupdate, true)
end

local function PlacePlateClassSource()
	if multicheck(G.myClass, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
		if aCoreCDB["PlateOptions"]["classresource_show"] and aCoreCDB["PlateOptions"]["classresource_pos"] == "target" then -- 个人资源
			local playerPlate = C_NamePlate.GetNamePlateForUnit("player")
			if playerPlate and playerPlate.unitFrame then
				if G.myClass == "DEATHKNIGHT" then
					playerPlate.unitFrame.Runes:ClearAllPoints()
					playerPlate.unitFrame.Runes:Hide()
				else
					playerPlate.unitFrame.ClassPower:ClearAllPoints()
					playerPlate.unitFrame.ClassPower:Hide()
				end
				local targetPlate = C_NamePlate.GetNamePlateForUnit("target")	
				if targetPlate and targetPlate.unitFrame and not UnitIsUnit("player", "target") then
					if G.myClass == "DEATHKNIGHT" then
						if aCoreCDB["PlateOptions"]["theme"] == "number" then
							playerPlate.unitFrame.Runes:SetPoint("BOTTOM", targetPlate.unitFrame.Health.value, "TOP", 0, 0)
						else
							playerPlate.unitFrame.Runes:SetPoint("BOTTOM", targetPlate.unitFrame, "TOP", 0, 3)
						end
						playerPlate.unitFrame.Runes:Show()
					else
						if aCoreCDB["PlateOptions"]["theme"] == "number" then
							playerPlate.unitFrame.ClassPower:SetPoint("BOTTOM", targetPlate.unitFrame.Health.value, "TOP", 0, 0)
						else
							playerPlate.unitFrame.ClassPower:SetPoint("BOTTOM", targetPlate.unitFrame, "TOP", 0, 3)
						end
						playerPlate.unitFrame.ClassPower:Show()
					end
				end		
			end
		end
	end
end
T.PlacePlateClassSource = PlacePlateClassSource

local function PostUpdatePlate(self, event, unit)
	if not self then return end
	
	if event == "NAME_PLATE_UNIT_ADDED" then
		for _, func in pairs(nameplate_callbacks) do
			func(self, event, unit)
		end
		
		if G.myClass == "DEATHKNIGHT" and UnitIsUnit(unit, 'player') then
			if aCoreCDB["PlateOptions"]["classresource_show"] then -- 个人资源
				self:EnableElement('Runes')
				PlacePlateClassSource()
				self.Runes:ForceUpdate()
				self.Runes:Show()
			else
				self:DisableElement('Runes')
				self.Runes:Hide()
			end
		end
		
		if multicheck(G.myClass, "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
			if UnitIsUnit(unit, 'player') and aCoreCDB["PlateOptions"]["classresource_show"] then -- 个人资源
				self:EnableElement('ClassPower')
				PlacePlateClassSource()
				self.ClassPower:ForceUpdate()
				self.ClassPower:Show()
			else
				self:DisableElement('ClassPower')
				self.ClassPower:Hide()
			end
		end
	end
end
T.PostUpdatePlate = PostUpdatePlate

local function PostUpdateAllPlates()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.style == "Altz_Nameplates" and obj.unit then
			PostUpdatePlate(obj, "NAME_PLATE_UNIT_ADDED", obj.unit)
		end
	end
end
T.PostUpdateAllPlates = PostUpdateAllPlates

local PlacePlateTargetElementEventFrame = CreateFrame("Frame", nil, UIParent)
PlacePlateTargetElementEventFrame:SetScript("OnEvent", PlacePlateClassSource)
PlacePlateTargetElementEventFrame:RegisterEvent('PLAYER_TARGET_CHANGED')

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
	T.ColorPicker_OnClick(aCoreCDB["PlateOptions"]["customcoloredplates"][name], nil, nil, PostUpdateAllPlates)
end

local function RemovefromCColor(name)
	aCoreCDB["PlateOptions"]["customcoloredplates"][name] = nil	
	PostUpdateAllPlates()
end

local menuFrame = CreateFrame("Frame", "NDui_EastMarking", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{text = RAID_TARGET_NONE, func = function() SetRaidTarget("target", 0) end},
	{text = T.hex_str(RAID_TARGET_1, 1, .92, 0).." "..ICON_LIST[1].."12|t", func = function() SetRaidTarget("target", 1) end},
	{text = T.hex_str(RAID_TARGET_2, .98, .57, 0).." "..ICON_LIST[2].."12|t", func = function() SetRaidTarget("target", 2) end},
	{text = T.hex_str(RAID_TARGET_3, .83, .22, .9).." "..ICON_LIST[3].."12|t", func = function() SetRaidTarget("target", 3) end},
	{text = T.hex_str(RAID_TARGET_4, .04, .95, 0).." "..ICON_LIST[4].."12|t", func = function() SetRaidTarget("target", 4) end},
	{text = T.hex_str(RAID_TARGET_5, .7, .82, .875).." "..ICON_LIST[5].."12|t", func = function() SetRaidTarget("target", 5) end},
	{text = T.hex_str(RAID_TARGET_6, 0, .71, 1).." "..ICON_LIST[6].."12|t", func = function() SetRaidTarget("target", 6) end},
	{text = T.hex_str(RAID_TARGET_7, 1, .24, .168).." "..ICON_LIST[7].."12|t", func = function() SetRaidTarget("target", 7) end},
	{text = T.hex_str(RAID_TARGET_8, .98, .98, .98).." "..ICON_LIST[8].."12|t", func = function() SetRaidTarget("target", 8) end},
	{text = ""}, -- 10
	{text = L["添加自定义能量"]},
	{text = L["添加自定义颜色"]},
	{text = L["添加自定义颜色"]},
}

local function HookNameplateCtrlMenu()
	WorldFrame:HookScript("OnMouseDown", function(_, btn)
		C_Timer.After(0.3, function()
			if btn == "LeftButton" and IsControlKeyDown() and UnitExists("target") then
				if not IsInGroup() or (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
					local ricon = GetRaidTargetIndex("target")
					for i = 1, 8 do
						if ricon == i then
							menuList[i+1].checked = true
						else
							menuList[i+1].checked = false
						end
					end
					local target_name = GetUnitName("target", false)
					
					if aCoreCDB["PlateOptions"]["custompowerplates"][target_name] then -- 已经有了
						menuList[11].text = string.format(L["移除自定义能量"], target_name)
						menuList[11].func = function() RemovefromCPower(target_name) end
					else
						menuList[11].text = string.format(L["添加自定义能量"], target_name)
						menuList[11].func = function() AddtoCPower(target_name) end
					end

					if aCoreCDB["PlateOptions"]["customcoloredplates"][target_name] then -- 已经有了
						local r, g, b = aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].r, aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].g, aCoreCDB["PlateOptions"]["customcoloredplates"][target_name].b
						menuList[12].text = string.format(L["替换自定义颜色"], r*255, g*255, b*255, target_name)
						menuList[12].func = function() SetCColor(target_name) end
						
						menuList[13].text = string.format(L["移除自定义颜色"], r*255, g*255, b*255, target_name)
						menuList[13].func = function() RemovefromCColor(target_name) end		
					else
						menuList[12].text = string.format(L["添加自定义颜色"], target_name)
						menuList[12].func = function() SetCColor(target_name) end
						
						menuList[13] = {}
					end
					
					EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
				end
			end
		end)
	end)
end
--=============================================--
--[[ Init ]]--
--=============================================--
local EventFrame = CreateFrame("Frame", nil, UIParent)
RegisterStateDriver(EventFrame, "visibility", "[petbattle] hide; show")

oUF:RegisterStyle("Altz", func)
for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle("Altz - " .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle("Altz - " .. unit:gsub("^%l", string.upper))
	elseif(UnitSpecific[unit:match("[^%d]+")]) then -- boss1 -> boss
		self:SetActiveStyle("Altz - " .. unit:match("[^%d]+"):gsub("^%l", string.upper))
	else
		self:SetActiveStyle"Altz"
	end

	local object = self:Spawn(unit)
	object:SetParent(EventFrame)
	return object
end

T.RegisterInitCallback(function()
	oUF:Factory(function(self)
		local playerframe = spawnHelper(self, "player")
		playerframe.movingname = T.split_words(PLAYER,L["单位框架"])
		playerframe.point = {
			healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "BOTTOM", x = -250, y = 350},
			dpser = {a1 = "TOP", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 280},
		}
		T.CreateDragFrame(playerframe)

		local petframe = spawnHelper(self, "pet")
		petframe.movingname = T.split_words(PET,L["单位框架"])
		petframe.point = {
			healer = {a1 = "RIGHT", parent = playerframe:GetName(), a2 = "LEFT", x = -10, y = 0},
			dpser = {a1 = "RIGHT", parent = playerframe:GetName(), a2 = "LEFT", x = -10, y = 0},
		}
		T.CreateDragFrame(petframe)

		local targetframe = spawnHelper(self, "target")
		targetframe.movingname = T.split_words(TARGET,L["单位框架"])
		targetframe.point = {
			healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "BOTTOM", x = 250, y = 350},
			dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "BOTTOM", x = 150, y = 350},
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
		focusframe.movingname = T.split_words(FOCUS,L["单位框架"])
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

		local bossframes = {}
		if aCoreCDB["UnitframeOptions"]["bossframes"] then
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
		end

		local arenaframes = {}
		if aCoreCDB["UnitframeOptions"]["arenaframes"] then
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
		end
		
		if aCoreCDB["PlateOptions"]["enableplate"] then
			oUF:RegisterStyle("Altz_Nameplates", plate_func)
			oUF:SetActiveStyle("Altz_Nameplates")
			oUF:SpawnNamePlates("Altz_Nameplates", PostUpdatePlate)			
		end
	end)

	if aCoreCDB["PlateOptions"]["playerplate"] or aCoreCDB["PlateOptions"]["classresource_show"] then
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
	
	EventFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	EventFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
	EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	
end)

EventFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

function EventFrame:ARENA_OPPONENT_UPDATE()
	for i=1, 5 do
		if not _G["oUF_AltzArena"..i] then return end
		_G["oUF_AltzArena"..i].prepFrame:Hide()
	end
end

function EventFrame:ARENA_PREP_OPPONENT_SPECIALIZATIONS()
	UpdatePrep()
end

function EventFrame:PLAYER_ENTERING_WORLD()
	UpdatePrep()
end

PetCastingBarFrame:Hide()
PetCastingBarFrame:UnregisterAllEvents()

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

