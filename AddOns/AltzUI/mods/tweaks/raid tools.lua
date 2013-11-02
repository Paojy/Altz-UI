local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
local DBM = DBM

--INSTANCE_ENCOUNTER_ENGAGE_UNIT
--IsEncounterInProgress
local potions = {
	[GetSpellInfo(105697)]=true, --兔妖之啮
	[GetSpellInfo(105702)]=true, --青龙药水
	[GetSpellInfo(105706)]=true, --魔古之力药水
}

local foods = {
	[GetSpellInfo(104280)] = true,
}

local flasks = {
	--[GetSpellInfo(117666)]=true, -- 帝王传承 测试
	[GetSpellInfo(105691)]=true, --暖阳合剂
	[GetSpellInfo(105689)]=true, --春华合剂
	[GetSpellInfo(105693)]=true, --秋叶合剂
	[GetSpellInfo(105696)]=true, --冬噬合剂
	[GetSpellInfo(105694)]=true, --大地合剂
}

local RaidToolFrame = CreateFrame("Frame", G.uiname.."RaidToolFrame", UIParent)
RaidToolFrame:SetSize(270, 150)
RaidToolFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -120)
RaidToolFrame:SetFrameStrata("HIGH")
RaidToolFrame:Hide()

RaidToolFrame:RegisterForDrag("LeftButton")
RaidToolFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
RaidToolFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
RaidToolFrame:SetClampedToScreen(true)
RaidToolFrame:SetMovable(true)
RaidToolFrame:EnableMouse(true)

F.SetBD(RaidToolFrame)

RaidToolFrame.title = T.createtext(RaidToolFrame, "OVERLAY", 14, "OUTLINE", "CENTER")
RaidToolFrame.title:SetPoint("BOTTOM", RaidToolFrame, "TOP", 0, -5)
RaidToolFrame.title:SetText(G.classcolor..L["团队工具"].."|r")

RaidToolFrame.close = CreateFrame("Button", nil, RaidToolFrame)
RaidToolFrame.close:SetPoint("BOTTOMRIGHT", -3, 3)
RaidToolFrame.close:SetSize(15, 15)
T.SkinButton(RaidToolFrame.close, G.Iconpath.."exit", true)
RaidToolFrame.close:SetScript("OnClick", function()
	RaidToolFrame:Hide()
end)

local Stats = CreateFrame("Frame",  G.uiname.."RaidToolStats", RaidToolFrame)
Stats.text = T.createtext(Stats, "OVERLAY", 12, "OUTLINE", "LEFT")
Stats.text:SetPoint("TOPLEFT", RaidToolFrame, "TOPLEFT", 5, -15)
Stats:SetAllPoints(Stats.text)

local flasked, unflasked, fed, unfed, OoR = {}, {}, {}, {}, {}
local prepotion, potion, noprepotion, nopotion = {}, {}, {}, {}
local numflask, numfood, numoor, rosterflask, rosterfood, rosteroor

local function UpdateFlasked()
	table.wipe(flasked)
	table.wipe(unflasked)
	local n = GetNumGroupMembers()
	for id =1, n do
		local unit = ("raid%d"):format(id)
		local name = GetUnitName(unit, false)
		if aCoreCDB["RaidToolOptions"]["onlyactive"] and select(3, GetRaidRosterInfo(id))<=5 or not aCoreCDB["RaidToolOptions"]["onlyactive"] then
			local value = false
			for flask, v in pairs(flasks) do
				if UnitBuff(unit, flask) then
					tinsert(flasked, name)
					value = true
					break
				end
			end
			if not value then
				tinsert(unflasked, name)
			end
		end
	end
end

