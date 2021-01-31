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

oUF.colors.smooth = {1,0,0, 1,1,0, 1,1,0}
oUF.colors.np_smooth = {1,0,0, 1,1,0, 1,1,1}

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

local plate_c = {
	color_unit = {},
	power_unit = {},
}

-- 姓名板自定义颜色
local function UpdateNameplateColors(refresh)
	plate_c.color_unit = {}
	for _, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
		if info.name ~= L["空"] then
			plate_c.color_unit[info.name] = {
				r = info.color.r,
				g = info.color.g, 
				b = info.color.b,
			}
		end
	end
	if refresh then
		for i, plate in ipairs(C_NamePlate.GetNamePlates(issecure())) do
			if plate.unitFrame then
				plate.unitFrame.Health:ForceUpdate()
			end
		end
	end
end

-- 姓名板自定义能量
local function UpdateNameplatePowerbars(refresh)
	plate_c.power_unit = {}
	for _, info in pairs(aCoreCDB["PlateOptions"]["custompowerplates"]) do
		if info.name ~= L["空"] then
			plate_c.power_unit[info.name] = true
		end
	end
	if refresh then
		for i, plate in ipairs(C_NamePlate.GetNamePlates(issecure())) do
			if plate.unitFrame then
				local unit = plate.unitFrame.unit
				if plate_c.power_unit[UnitName(unit)] then		
					plate.unitFrame:EnableElement('Power')
					plate.unitFrame.Power:ForceUpdate()
					plate.unitFrame.Power:Show()
				else
					plate.unitFrame:DisableElement('Power')
					plate.unitFrame.Power:Hide()
				end
			end
		end
	end
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

T.Overridehealthbar = function(self, event, unit)
	if(self.unit ~= unit) then return end

	local health = self.Health
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)

	health:SetMinMaxValues(0, max)

	if disconnected then
		health:SetValue(max)
	else
		health:SetValue(max - min)
	end

	local r, g, b, r1, b1, g1
	local perc

	if max ~= 0 then perc = min/max else perc = 1 end

	if health.value then
		if min > 0 and min < max then
			health.value:SetText(T.ShortValue(min).." "..T.hex(1, 1, 0)..math.floor(min/max*100+.5).."|r")
		elseif min > 0 and health.__owner.isMouseOver and UnitIsConnected(unit) then
			health.value:SetText(T.ShortValue(min))
		elseif aCoreCDB["UnitframeOptions"]["alwayshp"] then
			health.value:SetText(T.ShortValue(min))
		else
			health.value:SetText(nil)
		end
	end

	if min > 0 and min < max then
		health.ind:Show()
	else
		health.ind:Hide()
	end

	if not UnitIsConnected(unit) then
		r, g, b = .3, .3, .3
	elseif UnitIsGhost(unit) then
		r, g, b = .6, .6, .6
	elseif UnitIsDead(unit) then
		r, g, b = 1, 0, 0
	elseif (unit == "pet") then
		local _, playerclass = UnitClass("player")
		r, g, b = oUF:RGBColorGradient(perc, 1, unpack(oUF.colors.smooth))
		r1, g1, b1 = unpack(oUF.colors.class[playerclass])
	elseif(UnitIsPlayer(unit)) then
		local _, unitclass = UnitClass(unit)			
		r, g, b = oUF:RGBColorGradient(perc, 1, unpack(oUF.colors.smooth))
		if unitclass then r1, g1, b1 = unpack(oUF.colors.class[unitclass]) else r1, g1, b1 =  1, 1, 1 end
	elseif unit then
		r, g, b = oUF:RGBColorGradient(perc, 1, unpack(oUF.colors.smooth))
		r1, g1, b1 = unpack(oUF.colors.reaction[UnitReaction(unit, "player") or 5])
	end

	if aCoreCDB["UnitframeOptions"]["style"] == 1 then
		health:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/3, g/3, b/3)
	elseif aCoreCDB["UnitframeOptions"]["style"] == 2 then
		health:SetStatusBarColor(r, g, b)
	else
		health:SetStatusBarColor(0, 0, 0)
	end
	
	if aCoreCDB["UnitframeOptions"]["style"] == 3 then
		self.bg.tex:SetVertexColor(r1, g1, b1)
	else
		self.bg.tex:SetVertexColor(0, 0, 0)
	end
end

T.Updatehealthbar = function(self, unit, min, max)
	local r, g, b, r1, g1, b1, r2, g2, b2
	local perc

	if max ~= 0 then perc = min/max else perc = 1 end

	if self.value then
		if self.plate_element then -- 姓名板
			if min > 0 and min < max then
				if aCoreCDB["PlateOptions"]["theme"] == "number" then
					self.value:SetText(math.floor(min/max*100+.5))
				elseif aCoreCDB["PlateOptions"]["bar_hp_perc"] == "perc" then
					self.value:SetText(T.hex(1, 1, 0)..math.floor(min/max*100+.5).."|r")
				else
					self.value:SetText(T.ShortValue(min).." "..T.hex(1, 1, 0)..math.floor(min/max*100+.5).."|r")
				end
			elseif aCoreCDB["PlateOptions"]["theme"] ~= "number" and min > 0 and self.__owner.isMouseOver and UnitIsConnected(unit) then
				self.value:SetText(T.ShortValue(min))
			elseif aCoreCDB["PlateOptions"]["theme"] ~= "number" and aCoreCDB["PlateOptions"]["bar_alwayshp"] then
				self.value:SetText(T.ShortValue(min))
			elseif aCoreCDB["PlateOptions"]["theme"] == "number" and aCoreCDB["PlateOptions"]["number_alwayshp"] then
				self.value:SetText(math.floor(min/max*100+.5))
			else
				self.value:SetText(nil)
			end
		else -- 其他框架
			if min > 0 and min < max then
				self.value:SetText(T.ShortValue(min).." "..T.hex(1, 1, 0)..math.floor(min/max*100+.5).."|r")
			elseif min > 0 and self.__owner.isMouseOver and UnitIsConnected(unit) then
				self.value:SetText(T.ShortValue(min))
			elseif aCoreCDB["UnitframeOptions"]["alwayshp"] then
				self.value:SetText(T.ShortValue(min))
			else
				self.value:SetText(nil)
			end
		end
	end
	
	if not self.plate_element or aCoreCDB["PlateOptions"]["theme"] ~= "number" then
		if min > 0 and min < max then
			self.ind:Show()
		else
			self.ind:Hide()
		end
	end
	
	local name = GetUnitName(unit, false)
	if self.plate_element then -- 姓名板	
		if aCoreCDB["PlateOptions"]["focuscolored"] and UnitIsUnit(unit, "focus") then -- 焦点颜色
			r, g, b = aCoreCDB["PlateOptions"]["focus_color"].r, aCoreCDB["PlateOptions"]["focus_color"].g, aCoreCDB["PlateOptions"]["focus_color"].b
			r1, g1, b1 = r, g, b
		elseif plate_c.color_unit[name] then -- 自定义颜色
			r, g, b = plate_c.color_unit[name].r, plate_c.color_unit[name].g, plate_c.color_unit[name].b
			r1, g1, b1 = r, g, b
		elseif UnitIsTapDenied(unit) then
			r, g, b = .6, .6, .6
		elseif not UnitIsConnected(unit) then
			r, g, b = .3, .3, .3
		elseif UnitIsGhost(unit) then
			r, g, b = .6, .6, .6
		elseif UnitIsDead(unit) then
			r, g, b = 1, 0, 0
		elseif UnitIsUnit(unit, "pet") then
			local _, playerclass = UnitClass("player")
			r, g, b = unpack(oUF.colors.class[playerclass])
		elseif UnitIsPlayer(unit) then
			local _, unitclass = UnitClass(unit)
			if unitclass then r, g, b = unpack(oUF.colors.class[unitclass]) else r, g, b = 1, 1, 1 end
		elseif aCoreCDB["PlateOptions"]["threatcolor"] then
			local _, threatStatus = UnitDetailedThreatSituation("player", unit)
			if threatStatus == 3 then
				r, g, b = .9, .1, .4
				r1, g1, b1 = r, g, b
			elseif threatStatus == 2 then
				r, g, b = .9, .1, .9
				r1, g1, b1 = r, g, b
			elseif threatStatus == 1 then
				r, g, b = .4, .1, .9
				r1, g1, b1 = r, g, b
			elseif threatStatus == 0 then
				r, g, b = .1, .7, .9
				r1, g1, b1 = r, g, b
			elseif unit then
				r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player") or 5])	
			end
		elseif unit then
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player") or 5])
		end
	else
		if UnitIsTapDenied(unit) then
			r, g, b = .6, .6, .6
		elseif not UnitIsConnected(unit) then
			r, g, b = .3, .3, .3
		elseif UnitIsGhost(unit) then
			r, g, b = .6, .6, .6
		elseif UnitIsDead(unit) then
			r, g, b = 1, 0, 0
		elseif unit == "pet" then
			local _, playerclass = UnitClass("player")
			r, g, b = unpack(oUF.colors.class[playerclass])
		elseif(UnitIsPlayer(unit)) then
			local _, unitclass = UnitClass(unit)
			if unitclass then r, g, b = unpack(oUF.colors.class[unitclass]) else r, g, b = 1, 1, 1 end
		elseif unit then
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, "player") or 5])
		end
	end
	
	if self.plate_element then
		-- 给血条染色
		if aCoreCDB["PlateOptions"]["theme"] == "dark" then
			-- 底层
			r2, g2, b2 = oUF:RGBColorGradient(perc, 1, unpack(oUF.colors.smooth))
			self:GetStatusBarTexture():SetGradient("VERTICAL", r2, g2, b2, r2/3, g2/3, b2/3)
			self:SetValue(max - self:GetValue())
			
			-- 表层
			if r1 then
				self.bg:SetGradientAlpha("VERTICAL", r1*.8, g1*.8, b1*.8, 1, r1, g1, b1, 1)
			else
				self.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
			end
		elseif aCoreCDB["PlateOptions"]["theme"] == "class" then
			self:SetStatusBarColor(r, g, b)
		end
		
		-- 给血量数值染色（数字样式）
		if aCoreCDB["PlateOptions"]["theme"] == "number" and aCoreCDB["PlateOptions"]["number_colorheperc"] then
			self.value:SetTextColor(oUF:RGBColorGradient(perc, 1, unpack(oUF.colors.np_smooth)))
		end
		
		-- 给名字染色
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			self.__owner.Name:SetTextColor(r, g, b)
		elseif aCoreCDB["PlateOptions"]["bar_onlyname"] and UnitIsPlayer(unit) and UnitReaction(unit, 'player') >= 5 then -- 友方只显示名字,给名字染色
			self.__owner.Name:SetTextColor(r, g, b)
		else
			self.__owner.Name:SetTextColor(1, 1, 1)
		end
	else
		r2, g2, b2 = oUF:RGBColorGradient(perc, 1, unpack(oUF.colors.smooth))
		if aCoreCDB["UnitframeOptions"]["style"] == 1 then
			self:GetStatusBarTexture():SetGradient("VERTICAL", r2, g2, b2, r2/3, g2/3, b2/3)
		elseif aCoreCDB["UnitframeOptions"]["style"] == 2 then
			self:SetStatusBarColor(r2, g2, b2)
		else
			self:SetStatusBarColor(0, 0, 0)
		end
		
		if aCoreCDB["UnitframeOptions"]["style"] == 3 then
			self.__owner.bg.tex:SetVertexColor(r, g, b)
		else
			self.__owner.bg.tex:SetVertexColor(0, 0, 0)
		end
		
		self:SetValue(max - min)	
	end	
