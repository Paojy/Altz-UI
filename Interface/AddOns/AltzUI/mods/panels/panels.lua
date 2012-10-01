local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local function creategradient(f, r, g, b, n, a)
	local gradient = f:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture("Interface\\Buttons\\WHITE8x8")
	gradient:SetGradientAlpha("VERTICAL",  r, g, b, a, r/n, g/n, b/n, a)
end

local function createbargradient(bar, r, g, b, n)
	bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
	bar:GetStatusBarTexture():SetGradient("VERTICAL",  r, g, b, r/n, g/n, b/n)
end
--====================================================--
--[[                -- shadow --                    ]]--
--====================================================--	
local PShadow = CreateFrame("Frame", nil, UIParent)
PShadow:SetFrameStrata("BACKGROUND")
PShadow:SetAllPoints()
PShadow:SetBackdrop({bgFile = "Interface\\AddOns\\AltzUI\\media\\shadow"})
PShadow:SetBackdropColor(0, 0, 0, 0.3)

--====================================================--
--[[                -- panels --                    ]]--
--====================================================--	
local function createpanel(panel, pos, y)
	panel = CreateFrame("Frame", nil, UIParent)
	panel:SetFrameStrata("BACKGROUND")
	panel:SetPoint(pos, 0, y)
	panel:SetPoint("LEFT", UIParent, "LEFT", 8, 0)
	panel:SetPoint("RIGHT", UIParent, "RIGHT", -8, 0)
	panel:SetHeight(7)
	panel.border = F.CreateBDFrame(panel, 0.6)
	F.CreateSD(panel.border, 2, 0, 0, 0, 1, -1)
	return panel
end

local toppanel = createpanel(self, "TOP", -3)
local bottompanel = createpanel(self, "BOTTOM", 3)

local function createlittlepanel(panel, width, text)
	panel = CreateFrame("Frame", nil, UIParent)
	panel:SetFrameStrata("LOW")
	panel:SetFrameLevel(3)
	panel:SetSize(width, 4)
	panel.text = T.createtext(panel, "HIGHLIGHT", 14, "OUTLINE", "CENTER")
	panel.text:SetAllPoints()
	panel.text:SetText(text)
	creategradient(panel, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 3)
	panel.border = F.CreateBDFrame(panel, 1)
	F.CreateSD(panel.border, 2, 0, 0, 0, 1, -1)
	return panel
end

--====================================================--
--[[          -- Calendar toggle panel --           ]]--
--====================================================--
local infopanel = createlittlepanel(self, 130, L["|cffFF3E96C|ralendar"])
infopanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -10)
infopanel:SetScript("OnMouseUp", function() ToggleCalendar() end)

--====================================================--
--[[           -- XP bar and Info bar --            ]]--
--====================================================--
BNToastFrame:ClearAllPoints()
BNToastFrame:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 10, -20)
BNToastFrame_UpdateAnchor = function() end

local xpbar = CreateFrame("StatusBar", "ExperienceBar", UIParent)
xpbar:SetFrameStrata("LOW")
xpbar:SetSize(G.screenwidth*2/9-130, 4)
xpbar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 152, -10)

