local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
if not aCoreCDB["PlateOptions"]["enableplate"] then return end

local iconcastbar = "Interface\\AddOns\\AltzUI\\media\\dM3"
local redarrow = "Interface\\AddOns\\AltzUI\\media\\NeonRedArrow"
local numberstylefont = "Interface\\AddOns\\AltzUI\\media\\Infinity Gears.ttf"
local fontsize = 14

local numberstyle = aCoreCDB["PlateOptions"]["numberstyle"]
local combat = aCoreCDB["PlateOptions"]["autotoggleplates"]

local auranum = aCoreCDB["PlateOptions"]["plateauranum"]
local auraiconsize = aCoreCDB["PlateOptions"]["plateaurasize"]
local firendlyCR = aCoreCDB["PlateOptions"]["firendlyCR"]
local enemyCR = aCoreCDB["PlateOptions"]["enemyCR"]

--[[ Class bar stuff ]]-- 

local function RedrawManaBar()
	local manaBar = ClassNameplateManaBarFrame
	manaBar:SetWidth(110)
	manaBar:SetHeight(2)
	manaBar.SetWidth = function() end
	manaBar.SetHeight = function() end
	manaBar.FullPowerFrame:ClearAllPoints()
end

local function MoveClassResource(onTarget, bar)
	if (not bar) then
		return
	end
	local showSelf = GetCVar("nameplateShowSelf")
	if (showSelf == "0") then
		return
	end

	if (onTarget and NamePlateTargetResourceFrame) then
		local namePlateTarget = C_NamePlate.GetNamePlateForUnit("target")
		if (namePlateTarget) then
			NamePlateTargetResourceFrame:ClearAllPoints()
			NamePlateTargetResourceFrame:SetPoint("CENTER", namePlateTarget.UnitFrame.castBar, "TOP", 0, 5)
		end
	elseif (not onTarget and NamePlatePlayerResourceFrame) then
		-- Not getting called because, for some reason, 
		-- NamePlatePlayerResourceFrame is only true when onTarget is false
		local namePlatePlayer = C_NamePlate.GetNamePlateForUnit("player")
		if (namePlatePlayer) then
			NamePlatePlayerResourceFrame:ClearAllPoints()
			NamePlatePlayerResourceFrame:SetPoint("BOTTOM", namePlatePlayer.UnitFrame, "TOP", 0, 0)
		end
	end
end


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

local function CreateAuraIcon(parent)
	local button = CreateFrame("Frame",nil,parent)
	button:SetSize(auraiconsize, auraiconsize)
	
	button.icon = button:CreateTexture(nil, "OVERLAY", nil, 3)
	button.icon:SetPoint("TOPLEFT",button,"TOPLEFT", 1, -1)
	button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-1, 1)
	button.icon:SetTexCoord(.08, .92, 0.08, 0.92)
	
	button.overlay = button:CreateTexture(nil, "ARTWORK", nil, 7)
	button.overlay:SetTexture("Interface\\Buttons\\WHITE8x8")
	button.overlay:SetAllPoints(button)	
	
	button.bd = button:CreateTexture(nil, "ARTWORK", nil, 6)
	button.bd:SetTexture("Interface\\Buttons\\WHITE8x8")
	button.bd:SetVertexColor(0, 0, 0)
	button.bd:SetPoint("TOPLEFT",button,"TOPLEFT", -1, 1)
	button.bd:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT", 1, -1)
	
	button.text = T.createnumber(button, "OVERLAY", auraiconsize-11, "OUTLINE", "CENTER")
    button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
	button.text:SetTextColor(1, 1, 0)
	
	button.count = T.createnumber(button, "OVERLAY", auraiconsize-13, "OUTLINE", "RIGHT")
	button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", -1, 2)
	button.count:SetTextColor(.4, .95, 1)
	
	return button
end

