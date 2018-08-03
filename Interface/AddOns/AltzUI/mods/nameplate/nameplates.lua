local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)
local oUF = AltzUF or oUF

if not aCoreCDB["PlateOptions"]["enableplate"] then return end

local iconcastbar = "Interface\\AddOns\\AltzUI\\media\\dM3"
local numberstylefont = "Interface\\AddOns\\AltzUI\\media\\Infinity Gears.ttf"
local fontsize = 14

local numberstyle = aCoreCDB["PlateOptions"]["numberstyle"]
local playerplate = aCoreCDB["PlateOptions"]["playerplate"]
local classresource_show = aCoreCDB["PlateOptions"]["classresource_show"]
local classresource = aCoreCDB["PlateOptions"]["classresource"] -- "player"  "target"
local plateaura =  aCoreCDB["PlateOptions"]["plateaura"]

local auranum = aCoreCDB["PlateOptions"]["plateauranum"]
local auraiconsize = aCoreCDB["PlateOptions"]["plateaurasize"]
local firendlyCR = aCoreCDB["PlateOptions"]["firendlyCR"]
local enemyCR = aCoreCDB["PlateOptions"]["enemyCR"]

--[[ Auras ]]-- 

local day, hour, minute = 86400, 3600, 60
local function FormatTime(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", math.fmod(s, minute))
end

local function UpdateAuraIcon(button, unit, index, filter)
	local _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)

	button.icon:SetTexture(icon)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	
	local color = DebuffTypeColor[debuffType] or DebuffTypeColor.none
	button.overlay:SetVertexColor(color.r, color.g, color.b)

	if count and count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	
	button:SetScript("OnUpdate", function(self, elapsed)
		if not self.duration then return end
		
		self.elapsed = (self.elapsed or 0) + elapsed

		if self.elapsed < .2 then return end
		self.elapsed = 0

		local timeLeft = self.expirationTime - GetTime()
		if timeLeft <= 0 then
			self.text:SetText(nil)
		else
			self.text:SetText(FormatTime(timeLeft))
		end
	end)
	
	button:Show()
end

local function AuraFilter(caster, spellid)
	if caster == "player" then
		if aCoreCDB["PlateOptions"]["myfiltertype"] == "none" then
			return false
		elseif aCoreCDB["PlateOptions"]["myfiltertype"] == "whitelist" and aCoreCDB["PlateOptions"]["myplateauralist"][spellid] then
			return true
		elseif aCoreCDB["PlateOptions"]["myfiltertype"] == "blacklist" and not aCoreCDB["PlateOptions"]["myplateauralist"][spellid] then
			return true
		end
	else
		if aCoreCDB["PlateOptions"]["otherfiltertype"] == "none" then
			return false
		elseif aCoreCDB["PlateOptions"]["otherfiltertype"] == "whitelist" and aCoreCDB["PlateOptions"]["otherplateauralist"][spellid] then
			return true
		end
	end
end

local function UpdateBuffs(unitFrame)
	if not unitFrame.icons or not unitFrame.displayedUnit then return end
	if not plateaura and UnitIsUnit(unitFrame.displayedUnit, "player") then return end
	local i = 1
	
	for index = 1, 15 do
		if i <= auranum then			
			local bname, _, _, _, bduration, _, bcaster, _, _, bspellid = UnitAura(unitFrame.displayedUnit, index, 'HELPFUL') 
				
			if bname and AuraFilter(bcaster, bspellid) then
				if not unitFrame.icons[i] then					
					unitFrame.icons[i] = unitFrame.Pools:Acquire("AuraIconTemplate")
					unitFrame.icons[i]:SetSize(auraiconsize, auraiconsize)
					unitFrame.icons[i].text:SetFont(G.numFont, auraiconsize-11, "OUTLINE")
					unitFrame.icons[i].count:SetFont(G.numFont, auraiconsize-13, "OUTLINE")
				end
				UpdateAuraIcon(unitFrame.icons[i], unitFrame.displayedUnit, index, 'HELPFUL')
				if i ~= 1 then
					unitFrame.icons[i]:SetPoint("LEFT", unitFrame.icons[i-1], "RIGHT", 4, 0)
				end
				i = i + 1
			end
		end
	end

	for index = 1, 20 do
		if i <= auranum then
			local dname, _, _, _, dduration, _, dcaster, _, _, dspellid = UnitAura(unitFrame.displayedUnit, index, 'HARMFUL')
			
			if dname and AuraFilter(dcaster, dspellid) then
				if not unitFrame.icons[i] then
					unitFrame.icons[i] = unitFrame.Pools:Acquire("AuraIconTemplate")
					unitFrame.icons[i]:SetSize(auraiconsize, auraiconsize)
					unitFrame.icons[i].text:SetFont(G.numFont, auraiconsize-11, "OUTLINE")
					unitFrame.icons[i].count:SetFont(G.numFont, auraiconsize-13, "OUTLINE")
				end
				UpdateAuraIcon(unitFrame.icons[i], unitFrame.displayedUnit, index, 'HARMFUL')
				if i ~= 1 then
					unitFrame.icons[i]:SetPoint("LEFT", unitFrame.icons[i-1], "RIGHT", 4, 0)
				end
				i = i + 1
			end
		end
	end
	
	unitFrame.iconnumber = i - 1
	
	if i > 1 then
		unitFrame.icons[1]:SetPoint("LEFT", unitFrame.icons, "CENTER", -((auraiconsize+4)*(unitFrame.iconnumber)-4)/2,0)
	end
	for index = i, #unitFrame.icons do unitFrame.icons[index]:Hide() end
