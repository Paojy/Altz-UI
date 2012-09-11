local addon, ns = ...
local font = GameFontHighlight:GetFont()
local Ccolor = GetClassColor()
local aMedia = "Interface\\AddOns\\aCore\\media\\"
local blank = "Interface\\Buttons\\WHITE8x8"
local ver = GetAddOnMetadata("aCore", "Version")
--====================================================--
--[[                -- shadow --                    ]]--
--====================================================--	
local PShadow = CreateFrame("Frame", nil, UIParent)
PShadow:SetFrameStrata("BACKGROUND")
PShadow:SetAllPoints()
PShadow:SetBackdrop({bgFile = aMedia.."shadow"})
PShadow:SetBackdropColor(0, 0, 0, 0.3)

--====================================================--
--[[                -- panels --                    ]]--
--====================================================--	
local function createpanel(panel, pos, y)
	panel = CreateFrame("Frame", nil, UIParent)
	panel:SetFrameStrata("BACKGROUND")
	panel:SetPoint(pos, 0, y)
	panel:SetPoint("LEFT", UIParent, "LEFT", 10, 0)
	panel:SetPoint("RIGHT", UIParent, "RIGHT", -10, 0)
	panel:SetHeight(7)
	creategrowBD(panel, 0, 0, 0, 0.3, 1)
	return panel
end

local toppanel = createpanel(self, "TOP", -3)
local bottompanel = createpanel(self, "BOTTOM", 3)

local function createlittlepanel(panel, width, text)
	panel = CreateFrame("Frame", nil, UIParent)
	panel:SetFrameStrata("LOW")
	panel:SetFrameLevel(3)
	panel:SetSize(width, 4)
	panel.text = createtext(panel, "HIGHLIGHT", 14, "OUTLINE", "CENTER")
	panel.text:SetAllPoints()
	panel.text:SetText(text)
	creategradient(panel, Ccolor.r, Ccolor.g, Ccolor.b, 3)
	creategrowBD(panel, 0.3, 0.3, 0.3, 1, 1)
	return panel
end

--====================================================--
--[[          -- Calendar toggle panel --           ]]--
--====================================================--
local infopanel = createlittlepanel(self, 130, "|cffFF3E96C|ralendar")
infopanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -10)
infopanel:SetScript("OnMouseUp", function() ToggleCalendar() end)

--====================================================--
--[[           -- XP bar and Info bar --            ]]--
--====================================================--
BNToastFrame:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 10, -20)

local xpbar = CreateFrame("StatusBar", "ExperienceBar", UIParent)
xpbar:SetFrameStrata("LOW")
xpbar:SetSize(195,4)
xpbar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 150, -10)
createbargradient(xpbar, Ccolor.r, Ccolor.g, Ccolor.b, 3)
creategrowBD(xpbar, 0.3, 0.3, 0.3, 1, 1)

