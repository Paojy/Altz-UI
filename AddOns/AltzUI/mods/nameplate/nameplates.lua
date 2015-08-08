local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
if not aCoreCDB["PlateOptions"]["enableplate"] then return end

local texture = "Interface\\AddOns\\AltzUI\\media\\statusbar"
local empty = "Interface\\AddOns\\AltzUI\\media\\empty"
local iconcastbar = "Interface\\AddOns\\AltzUI\\media\\dM3"
local redarrow = "Interface\\AddOns\\AltzUI\\media\\NeonRedArrow"

local numberstylefont = "Interface\\AddOns\\AltzUI\\media\\Infinity Gears.ttf"

local fontsize = 14
local hpHeight = tonumber(aCoreCDB["PlateOptions"]["plateheight"])
local hpWidth = tonumber(aCoreCDB["PlateOptions"]["platewidth"])

local raidiconSize = 36
local cbHeight = 8

local numberstyle = aCoreCDB["PlateOptions"]["numberstyle"]
local combat = aCoreCDB["PlateOptions"]["autotoggleplates"]
local enhancethreat = aCoreCDB["PlateOptions"]["threatplates"]

local auranum = aCoreCDB["PlateOptions"]["plateauranum"]
local auraiconsize = aCoreCDB["PlateOptions"]["plateaurasize"]

local frames = {}

local dummy = function() return end
local numChildren = -1

local NamePlates = CreateFrame("Frame", "aplate", UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

SetCVar("bloatthreat", 0)
SetCVar("bloattest", 0)
SetCVar("bloatnameplates", 0)

--Nameplates we do NOT want to see

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
    button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, -2)
	button.text:SetTextColor(1, 1, 0)
	
	button.count = T.createnumber(button, "OVERLAY", auraiconsize-13, "OUTLINE", "RIGHT")
	button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", -1, 2)
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

local function OnAura(frame, unit)
	if not frame.icons or not frame.unit then return end
	local i = 1
	
	for index = 1, 15 do
		if i <= auranum then			
			local bname, _, _, _, _, bduration, _, bcaster, _, _, bspellid = UnitAura(frame.unit, index, 'HELPFUL')
			local matchbuff = AuraFilter(bcaster, bspellid)
				
			if bname and matchbuff then
				if not frame.icons[i] then
					frame.icons[i] = CreateAuraIcon(frame)
				end
				UpdateAuraIcon(frame.icons[i], frame.unit, index, 'HELPFUL')
				if i ~= 1 then
					frame.icons[i]:SetPoint("LEFT", frame.icons[i-1], "RIGHT", 4, 0)
				end
				i = i + 1
			end
		end
	end

	for index = 1, 20 do
		if i <= auranum then
			local dname, _, _, _, _, dduration, _, dcaster, _, _, dspellid = UnitAura(frame.unit, index, 'HARMFUL')
			local matchdebuff = AuraFilter(dcaster, dspellid)
			
			if dname and matchdebuff then
				if not frame.icons[i] then
					frame.icons[i] = CreateAuraIcon(frame)
				end
				UpdateAuraIcon(frame.icons[i], frame.unit, index, 'HARMFUL')
				if i ~= 1 then
					frame.icons[i]:SetPoint("LEFT", frame.icons[i-1], "RIGHT", 4, 0)
				end
				i = i + 1
			end
		end
	end
	
	frame.iconnumber = i - 1
	
	if i > 1 then
		frame.icons[1]:SetPoint("LEFT", frame.icons, "CENTER", -((auraiconsize+4)*(frame.iconnumber)-4)/2,0)
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

-- Scan all visible nameplate for a known unit
local function CheckUnit_Guid(frame, ...)
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
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
	if numberstyle then
		frame:SetSize(32, 32)
		frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -17)
	else
		frame:SetSize(hpWidth, cbHeight)
		frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -8)
	end
	frame:GetStatusBarTexture():SetHorizTile(true)
	
	if frame.shield:IsShown() then
		frame:SetStatusBarColor(0.78, 0.25, 0.25, 1)
	end
end

