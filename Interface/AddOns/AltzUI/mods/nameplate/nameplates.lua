local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
if not aCoreCDB.enableplate then return end

local texture = "Interface\\AddOns\\AltzUI\\media\\statusbar"
local fontsize = 14
local hpHeight = aCoreCDB.plateheight
local hpWidth = aCoreCDB.platewidth

local iconSize = 32		--Size of all Icons, RaidIcon/Castbar Icon
local cbHeight = 8

local combat = aCoreCDB.autotoggleplates
local enhancethreat = aCoreCDB.threatplates

local enabledebuff = aCoreCDB.platedebuff
local enablebuff = aCoreCDB.platebuff
local auranum = aCoreCDB.plateauranum
local auraiconsize = aCoreCDB.plateaurasize

local frames = {}
local BuffWhiteList = G.BuffWhiteList
local DebuffBlackList = G.DebuffBlackList
local DebuffWhiteList = G.DebuffWhiteList

local dummy = function() return end
local numChildren = -1

local NamePlates = CreateFrame("Frame", "aplate", UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

SetCVar("bloatthreat", 0)
SetCVar("bloattest", 0)
SetCVar("bloatnameplates", 0)

--Nameplates we do NOT want to see
local PlateBlacklist = {
	--Shaman Totems (Ones that don't matter)
	["Earth Elemental Totem"] = true,
	["Fire Elemental Totem"] = true,
	["Fire Resistance Totem"] = true,
	["Flametongue Totem"] = true,
	["Frost Resistance Totem"] = true,
	["Healing Stream Totem"] = true,
	["Magma Totem"] = true,
	["Mana Spring Totem"] = true,
	["Nature Resistance Totem"] = true,
	["Searing Totem"] = true,
	["Stoneclaw Totem"] = true,
	["Stoneskin Totem"] = true,
	["Strength of Earth Totem"] = true,
	["Windfury Totem"] = true,
	["Totem of Wrath"] = true,
	["Wrath of Air Totem"] = true,

	--Army of the Dead
	["Army of the Dead Ghoul"] = true,
}

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
			object.SetTexture = dummy
		elseif (object:GetObjectType() == 'FontString') then
			object.ClearAllPoints = dummy
			object.SetFont = dummy
			object.SetPoint = dummy
			object:Hide()
			object.Show = dummy
			object.SetText = dummy
			object.SetShadowOffset = dummy
		else
			object:Hide()
			object.Show = dummy
		end
	end
end

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

-- Create aura icons
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
    button.text:SetPoint("CENTER", button, "BOTTOM")
	button.text:SetTextColor(1, 1, 0)
	
	button.count = T.createnumber(button, "OVERLAY", auraiconsize-13, "OUTLINE", "RIGHT")
	button.count:SetPoint("CENTER", button, "TOPRIGHT")
	button.count:SetTextColor(.4, .95, 1)
	
	return button
end

-- Update an aura icon
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

local function DebuffFliter(caster, spellid)
	if DebuffBlackList[spellid] then
		return nil
	elseif caster == "player" then
		return true
	elseif DebuffWhiteList[spellid] then
		return true
	end
end

local function BuffFliter(spellid)
	if BuffWhiteList[spellid] then
		return true
	else
		return nil
	end
end

local function OnAura(frame, unit)
	if not frame.icons or not frame.unit then return end
	local i = 1
	if enablebuff then
		for index = 1, 15 do
			if i > auranum then return end
				
			local bname, _, _, _, _, bduration, _, bcaster, _, _, bspellid = UnitAura(frame.unit, index, 'HELPFUL')
			local matchbuff = BuffFliter(bspellid)
				
			if bduration and matchbuff then
				if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
				if i == 1 then frame.icons[i]:SetPoint("RIGHT", frame.icons, "RIGHT") end
				if i ~= 1 and i <= auranum then frame.icons[i]:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -4, 0) end
				UpdateAuraIcon(frame.icons[i], frame.unit, index, 'HELPFUL')
				i = i + 1
			end
		end
	end
	if enabledebuff then
		for index = 1, 20 do
			if i > auranum then return end
			
			local dname, _, _, _, _, dduration, _, dcaster, _, _, dspellid = UnitAura(frame.unit, index, 'HARMFUL')
			local matchdebuff = DebuffFliter(dcaster, dspellid)
			
			if dduration and matchdebuff then
				if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
				if i == 1 then frame.icons[i]:SetPoint("RIGHT", frame.icons, "RIGHT") end
				if i ~= 1 and i <= auranum then frame.icons[i]:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -4, 0) end
				UpdateAuraIcon(frame.icons[i], frame.unit, index, 'HARMFUL')
				i = i + 1
			end
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

