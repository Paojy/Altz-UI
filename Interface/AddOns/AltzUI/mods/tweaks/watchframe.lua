--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function()
	if aCoreCDB["SkinOptions"]["collapseWF"] then
		if IsInInstance() then
			ObjectiveTrackerFrame.Header:SetCollapsed(true)
		else
			ObjectiveTrackerFrame.Header:SetCollapsed(true)
		end
	end
end)

OBJECTIVE_TRACKER_COLOR["Normal"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["Normal"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["Normal"]["b"] = 1

OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["b"] = 0

OBJECTIVE_TRACKER_COLOR["Header"]["r"] = G.addon_color[1]
OBJECTIVE_TRACKER_COLOR["Header"]["g"] = G.addon_color[2]
OBJECTIVE_TRACKER_COLOR["Header"]["b"] = G.addon_color[3]

OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["r"] = G.addon_color[1]
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["g"] = G.addon_color[2]
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["b"] = G.addon_color[3]

OBJECTIVE_TRACKER_COLOR["Complete"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["Complete"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["Complete"]["b"] = 1
