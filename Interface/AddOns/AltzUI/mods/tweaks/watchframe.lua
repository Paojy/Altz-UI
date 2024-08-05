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
