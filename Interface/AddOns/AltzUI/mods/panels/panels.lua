local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)


local font = aCoreCDB["SkinOptions"]["combattext"]
if font ~= "none" then
	DAMAGE_TEXT_FONT = G.combatFont[font]
end

--====================================================--
--[[                -- Functions --                    ]]--
--====================================================--
local function Skinbar(bar)
	if aCoreCDB["UnitframeOptions"]["style"] == 1 then	
		bar.tex:SetTexture(G.media.blank)
		bar.tex:SetGradient("VERTICAL", CreateColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1), CreateColor(G.Ccolor.r/3, G.Ccolor.g/3, G.Ccolor.b/3, 1))
	else
		bar.tex:SetTexture(G.media.ufbar)
		bar.tex:SetVertexColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	end
end

local function Skinbg(bar)
	if aCoreCDB["UnitframeOptions"]["style"] == 1 then
		bar.sd:SetBackdropColor(0, 0, 0, 0)
	else
		bar.sd:SetBackdropColor(0, 0, 0, 1)
	end
end
--====================================================--
--[[                -- Shadow --                    ]]--
--====================================================--	
local PShadow = CreateFrame("Frame", G.uiname.."Background Shadow", UIParent, "BackdropTemplate")
PShadow:SetFrameStrata("BACKGROUND")
PShadow:SetAllPoints()
PShadow:SetBackdrop({bgFile = "Interface\\AddOns\\AltzUI\\media\\shadow"})
PShadow:SetBackdropColor(0, 0, 0, 0.3)

--====================================================--
--[[                 -- Panels --                   ]]--
--====================================================--

local toppanel = CreateFrame("Frame", G.uiname.."Top Long Panel", UIParent, "BackdropTemplate")
toppanel:SetFrameStrata("BACKGROUND")
toppanel:SetPoint("TOP", 0, 3)
toppanel:SetPoint("LEFT", UIParent, "LEFT", -8, 0)
toppanel:SetPoint("RIGHT", UIParent, "RIGHT", 8, 0)
toppanel:SetHeight(15)

toppanel.tex = toppanel:CreateTexture(nil, "ARTWORK")
toppanel.tex:SetAllPoints()
toppanel.tex:SetTexture(G.media.blank)
toppanel.tex:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15),CreateColor(.25,.25,.25,.6))

toppanel.sd = T.createBackdrop(toppanel, toppanel, 1)

local TLPanel = CreateFrame("Frame", G.uiname.."TLPanel", UIParent)
TLPanel:SetFrameStrata("BACKGROUND")
TLPanel:SetFrameLevel(2)
TLPanel:SetSize(G.screenwidth*2/9, 5)
TLPanel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -10)
T.CreateSD(TLPanel, 2, 0, 0, 0, 0, -1)
TLPanel.tex = TLPanel:CreateTexture(nil, "ARTWORK")
TLPanel.tex:SetAllPoints()
TLPanel.Apply = function()
	if aCoreCDB["SkinOptions"]["showtopconerbar"] then
		TLPanel:Show()
	else
		TLPanel:Hide()
	end
	Skinbar(TLPanel) 
end
TLPanel.Apply()
G.TLPanel = TLPanel

local TRPanel = CreateFrame("Frame", G.uiname.."TRPanel", UIParent)
TRPanel:SetFrameStrata("BACKGROUND")
TRPanel:SetFrameLevel(2)
TRPanel:SetSize(G.screenwidth*2/9, 5)
TRPanel:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -15, -10)
T.CreateSD(TRPanel, 2, 0, 0, 0, 0, -1)
TRPanel.tex = TRPanel:CreateTexture(nil, "ARTWORK")
TRPanel.tex:SetAllPoints()
TRPanel.Apply = function()
	if aCoreCDB["SkinOptions"]["showtopconerbar"] then
		TRPanel:Show()
	else
		TRPanel:Hide()
	end
	Skinbar(TRPanel)
end
TRPanel.Apply()
G.TRPanel = TRPanel

toppanel.Apply = function()
	if aCoreCDB["SkinOptions"]["showtopbar"] then
		toppanel:Show()
	else
		toppanel:Hide()
	end
	if aCoreCDB["SkinOptions"]["showtopconerbar"] then
		toppanel.sd:SetBackdropBorderColor(0, 0, 0)
	else
		toppanel.sd:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	end
	Skinbg(toppanel)
end
toppanel.Apply()
G.toppanel = toppanel

local bottompanel = CreateFrame("Frame", G.uiname.."Bottom Long Panel", UIParent, "BackdropTemplate")
bottompanel:SetFrameStrata("BACKGROUND")
bottompanel:SetPoint("BOTTOM", 0, -3)
bottompanel:SetPoint("LEFT", UIParent, "LEFT", -8, 0)
bottompanel:SetPoint("RIGHT", UIParent, "RIGHT", 8, 0)
bottompanel:SetHeight(15)

bottompanel.tex = bottompanel:CreateTexture(nil, "ARTWORK")
bottompanel.tex:SetAllPoints()
bottompanel.tex:SetTexture(G.media.blank)
bottompanel.tex:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15), CreateColor(.25,.25,.25,.6))

bottompanel.sd = T.createBackdrop(bottompanel, bottompanel, 1)

local BLPanel = CreateFrame("Frame", G.uiname.."BLPanel", UIParent)
BLPanel:SetFrameStrata("BACKGROUND")
BLPanel:SetFrameLevel(2)
BLPanel:SetSize(G.screenwidth*2/9, 5)
BLPanel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 15, 10)
T.CreateSD(BLPanel, 2, 0, 0, 0, 0, -1)
BLPanel.tex = BLPanel:CreateTexture(nil, "ARTWORK")
BLPanel.tex:SetAllPoints()
BLPanel.Apply = function()
	if aCoreCDB["SkinOptions"]["showbottomconerbar"] then
		BLPanel:Show()
	else
		BLPanel:Hide()
	end
	Skinbar(BLPanel)
end
BLPanel.Apply()
G.BLPanel = BLPanel

local BRPanel = CreateFrame("Frame", G.uiname.."BRPanel", UIParent)
BRPanel:SetFrameStrata("BACKGROUND")
BRPanel:SetFrameLevel(2)
BRPanel:SetSize(G.screenwidth*2/9, 5)
BRPanel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 10)
T.CreateSD(BRPanel, 2, 0, 0, 0, 0, -1)
BRPanel.tex = BRPanel:CreateTexture(nil, "ARTWORK")
BRPanel.tex:SetAllPoints()
BRPanel.Apply = function()
	if aCoreCDB["SkinOptions"]["showbottomconerbar"] then
		BRPanel:Show()
	else
		BRPanel:Hide()
	end
	Skinbar(BRPanel)
end
BRPanel.Apply()
G.BRPanel = BRPanel

bottompanel.Apply = function()
	if aCoreCDB["SkinOptions"]["showbottombar"] then
		bottompanel:Show()
	else
		bottompanel:Hide()
	end
	if aCoreCDB["SkinOptions"]["showbottomconerbar"] then
		bottompanel.sd:SetBackdropBorderColor(0, 0, 0)
	else
		bottompanel.sd:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	end
	Skinbg(bottompanel)