end

T.Updatepowerbar = function(self, unit, cur, min, max)
	local r, g, b
	local type = select(2, UnitPowerType(unit))
	local powercolor = oUF.colors.power[type] or oUF.colors.power.FUEL

	if self.value then
		if self.__owner.isMouseOver and type == 'MANA' and UnitIsConnected(unit) then
			self.value:SetText(T.hex(unpack(powercolor))..T.ShortValue(cur)..'|r')
		elseif (cur > 0 and cur < max) or aCoreCDB["UnitframeOptions"]["alwayspp"] or self.plate_element then
			if type == 'MANA' then
				self.value:SetText(T.hex(1, 1, 1)..math.floor(cur/max*100+.5)..'|r'..T.hex(1, .4, 1)..'%|r')
			else
				self.value:SetText(T.hex(unpack(powercolor))..T.ShortValue(cur)..'|r')
			end
		else
			self.value:SetText(nil)
		end
	end
	
	if self.plate_element then
		if aCoreCDB["PlateOptions"]["theme"] ~= "dark" then -- 职业、数字
			r, g, b = unpack(powercolor)
		elseif UnitIsPlayer(unit) then -- 深色
			local _, unitclass = UnitClass(unit)
			if unitclass then r, g, b = unpack(oUF.colors.class[unitclass]) else r, g, b = 1, 1, 1 end
		else
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, 'player') or 5])
		end
	else
		if aCoreCDB["UnitframeOptions"]["style"] == 3 then -- 职业
			r, g, b = unpack(powercolor)
		elseif UnitIsPlayer(unit) then -- 深色或透明
			local _, unitclass = UnitClass(unit)
			if unitclass then r, g, b = unpack(oUF.colors.class[unitclass]) else r, g, b = 1, 1, 1 end
		else
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, 'player') or 5])
		end	
	end
	
	if self.plate_element then
		if aCoreCDB["PlateOptions"]["theme"] == "class" then -- 职业
			self:SetStatusBarColor(r, g, b)
		elseif aCoreCDB["PlateOptions"]["theme"] == "dark" then -- 深色
			self:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/3, g/3, b/3)
		end
	else
		if aCoreCDB["UnitframeOptions"]["style"] ~= 1 then
			self:SetStatusBarColor(r, g, b)
		else
			self:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/3, g/3, b/3)
		end
	end
end

local PostAltUpdate = function(altpp, unit, cur, min, max)
	altpp.value:SetText(cur)
end

local CpointsUpdate = function(self, event, unit, powerType)
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
			element[i]:SetWidth((element.width+3)/max-3)
		end
	end
end

local PostUpdateRunes = function(self, rune, rid, start, duration, runeReady)
	if rune.value then
		if runeReady then
			rune.value:SetText("")
		else
			rune:HookScript("OnUpdate", function(self, elapsed)
				local duration = self.duration + elapsed
				if duration >= self.max or duration <= 0 then
					rune.value:SetText("")
				else
					rune.value:SetText(T.FormatTime(self.max - duration))
				end
			end)
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
--[[ Castbars ]]--
--=============================================--
local Interruptible_color = {aCoreCDB["UnitframeOptions"]["Interruptible_color"].r, aCoreCDB["UnitframeOptions"]["Interruptible_color"].g, aCoreCDB["UnitframeOptions"]["Interruptible_color"].b} -- 玩家以及可打断的颜色
local notInterruptible_color = {aCoreCDB["UnitframeOptions"]["notInterruptible_color"].r, aCoreCDB["UnitframeOptions"]["notInterruptible_color"].g, aCoreCDB["UnitframeOptions"]["notInterruptible_color"].b} -- 不可打断的颜色
local tk = {} -- 引导法术的分段竖线颜色

local ChannelSpells = {
	[GetSpellInfo(15407)] = 3, --精神鞭笞
}

