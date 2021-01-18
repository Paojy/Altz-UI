--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

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

local anchorframe = CreateFrame("Frame", "Altz_WFanchorframe", UIParent)
local customobjectivetracker = aCoreCDB["SkinOptions"]["customobjectivetracker"]
if customobjectivetracker then return end
 
anchorframe.movingname = L["任务追踪"]
anchorframe.point = {
	healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 20, y = -200},
	dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 20, y = -200},
}
T.CreateDragFrame(anchorframe) --frame, dragFrameList, inset, clamp	
anchorframe:SetSize(240, 20)


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


local vm = ObjectiveTrackerFrame

vm:SetFrameStrata("MEDIUM")
vm:SetFrameLevel(15) -- higher than multiright actionbar
vm:ClearAllPoints()
vm:SetPoint("TOPLEFT", anchorframe, "TOPLEFT")
vm:SetHeight(G.screenheight - 300)
vm.ClearAllPoints = function() end
vm.SetPoint = function() end