--Sometimes castbar likes to randomly resize
local OnValueChanged = function(self, curValue)
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
	frame.hp.name:SetTextColor(1, 1, 1)
	frame.hp:SetScale(1)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.customcolor = nil
	frame.hasClass = nil
	frame.unit = nil
	frame.guid = nil
	frame.iconnumber = nil
	frame.fullhealth = nil
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
	local r,g,b = frame.healthOriginal:GetStatusBarColor()

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
		r,g,b = 254/255, 20/255,  0
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
	if numberstyle then
		frame.hp.name:SetTextColor(r, g, b)
	end
	
	for index, info in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
		if frame.hp.oldname:GetText() == info.name then
			frame.hp:SetStatusBarColor(info.color.r, info.color.g, info.color.b, 2)
			if numberstyle then
				frame.hp.name:SetTextColor(r, g, b)
			end
			frame.customcolor = true
			break
		end
	end
end

--HealthBar OnShow, use this to set variables for the nameplate, also size the healthbar here because it likes to lose it"s
--size settings when it gets reshown
local function UpdateObjects(frame)
	local frame = frame:GetParent()
	
	--Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(hpWidth, hpHeight)	
	frame.hp:SetPoint('TOP', frame, 'TOP', 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)

	--Set the name text
	frame.hp.name:SetText(frame.hp.oldname:GetText())
		
	-- why the fuck does blizzard rescale "useless" npc nameplate to 0.4, its really hard to read ...
	if not numberstyle then 
		while frame.hp:GetEffectiveScale() < 1 do
		frame.hp:SetScale(frame.hp:GetScale() + 0.01)
		frame.cb:SetScale(frame.cb:GetScale() + 0.01)
		end
	end
	
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)
	
	--Setup level text
	local level, elite = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown()
	frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
	
	if frame.hp.boss:IsShown() then
		frame.hp.level:SetText("??")
		frame.hp.level:SetTextColor(0.8, 0.05, 0)
		frame.hp.level:Show()
	else
		frame.hp.level:Show()
		if numberstyle then
			frame.hp.level:SetText(elite and "+" or "")
		else	
			frame.hp.level:SetText(level..(elite and "+" or ""))
		end
	end
	
	if not frame.icons then
		frame.icons = CreateFrame("Frame", nil, frame)
		frame.icons:SetPoint("BOTTOM", frame.hp, "TOP", 0, 15)
		frame.icons:SetWidth(20 + hpWidth)
		frame.icons:SetHeight(25)
		frame.icons:SetFrameLevel(frame.hp:GetFrameLevel() + 2)
		frame:RegisterEvent("UNIT_AURA")
		frame:HookScript("OnEvent", OnAura)
	end
	
	HideObjects(frame)
end