local PostCastStart = function(castbar, unit)
	local u = unit:match("[^%d]+")
	if u == "nameplate" then
		if UnitIsUnit(unit, "player") then -- 玩家
			if aCoreCDB["PlateOptions"]["theme"] == "number" then
				castbar:SetStatusBarColor(aCoreCDB["PlateOptions"]["Interruptible_color"].r, aCoreCDB["PlateOptions"]["Interruptible_color"].g, aCoreCDB["PlateOptions"]["Interruptible_color"].b)
			else
				castbar:SetStatusBarColor(0,0,0,0) -- 透明
			end
		else
			-- 染色
			if castbar.notInterruptible then
				castbar:SetStatusBarColor(aCoreCDB["PlateOptions"]["notInterruptible_color"].r, aCoreCDB["PlateOptions"]["notInterruptible_color"].g, aCoreCDB["PlateOptions"]["notInterruptible_color"].b)
			else
				castbar:SetStatusBarColor(aCoreCDB["PlateOptions"]["Interruptible_color"].r, aCoreCDB["PlateOptions"]["Interruptible_color"].g, aCoreCDB["PlateOptions"]["Interruptible_color"].b)
			end
		end
	else
		if unit == "player" then
			if aCoreCDB["UnitframeOptions"]["independentcb"] then
				castbar:SetStatusBarColor(aCoreCDB["UnitframeOptions"]["Interruptible_color"]["r"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["g"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["b"])
			else
				castbar.IBackdrop_1:SetBackdropBorderColor(aCoreCDB["UnitframeOptions"]["Interruptible_color"]["r"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["g"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["b"])			
			end
		else
			if castbar.notInterruptible then
				if aCoreCDB["UnitframeOptions"]["independentcb"] then
					castbar:SetStatusBarColor(aCoreCDB["UnitframeOptions"]["notInterruptible_color"]["r"], aCoreCDB["UnitframeOptions"]["notInterruptible_color"]["g"], aCoreCDB["UnitframeOptions"]["notInterruptible_color"]["b"])
				else
					castbar.IBackdrop_1:SetBackdropBorderColor(aCoreCDB["UnitframeOptions"]["notInterruptible_color"]["r"], aCoreCDB["UnitframeOptions"]["notInterruptible_color"]["g"], aCoreCDB["UnitframeOptions"]["notInterruptible_color"]["b"])
				end
			else
				if aCoreCDB["UnitframeOptions"]["independentcb"] then
					castbar:SetStatusBarColor(aCoreCDB["UnitframeOptions"]["Interruptible_color"]["r"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["g"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["b"])
				else
					castbar.IBackdrop_1:SetBackdropBorderColor(aCoreCDB["UnitframeOptions"]["Interruptible_color"]["r"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["g"], aCoreCDB["UnitframeOptions"]["Interruptible_color"]["b"])
				end
			end
		end
	end
end

local PostChannelStart = function(castbar, unit, spell)
	PostCastStart(castbar, unit)
	
	if aCoreCDB["UnitframeOptions"]["channelticks"] then
		if unit == "player" and ChannelSpells[spell] then
			if #castbar.Ticks ~= 0 then
				for i = 1, #castbar.Ticks do
					castbar.Ticks[i]:Hide()
				end
			end
			castbar.tick = ChannelSpells[spell]
			for i = 1, (castbar.tick-1) do
				if not castbar.Ticks[i] then
					castbar.Ticks[i] = castbar:CreateTexture(nil, "OVERLAY")
					castbar.Ticks[i]:SetColorTexture(tk[1], tk[2], tk[3])
					castbar.Ticks[i]:SetSize(2, aCoreCDB["UnitframeOptions"]["independentcb"] and aCoreCDB["UnitframeOptions"]["cbheight"] or aCoreCDB["UnitframeOptions"]["height"])
				else
					castbar.Ticks[i]:Show()
				end
				castbar.Ticks[i]:SetPoint("RIGHT", castbar, "RIGHT", -(aCoreCDB["UnitframeOptions"]["independentcb"] and aCoreCDB["UnitframeOptions"]["cbwidth"] or aCoreCDB["UnitframeOptions"]["width"])/castbar.tick*i, 0)
			end
			--print("start")
		end
	end
end

local PostChannelUpdate = function(castbar, unit, spell)
	if aCoreCDB["UnitframeOptions"]["channelticks"] then
		if unit == "player" and ChannelSpells[spell] then
			if #castbar.Ticks ~= 0 then
				for i = 1, #castbar.Ticks do
					castbar.Ticks[i]:Hide()
				end
			end
			castbar.tick = ChannelSpells[spell] + 1
			for i = 1, (castbar.tick-1) do
				if not castbar.Ticks[i] then
					castbar.Ticks[i] = castbar:CreateTexture(nil, "OVERLAY")
					castbar.Ticks[i]:SetColorTexture(tk[1], tk[2], tk[3])
					castbar.Ticks[i]:SetSize(2, aCoreCDB["UnitframeOptions"]["independentcb"] and aCoreCDB["UnitframeOptions"]["cbheight"] or aCoreCDB["UnitframeOptions"]["height"])
				else
					castbar.Ticks[i]:Show()
				end
				if i == 1 then
					castbar.Ticks[i]:SetPoint("RIGHT", castbar, "RIGHT", (aCoreCDB["UnitframeOptions"]["independentcb"] and aCoreCDB["UnitframeOptions"]["cbwidth"] or aCoreCDB["UnitframeOptions"]["width"])*castbar.delay/castbar.max, 0)
				else
					castbar.Ticks[i]:SetPoint("RIGHT", castbar, "RIGHT", (aCoreCDB["UnitframeOptions"]["independentcb"] and aCoreCDB["UnitframeOptions"]["cbwidth"] or aCoreCDB["UnitframeOptions"]["width"])*(castbar.delay/castbar.max-(1+castbar.delay/castbar.max)/(castbar.tick-1)*(i-1)), 0)
				end
			end
			--print("update")
		end
	end
end

local PostChannelStop = function(castbar, unit, spell)
	if aCoreCDB["UnitframeOptions"]["channelticks"] then
		if unit == "player" then
			if #castbar.Ticks ~= 0 then
				for i = 1, #castbar.Ticks do
					castbar.Ticks[i]:Hide()
				end
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
	if multicheck(u, "target", "player", "focus", "boss", "nameplate") then
		local cb = CreateFrame("StatusBar", G.uiname..unit.."Castbar", self)
		if u == "nameplate" then
			if aCoreCDB["PlateOptions"]["theme"] == "number" then
				cb:SetStatusBarTexture(G.media.iconcastbar)
				cb:SetSize(25, 25)
				cb:SetPoint("TOP", self, "BOTTOM", 0, -aCoreCDB["PlateOptions"]["fontsize"]-3)
			else
				cb:SetStatusBarTexture(G.media.ufbar)
				cb:SetSize(aCoreCDB["PlateOptions"]["bar_width"], aCoreCDB["PlateOptions"]["bar_height"]/3)
			end
		else
			cb:SetStatusBarTexture(G.media.blank)
			cb:SetFrameLevel(2)
			cb:SetStatusBarColor(0, 0, 0, 0)
		end
		
		cb.bd = T.createBackdrop(cb, cb, 1)
		
		-- 光标
		cb.Spark = cb:CreateTexture(nil, "OVERLAY")
		cb.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		cb.Spark:SetBlendMode("ADD")
		cb.Spark:SetAlpha(1)
		cb.Spark:SetPoint('CENTER', cb:GetStatusBarTexture(), 'RIGHT', 0, 0)
		
		-- 时间
		if u ~= "nameplate" then
			cb.Time = T.createnumber(cb, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "CENTER")	
			cb.CustomTimeText = CustomTimeText
			cb.CustomDelayText = CustomDelayText
		end
		
		-- 法术名字
		cb.Text = T.createtext(cb, "OVERLAY", u == "nameplate" and 8 or 14, "OUTLINE", "CENTER")
		
		-- 图标
		cb.Icon = cb:CreateTexture(nil, "OVERLAY", 3)
		cb.Icon:SetTexCoord(.1, .9, .1, .9)
		cb.IBackdrop_1 = T.createBackdrop(cb, cb.Icon, 1)
		cb.IBackdrop_2 = cb:CreateTexture(nil, "ARTWORK", 3)
		cb.IBackdrop_2:SetPoint("TOPLEFT", cb.Icon, "TOPLEFT", -1, 1)
		cb.IBackdrop_2:SetPoint("BOTTOMRIGHT", cb.Icon, "BOTTOMRIGHT", 1, -1)
		cb.IBackdrop_2:SetVertexColor(0, 0, 0)
		cb.IBackdrop_2:SetTexture(G.media.blank)
			
		-- 独立施法条
		if multicheck(u, "target", "player", "focus") then	
			if unit == "player" then
				cb.SafeZone = cb:CreateTexture(nil, "OVERLAY")
				cb.SafeZone:SetTexture(G.media.blank)
				cb.SafeZone:SetVertexColor( 1, 1, 1, .5)
				
				cb.movingname = L["玩家施法条"]
				cb.point = {
					healer = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -150},
					dpser = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -150},
				}
			elseif unit == "target" then	
				cb.movingname = L["目标施法条"]
				cb.point = {
					healer = {a1 = "TOPLEFT", parent = "oUF_AltzTarget", a2 = "BOTTOMLEFT", x = 0, y = -10},
					dpser = {a1 = "TOPLEFT", parent = "oUF_AltzTarget", a2 = "BOTTOMLEFT", x = 0, y = -10},
				}
			elseif unit == "focus" then	
				cb.movingname = L["焦点施法条"]
				cb.point = {
					healer = {a1 = "TOPLEFT", parent = "oUF_AltzFocus", a2 = "BOTTOMLEFT", x = 0, y = -10},
					dpser = {a1 = "TOPLEFT", parent = "oUF_AltzFocus", a2 = "BOTTOMLEFT", x = 0, y = -10},
				}
			end

			T.CreateDragFrame(cb)
		end

		cb.Ticks = {}
		cb.PostCastStart = PostCastStart
		cb.PostChannelStart = PostChannelStart
		cb.PostChannelUpdate = PostChannelUpdate
		cb.PostChannelStop = PostChannelStop
		cb.ApplySettings = function()
			if u == "nameplate" then
				if aCoreCDB["PlateOptions"]["theme"] == "number" then
					cb:SetStatusBarTexture(G.media.iconcastbar)
					cb:SetSize(25, 25)
					
					cb.Spark:SetSize(8, 35)
					
					cb.Icon:SetSize(20, 20)
					cb.Icon:ClearAllPoints()
					cb.Icon:SetPoint("CENTER", cb, "CENTER")
					
					cb.IBackdrop_1:Hide()
					cb.IBackdrop_2:Show()
				else
					cb:SetStatusBarTexture(G.media.ufbar)
					cb:SetSize(aCoreCDB["PlateOptions"]["bar_width"], aCoreCDB["PlateOptions"]["bar_height"]/3)
					
					cb.Spark:SetSize(8, aCoreCDB["PlateOptions"]["bar_height"]*2)
					
					cb.Icon:SetSize(aCoreCDB["PlateOptions"]["bar_height"]*1.5+6, aCoreCDB["PlateOptions"]["bar_height"]*1.5+6)
					cb.Icon:ClearAllPoints()
					cb.Icon:SetPoint("RIGHT", self, "LEFT", -5, 0)
					
					cb.IBackdrop_1:Show()
					cb.IBackdrop_2:Hide()	
				end
				
				cb.Text:SetPoint("TOP", cb, "BOTTOM", 0, -3)
				
				cb.bd:Show()
			else
				table.wipe(tk)
				if aCoreCDB["UnitframeOptions"]["independentcb"] then -- 独立施法条
					tk = {0, 0, 0}
				elseif aCoreCDB["UnitframeOptions"]["style"] == 1 or aCoreCDB["UnitframeOptions"]["style"] == 3 then -- 透明或者经典主题
					tk = {0, 0, 0}
				else -- 深色主题
					tk = {1, 1, 1}
				end
				
				if unit == "player" and aCoreCDB["UnitframeOptions"]["hideplayercastbaricon"] then
					cb.Icon:Hide()
					cb.IBackdrop_1:Hide()
					cb.IBackdrop_2:Hide()
				else
					cb.Icon:Show()
					cb.IBackdrop_1:Show()
					cb.IBackdrop_2:Hide()
				end
				
				cb.Icon:SetSize(aCoreCDB["UnitframeOptions"]["cbIconsize"], aCoreCDB["UnitframeOptions"]["cbIconsize"])
				
				if multicheck(u, "target", "player", "focus") and aCoreCDB["UnitframeOptions"]["independentcb"] then -- 独立施法条	
					if unit == "player" then
						cb:SetSize(aCoreCDB["UnitframeOptions"]["cbwidth"], aCoreCDB["UnitframeOptions"]["cbheight"])
						T.PlaceCurrentFrame(true, "AltzUI_playerCastbar", true)
						cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["cbheight"]*2)
					elseif unit == "target" then
						cb:SetSize(aCoreCDB["UnitframeOptions"]["target_cbwidth"], aCoreCDB["UnitframeOptions"]["target_cbheight"])
						T.PlaceCurrentFrame(true, "AltzUI_targetCastbar", true)
						cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["target_cbheight"]*2)
					elseif unit == "focus" then
						cb:SetSize(aCoreCDB["UnitframeOptions"]["focus_cbwidth"], aCoreCDB["UnitframeOptions"]["focus_cbheight"])
						T.PlaceCurrentFrame(true, "AltzUI_focusCastbar", true)
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
					
					if aCoreCDB["UnitframeOptions"]["style"] == 1 then
						cb:SetStatusBarTexture(G.media.blank)
					else
						cb:SetStatusBarTexture(G.media.ufbar)
					end
					cb.bd:Show()
				else -- 重叠施法条
					if u == "player" then
						T.ReleaseFrame("AltzUI_playerCastbar")
					elseif u == "target" then
						T.ReleaseFrame("AltzUI_targetCastbar")
					elseif u == "focus" then
						T.ReleaseFrame("AltzUI_focusCastbar")
					end
					
					cb:SetAllPoints(self)
					
					cb.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["height"]*2)
					cb.Icon:SetPoint("BOTTOMRIGHT", cb, "BOTTOMLEFT", -7, -aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"]))
					
					cb.Time:ClearAllPoints()
					cb.Time:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", -3, -3)

					cb.Text:ClearAllPoints()
					if u == "boss" then
						cb.Text:SetPoint("BOTTOMLEFT", cb, "BOTTOMLEFT", 3, -3)					
					elseif aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
						cb.Text:SetPoint("BOTTOM", cb, "BOTTOM", 0, 0)
					else
						cb.Text:SetPoint("TOP", cb, "BOTTOM", 0,  -2-(aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"])))			
					end
					
					cb:SetStatusBarColor(0, 0, 0, 0)
					cb.bd:Hide()
				end			
			end
		end
		cb.ApplySettings()

		self.Castbar = cb
	end
end

--=============================================--
--[[ Swing Timer ]]--
--=============================================--
local CreateSwingTimer = function(self, unit) -- only for player
	if unit ~= "player" then return end
	local bar = CreateFrame("Frame", G.uiname..unit.."SwingTimer", self)
	bar:SetSize(aCoreCDB["UnitframeOptions"]["swwidth"], aCoreCDB["UnitframeOptions"]["swheight"])
	bar.movingname = L["玩家平砍计时条"]
	bar.point = {
		healer = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -160},
		dpser = {a1 = "TOP", parent = "UIParent", a2 = "CENTER", x = 0, y = -160},
	}
	T.CreateDragFrame(bar)

	-- 双手
	bar.Twohand = CreateFrame("StatusBar", nil, bar)
	bar.Twohand:SetAllPoints(bar)
	bar.Twohand:SetStatusBarColor(1, 1, .2)
	bar.Twohand.bd = T.createBackdrop(bar.Twohand, bar.Twohand, 1)
	bar.Twohand:SetFrameLevel(20)

	bar.Twohand.Spark = bar.Twohand:CreateTexture(nil, "OVERLAY")
	bar.Twohand.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["swheight"]*2)
	bar.Twohand.Spark:SetPoint("CENTER", bar.Twohand:GetStatusBarTexture(), "RIGHT")
	bar.Twohand.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.Twohand.Spark:SetVertexColor(1, 1, .2)
	bar.Twohand.Spark:SetBlendMode("ADD")
	bar.Twohand.Spark:SetPoint('CENTER', bar.Twohand:GetStatusBarTexture(), 'RIGHT', 0, 0)
	
	bar.Twohand:Hide()

	-- 主手
	bar.Mainhand = CreateFrame("StatusBar", nil, bar)
	bar.Mainhand:SetAllPoints(bar)
	bar.Mainhand:SetStatusBarColor(1, 1, .2)
	bar.Mainhand.bd = T.createBackdrop(bar.Mainhand, bar.Mainhand, 1)
	bar.Mainhand:SetFrameLevel(20)

	bar.Mainhand.Spark = bar.Mainhand:CreateTexture(nil, "OVERLAY")
	bar.Mainhand.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["swheight"]*2)

	bar.Mainhand.Spark:SetPoint("CENTER", bar.Mainhand:GetStatusBarTexture(), "RIGHT")
	bar.Mainhand.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.Mainhand.Spark:SetVertexColor(1, 1, .2)
	bar.Mainhand.Spark:SetBlendMode("ADD")
	bar.Mainhand.Spark:SetPoint('CENTER', bar.Mainhand:GetStatusBarTexture(), 'RIGHT', 0, 0)
	
	bar.Mainhand:Hide()

	-- 副手
	bar.Offhand = CreateFrame("StatusBar", nil, bar)
	bar.Offhand:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -3)
	bar.Offhand:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", 0, -3)
	bar.Offhand:SetHeight(aCoreCDB["UnitframeOptions"]["swheight"]/2)
	bar.Offhand:SetStatusBarColor(.2, 1, 1)
	bar.Offhand.bd = T.createBackdrop(bar.Offhand, bar.Offhand, 1)
	bar.Offhand:SetFrameLevel(20)

	bar.Offhand.Spark = bar.Offhand:CreateTexture(nil, "OVERLAY")
	bar.Offhand.Spark:SetSize(8, aCoreCDB["UnitframeOptions"]["swheight"])
	bar.Offhand.Spark:SetPoint("CENTER", bar.Offhand:GetStatusBarTexture(), "RIGHT")
	bar.Offhand.Spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.Offhand.Spark:SetVertexColor(.2, 1, 1)
	bar.Offhand.Spark:SetBlendMode("ADD")
	bar.Offhand.Spark:SetPoint('CENTER', bar.Offhand:GetStatusBarTexture(), 'RIGHT', 0, 0)
	
	bar.Offhand:Hide()

	if not aCoreCDB["UnitframeOptions"]["swoffhand"] then
		bar.Offhand.Show = bar.Offhand.Hide
	end

	if aCoreCDB["UnitframeOptions"]["swtimer"] then
		bar.Text = T.createtext(bar.Twohand, "OVERLAY", aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE", "CENTER")
		bar.Text:SetPoint("CENTER")

		bar.TextMH = T.createtext(bar.Mainhand, "OVERLAY", aCoreCDB["UnitframeOptions"]["swtimersize"], "OUTLINE", "CENTER")
		bar.TextMH:SetPoint("CENTER")

		bar.TextOH = T.createtext(bar.Offhand, "OVERLAY", aCoreCDB["UnitframeOptions"]["swtimersize"]/1.5, "OUTLINE", "CENTER")
		bar.TextOH:SetPoint("CENTER")
	end

	bar.hideOoc = true

	bar.ApplySettings = function()
		if aCoreCDB["UnitframeOptions"]["style"] == 1 then
			bar.Twohand:SetStatusBarTexture(G.media.blank)
			bar.Mainhand:SetStatusBarTexture(G.media.blank)
			bar.Offhand:SetStatusBarTexture(G.media.blank)
		else
			bar.Twohand:SetStatusBarTexture(G.media.ufbar)
			bar.Mainhand:SetStatusBarTexture(G.media.ufbar)
			bar.Offhand:SetStatusBarTexture(G.media.ufbar)
		end
	end
	bar.ApplySettings()
	self.Swing = bar
end

--=============================================--
--[[ Auras ]]--
--=============================================--
local PostCreateIcon = function(auras, icon)
	icon.icon:SetTexCoord(.07, .93, .07, .93)

	icon.count:ClearAllPoints()
	icon.count:SetPoint("BOTTOMRIGHT", 0, -3)
	icon.count:SetFontObject(nil)	
	icon.count:SetTextColor(.9, .9, .1)

	icon.overlay:SetTexture(G.media.blank)
	icon.overlay:SetDrawLayer("BACKGROUND")
	icon.overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)

	icon.bd = T.createBackdrop(icon, icon, 0)
	
	if auras.plate_element then
		icon.count:SetFont(G.numFont, aCoreCDB["PlateOptions"]["numfontsize"], "OUTLINE")
		icon.remaining = T.createnumber(icon, "OVERLAY", aCoreCDB["PlateOptions"]["numfontsize"], "OUTLINE", "CENTER")
	else
		icon.count:SetFont(G.numFont, ((aCoreCDB["UnitframeOptions"]["width"]+3)/aCoreCDB["UnitframeOptions"]["auraperrow"]-3)*.4, "OUTLINE")
		icon.remaining = T.createnumber(icon, "OVERLAY", ((aCoreCDB["UnitframeOptions"]["width"]+3)/aCoreCDB["UnitframeOptions"]["auraperrow"]-3)*.4, "OUTLINE", "CENTER")
	end
	
	icon.remaining:SetPoint("TOPLEFT", 0, 5)

	if aCoreCDB["UnitframeOptions"]["auraborders"] then
		auras.showDebuffType = true
	else
		auras.showDebuffType = false
	end
end

local PostCreateIndicatorIcon = function(auras, icon)
	icon.icon:SetTexCoord(.07, .93, .07, .93)

	icon.count:ClearAllPoints()
	icon.count:SetPoint("BOTTOM", 0, -3)
	icon.count:SetFontObject(nil)
	icon.count:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["hotind_size"]*.8, "OUTLINE")
	icon.count:SetTextColor(.9, .9, .1)

	icon.overlay:SetTexture(G.media.blank)
	icon.overlay:SetDrawLayer("BACKGROUND")
	icon.overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)

	icon.bd = T.createBackdrop(icon, icon, 0, true)

	icon.cd.noshowcd = true
	icon.cd:SetReverse(true)
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
	["123059"] = true, -- 动摇意志
}

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local name, _, _, _, duration, expirationTime, _, _, _, SpellID = UnitAura(unit, index, icon.filter)

	if icon.isPlayer or UnitIsFriend("player", unit) or not icon.isDebuff or aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][tostring(SpellID)] or whitelist[tostring(SpellID)] then
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
		auras[1]:SetPoint("LEFT", auras, "CENTER", -((aCoreCDB["PlateOptions"]["plateaurasize"]+4)*auras.iconnum-4)/2, 0)
	end
	
	if auras[1] and auras[1]:IsShown() then
		auras.__owner.RedArrow:SetPoint('BOTTOM', auras.__owner, 'TOP', 0, 15+aCoreCDB["PlateOptions"]["plateaurasize"]) -- 有光环
	else
		auras.__owner.RedArrow:SetPoint('BOTTOM', auras.__owner, 'TOP', 0, 15)
	end