local function CommaValue(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if (k==0) then
			break
		end
	end
	return formatted
end

local _G = getfenv(0)
function xprptoolitp()
	if not InCombatLockdown() then
		GameTooltip:SetOwner(xpbar, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, 0)
	
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		local restXP = GetXPExhaustion()
		local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
	
		if UnitLevel("player") < MAX_PLAYER_LEVEL then
			GameTooltip:AddDoubleLine("Current: ", string.format("%s/%s (%d%%)", CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
			GameTooltip:AddDoubleLine("Remaining: ", string.format("%s", CommaValue(maxXP-XP)), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
			if restXP then GameTooltip:AddDoubleLine("Rested: ", string.format("|cffb3e1ff%s (%d%%)", CommaValue(restXP), restXP/maxXP*100), Ccolor.r, Ccolor.g, Ccolor.b) end
		end
	
		if name and not UnitLevel("player") == MAX_PLAYER_LEVEL then
			GameTooltip:AddLine(" ")
		end

		if name then
			GameTooltip:AddLine(name.."  (".._G["FACTION_STANDING_LABEL"..rank]..")", Ccolor.r, Ccolor.g, Ccolor.b)
			GameTooltip:AddDoubleLine("Rep:", string.format("%s/%s (%d%%)", CommaValue(value-minRep), CommaValue(maxRep-minRep), (value-minRep)/(maxRep-minRep)*100), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
			GameTooltip:AddDoubleLine("Remaining:", string.format("%s", CommaValue(maxRep-value)), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
		end	
	
		GameTooltip:Show()
	end
end

function xpbar:updateOnevent()
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
   	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		xpbar:SetMinMaxValues(min(0, XP), maxXP)
		xpbar:SetValue(XP)
	else
		xpbar:SetMinMaxValues(minRep, maxRep)
		xpbar:SetValue(value)
	end
end

xpbar:SetScript("OnEnter", xprptoolitp)
xpbar:SetScript("OnLeave", function() GameTooltip:Hide() end)
xpbar:SetScript("OnEvent", xpbar.updateOnevent)

xpbar:RegisterEvent("PLAYER_XP_UPDATE")
xpbar:RegisterEvent("UPDATE_FACTION")
xpbar:RegisterEvent("PLAYER_LEVEL_UP")
xpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
xpbar:RegisterEvent("PLAYER_LOGIN")

local infobar = CreateFrame("Frame", nil, UIParent) -- Center Frame
infobar:SetFrameStrata("LOW")
infobar:SetSize(200, 20)
infobar:SetAlpha(.6)
infobar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 150, -13)

Minimap:HookScript('OnEnter', function() infobar:SetAlpha(1) end)
Minimap:HookScript('OnLeave', function() infobar:SetAlpha(.6) end)

local Ctext = createtext(infobar, "OVERLAY", 12, "OUTLINE", "LEFT")
Ctext:SetPoint"LEFT"

-- Hex Color
local Hex
do 
	Hex = function(color)
        return format("|cff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
   	end
end

-- Format String
local memFormat = function(num)
	if num > 1024 then
		return format("%.2f mb", (num / 1024))
	else
		return format("%.1f kb", floor(num))
	end
end

-- Ordering
local AddonCompare = function(a, b)
	return a.memory > b.memory
end

-- Calculates Lower Durability
local SLOTS = {}
for _,slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"})
do SLOTS[slot] = GetInventorySlotInfo(slot .. "Slot") end
function Durability()
	local l = 1
	for slot,id in pairs(SLOTS) do
		local d, md = GetInventoryItemDurability(id)
		if d and md and md ~= 0 then
			l = math.min(d/md, l)
		end
	end
	return format("%d",l*100)
end

-- Tooltips
local nraddons = 20
function memorytooltip()
	if not InCombatLockdown() then -- Don't Show in Combat
		local addons, total, nr, name = {}, 0, 0
		local memory, entry
		local BlizzMem = collectgarbage("count")
			
		GameTooltip:SetOwner(infobar, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, 0)
		GameTooltip:AddLine("Top "..nraddons.." AddOns", Ccolor.r, Ccolor.g, Ccolor.b)
		GameTooltip:AddLine(" ")	
			
		UpdateAddOnMemoryUsage()
		for i = 1, GetNumAddOns() do
			if (GetAddOnMemoryUsage(i) > 0 ) then
				memory = GetAddOnMemoryUsage(i)
				entry = {name = GetAddOnInfo(i), memory = memory}
				table.insert(addons, entry)
				total = total + memory
			end
		end
		table.sort(addons, AddonCompare)
		for _, entry in pairs(addons) do
			if nr < nraddons then
				GameTooltip:AddDoubleLine(entry.name, memFormat(entry.memory), 1, 1, 1, 0.75, 0.75, 0.75)
				nr = nr+1
			end
		end

		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("UI Memory usage", memFormat(total), Ccolor.r, Ccolor.g, Ccolor.b, Ccolor.r, Ccolor.g, Ccolor.b)
		GameTooltip:AddDoubleLine("Total incl. Blizzard", memFormat(BlizzMem), Ccolor.r, Ccolor.g, Ccolor.b, Ccolor.r, Ccolor.g, Ccolor.b)
		GameTooltip:Show()
	end
end

-- Update Function
local hour, fps, lag, dur
local refresh_timer = 0
function infobar:updateOntime(elapsed)
	refresh_timer = refresh_timer + elapsed -- Only update this values every refresh_timer seconds
	if refresh_timer > 1 then -- Updates each X seconds	
		dur = (Durability().."%sdur|r   "):format(Hex(Ccolor))
		fps = (floor(GetFramerate()).."%sfps|r   "):format(Hex(Ccolor))
		lag = (select(3, GetNetStats()).."%sms|r   "):format(Hex(Ccolor))
		hour = date("%H:%M")
		
		Ctext:SetText(dur..fps..lag..hour) -- Center Anchored Text
		
		refresh_timer = 0 -- Reset Timer
	end
end

infobar:SetScript("OnEnter", function(self) memorytooltip() end)
infobar:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
infobar:SetScript("OnUpdate", infobar.updateOntime)

--====================================================--
--[[              -- buff panel --                  ]]--
--====================================================--
local buffpanel = createlittlepanel(self, 330, "")
buffpanel:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -15, -10)

--====================================================--
--[[              -- chat panel --                  ]]--
--====================================================--
local blpanel = createlittlepanel(self, 330, "")

blpanel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 15, 10)

blpanel.text:SetText("|cff00B2EEF|rriends   |cff00EE00G|ruild")
blpanel:SetScript("OnMouseUp", function(self, button) 
	if button == "RightButton" then
		if IsInGuild() then 
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end 
			GuildFrame_Toggle() 
		else 
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end 
			LookingForGuildFrame_Toggle() 
		end
	else
		ToggleFriendsFrame(1)
	end
end)
--====================================================--
--[[   -- world channel button only for zhCN --     ]]--
--====================================================--
local channels = {GetChannelList()}
local customChannelName = "大脚世界频道"
local isInCustomChannel = false

local ToggleWorldChannel = function(button)
	if isInCustomChannel then
		LeaveChannelByName(customChannelName)
		print("|cffFF0000Leave|r 大脚世界频道")
		button:UnlockHighlight()
		isInCustomChannel = false	  
	else
		JoinPermanentChannel(customChannelName,nil,1)
		ChatFrame_AddChannel(ChatFrame1,customChannelName)
		ChatFrame_RemoveMessageGroup(ChatFrame1,"CHANNEL")
		print("|cff7FFF00Join|r 大脚世界频道")
		button:LockHighlight()
		isInCustomChannel = true
	end
end

local wcbutton = CreateFrame("Button", "wcButton", blpanel)
wcbutton:SetPoint("LEFT", 20, 0)
wcbutton:SetFrameStrata("LOW")
wcbutton:SetFrameLevel(4)
wcbutton:SetSize(25, 25)
wcbutton:SetNormalTexture("Interface\\HELPFRAME\\ReportLagIcon-Chat")
wcbutton:SetHighlightTexture("Interface\\HELPFRAME\\ReportLagIcon-Chat", "ADD")
wcbutton:SetPushedTextOffset(3, -3)
wcbutton:Hide()

if GetLocale() == "zhCN" then
	wcbutton:Show()
	for i = 1, #channels do
		if channels[i] == customChannelName then
			isInCustomChannel = true
			wcbutton:LockHighlight()
		end
	end
	wcbutton:SetScript("OnClick", function(self) ToggleWorldChannel(self) end)
end

--====================================================--
--[[            -- center panel --                  ]]--
--====================================================--	
local centerpanel = createlittlepanel(self, 345, "")
centerpanel:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 10)
centerpanel:SetFrameStrata("HIGH")
FrameFader(centerpanel)

centerpanel:RegisterEvent("PLAYER_LOGIN")
centerpanel:SetScript("OnEvent", function(self)
	if aCoreCDB == nil then return end
	if aCoreCDB.fade then
		self.text:SetText("UI Fading: |cff7FFF00ON|r")
	else
		self.text:SetText("UI Fading: |cffFF0000OFF|r")
	end
	centerpanel:SetAlpha(0)
end)

centerpanel:SetScript("OnMouseUp", function(self)
	if aCoreCDB == nil then return end
	if aCoreCDB.fade then
		aCoreCDB.fade = false
		self.text:SetText("UI Fading: |cffFF0000OFF|r")
	else
		aCoreCDB.fade = true
		self.text:SetText("UI Fading: |cff7FFF00ON|r")
	end
end)
--====================================================--
--[[             -- bottomright panel --            ]]--
--====================================================--		
local brpanel = createlittlepanel(self, 330, "|cffFFFF00B|rags   |cffBF3EFFD|ramage Meter")
brpanel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 10)

local function toggletinydps()
	if IsAddOnLoaded("TinyDPS") then
		if tdpsFrame:IsVisible() then
			CloseDropDownMenus()
			tdps.hidePvP, tdps.hideSolo, tdps.hideIC, tdps.hideOOC = true, true, true, true
			tdpsFrame:Hide() 
		else
			CloseDropDownMenus()
			tdps.hidePvP, tdps.hideSolo, tdps.hideIC, tdps.hideOOC = nil, nil, nil, nil
			tdpsRefresh()
			tdpsFrame:Show()
		end
		PlaySound("gsTitleOptionExit")
	end
end

local function togglerecount()
	if IsAddOnLoaded("Recount") then
		local Recount = LibStub("AceAddon-3.0"):GetAddon("Recount")
		if Recount.MainWindow:IsShown() then
			Recount.MainWindow:Hide()
			Recount.db.profile.MainWindowVis = false
		else
			Recount.MainWindow:Show()
			Recount:RefreshMainWindow()
			Recount.db.profile.MainWindowVis = true
		end
	end
end

brpanel:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
        if IsAddOnLoaded("Numeration") then
            Numeration:ToggleVisibility()
	    elseif IsAddOnLoaded("Skada") then
            Skada:ToggleWindow()
		elseif IsAddOnLoaded("TinyDPS") then
			toggletinydps()
		elseif IsAddOnLoaded("Recount") then
			togglerecount()
	    else 
			print "Can't find Numeration, Skada, Recount or TinyDPS!"
        end
	else
		if IsAddOnLoaded("aBag") then
			ToggleAllBags()
		else
			print "Can't find aBag!"
		end
	end
end)
--====================================================--
--[[                 -- Screen --                   ]]--
--====================================================--

local TOPPANEL = CreateFrame("Frame", "AltzAKFtoppanel", WorldFrame)
TOPPANEL:SetFrameStrata("FULLSCREEN")
creategrowBD(TOPPANEL, 0, 0, 0, 0.5, 1)
TOPPANEL:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT",-5,5)
TOPPANEL:SetPoint("BOTTOMRIGHT",WorldFrame,"TOPRIGHT",5,-80)
TOPPANEL:Hide()

local BOTTOMPANEL = CreateFrame("Frame", "AltzAKFbottompanel", WorldFrame)
BOTTOMPANEL:SetFrameStrata("FULLSCREEN")
creategrowBD(BOTTOMPANEL, 0, 0, 0, 0.5, 1)
BOTTOMPANEL:SetPoint("BOTTOMLEFT",WorldFrame,"BOTTOMLEFT",-5,-5)
BOTTOMPANEL:SetPoint("TOPRIGHT",WorldFrame,"BOTTOMRIGHT",5,75)
BOTTOMPANEL:Hide()

local Clock = createtext(TOPPANEL, "OVERLAY", 27, "NONE", "CENTER")
Clock:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 10)
Clock:SetTextColor(0.7, 0.7, 0.7)

