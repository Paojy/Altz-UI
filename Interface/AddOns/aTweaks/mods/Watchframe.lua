--Author: Nibelheim
local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.customwf then return end

local lColor = GetClassColor()

local Opts = {

-- Text Colors
colors = {
	lines = {
		-- Lines in their normal state
		normal = {
			header = {r = lColor.r/1.5, g = lColor.g/1.5, b = lColor.b/1.5},
			objectives = {r = 0.7, g = 0.7, b = 0.7},
		},
		-- Lines when you mouse-over them
		highlight = {
			header = {r = lColor.r, g = lColor.g, b = lColor.b},
			objectives = {r = 1, g = 1, b = 1},
		},
	},
},

-- Auto-Hide
hidden = {
	-- Collapse the Watch Frame
	collapse = {
		pvp = cfg.collapsepvp,
		arena = cfg.collapsearena,
		party = cfg.collapseparty,
		raid = cfg.collapseraid,
	},
	-- Hide the Watch Frame completely
	hide = {
		pvp = cfg.hidepvp,
		arena = cfg.hidearena,
		party = cfg.hideparty,
		raid = cfg.hideraid,
	},
},

}

local nWFA = CreateFrame("Frame")
--local EventsRegistered

local WF;
local OrigWFSetPoint, OrigWFClearAllPoints;
local origWFHighlight;
local WFColorsHooked = false;

-- Hide Quest Tracker based on zone
function nWFA.UpdateHideState()
	if not WF then WF = _G["WatchFrame"]; end
	
	local Inst, InstType = IsInInstance();
	local Hide = false;
	if Inst then
		if (InstType == "pvp" and Opts.hidden.hide.pvp) then			-- Battlegrounds
			Hide = true;
		elseif (InstType == "arena" and Opts.hidden.hide.arena) then	-- Arena
			Hide = true;
		elseif (InstType == "party" and Opts.hidden.hide.party) then	-- 5 Man Dungeons
			Hide = true;
		elseif (InstType == "raid" and Opts.hidden.hide.raid) then	-- Raid Dungeons
			Hide = true;
		end
	end
	if Hide then WF:Hide() else WF:Show() end
end

-- Collapse Quest Tracker based on zone
function nWFA.UpdateCollapseState()
	if not WF then WF = _G["WatchFrame"]; end

	local Inst, InstType = IsInInstance();
	local Collapsed = false;
	if Inst then
		if (InstType == "pvp" and Opts.hidden.collapse.pvp) then			-- Battlegrounds
			Collapsed = true;
		elseif (InstType == "arena" and Opts.hidden.collapse.arena) then	-- Arena
			Collapsed = true;
		elseif (InstType == "party" and Opts.hidden.collapse.party) then	-- 5 Man Dungeons
			Collapsed = true;
		elseif (InstType == "raid" and Opts.hidden.collapse.raid) then	-- Raid Dungeons
			Collapsed = true;
		end
	end
	
	if Collapsed then
		WF.userCollapsed = true;
		WatchFrame_Collapse(WF);
	else
		WF.userCollapsed = false;
		WatchFrame_Expand(WF);
	end	
end

-- Position the Quest Tracker
function nWFA.UpdatePosition()
	if not WF then WF = _G["WatchFrame"]; end
	
	if not OrigWFSetPoint then
		OrigWFSetPoint = WF.SetPoint;
	else
		WF.SetPoint = OrigWFSetPoint;
	end
	if not OrigWFClearAllPoints then
		OrigWFClearAllPoints = WF.ClearAllPoints;
	else
		WF.ClearAllPoints = OrigWFClearAllPoints;
	end
	
	WF:SetFrameStrata("HIGH")
	WF:ClearAllPoints();
	WF:SetPoint(cfg.anchor, "UIParent", cfg.anchor, cfg.x, cfg.y);
	WF:SetHeight(UIParent:GetHeight() - cfg.heightsc);
	WF.ClearAllPoints = function() end
	WF.SetPoint = function() end
end

-- Udate WatchFrame styling
function nWFA.UpdateStyle()
	local WFT = _G["WatchFrameTitle"];
	
	-- Header
	if not WFColorsHooked then nWFA.HookWFColors(); end
	if WFT then	
		WFT:SetTextColor(1, 1, 1);
	end

	-- Update all lines
	for i = 1, #WATCHFRAME_LINKBUTTONS do
		WatchFrameLinkButtonTemplate_Highlight(WATCHFRAME_LINKBUTTONS[i], false);
	end
end

-- Font Updates
function nWFA.HookFont()
	local WFT = _G["WatchFrameTitle"]
	
	WFT:SetFont(GameFontHighlight:GetFont(), cfg.wffont, "OUTLINE")
	
	hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
		line.text:SetFont(GameFontHighlight:GetFont(), cfg.wffont, "OUTLINE")
		if line.dash then
			line.dash:SetFont(GameFontHighlight:GetFont(), cfg.wffont, "OUTLINE")
		end
	end)
end

-- Hook into / replace WatchFrame functions for Colors
function nWFA.HookWFColors()
	local lc = {
		n = {h = Opts.colors.lines.normal.header, o = Opts.colors.lines.normal.objectives},
		h = {h = Opts.colors.lines.highlight.header, o = Opts.colors.lines.highlight.objectives},
	};
		
	-- Hook into SetLine to change color of lines	
	hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
		if isHeader then 
			line.text:SetTextColor(lc.n.h.r, lc.n.h.g, lc.n.h.b);
		else
			line.text:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b);
		end
	end)
		
	-- Replace Highlight function
	WatchFrameLinkButtonTemplate_Highlight = function(self, onEnter)
		local line;
		for index = self.startLine, self.lastLine do
			line = self.lines[index];
			if line then
				if index == self.startLine then
				-- header
					if onEnter then
						line.text:SetTextColor(lc.h.h.r, lc.h.h.g, lc.h.h.b);
					else
						line.text:SetTextColor(lc.n.h.r, lc.n.h.g, lc.n.h.b);
					end
				else
					if onEnter then
						line.text:SetTextColor(lc.h.o.r, lc.h.o.g, lc.h.o.b);
						line.dash:SetTextColor(lc.h.o.r, lc.h.o.g, lc.h.o.b);
					else
						line.text:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b);
						line.dash:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b);
					end
				end
			end
		end
	end
	WFColorsHooked = true
end

function nWFA.PLAYER_ENTERING_WORLD()
	nWFA.UpdateCollapseState()
	nWFA.UpdateHideState()
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