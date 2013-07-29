local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

--====================================================--
--[[                -- Functions --                    ]]--
--====================================================--

local function ColorGradient(perc, ...)-- http://www.wowwiki.com/ColorGradient
    if (perc > 1) then
        local r, g, b = select(select('#', ...) - 2, ...) return r, g, b
    elseif (perc < 0) then
        local r, g, b = ... return r, g, b
    end

    local num = select('#', ...) / 3

    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end
--====================================================--
--[[                -- Shadow --                    ]]--
--====================================================--	
local PShadow = CreateFrame("Frame", nil, UIParent)
PShadow:SetFrameStrata("BACKGROUND")
PShadow:SetAllPoints()
PShadow:SetBackdrop({bgFile = "Interface\\AddOns\\AltzUI\\media\\shadow"})
PShadow:SetBackdropColor(0, 0, 0, 0.3)

--====================================================--
--[[              -- Bottom Panel --                ]]--
--====================================================--	
bottompanel = CreateFrame("Frame", nil, UIParent)
bottompanel:SetFrameStrata("BACKGROUND")
bottompanel:SetPoint("BOTTOM", 0, -3)
bottompanel:SetPoint("LEFT", UIParent, "LEFT", -8, 0)
bottompanel:SetPoint("RIGHT", UIParent, "RIGHT", 8, 0)
bottompanel:SetHeight(15)
bottompanel.border = F.CreateBDFrame(bottompanel, 0.6)
F.CreateSD(bottompanel.border, 2, 0, 0, 0, 1, -1)

--====================================================--
--[[                   -- Minimap --                ]]--
--====================================================--
local minimap_height = aCoreCDB["OtherOptions"]["minimapheight"]

-- 收缩和伸展的按钮
local minimap_pullback = CreateFrame("Frame", G.uiname.."minimap_pullback", UIParent) 
minimap_pullback:SetWidth(8)
minimap_pullback:SetHeight(minimap_height)
minimap_pullback:SetFrameStrata("BACKGROUND")
minimap_pullback:SetFrameLevel(5)
minimap_pullback.movingname = L["小地图缩放按钮"]
minimap_pullback.point = {
	healer = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -10, y = 40},
	dpser = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -10, y = 40},
}
minimap_pullback:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 40)
T.CreateDragFrame(minimap_pullback)
minimap_pullback.border = F.CreateBDFrame(minimap_pullback, 0.6)
F.CreateSD(minimap_pullback.border, 2, 0, 0, 0, 1, -1)

minimap_pullback:SetAlpha(.2)
minimap_pullback:HookScript("OnEnter", function(self) T.UIFrameFadeIn(self, .5, self:GetAlpha(), 1) end)
minimap_pullback:SetScript("OnLeave", function(self) T.UIFrameFadeOut(self, .5, self:GetAlpha(), 0.2) end)

local minimap_anchor = CreateFrame("Frame", nil, UIParent)
minimap_anchor:SetPoint("BOTTOMRIGHT", minimap_pullback, "BOTTOMLEFT", -5, 0)
minimap_anchor:SetWidth(minimap_height)
minimap_anchor:SetHeight(minimap_height)
minimap_anchor:SetFrameStrata("BACKGROUND")
minimap_anchor.border = F.CreateBDFrame(minimap_anchor, 0.6)
F.CreateSD(minimap_anchor.border, 2, 0, 0, 0, 1, -1)

Minimap:SetParent(minimap_anchor)
Minimap:SetPoint("CENTER")
Minimap:SetSize(minimap_height, minimap_height)
Minimap:SetFrameLevel(1)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")

local nowwidth, allwidth, all
local Updater = CreateFrame("Frame")
Updater.mode = "OUT"
Updater:Hide()

Updater:SetScript("OnUpdate",function(self,elapsed)
	if self.mode == "OUT" then
		if nowwidth < allwidth then
			nowwidth = nowwidth+allwidth/(all/0.2)/3
			minimap_anchor:SetPoint("BOTTOMRIGHT", minimap_pullback, "BOTTOMLEFT", nowwidth, 0)
		else
			minimap_anchor:SetPoint("BOTTOMRIGHT", minimap_pullback, "BOTTOMLEFT", allwidth, 0)
			minimap_pullback.border:SetBackdropColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			Updater:Hide()
			Updater.mode = "IN"
			Minimap:Hide()
		end
	elseif self.mode == "IN" then
		if nowwidth >0 then
			nowwidth = nowwidth-allwidth/(all/0.2)/3
			minimap_anchor:SetPoint("BOTTOMRIGHT", minimap_pullback, "BOTTOMLEFT", nowwidth, 0);	
		else
			minimap_anchor:SetPoint("BOTTOMRIGHT", minimap_pullback, "BOTTOMLEFT", -5, 0)
			minimap_pullback.border:SetBackdropColor(0, 0, 0, .6)
			Updater:Hide()
			Updater.mode = "OUT"
		end		
	end
end)

minimap_pullback:SetScript("OnMouseDown",function(self)
	if Updater.mode == "OUT" then
		nowwidth, allwidth, all = 0, minimap_height, 1
		T.UIFrameFadeOut(minimap_anchor, 1, minimap_anchor:GetAlpha(), 0)
		T.UIFrameFadeOut(Minimap, 1, Minimap:GetAlpha(), 0)
	elseif Updater.mode == "IN" then
		Minimap:Show()
		nowwidth, allwidth, all = minimap_height, minimap_height, 1
		T.UIFrameFadeIn(minimap_anchor, 1, minimap_anchor:GetAlpha(), 1)
		T.UIFrameFadeIn(Minimap, 1, Minimap:GetAlpha(), 1)
	end
	Updater:Show()
end)