local Date = createtext(TOPPANEL, "OVERLAY", 17, "NONE", "CENTER")
Date:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 40)
Date:SetTextColor(0.7, 0.7, 0.7)

local AUI = createtext(TOPPANEL, "OVERLAY", 50, "NONE", "CENTER")
AUI:SetPoint("BOTTOMRIGHT", TOPPANEL, "BOTTOMRIGHT", -290, 13)
AUI:SetTextColor(0.7, 0.7, 0.7)
AUI:SetText("AltZ UI")

local Guide = CreateFrame("Frame", "AltzAKFcenterpanel", WorldFrame)
Guide:SetFrameStrata("FULLSCREEN")
creategrowBD(Guide, 0, 0, 0, 0.5, 1)
Guide:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT", -5, -90)
Guide:SetPoint("BOTTOMRIGHT",WorldFrame,"BOTTOMRIGHT", 5, 85)
Guide:Hide()

local Guidetext = createtext(Guide, "OVERLAY", 15, "NONE", "CENTER")
Guidetext:SetAllPoints()
Guidetext:SetTextColor(0.7, 0.7, 0.7)
Guidetext:SetText("|cff3399FF/rl|r - Reload UI \n \n |cff3399FF/hb|r - Key Binding Mode \n \n |cff3399FF/raidcd|r - Test/Move RaidCD bars \n \n |cff3399FFSHIFT+Leftbutton|r - Set Focus \n \n |cff3399FFTab|r - Change between available channels. \n \n |cff3399FF/omf|r - Unlock UnitFrames \n \n |cff3399FF/cd x|r - count down from x second. \n \n Raid Control/World Flare button appears on topright of minimap when available. \n \n |cff3399FFEnjoy!|r")
Guidetext:Hide()