end

--[[ Player Power ]]--
if playerplate then
	local PowerFrame = CreateFrame("Frame", G.uiname.."NamePlatePowerFrame")
	
	PowerFrame.powerBar = CreateFrame("StatusBar", nil, PowerFrame)
	PowerFrame.powerBar:SetHeight(3)
	PowerFrame.powerBar:SetStatusBarTexture(G.media.ufbar)
	PowerFrame.powerBar:SetMinMaxValues(0, 1)
	
	PowerFrame.powerBar.bd = T.createBackdrop(PowerFrame.powerBar, PowerFrame.powerBar, 1)
	
	PowerFrame.powerperc = PowerFrame:CreateFontString(nil, "OVERLAY")
	PowerFrame.powerperc:SetFont(numberstylefont, fontsize, "OUTLINE")
	PowerFrame.powerperc:SetShadowColor(0, 0, 0, 0.4)
	PowerFrame.powerperc:SetShadowOffset(1, -1)
	
	PowerFrame:SetScript("OnEvent", function(self, event, unit)
		if event == "PLAYER_ENTERING_WORLD" or (event == "UNIT_POWER_FREQUENT" and unit == "player") then
			local minPower, maxPower, powertype_index, powertype = UnitPower("player"), UnitPowerMax("player"), UnitPowerType("player")
			local perc
			
			if maxPower ~= 0 then
				perc = minPower/maxPower
			else
				perc = 0
			end
			local perc_text = string.format("%d", math.floor(perc*100))
			
			if not numberstyle then
				PowerFrame.powerBar:SetValue(perc)
			else
				if minPower ~= maxPower then
					if powertype_index == 0 then
						PowerFrame.powerperc:SetText(perc_text)
					else
						PowerFrame.powerperc:SetText(minPower)
					end
				else
					PowerFrame.powerperc:SetText("")
				end
			end
		
			local r, g, b = unpack(oUF.colors.power[powertype])

			if ( r ~= PowerFrame.r or g ~= PowerFrame.g or b ~= PowerFrame.b ) then
				if not numberstyle then
					PowerFrame.powerBar:SetStatusBarColor(r, g, b)
				else
					PowerFrame.powerperc:SetTextColor(r, g, b)
				end
				PowerFrame.r, PowerFrame.g, PowerFrame.b = r, g, b
			end
		elseif event == "NAME_PLATE_UNIT_ADDED" and UnitIsUnit(unit, "player") then
			local namePlatePlayer = C_NamePlate.GetNamePlateForUnit("player")
			if namePlatePlayer then
				PowerFrame:Show()
				PowerFrame:SetParent(namePlatePlayer)
				if not numberstyle then
					PowerFrame.powerBar:ClearAllPoints()
					PowerFrame.powerBar:SetPoint("TOPLEFT", namePlatePlayer.NUnitFrame.healthBar, "BOTTOMLEFT", 0, -3)
					PowerFrame.powerBar:SetPoint("TOPRIGHT", namePlatePlayer.NUnitFrame.healthBar, "BOTTOMRIGHT", 0, -3)
				else
					PowerFrame.powerperc:ClearAllPoints()
					PowerFrame.powerperc:SetPoint("TOP", namePlatePlayer.NUnitFrame.healthperc, "BOTTOM", 0, 0)
					PowerFrame.powerperc:SetJustifyH("CENTER")
					PowerFrame.powerperc:SetJustifyV("TOP")
				end
			end
		elseif event == "NAME_PLATE_UNIT_REMOVED" and UnitIsUnit(unit, "player") then
			PowerFrame:Hide()
		end
	end)
	PowerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
	PowerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	PowerFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	PowerFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