end

local CustomFilter = function(icons, unit, icon, ...)
	local SpellID = select(11, ...)
	if icon.isPlayer then -- show all my auras
		return true
	elseif UnitIsFriend("player", unit) and (not aCoreCDB["UnitframeOptions"]["AuraFilterignoreBuff"] or icon.isDebuff) then
		return true
	elseif not UnitIsFriend("player", unit) and (not aCoreCDB["UnitframeOptions"]["AuraFilterignoreDebuff"] or not icon.isDebuff) then
		return true
	elseif aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"][tostring(SpellID)] then
		return true
	end
end

local BossAuraFilter = function(icons, unit, icon, ...)
	local SpellID = select(11, ...)
	if icon.isPlayer or not icon.isDebuff then -- show buff and my auras
		return true
	elseif whitelist[tostring(SpellID)] then
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

local PlayerDebuffFilter = function(icons, unit, icon, ...)
	local SpellID = select(11, ...)
	if blacklist[tostring(SpellID)] then
		return false
	else
		return true
	end
end

local HealerInd_AuraFilter = function(icons, unit, icon, ...)
	local SpellID = select(10, ...)
	if icon.isPlayer then -- show my buffs
		if aCoreCDB["UnitframeOptions"]["hotind_filtertype"] == "blacklist" and not aCoreCDB["UnitframeOptions"]["hotind_auralist"][SpellID] then
			return true
		elseif aCoreCDB["UnitframeOptions"]["hotind_filtertype"] == "whitelist"	and aCoreCDB["UnitframeOptions"]["hotind_auralist"][SpellID] then
			return true
		end
	end
end

local NamePlate_AuraFilter = function(icons, unit, icon, ...)
	local SpellID = select(10, ...)
	if icon.isPlayer then
		if aCoreCDB["PlateOptions"]["myfiltertype"] == "none" then
			return false
		elseif aCoreCDB["PlateOptions"]["myfiltertype"] == "whitelist" and aCoreCDB["PlateOptions"]["myplateauralist"][SpellID] then
			return true
		elseif aCoreCDB["PlateOptions"]["myfiltertype"] == "blacklist" and not aCoreCDB["PlateOptions"]["myplateauralist"][SpellID] then
			return true
		end
	else
		if aCoreCDB["PlateOptions"]["otherfiltertype"] == "none" then
			return false
		elseif aCoreCDB["PlateOptions"]["otherfiltertype"] == "whitelist" and aCoreCDB["PlateOptions"]["otherplateauralist"][SpellID] then
			return true
		end
	end
end