local chatframe_pullback = CreateFrame("Frame", G.uiname.."chatframe_pullback", UIParent) 
chatframe_pullback:SetWidth(8)
chatframe_pullback:SetHeight(minimap_height)
chatframe_pullback:SetFrameStrata("BACKGROUND")
chatframe_pullback:SetFrameLevel(3)
chatframe_pullback.movingname = L["聊天框缩放按钮"]
chatframe_pullback.point = {
	healer = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 40},
	dpser = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 40},
}
chatframe_pullback:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 40)
T.CreateDragFrame(chatframe_pullback)
chatframe_pullback.border = F.CreateBDFrame(chatframe_pullback, 0.6)
F.CreateSD(chatframe_pullback.border, 2, 0, 0, 0, 1, -1)

chatframe_pullback:SetAlpha(.2)
chatframe_pullback:HookScript("OnEnter", function(self) T.UIFrameFadeIn(self, .5, self:GetAlpha(), 1) end)
chatframe_pullback:SetScript("OnLeave", function(self) T.UIFrameFadeOut(self, .5, self:GetAlpha(), 0.2) end)

local chatframe_anchor = CreateFrame("frame",nil,UIParent)
chatframe_anchor:SetPoint("BOTTOMLEFT", chatframe_pullback, "BOTTOMRIGHT", 5, 0)
chatframe_anchor:SetWidth(300)
chatframe_anchor:SetHeight(minimap_height)
chatframe_anchor:SetFrameStrata("BACKGROUND")

local cf = _G['ChatFrame1']
local dm = _G['GeneralDockManager']

--move chat
local MoveChat = function()
    FCF_SetLocked(cf, nil) 
    cf:ClearAllPoints()
    cf:SetPoint("BOTTOMLEFT", chatframe_anchor ,"BOTTOMLEFT", 3, 5)
    FCF_SavePositionAndDimensions(cf)
	FCF_SetLocked(cf, 1)
end

local nowwidth, allwidth, all
local Updater2 = CreateFrame("Frame")
Updater2.mode = "OUT"
Updater2:Hide()

Updater2:SetScript("OnUpdate",function(self,elapsed)
	if self.mode == "OUT" then
		if nowwidth > -375 then
			nowwidth = nowwidth-allwidth/(all/0.2)/4
			chatframe_anchor:SetPoint("BOTTOMLEFT", chatframe_pullback, "BOTTOMRIGHT", nowwidth, 0)
			MoveChat()
		else
			chatframe_anchor:SetPoint("BOTTOMLEFT", chatframe_pullback, "BOTTOMRIGHT", -375, 0)
			chatframe_pullback.border:SetBackdropColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			self:Hide()
			self.mode = "IN"
		end
	elseif self.mode == "IN" then
		if nowwidth <0 then
			nowwidth = nowwidth+allwidth/(all/0.2)/4
			chatframe_anchor:SetPoint("BOTTOMLEFT", chatframe_pullback, "BOTTOMRIGHT", nowwidth, 0)
			MoveChat()			
		else
			chatframe_anchor:SetPoint("BOTTOMLEFT", chatframe_pullback, "BOTTOMRIGHT", 5, 0)
			chatframe_pullback.border:SetBackdropColor(0, 0, 0, .6)			
			self:Hide()
			self.mode = "OUT"
		end		
	end
end)

chatframe_pullback:SetScript("OnMouseDown",function(self)
	if Updater2.mode == "OUT" then
		nowwidth, allwidth, all = 0, 375, 1
		T.UIFrameFadeOut(cf, 1, cf:GetAlpha(), 0)
		T.UIFrameFadeOut(dm, 1, dm:GetAlpha(), 0)
	elseif Updater2.mode == "IN" then
		nowwidth, allwidth, all = -375, 375, 1
		T.UIFrameFadeIn(cf, 1, cf:GetAlpha(), 1)
		T.UIFrameFadeIn(dm, 1, dm:GetAlpha(), 1)
	end
	Updater2:Show()
end)

for i = 1, NUM_CHAT_WINDOWS do
	_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusGained", function(self)
		if Updater2.mode == "IN" then
			nowwidth, allwidth, all = -375, 375, 1
			T.UIFrameFadeIn(cf, 1, cf:GetAlpha(), 1)
			T.UIFrameFadeIn(dm, 1, dm:GetAlpha(), 1)
			Updater2:Show()
		end
	end)
end

-- 隐藏按钮
for _, hide in next,
	{MinimapBorder, MinimapBorderTop, MinimapZoomIn, MinimapZoomOut, MiniMapVoiceChatFrame, MiniMapTracking,  
	MiniMapWorldMapButton, MinimapBackdrop, MinimapCluster, GameTimeFrame, MiniMapInstanceDifficulty,} do
	hide:Hide()
end
MinimapNorthTag:SetAlpha(0)