-- Scan all visible nameplate for a known unit
local function CheckUnit_Guid(frame, ...)
	if UnitExists("target") and frame:GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end
end

-- Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end

	if frame.guid == destGUID then
		for _, icon in ipairs(frame.icons) do
			if icon.spellID == spellID then
				icon:Hide()
			end
		end
	end
end

--Color the castbar depending on if we can interrupt or not, 
--also resize it as nameplates somehow manage to resize some frames when they reappear after being hidden
local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(hpWidth, cbHeight)
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -8)
	frame:GetStatusBarTexture():SetHorizTile(true)
	if(frame.shield:IsShown()) then
		frame:SetStatusBarColor(0.78, 0.25, 0.25, 1)
	end
end

--Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function UpdateCastText(frame, curValue)
	local minValue, maxValue = frame:GetMinMaxValues()
	
	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		frame.name:SetText(select(1, (UnitChannelInfo("target"))))
	end
	
	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		frame.name:SetText(select(1, (UnitCastingInfo("target"))))
	end
end

--Sometimes castbar likes to randomly resize
local OnValueChanged = function(self, curValue)
	UpdateCastText(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

--Sometimes castbar likes to randomly resize
local OnSizeChanged = function(self)
	self.needFix = true
end

--We need to reset everything when a nameplate it hidden, this is so theres no left over data when a nameplate gets reshown for a differant mob.
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.hasClass = nil
	frame.unit = nil
	frame.guid = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	frame.hp.valueperc:SetTextColor(1,1,1)
	
	if frame.icons then
		for _, icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end
	
	frame:SetScript("OnUpdate",nil)
end

--Color Nameplate
local function Colorize(frame)
	local r,g,b = frame.hp:GetStatusBarColor()

	for class, color in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.hp:SetStatusBarColor(G.Ccolors[class].r, G.Ccolors[class].g, G.Ccolors[class].b)
			frame.hasClass = true
			frame.isFriendly = false
			return
		end
	end
	
	if g+b == 0 then -- hostile
		r,g,b = 254/255, 144/255,  46/255
		frame.isFriendly = false
	elseif r+b == 0 then -- friendly npc
		r,g,b = 19/255, 213/255, 29/255
		frame.isFriendly = true
	elseif r+g > 1.95 then -- neutral
		r,g,b = 240/255, 250/255, 50/255
		frame.isFriendly = false
	elseif r+g == 0 then -- friendly player
		r,g,b = 0/255,  100/255, 230/255
		frame.isFriendly = true
	else -- enemy player
		frame.isFriendly = false
	end
	frame.hasClass = false
	
	frame.hp:SetStatusBarColor(r,g,b)
end

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it"s
--size settings when it gets reshown
local function UpdateObjects(frame)
	local frame = frame:GetParent()
	
	local r, g, b = frame.hp:GetStatusBarColor()

	--Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(hpWidth, hpHeight)	
	frame.hp:SetPoint('TOP', frame, 'TOP', 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
			
	--Colorize Plate
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.25)
	
	--Set the name text
	frame.hp.name:SetText(frame.hp.oldname:GetText())
	
	--Setup level text
	local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
	frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
	
	if frame.hp.boss:IsShown() then
		frame.hp.level:SetText("??")
		frame.hp.level:SetTextColor(0.8, 0.05, 0)
		frame.hp.level:Show()
	else
		frame.hp.level:SetText(level..(elite and "+" or ""))
		frame.hp.level:Show()
	end
	
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)

	if enablebuff or enabledebuff then
		if frame.icons then return end
		frame.icons = CreateFrame("Frame", nil, frame)
		frame.icons:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, 15)
		frame.icons:SetWidth(20 + hpWidth)
		frame.icons:SetHeight(25)
		frame.icons:SetFrameLevel(frame.hp:GetFrameLevel() + 2)
		frame:RegisterEvent("UNIT_AURA")
		frame:HookScript("OnEvent", OnAura)
	end
	
	HideObjects(frame)