local function UpdateFed()
	table.wipe(fed)
	table.wipe(unfed)
	local n = GetNumGroupMembers()
	for id =1, n do
		local unit = ("raid%d"):format(id)
		local name = GetUnitName(unit, false)
		if aCoreCDB["RaidToolOptions"]["onlyactive"] and select(3, GetRaidRosterInfo(id))<=5 or not aCoreCDB["RaidToolOptions"]["onlyactive"] then
			local value = false
			for food, v in pairs(foods) do
				if UnitBuff(unit, food) then
					tinsert(fed, name)
					value = true
					break
				end
			end
			if not value then
				tinsert(unfed, name)
			end
		end
	end
end

local function UpdateOoR()
	table.wipe(OoR)
	local n = GetNumGroupMembers()
	for id =1, n do
		local unit = ("raid%d"):format(id)
		local name = GetUnitName(unit, false)
		if aCoreCDB["RaidToolOptions"]["onlyactive"] and select(3, GetRaidRosterInfo(id))<=5 or not aCoreCDB["RaidToolOptions"]["onlyactive"] then
			if not UnitInRange(unit) then
				tinsert(OoR, name)
			end
		end
	end
end

local function UpdateStats()
	UpdateFlasked()
	local raidflasked = #flasked/(#flasked+#unflasked)
	if raidflasked > .5 then
		if raidflasked == 1 then
			rosterflask = L["全合剂增益"]
			numflask = "|cffA6FFFF0 |r"..L["无2"]..L["合剂"]
		else
			rosterflask = L["无2"].."|cffA6FFFF"..L["合剂"]..":|r \n"..table.concat(unflasked, ", ")
			numflask = "|cffA6FFFF "..#unflasked.." |r"..L["无2"]..L["合剂"]
		end
	else
		numflask = "|cffA6FFFF"..#flasked.." |r"..L["合剂"]
		if raidflasked == 0 then
			rosterflask = "|cffA6FFFF"..L["合剂"]..":|r "..NONE
		else
			rosterflask = "|cffA6FFFF"..L["合剂"]..":|r \n"..table.concat(flasked, ", ")
		end
	end
	
	UpdateFed()
	local raidfed = #fed/(#fed+#unfed)
	if raidfed > .5 then
		if raidfed == 1 then
			rosterfood = L["全食物增益"]
			numfood = "|cffA6FFFF0 |r"..L["无2"]..L["食物"]
		else
			numfood = "|cffA6FFFF"..#unfed.." |r"..L["无2"]..L["食物"]
			rosterfood = L["无2"].."|cffA6FFFF"..L["食物"]..":|r \n"..table.concat(unfed, ", ")
		end
	else
		numfood = "|cffA6FFFF"..#fed.." |r"..L["食物"]
		if raidfed == 0 then
			rosterfood = "|cffA6FFFF"..L["食物"]..":|r "..NONE
		else
			rosterfood = "|cffA6FFFF"..L["食物"]..":|r \n"..table.concat(fed, ", ")
		end
	end
	
	UpdateOoR()
	numoor = "|cffA6FFFF"..#OoR.." |r"..L["过远"]
	if #OoR == 0 then
		rosteroor = "|cffA6FFFF"..L["距离过远"]..":|r "..NONE
	else
		rosteroor = "|cffA6FFFF"..L["距离过远"]..":|r \n"..table.concat(OoR, ", ")
	end
	
	Stats.text:SetText(numflask.."  "..numfood.."  "..numoor)
end