T.CreateAuras = function(self, unit)
	if not unit then return end
	local u = unit:match("[^%d]+")
	if multicheck(u, "target", "focus", "boss", "arena", "party", "player", "pet", "raid", "nameplate") then
		local Auras = CreateFrame("Frame", nil, self)
		if u == "raid" then
			Auras.spacing = 1
			Auras.PostCreateIcon = PostCreateIndicatorIcon
		else
			Auras.disableCooldown = true
			if G.myClass == "MAGE" then
				Auras.showStealableBuffs = true
			end
			Auras.spacing = 3
			Auras.PostCreateIcon = PostCreateIcon
			Auras.PostUpdateIcon = PostUpdateIcon
			if u == "party" then
				Auras.size = 20
			else
				Auras.gap = true
				Auras.PostUpdateGapIcon = PostUpdateGapIcon
			end
		end

		if unit == "target" or unit == "focus" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			if unit == "target" and (aCoreCDB["UnitframeOptions"]["AuraFilterignoreBuff"] or aCoreCDB["UnitframeOptions"]["AuraFilterignoreDebuff"]) then
				Auras.CustomFilter = CustomFilter
			end
		elseif aCoreCDB["UnitframeOptions"]["playerdebuffenable"] and unit == "player" then		
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numBuffs = 0
			Auras.CustomFilter = PlayerDebuffFilter
		elseif unit == "pet" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 5)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = 5
			Auras.numBuffs = 0
		elseif u == "boss" then -- boss 1-5
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = 6
			Auras.numBuffs = 3
			Auras.CustomFilter = BossAuraFilter
		elseif u == "arena" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
		elseif u == "raid" then
			Auras:SetPoint("TOPRIGHT", self, "TOPRIGHT", -1, -1)
			Auras.initialAnchor = "TOPRIGHT"
			Auras["growth-x"] = "LEFT"
			Auras["growth-y"] = "DOWN"
			Auras.numDebuffs = 1
			Auras.numBuffs = 8
			Auras.CustomFilter = HealerInd_AuraFilter
		elseif u == "party" or u == "partypet" then
			Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, 14)
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = 0
			Auras.numBuffs = 5
			if aCoreCDB["UnitframeOptions"]["usehotfilter"] then
				Auras.CustomFilter = HealerInd_AuraFilter
			else
				Auras.onlyShowPlayer = true
			end

			local Debuffs = CreateFrame("Frame", nil, self)
			Debuffs:SetPoint("BOTTOMLEFT", self.Power, "BOTTOMRIGHT", 8, -8)
			Debuffs.disableCooldown = true
			Debuffs.spacing = 3
			Debuffs.PostCreateIcon = PostCreateIcon
			Debuffs.PostUpdateIcon = PostUpdateIcon
			Debuffs.initialAnchor = "TOPLEFT"
			Debuffs["growth-x"] = "RIGHT"
			Debuffs["growth-y"] = "DOWN"
			Debuffs.num = 5
			self.Debuffs = Debuffs
		elseif u == "nameplate" then
			Auras:SetWidth(aCoreCDB["PlateOptions"]["bar_width"])
			Auras.initialAnchor = "BOTTOMLEFT"
			Auras["growth-x"] = "RIGHT"
			Auras["growth-y"] = "UP"
			Auras.numDebuffs = aCoreCDB["PlateOptions"]["plateauranum"]
			Auras.numBuffs = aCoreCDB["PlateOptions"]["plateauranum"]
			Auras.size = aCoreCDB["PlateOptions"]["plateaurasize"]
			Auras.SetPosition = OverrideAurasSetPosition
			Auras.CustomFilter = NamePlate_AuraFilter
			Auras.disableMouse = true
			Auras.plate_element = true
			
			self:HookScript("OnEvent", function(self, event)
				if event == "UNIT_AURA" then
					self.Auras:ForceUpdate() -- 更新光环居中对齐
				end
			end)
		end
		
		Auras.ApplySettings =  function()
			if u == "raid" then
				Auras:SetHeight(aCoreCDB["UnitframeOptions"]["healerraidheight"])
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["healerraidwidth"]-2)
				Auras.size = aCoreCDB["UnitframeOptions"]["hotind_size"]
			else
				Auras:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*2)
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["width"]-2)		
				Auras.size = (aCoreCDB["UnitframeOptions"]["width"]+3)/aCoreCDB["UnitframeOptions"]["auraperrow"]-3				
			end
			
			if unit == "target" or unit == "focus" then				
				Auras.numDebuffs = aCoreCDB["UnitframeOptions"]["auraperrow"]
				Auras.numBuffs = aCoreCDB["UnitframeOptions"]["auraperrow"]
			elseif aCoreCDB["UnitframeOptions"]["playerdebuffenable"] and unit == "player" then
				Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, aCoreCDB["UnitframeOptions"]["height"]*-(aCoreCDB["UnitframeOptions"]["hpheight"]-1)+8)				
				Auras.numDebuffs = aCoreCDB["UnitframeOptions"]["playerdebuffnum"]				
			elseif unit == "pet" then
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["widthpet"]-2)
			elseif u == "boss" then -- boss 1-5
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["widthboss"]-2)
			elseif u == "arena" then
				Auras:SetWidth(aCoreCDB["UnitframeOptions"]["widthboss"]-2)
				Auras.numDebuffs = ceil(aCoreCDB["UnitframeOptions"]["widthboss"]/((aCoreCDB["UnitframeOptions"]["width"]+3)/aCoreCDB["UnitframeOptions"]["auraperrow"]-3))-1
				Auras.numBuffs = ceil(aCoreCDB["UnitframeOptions"]["widthboss"]/((aCoreCDB["UnitframeOptions"]["width"]+3)/aCoreCDB["UnitframeOptions"]["auraperrow"]-3))-1
			elseif u == "party" or u == "partypet" then			
				self.Debuffs:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*2)
				self.Debuffs:SetWidth(aCoreCDB["UnitframeOptions"]["widthparty"]-2)				
				self.Debuffs.size = (aCoreCDB["UnitframeOptions"]["width"]+3)/aCoreCDB["UnitframeOptions"]["auraperrow"]-3
			elseif u == "nameplate" then
				if aCoreCDB["PlateOptions"]["theme"] == "number" then
					Auras:SetPoint("BOTTOM", self.Health.value, "TOP", 0, -5)
				else
					Auras:SetPoint("BOTTOM", self, "TOP", 0, aCoreCDB["PlateOptions"]["fontsize"]+7)
				end
				Auras:SetHeight(aCoreCDB["PlateOptions"]["plateaurasize"])
				Auras:SetWidth(aCoreCDB["PlateOptions"]["bar_width"])
				Auras.size = aCoreCDB["PlateOptions"]["plateaurasize"]
			end
		end
		Auras.ApplySettings()
		self.Auras = Auras
	end
end