end

--This is where we create most 'Static' objects for the nameplate, it gets fired when a nameplate is first seen.
local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()

	--Health Bar
	frame.healthOriginal = hp
	hp:SetFrameLevel(2)
	hp:SetStatusBarTexture(texture)
	hp.border = F.CreateBDFrame(hp, 0.6)
	F.CreateSD(hp.border, 3, 0, 0, 0, 1, -1)
	
	--Create Level
	hp.level = T.createtext(hp, "ARTWORK", fontsize-2, "OUTLINE", "RIGHT")
	hp.level:SetPoint("BOTTOMRIGHT", hp, "TOPLEFT", 19, -fontsize/3)
	hp.level:SetTextColor(1, 1, 1)
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite
	
	--Create Health Text
	hp.value = T.createtext(hp, "ARTWORK", fontsize/2+3, "OUTLINE", "RIGHT")
	hp.value:SetPoint("TOPRIGHT", hp, "TOPRIGHT", 0, -fontsize/3)
	hp.value:SetTextColor(0.5,0.5,0.5)

	--Create Health Pecentage Text
	hp.valueperc = T.createtext(hp, "ARTWORK", fontsize, "OUTLINE", "RIGHT")
	hp.valueperc:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 0, -fontsize/3)
	hp.valueperc:SetTextColor(1,1,1)
	
	--Create Name Text
	hp.name = T.createtext(hp, "ARTWORK", fontsize-2, "OUTLINE", "LEFT")
	hp.name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', -30, -fontsize/3)
	hp.name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', 17, -fontsize/3)
	hp.name:SetTextColor(1,1,1)
	hp.oldname = oldname
	
	hp.hpbg = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1,1,1,0.25) 		
	
	hp:HookScript('OnShow', UpdateObjects)
	frame.hp = hp
	
	--Cast Bar
	cb:SetFrameLevel(2)
	cb:SetStatusBarTexture(texture)
	cb.border = F.CreateBDFrame(cb, 0.6)
	F.CreateSD(cb.border, 3, 0, 0, 0, 1, -1)
	
	--Create Cast Time Text
	cb.time = T.createtext(cb, "OVERLAY", fontsize, "OUTLINE", "RIGHT")
	cb.time:SetPoint("RIGHT", cb, "LEFT", -1, 0)
	cb.time:SetTextColor(1, 1, 1)

	--Create Cast Name Text
	cb.name = T.createtext(cb, "OVERLAY", fontsize, "OUTLINE", "CENTER")
	cb.name:SetPoint("TOP", cb, "BOTTOM", 0, -3)
	cb.name:SetTextColor(1, 1, 1)

	--Setup CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)		
	cbicon:SetSize(iconSize, iconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	cb.iconborder = F.CreateBDFrame(cb.icon, 0.6)
	F.CreateSD(cb.iconborder, 3, 0, 0, 0, 1, -1)
	
	cb.shield = cbshield
	cbshield:ClearAllPoints()
	cbshield:SetPoint("TOP", cb, "BOTTOM")
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)			
	frame.cb = cb
	
	--Highlight
	overlay:SetTexture(1,1,1,0.15)
	overlay:SetAllPoints(hp)	
	frame.overlay = overlay

	--Reposition and Resize RaidIcon
	raidicon:ClearAllPoints()
	raidicon:SetDrawLayer("OVERLAY", 7)
	raidicon:SetPoint("RIGHT", hp, "LEFT", -5, 0)
	raidicon:SetSize(iconSize, iconSize)
	raidicon:SetTexture([[Interface\AddOns\AltzUI\media\raidicons.blp]])
	frame.raidicon = raidicon
	
	--Hide Old Stuff
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)
	
	UpdateObjects(hp)
	UpdateCastbar(cb)
	
	frame:HookScript('OnHide', OnHide)
	frames[frame] = true
