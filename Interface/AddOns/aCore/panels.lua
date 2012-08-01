
local font = GameFontHighlight:GetFont()
local Ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
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
	panel:SetFrameLevel(3)
	panel:SetPoint(pos, 0, y)
	panel:SetSize(GetScreenWidth() -20, 7)
	creategrowBD(panel, 0, 0, 0, 0.3, 1)
	return panel
end

local toppanel = createpanel(self, "TOP", -3)
local bottompanel = createpanel(self, "BOTTOM", 3)

local function createlittlepanel(panel, width)
	panel = CreateFrame("Frame", nil, UIParent)
	panel:SetFrameStrata("MEDIUM")
	panel:SetFrameLevel(5)
	panel:SetSize(width, 4)
	creategradient(panel, Ccolor.r, Ccolor.g, Ccolor.b, 3)
	creategrowBD(panel, 0.3, 0.3, 0.3, 1, 1)
	return panel
end
--====================================================--
--[[         -- XP bar (topleft panel)--            ]]--
--====================================================--

local xpbar = CreateFrame("StatusBar", "ExperienceBar", UIParent)
xpbar:SetFrameStrata("MEDIUM")
xpbar:SetFrameLevel(5)
xpbar:SetSize(130,4)
xpbar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -10)
createbargradient(xpbar, Ccolor.r, Ccolor.g, Ccolor.b, 3)
creategrowBD(xpbar, 0.3, 0.3, 0.3, 1, 1)

local indicator = createtex(xpbar, [[Interface\CastingBar\UI-CastingBar-Spark]], "ADD")
indicator:SetSize(7, 15)
indicator:ClearAllPoints()

local function CommaValue(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

local _G = getfenv(0)
function xprptoolitp()
	GameTooltip:SetOwner(xpbar, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, 0)
	
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()
	local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
	
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		GameTooltip:AddDoubleLine("Current: ", string.format('%s/%s (%d%%)', CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Remaining: ", string.format('%s', CommaValue(maxXP-XP)), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Rested: ", string.format('|cffb3e1ff%s (%d%%)', CommaValue(restXP), restXP/maxXP*100), Ccolor.r, Ccolor.g, Ccolor.b)
	end
	
	if name and not UnitLevel("player") == MAX_PLAYER_LEVEL then
		GameTooltip:AddLine(" ")
	end

	if name then
		GameTooltip:AddLine(name.."  (".._G['FACTION_STANDING_LABEL'..rank]..")", Ccolor.r, Ccolor.g, Ccolor.b)
		GameTooltip:AddDoubleLine("Rep:", string.format('%s/%s (%d%%)', CommaValue(value-minRep), CommaValue(maxRep-minRep), (value-minRep)/(maxRep-minRep)*100), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Remaining:", string.format('%s', CommaValue(maxRep-value)), Ccolor.r, Ccolor.g, Ccolor.b, 1, 1, 1)
	end	
	
	GameTooltip:Show()
end

function xpbar:updateOnevent()
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
   	if not UnitLevel('player') == MAX_PLAYER_LEVEL then
		xpbar:SetMinMaxValues(min(0, XP), maxXP)
		xpbar:SetValue(XP)
	else
		xpbar:SetMinMaxValues(minRep, maxRep)
		xpbar:SetValue(value)
	end
	indicator:SetPoint("CENTER", xpbar:GetStatusBarTexture(), "RIGHT")
end

xpbar:SetScript("OnEnter", xprptoolitp)
xpbar:SetScript("OnLeave", function() GameTooltip:Hide() end)
xpbar:SetScript("OnEvent", xpbar.updateOnevent)

xpbar:RegisterEvent("PLAYER_XP_UPDATE")
xpbar:RegisterEvent('UPDATE_FACTION')
xpbar:RegisterEvent("PLAYER_LEVEL_UP")
xpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
xpbar:RegisterEvent("PLAYER_LOGIN")

--====================================================--
--[[            -- info panel --                    ]]--
--====================================================--
local infopanel = createlittlepanel(self, 185)
infopanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 150, -10)

local centerbox = CreateFrame("Button", nil, infopanel) -- Center Frame
centerbox:SetSize(200, 20)
centerbox:SetPoint("TOPLEFT", infopanel, "BOTTOMLEFT", 10, 5)
local Ctext = createtext(centerbox, 12, "OUTLINE", false)
Ctext:SetPoint"LEFT"

-- Hex Color
local Hex
do 
	Hex = function(color)
        return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
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
for _,slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand", "Ranged"})
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
	if  not InCombatLockdown()  then -- Don't Show in Combat
		local addons, total, nr, name = {}, 0, 0
		local memory, entry
		local BlizzMem = collectgarbage("count")
			
		GameTooltip:SetOwner(centerbox, "ANCHOR_NONE")
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
function infopanel:updateOntime(elapsed)
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

centerbox:SetScript("OnEnter", memorytooltip)
centerbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
centerbox:SetScript("OnMouseUp", function() ToggleCalendar() end)

infopanel:SetScript("OnUpdate", infopanel.updateOntime)

--====================================================--
--[[              -- buff panel --               ]]--
--====================================================--

local buffpanel = createlittlepanel(self, 320)
buffpanel:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -15, -10)

--====================================================--
--[[              -- chat panel --               ]]--
--====================================================--
local chatpanel = createlittlepanel(self, 320)
chatpanel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 15, 10)