T.CreateClassResources = function(self, plate)
	if multicheck(G.myClass, "DEATHKNIGHT", "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
		local count = 6
		
		local bars = CreateFrame("Frame", self:GetName().."SpecOrbs", self)
		bars:SetPoint("BOTTOM", self, "TOP", 0, 3)

		bars.ApplySettings = function()
			if plate then
				if aCoreCDB["PlateOptions"]["theme"] == "number" then
					bars.width = aCoreCDB["PlateOptions"]["number_cpwidth"]*5
					bars.height = 2
				else
					if aCoreCDB["PlateOptions"]["classresource_pos"] == "target" then
						bars.width = aCoreCDB["PlateOptions"]["bar_width"]*GetCVar("nameplateSelectedScale")
					else
						bars.width = aCoreCDB["PlateOptions"]["bar_width"]
					end
					bars.height = aCoreCDB["PlateOptions"]["bar_height"]/4
				end
			else
				bars.width = aCoreCDB["UnitframeOptions"]["width"]
				bars.height = aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"])
			end
			bars:SetSize(bars.width, bars.height)
		end
		bars.ApplySettings()
		
		for i = 1, count do
			bars[i] = T.createStatusbar(bars, "ARTWORK", bars.height, (bars.width+2)/count-3, 1, 1, 1, 1, self:GetName().."SpecOrbs"..i)
	
			if i == 1 then
				bars[i]:SetPoint("BOTTOMLEFT", bars, "BOTTOMLEFT", 0, 0)
			else
				bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
			end
	
			bars[i].bg:Hide()
			bars[i].bd = T.createBackdrop(bars[i], bars[i], 1)
		end
		
		if G.myClass == "DEATHKNIGHT" then
			if aCoreCDB["UnitframeOptions"]["runecooldown"] then
				for i = 1, 6 do
					bars[i].value = T.createtext(bars[i], "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefs"], "OUTLINE", "CENTER")
					bars[i].value:SetPoint("CENTER")
					bars[i]:SetStatusBarColor(.7, .7, 1)
				end
			end
			self.Runes = bars
			self.Runes.PostUpdateRune = PostUpdateRunes
		elseif G.myClass == "PALADIN" or G.myClass == "MONK" or G.myClass == "WARLOCK" or G.myClass == "MAGE" then
			self.ClassPower = bars
			self.ClassPower.PostUpdate = ClassIconsPostUpdate
		elseif G.myClass == "ROGUE" or G.myClass == "DRUID" then
			if not plate and G.myClass == "DRUID" and aCoreCDB["UnitframeOptions"]["dpsmana"] then
				bars:SetPoint("BOTTOM", self, "TOP", 0, 8)
			end
			self.ClassPower = bars
			self.ClassPower.Override = CpointsUpdate
		end
		
		if plate then
			bars.plate_element = true
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
		if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
			T.CreateClickSets(self)
		end
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

	-- backdrop --
	self.bg = CreateFrame("Frame", nil, self)
	self.bg:SetFrameLevel(0)
	self.bg:SetAllPoints(self)
	self.bg.tex = self.bg:CreateTexture(nil, "BACKGROUND")
	self.bg.tex:SetAllPoints(self)
	self.bg.tex:SetVertexColor(0, 0, 0)
	self.bg.tex:SetTexture(G.media.ufbar)
	
	-- shadow border for health bar --
	self.backdrop = T.createBackdrop(self, self, 0) -- this also use for dispel border

	-- health bar --
	local hp = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(2)
	hp:SetAllPoints(self)
	hp:SetReverseFill(true)
	hp.frequentUpdates = true

	-- health text --
	if not (unit == "targettarget" or unit == "focustarget" or unit == "pet") then
		hp.value = T.createnumber(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "RIGHT")
	end

	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
	hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, aCoreCDB["UnitframeOptions"]["height"])
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	
	self.Health = hp
	self.Health.PostUpdate = T.Updatehealthbar
	tinsert(self.mouseovers, self.Health)

	-- portrait 肖像
	if aCoreCDB["UnitframeOptions"]["portrait"] and multicheck(u, "player", "target", "focus", "boss", "arena") then
		local Portrait = CreateFrame('PlayerModel', nil, self)
		Portrait:SetFrameLevel(1)
		Portrait:SetPoint("TOPLEFT", 0, 0)
		Portrait:SetPoint("BOTTOMRIGHT", -1, 0)
		Portrait:SetAlpha(aCoreCDB["UnitframeOptions"]["portraitalpha"])
		self.Portrait = Portrait
	end

	-- power bar --
	if not (unit == "targettarget" or unit == "focustarget") then
		local pp = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
		pp:SetFrameLevel(2)
		pp:SetPoint"LEFT"
		pp:SetPoint"RIGHT"
		pp:SetPoint("TOP", self, "BOTTOM", 0, -1)
		pp.frequentUpdates = true

		pp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)

		-- backdrop for power bar --
		pp.bd = T.createBackdrop(pp, pp, 1)

		-- power text --
		if not multicheck(u, "pet", "boss", "arena") then
			pp.value = T.createnumber(pp, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "LEFT")
		end

		pp.ApplySettings = function()			
			if aCoreCDB["UnitframeOptions"]["style"] == 1 then
				pp:SetStatusBarTexture(G.media.blank)
			else
				pp:SetStatusBarTexture(G.media.ufbar)
			end
			pp:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"]))
			if pp.value then
				pp.value:ClearAllPoints()
				if aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
					pp.value:SetPoint("BOTTOMLEFT", self, 4, -2)
				else
					pp.value:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 4, -2-(aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"])))
				end
			end
		end

		self.Power = pp
		self.Power.PostUpdate = T.Updatepowerbar
		self.Power.ApplySettings()
		tinsert(self.mouseovers, self.Power)
	end

	-- altpower bar --
	if multicheck(u, "player", "boss", "pet") then
		local altpp = T.createStatusbar(self, "ARTWORK", 5, nil, 1, 1, 0, 1)
		if unit == "pet" then
			altpp:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -5)
			altpp:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -5)
		else
			altpp:SetPoint("TOPLEFT", _G["oUF_AltzPlayer"].Power, "BOTTOMLEFT", 0, -5)
			altpp:SetPoint("TOPRIGHT", _G["oUF_AltzPlayer"].Power, "BOTTOMRIGHT", 0, -5)
		end

		altpp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
		altpp.bd = T.createBackdrop(altpp, altpp, 1)

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
	local name = T.createtext(self.Health, "OVERLAY", 13, "OUTLINE", "LEFT")
	name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 3, 9)
	if unit == "player" or unit == "pet" then
		name:Hide()
	elseif multicheck(u, "targettarget", "focustarget", "boss", "arena") then
		self:Tag(name, "[Altz:shortname]")
	else
		self:Tag(name, "[Altz:longname]")
	end

	if aCoreCDB["UnitframeOptions"]["castbars"] then
		CreateCastbars(self, unit)
	end

	if aCoreCDB["UnitframeOptions"]["swing"] then
		CreateSwingTimer(self, unit)
	end

	if aCoreCDB["UnitframeOptions"]["auras"] then
		T.CreateAuras(self, unit)
	end

	self.FadeMinAlpha = aCoreCDB["UnitframeOptions"]["fadingalpha"]
	self.FadeInSmooth = 0.4
	self.FadeOutSmooth = 1.5
	self.FadeCasting = true
	self.FadeCombat = true
	self.FadeTarget = true
	self.FadeHealth = true
	self.FadePower = true
	self.FadeHover = true
	
	self.Health.ApplySettings = function()
		if aCoreCDB["UnitframeOptions"]["style"] == 1 then
			self.bg.tex:SetAlpha(0)
			hp:SetStatusBarTexture(G.media.blank)
			hp.bg:SetTexture(G.media.blank)
			hp.bg:SetGradientAlpha("VERTICAL", .5, .5, .5, .5, 0, 0, 0,0)
		elseif aCoreCDB["UnitframeOptions"]["style"] == 2 then
			self.bg.tex:SetAlpha(1)
			hp:SetStatusBarTexture(G.media.ufbar)
			hp.bg:SetTexture(G.media.ufbar)
			hp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)			
		else
			self.bg.tex:SetAlpha(1)
			hp:SetStatusBarTexture(G.media.ufbar)
			hp.bg:SetTexture(G.media.ufbar)
			hp.bg:SetAlpha(0)
		end
		-- height, width and scale --
		if multicheck(u, "targettarget", "focustarget", "pet") then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthpet"], aCoreCDB["UnitframeOptions"]["height"])
		elseif u == "boss" or u == "arena" then
			self:SetSize(aCoreCDB["UnitframeOptions"]["widthboss"], aCoreCDB["UnitframeOptions"]["height"])
		else
			self:SetSize(aCoreCDB["UnitframeOptions"]["width"], aCoreCDB["UnitframeOptions"]["height"])
		end
		self:SetScale(aCoreCDB["UnitframeOptions"]["scale"])
		if self.Health.value then
			self.Health.value:ClearAllPoints()
			if aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
				self.Health.value:SetPoint("BOTTOMRIGHT", self, -4, -2)
			else
				self.Health.value:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -4, -2-(aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"])))
			end
		end		
	end

	self.Health.ApplySettings()
end

local UnitSpecific = {

	--========================--
	-- Player
	--========================--
	player = function(self, ...)
		func(self, ...)

		-- Runes, Shards, HolyPower and so on --
		T.CreateClassResources(self)

		-- Stagger
		if G.myClass == "MONK" and aCoreCDB["UnitframeOptions"]["stagger"] then
			local stagger = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
			stagger:SetFrameLevel(2)
			stagger:SetPoint"LEFT"
			stagger:SetPoint"RIGHT"
			stagger:SetPoint("BOTTOM", self, "TOP", 0, 1)

			stagger.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
			stagger.bg.multiplier =.20

			-- backdrop --
			stagger.bd = T.createBackdrop(stagger, stagger, 1)
			
			stagger.ApplySettings = function()
				stagger:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"]))
			end
			stagger.ApplySettings()
			self.Stagger = stagger
		end

		-- Shaman mana
		if multicheck(G.myClass, "SHAMAN", "PRIEST", "DRUID") and aCoreCDB["UnitframeOptions"]["dpsmana"] then
			local dpsmana = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
			dpsmana:SetFrameLevel(2)
			dpsmana:SetPoint"LEFT"
			dpsmana:SetPoint"RIGHT"
			dpsmana:SetPoint("BOTTOM", self, "TOP", 0, 1)

			dpsmana:SetMinMaxValues(0, 2)
			dpsmana:SetValue(1)

			dpsmana.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
			dpsmana.bg.multiplier =.20

			-- backdrop --
			dpsmana.bd = T.createBackdrop(dpsmana, dpsmana, 1)

			dpsmana.ApplySettings = function()
				dpsmana:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*(1-aCoreCDB["UnitframeOptions"]["hpheight"]))
			end
			dpsmana.ApplySettings()
			self.Dpsmana = dpsmana
		end

		-- Zzz
		local Resting = self.Power:CreateTexture(nil, 'OVERLAY')
		Resting:SetSize(18, 18)
		Resting:SetTexture(G.media.reseting)
		Resting:SetDesaturated(true)
		Resting:SetVertexColor( 0, 1, 0)
		Resting:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		self.RestingIndicator = Resting

		-- Combat
		local Combat = self.Power:CreateTexture(nil, "OVERLAY")
		Combat:SetSize(18, 18)
		Combat:SetTexture(G.media.combat)
		Combat:SetDesaturated(true)
		Combat:SetPoint("RIGHT", self.Power, "RIGHT", -5, 0)
		Combat:SetVertexColor( 1, 1, 0)
		self.CombatIndicator = Combat
		self.CombatIndicator.PostUpdate = CombatPostUpdate

		-- PvP
		if aCoreCDB["UnitframeOptions"]["pvpicon"] then
			local PvP = self:CreateTexture(nil, 'OVERLAY')
			PvP:SetSize(35, 35)
			PvP:SetPoint("CENTER", self, "TOPRIGHT", 5, -5)
			self.PvPIndicator = PvP
		end
	end,

	--========================--
	-- Target
	--========================--
	target = function(self, ...)
		func(self, ...)
		-- threat bar --
		if aCoreCDB["UnitframeOptions"]["showthreatbar"] then
			local threatbar = T.createStatusbar(UIParent, "ARTWORK", nil, nil, 0.25, 0.25, 0.25, 1)
			threatbar:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -3)
			threatbar:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 0, -5)
			threatbar.bd = T.createBackdrop(threatbar, threatbar, 1)
			threatbar.bg:Hide()
			self.ThreatBar = threatbar
		end
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
			self.prepFrame.Health = T.createStatusbar(self.prepFrame, "MEDIUM", nil, nil, 1, 1, 1, 1)
			self.prepFrame.Health.bg:Hide()
			self.prepFrame.Health:SetAllPoints(self.prepFrame)
			self.prepFrame.Health.bd = T.createBackdrop(self.prepFrame.Health, self.prepFrame.Health, 0)

			self.prepFrame.Icon = self.prepFrame:CreateTexture(nil, "OVERLAY")
			self.prepFrame.Icon:SetPoint("LEFT", self.prepFrame, "RIGHT", 5, 0)
			self.prepFrame.Icon:SetTexCoord(.08, .92, .08, .92)
			self.prepFrame.Icon.bd = T.createBackdrop(self.prepFrame, self.prepFrame.Icon, 0)

			self.prepFrame.SpecClass = T.createtext(self.prepFrame.Health, "OVERLAY", 13, "OUTLINE", "CENTER")
			self.prepFrame.SpecClass:SetPoint("CENTER")
		end

		local specIcon = CreateFrame("Frame", nil, self)
		specIcon:SetPoint("LEFT", self, "RIGHT", 5, 0)
		specIcon.bd = T.createBackdrop(specIcon, specIcon, 0)
		self.PVPSpecIcon = specIcon

		local trinkets = CreateFrame("Frame", nil, self)
		trinkets:SetPoint("LEFT", specIcon, "RIGHT", 5, 0)
		trinkets.bd = T.createBackdrop(trinkets, trinkets, 0)
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
	
	-- 生命
	local hp = T.createStatusbar(self, "ARTWORK")
	hp:SetFrameLevel(self:GetFrameLevel())
	hp:SetStatusBarTexture("Interface\\AddOns\\AltzUI\\media\\ufbar")
	hp.bd = T.createBackdrop(hp, hp, 1)
	hp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
	
	hp.value = self:CreateFontString(nil, "OVERLAY")
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
	hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, hp:GetHeight())

	hp.ApplySettings = function()
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			self:SetSize(aCoreCDB["PlateOptions"]["number_size"], aCoreCDB["PlateOptions"]["number_size"])
			hp:ClearAllPoints()
			
			hp.value:SetFont(G.plateFont, aCoreCDB["PlateOptions"]["number_size"], "OUTLINE")
			hp.value:ClearAllPoints()
			hp.value:SetPoint("BOTTOM")
			hp.value:SetJustifyH("CENTER")

			hp.ind:ClearAllPoints()
			
			hp:SetReverseFill(false)
		elseif aCoreCDB["PlateOptions"]["theme"] == "dark" then
			self:SetSize(aCoreCDB["PlateOptions"]["bar_width"], aCoreCDB["PlateOptions"]["bar_height"])
			hp:SetAllPoints(self)
			
			hp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["fontsize"], "OUTLINE")			
			hp.value:ClearAllPoints()
			hp.value:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", -5, -3)
			hp.value:SetJustifyH("RIGHT")

			hp.ind:ClearAllPoints()
			hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
			
			hp:SetReverseFill(true)
		else
			self:SetSize(aCoreCDB["PlateOptions"]["bar_width"], aCoreCDB["PlateOptions"]["bar_height"])
			hp:SetAllPoints(self)
			
			hp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["fontsize"], "OUTLINE")
			hp.value:ClearAllPoints()			
			hp.value:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", -5, -3)
			hp.value:SetJustifyH("RIGHT")			
			
			hp.ind:ClearAllPoints()
			hp.ind:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT", 0, 0)
			
			hp:SetReverseFill(false)	
		end
	end
	hp.ApplySettings()
	
	self.Health = hp
	self.Health.plate_element = true
	self.Health.PostUpdate = T.Updatehealthbar
	tinsert(self.mouseovers, self.Health)
	
	-- 能量
	local pp = T.createStatusbar(self, "ARTWORK")
	pp:SetFrameLevel(self:GetFrameLevel())
	pp:SetHeight(aCoreCDB["PlateOptions"]["bar_height"]/4)
	pp:SetStatusBarTexture("Interface\\AddOns\\AltzUI\\media\\ufbar")
	pp.bd = T.createBackdrop(pp, pp, 1)
	pp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
	
	pp.value = self:CreateFontString(nil, "OVERLAY")
	
	pp.ApplySettings = function()
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			pp:ClearAllPoints()
			
			pp.value:SetFont(G.plateFont, aCoreCDB["PlateOptions"]["number_size"]/2, "OUTLINE")
			pp.value:ClearAllPoints()
			pp.value:SetPoint("BOTTOMLEFT", hp.value, "BOTTOMRIGHT")
			pp.value:SetJustifyH("LEFT")
		else
			pp:ClearAllPoints()
			pp:SetPoint("TOPLEFT", hp, "BOTTOMLEFT", 0, -3)
			pp:SetPoint("TOPRIGHT", hp, "BOTTOMRIGHT", 0, -3)
			
			pp.value:SetFont(G.numFont, aCoreCDB["PlateOptions"]["fontsize"], "OUTLINE")
			pp.value:ClearAllPoints()			
			pp.value:SetPoint("BOTTOMLEFT", self, 4, -2)
			pp.value:SetJustifyH("LEFT")		
		end
	end
	pp.ApplySettings()
	
	self.Power = pp
	self.Power.plate_element = true
	self.Power.PostUpdate = T.Updatepowerbar
	tinsert(self.mouseovers, self.Power)
	
	-- 光环
	T.CreateAuras(self, unit)
	
	-- 施法条
	CreateCastbars(self, unit)
	
	-- 个人资源
	if aCoreCDB["PlateOptions"]["classresource_show"] then
		T.CreateClassResources(self, true)
	end
	
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
	ricon.ApplySettings()
	self.RaidTargetIndicator = ricon
	self.RaidTargetIndicator.PostUpdate = RaidTargetIconPostUpdate
	
	-- 名字
	local name = T.createtext(self, "OVERLAY", aCoreCDB["PlateOptions"]["fontsize"], "OUTLINE", "CENTER")	
	self:Tag(name, "[Altz:platename]")
	name.ApplySettings = function()
		if aCoreCDB["PlateOptions"]["theme"] == "number" then
			name:ClearAllPoints()
			name:SetPoint("TOP", self, "BOTTOM")
		else
			name:ClearAllPoints()
			name:SetPoint("TOPLEFT", self, "TOPLEFT", 5, aCoreCDB["PlateOptions"]["fontsize"])
			name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -5, 5)
		end
	end
	name.ApplySettings()
	self.Name = name
	
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
	PvP.ApplySettings()
	self.PvPClassificationIndicator = PvP
	
	-- target RedArrow --
	local RedArrow = self:CreateTexture(nil, 'OVERLAY')
	RedArrow:SetTexture([[Interface\AddOns\AltzUI\media\NeonRedArrow]])
    RedArrow:SetSize(50, 40)
    RedArrow:SetPoint('BOTTOM', self, 'TOP', 0, 15)
	RedArrow:Hide()	
	self.RedArrow = RedArrow
	self:RegisterEvent("PLAYER_TARGET_CHANGED", TargetRedArrowupdate, true)
	self:RegisterEvent("UNIT_AURA", TargetRedArrowupdate, true)
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', function() self.Health:ForceUpdate() end, true)
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

