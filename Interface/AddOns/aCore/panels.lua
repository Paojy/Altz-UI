
local font = GameFontHighlight:GetFont()
local Ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local aMedia = "Interface\\AddOns\\aCore\\media\\"
local blank = "Interface\\Buttons\\WHITE8x8"

local xpbarsize = {
	['Width'] = 330,
	['Height'] = 10,
}

local xppos = {"BOTTOM", UIParent, "BOTTOM", 0, 10}

--====================================================--
--[[            -- shadow and lines--               ]]--
--====================================================--	
local PShadow = CreateFrame("Frame", nil, UIParent)
PShadow:SetFrameStrata("BACKGROUND")
PShadow:SetAllPoints()
PShadow:SetBackdrop({bgFile = aMedia.."shadow"})
PShadow:SetBackdropColor(0, 0, 0, 0.3)

local function createline(line, pos, y)
	line = CreateFrame("Frame", nil, UIParent)
	line:SetFrameStrata("BACKGROUND")
	line:SetPoint(pos, 0, y)
	line:SetSize(GetScreenWidth(), 1)
	creategrowBD(line, Ccolor.r, Ccolor.g, Ccolor.b, 1, 1)
	return line
end

--local topline = createline(self, "TOP", -15)
local bottomline = createline(self, "BOTTOM", 15)
--====================================================--
--[[            -- XP bar --                        ]]--
--====================================================--
--xp bar
local xpbar = CreateFrame("StatusBar", "ExperienceBar", UIParent)
xpbar:SetSize(xpbarsize.Width,xpbarsize.Height)
xpbar:SetPoint(unpack(xppos))
createbargradient(xpbar, Ccolor.r, Ccolor.g, Ccolor.b, 3)
creategrowBD(xpbar, 0.3, 0.3, 0.3, 1, 1)

local indicator = createtex(xpbar, [[Interface\CastingBar\UI-CastingBar-Spark]], "ADD")
indicator:SetSize(7, xpbarsize.Height+10)
indicator:ClearAllPoints()

local centerbox = CreateFrame("Button", nil, xpbar) -- Center Frame
centerbox:SetSize(120, 20)
centerbox:SetPoint("CENTER", 0, 5)
local Ctext = createtext(centerbox, 12, "OUTLINE", true)

local leftbox = CreateFrame("Button", nil, xpbar) -- Left Frame
leftbox:SetSize(40, 20)
leftbox:SetPoint("LEFT", xpbar, "LEFT", 25, 5)
local Ltext = createtext(leftbox, 12, "OUTLINE", false)
--Ltext:SetJustifyH("LEFT")
Ltext:SetPoint("LEFT")