end
bottompanel.Apply()
G.bottompanel = bottompanel
--====================================================--
--[[                   -- Minimap --                ]]--
--====================================================--

local minimap_height = aCoreCDB["SkinOptions"]["minimapheight"]

local minimap_anchor = CreateFrame("Frame", G.uiname.."minimap_anchor", UIParent)
minimap_anchor:SetWidth(minimap_height)
minimap_anchor:SetHeight(minimap_height)
minimap_anchor:SetFrameStrata("BACKGROUND")
minimap_anchor.border = F.CreateBDFrame(minimap_anchor, 0.6)
T.CreateSD(minimap_anchor.border, 2, 0, 0, 0, 0, -1)

minimap_anchor.movingname = L["小地图"]
minimap_anchor.point = {
	healer = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -10, y = 95},
	dpser = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -10, y = 95},
}
T.CreateDragFrame(minimap_anchor)

-- 小地图
Minimap:SetParent(minimap_anchor)
Minimap:SetWidth(minimap_height)
Minimap:SetHeight(minimap_height)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
function GetMinimapShape() return 'SQUARE' end
MinimapBackdrop:SetAlpha(0)
hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function()
	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER", minimap_anchor, "CENTER")
end)

-- 右键打开追踪
MinimapCluster.Tracking:Hide()
MinimapCluster.Tracking.Show = function() MinimapCluster.Tracking:Hide() end
Minimap:SetScript('OnMouseUp', function (self, button)
	if button == 'RightButton' then
		GameTooltip:Hide()
		ToggleDropDownMenu(1, nil, MinimapCluster.Tracking.DropDown, Minimap, (Minimap:GetWidth()+8), (Minimap:GetHeight()))
		DropDownList1:ClearAllPoints()
		if select(2, Minimap:GetCenter())/G.screenheight > .5 then -- In the upper part of the screen
			DropDownList1:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -8)
		else
			DropDownList1:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 8)
		end
	end
end)

-- 整合按钮
local buttons = {}
local BlackList = { 
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MinimapBackdrop"] = true,
	["MinimapButtonCollectFrame"] = true,
	["MinimapButtonCollectFrame_Toggle"] = true,
}

local MBCF = CreateFrame("Frame", "MinimapButtonCollectFrame", Minimap)

if aCoreCDB["SkinOptions"]["MBCFpos"] == "TOP" then
	MBCF:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
	MBCF:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 5)
else
	MBCF:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -5)
	MBCF:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -5)
end

MBCF:SetHeight(20)
MBCF.bg = MBCF:CreateTexture(nil, "BACKGROUND")
MBCF.bg:SetTexture(G.media.blank)
MBCF.bg:SetAllPoints(MBCF)
MBCF.bg:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, .8), CreateColor(0, 0, 0, 0))

MBCF_Toggle = CreateFrame("Frame", "MinimapButtonCollectFrame_Toggle", Minimap)
MBCF_Toggle:SetFrameStrata("MEDIUM")
MBCF_Toggle:SetSize(20,20)
MBCF_Toggle:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5, -5)
MBCF_Toggle.tex = MBCF_Toggle:CreateTexture(nil, "ARTWORK")
MBCF_Toggle.tex:SetTexture(516768)
MBCF_Toggle.tex:SetAllPoints(MBCF_Toggle)

MBCF_Toggle:SetScript("OnMouseDown", function(self)
	if MBCF:IsShown() then
		MBCF:Hide()
	else
		MBCF:Show()
	end
end)

T.ArrangeMinimapButtons = function(parent)
	if #buttons == 0 then 
		parent:Hide()
		return
	end

	local lastbutton
	for k, button in pairs(buttons) do
		button:ClearAllPoints()
		if button:IsShown() then
			if not lastbutton then
				button:SetPoint("LEFT", parent, "LEFT", 0, 0)
			else
				button:SetPoint("LEFT", lastbutton, "RIGHT", 5, 0)
			end
			lastbutton = button
		end
	end
end

T.CollectMinimapButtons = function(parent)
	if aCoreCDB["SkinOptions"]["collectminimapbuttons"] then
		for i, child in ipairs({Minimap:GetChildren()}) do
			if child:GetName() and not BlackList[child:GetName()] then
				if child:GetObjectType() == "Button" or strupper(child:GetName()):match("BUTTON") then
					child:SetParent(parent)
					child:SetSize(25, 25)
					for j = 1, child:GetNumRegions() do
						local region = select(j, child:GetRegions())
						if region:GetObjectType() == "Texture" then
							local texture = region:GetTexture()
							if texture then
								if (string.find(texture, "Interface\\CharacterFrame") or string.find(texture, "Interface\\Minimap")) then
									region:SetTexture(nil)
								elseif texture == 136430 or texture == 136467 then 
									region:SetTexture(nil)
								end
							end
						end
					end
					
					child:HookScript("OnShow", function() 
						T.ArrangeMinimapButtons(parent)
					end)
					child:HookScript("OnHide", function() 
						T.ArrangeMinimapButtons(parent)
					end)
					child:SetScript("OnDragStart", nil)
					child:SetScript("OnDragStop", nil)
					tinsert(buttons, child)
				end
			end
		end
	end
end

MBCF:SetScript("OnEvent", function(self)
	C_Timer.After(0.3, function()
		T.CollectMinimapButtons(MBCF)
		T.ArrangeMinimapButtons(MBCF)
	end)
	self:Hide()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

MBCF:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 缩放按钮
Minimap.ZoomIn:Hide()
Minimap.ZoomIn.Show = function() Minimap.ZoomIn:Hide() end
Minimap.ZoomOut:Hide()
Minimap.ZoomOut.Show = function() Minimap.ZoomOut:Hide() end

-- 地图
MinimapCluster.BorderTop:Hide()
MinimapCluster.ZoneTextButton:ClearAllPoints()
MinimapCluster.ZoneTextButton:SetPoint("CENTER", Minimap, "CENTER", 0, 20)
MinimapCluster.ZoneTextButton:EnableMouse(false)
MinimapCluster.ZoneTextButton:Hide()
MinimapZoneText:SetFont(G.norFont, 12, "OUTLINE") 
MinimapZoneText:SetShadowOffset(0, 0)
MinimapZoneText:SetJustifyH("CENTER")

Minimap:HookScript("OnEvent",function(self,event,...)
	if event=="ZONE_CHANGED_NEW_AREA" and not WorldMapFrame:IsShown() then
		SetMapToCurrentZone();
	end
end)

Minimap:HookScript("OnEnter", function() MinimapCluster.ZoneTextButton:Show() end)
Minimap:HookScript("OnLeave", function() MinimapCluster.ZoneTextButton:Hide() end)

-- 邮件
MinimapCluster.IndicatorFrame.MailFrame:ClearAllPoints()
MinimapCluster.IndicatorFrame.MailFrame:SetPoint("TOP", Minimap, "TOP", 0, -5)
MinimapCluster.IndicatorFrame.MailFrame.SetPoint = function() end
MinimapCluster.IndicatorFrame.MailFrame:SetHitRectInsets(-5, -5, -5, -5)	

-- 日历
--GameTimeFrame:ClearAllPoints()
--GameTimeFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -5, 5)
--GameTimeFrame.SetPoint = function() end