end

local goodR, goodG, goodB = 0, 1, 0
local badR, badG, badB = 1, 0, 0
local transitionR, transitionG, transitionB = 0, 1, 0
local function UpdateThreat(frame, elapsed)
	frame.hp:Show()
	if frame.hasClass == true then return end
	
	if enhancethreat ~= true then
		frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	else
		if not frame.region:IsShown() then
			if InCombatLockdown() and frame.isFriendly ~= true then
				--No Threat
				frame.hp:SetStatusBarColor(goodR, goodG, goodB)
				frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.25)
			else
				--Set colors to their original, not in combat
				frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.25)
			end
		else
			--Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.region:GetVertexColor()
			if g + b == 0 then
				--Have Threat
				frame.hp:SetStatusBarColor( badR, badG, badB)
				frame.hp.hpbg:SetTexture(badR, badG, badB, 0.25)
			else
				--Losing/Gaining Threat
				frame.hp:SetStatusBarColor( transitionR, transitionG, transitionB)	
				frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.25)
			end
		end
	end
end

--Create our blacklist for nameplates, so prevent a certain nameplate from ever showing
local function CheckBlacklist(frame, ...)
	if PlateBlacklist[frame.hp.name:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end

--When becoming intoxicated blizzard likes to re-show the old level text, this should fix that
local function HideDrunkenText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
end

--Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- show current health value
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100
	
	-- Match values
	frame.hp:SetValue(valueHealth - 1)	--Bug Fix 4.1
	frame.hp:SetValue(valueHealth)
	
	if d < 25 then
		frame.hp.valueperc:SetTextColor(0.8, 0.05, 0)
	elseif d < 30 then
		frame.hp.valueperc:SetTextColor(0.95, 0.7, 0.25)
	else
		frame.hp.valueperc:SetTextColor(1, 1, 1)
	end
	
	if valueHealth ~= maxHealth then
		frame.hp.value:SetText(T.ShortValue(valueHealth))
		frame.hp.valueperc:SetText(string.format("%d", math.floor((valueHealth/maxHealth)*100)))
	else
		frame.hp.value:SetText("")
		frame.hp.valueperc:SetText("")
	end
end

--Run a function for all visible nameplates
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame:IsShown() then
			functionToRun(frame, ...)
		end
	end
end

--Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		
		if(not frames[frame] and (frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == "Texture") then
			SkinObjects(frame)
			frame.region = region
			frame.isSkinned = true
		end
	end
end

--Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
NamePlates:SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if(self.elapsed and self.elapsed > 0.2) then
		ForEachPlate(UpdateThreat, self.elapsed)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
	
	ForEachPlate(ShowHealth)
	ForEachPlate(CheckBlacklist)
	ForEachPlate(HideDrunkenText)
	ForEachPlate(CheckUnit_Guid)
end)

if enablebuff or enabledebuff then
	NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

--Only show nameplates when in combat
if combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	
	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	
	if enhancethreat == true then
		SetCVar("threatWarning", 3)
	end
	
    local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies");
	local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends");
	
        if SHOW_ENEMIES then
            SetCVar("nameplateShowEnemies", 0);
		end
        if SHOW_FRIENDS then
            SetCVar("nameplateShowFriends", 0);
        end
end