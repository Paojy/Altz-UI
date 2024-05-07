local T, C, L, G = unpack(select(2, ...))

local width, height = GetPhysicalScreenSize();
local renderScale = GetCVar("RenderScale")
local screenheight = tonumber(math.floor(height * renderScale))
local screenwidth = tonumber(math.floor(width * renderScale))

--====================================================--
--[[                 -- 边角装饰 --                 ]]--
--====================================================--
local BGFrame = CreateFrame("Frame", G.uiname.."Background", UIParent, "BackdropTemplate")
BGFrame:SetFrameStrata("BACKGROUND")
BGFrame:SetAllPoints(UIParent)
BGFrame:SetBackdrop({bgFile = "Interface\\AddOns\\AltzUI\\media\\shadow"})
BGFrame:SetBackdropColor(0, 0, 0, 0.3)
BGFrame.longpanels = {}
BGFrame.shortpanels = {}
G.BGFrame = BGFrame

local function CreateLongPanel(pos)
	local panel = CreateFrame("Frame", G.uiname..pos.."long panel", BGFrame, "BackdropTemplate")	
	panel:SetPoint(pos, BGFrame, pos, 0, 0)
	panel:SetPoint("LEFT", BGFrame, "LEFT", -8, 0)
	panel:SetPoint("RIGHT", BGFrame, "RIGHT", 8, 0)
	panel:SetHeight(12)
	
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(G.media.blank)
	panel.tex:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15),CreateColor(.25,.25,.25,.6))
	
	panel.backdrop = T.createBackdrop(panel, 1)
	
	BGFrame.longpanels[pos] = panel
end

CreateLongPanel("TOP")
CreateLongPanel("BOTTOM")

local function CreateShortPanel(pos)
	local panel = CreateFrame("Frame", G.uiname..pos.."short panel", BGFrame)
	panel:SetFrameLevel(2)
	panel:SetSize(screenwidth/6, 5)
	
	local x_offset = string.find(pos, "LEFT") and 12 or -12
	local y_offset = string.find(pos, "TOP") and -9 or 9
	panel:SetPoint(pos, BGFrame, pos, x_offset, y_offset)
	
	panel.backdrop = T.createBackdrop(panel, nil, 2)
	
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints(panel)
	panel.tex:SetTexture(G.media.ufbar)
	panel.tex:SetVertexColor(unpack(G.addon_color))
	
	BGFrame.shortpanels[pos] = panel
end

CreateShortPanel("TOPLEFT")
CreateShortPanel("TOPRIGHT")
CreateShortPanel("BOTTOMLEFT")
CreateShortPanel("BOTTOMRIGHT")

BGFrame.Apply = function()
	-- 上方材质
	if aCoreCDB["SkinOptions"]["showtopbar"] then
		BGFrame.longpanels.TOP:Show()
	else
		BGFrame.longpanels.TOP:Hide()
	end
	
	if aCoreCDB["SkinOptions"]["showtopconerbar"] then
		BGFrame.shortpanels.TOPLEFT:Show()
		BGFrame.shortpanels.TOPRIGHT:Show()
		BGFrame.longpanels.TOP.backdrop:SetBackdropBorderColor(0, 0, 0)
	else
		BGFrame.shortpanels.TOPLEFT:Hide()
		BGFrame.shortpanels.TOPRIGHT:Hide()
		BGFrame.longpanels.TOP.backdrop:SetBackdropBorderColor(unpack(G.addon_color))
	end
	
	-- 下方材质
	if aCoreCDB["SkinOptions"]["showbottombar"] then
		BGFrame.longpanels.BOTTOM:Show()
	else
		BGFrame.longpanels.BOTTOM:Hide()
	end
	
	if aCoreCDB["SkinOptions"]["showbottomconerbar"] then
		BGFrame.shortpanels.BOTTOMLEFT:Show()
		BGFrame.shortpanels.BOTTOMRIGHT:Show()
		BGFrame.longpanels.BOTTOM.backdrop:SetBackdropBorderColor(0, 0, 0)
	else
		BGFrame.shortpanels.BOTTOMLEFT:Hide()
		BGFrame.shortpanels.BOTTOMRIGHT:Hide()
		BGFrame.longpanels.BOTTOM.backdrop:SetBackdropBorderColor(unpack(G.addon_color))
	end
	
	-- 材质颜色
	for k, panel in pairs(BGFrame.longpanels) do
		if aCoreCDB["SkinOptions"]["style"] == 1 then
			panel.backdrop:SetBackdropColor(0, 0, 0, 0)
		else
			panel.backdrop:SetBackdropColor(0, 0, 0, 1)
		end
	end
end

T.RegisterInitCallback(BGFrame.Apply)
--====================================================--
--[[            -- 小地图 和 插件按钮 --            ]]--
--====================================================--
Minimap:SetMaskTexture(G.media.blank)
Minimap.bd = T.createBackdrop(Minimap)

-- 背景和材质
MinimapCompassTexture:SetAlpha(0)
local BorderTopTextures = {"Center", "TopEdge", "LeftEdge", "RightEdge", "BottomEdge", "BottomLeftCorner", "BottomRightCorner", "TopLeftCorner", "TopRightCorner"}
for i, key in pairs(BorderTopTextures) do
	MinimapCluster.BorderTop[key]:SetAlpha(0)
end

-- 巨龙群岛概要
ExpansionLandingPageMinimapButton:SetScale(.7)
ExpansionLandingPageMinimapButton:GetNormalTexture():SetTexCoord(.2, .8, .2, .8)
ExpansionLandingPageMinimapButton:GetPushedTexture():SetTexCoord(.2, .8, .2, .8)
ExpansionLandingPageMinimapButton:GetHighlightTexture():SetTexCoord(.2, .8, .2, .8)
ExpansionLandingPageMinimapButton.bd = T.createBackdrop(ExpansionLandingPageMinimapButton, nil, 2)