--This is where we create most 'Static' objects for the nameplate, it gets fired when a nameplate is first seen.
local function SkinObjects(frame, nameFrame)
	local hp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbtext, cbshadow = cb:GetRegions()
	local offset = 3
	local backdrop = {edgeFile = G.media.black, edgeSize = 2}
	
	if numberstyle then
		--Health Bar
		frame.healthOriginal = hp
		hp:SetStatusBarTexture(empty)
		
		--Create Health Text
		hp.valueperc = hp:CreateFontString(nil, "OVERLAY")
		hp.valueperc:SetFont(numberstylefont, fontsize*2, "OUTLINE")
		hp.valueperc:SetPoint("BOTTOM", hp, "TOP")
		hp.valueperc:SetTextColor(1,1,1)
		hp.valueperc:SetShadowColor(0, 0, 0, 0.4)
		hp.valueperc:SetShadowOffset(1, -1)
	
		--Create Name Text
		hp.name = T.createtext(hp, "ARTWORK", fontsize-4, "OUTLINE", "CENTER")
		hp.name:SetPoint("TOP", hp, "TOP", 0, -5)
		hp.name:SetTextColor(1,1,1)
		hp.oldname = oldname
		
		--Create Level
		hp.level = hp:CreateFontString(nil, "OVERLAY")	
		hp.level:SetFont(numberstylefont, fontsize, "OUTLINE")
		hp.level:SetPoint("LEFT", hp.name, "RIGHT", 4, 0)
		hp.level:SetShadowOffset(1, -1)	
		
		hp.oldlevel = oldlevel
		hp.boss = bossicon
		hp.elite = elite		
		
		-- threat
		frame.HLthreat = hp:CreateFontString(nil, "OVERLAY")	
		frame.HLthreat:SetFont(numberstylefont, fontsize*2, "OUTLINE")
		frame.HLthreat:SetPoint("RIGHT", hp.valueperc, "LEFT", -2, 0)
		frame.HLthreat:SetShadowOffset(1, -1)
		
		hp.redarrow = hp:CreateTexture(nil, 'OVERLAY', nil)
		hp.redarrow:SetSize(50, 50)
		hp.redarrow:SetTexture(redarrow)
		hp.redarrow:Hide()
		
		hp:HookScript('OnShow', UpdateObjects)
		frame.hp = hp
		
		if not frame.threat then
			frame.threat = threat
		end
		
		cb:SetFrameLevel(1)
		cb:SetStatusBarTexture(iconcastbar)
		
		cb.border = F.CreateBDFrame(cb, 0)
		T.CreateThinSD(cb.border, 1, 0, 0, 0, 1, -2)

		local cbbg = cb:CreateTexture(nil, 'BORDER')
		cbbg:SetAllPoints(cb)
		cbbg:SetTexture(1/3, 1/3, 1/3, .5)
		
		cbicon:ClearAllPoints()
		cbicon:SetPoint("TOP", hp, "BOTTOM", 0, -20)		
		cbicon:SetSize(26, 26)
		cbicon:SetTexCoord(.07, .93, .07, .93)
		cbicon:SetDrawLayer("OVERLAY")
		cb.iconborder = F.CreateBG(cbicon)
		cb.iconborder:SetDrawLayer("OVERLAY",-1)
		cb.icon = cbicon
		
		-- castbar text
		cbtext:ClearAllPoints()
		cbtext:SetPoint("TOP", cbicon, "BOTTOM", 0, -8)	
		cbtext:SetFont(G.norFont, fontsize-2, "OUTLINE")
		cb.cbtext = cbtext	

		cb.shield = cbshield
		cbshield:ClearAllPoints()
		cb:HookScript('OnShow', UpdateCastbar)
		cb:HookScript('OnSizeChanged', OnSizeChanged)
		cb:HookScript('OnValueChanged', OnValueChanged)			
		frame.cb = cb
		
		-- raidicon
		raidicon:ClearAllPoints()
		raidicon:SetPoint("RIGHT", hp.name, "LEFT", -4, 0)
		raidicon:SetSize(raidiconSize, raidiconSize)
		raidicon:SetTexture([[Interface\AddOns\AltzUI\media\raidicons.blp]])
		frame.raidicon = raidicon
		
		--Highlight
		overlay:SetTexture(0,0,0,0)
		overlay:SetAllPoints(hp)	
		frame.overlay = overlay
	else
		--Health Bar
		frame.healthOriginal = hp
		hp:SetFrameLevel(2)
		hp:SetStatusBarTexture(texture)
		hp.border = F.CreateBDFrame(hp, 1)
		T.CreateSD(hp.border, 1, 0, 0, 0, 1, -1)
		
		--Create Level
		hp.level = T.createtext(hp, "ARTWORK", fontsize-2, "OUTLINE", "RIGHT")
		hp.level:SetPoint("BOTTOMRIGHT", hp, "TOPLEFT", 19, -fontsize/3)
		hp.level:SetTextColor(1, 1, 1)
		hp.oldlevel = oldlevel
		hp.boss = bossicon
		hp.elite = elite
		
		--Create Health Text
		hp.value = T.createtext(hp, "ARTWORK", fontsize/2+3, "OUTLINE", "RIGHT")
		if hpHeight > 14 then
			hp.value:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", 0, 0)
		else
			hp.value:SetPoint("TOPRIGHT", hp, "TOPRIGHT", 0, -fontsize/3)
		end
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
		
		hp.threat = hp:CreateTexture(nil, 'ARTWORK', nil, 7)
		hp.threat:SetAllPoints(hp:GetStatusBarTexture())
		hp.threat:SetTexture(texture)
		hp.threat:SetVertexColor(1, 0, 1)
		hp.threat:Hide()
		
		hp.target_ind1 = hp:CreateTexture(nil, 'OVERLAY', nil)
		hp.target_ind1:SetSize(hpHeight+10, hpHeight+10)
		hp.target_ind1:SetPoint("RIGHT", hp, "LEFT")
		hp.target_ind1:SetTexture(G.media.left)
		hp.target_ind1:Hide()

		hp.target_ind2 = hp:CreateTexture(nil, 'OVERLAY', nil)
		hp.target_ind2:SetSize(hpHeight+10, hpHeight+10)
		hp.target_ind2:SetPoint("LEFT", hp, "RIGHT")
		hp.target_ind2:SetTexture(G.media.right)
		hp.target_ind2:Hide()
		
		hp:HookScript('OnShow', UpdateObjects)
		frame.hp = hp
		
		if not frame.threat then
			frame.threat = threat
		end
		
		--Cast Bar
		cb:SetFrameLevel(2)
		cb:SetStatusBarTexture(texture)
		cb.border = F.CreateBDFrame(cb, 0.6)
		T.CreateSD(cb.border, 1, 0, 0, 0, 1, -1)
		
		--Create Cast Name Text
		cbtext:SetFont(G.norFont, fontsize-2, "OUTLINE")
		cbtext:ClearAllPoints()
		cbtext:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 40, -4)
		cbtext:SetTextColor(1, 1, 1)

		--Setup CastBar Icon
		cbicon:ClearAllPoints()
		cbicon:SetPoint("TOPLEFT", cb, "TOPLEFT", 10, 3)		
		cbicon:SetSize(22, 22)
		cbicon:SetTexCoord(.07, .93, .07, .93)
		cbicon:SetDrawLayer("OVERLAY")
		cb.icon = cbicon
		cb.iconborder = F.CreateBG(cb.icon)
		cb.iconborder:SetDrawLayer("OVERLAY",-1)
		
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
		raidicon:SetSize(raidiconSize, raidiconSize)
		raidicon:SetTexture([[Interface\AddOns\AltzUI\media\raidicons.blp]])
		frame.raidicon = raidicon
	end
	
	--Hide Old Stuff
	QueueObject(frame, cbshadow)
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