-- 整合按钮
local buttons = {}
local BlackList = { 
	["MiniMapTracking"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["MiniMapLFGFrame"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MiniMapMailFrame"] = true,
	["BattlefieldMinimap"] = true,
	["MinimapBackdrop"] = true,
	["GameTimeFrame"] = true,
	["TimeManagerClockButton"] = true,
	["FeedbackUIButton"] = true,
	["HelpOpenTicketButton"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["QueueStatusMinimapButton"] = true,
	["MinimapButtonCollectFrame"] = true,
}

local MBCF = CreateFrame("Frame", "MinimapButtonCollectFrame", Minimap)
MBCF:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
MBCF:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 5)
MBCF:SetHeight(20)
MBCF.bg = MBCF:CreateTexture(nil, "BACKGROUND")
MBCF.bg:SetTexture(G.media.blank)
MBCF.bg:SetAllPoints(MBCF)
MBCF.bg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, .8, 0, 0, 0, 0)

T.CollectMinimapButtons = function(parent)
	if aCoreCDB["OtherOptions"]["collectminimapbuttons"] then
		for i, child in ipairs({Minimap:GetChildren()}) do
			if child:GetName() and not BlackList[child:GetName()] then
				if child:GetObjectType() == "Button" or strupper(child:GetName()):match("BUTTON") then
					if child:IsShown() or aCoreCDB["OtherOptions"]["collecthidingminimapbuttons"] then
						child:SetParent(parent)
						for j = 1, child:GetNumRegions() do
							local region = select(j, child:GetRegions())
							if region:GetObjectType() == "Texture" then
								local texture = region:GetTexture()
								if texture == "Interface\\CharacterFrame\\TempPortraitAlphaMask" or texture == "Interface\\Minimap\\MiniMap-TrackingBorder" or texture == "Interface\\Minimap\\UI-Minimap-Background" or texture == "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight" then
									region:Hide()
								end
							end
						end
						tinsert(buttons, child)
					end
				end
			end
		end
	end
	if #buttons == 0 then 
		parent:Hide() 
	else
		for _, child in ipairs(buttons) do
			child:HookScript("OnEnter", function()
				T.UIFrameFadeIn(parent, .5, parent:GetAlpha(), 1)
			end)
			child:HookScript("OnLeave", function()
				T.UIFrameFadeOut(parent, .5, parent:GetAlpha(), 0)
			end)
		end
	end
	for i =1, #buttons do
		buttons[i]:ClearAllPoints()
		if i == 1 then
			buttons[i]:SetPoint("LEFT", parent, "LEFT", 0, 0)
		else
			buttons[i]:SetPoint("LEFT", buttons[i-1], "RIGHT", 0, 0)
		end
		buttons[i].ClearAllPoints = T.dummy
		buttons[i].SetPoint = T.dummy
	end
end

MBCF:SetScript("OnEvent", function(self)
	T.CollectMinimapButtons(MBCF)
	self:SetAlpha(0)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

MBCF:RegisterEvent("PLAYER_ENTERING_WORLD")

MBCF:SetScript("OnEnter", function(self)
	T.UIFrameFadeIn(self, .5, self:GetAlpha(), 1)
end)

Minimap:HookScript("OnEnter", function()
	T.UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
end)

MBCF:SetScript("OnLeave", function(self)
	T.UIFrameFadeOut(self, .5, self:GetAlpha(), 0)
end)

Minimap:HookScript("OnLeave", function()
	T.UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
end)
	
-- 战网好友上线提示
BNToastFrame:ClearAllPoints()
BNToastFrame:SetPoint("BOTTOMLEFT", chatframe_pullback, "TOPLEFT", 0, 10)
BNToastFrame_UpdateAnchor = function() end

-- 排队的眼睛
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusFrame:SetClampedToScreen(true)
QueueStatusFrame:ClearAllPoints()
QueueStatusFrame:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 9, -2)

-- 公会副本队伍
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetScale(.5)
GuildInstanceDifficulty:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 1)
GuildInstanceDifficulty:SetFrameStrata("HIGH")

-- 副本难度
local InstanceDifficulty = CreateFrame("Frame", nil, Minimap)
InstanceDifficulty:SetPoint("TOPLEFT", 8, -8)
InstanceDifficulty:SetSize(80, 20)

InstanceDifficulty.text = T.createtext(InstanceDifficulty, "OVERLAY", 12, "OUTLINE", "LEFT")
InstanceDifficulty.text:SetPoint"LEFT"
InstanceDifficulty.text:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)

InstanceDifficulty:RegisterEvent("PLAYER_ENTERING_WORLD")
InstanceDifficulty:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
InstanceDifficulty:SetScript("OnEvent", function(self) self.text:SetText(select(4, GetInstanceInfo())) end)

-- 隐藏时钟
if not IsAddOnLoaded("Blizzard_TimeManager") then LoadAddOn("Blizzard_TimeManager") end
local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:Hide()
TimeManagerClockButton:EnableMouse(false)

-- 缩放小地图比例
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        MinimapZoomIn:Click()
    elseif delta < 0 then
        MinimapZoomOut:Click()
    end
end)

 -- 右键打开追踪
Minimap:SetScript('OnMouseUp', function (self, button)
	if button == 'RightButton' then
		GameTooltip:Hide()
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, Minimap, (Minimap:GetWidth()+8), (Minimap:GetHeight()))
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", -3, 10)
	else
		Minimap_OnClick(self)
	end
end)

function GetMinimapShape() return 'SQUARE' end