-- 副本难度
MinimapCluster.InstanceDifficulty:SetScale(.7)

-- 缩放
Minimap.ZoomIn:SetAlpha(0)
Minimap.ZoomOut:SetAlpha(0)
Minimap.ZoomIn:EnableMouse(false)
Minimap.ZoomOut:EnableMouse(false)

-- 追踪
MinimapCluster.TrackingFrame:Hide()
MinimapCluster.TrackingFrame.Show = T.dummy
Minimap:SetScript('OnMouseUp', function (self, button)
	if button == 'RightButton' then
		MinimapCluster.TrackingFrame.DropDown.point = "TOPRIGHT";
		MinimapCluster.TrackingFrame.DropDown.relativePoint = "BOTTOMRIGHT";		
		ToggleDropDownMenu(1, nil, MinimapCluster.TrackingFrame.DropDown, self, 0, 0)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end
end)

-- 地名
MinimapCluster.ZoneTextButton:SetFrameLevel(Minimap:GetFrameLevel()+1)
MinimapCluster.ZoneTextButton:SetWidth(80)
MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint("LEFT", MinimapCluster.ZoneTextButton, "LEFT", 0, 0)

-- 时钟
if not IsAddOnLoaded("Blizzard_TimeManager") then LoadAddOn("Blizzard_TimeManager") end
TimeManagerClockTicker:ClearAllPoints()
TimeManagerClockTicker:SetPoint("RIGHT", 0, 0)
TimeManagerClockTicker:SetFont(G.norFont, 12, "OUTLINE")
TimeManagerClockTicker:SetJustifyH("RIGHT")
TimeManagerClockTicker:SetJustifyV("CENTER")
TimeManagerClockButton:SetHeight(18)

-- 日历
GameTimeFrame:SetSize(35,18)
GameTimeFrame:GetNormalTexture():SetAlpha(0)
GameTimeFrame:GetPushedTexture():SetAlpha(0)
GameTimeFrame:GetHighlightTexture():SetAlpha(0)
GameTimeFrame.Text = T.createtext(GameTimeFrame, "OVERLAY", 12, "OUTLINE", "RIGHT")
GameTimeFrame.Text:SetPoint("RIGHT", 0, 0)
GameTimeFrame.Text:SetJustifyV("CENTER")

function GameTimeFrame_SetDate()
	local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
	local presentMonth = currentCalendarTime.month;
	local presentDay = currentCalendarTime.monthDay;
	GameTimeFrame.Text:SetText(string.format("%s/%s", presentMonth, presentDay))
end

-- 插件按钮
AddonCompartmentFrame:SetFrameLevel(Minimap:GetFrameLevel()+1)
AddonCompartmentFrame:GetNormalTexture():SetAlpha(0)
AddonCompartmentFrame:GetPushedTexture():SetAlpha(0)
AddonCompartmentFrame:GetHighlightTexture():SetAlpha(0)

-- 整合按钮
local BlackList = { 
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MinimapBackdrop"] = true,
	["MinimapButtonCollectFrame"] = true,
	["MinimapButtonCollectFrame_Toggle"] = true,
}

local MBCF_Frame = CreateFrame("Frame", "MinimapButtonCollectFrame", Minimap)
MBCF_Frame:SetHeight(20)
MBCF_Frame.buttons = {}

T.setStripBD(MBCF_Frame)

local MBCF_Button = CreateFrame("Frame", "MinimapButtonCollectFrame_Toggle", Minimap)
MBCF_Button:SetFrameStrata("MEDIUM")
MBCF_Button:SetSize(15,15)

MBCF_Button.tex = MBCF_Button:CreateTexture(nil, "ARTWORK")
MBCF_Button.tex:SetAllPoints(MBCF_Button)
MBCF_Button.tex:SetTexture(516768)
MBCF_Button.tex:SetTexCoord(.2, .8, .2, .8)

local MBCF_UpdatePoints = function()
	MBCF_Frame:ClearAllPoints()
	if aCoreCDB["SkinOptions"]["MBCFpos"] == "TOP" then
		MBCF_Frame:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
		MBCF_Frame:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 5)
	else
		local y_offset = -3
		if G.xpbar:IsShown() then
			y_offset = y_offset - 5
		end
		if G.repbar:IsShown() then
			y_offset = y_offset - 5
		end
		MBCF_Frame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, y_offset)
		MBCF_Frame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, y_offset)
	end
end

local MBCF_Toggle = function(clicked)
	if aCoreCDB["SkinOptions"]["MBCFalwaysshow"] then
		MBCF_Frame:Show()
	elseif clicked then
		if MBCF_Frame:IsShown() then
			MBCF_Frame:Hide()
		else
			MBCF_Frame:Show()
		end
	else
		MBCF_Frame:Hide()
	end
end

T.ArrangeMinimapButtons = function()
	if #MBCF_Frame.buttons == 0 then 
		MBCF_Frame:Hide()
		return
	end
	local lastbutton
	for k, button in pairs(MBCF_Frame.buttons) do
		button:ClearAllPoints()
		if button:IsShown() then
			if not lastbutton then
				button:SetPoint("LEFT", MBCF_Frame, "LEFT", 0, 0)
			else
				button:SetPoint("LEFT", lastbutton, "RIGHT", 5, 0)
			end
			lastbutton = button
		end
	end
end