end

--[[ Class bar stuff ]]--
if classresource_show then
	local function multicheck(check, ...)
		for i=1, select("#", ...) do
			if check == select(i, ...) then return true end
		end
		return false
	end

	local ClassPowerID, ClassPowerType, RequireSpec
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
	
	if(G.myClass == 'MONK') then
		ClassPowerID = Enum.PowerType.Chi or 12
		ClassPowerType = "CHI"
		RequireSpec = SPEC_MONK_WINDWALKER
	elseif(G.myClass == 'PALADIN') then
		ClassPowerID = Enum.PowerType.HolyPower or 9
		ClassPowerType = "HOLY_POWER"
		RequireSpec = SPEC_PALADIN_RETRIBUTION
	elseif(G.myClass == 'MAGE') then
		ClassPowerID = Enum.PowerType.ArcaneCharges or 16
		ClassPowerType = "ARCANE_CHARGES"
		RequireSpec = SPEC_MAGE_ARCANE
	elseif(G.myClass == 'WARLOCK') then
		ClassPowerID = Enum.PowerType.SoulShards or 7
		ClassPowerType = "SOUL_SHARDS"
	elseif(G.myClass == 'ROGUE' or G.myClass == 'DRUID') then
		ClassPowerID = Enum.PowerType.ComboPoints or 4
		ClassPowerType = "COMBO_POINTS"
	end

	local Resourcebar = CreateFrame("Frame", G.uiname.."plateresource", UIParent)
	Resourcebar:SetWidth(100)--(10+3)*6 - 3
	Resourcebar:SetHeight(3)
	Resourcebar.maxbar = 6
	
	for i = 1, 6 do
		Resourcebar[i] = CreateFrame("Frame", G.uiname.."plateresource"..i, Resourcebar)
		Resourcebar[i]:SetFrameLevel(1)
		Resourcebar[i]:SetSize(15, 3)
		Resourcebar[i].bd = T.createBackdrop(Resourcebar[i], Resourcebar[i], 1)
		Resourcebar[i].tex = Resourcebar[i]:CreateTexture(nil, "OVERLAY")
		Resourcebar[i].tex:SetAllPoints(Resourcebar[i])
		if G.myClass == "DEATHKNIGHT" then
			Resourcebar[i].value = T.createtext(Resourcebar[i], "OVERLAY", fontsize-2, "OUTLINE", "CENTER")
			Resourcebar[i].value:SetPoint("CENTER")
			Resourcebar[i].tex:SetColorTexture(.7, .7, 1)
		end
		
		if i == 1 then
			Resourcebar[i]:SetPoint("BOTTOMLEFT", Resourcebar, "BOTTOMLEFT")
		else
			Resourcebar[i]:SetPoint("LEFT", Resourcebar[i-1], "RIGHT", 2, 0)
		end

	end
	
	Resourcebar:SetScript("OnEvent", function(self, event, unit, powerType)
		if event == "PLAYER_TALENT_UPDATE" then
			if multicheck(G.myClass, "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") and not RequireSpec or RequireSpec == GetSpecialization() then -- 启用
				self:RegisterEvent("UNIT_POWER_FREQUENT")
				self:RegisterEvent("PLAYER_ENTERING_WORLD")
				self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
				self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
				self:RegisterEvent("PLAYER_TARGET_CHANGED")
				self:RegisterEvent("RUNE_POWER_UPDATE")
				self:Show()
			else
				self:UnregisterEvent("UNIT_POWER_FREQUENT")
				self:UnregisterEvent("PLAYER_ENTERING_WORLD")
				self:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
				self:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
				self:UnregisterEvent("PLAYER_TARGET_CHANGED")
				self:UnregisterEvent("RUNE_POWER_UPDATE")
				self:Hide()
			end
		elseif event == "PLAYER_ENTERING_WORLD" or (event == "UNIT_POWER_FREQUENT" and unit == "player" and powerType == ClassPowerType) then
			if multicheck(G.myClass, "WARLOCK", "PALADIN", "MONK", "MAGE", "ROGUE", "DRUID") then
				local cur, max, oldMax
				
				cur = UnitPower('player', ClassPowerID)
				max = UnitPowerMax('player', ClassPowerID)
				
				if multicheck(G.myClass, "WARLOCK", "PALADIN", "MONK", "MAGE") then
					for i = 1, max do
						if(i <= cur) then
							self[i]:Show()
						else
							self[i]:Hide()
						end
						if cur == max then
							self[i].tex:SetColorTexture(unpack(classicon_colors[max]))
						else
							self[i].tex:SetColorTexture(unpack(classicon_colors[i]))
						end
					end
					
					oldMax = self.maxbar
					if(max ~= oldMax) then
						if(max < oldMax) then
							for i = max + 1, oldMax do
								self[i]:Hide()
							end
						end
						for i = 1, 6 do
							self[i]:SetWidth(102/max-2)
						end
						self.maxbar = max
					end
				else -- 连击点
					if max <= 6 then
						for i = 1, max do
							if(i <= cur) then
								self[i]:Show()
							else
								self[i]:Hide()
							end
							self[i].tex:SetColorTexture(unpack(cpoints_colors[1]))
						end
					else
						if cur <= 5 then
							for i = 1, 5 do
								if(i <= cur) then
									self[i]:Show()
								else
									self[i]:Hide()
								end
								self[i].tex:SetColorTexture(unpack(cpoints_colors[1]))
							end
						else
							for i = 1, 5 do
								self[i]:Show()
							end
							for i = 1, cur - 5 do
								self[i].tex:SetColorTexture(unpack(cpoints_colors[2]))
							end
							for i = cur - 4, 5 do
								self[i].tex:SetColorTexture(unpack(cpoints_colors[1]))
							end
						end
					end

					oldMax = self.maxbar
					if(max ~= oldMax) then
						if max == 5 or max == 10 then
							self[6]:Hide()
							for i = 1, 6 do
								self[i]:SetWidth(102/5-2)
							end
						else
							for i = 1, 6 do
								self[i]:SetWidth(102/max-2)
								if i > max then
									self[i]:Hide()
								end
							end
						end
						self.maxbar = max
					end
				end
			end
		elseif G.myClass == "DEATHKNIGHT" and event == "RUNE_POWER_UPDATE" then
			local rid = unit
			local start, duration, runeReady = GetRuneCooldown(rid)
			if runeReady then
				self[rid]:SetAlpha(1)
				self[rid].tex:SetColorTexture(.7, .7, 1)
				self[rid]:SetScript("OnUpdate", nil)
				self[rid].value:SetText("")
			elseif start then
				self[rid]:SetAlpha(.7)
				self[rid].tex:SetColorTexture(.3, .3, .3)
				self[rid].max = duration
				self[rid].duration = GetTime() - start
				self[rid]:SetScript("OnUpdate", function(self, elapsed)
					self.duration = self.duration + elapsed
					if self.duration >= self.max or self.duration <= 0 then
						self.value:SetText("")
					else
						self.value:SetText(T.FormatTime(self.max - self.duration))
					end
				end)
			end
		elseif classresource == "player" then
			if event == "NAME_PLATE_UNIT_ADDED" and UnitIsUnit(unit, "player") then
				local namePlatePlayer = C_NamePlate.GetNamePlateForUnit("player")
				if namePlatePlayer then
					self:SetParent(namePlatePlayer)
					self:ClearAllPoints()
					self:Show()
					if numberstyle then
						self:SetPoint("TOP", namePlatePlayer.NUnitFrame.name, "TOP", 0, 0) -- 玩家数字
					else
						self:SetPoint("BOTTOM", namePlatePlayer.NUnitFrame.healthBar, "TOP", 0, 3) -- 玩家条
					end
				end
			elseif event == "NAME_PLATE_UNIT_REMOVED" and UnitIsUnit(unit, "player") then
				self:Hide()
			end
		elseif classresource == "target" and (event == "PLAYER_TARGET_CHANGED" or event == "NAME_PLATE_UNIT_ADDED") then
			local namePlateTarget = C_NamePlate.GetNamePlateForUnit("target")
			if namePlateTarget and UnitCanAttack("player", namePlateTarget.NUnitFrame.displayedUnit) then
				self:SetParent(namePlateTarget)
				self:ClearAllPoints()
				if numberstyle then
					self:SetPoint("TOP", namePlateTarget.NUnitFrame.name, "BOTTOM", 0, -2) -- 目标数字
				else
					self:SetPoint("TOP", namePlateTarget.NUnitFrame.healthBar, "BOTTOM", 0, -2) -- 目标条
				end
				self:Show()
			else
				self:Hide()
			end
		end
	end)
	
	Resourcebar:RegisterEvent("PLAYER_TALENT_UPDATE")
