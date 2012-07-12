--[[---------
## Title: Flare
## Author: 楼上你妈妈叫你吃饭，Athelas

--]]--------
local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -3, -3) 
wm:SetSize(16, 16)
wm:Hide()

CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0) 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0) 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0) 
wm:SetHighlightTexture("")
wm:SetDisabledTexture("")

local wmmenuFrame = CreateFrame("Frame", "wmRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local wmmenuList = { 
	{text = "Ready Check", func = function() DoReadyCheck() end}, 
	{text = "Initiate Role Poll", func = function() InitiateRolePoll() end}, 
	{text = "Convert To Raid", func = function() ConvertToRaid() end}, 
	{text = "Convert To Party", func = function() ConvertToParty() end}, 
} 

wm:SetScript('OnMouseUp', function(self, button) 
	if (button=="RightButton") then 
		EasyMenu(wmmenuList, wmmenuFrame, "cursor", -150, 0, "MENU", 2) 
	end 
end)

wm:RegisterEvent("PARTY_MEMBERS_CHANGED")
wm:RegisterEvent("PLAYER_ENTERING_WORLD")

wm:HookScript("OnEvent", function(self) 
	local inInstance, instanceType = IsInInstance()
	if (UnitIsRaidOfficer("player") or UnitIsGroupLeader("player")) and not (inInstance and (instanceType == "raid"))
	or (inInstance and (instanceType == "party")) then
		self:Show()
	else
		self:Hide()
	end
end) 