T.CollectMinimapButtons = function()
	if aCoreCDB["SkinOptions"]["collectminimapbuttons"] then
		for i, child in ipairs({Minimap:GetChildren()}) do
			local child_name = child:GetName()
			if child_name and not BlackList[child_name] and (child:GetObjectType() == "Button" or strupper(child_name):match("BUTTON")) then
				child:SetParent(MBCF_Frame)
				child:SetSize(20, 20)
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
					T.ArrangeMinimapButtons()
				end)
				child:HookScript("OnHide", function() 
					T.ArrangeMinimapButtons()
				end)
				child:SetScript("OnDragStart", nil)
				child:SetScript("OnDragStop", nil)
				table.insert(MBCF_Frame.buttons, child)
			end
		end
	end
end

local MBCF_PosMenu = CreateFrame("Frame", G.uiname.."MBCF_PosMenu", UIParent, "UIDropDownMenuTemplate")
local MBCF_PosList = {
	{ text = L["上方"], func = function()
		aCoreCDB["SkinOptions"]["MBCFpos"] = "TOP"
		MBCF_UpdatePoints()
	end},
	{ text = L["下方"], func = function()
		aCoreCDB["SkinOptions"]["MBCFpos"] = "BOTTOM"
		MBCF_UpdatePoints()
	end},
	{ text = "------------------",  disabled = true},
	{ text = L["一直显示插件按钮"], func = function()
		if not aCoreCDB["SkinOptions"]["MBCFalwaysshow"] then
			aCoreCDB["SkinOptions"]["MBCFalwaysshow"] = true
		else
			aCoreCDB["SkinOptions"]["MBCFalwaysshow"] = false
		end
		MBCF_Toggle()
	end},
	{ text = L["小地图按钮"].." |T348547:12:12:0:0:64:64:4:60:4:60|t", func = function()
		if not aCoreCDB["SkinOptions"]["minimapbutton"] then
			aCoreCDB["SkinOptions"]["minimapbutton"] = true
		else
			aCoreCDB["SkinOptions"]["minimapbutton"] = false
		end
		T.ToggleMinimapButton()
	end},
}

MBCF_Button:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		MBCF_Toggle(true)
	else
		MBCF_PosList[1].checked = (aCoreCDB["SkinOptions"]["MBCFpos"] == "TOP")
		MBCF_PosList[2].checked = (aCoreCDB["SkinOptions"]["MBCFpos"] == "BOTTOM")
		MBCF_PosList[4].checked = aCoreCDB["SkinOptions"]["MBCFalwaysshow"]
		MBCF_PosList[5].checked = aCoreCDB["SkinOptions"]["minimapbutton"]
		EasyMenu(MBCF_PosList, MBCF_PosMenu, "cursor", 0, 0, "MENU")
	end
end)

T.RegisterEnteringWorldCallback(function()
	C_Timer.After(0.3, function()
		T.CollectMinimapButtons()
		T.ArrangeMinimapButtons()
	end)
	MBCF_UpdatePoints()
	MBCF_Toggle()
end)

-- 小地图元素位置
hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function(self, headerUnderneath)
	local scale = self.MinimapContainer:GetScale()
	
	self.MinimapContainer:ClearAllPoints()
	self.BorderTop:ClearAllPoints()
	GameTimeFrame:ClearAllPoints()
	ExpansionLandingPageMinimapButton:ClearAllPoints()
	self.InstanceDifficulty:ClearAllPoints()
	MBCF_Button:ClearAllPoints()
	
	if (headerUnderneath) then					
		self.MinimapContainer:SetPoint("BOTTOM", self, "BOTTOM", 10 / scale, 5 / scale)
		self.BorderTop:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 2)
		GameTimeFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 2)		
		ExpansionLandingPageMinimapButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -40, 0)
		self.InstanceDifficulty:SetPoint("TOPRIGHT", ExpansionLandingPageMinimapButton, "TOPLEFT", -5, 0)
		MBCF_Button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)	
	else				
		self.MinimapContainer:SetPoint("TOP", self, "TOP", 10 / scale, -5 / scale)	
		self.BorderTop:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, -2)
		GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, -2)
		ExpansionLandingPageMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -40, 0)
		self.InstanceDifficulty:SetPoint("BOTTOMRIGHT", ExpansionLandingPageMinimapButton, "BOTTOMLEFT", -5, 0)
		MBCF_Button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 2)
	end
	
	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint("RIGHT", GameTimeFrame, "LEFT", 0, 0)
	
	AddonCompartmentFrame:ClearAllPoints()
	AddonCompartmentFrame:SetPoint("LEFT", MBCF_Button, "RIGHT", 0, 0)
	
	self.IndicatorFrame:ClearAllPoints()
	self.IndicatorFrame:SetPoint("LEFT", AddonCompartmentFrame, "RIGHT", 3, 0)
end)

-- 小地图悬停渐隐
T.ChildrenFader(Minimap, {MinimapCluster.ZoneTextButton, TimeManagerClockButton, GameTimeFrame, AddonCompartmentFrame, MBCF_Button})

--====================================================--
--[[             -- 经验条和声望条 --               ]]--
--====================================================--
-- 经验条
local xpbar = T.createStatusbar(Minimap, 5, nil, .3, .4, 1)
xpbar:SetFrameLevel(Minimap:GetFrameLevel()+3)
xpbar.border = T.createBackdrop(xpbar, .8)
G.xpbar = xpbar

xpbar:SetScript("OnEnter", function()
	GameTooltip:SetOwner(xpbar, "ANCHOR_TOPRIGHT")
	
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()
	
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		GameTooltip:AddDoubleLine(T.color_text(L["当前经验"]), string.format("%s/%s (%d%%)", T.ShortValue(XP), T.ShortValue(maxXP), (XP/maxXP)*100))
		GameTooltip:AddDoubleLine(T.color_text(L["剩余经验"]), string.format("%s", T.ShortValue(maxXP-XP)))
		if restXP then
			GameTooltip:AddDoubleLine(T.color_text(L["双倍"]), string.format("|cffb3e1ff%s (%d%%)", T.ShortValue(restXP), restXP/maxXP*100))
		end
	end
	
	GameTooltip:Show()
end)

