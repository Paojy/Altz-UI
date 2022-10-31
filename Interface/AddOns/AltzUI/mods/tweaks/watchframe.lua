--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function()
	if aCoreCDB["SkinOptions"]["collapseWF"] then
		if IsInInstance() then
			ObjectiveTracker_Collapse()
		else
			ObjectiveTracker_Expand()
		end
	end
end)

OBJECTIVE_TRACKER_COLOR["Normal"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["Normal"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["Normal"]["b"] = 1

OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["b"] = 0

OBJECTIVE_TRACKER_COLOR["Header"]["r"] = G.Ccolor.r
OBJECTIVE_TRACKER_COLOR["Header"]["g"] = G.Ccolor.g
OBJECTIVE_TRACKER_COLOR["Header"]["b"] = G.Ccolor.b

OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["r"] = G.Ccolor.r
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["g"] = G.Ccolor.g
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["b"] = G.Ccolor.b

OBJECTIVE_TRACKER_COLOR["Complete"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["Complete"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["Complete"]["b"] = 1
