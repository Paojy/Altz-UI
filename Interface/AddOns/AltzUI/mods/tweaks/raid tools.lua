local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)
local DBM = DBM

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

local WorldMarkButton = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
WorldMarkButton:SetParent(RaidToolFrame)
WorldMarkButton:ClearAllPoints()
WorldMarkButton:SetPoint("TOPRIGHT", RaidToolFrame, "TOPRIGHT", -5, -3)
WorldMarkButton:SetSize(15, 15)

WorldMarkButton:HookScript("OnEvent", function(self, event) 
	if UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") or (IsInGroup() and not IsInRaid()) then
		self:Enable()
	else
		self:Disable()
	end
end)

WorldMarkButton:RegisterEvent("GROUP_ROSTER_UPDATE")
WorldMarkButton:RegisterEvent("PLAYER_ENTERING_WORLD")

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
		C_ChatInfo.SendAddonMessage("D4", "PT\t"..timer, "RAID")
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
		C_ChatInfo.SendAddonMessage("D4", "L\t", "RAID")
		DBM:AddMsg(DBM_CORE_LAG_CHECKING)
		DBM:Schedule(5, function() DBM:ShowLag() end)
	end
end)

local function ReSkinButton(button, ...)
	button:SetParent(RaidToolFrame)
	button:ClearAllPoints()
	button:SetPoint(...)
	button:SetSize(RaidToolFrame:GetWidth()/2-20, 25)
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

local ConvertGroupButton = CreateFrame("Button", G.uiname.."ConvertGroupButton", RaidToolFrame, "UIPanelButtonTemplate")
ConvertGroupButton:SetPoint("LEFT", SwitchRaidButton, "RIGHT", 10, 0)
ConvertGroupButton:SetSize(RaidToolFrame:GetWidth()/2-20, 25)
ConvertGroupButton.text = ConvertGroupButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
ConvertGroupButton.text:SetPoint("CENTER")

F.Reskin(ConvertGroupButton)

ConvertGroupButton:SetScript("OnEvent", function(self, event, arg1)
	if not IsInGroup() then
		self:Hide()
	else
		if IsInRaid() then
			self.text:SetText(CONVERT_TO_PARTY)
		else
			self.text:SetText(CONVERT_TO_RAID)
		end
		self:Show()
	end
end)

ConvertGroupButton:RegisterEvent("GROUP_ROSTER_UPDATE")
ConvertGroupButton:RegisterEvent("PLAYER_ENTERING_WORLD")

ConvertGroupButton:SetScript("OnClick", function(self)
	if IsInRaid() then
		ConvertToParty()
	else
		ConvertToRaid()
	end
end)

local AllAssistButton = CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton
AllAssistButton:SetParent(RaidToolFrame)
AllAssistButton:ClearAllPoints()
AllAssistButton:SetPoint("TOPLEFT", 5, -6)
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