local Creditstext = createtext(Guide, "OVERLAY", 17, "NONE", "CENTER")
Creditstext:SetAllPoints()
Creditstext:SetTextColor(0.7, 0.7, 0.7)
if GetLocale() == "zhCN" then
	Creditstext:SetText("AltzUI ver"..ver.." \n \n \n \n 伤心蓝 < 炼狱 > CN5_深渊之巢  \n \n \n \n |cff3399FF Thanks to \n \n deemax Zork Haste Tukz Haleth Qulight Freebaser Monolit \n and everyone who help me with this Compilations.|r")
elseif GetLocale() == "zhTW" then
	Creditstext:SetText("AltzUI ver"..ver.." \n \n \n \n 傷心藍 < 煉獄 > CN5_深淵之巢 \n \n \n \n |cff3399FF Thanks to \n \n deemax Zork Haste Tukz Haleth Qulight Freebaser Monolit \n and everyone who help me with this Compilations.|r")
else
	Creditstext:SetText("AltzUI ver"..ver.." \n \n \n \n Paopao <Purgatory> CN5_Abyssion's Lair \n \n \n \n |cff3399FF Thanks to \n \n deemax Zork Haste Tukz Haleth Qulight Freebaser Monolit \n and everyone who help me with this Compilations.|r")