-- 时间
--if not IsAddOnLoaded("Blizzard_TimeManager") then LoadAddOn("Blizzard_TimeManager") end
--TimeManagerClockButton:ClearAllPoints()
--TimeManagerClockButton:SetPoint("RIGHT", GameTimeFrame, "LEFT", -5, -1)
--TimeManagerClockTicker:SetFont(G.norFont, 12, "OUTLINE") 
--TimeManagerClockTicker:SetShadowOffset(0, 0)
--TimeManagerClockTicker:SetJustifyH("RIGHT")

-- 附加按钮
--ExpansionLandingPageMinimapButton:SetParent(Minimap)

-- 经验条
local xpbar = CreateFrame("StatusBar", G.uiname.."ExperienceBar", Minimap)
xpbar:SetWidth(5)
xpbar:SetOrientation("VERTICAL")
xpbar:SetStatusBarTexture(G.media.blank)
xpbar:SetStatusBarColor(.3, .4, 1)
xpbar:SetFrameLevel(Minimap:GetFrameLevel()+3)
xpbar.border = F.CreateBDFrame(xpbar, .8)

local repbar = CreateFrame("StatusBar", G.uiname.."WatchedFactionBar", Minimap)
repbar:SetWidth(5)
repbar:SetOrientation("VERTICAL")
repbar:SetStatusBarTexture(G.media.blank)
repbar:SetStatusBarColor(.4, 1, .2)
repbar:SetFrameLevel(Minimap:GetFrameLevel()+3)
repbar.border = F.CreateBDFrame(repbar, .8)

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
		