xpbar:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

xpbar.update = function()
	if UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled() then
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		xpbar:SetMinMaxValues(min(0, XP), maxXP)
		xpbar:SetValue(XP)
		xpbar:Show()
	else
		xpbar:Hide()
	end
end

-- 声望条
local repbar = T.createStatusbar(Minimap, 5, nil, .4, 1, .2)
repbar:SetFrameLevel(Minimap:GetFrameLevel()+3)
repbar.border = T.createBackdrop(repbar, .8)
G.repbar = repbar

repbar:SetScript("OnEnter", function()
	GameTooltip:SetOwner(repbar, "ANCHOR_TOPRIGHT")
	
	local name, rank, minRep, maxRep, value, factionID = GetWatchedFactionInfo()
	local ranktext = _G["FACTION_STANDING_LABEL"..rank]
	
	if name then
		local minrep, maxrep, valuerep
		local reputationInfo = C_GossipInfo.GetFriendshipReputation(factionID)
		if reputationInfo and reputationInfo.friendshipFactionID ~= 0 then
			minrep, maxrep, valuerep = 0, reputationInfo.nextThreshold, reputationInfo.standing
			ranktext = string.format(" (%s)", reputationInfo.reaction)
		elseif C_Reputation.IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
			minrep, maxrep, valuerep = 0, threshold, mod(currentValue, threshold)
		elseif C_Reputation.IsMajorFaction(factionID) then
			local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
			minrep, maxrep, valuerep = 0, majorFactionData.renownLevelThreshold, value
			ranktext = majorFactionData.renownLevel
		else
			minrep, maxrep, valuerep = minRep, maxRep, value
		end
		
		GameTooltip:AddLine(name..ranktext)
		
		if maxrep and maxrep > valuerep then
			GameTooltip:AddDoubleLine(T.color_text(L["声望"]), string.format("%s/%s (%d%%)", T.ShortValue(valuerep-minrep), T.ShortValue(maxrep-minrep), (valuerep-minrep)/(maxrep-minrep)*100))
			GameTooltip:AddDoubleLine(T.color_text(L["剩余声望"]), string.format("%s", T.ShortValue(maxrep-valuerep)))
		end
	end	
	
	GameTooltip:Show()
end)
repbar:SetScript("OnLeave", function() GameTooltip:Hide() end)
repbar:SetScript("OnMouseDown", function() ToggleCharacter("ReputationFrame") end)

repbar.update = function()
	if GetWatchedFactionInfo() then
		local name, rank, minRep, maxRep, value, factionID = GetWatchedFactionInfo()	
		local reputationInfo = C_GossipInfo.GetFriendshipReputation(factionID)
		if reputationInfo and reputationInfo.friendshipFactionID ~= 0 then
			if reputationInfo.nextThreshold then
				repbar:SetMinMaxValues(0, reputationInfo.nextThreshold)
				repbar:SetValue(reputationInfo.standing)
			else
				repbar:SetMinMaxValues(0, 1)
				repbar:SetValue(1)
			end
		elseif C_Reputation.IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
			repbar:SetMinMaxValues(0, threshold)
			repbar:SetValue(mod(currentValue, threshold))
		elseif C_Reputation.IsMajorFaction(factionID) then
			local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
			repbar:SetMinMaxValues(0, majorFactionData.renownLevelThreshold)
			repbar:SetValue(value)
		else
			if rank == MAX_REPUTATION_REACTION then
				repbar:SetMinMaxValues(0, 1)
				repbar:SetValue(1)
			else
				repbar:SetMinMaxValues(minRep, maxRep)
				repbar:SetValue(value)
			end
		end
		repbar:Show()
	else
		repbar:Hide()
	end
end

local update_bar_positions = function()
	local showXP = UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled()
	local showRep = GetWatchedFactionInfo()
	
	xpbar.shown = showXP
	repbar.shown = showRep
	
	if (xpbar.shown or repbar.shown) and (xpbar.shown ~= xpbar.shown_old or repbar.shown ~= repbar.shown_old) then
		if showXP then
			xpbar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
			xpbar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
			if showRep then
				repbar:SetPoint("TOPLEFT", xpbar, "BOTTOMLEFT", 0, -1)
				repbar:SetPoint("TOPRIGHT", xpbar, "BOTTOMRIGHT", 0, -1)
			end
		elseif showRep then
			repbar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
			repbar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
		end
		xpbar.shown_old = xpbar.shown
		repbar.shown_old = repbar.shown
		
		MBCF_UpdatePoints()
	end
end

xpbar:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_XP_UPDATE" then
		xpbar.update()
	end
	if event == "PLAYER_LOGIN" or event == "UPDATE_FACTION" then
		repbar.update()
	end
	update_bar_positions()
end)

xpbar:RegisterEvent("PLAYER_LEVEL_UP")
xpbar:RegisterEvent("PLAYER_XP_UPDATE")
xpbar:RegisterEvent("UPDATE_FACTION")
xpbar:RegisterEvent("PLAYER_LOGIN")

--====================================================--
--[[                  -- 游戏菜单 --                ]]--
--====================================================--
local microbuttons = {}
for i, name in pairs(MICRO_BUTTONS) do
	local bu = _G[name]	
	local normal_tex = bu:GetNormalTexture()
	
	if normal_tex then
		normal_tex:SetDesaturated(true)
		normal_tex:SetVertexColor(unpack(G.addon_color))
	end
	
	bu.Background:SetTexture(nil)
	bu.backdrop = T.createBackdrop(bu, .6)
	bu.backdrop:ClearAllPoints()
	bu.backdrop:SetPoint("TOPLEFT", bu, "TOPLEFT", 3, -3)
	bu.backdrop:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -3, 3)
	
	table.insert(microbuttons, bu)