function PostUpdatePlates(self, event, unit)
	if not self then return end
	
	if event == "NAME_PLATE_UNIT_ADDED" then
		if UnitIsUnit(unit, 'player') then -- 玩家姓名板
			if not aCoreCDB["PlateOptions"]["playerplate"] then --  不显示玩家姓名板
				self:DisableElement('Health')		
				self:DisableElement('Power')
				self:DisableElement('Castbar')
				self:DisableElement('Aura')
				
				self.Power.value:Hide()
				self.Health.value:Hide()
				self.Power:Hide()
				self.Health:Hide()
				
				self.Castbar:Hide()
				self.Auras:Hide()
			else  --  显示玩家姓名板
				self:EnableElement('Health')
				self:EnableElement('Power')
				self.Power.value:Show()
				self.Health.value:Show()				
	
				if aCoreCDB["PlateOptions"]["theme"] == "number" then -- 数字样式
					self.Power:Hide()
					self.Health:Hide()
				else
					self.Power:Show()
					self.Health:Show()
				end
				self.Health:ForceUpdate()
				self.Power:ForceUpdate()
					
				if aCoreCDB["PlateOptions"]["platecastbar"] then -- 显示玩家姓名板施法条
					self:EnableElement('Castbar')
					if aCoreCDB["PlateOptions"]["theme"] == "number" then
						self.Castbar.bd:Show()
						self.Castbar:ClearAllPoints()
						self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)					
					else
						self.Castbar.bd:Hide()
						self.Castbar:ClearAllPoints()
						self.Castbar:SetAllPoints(self)
					end
					self.Castbar.Text:ClearAllPoints()
					self.Castbar.Spark:Show()
				else
					self:DisableElement('Castbar')
					self.Castbar:Hide()
				end
				
				if aCoreCDB["PlateOptions"]["plateaura"] then -- 显示玩家姓名板光环
					self:EnableElement('Aura')
					self.Auras:Show()
				else
					self:DisableElement('Aura')
					self.Auras:Hide()
				end
			end
		else -- 其他姓名板
			if aCoreCDB["PlateOptions"]["theme"] == "number" then -- 数字样式
				self.Health:Hide()
				self.Health:ForceUpdate()
				self.Power:Hide()
				
				if plate_c.power_unit[UnitName(unit)] then
					self:EnableElement('Power')
					self.Power:ForceUpdate()
					self.Power.value:Show()
				else
					self:DisableElement('Power')
					self.Power.value:Hide()
				end
				
				self:EnableElement('Castbar')
				self.Castbar.bd:Show()
				self.Castbar:ClearAllPoints()
				self.Castbar:SetPoint("TOP", self, "BOTTOM", 0, -aCoreCDB["PlateOptions"]["fontsize"]-3)
				self.Castbar.Text:ClearAllPoints()
				self.Castbar.Text:SetPoint("TOP", self.Castbar, "BOTTOM", 0, -3)	
				self.Castbar.Spark:Show()
				
				self:EnableElement('Aura')
				self.Auras:Show()				
			elseif aCoreCDB["PlateOptions"]["bar_onlyname"] and UnitIsPlayer(unit) and UnitReaction(unit, 'player') >= 5 then  -- 友方只显示名字		
				self.Health:ForceUpdate() -- 给名字染色
				self:DisableElement('Health')				
				self:DisableElement('Power')
				self:DisableElement('Castbar')
				self:DisableElement('Aura')
				
				self.Health:Hide()
				self.Power:Hide()
				self.Castbar:Hide()
				self:DisableElement('Aura')
				self.Auras:Hide()
			else
				self:EnableElement('Health')
				self.Health:ForceUpdate()
				self.Health:Show()
				
				if plate_c.power_unit[UnitName(unit)] then		
					self:EnableElement('Power')
					self.Power:ForceUpdate()
					self.Power:Show()
					self.Power.value:Show()
				else
					self:DisableElement('Power')
					self.Power:Hide()
					self.Power.value:Hide()
				end
				
				self:EnableElement('Castbar')
				self.Castbar.bd:Show()
				self.Castbar:ClearAllPoints()
				if plate_c.power_unit[UnitName(unit)] then
					self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
					self.Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -7)
				else
					self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
					self.Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
				end
				self.Castbar.Text:ClearAllPoints()
				self.Castbar.Text:SetPoint("TOP", self.Castbar, "BOTTOM", 0, -3)	
				self.Castbar.Spark:Hide()
				
				self:EnableElement('Aura')
				self.Auras:Show()
			end
		end
		
		if aCoreCDB["PlateOptions"]["classresource_show"] then -- 个人资源
			if G.myClass == "DEATHKNIGHT" then
				if UnitIsUnit(unit, 'player') then					
					self:EnableElement('Runes')
					PlacePlateClassSource()
					self.Runes:ForceUpdate()
					self.Runes:Show()
				else
					self:DisableElement('Runes')
					self.Runes:Hide()
				end
			elseif multicheck(G.myClass, "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
				if UnitIsUnit(unit, 'player') then
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
end
T.PostUpdatePlates = PostUpdatePlates

local PlacePlateTargetElementEventFrame = CreateFrame("Frame", nil, UIParent)
PlacePlateTargetElementEventFrame:SetScript("OnEvent", PlacePlateClassSource)
PlacePlateTargetElementEventFrame:RegisterEvent('PLAYER_TARGET_CHANGED')
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

EventFrame:RegisterEvent("ADDON_LOADED")

EventFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

function EventFrame:ADDON_LOADED(arg1)
	if arg1 ~= "AltzUI" then return end

	oUF:Factory(function(self)
		local playerframe = spawnHelper(self, "player")
		playerframe.movingname = L["玩家头像"]
		playerframe.point = {
			healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "BOTTOM", x = -250, y = 350},
			dpser = {a1 = "TOP", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 280},
		}
		T.CreateDragFrame(playerframe)

		local petframe = spawnHelper(self, "pet")
		petframe.movingname = L["宠物头像"]
		petframe.point = {
			healer = {a1 = "RIGHT", parent = playerframe:GetName(), a2 = "LEFT", x = -10, y = 0},
			dpser = {a1 = "RIGHT", parent = playerframe:GetName(), a2 = "LEFT", x = -10, y = 0},
		}
		T.CreateDragFrame(petframe)

		local targetframe = spawnHelper(self, "target")
		targetframe.movingname = L["目标头像"]
		targetframe.point = {
			healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "BOTTOM", x = 250, y = 350},
			dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "BOTTOM", x = 150, y = 350},
		}
		T.CreateDragFrame(targetframe)

		local totframe = spawnHelper(self, "targettarget")
		totframe.movingname = L["目标的目标头像"]
		totframe.point = {
			healer = {a1 = "LEFT", parent = targetframe:GetName(), a2 = "RIGHT" , x = 10, y = 0},
			dpser = {a1 = "LEFT", parent = targetframe:GetName(), a2 = "RIGHT" , x = 10, y = 0},
		}
		T.CreateDragFrame(totframe)

		local focusframe = spawnHelper(self, "focus")
		focusframe.movingname = L["焦点头像"]
		focusframe.point = {
			healer = {a1 = "BOTTOM", parent = targetframe:GetName(), a2 = "BOTTOM" , x = 0, y = 180},
			dpser = {a1 = "BOTTOM", parent = targetframe:GetName(), a2 = "BOTTOM" , x = 0, y = 180},
		}
		T.CreateDragFrame(focusframe)

		local ftframe = spawnHelper(self, "focustarget")
		ftframe.movingname = L["焦点的目标头像"]
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
				bossframes["boss"..i].movingname = L["首领头像"]..i
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
				arenaframes["arena"..i].movingname = L["竞技场敌人头像"]..i
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
			oUF:SpawnNamePlates("Altz_Nameplates", PostUpdatePlates)			
		end
	end)
	
	if aCoreCDB["PlateOptions"]["playerplate"] or aCoreCDB["PlateOptions"]["classresource_show"] then
		SetCVar("nameplateShowSelf", 1)
	else
		SetCVar("nameplateShowSelf", 0)
	end
	
	UpdateNameplateColors()
	UpdateNameplatePowerbars()
	
	ClassNameplateManaBarFrame:SetAlpha(0)
	DeathKnightResourceOverlayFrame:SetAlpha(0)
	ClassNameplateBarMageFrame:SetAlpha(0)
	ClassNameplateBarWindwalkerMonkFrame:SetAlpha(0)
	ClassNameplateBarPaladinFrame:SetAlpha(0)
	ClassNameplateBarRogueDruidFrame:SetAlpha(0)
	ClassNameplateBarWarlockFrame:SetAlpha(0)
	
	EventFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	EventFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
	EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

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
--[[ Ctrl+Click EasyMenu ]]--
--=============================================--
-- From NDui
local function CheckCPower(target_name)
	local full, found_index, target_index
	for index, info in pairs(aCoreCDB["PlateOptions"]["custompowerplates"]) do
		if info.name == target_name then
			found_index = index
			break
		end
	end
	
	for index, info in pairs(aCoreCDB["PlateOptions"]["custompowerplates"]) do
		if info.name == L["空"] then
			target_index = index 
			break
		end
	end
	
	if not target_index then
		full = true
	end
	
	return full, found_index, target_index