xpbar:SetScript("OnEnter", function()
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()
	
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		GameTooltip:AddDoubleLine(L["当前经验"], string.format("%s/%s (%d%%)", CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["剩余经验"], string.format("%s", CommaValue(maxXP-XP)), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
		if restXP then GameTooltip:AddDoubleLine(L["双倍"], string.format("|cffb3e1ff%s (%d%%)", CommaValue(restXP), restXP/maxXP*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end
	end
	
	GameTooltip:Show()
end)
xpbar:SetScript("OnLeave", function() GameTooltip:Hide() end)

repbar:SetScript("OnEnter", function()
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	
	local name, rank, minRep, maxRep, value, factionID = GetWatchedFactionInfo()
	local ranktext = _G["FACTION_STANDING_LABEL"..rank]
	
	if name then
		local minrep, maxrep, valuerep
		if C_GossipInfo.GetFriendshipReputation(factionID) then
			local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = C_GossipInfo.GetFriendshipReputation(factionID)
			minrep, maxrep, valuerep = friendThreshold, nextFriendThreshold, friendRep
			ranktext = friendTextLevel and string.format(" (%s)", friendTextLevel) or ""
		elseif C_Reputation.IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
			minrep, maxrep, valuerep = 0, threshold, mod(currentValue, threshold)
		else
			minrep, maxrep, valuerep = minRep, maxRep, value
		end
		
		GameTooltip:AddLine(name..ranktext, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		
		if maxrep and maxrep > valuerep then
			GameTooltip:AddDoubleLine(L["声望"], string.format("%s/%s (%d%%)", CommaValue(valuerep-minrep), CommaValue(maxrep-minrep), (valuerep-minrep)/(maxrep-minrep)*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
			GameTooltip:AddDoubleLine(L["剩余声望"], string.format("%s", CommaValue(maxrep-valuerep)), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
		end
	end	
	
	GameTooltip:Show()
end)
repbar:SetScript("OnLeave", function() GameTooltip:Hide() end)
repbar:SetScript("OnMouseDown", function() ToggleCharacter("ReputationFrame") end)

xpbar:SetScript("OnEvent", function(self, event, arg1)
	local name, reaction, minRep, maxRep, value, factionID = GetWatchedFactionInfo()
	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
	local newLevel = UnitLevel("player")
	
	local showAzerite = C_AzeriteItem.HasActiveAzeriteItem()
	local showXP = newLevel < MAX_PLAYER_LEVEL and not IsXPUserDisabled()
	local showRep = name
	
	if event == "PLAYER_LOGIN" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_XP_UPDATE" then
		if showXP then
			xpbar:Show()
			local XP, maxXP = UnitXP("player"), UnitXPMax("player")
			xpbar:SetMinMaxValues(min(0, XP), maxXP)
			xpbar:SetValue(XP)
		else
			xpbar:Hide()
		end
	end
	
	if event == "PLAYER_LOGIN" or event == "UPDATE_FACTION" then
		if showRep then
			repbar:Show()
			local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
			
			if C_GossipInfo.GetFriendshipReputation(factionID) then
				local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = C_GossipInfo.GetFriendshipReputation(factionID)
				if ( nextFriendThreshold ) then
					repbar:SetMinMaxValues(friendThreshold, nextFriendThreshold)
					repbar:SetValue(friendRep)
				else
					repbar:SetMinMaxValues(0, 1)
					repbar:SetValue(1)
				end
			elseif C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
				repbar:SetMinMaxValues(0, threshold)
				repbar:SetValue(mod(currentValue, threshold))
			elseif reaction == MAX_REPUTATION_REACTION then
				repbar:SetMinMaxValues(0, 1)
				repbar:SetValue(1)
			else
				repbar:SetMinMaxValues(minRep, maxRep)
				repbar:SetValue(value)
			end
		else
			repbar:Hide()
		end
	end
	
	if showXP then
		xpbar:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
		xpbar:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
		if showRep then
			repbar:SetPoint("BOTTOMRIGHT", xpbar, "BOTTOMLEFT", -1, 0)
			repbar:SetPoint("TOPRIGHT", xpbar, "TOPLEFT", -1, 0)
		end
	elseif showRep then
		repbar:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
		repbar:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
	end
end)

xpbar:RegisterEvent("PLAYER_XP_UPDATE")
xpbar:RegisterEvent("UPDATE_FACTION")
xpbar:RegisterEvent("PLAYER_LEVEL_UP")
xpbar:RegisterEvent("PLAYER_LOGIN")
xpbar:RegisterEvent("UNIT_INVENTORY_CHANGED")
xpbar:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")

--====================================================--
--[[                --  Info Bar --              ]]--
--====================================================--
local InfoFrame = CreateFrame("Frame", G.uiname.."Info Frame", UIParent)
InfoFrame:SetScale(aCoreCDB["SkinOptions"]["infobarscale"])
InfoFrame:SetFrameLevel(4)
InfoFrame:SetSize(260, 20)
InfoFrame.movingname = L["信息条"]
InfoFrame.point = {
		healer = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 5},
		dpser = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 5},
	}
T.CreateDragFrame(InfoFrame)

if not aCoreCDB["SkinOptions"]["infobar"] then
	InfoFrame:Hide()
end

local function CreateInfoButton(name, parent, width, height, justify, ...)
	local Button = CreateFrame("Frame", G.uiname..parent:GetName()..name, parent)
	Button:SetSize(width, height)
	Button:SetPoint(...)
	
	Button.text = T.createtext(Button, "OVERLAY", 12, "OUTLINE", justify)
	Button.text:SetPoint(justify)
	
	return Button
end

-- 耐久
local Durability = CreateInfoButton("Durability", InfoFrame, 40, 20, "CENTER", "CENTER", InfoFrame, "CENTER", 20, 0)

local SLOTS = {}
for _,slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do 
	SLOTS[slot] = GetInventorySlotInfo(slot .. "Slot")
end

local function GetLowestDurability()
	local l = 1
	for slot,id in pairs(SLOTS) do
		local d, md = GetInventoryItemDurability(id)
		if d and md and md ~= 0 then
			l = math.min(d/md, l)
		end
	end
	return l
end

local EquipSetsMenu = CreateFrame("Frame", G.uiname.."EquipSetsMenu", UIParent, "UIDropDownMenuTemplate")
local EquipSetsList = {}

local function UpdateEquipSetsList()
	local count = C_EquipmentSet.GetNumEquipmentSets()
	if count > 0 then
		EquipSetsList = {}
		for index = 1, count do 
			local name, Icon, setID, isEquipped, totalItems, equippedItems, inventoryItems, missingItems, ignoredSlots = C_EquipmentSet.GetEquipmentSetInfo(index)
			EquipSetsList[index] = {
				text = name,
				icon = Icon,
				tCoordLeft = .1, tCoordRight = .9, tCoordTop = .1, tCoordBottom = .9,
				checked = isEquipped,
				func = function() C_EquipmentSet.UseEquipmentSet(index) end
			}
		end
	end
end

Durability:SetScript("OnMouseDown", function(self)
	if not InCombatLockdown() and C_EquipmentSet.GetNumEquipmentSets() > 0 then
		UpdateEquipSetsList()
		EasyMenu(EquipSetsList, EquipSetsMenu, "cursor", 0, 0, "MENU", 2)
		DropDownList1:ClearAllPoints()
		if select(2, InfoFrame:GetCenter())/G.screenheight > .5 then -- In the upper part of the screen
			DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -5, -5)
		else
			DropDownList1:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, 5)
		end
	end
end)

Durability:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
		self.text:SetText(format("%d"..G.classcolor.."dur|r", GetLowestDurability()*100))
end)

Durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Durability:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 延迟和帧数
local Net_Stats = CreateInfoButton("Net_Stats", InfoFrame, 80, 20, "RIGHT", "RIGHT", Durability, "LEFT", -5, 0)

-- Format String
local memFormat = function(num)
	if num > 1024 then
		return format("%.2f mb", (num / 1024))
	else
		return format("%.1f kb", floor(num))
	end
end

Net_Stats.t = 0
Net_Stats:SetScript("OnUpdate", function(self, elapsed)
	self.t = self.t + elapsed
	if self.t > 3 then -- 每秒刷新一次
		fps = format("%d"..G.classcolor.."fps|r", GetFramerate())
		lag = format("%d"..G.classcolor.."ms|r", select(4, GetNetStats()))	
		self.text:SetText(fps.."  "..lag)
		self.t = 0
	end
end)

local NUM_ADDONS_TO_DISPLAY = 20;
local topAddOns = {}
for i=1, NUM_ADDONS_TO_DISPLAY do
	topAddOns[i] = { value = 0, name = "" }
end

Net_Stats:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	
	if select(2, InfoFrame:GetCenter())/G.screenheight > .5 then -- In the upper part of the screen
		GameTooltip:SetPoint("TOP", InfoFrame, "BOTTOM", 0, -5)
	else
		GameTooltip:SetPoint("BOTTOM", InfoFrame, "TOP", 0, 5)
	end

	for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
		topAddOns[i].value = 0
	end

	UpdateAddOnMemoryUsage()
	local totalMem = 0

	for i=1, GetNumAddOns(), 1 do
		local mem = GetAddOnMemoryUsage(i)
		totalMem = totalMem + mem
		for j=1, NUM_ADDONS_TO_DISPLAY, 1 do
			if( mem > topAddOns[j].value ) then
				for k= NUM_ADDONS_TO_DISPLAY, 1, -1 do
					if( k == j ) then
						topAddOns[k].value = mem
						topAddOns[k].name = GetAddOnInfo(i)
						break
					elseif( k ~= 1 ) then
						topAddOns[k].value = topAddOns[k-1].value
						topAddOns[k].name = topAddOns[k-1].name
					end
				end
				break
			end
		end
	end

	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
	
	if ( totalMem > 0 ) then
		GameTooltip:AddLine(format(L["占用前 %d 的插件"], min(NUM_ADDONS_TO_DISPLAY,GetNumAddOns())), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		GameTooltip:AddLine(" ")
		
		for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
			if ( topAddOns[i].value == 0 ) then
				break
			end
			GameTooltip:AddDoubleLine(topAddOns[i].name, memFormat(topAddOns[i].value), 1, 1, 1, T.ColorGradient(topAddOns[i].value / 1024, 0, 1, 0, 1, 1, 0, 1, 0, 0))
		end
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["自定义插件占用"], memFormat(totalMem), 1, 1, 1, T.ColorGradient(totalMem / (1024*20), 0, 1, 0, 1, 1, 0, 1, 0, 0))
		GameTooltip:AddDoubleLine(L["所有插件占用"], memFormat(collectgarbage("count")), 1, 1, 1, T.ColorGradient(collectgarbage("count") / (1024*50) , 0, 1, 0, 1, 1, 0, 1, 0, 0))
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld), 1, 1, 1)
		
		GameTooltip:Show()		
	end
end)
 
Net_Stats:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

-- 天赋
local Talent = CreateInfoButton("Talent", InfoFrame, 40, 20, "LEFT", "LEFT", Durability, "RIGHT", 10, 0)

local LootSpecMenu = CreateFrame("Frame", G.uiname.."LootSpecMenu", UIParent, "UIDropDownMenuTemplate")

local SpecList = {
	{ text = TALENTS_BUTTON, notCheckable = true, func = function() ToggleTalentFrame() end},
	{ text = SELECT_LOOT_SPECIALIZATION, notCheckable = true, hasArrow = 1,
		menuList = {
			{ text = LOOT_SPECIALIZATION_DEFAULT, specializationID = 0 },
			{ text = "spec1", specializationID = 0 },
			{ text = "spec2", specializationID = 0 },
			{ text = "spec3", specializationID = 0 },
			{ text = "spec4", specializationID = 0 },	
		}
	},
	{ text = L["切天赋"], notCheckable = true, hasArrow = 1,
			menuList = {
			{ text = "spec1", specializationID = 0 },
			{ text = "spec2", specializationID = 0 },
			{ text = "spec3", specializationID = 0 },
			{ text = "spec4", specializationID = 0 },	
		}
	},
}

