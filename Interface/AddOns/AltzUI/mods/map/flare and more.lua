local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local READY_CHECK = READY_CHECK
local ROLE_POLL = ROLE_POLL
local CONVERT_TO_RAID = CONVERT_TO_RAID
local CONVERT_TO_PARTY = CONVERT_TO_PARTY

local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -6, -6) 
wm:SetSize(10, 10)
F.Reskin(wm)
wm:Hide()

CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0) 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0) 
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0) 

local wmmenuFrame = CreateFrame("Frame", "wmRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local wmmenuList = { 
	{text = READY_CHECK, func = function() DoReadyCheck() end}, 
	{text = ROLE_POLL, func = function() InitiateRolePoll() end}, 
	{text = CONVERT_TO_RAID, func = function() ConvertToRaid() end}, 
	{text = CONVERT_TO_PARTY, func = function() ConvertToParty() end}, 
} 

wm:SetScript('OnMouseUp', function(self, button) 
	if (button=="RightButton") then 
		EasyMenu(wmmenuList, wmmenuFrame, "cursor", -150, 0, "MENU", 2) 
	end 
end)

wm:RegisterEvent("GROUP_ROSTER_UPDATE")
wm:HookScript("OnEvent", function(self, event) 
	if UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") or (IsInGroup() and not IsInRaid()) then
		self:Show()
	else
		self:Hide()
	end
end)