local function UpdateAuraIcon(button, unit, index, filter)
	local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)

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
	local unit = unitFrame.displayedUnit
	local i = 1
	
	for index = 1, 15 do
		if i <= auranum then			
			local bname, _, _, _, _, bduration, _, bcaster, _, _, bspellid = UnitAura(unit, index, 'HELPFUL')
			local matchbuff = AuraFilter(bcaster, bspellid)
				
			if bname and matchbuff then
				if not unitFrame.icons[i] then
					unitFrame.icons[i] = CreateAuraIcon(unitFrame)
				end
				UpdateAuraIcon(unitFrame.icons[i], unit, index, 'HELPFUL')
				if i ~= 1 then
					unitFrame.icons[i]:SetPoint("LEFT", unitFrame.icons[i-1], "RIGHT", 4, 0)
				end
				i = i + 1
			end
		end
	end

	for index = 1, 20 do
		if i <= auranum then
			local dname, _, _, _, _, dduration, _, dcaster, _, _, dspellid = UnitAura(unit, index, 'HARMFUL')
			local matchdebuff = AuraFilter(dcaster, dspellid)
			
			if dname and matchdebuff then
				if not unitFrame.icons[i] then
					unitFrame.icons[i] = CreateAuraIcon(unitFrame)
				end
				UpdateAuraIcon(unitFrame.icons[i], unit, index, 'HARMFUL')
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

--[[ Unit frame ]]--

local OPTION_TABLE_NONE = {}

local EnemyFrameOptions = {

}

local FriendlyFrameOptions = {

}

local PlayerFrameOptions = {
	UseClassColor = aCoreCDB["PlateOptions"]["classcolor"]
}

local function UpdateName(unitFrame)
	local name = GetUnitName(unitFrame.displayedUnit, false)
	if name then
		unitFrame.name:SetText(name)
	end
end

local function UpdateHealth(unitFrame)
	local unit = unitFrame.displayedUnit
	local minHealth, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	local perc = minHealth/maxHealth
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
			unitFrame.valueperc:SetText(perc_text)
		else
			unitFrame.valueperc:SetText("")
		end
		
		if perc < .25 then
			unitFrame.valueperc:SetTextColor(0.8, 0.05, 0)
		elseif perc < .3 then
			unitFrame.valueperc:SetTextColor(0.95, 0.7, 0.25)
		else
			unitFrame.valueperc:SetTextColor(1, 1, 1)
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
	local healthBar = unitFrame.healthBar
	local options = unitFrame.optionTable
	local unit = unitFrame.displayedUnit
	local r, g, b
	
	if ( not UnitIsConnected(unit) ) then
		r, g, b = 0.7, 0.7, 0.7
	else
		local iscustomed = false
		for index, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
			if GetUnitName(unit, false) == info.name then
				r, g, b= info.color.r, info.color.g, info.color.b
				iscustomed = true
				break
			end
		end
		
		if not iscustomed then
			local _, englishClass = UnitClass(unit)
			local classColor = RAID_CLASS_COLORS[englishClass]
			if UnitIsPlayer(unit) and classColor and firendlyCR and UnitReaction(unit, 'player') >= 5 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif UnitIsPlayer(unit) and classColor and enemyCR and UnitReaction(unit, 'player') <= 4 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif ( IsTapDenied(unitFrame) ) then
				r, g, b = 0.3, 0.3, 0.3
			else
				if aCoreCDB["PlateOptions"]["threatcolor"] and IsOnThreatList(unitFrame.displayedUnit) then
					r, g, b = IsOnThreatList(unitFrame.displayedUnit)
				else
					r, g, b = UnitSelectionColor(unit, true)
				end
			end
		end
	end
	
	if ( r ~= unitFrame.r or g ~= unitFrame.g or b ~= unitFrame.b ) then
		if not numberstyle then
			healthBar:SetStatusBarColor(r, g, b)
		else
			unitFrame.name:SetTextColor(r, g, b)
		end
		unitFrame.r, unitFrame.g, unitFrame.b = r, g, b
	end
end

local function UpdateCastBar(unitFrame)
	local castBar = unitFrame.castBar
	castBar.startCastColor = CreateColor(0.6, 0.6, 0.6)
	castBar.startChannelColor = CreateColor(0.6, 0.6, 0.6)
	castBar.finishedCastColor = CreateColor(0.6, 0.6, 0.6)
	castBar.failedCastColor = CreateColor(0.5, 0.2, 0.2)
	castBar.nonInterruptibleColor = CreateColor(0.3, 0.3, 0.3)
	CastingBarFrame_AddWidgetForFade(castBar, castBar.BorderShield)
	CastingBarFrame_SetUnit(castBar, unitFrame.unit, false, true)
end