local numspec = 4
if G.myClass ~= "DRUID" then
	tremove(SpecList[2]["menuList"], 5)
	tremove(SpecList[3]["menuList"], 4)
	numspec = 3
end

local function TalentOnClick(self, button)
	if UnitLevel("player")>=10 then -- 10 级别后有天赋
		EasyMenu(SpecList, LootSpecMenu, "cursor", 0, 0, "MENU", 2)
		DropDownList1:ClearAllPoints()
		if select(2, InfoFrame:GetCenter())/G.screenheight > .5 then -- In the upper part of the screen
			DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -5, -5)
		else
			DropDownList1:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, 5)
		end
	end
end

Talent:SetScript("OnMouseDown", TalentOnClick)

Talent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	
	local specIndex = GetSpecialization()
	local Loot_specIndex = GetLootSpecialization()

	if specIndex then
		local specID, specName = GetSpecializationInfo(specIndex)
		local Loot_specID, Loot_specName = GetSpecializationInfoByID(Loot_specIndex)
		
		if specName then
			if Loot_specName then
				self.text:SetText(format(G.classcolor.."%s ("..SELECT_LOOT_SPECIALIZATION.." %s)|r", specName, Loot_specName))
			else
				self.text:SetText(format(G.classcolor.."%s|r", specName))
			end
			
			SpecList[2]["disabled"] = false
			SpecList[3]["disabled"] = false
			
			local specPopupButton = SpecList[2]["menuList"][1]
			specPopupButton.text = format(LOOT_SPECIALIZATION_DEFAULT, specName)
			specPopupButton.func = function(self) SetLootSpecialization(0) end
			if GetLootSpecialization() == specPopupButton.specializationID then
				specPopupButton.checked = true
			else
				specPopupButton.checked = false
			end

			for index = 2, numspec+1 do
				specPopupButton = SpecList[2]["menuList"][index]
				if specPopupButton then
					local id, name = GetSpecializationInfo(index-1)
					specPopupButton.specializationID = id
					specPopupButton.text = name
					specPopupButton.func = function(self) 
						SetLootSpecialization(id)
					end
					if GetLootSpecialization() == specPopupButton.specializationID then
						specPopupButton.checked = true
					else
						specPopupButton.checked = false
					end
				end
			end
			
			for index = 1, numspec do
				specbutton = SpecList[3]["menuList"][index]
				if specbutton then
					local _, name = GetSpecializationInfo(index)
					specbutton.specializationID = index
					specbutton.text = name
					specbutton.func = function(self) SetSpecialization(index) end
					if GetSpecialization() == specbutton.specializationID then
						specbutton.checked = true
					else
						specbutton.checked = false
					end
				end
			end
		end
	else
		SpecList[2]["disabled"] = true
		SpecList[3]["disabled"] = true
		self.text:SetText(G.classcolor.."No Talents|r")
	end
end)

Talent:RegisterEvent("PLAYER_ENTERING_WORLD")

--====================================================--
--[[                  -- Game menu --               ]]--
--====================================================--

local GameMenuButton = CreateFrame("Button", G.uiname.."GameMenuButton", GameMenuFrame, "GameMenuButtonTemplate")
GameMenuButton:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -1)
GameMenuButton:SetScript("OnClick", function()
	_G[G.uiname.."GUI Main Frame"]:Show()
	HideUIPanel(GameMenuFrame)
end)
GameMenuButton:SetText(C_AddOns.GetAddOnMetadata("AltzUI", "Title"))
F.Reskin(GameMenuButton)

GameMenuFrame:HookScript("OnShow", function()
	_G[G.uiname.."GUI Main Frame"]:Hide()
end)

GameMenuButtonRatings:SetPoint("TOP", GameMenuButton, "BOTTOM", 0, -1)

function GameMenuFrame_UpdateVisibleButtons(self)
	local height = 332;

	local buttonToReanchor = GameMenuButtonWhatsNew;
	local reanchorYOffset = -1;

	if IsCharacterNewlyBoosted() or not C_SplashScreen.CanViewSplashScreen()  then
		GameMenuButtonWhatsNew:Hide();
		height = height - 20;
		buttonToReanchor = GameMenuButtonOptions;
		reanchorYOffset = -16;
	else
		GameMenuButtonWhatsNew:Show();
	end

	if ( C_StorePublic.IsEnabled() ) then
		height = height + 20;
		GameMenuButtonStore:Show();
		buttonToReanchor:SetPoint("TOP", GameMenuButtonStore, "BOTTOM", 0, reanchorYOffset);
	else
		GameMenuButtonStore:Hide();
		buttonToReanchor:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, reanchorYOffset);
	end
	
	if ( GameMenuButtonRatings:IsShown() ) then
		height = height + 20;
		GameMenuButtonLogout:SetPoint("TOP", GameMenuButtonRatings, "BOTTOM", 0, -16);
	else
		GameMenuButtonLogout:SetPoint("TOP", GameMenuButton, "BOTTOM", 0, -16)
	end

	self:SetHeight(height);
end

--====================================================--
--[[          --  Order Hall Command Bar --         ]]--
--====================================================--

local OrderHall_eframe = CreateFrame("Frame")
OrderHall_eframe:RegisterEvent("ADDON_LOADED")

OrderHall_eframe:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
		OrderHall_eframe:RegisterEvent("DISPLAY_SIZE_CHANGED")
		OrderHall_eframe:RegisterEvent("UI_SCALE_CHANGED")
		OrderHall_eframe:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
		OrderHall_eframe:RegisterEvent("GARRISON_FOLLOWER_ADDED")
		OrderHall_eframe:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
		
		OrderHallCommandBar:HookScript("OnShow", function()
			if not OrderHallCommandBar.styled then
				OrderHallCommandBar:EnableMouse(false)
				OrderHallCommandBar.Background:SetAtlas(nil)
				
				OrderHallCommandBar.ClassIcon:ClearAllPoints()
				OrderHallCommandBar.ClassIcon:SetPoint("TOPLEFT", 15, -20)
				OrderHallCommandBar.ClassIcon:SetSize(40,20)
				OrderHallCommandBar.ClassIcon:SetAlpha(1)
				local bg = F.CreateBDFrame(OrderHallCommandBar.ClassIcon, 0)
				F.CreateBD(bg, 1)
				
				OrderHallCommandBar.AreaName:ClearAllPoints()
				OrderHallCommandBar.AreaName:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 5, 0)
				OrderHallCommandBar.AreaName:SetFont(G.norFont, 14, "OUTLINE")
				OrderHallCommandBar.AreaName:SetTextColor(1, 1, 1)
				OrderHallCommandBar.AreaName:SetShadowOffset(0, 0)
				
				OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
				OrderHallCommandBar.CurrencyIcon:SetPoint("LEFT", OrderHallCommandBar.AreaName, "RIGHT", 5, 0)
				OrderHallCommandBar.Currency:ClearAllPoints()
				OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 5, 0)
				OrderHallCommandBar.Currency:SetFont(G.norFont, 14, "OUTLINE")
				OrderHallCommandBar.Currency:SetTextColor(1, 1, 1)
				OrderHallCommandBar.Currency:SetShadowOffset(0, 0)
				
				OrderHallCommandBar.CurrencyHitTest:ClearAllPoints()
				OrderHallCommandBar.CurrencyHitTest:SetAllPoints(OrderHallCommandBar.CurrencyIcon)
								
				OrderHallCommandBar.WorldMapButton:Hide()
				
				OrderHallCommandBar.styled = true
			end
		end)
	elseif event ~= "ADDON_LOADED" then
		local index = 1
		C_Timer.After(0.1, function()
			for i, child in ipairs({OrderHallCommandBar:GetChildren()}) do
				if child.Icon and child.Count and child.TroopPortraitCover then
					child:SetPoint("TOPLEFT", OrderHallCommandBar.ClassIcon, "BOTTOMLEFT", -5, -index*25+20)
					child.TroopPortraitCover:Hide()
					
					child.Icon:SetSize(40,20)
					local bg = F.CreateBDFrame(child.Icon, 0)
					F.CreateBD(bg, 1)
					
					child.Count:SetFont(G.norFont, 14, "OUTLINE")
					child.Count:SetTextColor(1, 1, 1)
					child.Count:SetShadowOffset(0, 0)
					
					index = index + 1
				end
			end
		end)
	end