local function UpdateThreat(frame, elapsed)
	if numberstyle then
		if frame.threat:IsShown() then
			local _, val = frame.threat:GetVertexColor()
			if(val > 0.7) then
				frame.HLthreat:SetTextColor(1, 1, 0)
				frame.HLthreat:SetText(">")
			else
				frame.HLthreat:SetTextColor(1, 0, 0)
				frame.HLthreat:SetText(">")
			end
		else
			frame.HLthreat:SetText("")
		end
	else
		if frame.threat:IsShown() and not frame.customcolor then
			frame.hp.threat:Show()
		else
			frame.hp.threat:Hide()
		end
	end
end

--When becoming intoxicated blizzard likes to re-show the old level text, this should fix that
local function HideDrunkenText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
	if frame and frame.hp.elite and frame.hp.elite:IsShown() then
		frame.hp.elite:Hide()
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
		if not numberstyle then
			frame.hp.value:SetText(T.ShortValue(valueHealth))
		end
		frame.hp.valueperc:SetText(string.format("%d", math.floor((valueHealth/maxHealth)*100)))
		frame.fullhealth = false
	else
		if not numberstyle then
			frame.hp.value:SetText("")
		end
		frame.hp.valueperc:SetText("")
		frame.fullhealth = true
	end
end

local function ShowTargetInd(frame)
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
	--if frame.guid == UnitGUID("target") and frame.guid ~= nil then
		if numberstyle then
			frame.hp.redarrow:Show()
		else
			frame.hp.target_ind1:Show()
			frame.hp.target_ind2:Show()
		end
	else
		if numberstyle then
			frame.hp.redarrow:Hide()
		else
			frame.hp.target_ind1:Hide()
			frame.hp.target_ind2:Hide()
		end
	end
	
	if numberstyle then
		if frame.iconnumber and frame.iconnumber > 0 then
			frame.hp.redarrow:SetPoint("BOTTOM", frame.hp, "TOP", 0, auraiconsize+15)
		elseif not frame.fullhealth then
			frame.hp.redarrow:SetPoint("BOTTOM", frame.hp, "TOP", 0, 10)
		else
			frame.hp.redarrow:SetPoint("BOTTOM", frame.hp, "TOP", 0, -8)
		end
	end
end

--Run a function for all visible nameplates
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame and frame:GetParent():IsShown() then
			functionToRun(frame, ...)
		end
	end
end

--Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)

		if frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d") then
			local child1, child2 = frame:GetChildren()
			SkinObjects(child1, child2)
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

	ForEachPlate(ShowHealth)
	ForEachPlate(HideDrunkenText)
	ForEachPlate(Colorize)
	ForEachPlate(CheckUnit_Guid)
	ForEachPlate(ShowTargetInd)
	
	if(self.elapsed and self.elapsed > 0.2) then
		if enhancethreat then
			ForEachPlate(UpdateThreat, self.elapsed)
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

--Only show nameplates when in combat
if combat then
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
	if combat then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	
	if enhancethreat then
		SetCVar("threatWarning", 3)
	end
	
	NamePlates:UnregisterEvent("PLAYER_ENTERING_WORLD")
end