chatpanel:SetScript('OnMouseUp', function() WorldChannel() end)
chatpanel:SetScript('OnEnter', function()
		GameTooltip:SetOwner(chatpanel, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMLEFT", chatpanel, "TOPLEFT", -1, 3)
		GameTooltip:AddLine("WorldChannel")
		GameTooltip:Show()
		end)
chatpanel:SetScript('OnLeave', function() 
		GameTooltip:Hide() 
		end)
		
--====================================================--
--[[             -- bottom panel --            ]]--
--====================================================--	

local bottompanel = createlittlepanel(self, 345)
bottompanel:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 10)
bottompanel:SetScript('OnMouseUp', function() 
InterfaceOptionsFrame_OpenToCategory(ACTIONBAR_LABEL)
end)
--====================================================--
--[[             -- bottomright panel --            ]]--
--====================================================--		
local brpanel = createlittlepanel(self, 320)
brpanel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 10)

-- tiny dps don't have a global toggle fuction, so just copy it.
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
		PlaySound('gsTitleOptionExit')
		end
end

if IsAddOnLoaded("Recount") then
	local Recount = LibStub("AceAddon-3.0"):GetAddon("Recount")
	
	local function togglerecount()
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

brpanel:SetScript('OnMouseUp', function() 
        if IsAddOnLoaded("Numeration") then
            Numeration:ToggleVisibility()
	    elseif IsAddOnLoaded("Skada") then
            Skada:ToggleWindow()
		elseif IsAddOnLoaded("TinyDPS") then
			toggletinydps()
		elseif IsAddOnLoaded("Recount") then
			togglerecount()
	    else print "Can't find Numeration, Skada, Recount or TinyDPS!"
        end 
		end)
brpanel:SetScript('OnEnter', function()
		GameTooltip:SetOwner(brpanel, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", brpanel, "TOPRIGHT", 1, 3)
		GameTooltip:AddLine("Damage Meter")
		GameTooltip:Show()
		end)
brpanel:SetScript('OnLeave', function() 
		GameTooltip:Hide() 
		end)

--====================================================--
--[[                 -- Screen --                   ]]--
--====================================================--

local TOPPANEL = CreateFrame("Frame", nil, WorldFrame)
TOPPANEL:SetFrameStrata("HIGH")
creategrowBD(TOPPANEL, 0, 0, 0, 0.5, 1)
TOPPANEL:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT",-5,5)
TOPPANEL:SetPoint("BOTTOMRIGHT",WorldFrame,"TOPRIGHT",5,-80)

local BOTTOMPANEL = CreateFrame("Frame", nil, WorldFrame)
BOTTOMPANEL:SetFrameStrata("HIGH")
creategrowBD(BOTTOMPANEL, 0, 0, 0, 0.5, 1)
BOTTOMPANEL:SetPoint("BOTTOMLEFT",WorldFrame,"BOTTOMLEFT",-5,-5)
BOTTOMPANEL:SetPoint("TOPRIGHT",WorldFrame,"BOTTOMRIGHT",5,75)

local BOTTOMTEXT = createtext(BOTTOMPANEL, 20, "NONE", false)
BOTTOMTEXT:SetPoint("TOP", BOTTOMPANEL, "TOP", 0, -10)
BOTTOMTEXT:SetTextColor(0, 0, 0,.5)
BOTTOMTEXT:SetText("Click to hide.")

local Clock = createtext(TOPPANEL, 27, "NONE", false)
Clock:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 10)
Clock:SetTextColor(0.7, 0.7, 0.7)