end)

--====================================================--
--[[                 -- Screen --                   ]]--
--====================================================--

local BOTTOMPANEL = CreateFrame("Frame", G.uiname.."AFK Bottompanel", WorldFrame)
BOTTOMPANEL:SetFrameStrata("FULLSCREEN")
BOTTOMPANEL:SetPoint("BOTTOMLEFT",WorldFrame,"BOTTOMLEFT",-5,-5)
BOTTOMPANEL:SetPoint("TOPRIGHT",WorldFrame,"BOTTOMRIGHT",5,60)
F.SetBD(BOTTOMPANEL)
BOTTOMPANEL:Hide()

BOTTOMPANEL.petmodelbutton = CreateFrame("PlayerModel", G.uiname.."AFKpetmodel", BOTTOMPANEL)
BOTTOMPANEL.petmodelbutton:SetSize(120,120)
BOTTOMPANEL.petmodelbutton:SetPosition(-0.5, 0, 0)
BOTTOMPANEL.petmodelbutton:SetPoint("CENTER", BOTTOMPANEL, "TOPRIGHT", -190, 0)

BOTTOMPANEL.petmodelbutton.text = T.createtext(BOTTOMPANEL.petmodelbutton, "OVERLAY", 13, "OUTLINE", "RIGHT")
BOTTOMPANEL.petmodelbutton.text:SetPoint("CENTER")
BOTTOMPANEL.petmodelbutton.text:SetText("AltzUI")

BOTTOMPANEL.tipframe = CreateFrame("Frame", G.uiname.."AFK tips", BOTTOMPANEL)
BOTTOMPANEL.tipframe:SetHeight(40)
BOTTOMPANEL.tipframe:SetPoint("LEFT", BOTTOMPANEL, "LEFT", 200, 0)
BOTTOMPANEL.tipframe:SetPoint("RIGHT", BOTTOMPANEL, "RIGHT", -200, 0)
BOTTOMPANEL.tipframe:Hide()

BOTTOMPANEL.tipframe.text = T.createtext(BOTTOMPANEL.tipframe, "OVERLAY", 8, "OUTLINE", "CENTER")
BOTTOMPANEL.tipframe.text:SetPoint("BOTTOM", BOTTOMPANEL.tipframe, "CENTER", 0, 0)
BOTTOMPANEL.tipframe.text:SetPoint("LEFT")
BOTTOMPANEL.tipframe.text:SetPoint("RIGHT")

local current_tip = 1

