local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

Minimap:SetParent(UIParent)
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -20)
Minimap:SetFrameStrata("BACKGROUND")
Minimap:SetSize(128, 128)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
F.SetBD(Minimap, -1, 1, 1, -1)

function fixTooltip(self)
	if self ~= MiniMapMailFrame then
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
	end
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 8, 0)
end

function dropdownOnClick(self)
	GameTooltip:Hide()
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint('TOPLEFT', Minimap, 'TOPRIGHT', 2, 0)
end

-- Hide thins we dont need
for _, hide in next,
{	MinimapBorder, 
	MinimapBorderTop, 
	MinimapZoomIn, 
	MinimapZoomOut, 
	MiniMapVoiceChatFrame,
	GameTimeFrame, 
	MiniMapTracking,  
	MiniMapWorldMapButton, 
	MinimapBackdrop,
	MinimapCluster,
	GameTimeFrame,
	MiniMapInstanceDifficulty,} do
	hide:Hide()
end
MinimapNorthTag:SetAlpha(0)

-- mail 
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetSize(16, 16)
MiniMapMailFrame:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 5)
MiniMapMailFrame:HookScript('OnEnter', fixTooltip)
MiniMapMailIcon:SetTexture('Interface\\Minimap\\TRACKING\\Mailbox')
MiniMapMailIcon:SetAllPoints(MiniMapMailFrame)
MiniMapMailBorder:Hide()

-- queuestatus
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusFrame:SetClampedToScreen(true)
QueueStatusFrame:ClearAllPoints()
QueueStatusFrame:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 9, -2)

--InstanceDifficulty
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetScale(.5)
GuildInstanceDifficulty:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 1)
GuildInstanceDifficulty:SetFrameStrata("HIGH")

local id = CreateFrame("Frame", nil, Minimap)
id:SetPoint("TOPLEFT", 8, -8)
id:SetSize(80, 20)
local idtext = T.createtext(id, "OVERLAY", 14, "OUTLINE", "LEFT")
idtext:SetPoint"LEFT"
idtext:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)

function indiff()
	local index = GetInstanceDifficulty()
	if index == 2 then
		return "5"
	elseif index == 3 then
		return "5|cffFF7F00H|r"
	elseif index == 4 then
		return "10"
	elseif index == 5 then
		return "25"
	elseif index == 6 then
		return "10|cffFF7F00H|r"
	elseif index == 7 then
		return "25|cffFF7F00H|r"	
	elseif index == 8 then
		return "|cff7FFF00LFR|r"
	elseif index == 9 then
		return "|cffCD0000CLG|r"
	elseif index == 10 then
		return "40"
	end
end

id:RegisterEvent("PLAYER_ENTERING_WORLD")
id:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
id:SetScript("OnEvent", function() idtext:SetText(indiff()) end)

-- location
MinimapZoneTextButton:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 10, -25)
MinimapZoneTextButton:SetWidth(400)
MinimapZoneTextButton:SetParent(Minimap)
MinimapZoneTextButton:Hide()
MinimapZoneText:SetAllPoints(MinimapZoneTextButton)
MinimapZoneText:SetFont(NAMEPLATE_FONT, 18, "OUTLINE") 
MinimapZoneText:SetJustifyH"LEFT"

Minimap:HookScript('OnEnter', function() MinimapZoneTextButton:Show() end)
Minimap:HookScript('OnLeave', function() MinimapZoneTextButton:Hide() end)

-- Clock 
if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end

local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:Hide()
TimeManagerClockButton:EnableMouse(false)

-- room in / room out
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        MinimapZoomIn:Click()
    elseif delta < 0 then
        MinimapZoomOut:Click()
    end
end)

Minimap:SetScript('OnMouseUp', function (self, button)
	if button == 'RightButton' then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, Minimap, (Minimap:GetWidth()+8), (Minimap:GetHeight()))
		GameTooltip:Hide()
	else
		Minimap_OnClick(self)
	end
end)

function GetMinimapShape() return 'SQUARE' end