end

T.ParentFader(MicroMenu, microbuttons)

--====================================================--
--[[                  -- 背包按钮 --                ]]--
--====================================================--

local textures = {
	normal= "Interface\\AddOns\\AltzUI\\media\\gloss",
	hover = "Interface\\AddOns\\AltzUI\\media\\hover",
	pushed= "Interface\\AddOns\\AltzUI\\media\\pushed",
	checked = "Interface\\AddOns\\AltzUI\\media\\checked",
}

MainMenuBarBackpackButton:SetSize(30, 30)
MainMenuBarBackpackButton:SetNormalTexture(textures.normal)
MainMenuBarBackpackButton:SetPushedTexture(textures.pushed)
MainMenuBarBackpackButton:SetHighlightTexture(textures.hover)
MainMenuBarBackpackButton.SlotHighlightTexture:SetTexture(textures.checked)

T.createBackdrop(MainMenuBarBackpackButton)

MainMenuBarBackpackButton.Icon = MainMenuBarBackpackButton:CreateTexture(nil, "ARTWORK")
MainMenuBarBackpackButton.Icon:SetAllPoints(MainMenuBarBackpackButton)
MainMenuBarBackpackButton.Icon:SetTexture(133633)
MainMenuBarBackpackButton.Icon:SetTexCoord(.2, .8, .2, .8)

hooksecurefunc(MainMenuBarBackpackButton, "UpdateFreeSlots", function(self)
	self.Count:SetText(self.freeSlots)
end)

local bagbuttons = {
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, CharacterReagentBag0Slot
}

local fadebagbuttons = {BagsBar, MainMenuBarBackpackButton}

for i, bu in pairs(bagbuttons) do
	hooksecurefunc(bu, "UpdateTextures", function(self)
		bu.CircleMask:Hide()
		bu:SetNormalTexture(textures.normal)
		bu:SetPushedTexture(textures.pushed)
		bu:SetHighlightTexture(textures.hover)
		bu.SlotHighlightTexture:SetTexture(textures.checked)
		local icon = _G[bu:GetName().."IconTexture"]
		if icon then
			icon:SetTexCoord(.2, .8, .2, .8)
		end
		if not bu.bg then
			bu.bg = T.createBackdrop(bu, nil, 2)
		end
	end)
	table.insert(fadebagbuttons, bu)
end

T.GroupFader(fadebagbuttons)
--====================================================--
--[[                  --  信息条 --                 ]]--
--====================================================--
local InfoFrame = CreateFrame("Frame", G.uiname.."InfoFrame", UIParent)
InfoFrame:SetFrameLevel(4)
InfoFrame:SetSize(270, 25)
G.InfoFrame = InfoFrame

InfoFrame.movingname = L["信息条"]
InfoFrame.point = {
	healer = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 3},
	dpser = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 3},
}
T.CreateDragFrame(InfoFrame)

InfoFrame.Apply = function()
	if not aCoreCDB["SkinOptions"]["infobar"] then
		InfoFrame:Hide()
		T.ReleaseDragFrame(InfoFrame)
	else
		InfoFrame:Show()
		T.RestoreDragFrame(InfoFrame)
	end
	InfoFrame:SetScale(aCoreCDB["SkinOptions"]["infobarscale"])
end
T.RegisterInitCallback(InfoFrame.Apply)

local function CreateInfoButton(width, points, dropdown)
	local Frame = CreateFrame("Frame", nil, InfoFrame)
	Frame:SetPoint(unpack(points))
	Frame:SetSize(width, 25)
	
	Frame.text = T.createtext(Frame, "OVERLAY", 12, "OUTLINE", "LEFT")
	Frame.text:SetPoint("LEFT")

	if dropdown then	
		Frame.Button = CreateFrame("DropDownToggleButton", nil, Frame)
		Frame.Button:SetSize(width, 25)
		Frame.Button:SetPoint("CENTER", 0, 0)
		
		Frame.DropDown = CreateFrame("Frame", nil, Frame, "UIDropDownMenuTemplate")
	end
	
	return Frame
end

local function PointMenuFrame(frame, anchor)
	frame:ClearAllPoints()
	if select(2, InfoFrame:GetCenter())/screenheight > .5 then -- In the upper part of the screen
		frame:SetPoint("TOP", anchor, "BOTTOM", 0, -5)
	else
		frame:SetPoint("BOTTOM", anchor, "TOP", 0, 5)
	end
end

-- 延迟和帧数
local Net_Stats = CreateInfoButton(95, {"LEFT", InfoFrame, "LEFT", 0, 0})

Net_Stats.t = 0
Net_Stats:SetScript("OnUpdate", function(self, elapsed)
	self.t = self.t + elapsed
	if self.t > 3 then -- 每秒刷新一次
		fps = format("%d"..T.color_text("fps"), GetFramerate())
		lag = format("%d"..T.color_text("ms"), select(4, GetNetStats()))	
		self.text:SetText(fps.."  "..lag)
		self.t = 0
	end
end)

