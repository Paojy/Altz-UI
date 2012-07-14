local fontsize = 14
local texture = "Interface\\AddOns\\aCore\\media\\statusbar"

local hpHeight = 14
local hpWidth = 150
local iconSize = 32		--Size of all Icons, RaidIcon/ClassIcon/Castbar Icon
local cbHeight = 8
local cbWidth = 150

local combat = true
local enhancethreat = true

local frames = {}
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

--Color the castbar depending on if we can interrupt or not, 
--also resize it as nameplates somehow manage to resize some frames when they reappear after being hidden
local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(cbWidth, cbHeight)
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
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	frame.hp.valueperc:SetTextColor(1,1,1)

	frame:SetScript("OnUpdate",nil)
end

--Color Nameplate
local function Colorize(frame)
	local r,g,b = frame.hp:GetStatusBarColor()
	
	for class, color in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
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

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it's
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

	HideObjects(frame)
end

--This is where we create most 'Static' objects for the nameplate, it gets fired when a nameplate is first seen.
local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()

	--Health Bar
	frame.healthOriginal = hp
	hp:SetFrameLevel(1)
	hp:SetStatusBarTexture(texture)
	createnameplateBD(hp, 0, 0, 0, 0.3, 1)
	
	--Create Level
	hp.level = createtext(hp, fontsize-2, "OUTLINE", false)
	hp.level:SetPoint("BOTTOMRIGHT", hp, "TOPLEFT", 19, -fontsize/3)
	hp.level:SetJustifyH("RIGHT")
	hp.level:SetTextColor(1, 1, 1)
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite
	
	--Create Health Text
	hp.value = createtext(hp, fontsize/2+3, "OUTLINE", false)
	hp.value:SetPoint("TOPRIGHT", hp, "TOPRIGHT", 0, -fontsize/3)
	hp.value:SetJustifyH("RIGHT")
	hp.value:SetTextColor(0.5,0.5,0.5)

	--Create Health Pecentage Text
	hp.valueperc = createtext(hp, fontsize, "OUTLINE", false)
	hp.valueperc:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 0, -fontsize/3)
	hp.valueperc:SetJustifyH("RIGHT")
	hp.valueperc:SetTextColor(1,1,1)
	
	--Create Name Text
	hp.name = createtext(hp, fontsize-2, "OUTLINE", false)
	hp.name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', -30, -fontsize/3)
	hp.name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', 17, -fontsize/3)
	hp.name:SetTextColor(1,1,1)
	hp.name:SetJustifyH("LEFT")
	hp.oldname = oldname
	
	hp.hpbg = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1,1,1,0.25) 		
	
	hp:HookScript('OnShow', UpdateObjects)
	frame.hp = hp
	
	--Cast Bar
	cb:SetFrameLevel(1)
	cb:SetStatusBarTexture(texture)
	createnameplateBD(cb, 0, 0, 0, 0.3, 1)
	
	--Create Cast Time Text
	cb.time = createtext(cb, fontsize, "OUTLINE", false)
	cb.time:SetPoint("RIGHT", cb, "LEFT", -1, 0)
	cb.time:SetJustifyH("RIGHT")
	cb.time:SetTextColor(1, 1, 1)

	--Create Cast Name Text
	cb.name = createtext(cb, fontsize, "OUTLINE", false)
	cb.name:SetPoint("TOP", cb, "BOTTOM", 0, -3)
	cb.name:SetJustifyH("CENTER")
	cb.name:SetTextColor(1, 1, 1)

	--Setup CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)		
	cbicon:SetSize(iconSize, iconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	createnameplateBD(cb, 0, 0, 0, 0.3, 1, cb.icon)

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
	raidicon:SetPoint("BOTTOM", hp, "TOP", 0, 16)
	raidicon:SetSize(iconSize*1.4, iconSize*1.4)
	raidicon:SetTexture([[Interface\AddOns\aCore\media\raidicons.blp]])
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
		frame.hp.value:SetText(ShortValue(valueHealth))
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
		
		if(not frames[frame] and (frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d")) and region and region:GetObjectType() == 'Texture') then
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
end)

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