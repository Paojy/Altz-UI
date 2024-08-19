--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))


local function ReskinFont(font, size)
	if not font then return end
	local oldSize = select(2, font:GetFont())
	size = size or oldSize
	font:SetFont(G.norFont, size, "OUTLINE")
	font:SetShadowColor(0, 0, 0, 0)
end

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
	
	ReskinFont(ObjectiveTrackerLineFont)
	ReskinFont(ObjectiveTrackerHeaderFont)
end)