local Date = createtext(TOPPANEL, 17, "NONE", false)
Date:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 34)
Date:SetTextColor(0.7, 0.7, 0.7)

local AUI = createtext(TOPPANEL, 50, "NONE", false)
AUI:SetPoint("BOTTOMRIGHT", TOPPANEL, "BOTTOMRIGHT", -290, 13)
AUI:SetTextColor(0.7, 0.7, 0.7)
AUI:SetText("AltZ UI")

local Guide = CreateFrame("Frame", nil, WorldFrame)
creategrowBD(Guide, 0, 0, 0, 0.5, 0)
Guide:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT", -5, -85)
Guide:SetPoint("BOTTOMRIGHT",WorldFrame,"BOTTOMRIGHT", 5, 80)
Guide:Hide()

local Guidetext = createtext(Guide, 15, "NONE", true)
Guidetext:SetTextColor(0.7, 0.7, 0.7)
Guidetext:SetText("|cff3399FF/rl|r - Reload UI \n \n |cff3399FF/hb|r - Key Binding Mode \n \n |cff3399FF/raidcd|r - Test RaidCD bars \n \n |cff3399FF/atweaks|r - move RaidCD bars \n \n |cff3399FFSHIFT+Leftbutton|r - Set Focus \n \n |cff3399FFTab|r - Change between available channels. \n \n |cff3399FF/omf|r - Unlock UnitFrames \n \n |cff3399FF/cd x|r - count down from x second. \n \n Raid Control/World Flare button appears on topright of minimap when available. \n \n |cff3399FFEnjoy!|r")
Guidetext:Hide()

local Creditstext = createtext(Guide, 15, "NONE", true)
Creditstext:SetTextColor(0.7, 0.7, 0.7)
Creditstext:SetText("AltzUI ver"..ver.." \n \n \n \n 伤心蓝 CN5_深渊之巢 \n  < 炼狱 > \n \n \n \n |cff3399FF Thanks to \n \n Zork Haste Tukz Haleth Qulight Freebaser Monolit \n and everyone who help me with this Compilations.|r")
Creditstext:Hide()

local interval = 0
TOPPANEL:SetScript('OnUpdate', function(self, elapsed)
 	interval = interval - elapsed
	if interval <= 0 then
        Clock:SetText(format("%s",date("%H:%M:%S")))
		Date:SetText(format("%s",date("%a %b/%d")))
		interval = .5
	end
end)

local buttonhold = CreateFrame("Frame", nil, BOTTOMPANEL)
buttonhold:SetPoint("TOPRIGHT",BOTTOMPANEL,"TOPRIGHT", -220, -10)
buttonhold:SetSize(100,45)
buttonhold:SetScript('OnEnter', function() BOTTOMTEXT:SetTextColor(0, 0, 0, .5) end)

local function littebutton(self, x, texturefile, note)
	self = CreateFrame("Button", nil, buttonhold)
	self:SetPoint("LEFT",buttonhold,"LEFT", 10+(x-1)*45, 0)
	self:SetSize(35,35)
	self:SetNormalTexture(texturefile)
	self:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	self:GetNormalTexture():SetDesaturated(true)
	creategrowBD(self, 0, 0, 0, 0.3, 1)
	
	self.text = createtext(self, 30, "NONE", false)
	self.text:SetPoint("RIGHT",BOTTOMPANEL,"RIGHT", -360, 0)
	self.text:SetTextColor(0.7, 0.7, 0.7)
	self.text:SetText(note)
	self.text:Hide()

	self:SetScript('OnEnter', function() self:GetNormalTexture():SetDesaturated(false) self.border:SetBackdropBorderColor(0.2, 0.8, 1, 1) self.text:Show() end)
	self:SetScript('OnLeave', function() self:GetNormalTexture():SetDesaturated(true) self.border:SetBackdropBorderColor(0, 0, 0, 1) self.text:Hide() end)
	
	return self