Net_Stats:SetScript("OnEnter", function(self)
	local numAddons = GetNumAddOns()
	local customMem = 0	
	local topAddOns = {}	

	UpdateAddOnMemoryUsage()
	
	for i=1, numAddons do
		local mem = GetAddOnMemoryUsage(i)
		local addon_name = GetAddOnInfo(i)
		customMem = customMem + mem
		table.insert(topAddOns, {name = addon_name, value = mem})
	end

	local _, _, latencyHome, latencyWorld = GetNetStats()
	
	if ( customMem > 0 ) then
		local totalMem = collectgarbage("count")
		local numDisplay = min(20, numAddons)
		table.sort(topAddOns, function(a, b) return a.value > b.value end)
		
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:AddLine(T.color_text(string.format(L["占用前 %d 的插件"], numDisplay)))
		GameTooltip:AddLine(" ")
		
		for i=1, numDisplay do
			GameTooltip:AddDoubleLine(topAddOns[i].name, T.memFormat(topAddOns[i].value), 1, 1, 1, T.ColorGradient(topAddOns[i].value / 1024, "red"))
		end
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["自定义插件占用"], T.memFormat(customMem), 1, 1, 1, T.ColorGradient(customMem / (1024*numDisplay), "red"))
		GameTooltip:AddDoubleLine(L["所有插件占用"], T.memFormat(totalMem), 1, 1, 1, T.ColorGradient(totalMem / (1024*50) , "red"))
		
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld), 1, 1, 1)
		
		PointMenuFrame(GameTooltip, InfoFrame)
		GameTooltip:Show()		
	end
end)
 
Net_Stats:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

-- 耐久
local Durability = CreateInfoButton(55, {"LEFT", Net_Stats, "RIGHT", 0, 0}, true)

local function Durability_Initialize(self, level)
	local count = C_EquipmentSet.GetNumEquipmentSets()	
	if count > 0 then
		local sets = C_EquipmentSet.GetEquipmentSetIDs()
		for i, setID in pairs(sets) do
			local name, icon, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(setID)
			info = UIDropDownMenu_CreateInfo()
			info.text = string.format(EQUIPMENT_SETS, T.GetTexStr(icon).." "..name)
			info.checked = isEquipped
			info.func = function() C_EquipmentSet.UseEquipmentSet(index) end
			UIDropDownMenu_AddButton(info)
		end
	end
end

Durability.Button:SetScript("OnMouseDown", function(self)
	local count = C_EquipmentSet.GetNumEquipmentSets()
	if count > 0 then
		
		Durability.DropDown.point = "BOTTOMLEFT";
		Durability.DropDown.relativePoint = "TOPLEFT"
		ToggleDropDownMenu(1, nil, Durability.DropDown, Durability, 0, 5)	
	end
end)

Durability:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_EQUIPMENT_CHANGED" or event == "EQUIPMENT_SETS_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		UIDropDownMenu_Initialize(Durability.DropDown, Durability_Initialize, "MENU")
	end
	
	if event == "UPDATE_INVENTORY_DURABILITY" or event == "PLAYER_ENTERING_WORLD" then
		local lowest = 1
		for slot,id in pairs(G.SLOTS) do
			local current, maximum = GetInventoryItemDurability(id)
			if current and maximum and maximum ~= 0 then
				lowest = math.min(current/maximum, lowest)
			end
		end
		Durability.text:SetText(format("%d"..T.color_text("dur"), lowest*100))
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

Durability:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
Durability:RegisterEvent("EQUIPMENT_SETS_CHANGED")
Durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Durability:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 天赋
local Talent = CreateInfoButton(120, {"LEFT", Durability, "RIGHT", 0, 0}, true)

local function TalentDropDown_Initialize(self, level, menuList)
	local current_spec_index = GetSpecialization()
	local current_lootspec_index = GetLootSpecialization()
	local cur_specID, cur_specName, _, cur_Icon = GetSpecializationInfo(current_spec_index)
	local cur_LootspecID, cur_LootspecName = GetSpecializationInfoByID(current_lootspec_index)
	local numspec = GetNumSpecializations()

	if level == 1 then
		local info = UIDropDownMenu_CreateInfo()
		-- 启用专精
		info.text = ACTIVATE..SPECIALIZATION
		info.notCheckable = true
		info.keepShownOnClick = true
		info.hasArrow = true
		info.menuList = "Spec"
		UIDropDownMenu_AddButton(info)
		-- 专精拾取
		info.text = SELECT_LOOT_SPECIALIZATION
		info.notCheckable = true
		info.keepShownOnClick = true
		info.hasArrow = true
		info.menuList = "LootSpec"
		UIDropDownMenu_AddButton(info)
		-- 天赋和专精
		info.text = TALENTS_BUTTON
		info.notCheckable = true
		info.keepShownOnClick = true
		info.hasArrow = false
		info.menuList = nil
		info.func = ToggleTalentFrame
		UIDropDownMenu_AddButton(info)
	
	elseif menuList == "Spec" then
		info = UIDropDownMenu_CreateInfo()
		for i = 1, numspec do
			local id, name, _, icon = GetSpecializationInfo(i)
			info.text = T.GetTexStr(icon).." "..name
			info.checked = (cur_specID == id)
			info.func = function()
				SetSpecialization(i)
				HideDropDownMenu(1)
			end
			UIDropDownMenu_AddButton(info, level)
		end
	elseif menuList == "LootSpec" then
		info = UIDropDownMenu_CreateInfo()
		for i = 0, numspec do		
			if i == 0 then
				info.text = string.format(LOOT_SPECIALIZATION_DEFAULT, T.GetTexStr(cur_Icon).." "..cur_specName)
				info.checked = (current_lootspec_index == 0)
				info.func = function() 
					SetLootSpecialization(0)
					HideDropDownMenu(1)
				end
			else
				local id, name, _, icon = GetSpecializationInfo(i)
				info.text = T.GetTexStr(icon).." "..name
				info.checked = (current_lootspec_index == id)
				info.func = function()
					SetLootSpecialization(id)
					HideDropDownMenu(1)
				end
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end
end