end

local function RemovefromCPower(target_index, target_name)
	aCoreCDB["PlateOptions"]["custompowerplates"][target_index]["name"] = L["空"]
	print(string.format(L["已从列表移除"], 255, 255, 0, target_name, L["自定义能量"]))
	UpdateNameplatePowerbars(true)
end

local function AddtoCPower(target_index, target_name)
	aCoreCDB["PlateOptions"]["custompowerplates"][target_index]["name"] = target_name
	print(string.format(L["已加入列表"], 255, 255, 0, target_name, L["自定义能量"]))
	UpdateNameplatePowerbars(true)
end

local function SetCColor(index, name, replace)
	local r, g, b = aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b	
	ColorPickerFrame:ClearAllPoints()
	ColorPickerFrame:SetPoint("CENTER", UIParent, "CENTER")
	ColorPickerFrame.hasOpacity = false
	
	ColorPickerFrame.func = function()
		aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b = ColorPickerFrame:GetColorRGB()
		if not replace then
			aCoreCDB["PlateOptions"]["customcoloredplates"][index]["name"] = name
		end	
	end
	
	ColorPickerOkayButton:SetScript("OnClick", function()
		local new_r, new_g, new_b = ColorPickerFrame:GetColorRGB()
		ColorPickerFrame:Hide()
		print(string.format(L["已加入列表"], new_r*255, new_g*255, new_b*255, name, L["自定义颜色"]))
		UpdateNameplateColors(true)
	end)
	
	ColorPickerFrame.previousValues = {r = r, g = g, b = b}
	
	ColorPickerFrame.cancelFunc = function()
		aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.r, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.g, aCoreCDB["PlateOptions"]["customcoloredplates"][index].color.b = r, g, b
	end
	
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

local function CheckCColor(target_name)
	local full, found_index, target_index, r, g, b
	for index, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
		if info.name == target_name then
			found_index = index
			r, g, b = info.color.r, info.color.g, info.color.b
			break
		end
	end
	
	for index, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
		if info.name == L["空"] and info.color.r == 1 and info.color.g == 1 and info.color.b == 1 then
			target_index = index 
			break
		end
	end
	
	if not target_index then
		full = true
	end
	
	return full, found_index, target_index, r, g, b
end

local function RemovefromCColor(target_index, target_name)
	table.wipe(aCoreCDB["PlateOptions"]["customcoloredplates"][target_index])
	aCoreCDB["PlateOptions"]["customcoloredplates"][target_index] = {
		name = L["空"],
		color = {r = 1, g = 1, b = 1},
	}
	print(string.format(L["已从列表移除"], 255, 255, 0, target_name, L["自定义颜色"]))
	UpdateNameplateColors(true)
end

local function AddtoCColor(target_index, target_name)
	SetCColor(target_index, target_name)
end

local function ReplaceCColor(target_index, target_name)
	SetCColor(target_index, target_name, true)	
end

local menuFrame = CreateFrame("Frame", "NDui_EastMarking", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{text = RAID_TARGET_NONE, func = function() SetRaidTarget("target", 0) end},
	{text = T.hex(1, .92, 0)..RAID_TARGET_1.." "..ICON_LIST[1].."12|t", func = function() SetRaidTarget("target", 1) end},
	{text = T.hex(.98, .57, 0)..RAID_TARGET_2.." "..ICON_LIST[2].."12|t", func = function() SetRaidTarget("target", 2) end},
	{text = T.hex(.83, .22, .9)..RAID_TARGET_3.." "..ICON_LIST[3].."12|t", func = function() SetRaidTarget("target", 3) end},
	{text = T.hex(.04, .95, 0)..RAID_TARGET_4.." "..ICON_LIST[4].."12|t", func = function() SetRaidTarget("target", 4) end},
	{text = T.hex(.7, .82, .875)..RAID_TARGET_5.." "..ICON_LIST[5].."12|t", func = function() SetRaidTarget("target", 5) end},
	{text = T.hex(0, .71, 1)..RAID_TARGET_6.." "..ICON_LIST[6].."12|t", func = function() SetRaidTarget("target", 6) end},
	{text = T.hex(1, .24, .168)..RAID_TARGET_7.." "..ICON_LIST[7].."12|t", func = function() SetRaidTarget("target", 7) end},
	{text = T.hex(.98, .98, .98)..RAID_TARGET_8.." "..ICON_LIST[8].."12|t", func = function() SetRaidTarget("target", 8) end},
	{text = ""}, -- 10
	{text = L["添加自定义能量"]},
	{text = L["添加自定义颜色"]},
	{text = L["添加自定义颜色"]},
}

if aCoreCDB["OtherOptions"]["ctrlmenu"] then
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
					
					local power_full, power_found_index, power_target_index = CheckCPower(target_name)
					if power_full then	-- 自定义能量已满
						menuList[11].text = string.format(L["列表已满"], L["自定义能量"])
					elseif power_found_index then -- 已经有了
						menuList[11].text = string.format(L["移除自定义能量"], target_name)
						menuList[11].func = function() RemovefromCPower(power_found_index, target_name) end
					elseif power_target_index then -- 可以添加
						menuList[11].text = string.format(L["添加自定义能量"], target_name)
						menuList[11].func = function() AddtoCPower(power_target_index, target_name) end
					end
					
					local color_full, color_found_index, color_target_index, r, g, b = CheckCColor(target_name)
					if color_full then	-- 自定义颜色已满
						menuList[12].text = string.format(L["列表已满"], L["自定义颜色"])
						
						menuList[13] = {}
					elseif color_found_index then -- 已经有了
					
						menuList[12].text = string.format(L["替换自定义颜色"], r*255, g*255, b*255, target_name)
						menuList[12].func = function() ReplaceCColor(color_found_index, target_name) end
						
						menuList[13].text = string.format(L["移除自定义颜色"], r*255, g*255, b*255, target_name)
						menuList[13].func = function() RemovefromCColor(color_found_index, target_name) end
						
					elseif color_target_index then -- 可以添加
						menuList[12].text = string.format(L["添加自定义颜色"], target_name)
						menuList[12].func = function() AddtoCColor(color_target_index, target_name) end
						
						menuList[13] = {}
					end
					
					EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 1)
				end
			end
		end)
	end)
end