local function UpdateStatsToolTip()
	GameTooltip:SetOwner(Stats, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", RaidToolFrame, "TOPRIGHT", 10, 0)
	
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(rosterflask, 1, 1, 1, true)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(rosterfood, 1, 1, 1, true)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(rosteroor, 1, 1, 1, true)
	
	GameTooltip:Show()
end

local function OnCombatLogEvent(...)
	local subEvent, srcName, spellName = (select(2,...)), (select(5,...)), (select(13,...))
	local raidIndex = UnitInRaid(srcName)
    if subEvent == "SPELL_CAST_SUCCESS" and potions[spellName] and raidIndex then
        potion[GetUnitName(("raid%d"):format(raidIndex))] = spellName
    end
end

local function StartCombat()
	--print("|cffA6FFFF战斗开始|r")
    table.wipe(prepotion)	
    table.wipe(potion)
	local n = GetNumGroupMembers()
	for id =1, n do
		local uID = ("raid%d"):format(id)
        for buffName, value in pairs(potions) do
			if UnitBuff(uID, buffName) then
				prepotion[GetUnitName(uID,true)] = true
				break
			end
		end
   end
end

local fliter = {string.split(" ", aCoreCDB["RaidToolOptions"]["potionblacklist"])}
local blacklist = {}
for _, name in pairs(fliter) do
	blacklist[name] = true
end

local function EndCombat()
	--print("|cffA6FFFF战斗结束|r")
    table.wipe(noprepotion)	
    table.wipe(nopotion)
	local n = GetNumGroupMembers()
	for id =1, n do
		local unit = ("raid%d"):format(id)
        local name = GetUnitName(unit,false)
		if aCoreCDB["RaidToolOptions"]["onlyactive"] and select(3, GetRaidRosterInfo(id))<=5 or not aCoreCDB["RaidToolOptions"]["onlyactive"] then
			if not blacklist[name] then
				if not prepotion[name] then tinsert(noprepotion, name) end
				if not potion[name] then tinsert(nopotion, name) end
			end
		end
    end
	if aCoreCDB["RaidToolOptions"]["potion"] then
		if (#noprepotion>0) then
			SendChatMessage(L["偷药水"]..table.concat(noprepotion, ", "), "RAID")
		else
			SendChatMessage(L["全偷药水"], "RAID")
		end
		if (#nopotion>0) then
			SendChatMessage(L["药水"]..table.concat(nopotion, ", "), "RAID")
		else
			SendChatMessage(L["全药水"], "RAID")
		end
	end
end

local incombat = 0
local function OnHealth()
	local bossexists = UnitExists("boss1") or UnitExists("boss2") or UnitExists("boss3") or UnitExists("boss4") or UnitExists("boss5")
	if incombat == 0 and bossexists then
		incombat = 1
		StartCombat()
	elseif incombat == 1 and not bossexists then
		incombat = 0
		EndCombat()
	end
end

Stats:SetScript("OnEvent", function(self, event, ...)
	if event == "GROUP_ROSTER_UPDATE" then
		if IsInRaid() then
			self:RegisterEvent("UNIT_AURA")
			UpdateStats()
			self:SetScript("OnEnter", UpdateStatsToolTip)
			self:SetScript("OnLeave", function() GameTooltip:Hide() end)
			if aCoreCDB["RaidToolOptions"]["potion"] then
				self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				self:RegisterEvent("UNIT_HEALTH")
			end
		else
			self:UnregisterEvent("UNIT_AURA")
			self.text:SetText(ERR_NOT_IN_RAID)
			self:SetScript("OnEnter", nil)
			self:SetScript("OnLeave", nil)
			if aCoreCDB["RaidToolOptions"]["potion"] then
				self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				self:UnregisterEvent("UNIT_HEALTH")
			end
		end
	elseif event == "UNIT_AURA" then
		UpdateStats()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		OnCombatLogEvent(...)
	elseif event == "UNIT_HEALTH" then
		OnHealth()
	elseif event == "PLAYER_LOGIN" then
		if IsInRaid() then
			self:RegisterEvent("UNIT_AURA")
			UpdateStats()
			self:SetScript("OnEnter", UpdateStatsToolTip)
			self:SetScript("OnLeave", function() GameTooltip:Hide() end)
			if aCoreCDB["RaidToolOptions"]["potion"] then
				self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				self:RegisterEvent("UNIT_HEALTH")
			end
		else
			self.text:SetText(ERR_NOT_IN_RAID)
		end
	end
end)

Stats:RegisterEvent("GROUP_ROSTER_UPDATE")
Stats:RegisterEvent("PLAYER_LOGIN")

local ConfigButton = CreateFrame("Button",  G.uiname.."RaidToolConfig", RaidToolFrame)
ConfigButton:SetPoint("TOPRIGHT", -10, -15)
ConfigButton:SetSize(15, 15)
T.SkinButton(ConfigButton, G.Iconpath.."RaidTool", true)

ConfigButton:SetScript("OnClick", function(self)
	local GUI = _G[G.uiname.."GUI Main Frame"]
	GUI:Show()
	
	for i = 1, 20 do
		local tab = GUI["tab"..i]
		if tab.fname == G.uiname.."RaidTool Options" then
			tab:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			tab:SetPoint("TOPLEFT", GUI, "TOPRIGHT", 8,  -30*i)
			_G[tab.fname]:Show()
		elseif GUI["tab"..i].fname then
			tab:SetBackdropBorderColor(0, 0, 0)
			tab:SetPoint("TOPLEFT", GUI, "TOPRIGHT", 2,  -30*i)
			_G[tab.fname]:Hide()
		end
	end
end)

local WorldMarkButton = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
WorldMarkButton:SetParent(RaidToolFrame)
WorldMarkButton:ClearAllPoints()
WorldMarkButton:SetPoint("RIGHT", ConfigButton, "LEFT", -5, 0)
WorldMarkButton:SetSize(15, 15)

_G[WorldMarkButton:GetName().."Left"]:SetAlpha(0) 
_G[WorldMarkButton:GetName().."Middle"]:SetAlpha(0) 
_G[WorldMarkButton:GetName().."Right"]:SetAlpha(0) 

WorldMarkButton:HookScript("OnEvent", function(self, event) 
	if UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") or (IsInGroup() and not IsInRaid()) then
		self:Enable()
	else
		self:Disable()
	end
end)

WorldMarkButton:RegisterEvent("GROUP_ROSTER_UPDATE")
WorldMarkButton:RegisterEvent("PLAYER_ENTERING_WORLD")

local AncButton = CreateFrame("Button",  G.uiname.."RaidToolAncButton", RaidToolFrame)
AncButton:SetPoint("RIGHT", WorldMarkButton, "LEFT", -5, 0)
AncButton:SetSize(15, 15)
T.SkinButton(AncButton, G.Iconpath.."anc", true)

AncButton:SetScript("OnClick", function(self)
	if IsInRaid() then
		UpdateFlasked()
		local raidflasked = #flasked/(#flasked+#unflasked)
		if raidflasked > .5 then
			SendChatMessage(L["无"]..L["合剂"]..": "..table.concat(unflasked, ", "), "RAID")
		elseif raidflasked == 0 then
			SendChatMessage(L["无合剂增益"], "RAID")
		else
			SendChatMessage(L["合剂"]..": "..table.concat(flasked, ", "), "RAID")
		end
			
		UpdateFed()
		local raidfed = #fed/(#fed+#unfed)
		if raidfed > .5 then
			SendChatMessage(L["无"]..L["食物"]..": "..table.concat(unfed, ", "), "RAID")
		elseif raidfed == 0 then
			SendChatMessage(L["无食物增益"], "RAID")
		else
			SendChatMessage(L["食物"]..": "..table.concat(fed, ", "), "RAID")
		end
			
		UpdateOoR()
		SendChatMessage(L["距离过远"]..": "..table.concat(OoR, ", "), "RAID")
	end
end)

local PullButton = CreateFrame("Button", G.uiname.."RaidToolPullButton", RaidToolFrame, "UIPanelButtonTemplate")
PullButton:SetPoint("TOPRIGHT", RaidToolFrame, "TOP", -5, -40)
PullButton:SetSize(RaidToolFrame:GetWidth()/2-20, 25)
PullButton.text = PullButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
PullButton.text:SetPoint("CENTER")
PullButton.text:SetText(L["dbm_pull"])

F.Reskin(PullButton)

PullButton:SetScript("OnEvent", function(self)
	if IsAddOnLoaded("DBM-Core") then
		self:Enable()
	else
		self:Disable()
		self:SetScript("OnEnter", function()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(L["需要加载DBM"])
			GameTooltip:Show()
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
end)
PullButton:RegisterEvent("PLAYER_LOGIN")
PullButton:SetScript("OnClick", function()
	if DBM then
		local timer = aCoreCDB["RaidToolOptions"]["pulltime"] or 10
		SendAddonMessage("D4", "PT\t"..timer, "RAID")
	end
end)

local LagCheckButton = CreateFrame("Button", G.uiname.."RaidToolLagCheckButton", RaidToolFrame, "UIPanelButtonTemplate")
LagCheckButton:SetPoint("LEFT", PullButton, "RIGHT", 10, 0)
LagCheckButton:SetSize(RaidToolFrame:GetWidth()/2-20, 25)
LagCheckButton.text = LagCheckButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
LagCheckButton.text:SetPoint("CENTER")
LagCheckButton.text:SetText(L["dbm_lag"])

F.Reskin(LagCheckButton)

LagCheckButton:SetScript("OnEvent", function(self)
	if IsAddOnLoaded("DBM-Core") then
		self:Enable()
	else
		self:Disable()
		self:SetScript("OnEnter", function()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(L["需要加载DBM"])
			GameTooltip:Show()
		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
end)
LagCheckButton:RegisterEvent("PLAYER_LOGIN")
LagCheckButton:SetScript("OnClick", function()
	if DBM then
		SendAddonMessage("D4", "L\t", "RAID")
		DBM:AddMsg(DBM_CORE_LAG_CHECKING)
		DBM:Schedule(5, function() DBM:ShowLag() end)
	end
end)

local function ReSkinButton(button, ...)
	button:SetParent(RaidToolFrame)
	button:ClearAllPoints()
	button:SetPoint(...)
	button:SetSize(RaidToolFrame:GetWidth()/2-20, 25)
	button.SetPoint = T.dummy
	for j = 1, button:GetNumRegions() do
		local region = select(j, button:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:Hide()
		end
	end
	F.Reskin(button)
end


local ReadyCheckButton = CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck
ReSkinButton(ReadyCheckButton, "TOP", PullButton, "BOTTOM", 0, -8)

local RolePollButton = CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll
ReSkinButton(RolePollButton, "LEFT", ReadyCheckButton, "RIGHT", 10, 0)

local SwitchRaidButton = CreateFrame("Button", G.uiname.."RaidToolSwitchRaidButton", RaidToolFrame, "UIPanelButtonTemplate")
SwitchRaidButton:SetPoint("TOP", ReadyCheckButton, "BOTTOM", 0, -8)
SwitchRaidButton:SetSize(RaidToolFrame:GetWidth()/2-20, 25)
SwitchRaidButton.text = SwitchRaidButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
SwitchRaidButton.text:SetPoint("CENTER")

F.Reskin(SwitchRaidButton)

SwitchRaidButton:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		if aCoreCDB["UnitframeOptions"]["enableraid"] then
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		else
			self:Hide()
			return
		end
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	
	if arg1 and arg1 ~= "player" then return end -- "PLAYER_SPECIALIZATION_CHANGED"
	
	if T.IsDpsRaidShown() then
		self.text:SetText(L["dpser"])
	else
		self.text:SetText(L["healer"])
	end
		
	if aCoreCDB["UnitframeOptions"]["autoswitch"] then
		self:UnregisterAllEvents()
	end
end)

SwitchRaidButton:RegisterEvent("PLAYER_ENTERING_WORLD")

SwitchRaidButton:SetScript("OnClick", function(self)
	T.SwitchRaidFrame()
	if T.IsDpsRaidShown() then
		self.text:SetText(L["dpser"])
	else
		self.text:SetText(L["healer"])
	end
end)

local ConvertGroupButton = CompactRaidFrameManagerDisplayFrameConvertToRaid
ReSkinButton(ConvertGroupButton, "LEFT", SwitchRaidButton, "RIGHT", 10, 0)

local AllAssistButton = CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton
AllAssistButton:SetParent(RaidToolFrame)
AllAssistButton:ClearAllPoints()
AllAssistButton:SetPoint("TOPLEFT", RolePollButton, "BOTTOMLEFT", 0, -6)
AllAssistButton.ClearAllPoints = T.dummy
AllAssistButton.SetPoint = T.dummy
F.ReskinCheck(AllAssistButton)

local RaidMarkFrame = CreateFrame("Frame", G.uiname.."RaidMarkFrame", UIParent)
RaidMarkFrame:SetSize(270, 80)
RaidMarkFrame:SetPoint("TOP", RaidToolFrame, "BOTTOM", 0, -5)
RaidMarkFrame:SetFrameStrata("HIGH")
RaidMarkFrame:Hide()

RaidMarkFrame:RegisterForDrag("LeftButton")
RaidMarkFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
RaidMarkFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
RaidMarkFrame:SetClampedToScreen(true)
RaidMarkFrame:SetMovable(true)
F.SetBD(RaidMarkFrame)

RaidMarkFrame.lockbutton = CreateFrame("Button", nil, RaidMarkFrame)
RaidMarkFrame.lockbutton:SetPoint("TOPRIGHT", -3, -3)
RaidMarkFrame.lockbutton:SetSize(15, 15)
T.SkinButton(RaidMarkFrame.lockbutton, G.Iconpath.."lock", true)
	
CompactRaidFrameManagerDisplayFrameRaidMarkers:SetParent(RaidMarkFrame)
CompactRaidFrameManagerDisplayFrameRaidMarkers:ClearAllPoints()
CompactRaidFrameManagerDisplayFrameRaidMarkers:SetPoint("CENTER", RaidMarkFrame, "CENTER")
CompactRaidFrameManagerDisplayFrameRaidMarkers.ClearAllPoints = T.dummy
CompactRaidFrameManagerDisplayFrameRaidMarkers.SetPoint = T.dummy
CompactRaidFrameManagerDisplayFrameRaidMarkers.Hide = CompactRaidFrameManagerDisplayFrameRaidMarkers.Show

local function lockraidmarkframe()
	RaidMarkFrame:EnableMouse(false)
	RaidMarkFrame:ClearAllPoints()
	RaidMarkFrame:SetPoint("TOP", RaidToolFrame, "BOTTOM", 0, -5)
	aCoreCDB["RaidToolOptions"]["unlockraidmarks"] = true
end

local function unlockraidmarkframe()
	RaidMarkFrame:EnableMouse(true)
	aCoreCDB["RaidToolOptions"]["unlockraidmarks"] = false
end

local function Lock()
	if aCoreCDB["RaidToolOptions"]["unlockraidmarks"] then
		unlockraidmarkframe()
	else
		lockraidmarkframe()
	end
end

RaidMarkFrame.lockbutton:SetScript("OnClick", Lock)
RaidMarkFrame:SetScript("OnEvent", Lock)
RaidMarkFrame:RegisterEvent("PLAYER_LOGIN")

RaidToolFrame.toggleraidmark = CreateFrame("Button", nil, RaidToolFrame)
RaidToolFrame.toggleraidmark:SetPoint("BOTTOMRIGHT", -22, 1)
RaidToolFrame.toggleraidmark:SetSize(20, 20)
T.SkinButton(RaidToolFrame.toggleraidmark, G.Iconpath.."Achievement", true)

local function Toggle()
	if RaidMarkFrame:IsShown() then
		RaidMarkFrame:Hide()
	else
		RaidMarkFrame:Show()
	end
end

RaidToolFrame.toggleraidmark:SetScript("OnClick", Toggle)