local rightbox = CreateFrame("Button", nil, xpbar) -- Right Frame
rightbox:SetSize(40, 20)
rightbox:SetPoint("RIGHT", xpbar, "RIGHT", -25, 5)
local Rtext = createtext(rightbox, 12, "OUTLINE", false)
--Rtext:SetJustifyH("RIGHT")
Rtext:SetPoint("RIGHT")

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
			
		GameTooltip:SetOwner(xpbar, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOM", xpbar, "TOP", 0, 8)
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

local _G = getfenv(0)
function xprptoolitp()
	GameTooltip:SetOwner(xpbar, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOM", xpbar, "TOP", 0, 8)
	
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


-- Update Function
local hour, fps, lag, dur
local refresh_timer = 0
function xpbar:updateOntime(elapsed)
	refresh_timer = refresh_timer + elapsed -- Only update this values every refresh_timer seconds
	if refresh_timer > 1 then -- Updates each X seconds	
		dur = (Durability().."%sdur|r   "):format(Hex(Ccolor))
		fps = (floor(GetFramerate()).."%sfps|r   "):format(Hex(Ccolor))
		lag = (select(3, GetNetStats()).."%sms|r   "):format(Hex(Ccolor))
		hour = date("%H:%M")
		
		Ltext:SetText(dur) -- Left Anchored Text
		Ctext:SetText(fps..lag) -- Center Anchored Text
		Rtext:SetText(hour) -- Right Anchored Text
		
		refresh_timer = 0 -- Reset Timer
	end
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

-- Initialize Function
local function Init()
	xpbar:SetScript("OnEnter", xprptoolitp)
	xpbar:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	centerbox:SetScript("OnEnter", memorytooltip)
	centerbox:SetScript("OnLeave", function() GameTooltip:Hide() end)

	leftbox:SetScript("OnMouseUp", function() ToggleCharacter("PaperDollFrame") end)
	rightbox:SetScript("OnMouseUp", function() ToggleCalendar() end)
	
	xpbar:SetScript("OnEvent", xpbar.updateOnevent)
	xpbar:SetScript("OnUpdate", xpbar.updateOntime)
end


Init()

xpbar:RegisterEvent("PLAYER_XP_UPDATE")
xpbar:RegisterEvent('UPDATE_FACTION')
xpbar:RegisterEvent("PLAYER_LEVEL_UP")
xpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
xpbar:RegisterEvent("PLAYER_LOGIN")

--====================================================--
--[[              -- World Channel --               ]]--
--====================================================--

local Leftbutton = CreateFrame("Frame", nil, xpbar)
Leftbutton:SetSize(20,20)
Leftbutton:SetPoint("CENTER", xpbar, "LEFT", 0 ,0)
createtex(Leftbutton, "Interface\\PetBattles\\DeadPetIcon")

Leftbutton:SetScript('OnMouseUp', function() WorldChannel() end)
Leftbutton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(Leftbutton, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMLEFT", Leftbutton, "TOPLEFT", -4, 8)
		GameTooltip:AddLine("WorldChannel")
		GameTooltip:Show()
		end)
Leftbutton:SetScript('OnLeave', function() 
		GameTooltip:Hide() 
		end)

--====================================================--
--[[               -- Damage Meter --               ]]--
--====================================================--

local Rightbutton = CreateFrame("Frame", nil, xpbar)
Rightbutton:SetSize(20,20)
Rightbutton:SetPoint("CENTER", xpbar, "RIGHT", 0 ,0)
createtex(Rightbutton, "Interface\\PetBattles\\DeadPetIcon")

-- tiny dps don't have a global toggle fuction, so just copy it.
local function toggle()
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

Rightbutton:SetScript('OnMouseUp', function() 
        if IsAddOnLoaded("Numeration") then
            Numeration:ToggleVisibility()
	    elseif IsAddOnLoaded("Skada") then
            Skada:ToggleWindow()
		elseif IsAddOnLoaded("TinyDPS") then
			toggle()
	    else print "Can't find Numeration, Skada or TinyDPS!"
        end 
		end)
Rightbutton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(Rightbutton, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", Rightbutton, "TOPRIGHT", 4, 8)
		GameTooltip:AddLine("Damage Meter")
		GameTooltip:Show()
		end)
Rightbutton:SetScript('OnLeave', function() 
		GameTooltip:Hide() 
		end)

--====================================================--
--[[                 -- Screen --                   ]]--
--====================================================--

local TOPPANEL = CreateFrame("Frame", nil, WorldFrame)
creategrowBD(TOPPANEL, 0, 0, 0, 0.5, 1)
TOPPANEL:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT",-5,5)
TOPPANEL:SetPoint("BOTTOMRIGHT",WorldFrame,"TOPRIGHT",5,-80)

local BOTTOMPANEL = CreateFrame("Frame", nil, WorldFrame)
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

local Contacttext = createtext(Guide, 15, "NONE", true)
Contacttext:SetTextColor(0.7, 0.7, 0.7)
Contacttext:SetText("E-mail:359661355@qq.com \n \n If you have any errors or questions,please post it in the comments of wowinterface.com or send a e-mail to me. \n \n If you are posting errors please always support your comment with a screenshot and in case the lua error you are getting.")
Contacttext:Hide()

local interval = 0
TOPPANEL:SetScript('OnUpdate', function(self, elapsed)
 	interval = interval - elapsed
	if interval <= 0 then
        Clock:SetText(format("%s",date("%H:%M:%S")))
		Date:SetText(format("%s",date("%a %b/%d")))
		interval = .5
	end
end)

local function littebutton(bu, x, texturefile, note)
local texture, text

bu:SetPoint("TOPRIGHT",BOTTOMPANEL,"TOPRIGHT", -285-x, -15)
bu:SetSize(30,30)

texture = createtex(bu, texturefile, "ADD")
texture:SetVertexColor(1, 1, 1)

text = createtext(bu, 30, "NONE", false)
text:SetPoint("RIGHT",BOTTOMPANEL,"RIGHT", -320, 10)
text:SetTextColor(0.7, 0.7, 0.7)
text:SetText(note)
text:Hide()

bu.texture = texture
bu.text = text

bu:SetScript('OnEnter', function() bu.texture:SetVertexColor(.1, 1, .1) bu.text:Show() end)
bu:SetScript('OnLeave', function() bu.texture:SetVertexColor(1, 1, 1) bu.text:Hide() end)
end

local Setup = CreateFrame("Frame", nil, BOTTOMPANEL)
littebutton(Setup, 0, aMedia.."setup", "Setup")
 
local Info = CreateFrame("Frame", nil, BOTTOMPANEL)
littebutton(Info, -40, aMedia.."info", "Info")

local Email = CreateFrame("Frame", nil, BOTTOMPANEL)
littebutton(Email, -80, aMedia.."email", "Need Help?")

local function fadeout()
	Minimap:Hide()
	UIParent:SetAlpha(0)
	UIFrameFadeIn(TOPPANEL, 3, 0, 1)
	UIFrameFadeIn(BOTTOMPANEL, 3, 0, 1)
	BOTTOMPANEL:EnableMouse(true)
	Setup:Show()
	Info:Show()
	Email:Show()
end

local function fadein()
	Minimap:Show()
	UIFrameFadeIn(UIParent, 2, 0, 1)
    UIFrameFadeOut(TOPPANEL, 2, 1, 0)
	UIFrameFadeOut(BOTTOMPANEL, 2, 1, 0)
	BOTTOMPANEL:EnableMouse(false)
	Setup:Hide()
	Info:Hide()
	Email:Hide()
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

StaticPopupDialogs["Setup"] = {
	text = "Do you want to set to Deflaut Options and Reload UI? (Recommed when you use AltUI for the first time.)",
	button1 = "yes",
	button2 = "cancel",
	OnAccept = function() SetDBM() ReloadUI() end,
	OnCancel = function() 
	UIFrameFadeOut(TOPPANEL, 2, 1, 0)
	UIFrameFadeOut(BOTTOMPANEL, 2, 1, 0) 
	BOTTOMPANEL:EnableMouse(false)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true
}

Setup:SetScript('OnMouseUp', function()
	UIFrameFadeIn(UIParent, 1, 0, 1)
	StaticPopup_Show("Setup")
	Guide:Hide() Guidetext:Hide() Contacttext:Hide()
end)

Info:SetScript('OnMouseUp', function()
	if Guidetext:IsShown() then 
		Guide:Hide() Guidetext:Hide()
	else 
		Guide:Show() Guidetext:Show() Contacttext:Hide()
	end
end)

Email:SetScript('OnMouseUp', function()
	if Contacttext:IsShown() then 
		Guide:Hide() Contacttext:Hide()
	else 
		Guide:Show() Contacttext:Show() Guidetext:Hide()
	end
end)

Guide:SetScript('OnMouseUp', function()
	Guide:Hide() Guidetext:Hide() Contacttext:Hide()
end)

--====================================================--
--[[               -- Numeration --                 ]]--
--====================================================--
if IsAddOnLoaded("Numeration") then 
creategrowBD(NumerationFrame, 0, 0, 0, 0.2, 1)
NumerationFrame.border:SetPoint("TOPLEFT", "NumerationFrame", "TOPLEFT", 0, -8)
NumerationFrame.border:SetPoint("BOTTOMRIGHT", "NumerationFrame", "BOTTOMRIGHT", 2, -1)
end

--====================================================--
--[[                 -- Skada --                    ]]--test
--====================================================--
if IsAddOnLoaded("Skada") then 
local Skada = Skada
local barmod = Skada.displays["bar"]

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
barmod.ApplySettings_(self, win)
	
	local skada = win.bargroup

	skada:SetTexture(blank)
	skada:SetSpacing(1, 1)
	skada:SetFont(font, 10)
	skada:SetFrameLevel(5)
	
	skada:SetBackdrop(nil)
	if not skada.border then
		creategrowBD(skada, 0, 0, 0, 0.3, 1)
		skada.border:ClearAllPoints()
		skada.border:SetPoint('TOPLEFT', win.bargroup.button or win.bargroup, 'TOPLEFT', -3, 3)
		skada.border:SetPoint('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT', 3, -3)
	end
end

for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end
end

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