Talent.Button:SetScript("OnMouseDown", function(self)
	if UnitLevel("player") >= 10 then -- 10 级别后有天赋
		Talent.DropDown.point = "BOTTOMLEFT";
		Talent.DropDown.relativePoint = "TOPLEFT"
		ToggleDropDownMenu(1, nil, Talent.DropDown, Talent, 0, 5)
	end
end)

Talent:SetScript("OnEvent", function(self, event)
	local current_spec_index = GetSpecialization()
	local current_lootspec_index = GetLootSpecialization()
 
	if current_spec_index then
		local _, cur_specName = GetSpecializationInfo(current_spec_index)
		local _, cur_LootspecName = GetSpecializationInfoByID(current_lootspec_index)
		
		if cur_LootspecName then
			self.text:SetText(string.format(T.color_text("%s (%s %s)"), cur_specName, SELECT_LOOT_SPECIALIZATION, cur_LootspecName))
		else
			self.text:SetText(T.color_text(cur_specName))
		end
		
		UIDropDownMenu_Initialize(self.DropDown, TalentDropDown_Initialize, "MENU")
	else
		self.text:SetText(T.color_text(T.split_words(NONE,SPECIALIZATION)))
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

Talent:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
Talent:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
Talent:RegisterEvent("PLAYER_ENTERING_WORLD")
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
				OrderHallCommandBar.ClassIconBD = T.createBackdrop(OrderHallCommandBar.ClassIcon, nil, nil, OrderHallCommandBar)
	
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
					
					local bg = T.createBackdrop(child.Icon, 1, nil, child)
					
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
--[[              -- AFK Screen --                  ]]--
--====================================================--
local AFK_Frame = CreateFrame("Frame", nil, WorldFrame)
AFK_Frame:SetFrameStrata("HIGH")
AFK_Frame:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOMLEFT", -5, -5)
AFK_Frame:SetPoint("TOPRIGHT", WorldFrame, "BOTTOMRIGHT", 5, 60)
AFK_Frame:Hide()

T.setStripBD(AFK_Frame)

AFK_Frame.petmodel = T.CreateCreatureModel(AFK_Frame, 120, 120, {"CENTER", AFK_Frame, "TOPRIGHT", -190, 0}, 42522, {-0.5, 0, 0})

AFK_Frame.petmodel.text = T.createtext(AFK_Frame.petmodel, "OVERLAY", 13, "OUTLINE", "RIGHT")
AFK_Frame.petmodel.text:SetPoint("CENTER")
AFK_Frame.petmodel.text:SetText("AltzUI")

AFK_Frame.tipframe = CreateFrame("Frame", nil, AFK_Frame)
AFK_Frame.tipframe:SetSize(400, 20)
AFK_Frame.tipframe:SetPoint("TOP", 0, -5)

AFK_Frame.tipframe.text = T.createtext(AFK_Frame.tipframe, "OVERLAY", 8, "OUTLINE", "CENTER")
AFK_Frame.tipframe.text:SetPoint("TOP", 0, 0)
AFK_Frame.tipframe:SetFrameLevel(AFK_Frame:GetFrameLevel()+5)

local current_tip = 1

local function SetTip(index)
	AFK_Frame.tipframe.text:SetText(L["TIPS"][index])
	current_tip = index
end

local fadeout = function()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.Portrait and obj:IsElementEnabled("Portrait") then
			obj.Portrait:Hide()
		end
	end
	
	Minimap:Hide()
	UIParent:Hide()
	AFK_Frame:Show()
	UIFrameFadeIn(AFK_Frame, 2, 0, 1)
	
	SetTip(random(1 , #L["TIPS"]))
	AFK_Frame.tipframe:SetShown(aCoreCDB["SkinOptions"]["showAFKtips"])
	
	AFK_Frame:EnableKeyboard(true)
	AFK_Frame:EnableMouse(true)
end

local fadein = function()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do
		if obj.Portrait and obj:IsElementEnabled("Portrait") then
			obj.Portrait:Show()
		end
	end
	
	Minimap:Show()
	UIParent:Show()
	AFK_Frame:Hide()
	
	AFK_Frame:EnableKeyboard(false)
	AFK_Frame:EnableMouse(true)
end

AFK_Frame.tipframe.next = T.ClickTexButton(AFK_Frame.tipframe, {"LEFT", AFK_Frame.tipframe.text, "RIGHT", 0, 0}, [[Interface\AddOns\AltzUI\media\arrow.tga]], nil, 14)
T.SetupArrow(AFK_Frame.tipframe.next.tex, "right")
T.SetupArrow(AFK_Frame.tipframe.next.hl_tex, "right")

AFK_Frame.tipframe.next:SetScript("OnClick", function()
	SetTip(current_tip == #L["TIPS"] and 1 or(current_tip + 1))
end)

AFK_Frame.tipframe.previous = T.ClickTexButton(AFK_Frame.tipframe, {"RIGHT", AFK_Frame.tipframe.text, "LEFT", 0, 0}, [[Interface\AddOns\AltzUI\media\arrow.tga]], nil, 14)
T.SetupArrow(AFK_Frame.tipframe.previous.tex, "left")
T.SetupArrow(AFK_Frame.tipframe.previous.hl_tex, "left")
AFK_Frame.tipframe.previous:SetScript("OnClick", function()
	SetTip(current_tip == 1 and #L["TIPS"] or (current_tip - 1))
end)

AFK_Frame.tipframe.dontshow = T.ClickTexButton(AFK_Frame.tipframe, {"LEFT", AFK_Frame.tipframe.next, "RIGHT", 5, 0}, [[Interface\BUTTONS\UI-GroupLoot-Pass-Up.tga]], nil, 14)
AFK_Frame.tipframe.dontshow:SetScript("OnClick", function()
	aCoreCDB["SkinOptions"]["showAFKtips"] = false
	AFK_Frame.tipframe:Hide()
	StaticPopup_Show(G.uiname.."hideAFKtips")
	fadein()
end)

AFK_Frame:SetScript("OnMouseDown", fadein)
AFK_Frame:SetScript("OnKeyDown", fadein)

AFK_Frame:RegisterEvent("PLAYER_FLAGS_CHANGED")
AFK_Frame:SetScript("OnEvent",function(self, event) 
	if aCoreCDB["SkinOptions"]["afkscreen"] then
		if UnitIsAFK("player") and not InCombatLockdown() then
			fadeout()
		end
	end
end)

--====================================================--
--[[                -- 团队标记 --                  ]]--
--====================================================--

local raidmark = CreateFrame("Frame", G.uiname.."RaidMarkFrame", UIParent)
raidmark:SetSize(290, 25)

raidmark.movingname = L["团队工具"]
raidmark.point = {
	healer = {a1 = "TOP", parent = "UIParent", a2 = "TOP", x = 0, y = -50},
	dpser = {a1 = "TOP", parent = "UIParent", a2 = "TOP", x = 0, y = -50},
}
T.CreateDragFrame(raidmark)
	
local rm_colors = {
	{1, 1, 0},
	{1, .5, 0},
	{1, 0, 1},
	{0, 1, 0},
	{.8, .8, .8},
	{.1, .5, 1},
	{1, 0, 0},
	{1, 1, 1},
	{1, 0, 0},
}
	
local skin_rm = function(bu, index, bg_color)
	bu:SetSize(25, 25)
	bu.bg = T.createBackdrop(bu, .5)
	
	if index == 9 then
		bu:SetNormalTexture([[Interface\BUTTONS\UI-GroupLoot-Pass-Up]])
		bu:SetHighlightTexture([[Interface\BUTTONS\UI-GroupLoot-Pass-Highlight]])
		bu:SetPushedTexture([[Interface\BUTTONS\UI-GroupLoot-Pass-Down]])
		
		bu:SetPushedTextOffset(3, 3)
	else
		bu.tex = bu:CreateTexture(nil, "ARTWORK")
		bu.tex:SetPoint("TOPLEFT", 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", -1, 1)
		
		bu.tex:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcon_]]..index)
		if bg_color then
			bu.bg:SetBackdropColor(rm_colors[i][1], rm_colors[i][2], rm_colors[i][3], .5)
		end
	end
	
	bu:SetScript("OnEnter", function(self)
		self.bg:SetBackdropBorderColor(rm_colors[index][1], rm_colors[index][2], rm_colors[index][3])
	end)
	
	bu:SetScript("OnLeave", function(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end)
end

for i = 1, 9 do
	local bu = CreateFrame("Button", nil, raidmark)
	bu:SetPoint("TOPLEFT", raidmark, "TOPLEFT", (i-1)*33, 0) 	
	skin_rm(bu, i)
	
	bu:SetScript("OnClick", function()
		SetRaidTarget("target", (i == 9 and 0) or i)
	end)
	
	raidmark["mark"..i] = bu	
end

local wm_index = {5, 6, 3, 2, 7, 1, 4, 8}

for i = 1, 9 do
	local bu = CreateFrame("Button", nil, raidmark, "SecureActionButtonTemplate")     
	bu:SetPoint("TOPLEFT", raidmark, "TOPLEFT", (i-1)*33, -33) 	
	skin_rm(bu, i)
	

	bu:SetAttribute("type", "macro") 
	bu:SetAttribute("macrotext1", (i == 9 and "/cwm 0") or "/wm "..wm_index[i])	

	bu:SetScript("OnEvent", function(self, event)
		if (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
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
	local bu = CreateFrame("Button", nil, raidmark)
	bu:SetPoint("TOPLEFT", raidmark, "TOPLEFT", math.fmod((i-1), 2)*149, -66-math.floor((i-1)/2)*30) 	
	bu:SetSize(140, 20)
	
	bu.text = T.createtext(bu, "OVERLAY", 13, "OUTLINE", "CENTER")
	bu.text:SetAllPoints(bu)
	bu.text:SetText(raid_tool_buttons[i][2])
	
	bu.bg = T.createBackdrop(bu, .5)

	bu:SetScript("OnEnter", function(self)
		self.bg:SetBackdropBorderColor(1, 1, 1)
	end)
	bu:SetScript("OnLeave", function(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end)
		
	bu:SetScript("OnEvent", function(self, event)
		if (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
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
	
local raidmark_toggle = T.ClickTexButton(UIParent, {"TOPRIGHT", raidmark, "TOPLEFT", -7, 0}, [[Interface\AddOns\AltzUI\media\icons\star.tga]], L["团队工具"], 18)
raidmark_toggle:SetSize(18, 18)

T.UpdateRaidTools = function()
	if aCoreCDB["UnitframeOptions"]["raidtool"] then	
		T.RestoreDragFrame(raidmark)
		if aCoreCDB["UnitframeOptions"]["raidtool_show"] then
			raidmark:Show()
			raidmark_toggle.text:Hide()
			raidmark_toggle:SetAlpha(.3)
		else
			raidmark:Hide()
			raidmark_toggle.text:Show()
			raidmark_toggle:SetAlpha(1)
		end
		raidmark_toggle:Show()
	else
		T.ReleaseDragFrame(raidmark)
		raidmark:Hide()
		raidmark_toggle:Hide()
	end
end

T.RegisterInitCallback(T.UpdateRaidTools)

raidmark_toggle:SetScript("OnClick", function()
	aCoreCDB["UnitframeOptions"]["raidtool_show"] = not aCoreCDB["UnitframeOptions"]["raidtool_show"]
	T.UpdateRaidTools()
end)