end

local Info = littebutton(self, 1, "Interface\\ICONS\\inv_pet_pandarenelemental", "Info")
local Credits = littebutton(self, 2, "Interface\\ICONS\\inv_pet_deathy", "Credits")

local function fadeout()
	Minimap:Hide()
	UIParent:SetAlpha(0)
	UIFrameFadeIn(TOPPANEL, 3, 0, 1)
	UIFrameFadeIn(BOTTOMPANEL, 3, 0, 1)
	BOTTOMPANEL:EnableMouse(true)
	Info:Show()
	Credits:Show()
end

local function fadein()
	Minimap:Show()
	UIFrameFadeIn(UIParent, 2, 0, 1)
    UIFrameFadeOut(TOPPANEL, 2, 1, 0)
	UIFrameFadeOut(BOTTOMPANEL, 2, 1, 0)
	BOTTOMPANEL:EnableMouse(false)
	Info:Hide()
	Credits:Hide()
end

TOPPANEL:SetScript("OnEvent",function(self,event,...) 
	if(event == "PLAYER_ENTERING_WORLD") then
		fadeout()
		TOPPANEL:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif UnitIsAFK("player") then
		fadeout()
	end
end)

TOPPANEL:RegisterEvent("PLAYER_ENTERING_WORLD")
TOPPANEL:RegisterEvent("PLAYER_FLAGS_CHANGED")

BOTTOMPANEL:SetScript('OnEnter', function() BOTTOMTEXT:SetTextColor(.6, .6, .6, .5) end)
BOTTOMPANEL:SetScript('OnLeave', function() BOTTOMTEXT:SetTextColor(0, 0, 0, .5) end)

BOTTOMPANEL:SetScript('OnMouseUp', function()
	fadein()
end)

Info:SetScript('OnMouseUp', function()
	if Guidetext:IsShown() then 
		Guide:Hide() Guidetext:Hide()
	else 
		Guide:Show() Guidetext:Show() Creditstext:Hide()
	end
end)

Credits:SetScript('OnMouseUp', function()
	if Creditstext:IsShown() then 
		Guide:Hide() Creditstext:Hide()
	else 
		Guide:Show() Creditstext:Show() Guidetext:Hide()
	end
end)

Guide:SetScript('OnMouseUp', function()
	Guide:Hide() Guidetext:Hide() Creditstext:Hide()
end)

--====================================================--
--[[         -- test --         ]]--
--====================================================--
--[[
local function listmount()
	for i=1,GetNumCompanions("CRITTER") do
		local creatureID, creatureName = GetCompanionInfo("CRITTER", i)
		print(i..":"..creatureName.."ID:"..creatureID)
	end
end
listmount()
]]
local creatures = {
--22514 -- 白色乘骑塔布羊 
--52748 -- 纯血火鹰 
16548, -- 哼哼先生 
51090, -- 唱歌的向日葵 
53623, -- 角鹰兽宝宝
36607, -- 奥妮克希亚宝宝
32595, -- 企鹅
16549, -- 老鼠
32939, -- 小鹿 
47944, -- 暗色凤凰宝宝
32814, -- 暴雪熊宝宝
33226, -- 螃蟹 
48107, -- 海鸥 
37865, -- 小狗 
7394, -- 小鸡 
27217, -- 竞争之魂 
9662, -- 精龙 
23274, -- 臭臭 
23258, -- 蛋蛋 
51635, -- 蜗牛 
33578, -- 鱼人 
16547, -- 乌龟 
}
--[[
local function createmodel(parent)
local Model = CreateFrame("PlayerModel", nil, parent)
Model:SetAllPoints(parent)
local randomNum = random(1 ,#creatures)
local creatureID = creatures[randomNum]
Model:SetCreature(creatureID)
end
]]