end
Creditstext:Hide()

local SetupPanel = CreateFrame("Frame", "Altzsetuppanel", WorldFrame)
SetupPanel:SetFrameStrata("FULLSCREEN")
creategrowBD(SetupPanel, 0, 0, 0, 0.5, 1)
SetupPanel:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT", -5, 5)
SetupPanel:SetPoint("BOTTOMRIGHT",WorldFrame,"BOTTOMRIGHT", 5, -5)
SetupPanel:Hide()

SetupPanel.text = createtext(SetupPanel, "OVERLAY", 15, "NONE", "CENTER")
SetupPanel.text:SetPoint("TOP", SetupPanel, "BOTTOM", 0, 75)
SetupPanel.text:SetTextColor(1, 1, 1)
if GetLocale() == "zhCN" then
	SetupPanel.text:SetText("ver"..ver.." 伤心蓝 < 炼狱 > CN5_深渊之巢")
elseif GetLocale() == "zhTW" then
	SetupPanel.text:SetText("ver"..ver.." 傷心藍 < 煉獄 > CN5_深淵之巢")
else
	SetupPanel.text:SetText("ver"..ver.." Paopao <Purgatory> CN5_Abyssion's Lair")
end
SetupPanel.text2 = createtext(SetupPanel, "OVERLAY", 35, "NONE", "CENTER")
SetupPanel.text2:SetPoint("BOTTOM", 0, 110)
SetupPanel.text2:SetTextColor(1, 1, 1)
SetupPanel.text2:SetText("Welcome to Altz UI Setup")

local Setupbutton = CreateFrame("Button", "AltzuiSetupButton", SetupPanel)
Setupbutton:SetPoint("BOTTOM", 0, 80)
Setupbutton:SetSize(UIParent:GetWidth()+10, 25)
creategrowBD(Setupbutton, 0, 0, 0, 0.7, 1)
Setupbutton.text = createtext(Setupbutton, "OVERLAY", 20, "NONE", "CENTER")
Setupbutton.text:SetAllPoints()
Setupbutton.text:SetTextColor(0.5, 0.5, 0.5, .1)
Setupbutton.text:SetText("Install")
Setupbutton:Hide()

Setupbutton:SetScript("OnClick", function()
	ns.SetupAltzui()  
	ReloadUI()
end)

Setupbutton:SetScript("OnEnter", function() Setupbutton.text:SetTextColor(Ccolor.r, Ccolor.g, Ccolor.b, 1) Setupbutton.border:SetBackdropBorderColor(Ccolor.r, Ccolor.g, Ccolor.b) end)
Setupbutton:SetScript("OnLeave", function() Setupbutton.text:SetTextColor(0.5, 0.5, 0.5, .1) Setupbutton.border:SetBackdropBorderColor(0, 0, 0) end)

local interval = 0
TOPPANEL:SetScript("OnUpdate", function(self, elapsed)
 	interval = interval - elapsed
	if interval <= 0 then
        Clock:SetText(format("%s",date("%H:%M:%S")))
		Date:SetText(format("%s",date("%a %b/%d")))
		interval = .5
	end
end)