end

--[[ Unit frame ]]--

local function UpdateName(unitFrame)
	if GetUnitName(unitFrame.displayedUnit, false) then
		if UnitIsUnit(unitFrame.displayedUnit, "player") then
			unitFrame.name:SetText("")
		else
			unitFrame.name:SetText(GetUnitName(unitFrame.displayedUnit, false))
		end
	end
end

local function UpdateHealth(unitFrame)
	local minHealth, maxHealth = UnitHealth(unitFrame.displayedUnit), UnitHealthMax(unitFrame.displayedUnit)
	local perc
	if maxHealth == 0 then
		perc = 1
	else
		perc = minHealth/maxHealth
	end
	
	local perc_text = string.format("%d", math.floor(perc*100))
	
	if not numberstyle then
		unitFrame.healthBar:SetValue(perc)
		if minHealth ~= maxHealth then 
			unitFrame.healthBar.value:SetText(perc_text)
		else
			unitFrame.healthBar.value:SetText("")
		end
		
		if perc < .25 then
			unitFrame.healthBar.value:SetTextColor(0.8, 0.05, 0)
		elseif perc < .3 then
			unitFrame.healthBar.value:SetTextColor(0.95, 0.7, 0.25)
		else
			unitFrame.healthBar.value:SetTextColor(1, 1, 1)
		end
	else
		if minHealth ~= maxHealth then
			unitFrame.healthperc:SetText(perc_text)
		else
			unitFrame.healthperc:SetText("")
		end
		
		if perc < .25 then
			unitFrame.healthperc:SetTextColor(0.8, 0.05, 0)
		elseif perc < .3 then
			unitFrame.healthperc:SetTextColor(0.95, 0.7, 0.25)
		else
			unitFrame.healthperc:SetTextColor(1, 1, 1)
		end
	end
