--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
local dragFrameList = G.dragFrameList

F.Reskin(WatchFrameCollapseExpandButton)
WatchFrameCollapseExpandButton:SetScale(.7)
WatchFrameCollapseExpandButton:ClearAllPoints()
WatchFrameCollapseExpandButton:SetPoint("TOPLEFT")

collapsepvp = true
collapsearena = false
collapseparty = true
collapseraid = true

local nWFA = CreateFrame("Frame")

local WF
local OrigWFSetPoint, OrigWFClearAllPoints
local origWFHighlight

local anchorframe = CreateFrame("Frame", "Altz_WFanchorframe", UIParent)
anchorframe.movingname = L["任务追踪"]
anchorframe.point = {
	healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 35, y = -20},
	dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 35, y = -20},
}
T.CreateDragFrame(anchorframe) --frame, dragFrameList, inset, clamp	
anchorframe:SetSize(200, 20)

-- Collapse Quest Tracker based on zone
function nWFA.UpdateCollapseState()
	if not WF then WF = _G["WatchFrame"] end

	local Inst, InstType = IsInInstance()
	local Collapsed = false;
	if Inst then
		if InstType == "pvp" and collapsepvp then  -- Battlegrounds
			Collapsed = true;
		elseif InstType == "arena" and collapsearena then  -- Arena
			Collapsed = true;
		elseif InstType == "party" and collapseparty then  -- 5 Man Dungeons
			Collapsed = true;
		elseif InstType == "raid" and collapseraid then  -- Raid Dungeons
			Collapsed = true;
		end
	end
	
	if Collapsed then
		WF.userCollapsed = true
		WatchFrame_Collapse(WF)
	else
		WF.userCollapsed = false
		WatchFrame_Expand(WF)
	end	
end

-- Position the Quest Tracker
function nWFA.UpdatePosition()
	if not WF then WF = _G["WatchFrame"] end
	
	if not OrigWFSetPoint then
		OrigWFSetPoint = WF.SetPoint
	else
		WF.SetPoint = OrigWFSetPoint
	end
	if not OrigWFClearAllPoints then
		OrigWFClearAllPoints = WF.ClearAllPoints
	else
		WF.ClearAllPoints = OrigWFClearAllPoints
	end
	
	WF:SetFrameStrata("MEDIUM")
	WF:SetFrameLevel(15) -- higher than multiright actionbar
	WF:ClearAllPoints()
	WF:SetPoint("TOPLEFT", anchorframe, "TOPLEFT")
	WF:SetHeight(G.screenheight - 300)
	WF.ClearAllPoints = function() end
	WF.SetPoint = function() end
end

-- Udate WatchFrame styling
function nWFA.UpdateStyle()
	local WFT = _G["WatchFrameTitle"]
	if WFT then	
		WFT:SetTextColor(1, 1, 1)
	end
	for i = 1, #WATCHFRAME_LINKBUTTONS do
		WatchFrameLinkButtonTemplate_Highlight(WATCHFRAME_LINKBUTTONS[i], false)
	end
end

-- Font Updates
function nWFA.HookFont()
	local WFT = _G["WatchFrameTitle"]
	WFT:SetFont(G.norFont, 12, "OUTLINE")
	WFT:SetShadowOffset(0, 0)
	WFT:SetPoint("TOPLEFT", WatchFrameCollapseExpandButton, "TOPRIGHT", 5, 0)
	hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
		line.text:SetFont(G.norFont, 12, "OUTLINE")
		line.text:SetShadowOffset(0, 0)
		if line.dash then
			line.dash:SetFont(G.norFont, 12, "OUTLINE")
			line.dash:SetShadowOffset(0, 0)
		end
	end)
end

-- Hook into / replace WatchFrame functions for Colors
function nWFA.HookWFColors()
	-- Hook into SetLine to change color of lines	
	hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
		if isHeader then 
			line.text:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		else
			line.text:SetTextColor(.7, .7, .7)
		end
	end)
	-- Replace Highlight function
	WatchFrameLinkButtonTemplate_Highlight = function(self, onEnter)
		local line;
		for index = self.startLine, self.lastLine do
			line = self.lines[index];
			if line then
				if index ~= self.startLine then
					if onEnter then
						line.text:SetTextColor(1, 1, 1)
						line.dash:SetTextColor(1, 1, 1)
					else
						line.text:SetTextColor(.7, .7, .7)
						line.dash:SetTextColor(.7, .7, .7)
					end
				end
			end
		end
	end
end

function nWFA.PLAYER_ENTERING_WORLD()
	nWFA.UpdateCollapseState()
end

function nWFA.PLAYER_LOGIN()
	nWFA.HookWFColors()
	nWFA.UpdatePosition()
	nWFA.UpdateStyle()
	nWFA.HookFont()
end

local function EventHandler(self, event)
	if event == "PLAYER_LOGIN" then
		nWFA.PLAYER_LOGIN()
	elseif event == "PLAYER_ENTERING_WORLD" then
		nWFA.PLAYER_ENTERING_WORLD()
	end
end

nWFA:RegisterEvent("PLAYER_LOGIN")
nWFA:RegisterEvent("PLAYER_ENTERING_WORLD")
nWFA:SetScript("OnEvent", EventHandler)