local function SetRandomTip()
	local index = random(1 , #L["TIPS"])
	BOTTOMPANEL.tipframe.text:SetText(L["TIPS"][index])
	current_tip = index
end

local function SetTip(index)
	BOTTOMPANEL.tipframe.text:SetText(L["TIPS"][index])
	current_tip = index
end

local function Previous_tip()
	if current_tip == 1 then
		SetTip(#L["TIPS"])
	else
		SetTip(current_tip - 1)
	end
end

local function Next_tip()
	if current_tip == #L["TIPS"] then
		SetTip(1)
	else
		SetTip(current_tip + 1)
	end
end

StaticPopupDialogs[G.uiname.."hideAFKtips"] = {
	text = L["隐藏提示的提示"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

local function DontShowTips()
	aCoreCDB["OtherOptions"]["showAFKtips"] = false
	BOTTOMPANEL.tipframe:Hide()
	StaticPopup_Show(G.uiname.."hideAFKtips")
	T.fadein()
end

BOTTOMPANEL.tipframe.next = CreateFrame("Button", G.uiname.."Next tip Button", BOTTOMPANEL.tipframe, "UIPanelButtonTemplate")
BOTTOMPANEL.tipframe.next:SetSize(120,15)
BOTTOMPANEL.tipframe.next:SetPoint("TOP", BOTTOMPANEL.tipframe, "CENTER", 0, -5)
BOTTOMPANEL.tipframe.next:SetText(L["下一条"])
BOTTOMPANEL.tipframe.next:Hide()
_G[G.uiname.."Next tip ButtonText"]:SetFont(G.norFont, 8, "OUTLINE")
F.Reskin(BOTTOMPANEL.tipframe.next)

BOTTOMPANEL.tipframe.next:SetScript("OnClick", Next_tip)

BOTTOMPANEL.tipframe.previous = CreateFrame("Button", G.uiname.."Previous tip Button", BOTTOMPANEL.tipframe, "UIPanelButtonTemplate")
BOTTOMPANEL.tipframe.previous:SetSize(120,15)
BOTTOMPANEL.tipframe.previous:SetPoint("RIGHT", BOTTOMPANEL.tipframe.next, "LEFT", -5, 0)
BOTTOMPANEL.tipframe.previous:SetText(L["上一条"])
BOTTOMPANEL.tipframe.previous:Hide()
_G[G.uiname.."Previous tip ButtonText"]:SetFont(G.norFont, 8, "OUTLINE")
F.Reskin(BOTTOMPANEL.tipframe.previous)

BOTTOMPANEL.tipframe.previous:SetScript("OnClick", Previous_tip)

BOTTOMPANEL.tipframe.dontshow = CreateFrame("Button", G.uiname.."Dontshow tip Button", BOTTOMPANEL.tipframe, "UIPanelButtonTemplate")
BOTTOMPANEL.tipframe.dontshow:SetSize(120,15)
BOTTOMPANEL.tipframe.dontshow:SetPoint("LEFT", BOTTOMPANEL.tipframe.next, "RIGHT", 5, 0)
BOTTOMPANEL.tipframe.dontshow:SetText(L["我不想看到这些提示"])
BOTTOMPANEL.tipframe.dontshow:Hide()
_G[G.uiname.."Dontshow tip ButtonText"]:SetFont(G.norFont, 8, "OUTLINE")
F.Reskin(BOTTOMPANEL.tipframe.dontshow)

BOTTOMPANEL.tipframe.dontshow:SetScript("OnClick", DontShowTips)

T.fadeout = function()
	Minimap:Hide()
	UIParent:SetAlpha(0)
	UIFrameFadeIn(BOTTOMPANEL, 3, BOTTOMPANEL:GetAlpha(), 1)
	
	SetRandomTip()
	if aCoreCDB["OtherOptions"]["showAFKtips"] then
		BOTTOMPANEL.tipframe:Show()
	end
	BOTTOMPANEL.t = 0
	BOTTOMPANEL:EnableKeyboard(true)
end

T.fadein = function()
	Minimap:Show()
	UIFrameFadeIn(UIParent, 2, 0, 1)
	UIFrameFadeOut(BOTTOMPANEL, 2, BOTTOMPANEL:GetAlpha(), 0)
	BOTTOMPANEL:SetScript("OnUpdate",  function(self, e)
		self.t = self.t + e
		if self.t > .5 then
			self:Hide()
			self:SetScript("OnUpdate", nil)
			self.t = 0
		end
	end)
	BOTTOMPANEL:EnableKeyboard(false)
end

local function ShowTipButtons()
	BOTTOMPANEL.tipframe.next:Show()
	BOTTOMPANEL.tipframe.previous:Show()
	BOTTOMPANEL.tipframe.dontshow:Show()
	Talent:EnableMouse(false)
end

local function HideTipButtons()
	BOTTOMPANEL.tipframe.next:Hide()
	BOTTOMPANEL.tipframe.previous:Hide()
	BOTTOMPANEL.tipframe.dontshow:Hide()
	Talent:EnableMouse(true)
end

BOTTOMPANEL.tipframe:SetScript("OnEnter", ShowTipButtons)
BOTTOMPANEL.tipframe.next:SetScript("OnEnter", ShowTipButtons)
BOTTOMPANEL.tipframe.previous:SetScript("OnEnter", ShowTipButtons)
BOTTOMPANEL.tipframe.dontshow:SetScript("OnEnter", ShowTipButtons)
BOTTOMPANEL.tipframe:SetScript("OnLeave", HideTipButtons)
BOTTOMPANEL.tipframe:SetScript("OnHide", HideTipButtons)

BOTTOMPANEL:SetScript("OnKeyDown", function(self, key) 
	T.fadein()
end)

BOTTOMPANEL:SetScript("OnMouseDown", function(self) 
	T.fadein()
end)

BOTTOMPANEL:SetScript("OnEvent",function(self, event) 
	if event == "PLAYER_ENTERING_WORLD" and aCoreCDB["SkinOptions"]["afklogin"] and not InCombatLockdown() then
		if aCoreDB.meet then
			T.fadeout()
		end
		
		local PetNumber = max(C_PetJournal.GetNumPets(false), 5)
		local randomIndex = random(1 ,PetNumber)
		local randomID = select(11, C_PetJournal.GetPetInfoByIndex(randomIndex))
		if randomID then
			self.petmodelbutton:SetCreature(randomID)
		else
			self.petmodelbutton:SetCreature(53623) -- 塞纳里奥角鹰兽宝宝
		end
		
		hooksecurefunc("ToggleDropDownMenu", function(level, value, dropDownFrame, anchorName)
			if level == 2 and value == SELECT_LOOT_SPECIALIZATION then
				local listFrame = _G["DropDownList"..level]
				local point, anchor, relPoint, _, y = listFrame:GetPoint()
				listFrame:SetPoint(point, anchor, relPoint, 16, y)
			end
		end)
		
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_FLAGS_CHANGED" and aCoreCDB["SkinOptions"]["afkscreen"] then
		if UnitIsAFK("player") and not InCombatLockdown() then
			T.fadeout()
		end
	end
end)

BOTTOMPANEL:RegisterEvent("PLAYER_ENTERING_WORLD")
BOTTOMPANEL:RegisterEvent("PLAYER_FLAGS_CHANGED")

--====================================================--
--[[                -- 团队标记 --                  ]]--
--====================================================--
if aCoreCDB["UnitframeOptions"]["raidtool"] then
	
	local raidmark = CreateFrame("Frame", G.uiname.."Raid Mark Frame", UIParent)
	
	raidmark.movingname = L["团队工具"]
	raidmark.point = {
			healer = {a1 = "TOP", parent = "UIParent", a2 = "TOP", x = 0, y = -50},
			dpser = {a1 = "TOP", parent = "UIParent", a2 = "TOP", x = 0, y = -50},
		}
	T.CreateDragFrame(raidmark) --frame, dragFrameList, inset, clamp
	raidmark:SetWidth(290)
	raidmark:SetHeight(25)
	
	local rm_colors = {
		{1, 1, 0},
		{1, .5, 0},
		{1, 0, 1},
		{0, 1, 0},
		{.8, .8, .8},
		{.1, .5, 1},
		{1, 0, 0},
		{1, 1, 1},
	}
	
	for i = 1, 9 do
		local bu = CreateFrame("Button", G.uiname.."Raid Mark Button"..i, raidmark)     
		bu:SetPoint("TOPLEFT", raidmark, "TOPLEFT", (i-1)*33, 0) 	
		bu:SetSize(25, 25)
		
		bu.bg = T.CreateSD(bu, 3)
		bu.bg:SetFrameLevel(0)
		
		bu.bgtex = bu:CreateTexture(nil, "BACKGROUND")
		bu.bgtex:SetAllPoints(bu)
		bu.bgtex:SetTexture(G.media.blank)
		bu.bgtex:SetVertexColor(0, 0, 0, .3)
		
		bu.tex = bu:CreateTexture(nil, "ARTWORK")
		
		bu.tex:SetPoint("TOPLEFT", 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", -1, 1)
		
		if i == 9 then
			bu:SetNormalTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
			bu:SetHighlightTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Highlight")
			bu:SetPushedTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down")
			bu:SetPushedTextOffset(3, 3)
			bu:SetScript("OnClick", function()
				SetRaidTarget("target", 0)
			end)
		else
			bu.tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)	
			bu:SetScript("OnClick", function()
				SetRaidTarget("target", i)
			end)
			bu:SetScript("OnEnter", function()
				bu.bg:SetBackdropBorderColor(rm_colors[i][1], rm_colors[i][2], rm_colors[i][3])
			end)
			bu:SetScript("OnLeave", function()
				bu.bg:SetBackdropBorderColor(0, 0, 0)
			end)		
		end
		raidmark["mark"..i] = bu	
	end
	
	local wm_index = {5, 6, 3, 2, 7, 1, 4, 8}
	
	for i = 1, 9 do
		local bu = CreateFrame("Button", G.uiname.."Raid WorldMark Button"..i, raidmark, "SecureActionButtonTemplate")     
		bu:SetPoint("TOPLEFT", raidmark, "TOPLEFT", (i-1)*33, -33) 	
		bu:SetSize(25, 25)
		
		bu.bg = T.CreateSD(bu, 3)
		bu.bg:SetFrameLevel(0)
		
		bu.bgtex = bu:CreateTexture(nil, "BACKGROUND")
		bu.bgtex:SetAllPoints(bu)
		bu.bgtex:SetTexture(G.media.blank)
		bu.bgtex:SetVertexColor(0, 0, 0, .3)
		
		bu.tex = bu:CreateTexture(nil, "ARTWORK")
		bu.tex:SetAllPoints(bu)
		
		if i == 9 then
			bu:SetNormalTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
			bu:SetHighlightTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Highlight")
			bu:SetPushedTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Down")
			bu:SetPushedTextOffset(3, 3)
			bu:SetAttribute("type", "macro") 
			bu:SetAttribute("macrotext1", "/cwm 0")
		else
			bu.bgtex:SetVertexColor(rm_colors[i][1], rm_colors[i][2], rm_colors[i][3], .5)
			bu.tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i)	
			bu:SetAttribute("type", "macro") 
			bu:SetAttribute("macrotext", "/wm "..wm_index[i])
			bu:SetScript("OnEnter", function()
				bu.bg:SetBackdropBorderColor(rm_colors[i][1], rm_colors[i][2], rm_colors[i][3])
			end)
			bu:SetScript("OnLeave", function()
				bu.bg:SetBackdropBorderColor(0, 0, 0)
			end)
		end
		
		bu:SetScript("OnEvent", function(self, event)
			if ((UnitInParty("player") or UnitInRaid("player")) and UnitIsGroupLeader("player"))
			or (UnitInRaid("player") and UnitIsGroupAssistant("player") and not UnitIsGroupLeader("player"))
			then
				self:Show()
			else
				self:Hide()
			end
		end)
		bu:RegisterEvent("GROUP_ROSTER_UPDATE")
		bu:RegisterEvent("PLAYER_ENTERING_WORLD")
		
		raidmark["wm"..i] = bu
	end
	
	local raid_tool_buttons = {
		{"readycheck", READY_CHECK},
		{"rolecheck", ROLE_POLL},
		{"convertgroup", CONVERT_TO_RAID},
		{"pull", PLAYER_COUNTDOWN_BUTTON},
	}
	
	for i = 1, 4 do
		local tag = raid_tool_buttons[i][1]
		local bu = CreateFrame("Button", G.uiname..tag.."Button", raidmark)
		bu:SetPoint("TOPLEFT", raidmark, "TOPLEFT", math.fmod((i-1), 2)*149, -66-math.floor((i-1)/2)*30) 	
		bu:SetSize(140, 20)
		
		bu.text = T.createtext(bu, "OVERLAY", 13, "OUTLINE", "CENTER")
		bu.text:SetAllPoints(bu)
		bu.text:SetText(raid_tool_buttons[i][2])
		
		bu.bg = T.CreateSD(bu, 3)
		bu.bg:SetFrameLevel(0)
		
		bu.bgtex = bu:CreateTexture(nil, "BACKGROUND")
		bu.bgtex:SetAllPoints(bu)
		bu.bgtex:SetTexture(G.media.blank)
		bu.bgtex:SetVertexColor(0, 0, 0, .3)
		
		bu:SetScript("OnEnter", function(self)
			self.bg:SetBackdropBorderColor(1, 1, 1)
		end)
		bu:SetScript("OnLeave", function(self)
			self.bg:SetBackdropBorderColor(0, 0, 0)
		end)
			
		bu:SetScript("OnEvent", function(self, event)
			if ((UnitInParty("player") or UnitInRaid("player")) and UnitIsGroupLeader("player"))
			or (UnitInRaid("player") and UnitIsGroupAssistant("player") and not UnitIsGroupLeader("player"))
			then
				self:Show()
			else
				self:Hide()
			end
			
			if tag == "convertgroup" then
				if IsInRaid() then
					bu.text:SetText(CONVERT_TO_PARTY)
				else
					bu.text:SetText(CONVERT_TO_RAID)
				end
			end
		end)
		bu:RegisterEvent("GROUP_ROSTER_UPDATE")
		bu:RegisterEvent("PLAYER_ENTERING_WORLD")
	
		bu:SetScript("OnClick", function()
			if tag == "readycheck" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				DoReadyCheck()
			elseif tag == "rolecheck" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				InitiateRolePoll()
			elseif tag == "convertgroup" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)	
				if IsInRaid() then
					C_PartyInfo.ConvertToParty()
				else
					C_PartyInfo.ConvertToRaid()
				end				
			elseif tag == "pull" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				C_PartyInfo.DoCountdown(10)
			end
		end)
		raidmark[tag] = bu
	end
	
	local raidmark_toggle = CreateFrame("Button", G.uiname.."Raid Mark Toggle", UIParent)
	raidmark_toggle:SetPoint("TOPRIGHT", raidmark, "TOPLEFT", -7, 0)
	
	raidmark_toggle:SetSize(10, 10)
	raidmark_toggle.bg = T.CreateSD(raidmark_toggle, 3)
	raidmark_toggle.bg:SetFrameLevel(0)
		
	raidmark_toggle.bgtex = raidmark_toggle:CreateTexture(nil, "BACKGROUND")
	raidmark_toggle.bgtex:SetAllPoints(raidmark_toggle)
	raidmark_toggle.bgtex:SetTexture(G.media.blank)
	raidmark_toggle.bgtex:SetVertexColor(0, 0, 0, .3)
	
	raidmark_toggle:SetScript("OnEnter", function(self)
		self.bg:SetBackdropBorderColor(1, 1, 1)
	end)
	raidmark_toggle:SetScript("OnLeave", function(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end)
		
	raidmark_toggle.text = T.createtext(raidmark_toggle, "OVERLAY", 13, "OUTLINE", "CENTER")
	raidmark_toggle.text:SetPoint("LEFT", raidmark_toggle, "RIGHT", 5, 0)
	raidmark_toggle.text:SetText(L["团队工具"])
	
	raidmark_toggle:SetScript("OnClick", function()
		if not aCoreCDB["UnitframeOptions"]["raidtool"] then return end
		if aCoreCDB["UnitframeOptions"]["raidtool_show"] then
			aCoreCDB["UnitframeOptions"]["raidtool_show"] = false
			raidmark:Hide()
			raidmark_toggle.text:Show()
			raidmark_toggle:SetAlpha(1)
		else
			aCoreCDB["UnitframeOptions"]["raidtool_show"] = true
			raidmark:Show()
			raidmark_toggle.text:Hide()
			raidmark_toggle:SetAlpha(.3)
		end
	end)
	
	raidmark_toggle:SetScript("OnEvent", function()
		if aCoreCDB["UnitframeOptions"]["raidtool_show"] then
			raidmark:Show()
			raidmark_toggle.text:Hide()
			raidmark_toggle:SetAlpha(.3)
		else
			raidmark:Hide()
			raidmark_toggle.text:Show()
			raidmark_toggle:SetAlpha(1)
		end
	end)
	raidmark_toggle:RegisterEvent("PLAYER_LOGIN")
end