end

local function IsOnThreatList(unit)
	local _, threatStatus = UnitDetailedThreatSituation("player", unit)
	if threatStatus == 3 then
		return .9, .1, .4
	elseif threatStatus == 2 then
		return .9, .1, .9
	elseif threatStatus == 1 then
		return .4, .1, .9
	elseif threatStatus == 0 then
		return .1, .7, .9
	end
end

local function IsTapDenied(unitFrame)
	return UnitIsTapDenied(unitFrame.unit) and not UnitPlayerControlled(unitFrame.unit)
end

local function UpdateHealthColor(unitFrame)
	local r, g, b
	
	if ( not UnitIsConnected(unitFrame.displayedUnit) ) then
		r, g, b = 0.7, 0.7, 0.7
	else
		local iscustomed = false
		for index, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
			if GetUnitName(unitFrame.displayedUnit, false) == info.name then
				r, g, b= info.color.r, info.color.g, info.color.b
				iscustomed = true
				break
			end
		end
		
		if not iscustomed then
			local _, englishClass = UnitClass(unitFrame.displayedUnit)
			local classColor = G.Ccolors[englishClass]
			if UnitIsPlayer(unitFrame.displayedUnit) and classColor and firendlyCR and UnitReaction(unitFrame.displayedUnit, 'player') >= 5 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif UnitIsPlayer(unitFrame.displayedUnit) and classColor and enemyCR and UnitReaction(unitFrame.displayedUnit, 'player') <= 4 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif ( IsTapDenied(unitFrame) ) then
				r, g, b = 0.3, 0.3, 0.3
			else
				if aCoreCDB["PlateOptions"]["threatcolor"] and IsOnThreatList(unitFrame.displayedUnit) then
					r, g, b = IsOnThreatList(unitFrame.displayedUnit)
				else
					r, g, b = UnitSelectionColor(unitFrame.displayedUnit, true)
				end
			end
		end
	end
	
	if ( r ~= unitFrame.r or g ~= unitFrame.g or b ~= unitFrame.b ) then
		if not numberstyle then
			unitFrame.healthBar:SetStatusBarColor(r, g, b)
			unitFrame.healthBar.bd:SetBackdropColor(r/3, g/3, b/3)
		else
			unitFrame.name:SetTextColor(r, g, b)
		end
		unitFrame.r, unitFrame.g, unitFrame.b = r, g, b
	end
end