local function UpdateSelectionHighlight(unitFrame)
	local unit = unitFrame.unit
	if ( UnitIsUnit(unit, "target") ) then
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
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.valueperc, "TOP", 0, auraiconsize)
		elseif UnitHealth(unit) and UnitHealthMax(unit) and UnitHealth(unit) ~= UnitHealthMax(unit) then -- 非满血
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.valueperc, "TOP", 0, 0)
		else -- 只有名字
			unitFrame.redarrow:SetPoint("BOTTOM", unitFrame.name, "TOP", 0, 0)
		end
	end
end

local function UpdateRaidTarget(unitFrame)
	local icon = unitFrame.RaidTargetFrame.RaidTargetIcon
	local index = GetRaidTargetIndex(unitFrame.displayedUnit)
	if ( index ) then
		SetRaidTargetIconTexture(icon, index)
		icon:Show()
	else
		icon:Hide()
	end
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
		UpdateName(unitFrame)
		UpdateHealthColor(unitFrame)
		UpdateHealth(unitFrame)
		UpdateCastBar(unitFrame)
		UpdateSelectionHighlight(unitFrame)
		UpdateBuffs(unitFrame)
		UpdateRaidTarget(unitFrame)
	end
end

local function NamePlate_OnEvent(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		UpdateName(self)
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
			UpdateName(self)
			UpdateHealthColor(self)
		elseif ( event == "UNIT_NAME_UPDATE" ) then
			UpdateName(self)
			UpdateHealthColor(self)
		elseif ( event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_PET" ) then
			UpdateAll(self)
		end
	end
end

local function UpdateNamePlateEvents(unitFrame)
	-- These are events affected if unit is in a vehicle
	local unit = unitFrame.unit
	local displayedUnit
	if ( unit ~= unitFrame.displayedUnit ) then
		-- Only register for displayedUnit if different from unit
		displayedUnit = unitFrame.displayedUnit
	end
	unitFrame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", unit, displayedUnit)
	unitFrame:RegisterUnitEvent("UNIT_AURA", unit, displayedUnit)
	unitFrame:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", unit, displayedUnit)
	-- unitFrame:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", unit, displayedUnit)
	-- unitFrame:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", unit, displayedUnit)  -- i.e. AFK, DND
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:RegisterEvent("UNIT_NAME_UPDATE")
	unitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	unitFrame:RegisterEvent("UNIT_PET")
	unitFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	unitFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
	-- unitFrame:RegisterEvent("UNIT_CONNECTION") 
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
	NamePlateDriverFrame:UnregisterAllEvents()
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
end

local function OnUnitFactionChanged(unit)
	-- This would make more sense as a unitFrame:RegisterUnitEvent
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	if (namePlate) then
		UpdateName(namePlate.UnitFrame)
		UpdateHealthColor(namePlate.UnitFrame)
	end
end

local function OnRaidTargetUpdate()
	for _, namePlate in pairs(C_NamePlate.GetNamePlates()) do
		UpdateRaidTarget(namePlate.UnitFrame)
	end
end

local function OnTargetChanged()
	NamePlateDriverFrame:SetupClassNameplateBars() -- Calling Blizz code here
end

local function SetOptions(unitFrame, unit)
	if ( UnitIsUnit("player", unit) ) then
		unitFrame.optionTable = PlayerFrameOptions
	elseif ( UnitIsFriend("player", unit) ) then
		unitFrame.optionTable = FriendlyFrameOptions
	else
		unitFrame.optionTable = EnemyFrameOptions
	end
end

function NamePlates_UpdateNamePlateOptions()
	-- Called at VARIABLES_LOADED and by "Larger Nameplates" interface options checkbox

	EnemyFrameOptions.useClassColors = GetCVarBool("ShowClassColorInNameplate")
	EnemyFrameOptions.playLoseAggroHighlight = GetCVarBool("ShowNamePlateLoseAggroFlash")

	local baseNamePlateWidth = 110
	local baseNamePlateHeight = 45
	local namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"))
	local horizontalScale = tonumber(GetCVar("NamePlateHorizontalScale"))
	C_NamePlate.SetNamePlateOtherSize(baseNamePlateWidth * horizontalScale, baseNamePlateHeight)
	C_NamePlate.SetNamePlateSelfSize(baseNamePlateWidth, baseNamePlateHeight)

	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		SetOptions(unitFrame, unitFrame.unit)
		UpdateAll(unitFrame)
	end
end

local function OnNamePlateCreated(namePlate)

	namePlate.UnitFrame = CreateFrame("Button", "$parentUnitFrame", namePlate)
	namePlate.UnitFrame:SetAllPoints(namePlate)
	namePlate.UnitFrame:SetFrameLevel(namePlate:GetFrameLevel())
	
	if numberstyle then -- 数字样式
		namePlate.UnitFrame.valueperc = namePlate.UnitFrame:CreateFontString(nil, "OVERLAY")
		namePlate.UnitFrame.valueperc:SetFont(numberstylefont, fontsize*2, "OUTLINE")
		namePlate.UnitFrame.valueperc:SetPoint("CENTER")
		namePlate.UnitFrame.valueperc:SetTextColor(1,1,1)
		namePlate.UnitFrame.valueperc:SetShadowColor(0, 0, 0, 0.4)
		namePlate.UnitFrame.valueperc:SetShadowOffset(1, -1)
		namePlate.UnitFrame.valueperc:SetText("111%")
		
		namePlate.UnitFrame.name = T.createtext(namePlate.UnitFrame, "ARTWORK", fontsize-4, "OUTLINE", "CENTER")
		namePlate.UnitFrame.name:SetPoint("TOP", namePlate.UnitFrame.valueperc, "BOTTOM", 0, -3)
		namePlate.UnitFrame.name:SetTextColor(1,1,1)
		namePlate.UnitFrame.name:SetText("Name")
		
		namePlate.UnitFrame.castBar = CreateFrame("StatusBar", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.castBar:Hide()
		namePlate.UnitFrame.castBar.iconWhenNoninterruptible = false
		namePlate.UnitFrame.castBar:SetSize(30,30)
		namePlate.UnitFrame.castBar:SetPoint("TOP", namePlate.UnitFrame.name, "BOTTOM", 0, -3)
		namePlate.UnitFrame.castBar:SetStatusBarTexture(iconcastbar)
		namePlate.UnitFrame.castBar:SetStatusBarColor(0.5, 0.5, 0.5)
		
		namePlate.UnitFrame.castBar.border = F.CreateBDFrame(namePlate.UnitFrame.castBar, 0)
		T.CreateThinSD(namePlate.UnitFrame.castBar.border, 1, 0, 0, 0, 1, -2)
		
		namePlate.UnitFrame.castBar.bg = namePlate.UnitFrame.castBar:CreateTexture(nil, 'BORDER')
		namePlate.UnitFrame.castBar.bg:SetAllPoints(namePlate.UnitFrame.castBar)
		namePlate.UnitFrame.castBar.bg:SetTexture(1/3, 1/3, 1/3, .5)

		namePlate.UnitFrame.castBar.Icon = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY", 1)
		namePlate.UnitFrame.castBar.Icon:SetPoint("CENTER")
		namePlate.UnitFrame.castBar.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
		namePlate.UnitFrame.castBar.Icon:SetSize(25, 25)
		namePlate.UnitFrame.castBar.iconborder = F.CreateBG(namePlate.UnitFrame.castBar.Icon)
		namePlate.UnitFrame.castBar.iconborder:SetDrawLayer("OVERLAY",-1)
		
		namePlate.UnitFrame.castBar.Text = T.createtext(namePlate.UnitFrame.castBar, "OVERLAY", fontsize-4, "OUTLINE", "CENTER")
		namePlate.UnitFrame.castBar.Text:SetPoint("CENTER")

		namePlate.UnitFrame.castBar.BorderShield = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY", 1)
		namePlate.UnitFrame.castBar.BorderShield:SetAtlas("nameplates-InterruptShield")
		namePlate.UnitFrame.castBar.BorderShield:SetSize(15, 15)
		namePlate.UnitFrame.castBar.BorderShield:SetPoint("CENTER", namePlate.UnitFrame.castBar, "TOPLEFT")
		
		namePlate.UnitFrame.castBar.Spark = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY")
		namePlate.UnitFrame.castBar.Spark:SetSize(30, 45)
		namePlate.UnitFrame.castBar.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		namePlate.UnitFrame.castBar.Spark:SetBlendMode("ADD")
		namePlate.UnitFrame.castBar.Spark:SetPoint("CENTER", 0, 3)
		
		namePlate.UnitFrame.castBar.Flash = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY")
		namePlate.UnitFrame.castBar.Flash:SetAllPoints()
		namePlate.UnitFrame.castBar.Flash:SetTexture(G.media.ufbar)
		namePlate.UnitFrame.castBar.Flash:SetBlendMode("ADD")
		
		CastingBarFrame_OnLoad(namePlate.UnitFrame.castBar, nil, false, true)
		namePlate.UnitFrame.castBar:SetScript("OnEvent", CastingBarFrame_OnEvent)
		namePlate.UnitFrame.castBar:SetScript("OnUpdate", CastingBarFrame_OnUpdate)
		namePlate.UnitFrame.castBar:SetScript("OnShow", CastingBarFrame_OnShow)

		namePlate.UnitFrame.RaidTargetFrame = CreateFrame("Frame", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.RaidTargetFrame:SetSize(30, 30)
		namePlate.UnitFrame.RaidTargetFrame:SetPoint("RIGHT", namePlate.UnitFrame.name, "LEFT")

		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon = namePlate.UnitFrame.RaidTargetFrame:CreateTexture(nil, "OVERLAY")
		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon:SetTexture([[Interface\AddOns\AltzUI\media\raidicons.blp]])
		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon:SetAllPoints()
		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon:Hide()
		
		namePlate.UnitFrame.redarrow = namePlate.UnitFrame:CreateTexture(nil, 'OVERLAY')
		namePlate.UnitFrame.redarrow:SetSize(50, 50)
		namePlate.UnitFrame.redarrow:SetTexture(redarrow)
		namePlate.UnitFrame.redarrow:Hide()
		
		namePlate.UnitFrame.icons = CreateFrame("Frame", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.icons:SetPoint("BOTTOM", namePlate.UnitFrame.valueperc, "TOP", 0, 0)
		namePlate.UnitFrame.icons:SetWidth(140)
		namePlate.UnitFrame.icons:SetHeight(25)
		namePlate.UnitFrame.icons:SetFrameLevel(namePlate.UnitFrame:GetFrameLevel() + 2)
	else -- 条形样式
		namePlate.UnitFrame.healthBar = CreateFrame("StatusBar", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.healthBar:SetHeight(8)
		namePlate.UnitFrame.healthBar:SetPoint("LEFT", 0, 0)
		namePlate.UnitFrame.healthBar:SetPoint("RIGHT", 0, 0)
		namePlate.UnitFrame.healthBar:SetStatusBarTexture(G.media.ufbar)
		namePlate.UnitFrame.healthBar:SetMinMaxValues(0, 1)
		
		namePlate.UnitFrame.healthBar.border = F.CreateBDFrame(namePlate.UnitFrame.healthBar, 1)
		T.CreateSD(namePlate.UnitFrame.healthBar.border, 1, 0, 0, 0, 0, -1)
		
		namePlate.UnitFrame.healthBar.bg = namePlate.UnitFrame.healthBar:CreateTexture(nil, 'BORDER')
		namePlate.UnitFrame.healthBar.bg:SetAllPoints(namePlate.UnitFrame.healthBar)
		namePlate.UnitFrame.healthBar.bg:SetColorTexture(.1, .1, .1)
		
		namePlate.UnitFrame.healthBar.value = T.createtext(namePlate.UnitFrame.healthBar, "OVERLAY", fontsize-4, "OUTLINE", "CENTER")
		namePlate.UnitFrame.healthBar.value:SetPoint("BOTTOMRIGHT", namePlate.UnitFrame.healthBar, "TOPRIGHT", 0, -fontsize/3)
		namePlate.UnitFrame.healthBar.value:SetTextColor(1,1,1)
		namePlate.UnitFrame.healthBar.value:SetText("Value")
		
		namePlate.UnitFrame.name = T.createtext(namePlate.UnitFrame, "OVERLAY", fontsize-4, "OUTLINE", "CENTER")
		namePlate.UnitFrame.name:SetPoint("TOPLEFT", namePlate.UnitFrame, "TOPLEFT", 5, -5)
		namePlate.UnitFrame.name:SetPoint("BOTTOMRIGHT", namePlate.UnitFrame, "TOPRIGHT", -5, -15)
		namePlate.UnitFrame.name:SetIndentedWordWrap(false)
		namePlate.UnitFrame.name:SetTextColor(1,1,1)
		namePlate.UnitFrame.name:SetText("Name")
		
		namePlate.UnitFrame.castBar = CreateFrame("StatusBar", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.castBar:Hide()
		namePlate.UnitFrame.castBar.iconWhenNoninterruptible = false
		namePlate.UnitFrame.castBar:SetHeight(8)
		namePlate.UnitFrame.castBar:SetPoint("TOPLEFT", namePlate.UnitFrame.healthBar, "BOTTOMLEFT", 0, -5)
		namePlate.UnitFrame.castBar:SetPoint("TOPRIGHT", namePlate.UnitFrame.healthBar, "BOTTOMRIGHT", 0, -5)
		namePlate.UnitFrame.castBar:SetStatusBarTexture(G.media.ufbar)
		namePlate.UnitFrame.castBar:SetStatusBarColor(0.5, 0.5, 0.5)
		namePlate.UnitFrame.castBar.border = F.CreateBDFrame(namePlate.UnitFrame.castBar, 0.6)
		T.CreateSD(namePlate.UnitFrame.castBar.border, 1, 0, 0, 0, 0, -1)
		
		namePlate.UnitFrame.castBar.bg = namePlate.UnitFrame.castBar:CreateTexture(nil, 'BORDER')
		namePlate.UnitFrame.castBar.bg:SetAllPoints(namePlate.UnitFrame.castBar)
		namePlate.UnitFrame.castBar.bg:SetColorTexture(1, 1, 1, .25)
			
		namePlate.UnitFrame.castBar.Text = T.createtext(namePlate.UnitFrame.castBar, "OVERLAY", fontsize-4, "OUTLINE", "CENTER")
		namePlate.UnitFrame.castBar.Text:SetPoint("CENTER")
		namePlate.UnitFrame.castBar.Text:SetText("Spell Name")
		
		namePlate.UnitFrame.castBar.Icon = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY", 1)
		namePlate.UnitFrame.castBar.Icon:SetPoint("BOTTOMRIGHT", namePlate.UnitFrame.castBar, "BOTTOMLEFT", -4, -1)
		namePlate.UnitFrame.castBar.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
		namePlate.UnitFrame.castBar.Icon:SetSize(23, 23)	
		namePlate.UnitFrame.castBar.Icon.iconborder = F.CreateBG(namePlate.UnitFrame.castBar.Icon)
		namePlate.UnitFrame.castBar.Icon.iconborder:SetDrawLayer("OVERLAY", -1)
		
		namePlate.UnitFrame.castBar.BorderShield = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY", 1)
		namePlate.UnitFrame.castBar.BorderShield:SetAtlas("nameplates-InterruptShield")
		namePlate.UnitFrame.castBar.BorderShield:SetSize(15, 15)
		namePlate.UnitFrame.castBar.BorderShield:SetPoint("LEFT", namePlate.UnitFrame.castBar, "LEFT", 5, -5)

		namePlate.UnitFrame.castBar.Spark = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY")
		namePlate.UnitFrame.castBar.Spark:SetSize(30, 25)
		namePlate.UnitFrame.castBar.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		namePlate.UnitFrame.castBar.Spark:SetBlendMode("ADD")
		namePlate.UnitFrame.castBar.Spark:SetPoint("CENTER", 0, 3)
		
		namePlate.UnitFrame.castBar.Flash = namePlate.UnitFrame.castBar:CreateTexture(nil, "OVERLAY")
		namePlate.UnitFrame.castBar.Flash:SetAllPoints()
		namePlate.UnitFrame.castBar.Flash:SetTexture(G.media.ufbar)
		namePlate.UnitFrame.castBar.Flash:SetBlendMode("ADD")
		
		CastingBarFrame_OnLoad(namePlate.UnitFrame.castBar, nil, false, true)
		namePlate.UnitFrame.castBar:SetScript("OnEvent", CastingBarFrame_OnEvent)
		namePlate.UnitFrame.castBar:SetScript("OnUpdate", CastingBarFrame_OnUpdate)
		namePlate.UnitFrame.castBar:SetScript("OnShow", CastingBarFrame_OnShow)

		namePlate.UnitFrame.RaidTargetFrame = CreateFrame("Frame", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.RaidTargetFrame:SetSize(30, 30)
		namePlate.UnitFrame.RaidTargetFrame:SetPoint("RIGHT", namePlate.UnitFrame.name, "LEFT")

		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon = namePlate.UnitFrame.RaidTargetFrame:CreateTexture(nil, "OVERLAY")
		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon:SetTexture([[Interface\AddOns\AltzUI\media\raidicons.blp]])
		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon:SetAllPoints()
		namePlate.UnitFrame.RaidTargetFrame.RaidTargetIcon:Hide()
		
		namePlate.UnitFrame.redarrow = namePlate.UnitFrame:CreateTexture("$parent_Arrow", 'OVERLAY')
		namePlate.UnitFrame.redarrow:SetSize(50, 50)
		namePlate.UnitFrame.redarrow:SetTexture(redarrow)
		namePlate.UnitFrame.redarrow:SetPoint("CENTER")
		namePlate.UnitFrame.redarrow:Hide()
		
		namePlate.UnitFrame.icons = CreateFrame("Frame", nil, namePlate.UnitFrame)
		namePlate.UnitFrame.icons:SetPoint("BOTTOM", namePlate.UnitFrame, "TOP", 0, 0)
		namePlate.UnitFrame.icons:SetWidth(140)
		namePlate.UnitFrame.icons:SetHeight(25)
		namePlate.UnitFrame.icons:SetFrameLevel(namePlate.UnitFrame:GetFrameLevel() + 2)
	end
	
	namePlate.UnitFrame:EnableMouse(false)
	namePlate.UnitFrame.optionTable = OPTION_TABLE_NONE
end

local function OnNamePlateAdded(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	local unitFrame = namePlate.UnitFrame
	SetUnit(unitFrame, unit)
	SetOptions(unitFrame, unit)
	UpdateAll(unitFrame)
	NamePlateDriverFrame:SetupClassNameplateBars()
end

local function OnNamePlateRemoved(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	SetUnit(namePlate.UnitFrame, nil)
end

local function NamePlates_OnEvent(self, event, ...) 
	if ( event == "VARIABLES_LOADED" ) then
		HideBlizzard()
		RedrawManaBar()
		hooksecurefunc(NamePlateDriverFrame, "SetupClassNameplateBar", MoveClassResource)
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
	elseif event == "PLAYER_TARGET_CHANGED" then
		OnTargetChanged()
	elseif event == "RAID_TARGET_UPDATE" then
		OnRaidTargetUpdate()
	elseif event == "DISPLAY_SIZE_CHANGED" then
		NamePlates_UpdateNamePlateOptions()
	elseif event == "CVAR_UPDATE" then
		local name = ...
		if name == "SHOW_CLASS_COLOR_IN_V_KEY" or name == "SHOW_NAMEPLATE_LOSE_AGGRO_FLASH" then
			NamePlates_UpdateNamePlateOptions()
		end
	elseif ( event == "UNIT_FACTION" ) then
		OnUnitFactionChanged(...)
	elseif combat then
		if event == "PLAYER_REGEN_ENABLED" then
			SetCVar("nameplateShowEnemies", 0)
		elseif event == "PLAYER_REGEN_DISABLED" then
			SetCVar("nameplateShowEnemies", 1)
		elseif event == "PLAYER_ENTERING_WORLD"	then
			if InCombatLockdown() then
				SetCVar("nameplateShowEnemies", 1)
			else
				SetCVar("nameplateShowEnemies", 0)
			end
			NamePlatesFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end
end

local NamePlatesFrame = CreateFrame("Frame", "NamePlatesFrame", UIParent) 
NamePlatesFrame:SetScript("OnEvent", NamePlates_OnEvent)
NamePlatesFrame:RegisterEvent("VARIABLES_LOADED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_CREATED")

NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
NamePlatesFrame:RegisterEvent("CVAR_UPDATE")
NamePlatesFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
NamePlatesFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
NamePlatesFrame:RegisterEvent("RAID_TARGET_UPDATE")
NamePlatesFrame:RegisterEvent("UNIT_FACTION")
NamePlatesFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
NamePlatesFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
NamePlatesFrame:RegisterEvent("PLAYER_ENTERING_WORLD")