createbargradient(xpbar, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 3)
xpbar.border = F.CreateBDFrame(xpbar, 1)
xpbar.border:SetBackdropColor(.3, .3, .3)
F.CreateSD(xpbar.border, 3, 0, 0, 0, 1, -1)

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
			GameTooltip:AddDoubleLine(L["Currentxp"], string.format("%s/%s (%d%%)", CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
			GameTooltip:AddDoubleLine(L["Remainingxp"], string.format("%s", CommaValue(maxXP-XP)), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
			if restXP then GameTooltip:AddDoubleLine(L["Restedxp"], string.format("|cffb3e1ff%s (%d%%)", CommaValue(restXP), restXP/maxXP*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end
		end
	
		if name and not UnitLevel("player") == MAX_PLAYER_LEVEL then
			GameTooltip:AddLine(" ")
		end

		if name then
			GameTooltip:AddLine(name.."  (".._G["FACTION_STANDING_LABEL"..rank]..")", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			GameTooltip:AddDoubleLine(L["Currentrep"], string.format("%s/%s (%d%%)", CommaValue(value-minRep), CommaValue(maxRep-minRep), (value-minRep)/(maxRep-minRep)*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
			GameTooltip:AddDoubleLine(L["Remainingrep"], string.format("%s", CommaValue(maxRep-value)), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
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
infobar:SetAlpha(.3)
infobar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 155, -13)

Minimap:HookScript('OnEnter', function() infobar:SetAlpha(1) end)
Minimap:HookScript('OnLeave', function() infobar:SetAlpha(.6) end)

local Ctext = T.createtext(infobar, "OVERLAY", 12, "OUTLINE", "LEFT")
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
		GameTooltip:AddLine(L["Top"].." "..nraddons.." "..L["AddOns"], G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
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
		GameTooltip:AddDoubleLine(L["UI Memory usage"], memFormat(total), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		GameTooltip:AddDoubleLine(L["Total incl. Blizzard"], memFormat(BlizzMem), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		GameTooltip:Show()
	end
end

-- Update Function
local hour, fps, lag, dur
local refresh_timer = 0
function infobar:updateOntime(elapsed)
	refresh_timer = refresh_timer + elapsed -- Only update this values every refresh_timer seconds
	if refresh_timer > 1 then -- Updates each X seconds	
		dur = (Durability().."%sdur|r   "):format(Hex(G.Ccolor))
		fps = (floor(GetFramerate()).."%sfps|r   "):format(Hex(G.Ccolor))
		lag = (select(3, GetNetStats()).."%sms|r   "):format(Hex(G.Ccolor))
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
local buffpanel = createlittlepanel(self, G.screenwidth*2/9, "")
buffpanel:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -15, -10)

--====================================================--
--[[              -- chat panel --                  ]]--
--====================================================--
local blpanel = createlittlepanel(self, G.screenwidth*2/9, L["|cff00B2EEF|rriends   |cff00EE00G|ruild"])

blpanel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 15, 10)

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
		print("|cffFF0000离开|r 大脚世界频道")
		button:UnlockHighlight()
		isInCustomChannel = false	  
	else
		JoinPermanentChannel(customChannelName,nil,1)
		ChatFrame_AddChannel(ChatFrame1,customChannelName)
		ChatFrame_RemoveMessageGroup(ChatFrame1,"CHANNEL")
		print("|cff7FFF00加入|r 大脚世界频道")
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
local centerpanel = createlittlepanel(self, G.screenwidth*2/9, "|cffFF0000A|r|cffFF8C00l|r|cffFFFF00t|r|cff7FFF00z|r |cff1C86EEU|r|cff8A2BE2I|r")
centerpanel:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 10)
centerpanel:SetFrameStrata("HIGH")
centerpanel:SetScript("OnMouseUp", function() InterfaceOptionsFrame_OpenToCategory("AltzUI") end)
--====================================================--
--[[             -- bottomright panel --            ]]--
--====================================================--		
local brpanel = createlittlepanel(self, G.screenwidth*2/9, L["|cffFFFF00B|rags   |cffBF3EFFD|ramage Meter"])
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
			print (L["Can't find"].." Numeration, Skada, Recount or TinyDPS!")
        end
	else
		ToggleAllBags()
	end
end)
--====================================================--
--[[                 -- Screen --                   ]]--
--====================================================--

local TOPPANEL = CreateFrame("Frame", "AltzAKFtoppanel", WorldFrame)
TOPPANEL:SetFrameStrata("FULLSCREEN")
F.SetBD(TOPPANEL)
TOPPANEL:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT",-5,5)
TOPPANEL:SetPoint("BOTTOMRIGHT",WorldFrame,"TOPRIGHT",5,-80)
TOPPANEL:Hide()

local BOTTOMPANEL = CreateFrame("Frame", "AltzAKFbottompanel", WorldFrame)
BOTTOMPANEL:SetFrameStrata("FULLSCREEN")
F.SetBD(BOTTOMPANEL)
BOTTOMPANEL:SetPoint("BOTTOMLEFT",WorldFrame,"BOTTOMLEFT",-5,-5)
BOTTOMPANEL:SetPoint("TOPRIGHT",WorldFrame,"BOTTOMRIGHT",5,75)
BOTTOMPANEL:Hide()

local Clock = T.createtext(TOPPANEL, "OVERLAY", 27, "NONE", "CENTER")
Clock:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 10)
Clock:SetTextColor(0.7, 0.7, 0.7)

local Date = T.createtext(TOPPANEL, "OVERLAY", 17, "NONE", "CENTER")
Date:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 40)
Date:SetTextColor(0.7, 0.7, 0.7)

local AUI = T.createtext(TOPPANEL, "OVERLAY", 50, "NONE", "CENTER")
AUI:SetPoint("BOTTOMRIGHT", TOPPANEL, "BOTTOMRIGHT", -290, 13)
AUI:SetTextColor(0.7, 0.7, 0.7)
AUI:SetText("AltZ UI")

local Guide = CreateFrame("Frame", "AltzAKFcenterpanel", WorldFrame)
Guide:SetFrameStrata("FULLSCREEN")
F.SetBD(Guide)

Guide:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT", -5, -90)
Guide:SetPoint("BOTTOMRIGHT",WorldFrame,"BOTTOMRIGHT", 5, 85)
Guide:Hide()

local Guidetext = T.createtext(Guide, "OVERLAY", 15, "NONE", "CENTER")
Guidetext:SetAllPoints()
Guidetext:SetTextColor(0.7, 0.7, 0.7)
Guidetext:SetText(L["Instruction"])
Guidetext:Hide()

local Creditstext = T.createtext(Guide, "OVERLAY", 17, "NONE", "CENTER")
Creditstext:SetAllPoints()
Creditstext:SetTextColor(0.7, 0.7, 0.7)
Creditstext:SetText("AltzUI ver"..G.Version.." \n \n \n \n "..L["Paopao <Purgatory> CN5_Abyssion's Lair"].."  \n \n \n \n |cff3399FF "..L["Thanks to"].." \n \n deemax Zork Haste Tukz Haleth Qulight Freebaser Monolit \n"..L["and everyone who help me with this Compilations."].."|r")
Creditstext:Hide()

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
buttonhold.text = T.createtext(buttonhold, "OVERLAY", 20, "NONE", "CENTER")
buttonhold.text:SetPoint("TOP", BOTTOMPANEL, "TOP", 0, -10)
buttonhold.text:SetTextColor(0, 0, 0,.5)
buttonhold.text:SetText(L["Click to hide."])

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
	
	self.text = T.createtext(self, "HIGHLIGHT", 20, "NONE", "CENTER")
	self.text:SetPoint("BOTTOM", self, "BOTTOM", 0, 25)
	self.text:SetTextColor(1, 1, 1)
	self.text:SetText(note)
	
	self.grow = self:CreateTexture(nil, "HIGHLIGHT")
	self.grow:SetSize(30, 30)
	self.grow:SetPoint("CENTER", self.text, "TOPRIGHT", -3, -5)
	self.grow:SetTexture("Interface\\Cooldown\\star4")
	self.grow:SetVertexColor(1, 1, 1, .7)
	self.grow:SetBlendMode("ADD")

	self:SetScript("OnEnter", function() self:SetFacing(0) end)
	self:SetScript("OnLeave", function() self:SetFacing(facing) end)
	
	self:EnableMouse(true)

	return self
end

local Info = littebutton(self, 1, L["Info"])
local Credits = littebutton(self, -1, L["Credits"])

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
		if not aCoreCDB.notmeet then
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