local function UpdateCastBar(unitFrame)
	if not unitFrame.castbar_added then
		unitFrame.castBar.startCastColor = CreateColor(0.6, 0.6, 0.6)
		unitFrame.castBar.startChannelColor = CreateColor(0.6, 0.6, 0.6)
		unitFrame.castBar.finishedCastColor = CreateColor(0.6, 0.6, 0.6)
		unitFrame.castBar.failedCastColor = CreateColor(0.5, 0.2, 0.2)
		unitFrame.castBar.nonInterruptibleColor = CreateColor(0.3, 0.3, 0.3)
		CastingBarFrame_AddWidgetForFade(unitFrame.castBar, unitFrame.castBar.BorderShield)
		unitFrame.castbar_added = true
	end
	if not UnitIsUnit("player", unitFrame.displayedUnit) then  
		CastingBarFrame_SetUnit(unitFrame.castBar, unitFrame.unit, false, true)
	end
end

local function UpdateSelectionHighlight(unitFrame)
	if UnitIsUnit(unitFrame.displayedUnit, "target") and not UnitIsUnit(unitFrame.displayedUnit, "player") then
		unitFrame.redarrow:Show()
	else
		unitFrame.redarrow:Hide()
	end
	
	if not numberstyle then
		if unitFrame.iconnumber and unitFrame.iconnumber > 0 then
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.name, "TOP", 0, auraiconsize+3)
		else
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.name, "TOP", 0, 0)
		end
	else
		if unitFrame.iconnumber and unitFrame.iconnumber > 0 then -- 有图标
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.healthperc, "TOP", 0, auraiconsize)
		elseif UnitHealth(unitFrame.displayedUnit) and UnitHealthMax(unitFrame.displayedUnit) and UnitHealth(unitFrame.displayedUnit) ~= UnitHealthMax(unitFrame.displayedUnit) then -- 非满血
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.healthperc, "TOP", 0, 0)
		else -- 只有名字
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.name, "TOP", 0, 0)
		end
	end
end

local function UpdateRaidTarget(unitFrame)
	if GetRaidTargetIndex(unitFrame.displayedUnit) then
		if not UnitIsUnit(unitFrame.displayedUnit, "player") then
			SetRaidTargetIconTexture(unitFrame.RaidTargetFrame.RaidTargetIcon, GetRaidTargetIndex(unitFrame.displayedUnit))
			unitFrame.RaidTargetFrame.RaidTargetIcon:Show()
		end
	else
		unitFrame.RaidTargetFrame.RaidTargetIcon:Hide()
	end
end

local function UpdateNamePlateEvents(unitFrame)
	-- These are events affected if unit is in a vehicle
	unitFrame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", unitFrame.unit, unitFrame.unit ~= unitFrame.displayedUnit and unitFrame.displayedUnit )
	unitFrame:RegisterUnitEvent("UNIT_AURA", unitFrame.unit, unitFrame.unit ~= unitFrame.displayedUnit and unitFrame.displayedUnit)
	unitFrame:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", unitFrame.unit, unitFrame.unit ~= unitFrame.displayedUnit and unitFrame.displayedUnit)
end

local function UpdateInVehicle(unitFrame)
	if ( UnitHasVehicleUI(unitFrame.unit) ) then
		if ( not unitFrame.inVehicle ) then
			unitFrame.inVehicle = true
			local prefix, id, suffix = string.match(unitFrame.unit, "([^%d]+)([%d]*)(.*)")
			unitFrame.displayedUnit = prefix.."pet"..id..suffix
			UpdateNamePlateEvents(unitFrame)
		end
	else
		if ( unitFrame.inVehicle ) then
			unitFrame.inVehicle = false
			unitFrame.displayedUnit = unitFrame.unit
			UpdateNamePlateEvents(unitFrame)
		end
	end
end

local function UpdateAll(unitFrame)
	UpdateInVehicle(unitFrame)
	if ( UnitExists(unitFrame.displayedUnit) ) then
		UpdateCastBar(unitFrame)
		UpdateSelectionHighlight(unitFrame)
		UpdateName(unitFrame)
		UpdateHealthColor(unitFrame)
		UpdateHealth(unitFrame)		
		UpdateBuffs(unitFrame)
		UpdateRaidTarget(unitFrame)
		
		if UnitIsUnit("player", unitFrame.displayedUnit) then
			unitFrame.castBar:UnregisterAllEvents()
			if not numberstyle then
				unitFrame.healthBar.value:Hide()
			end
		else
			if not numberstyle then
				unitFrame.healthBar.value:Show()
			end
		end
	end
	
	if aCoreCDB["PlateOptions"]["blzplates"] then
		local namePlate = unitFrame:GetParent()
		if namePlate then
		if namePlate.NUnitFrame:IsShown() then
			namePlate.UnitFrame:Hide()
		elseif aCoreCDB["PlateOptions"]["blzplates_nameonly"] then
			namePlate.UnitFrame.name:Show()
		else
			namePlate.UnitFrame:Show()
		end
		end
	end