-- 经验条
local xpbar = CreateFrame("StatusBar", G.uiname.."ExperienceBar", Minimap)
xpbar:SetWidth(5)
xpbar:SetOrientation("VERTICAL")
xpbar:SetStatusBarTexture(G.media.blank)
xpbar:SetStatusBarColor(.3, .4, 1)
xpbar:SetFrameLevel(Minimap:GetFrameLevel()+3)
xpbar:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
xpbar:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
xpbar.border = F.CreateBDFrame(xpbar, .8)

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
	GameTooltip:SetOwner(xpbar, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", -15, 10)
	
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()
	local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
	
	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		GameTooltip:AddDoubleLine(L["当前经验"], string.format("%s/%s (%d%%)", CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["剩余经验"], string.format("%s", CommaValue(maxXP-XP)), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
		if restXP then GameTooltip:AddDoubleLine(L["双倍"], string.format("|cffb3e1ff%s (%d%%)", CommaValue(restXP), restXP/maxXP*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end
	end
	
	if name and not UnitLevel("player") == MAX_PLAYER_LEVEL then
		GameTooltip:AddLine(" ")
	end

	if name then
		GameTooltip:AddLine(name.."  (".._G["FACTION_STANDING_LABEL"..rank]..")", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		GameTooltip:AddDoubleLine(L["声望"], string.format("%s/%s (%d%%)", CommaValue(value-minRep), CommaValue(maxRep-minRep), (value-minRep)/(maxRep-minRep)*100), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["剩余声望"], string.format("%s", CommaValue(maxRep-value)), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, 1, 1)
	end	
	
	GameTooltip:Show()
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
xpbar:RegisterEvent("PLAYER_LOGIN")

-- 世界频道
local WorldChannelToggle = CreateFrame("Button", G.uiname.."World Channel Button", ChatFrame1)
WorldChannelToggle:SetPoint("TOPLEFT", -20, -5)
WorldChannelToggle:SetSize(25, 25)
WorldChannelToggle:SetNormalTexture("Interface\\HELPFRAME\\ReportLagIcon-Chat", "ADD")
WorldChannelToggle:GetNormalTexture():SetDesaturated(true)

WorldChannelToggle:SetScript("OnClick", function(self)
	local inchannel = false
	local channels = {GetChannelList()}
	for i = 1, #channels do
		if channels[i] == "大脚世界频道" then
			inchannel = true
			break
		end
	end
	if inchannel then
		LeaveChannelByName("大脚世界频道")
		print("|cffFF0000离开|r 大脚世界频道")  
	else
		JoinPermanentChannel("大脚世界频道",nil,1)
		ChatFrame_AddChannel(ChatFrame1,"大脚世界频道")
		ChatFrame_RemoveMessageGroup(ChatFrame1,"CHANNEL")
		print("|cff7FFF00加入|r 大脚世界频道")
	end
end)

WorldChannelToggle:SetScript("OnEvent", function(self, event)
	local channels = {GetChannelList()}
	WorldChannelToggle:GetNormalTexture():SetVertexColor(.3, 1, 1)
	for i = 1, #channels do
		if channels[i] == "大脚世界频道" then
			WorldChannelToggle:GetNormalTexture():SetVertexColor(1, 0, 0)
			break
		end
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

WorldChannelToggle:RegisterEvent("PLAYER_ENTERING_WORLD")
WorldChannelToggle:RegisterEvent("CHANNEL_UI_UPDATE")

if G.Client == "zhCN" then WorldChannelToggle:Show() else WorldChannelToggle:Hide() end
--====================================================--
--[[                -- Topleft Info --              ]]--
--====================================================--
local InfoFrame = CreateFrame("Frame", G.uiname.."Topleft Info Frame", UIParent) -- Center Frame
InfoFrame:SetFrameStrata("BACKGROUND")
InfoFrame:SetSize(200, 80)
InfoFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -13)

local InfoButtons = {}
local function CreateInfoButton()
	local Button = CreateFrame("Frame", nil, InfoFrame)
	Button.text = T.createtext(Button, "OVERLAY", 12, "NONE", "CENTER")
	Button.text:SetShadowOffset(1, -1)	
	Button:SetAllPoints(Button.text)

	tinsert(InfoButtons, Button)
	return Button
end

-- 耐久
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

local ToggleAutoRepairMenu = CreateFrame("Frame", G.uiname.."ToggleAutoRepairMenu", UIParent, "UIDropDownMenuTemplate")
local ToggleAutoRepairList = {
	{text = L["autorepair"], checked= aCoreCDB["ItemOptions"]["autorepair"], func = function(self, _, _, checked) aCoreCDB["ItemOptions"]["autorepair"] = checked end, keepShownOnClick = true}, 
	{text = L["autorepair_guild"], checked = aCoreCDB["ItemOptions"]["autorepair_guild"], func = function(self, _, _, checked) aCoreCDB["ItemOptions"]["autorepair_guild"] = checked end, keepShownOnClick = true},  
}

local Durability = CreateInfoButton()
Durability:SetScript("OnMouseDown", function(self)
	EasyMenu(ToggleAutoRepairList, ToggleAutoRepairMenu, "cursor", 0, 0, "MENU", 2)
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)	
end)
Durability:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	r1, g1, b1 = ColorGradient(GetLowestDurability()-0.001, 1, 0, 0, 1, 1, 0, 1, 1, 1)
	self.text:SetText(format(G.classcolor..DURABILITY.." |r|cff%02x%02x%02x%d|r", r1 * 255, g1 * 255, b1 * 255, GetLowestDurability()*100))
end)

Durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Durability:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 好友
local Friends = CreateInfoButton()
Friends:SetScript("OnMouseDown", function(self)	ToggleFriendsFrame(1) end)
Friends:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	self.text:SetText(format(G.classcolor..FRIENDS.." |r%d", select(2, GetNumFriends())+select(2, BNGetNumFriends())))
end)

Friends:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
Friends:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
Friends:RegisterEvent("BN_FRIEND_TOON_ONLINE")
Friends:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
Friends:RegisterEvent("FRIENDLIST_UPDATE")
Friends:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 公会
local GuildMember = CreateInfoButton()
GuildMember:SetScript("OnMouseDown", function(self)
	if IsInGuild() then 
		if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end 
		GuildFrame_Toggle()
		GuildFrame_TabClicked(GuildFrameTab2)
	else 
		if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end 
		LookingForGuildFrame_Toggle() 
	end
end)
GuildMember:SetScript("OnEvent", function(self, event)
	if IsInGuild() then
		self.text:SetText(format(G.classcolor..GUILD.." |r%d", select(2, GetNumGuildMembers())))
	else
		self.text:SetText(format(G.classcolor..GUILD.." |r%d", NONE))
	end
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

GuildMember:RegisterEvent("GUILD_ROSTER_SHOW")
GuildMember:RegisterEvent("PLAYER_ENTERING_WORLD")
GuildMember:RegisterEvent("GUILD_ROSTER_UPDATE")
GuildMember:RegisterEvent("PLAYER_GUILD_UPDATE")

-- 金币
local Profit, Spent, OldMoney = 0, 0, 0

local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)
	if gold ~= 0 then
		return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
	else
		return format("%s".."|cffeda55fc|r", copper)
	end
end

local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)		
	return cash
end	
	
local Gold = CreateInfoButton()
Gold:SetScript("OnMouseDown", function() ToggleCharacter("TokenFrame") end)
Gold:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		OldMoney = GetMoney()
		if aCoreDB.gold[G.PlayerRealm] == nil then 
			aCoreDB.gold[G.PlayerRealm] = {}
		end	
	end
		
	local NewMoney	= GetMoney()
	local Change = NewMoney - OldMoney -- Positive if we gain money
		
	if OldMoney > NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end
	
	OldMoney = NewMoney
	
	self.text:SetText(format(G.classcolor..GOLD_AMOUNT_SYMBOL.." |r%d", NewMoney * 0.0001))

	aCoreDB.gold[G.PlayerRealm][G.PlayerName] = GetMoney()
end)

Gold:RegisterEvent("PLAYER_MONEY")
Gold:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
Gold:RegisterEvent("SEND_MAIL_COD_CHANGED")
Gold:RegisterEvent("PLAYER_TRADE_MONEY")
Gold:RegisterEvent("TRADE_MONEY_CHANGED")
Gold:RegisterEvent("PLAYER_ENTERING_WORLD")

Gold:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", MinimapZoneTextButton, "BOTTOMLEFT", 0, -5)
	GameTooltip:AddLine(L["本次登陆"]..": ", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	GameTooltip:AddDoubleLine(L["赚得"], formatMoney(Profit), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L["消费"], formatMoney(Spent), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		GameTooltip:AddDoubleLine(L["赤字"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		GameTooltip:AddDoubleLine(L["盈利"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
	end				
	GameTooltip:AddLine(" ")
	local totalGold = 0				
	GameTooltip:AddLine(L["角色"]..": ", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	for k,v in pairs(aCoreDB.gold[G.PlayerRealm]) do
		GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
		totalGold = totalGold + v
	end 
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["服务器"]..": ", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	GameTooltip:AddDoubleLine(TOTAL..": ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)
	for i = 1, MAX_WATCHED_TOKENS do
		local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
		if name and i == 1 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(CURRENCY, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end
		local r, g, b = 1 ,1 ,1
		if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
		if name and count then GameTooltip:AddDoubleLine(name, count, 1, 1, 1, 1, 1, 1) end
	end
	GameTooltip:Show()
end)
Gold:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 天赋
local Talent = CreateInfoButton()
Talent:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		ToggleTalentFrame()
	else
		local c = GetActiveSpecGroup(false,false)
		SetActiveSpecGroup(c == 1 and 2 or 1)
	end
end)

Talent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	
	if GetSpecialization() then
		self.text:SetText(format(G.classcolor.."%s|r", select(2, GetSpecializationInfo(GetSpecialization()))))
	else
		self.text:SetText("")
	end
end)

Talent:RegisterEvent("PLAYER_ENTERING_WORLD")

local LootSpecMenu = CreateFrame("Frame", G.uiname.."LootSpecMenu", UIParent, "UIDropDownMenuTemplate")
local LootSpecList = {
	{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true , notCheckable = true},
	{ text = LOOT_SPECIALIZATION_DEFAULT, specializationID = 0 },
	{ text = "spec1", specializationID = 0 },
	{ text = "spec2", specializationID = 0 },
	{ text = "spec3", specializationID = 0 },
	{ text = "spec4", specializationID = 0 },
}
local numspec = 4

if G.myClass ~= "DRUID" then
	tremove( LootSpecList, 6)
	numspec = 3
end

Talent:SetScript("OnMouseDown", function(self)
	if UnitLevel("player")>15 then
		local specPopupButton = LootSpecList[2]
		local specIndex = GetSpecialization()
		if specIndex then
			local specID, specName = GetSpecializationInfo(specIndex)
			if specName then
				specPopupButton.text = format(LOOT_SPECIALIZATION_DEFAULT, specName)
				specPopupButton.func = function(self) SetLootSpecialization(0) end
				if GetLootSpecialization() == specPopupButton.specializationID then
					specPopupButton.checked = true
				else
					specPopupButton.checked = false
				end
			end
		end
		for index = 3, numspec+2 do
			specPopupButton = LootSpecList[index]
			if specPopupButton then
				local id, name = GetSpecializationInfo(index-2)
				specPopupButton.specializationID = id
				specPopupButton.text = name
				specPopupButton.func = function(self) SetLootSpecialization(id) end
				if GetLootSpecialization() == specPopupButton.specializationID then
					specPopupButton.checked = true
				else
					specPopupButton.checked = false
				end
			end
		end
		EasyMenu(LootSpecList, LootSpecMenu, "cursor", 0, 0, "MENU", 2)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	end
end)

for i = 1, #InfoButtons do
	if i == 1 then
		InfoButtons[i].text:SetPoint("TOPLEFT", InfoFrame, "TOPLEFT", 0, 0)
	else
		InfoButtons[i].text:SetPoint("LEFT", InfoButtons[i-1].text, "RIGHT", 8, 0)
	end
end

local StatsFrame = CreateFrame("Frame", G.uiname.."Topleft Stats Frame", InfoFrame) -- Center Frame
StatsFrame:SetFrameStrata("BACKGROUND")
StatsFrame:SetSize(200, 80)
StatsFrame:SetPoint("TOPLEFT", Durability, "BOTTOMLEFT", 0, -10)

local Ttext = T.createtext(StatsFrame, "OVERLAY", 22, "NONE", "LEFT")
Ttext:SetPoint("TOPLEFT")
Ttext:SetShadowOffset(1, -1)

local Itext = T.createtext(StatsFrame, "OVERLAY", 14, "NONE", "LEFT")
Itext:SetPoint("TOPLEFT", Ttext, "TOPRIGHT", 7, -1)
Itext:SetShadowOffset(1, -1)

-- 新邮件图标
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetSize(18, 18)
MiniMapMailFrame:SetPoint("LEFT", Itext, "RIGHT", 5, 0)
MiniMapMailFrame:SetFrameLevel(StatsFrame:GetFrameLevel()+1)
MiniMapMailFrame:HookScript('OnEnter', function(self)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", MinimapZoneTextButton, "BOTTOMLEFT", 0, -5)
end)
MiniMapMailIcon:SetTexture('Interface\\Minimap\\TRACKING\\Mailbox')
MiniMapMailIcon:SetAllPoints(MiniMapMailFrame)
MiniMapMailBorder:Hide()

-- 位置
MinimapZoneTextButton:SetPoint("TOPLEFT", Ttext, "BOTTOMLEFT", 0, -10)
MinimapZoneTextButton:SetWidth(400)
MinimapZoneTextButton:SetParent(InfoFrame)
MinimapZoneTextButton:HookScript('OnEnter', function(self)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", MinimapZoneTextButton, "BOTTOMLEFT", 0, -5)
end)
MinimapZoneText:SetAllPoints(MinimapZoneTextButton)
MinimapZoneText:SetFont(G.norFont, 16, "NONE") 
MinimapZoneText:SetJustifyH"LEFT"

-- Format String
local memFormat = function(num)
	if num > 1024 then
		return format("%.2f mb", (num / 1024))
	else
		return format("%.1f kb", floor(num))
	end
end

-- Tooltips
local nraddons = 20
function memorytooltip()
	local addons, total, nr, name = {}, 0, 0
	local memory, entry
	local BlizzMem = collectgarbage("count")
			
	GameTooltip:SetOwner(InfoFrame, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", MinimapZoneTextButton, "BOTTOMLEFT", 0, -5)
	GameTooltip:AddLine(format(L["占用前 %d 的插件"], nraddons), G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
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
	table.sort(addons, function(a, b) return a.memory > b.memory end)
	for _, entry in pairs(addons) do
	if nr < nraddons then
			GameTooltip:AddDoubleLine(entry.name, memFormat(entry.memory), 1, 1, 1, ColorGradient(entry.memory / 1024, 0, 1, 0, 1, 1, 0, 1, 0, 0))
			nr = nr+1
		end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["自定义插件占用"], memFormat(total), 1, 1, 1, ColorGradient(total / (1024*20), 0, 1, 0, 1, 1, 0, 1, 0, 0))
	GameTooltip:AddDoubleLine(L["所有插件占用"], memFormat(BlizzMem), 1, 1, 1, ColorGradient(BlizzMem / (1024*50) , 0, 1, 0, 1, 1, 0, 1, 0, 0))
	GameTooltip:Show()
end

-- Update Function
local hour, fps, lag
local refresh_timer = 0
function StatsFrame:updateOntime(elapsed)
	refresh_timer = refresh_timer + elapsed
	if refresh_timer > 1 then -- 每秒刷新一次
		local r2, g2, b2 = ColorGradient(GetFramerate()/60-0.001, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		fps = format("|cff%02x%02x%02x%d|r|cff%02x%02x%02xfps|r  ", r2 * 255, g2 * 255, b2 * 255, GetFramerate(), G.Ccolor.r * 255, G.Ccolor.g * 255, G.Ccolor.b * 255)

		local r2, g2, b2 = ColorGradient(select(3, GetNetStats())/500-0.001, 0, 1, 0, 1, 1, 0, 0, 1, 0)
		lag = format("|cff%02x%02x%02x%d|r|cff%02x%02x%02xms|r  ", r2 * 255, g2 * 255, b2 * 255, select(3, GetNetStats()), G.Ccolor.r * 255, G.Ccolor.g * 255, G.Ccolor.b * 255)

		hour = date("%H:%M")
		
		Itext:SetText(fps..lag)
		Ttext:SetText(hour)
		
		refresh_timer = 0
	end
end

StatsFrame:SetScript("OnMouseDown", function(self) ToggleCalendar() end)
StatsFrame:SetScript("OnEnter", function(self) memorytooltip() end)
StatsFrame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
StatsFrame:SetScript("OnUpdate", StatsFrame.updateOntime)

--====================================================--
--[[                  -- Micromenu --               ]]--
--====================================================--

local MicromenuBar = CreateFrame("Frame", G.uiname.."MicromenuBar", UIParent) -- Center Frame
MicromenuBar:SetFrameStrata("MEDIUM")
MicromenuBar:SetSize(360, 25)
MicromenuBar:SetScale(aCoreCDB["OtherOptions"]["micromenuscale"])
MicromenuBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 30, 3)

MicromenuBar.toggle = CreateFrame("Button", nil, MicromenuBar)
MicromenuBar.toggle:SetPoint("RIGHT", MicromenuBar, "LEFT", -2, 0)
F.Reskin(MicromenuBar.toggle)

MicromenuBar.Char = CreateFrame("PlayerModel", G.uiname.."CharButton", MicromenuBar)
MicromenuBar.Char:SetSize(40, 40)
MicromenuBar.Char:SetUnit("player")
MicromenuBar.Char:SetPortraitZoom(1)
MicromenuBar.Char:SetPoint("BOTTOMLEFT", 0, 5)

local AltzMainMenu = CreateFrame("Frame", G.uiname.."ToggleAltzMainMenu", UIParent, "UIDropDownMenuTemplate")
local AltzMainMenuList = {
	{text = L["控制台"], func = function() _G["AltzUI_GUI Main Frame"]:Show() end, notCheckable = true},  -- GUI
	{text = L["团队工具"], func = function() _G[G.uiname.."RaidToolFrame"]:Show() end, notCheckable = true},  -- 团队工具
}

MicromenuBar.Char:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		ToggleCharacter("PaperDollFrame")
	else
		EasyMenu(AltzMainMenuList, AltzMainMenu, "cursor", 0, 0, "MENU", 2)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
	end
end)

MicromenuBar.Char:SetScript("OnEvent", function(self, event, unit)
	if unit == "player" then
		self:ClearModel()
		self:SetUnit("player")
	end
end)

MicromenuBar.Char:RegisterEvent("UNIT_MODEL_CHANGED")

local MicromenuButtons = {}
local function CreateMicromenuButton(text, texpath, original, left, right, top, bottom)
	local Button = CreateFrame("Button", nil, MicromenuBar)
	Button:SetSize(25, 25)
	Button.text = T.createtext(Button, "HIGHLIGHT", 12, "OUTLINE", "CENTER")
	Button.text:SetPoint("CENTER", Button, "TOP")
	if original == QuestLogMicroButton then
		Button.text:SetWidth(55)
	else
		Button.text:SetWidth(45)
	end
	Button.text:SetText(text)

	Button:SetHighlightTexture(texpath)
	Button:GetHighlightTexture():SetTexCoord(left, right, top, bottom)
	Button:GetHighlightTexture():SetBlendMode("BLEND")

	Button:SetNormalTexture(texpath)
	Button:GetNormalTexture():SetDesaturated(true)
	Button:GetNormalTexture():SetGradientAlpha("VERTICAL", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, 1)
	Button:GetNormalTexture():SetTexCoord(left, right, top, bottom)
	
	Button:SetScript("OnClick", function()
		if original == "MainMenuMicroButton" then
			if GameMenuFrame:IsShown() then
				GameMenuFrame:Hide()
			else
				GameMenuFrame:Show()
			end
		elseif original == "SpellbookMicroButton" then
			ToggleSpellBook("spell")			
		elseif original == "TalentMicroButton" then
			ToggleTalentFrame()
		elseif original == "AchievementMicroButton" then	
			ToggleAchievementFrame()
		elseif original == "QuestLogMicroButton" then
			ToggleFrame(QuestLogFrame)
		elseif original == "PVPMicroButton" then
			if not PVPUIFrame then PVP_LoadUI() end 
			ToggleFrame(PVPUIFrame)
		elseif original == "LFDMicroButton" then
			PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame)
		elseif original == "CompanionsMicroButton" then
			if not IsAddOnLoaded("Blizzard_PetJournal") then LoadAddOn("Blizzard_PetJournal") end 
			ToggleFrame(PetJournalParent)
		elseif original == "EJMicroButton" then
			if not IsAddOnLoaded("Blizzard_EncounterJournal") then LoadAddOn("Blizzard_EncounterJournal") end 
			ToggleFrame(EncounterJournal)
		elseif original == "Bag" then
			ToggleAllBags()		
		end
	end)
	

	tinsert(MicromenuButtons, Button)
	return Button
end

MicromenuBar.Mainmenu = CreateMicromenuButton(MAIN_MENU, "Interface\\MINIMAP\\OBJECTICONS", "MainMenuMicroButton", .12, .26, .49, .63)
MicromenuBar.Spellbook = CreateMicromenuButton(SPELLBOOK_ABILITIES_BUTTON, "Interface\\MINIMAP\\TRACKING\\Profession", "SpellbookMicroButton", .05, .95, .05, .95)
MicromenuBar.Spec = CreateMicromenuButton(TALENTS_BUTTON, "Interface\\MINIMAP\\TRACKING\\Reagents", "TalentMicroButton", .05, .95, .05, .95)
MicromenuBar.Achievement = CreateMicromenuButton(ACHIEVEMENT_BUTTON, "Interface\\ACHIEVEMENTFRAME\\UI-ACHIEVEMENT-SHIELDS-NOPOINTS", "AchievementMicroButton", 0, .45, .5, .95)
MicromenuBar.Quests = CreateMicromenuButton(QUESTLOG_BUTTON, "Interface\\MINIMAP\\TRACKING\\OBJECTICONS", "QuestLogMicroButton", 0.11, .25, .48, 1)
MicromenuBar.PvP = CreateMicromenuButton(PLAYER_V_PLAYER, "Interface\\WorldStateFrame\\CombatSwords", "PVPMicroButton", 0, .5, 0, .5)
MicromenuBar.LFR = CreateMicromenuButton(LFG_TITLE, "Interface\\LFGFRAME\\BattlenetWorking28", "LFDMicroButton", .14, .86, .14, .86)
MicromenuBar.Pet = CreateMicromenuButton(MOUNTS_AND_PETS, "Interface\\MINIMAP\\OBJECTICONS", "CompanionsMicroButton", .37, .5, .5, .63)
MicromenuBar.EJ = CreateMicromenuButton(ENCOUNTER_JOURNAL, "Interface\\MINIMAP\\TRACKING\\Class", "EJMicroButton", 0, 1, 0, 1)
MicromenuBar.Bag = CreateMicromenuButton(INVTYPE_BAG, "Interface\\MINIMAP\\TRACKING\\Banker", "Bag", 0, 1, 0, 1)

for i = 1, #MicromenuButtons do
	if i == 1 then
		MicromenuButtons[i]:SetPoint("BOTTOMLEFT", MicromenuBar.Char, "BOTTOMRIGHT", 5, -5)
	else
		MicromenuButtons[i]:SetPoint("LEFT", MicromenuButtons[i-1], "RIGHT", 5, 0)
	end
end

--====================================================--
--[[                 -- Screen --                   ]]--
--====================================================--
local TOPPANEL = CreateFrame("Frame", G.uiname.."AKF Toppanel", WorldFrame)
TOPPANEL:SetFrameStrata("FULLSCREEN")
TOPPANEL:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT",-5,5)
TOPPANEL:SetPoint("BOTTOMRIGHT",WorldFrame,"TOPRIGHT",5,-80)
F.SetBD(TOPPANEL)
TOPPANEL:Hide()

TOPPANEL.Clock = T.createtext(TOPPANEL, "OVERLAY", 27, "NONE", "CENTER")
TOPPANEL.Clock:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 10)
TOPPANEL.Clock:SetTextColor(0.7, 0.7, 0.7)

TOPPANEL.Date = T.createtext(TOPPANEL, "OVERLAY", 17, "NONE", "CENTER")
TOPPANEL.Date:SetPoint("BOTTOMLEFT", TOPPANEL, "BOTTOMRIGHT", -280, 40)
TOPPANEL.Date:SetTextColor(0.7, 0.7, 0.7)

TOPPANEL.AUI = T.createtext(TOPPANEL, "OVERLAY", 50, "NONE", "CENTER")
TOPPANEL.AUI:SetPoint("BOTTOMRIGHT", TOPPANEL, "BOTTOMRIGHT", -290, 13)
TOPPANEL.AUI:SetTextColor(0.7, 0.7, 0.7)
TOPPANEL.AUI:SetText("AltZ UI")

TOPPANEL.updater = 0
TOPPANEL:SetScript("OnUpdate", function(self, elapsed)
 	self.updater = self.updater - elapsed
	if self.updater <= 0 then
        self.Clock:SetText(format("%s",date("%H:%M:%S")))
		self.Date:SetText(format("%s",date("%a %b/%d")))
		self.updater = .5
	end
end)

local BOTTOMPANEL = CreateFrame("Frame", G.uiname.."AKF Bottompanel", WorldFrame)
BOTTOMPANEL:SetFrameStrata("FULLSCREEN")
BOTTOMPANEL:SetPoint("BOTTOMLEFT",WorldFrame,"BOTTOMLEFT",-5,-5)
BOTTOMPANEL:SetPoint("TOPRIGHT",WorldFrame,"BOTTOMRIGHT",5,75)
F.SetBD(BOTTOMPANEL)
BOTTOMPANEL:Hide()

BOTTOMPANEL.text = T.createtext(BOTTOMPANEL, "OVERLAY", 20, "NONE", "CENTER")
BOTTOMPANEL.text:SetPoint("TOP", BOTTOMPANEL, "TOP", 0, -10)
BOTTOMPANEL.text:SetTextColor(0, 0, 0,.5)
BOTTOMPANEL.text:SetText(L["点我隐藏"])

BOTTOMPANEL:SetScript("OnEnter", function(self) self.text:SetTextColor(.5, .5, .5, 1) end)
BOTTOMPANEL:SetScript("OnLeave", function(self) self.text:SetTextColor(0, 0, 0, .5) end)

local function littebutton(facing)
	local petmodelbutton = CreateFrame("PlayerModel", "AltzAKFlittlebutton"..facing, BOTTOMPANEL)
	petmodelbutton:SetSize(120,120)
	petmodelbutton:SetPosition(-0.5, 0, 0)
	petmodelbutton:SetFacing(facing)

	petmodelbutton.spark = petmodelbutton:CreateTexture(nil, "HIGHLIGHT")
	petmodelbutton.spark:SetSize(30, 30)
	petmodelbutton.spark:SetPoint("CENTER", petmodelbutton.text, "TOPRIGHT", -3, -5)
	petmodelbutton.spark:SetTexture("Interface\\Cooldown\\star4")
	petmodelbutton.spark:SetVertexColor(1, 1, 1, .7)
	petmodelbutton.spark:SetBlendMode("ADD")

	petmodelbutton:SetScript("OnEnter", function(self) self:SetFacing(0) end)
	petmodelbutton:SetScript("OnLeave", function(self) self:SetFacing(facing) end)
	
	return petmodelbutton
end

local Info = littebutton(1)
Info:SetPoint("BOTTOMRIGHT", BOTTOMPANEL, "CENTER", -200, -40)

local Credits = littebutton(-1)
Credits:SetPoint("BOTTOMLEFT", BOTTOMPANEL, "CENTER", 200, -40)

local function fadeout()
	Minimap:Hide()
	UIParent:SetAlpha(0)
	UIFrameFadeIn(TOPPANEL, 3, TOPPANEL:GetAlpha(), 1)
	UIFrameFadeIn(BOTTOMPANEL, 3, BOTTOMPANEL:GetAlpha(), 1)
	BOTTOMPANEL.t = 0
end

local function fadein()
	Minimap:Show()
	UIFrameFadeIn(UIParent, 2, 0, 1)
    UIFrameFadeOut(TOPPANEL, 2, TOPPANEL:GetAlpha(), 0)
	UIFrameFadeOut(BOTTOMPANEL, 2, BOTTOMPANEL:GetAlpha(), 0)
	BOTTOMPANEL:SetScript("OnUpdate",  function(self, e)
		self.t = self.t + e
		if self.t > .5 then
			self:Hide()
			TOPPANEL:Hide()
			self:SetScript("OnUpdate", nil)
			self.t = 0
		end
	end)
end

BOTTOMPANEL:SetScript("OnMouseUp", function() fadein() end)

BOTTOMPANEL:SetScript("OnEvent",function(self, event) 
	if event == "PLAYER_ENTERING_WORLD" then
		if aCoreDB.meet then
			fadeout()
		end
		
		local PetNumber = max(C_PetJournal.GetNumPets(false), 5)
		local randomIndex = random(1 ,PetNumber)
		local randomID = select(11, C_PetJournal.GetPetInfoByIndex(randomIndex))
		if randomID then
			Info:SetCreature(randomID)
			Credits:SetCreature(randomID)
		else
			Info:SetCreature(53623) -- 塞纳里奥角鹰兽宝宝
			Credits:SetCreature(53623)
		end
		
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_FLAGS_CHANGED" then
		if UnitIsAFK("player") then
			fadeout()
		end
	end
end)

BOTTOMPANEL:RegisterEvent("PLAYER_ENTERING_WORLD")
BOTTOMPANEL:RegisterEvent("PLAYER_FLAGS_CHANGED")
