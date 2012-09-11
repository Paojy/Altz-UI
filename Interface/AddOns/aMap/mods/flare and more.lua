--[[---------
## Title: Flare
## Author: 楼上你妈妈叫你吃饭，Athelas
--]]--------
local Ccolor = GetClassColor()
local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -3, -3) 
wm:SetSize(20, 20)
creategrowBD(wm, Ccolor.r, Ccolor.g, Ccolor.b, 0.3, 1)
wm.border:SetAllPoints(wm)
wm:Hide()

CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0) 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0) 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0) 
wm:SetDisabledTexture("")
wm:SetHighlightTexture("")

wm:RegisterEvent("GROUP_ROSTER_UPDATE")

wm:HookScript("OnEvent", function(self, event) 
	if UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") or (IsInGroup() and not IsInRaid()) then
		self:Show()
	else
		self:Hide()
	end
end)