end

local function NamePlate_OnEvent(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		UpdateName(self)-- 目标是自己的时候不要显示箭头
		UpdateSelectionHighlight(self)
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		UpdateAll(self)
	elseif ( arg1 == self.unit or arg1 == self.displayedUnit ) then
		if ( event == "UNIT_HEALTH_FREQUENT" ) then
			UpdateHealth(self)
			UpdateSelectionHighlight(self)
		elseif ( event == "UNIT_AURA" ) then
			UpdateBuffs(self)
			UpdateSelectionHighlight(self)
		elseif ( event == "UNIT_THREAT_LIST_UPDATE" ) then
			UpdateHealthColor(self)
		elseif ( event == "UNIT_NAME_UPDATE" ) then
			UpdateName(self)
		elseif ( event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_PET" ) then
			UpdateAll(self)
		end
	end
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:RegisterEvent("UNIT_NAME_UPDATE")
	unitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	unitFrame:RegisterEvent("UNIT_PET")
	unitFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	unitFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
	UpdateNamePlateEvents(unitFrame)
	unitFrame:SetScript("OnEvent", NamePlate_OnEvent)
end

local function UnregisterNamePlateEvents(unitFrame)
	unitFrame:UnregisterAllEvents()
	unitFrame:SetScript("OnEvent", nil)
end

local function SetUnit(unitFrame, unit)
	unitFrame.unit = unit
	unitFrame.displayedUnit = unit	 -- For vehicles
	unitFrame.inVehicle = false
	if ( unit ) then
		RegisterNamePlateEvents(unitFrame)
	else
		UnregisterNamePlateEvents(unitFrame)
	end
end


--[[ Driver frame ]]--

local function HideBlizzard()
	if not aCoreCDB["PlateOptions"]["blzplates"] then
		NamePlateDriverFrame:UnregisterAllEvents()
	end
	ClassNameplateManaBarFrame:Hide()
	SystemFont_NamePlate:SetFont(G.norFont, aCoreCDB["PlateOptions"]["name_fontsize"], "OUTLINE")
	
	hooksecurefunc(NamePlateDriverFrame, "SetupClassNameplateBar", function()
		NamePlateTargetResourceFrame:Hide()
		NamePlatePlayerResourceFrame:Hide()	
	end)
	
	local checkBox = InterfaceOptionsNamesPanelUnitNameplatesMakeLarger
	function checkBox.setFunc(value)
		if value == "1" then
			SetCVar("NamePlateHorizontalScale", checkBox.largeHorizontalScale)
			SetCVar("NamePlateVerticalScale", checkBox.largeVerticalScale)
		else
			SetCVar("NamePlateHorizontalScale", checkBox.normalHorizontalScale)
			SetCVar("NamePlateVerticalScale", checkBox.normalVerticalScale)
		end
		NamePlates_UpdateNamePlateOptions()
	end
	
	SetCVar("nameplateOtherTopInset", 0.08)
	SetCVar("nameplateOtherBottomInset", 0.1)
	SetCVar("namePlateMinScale", 1)
	SetCVar("namePlateMaxScale", 1)
	SetCVar("nameplateMaxDistance", 45)
	SetCVar("nameplateOverlapH",  0.3) --default is 0.8
	SetCVar("nameplateOverlapV",  0.7) --default is 1.1
end

local function OnUnitFactionChanged(unit)
	-- This would make more sense as a unitFrame:RegisterUnitEvent
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	if (namePlate) then
		UpdateName(namePlate.NUnitFrame)
		UpdateHealthColor(namePlate.NUnitFrame)
	end
end

local function OnRaidTargetUpdate()
	for _, namePlate in pairs(C_NamePlate.GetNamePlates()) do
		UpdateRaidTarget(namePlate.NUnitFrame)
	end
end

function NamePlates_UpdateNamePlateOptions()
	-- Called at VARIABLES_LOADED and by "Larger Nameplates" interface options checkbox
	C_NamePlate.SetNamePlateFriendlySize(100 * tonumber(GetCVar("NamePlateHorizontalScale")), 45)
	C_NamePlate.SetNamePlateEnemySize(100, 45)

	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		UpdateAll(namePlate.NUnitFrame)
	end
end

local function OnNamePlateCreated(namePlate)
	namePlate.Pools = CreatePoolCollection() 
	
	if numberstyle then -- 数字样式
		namePlate.Pools:CreatePool("Button", namePlate, "NumberStyleNameplateTemplate")
		namePlate.NUnitFrame = namePlate.Pools:Acquire("NumberStyleNameplateTemplate")
		namePlate.NUnitFrame:SetAllPoints(namePlate)
		namePlate.NUnitFrame:SetFrameLevel(namePlate:GetFrameLevel())
		namePlate.NUnitFrame:Show()
		namePlate.NUnitFrame.Pools = CreatePoolCollection() 
		namePlate.NUnitFrame.Pools:CreatePool("Frame", namePlate, "AuraIconTemplate")
		
		if classresource_show and classresource == "target" then
			namePlate.NUnitFrame.castBar:SetPoint("TOP", namePlate.NUnitFrame.name, "BOTTOM", 0, -7)
		else
			namePlate.NUnitFrame.castBar:SetPoint("TOP", namePlate.NUnitFrame.name, "BOTTOM", 0, -3)
		end		
	else -- 条形样式
		namePlate.Pools:CreatePool("Button", namePlate, "BarStyleNameplateTemplate")
		namePlate.NUnitFrame = namePlate.Pools:Acquire("BarStyleNameplateTemplate")
		namePlate.NUnitFrame:SetAllPoints(namePlate)
		namePlate.NUnitFrame:SetFrameLevel(namePlate:GetFrameLevel())
		namePlate.NUnitFrame:Show()
		namePlate.NUnitFrame.Pools = CreatePoolCollection() 
		namePlate.NUnitFrame.Pools:CreatePool("Frame", namePlate, "AuraIconTemplate")
		
		if classresource_show and classresource == "target" then
			namePlate.NUnitFrame.castBar:SetPoint("TOPLEFT", namePlate.NUnitFrame.healthBar, "BOTTOMLEFT", 0, -7)
			namePlate.NUnitFrame.castBar:SetPoint("TOPRIGHT", namePlate.NUnitFrame.healthBar, "BOTTOMRIGHT", 0, -7)
			namePlate.NUnitFrame.castBar.Icon:SetSize(25, 25)
		else
			namePlate.NUnitFrame.castBar:SetPoint("TOPLEFT", namePlate.NUnitFrame.healthBar, "BOTTOMLEFT", 0, -3)
			namePlate.NUnitFrame.castBar:SetPoint("TOPRIGHT", namePlate.NUnitFrame.healthBar, "BOTTOMRIGHT", 0, -3)
		end
	end
	
	namePlate.NUnitFrame:EnableMouse(false)
end

local function OnNamePlateAdded(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	SetUnit(namePlate.NUnitFrame, unit)
	UpdateAll(namePlate.NUnitFrame)
end

local function OnNamePlateRemoved(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	SetUnit(namePlate.NUnitFrame, nil)
end

local function NamePlates_OnEvent(self, event, ...) 
	if ( event == "VARIABLES_LOADED" ) then
		HideBlizzard()
		if playerplate then
			SetCVar("nameplateShowSelf", 1)
		else
			SetCVar("nameplateShowSelf", 0)
		end
		if aCoreCDB["PlateOptions"]["blzplates"] and aCoreCDB["PlateOptions"]["blzplates_nameonly"] then
			SetCVar("nameplateShowOnlyNames", 1)
		else
			SetCVar("nameplateShowOnlyNames", 0)
		end
		NamePlates_UpdateNamePlateOptions()
	elseif ( event == "NAME_PLATE_CREATED" ) then
		local namePlate = ...
		OnNamePlateCreated(namePlate)
	elseif ( event == "NAME_PLATE_UNIT_ADDED" ) then 
		local unit = ...
		OnNamePlateAdded(unit)
	elseif ( event == "NAME_PLATE_UNIT_REMOVED" ) then 
		local unit = ...
		OnNamePlateRemoved(unit)
	elseif event == "RAID_TARGET_UPDATE" then
		OnRaidTargetUpdate()
	elseif event == "DISPLAY_SIZE_CHANGED" then
		NamePlates_UpdateNamePlateOptions()
	elseif ( event == "UNIT_FACTION" ) then
		OnUnitFactionChanged(...)
	end
end

local NamePlatesFrame = CreateFrame("Frame", "NamePlatesFrame", UIParent) 
NamePlatesFrame:SetScript("OnEvent", NamePlates_OnEvent)
NamePlatesFrame:RegisterEvent("VARIABLES_LOADED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_CREATED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
NamePlatesFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
NamePlatesFrame:RegisterEvent("RAID_TARGET_UPDATE")
NamePlatesFrame:RegisterEvent("UNIT_FACTION")