local buttonhold = CreateFrame("Frame", "AltzAKFbottomhold", BOTTOMPANEL)
buttonhold:SetPoint("BOTTOM",BOTTOMPANEL,"TOP", 0, -50)
buttonhold:SetSize(400, 85)
buttonhold.text = createtext(buttonhold, "OVERLAY", 20, "NONE", "CENTER")
buttonhold.text:SetPoint("TOP", BOTTOMPANEL, "TOP", 0, -10)
buttonhold.text:SetTextColor(0, 0, 0,.5)
buttonhold.text:SetText("Click to hide.")

local petnum = C_PetJournal.GetNumPets(false)
local randomindex = random(1 ,petnum)
local randomID = select(11, C_PetJournal.GetPetInfoByIndex(randomindex))

local function littebutton(self, facing, note)
	self = CreateFrame("PlayerModel", "AltzAKFlittlebutton"..facing, buttonhold)
	self:SetSize(120,120)
	if facing == 1 then
		self:SetPoint("CENTER", buttonhold, "LEFT")
	else
		self:SetPoint("CENTER", buttonhold, "RIGHT")
	end
	
	self:SetPosition(-0.5, 0, 0)
	self:SetFacing(facing)
	if randomID > 0 then self:SetCreature(randomID) end
	
	self.text = createtext(self, "HIGHLIGHT", 20, "NONE", "CENTER")
	self.text:SetPoint("BOTTOM", self, "BOTTOM", 0, 25)
	self.text:SetTextColor(1, 1, 1)
	self.text:SetText(note)
	
	self.grow = self:CreateTexture(nil, "HIGHLIGHT")
	self.grow:SetSize(30, 30)
	self.grow:SetPoint("CENTER", self.text, "TOPRIGHT", -3, -5)
	self.grow:SetTexture("Interface\\Cooldown\\star4")
	self.grow:SetVertexColor(1, 1, 1, .7)
	self.grow:SetBlendMode("ADD")

	self:EnableMouse(true)

	return self
end

local Info = littebutton(self, 1, "Info")
local Credits = littebutton(self, -1, "Credits")

local function fadeout()
	Minimap:Hide()
	UIParent:SetAlpha(0)
	UIFrameFadeIn(TOPPANEL, 3, 0, 1)
	UIFrameFadeIn(BOTTOMPANEL, 3, 0, 1)
	Info:EnableMouse(true)	
	Credits:EnableMouse(true)
	BOTTOMPANEL:EnableMouse(true)
end

local function fadein()
	Minimap:Show()
	UIFrameFadeIn(UIParent, 2, 0, 1)
    UIFrameFadeOut(TOPPANEL, 2, 1, 0)
	UIFrameFadeOut(BOTTOMPANEL, 2, 1, 0)
	Info:EnableMouse(false)	
	Credits:EnableMouse(false)
	BOTTOMPANEL:EnableMouse(false)
end

TOPPANEL:SetScript("OnEvent",function(self,event,...) 
	if(event == "PLAYER_ENTERING_WORLD") then
		if aCoreCDB == nil then
			UIParent:SetAlpha(0)
			SetupPanel:Show()
			Setupbutton:Show()
		else
			fadeout()
		end
		TOPPANEL:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif UnitIsAFK("player") then
		fadeout()
	end
end)

TOPPANEL:RegisterEvent("PLAYER_ENTERING_WORLD")
TOPPANEL:RegisterEvent("PLAYER_FLAGS_CHANGED")

BOTTOMPANEL:SetScript("OnEnter", function() buttonhold.text:SetTextColor(.5, .5, .5, 1) end)
BOTTOMPANEL:SetScript("OnLeave", function() buttonhold.text:SetTextColor(0, 0, 0, .5) end)

BOTTOMPANEL:SetScript("OnMouseUp", function()
	fadein()
end)

Info:SetScript("OnMouseUp", function()
	if Guidetext:IsShown() then 
		Guide:Hide() Guidetext:Hide()
	else 
		Guide:Show() Guidetext:Show() Creditstext:Hide()
	end
end)

Credits:SetScript("OnMouseUp", function()
	if Creditstext:IsShown() then 
		Guide:Hide() Creditstext:Hide()
	else 
		Guide:Show() Creditstext:Show() Guidetext:Hide()
	end
end)

Guide:SetScript("OnMouseUp", function()
	Guide:Hide() Guidetext:Hide() Creditstext:Hide()
end)
