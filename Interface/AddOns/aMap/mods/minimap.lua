local ADDON_NAME, ns = ...
local cfg = ns.cfg

local Ccolor = GetClassColor()

Minimap:SetParent(UIParent)
Minimap:ClearAllPoints()
Minimap:SetFrameStrata("BACKGROUND")
Minimap:SetSize(120, 120)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
createpxBD(Minimap, 0, 1)
Minimap.pxborder:SetFrameLevel(3)
creategrowBD(Minimap, 0, 0, 0, 0, 1)
Minimap.border:SetFrameLevel(2)
Minimap.border:ClearAllPoints()
Minimap.border:SetPoint("TOPLEFT", -3, 3)
Minimap.border:SetPoint("BOTTOMRIGHT", 3, -3)

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

Minimap:SetPoint(unpack(cfg.spawn))

-- Hide thins we dont need
for _, hide in next,
{
MinimapBorder, 
MinimapBorderTop, 
MinimapZoomIn, 
MinimapZoomOut, 
MiniMapVoiceChatFrame,
GameTimeFrame, 
MinimapZoneTextButton, 
MiniMapTracking,  
MiniMapWorldMapButton, 
MinimapBackdrop,MinimapCluster,GameTimeFrame} do
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

MiniMapInstanceDifficulty:Hide()
local id = CreateFrame("Frame", nil, Minimap)
id:SetPoint("TOPLEFT")
id:SetSize(25, 25)
local idtext = createtext(id, "OVERLAY", 14, "OUTLINE", "CENTER")
idtext:SetAllPoints()
idtext:SetTextColor(Ccolor.r, Ccolor.g, Ccolor.b)

function indiff()
	local inInstance, instancetype = IsInInstance()
	local _, _, difficultyIndex, _, _, playerDifficulty, isDynamic = GetInstanceInfo()
	if inInstance and instancetype == "raid" then
		if isDynamic and difficultyIndex == 4 then
			if playerDifficulty == 0 then
				idtext:SetText("25H")
			end
		end
		if isDynamic and difficultyIndex == 3 then
			if playerDifficulty == 0 then
				idtext:SetText("10H")
			end
		end
		if isDynamic and difficultyIndex == 2 then
			if playerDifficulty == 0 then
				idtext:SetText("25")
			end
			if playerDifficulty == 1 then
				idtext:SetText("25H") 
			end
		end
		if isDynamic and difficultyIndex == 1 then
			if playerDifficulty == 0 then
				idtext:SetText("10") 
			end
			if playerDifficulty == 1 then
				idtext:SetText("10H") 
			end
		end
		if not isDynamic then
			if difficultyIndex == 1 then
				idtext:SetText("10") 
			end
			if difficultyIndex == 2 then
				idtext:SetText("25") 
			end
			if difficultyIndex == 3 then
				idtext:SetText("10H") 
			end
			if difficultyIndex == 4 then
				idtext:SetText("25H") 
			end
		end
	end
	if not inInstance then
		idtext:SetText("") 
	end
end
id:RegisterEvent("PLAYER_ENTERING_WORLD")
id:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")

id:SetScript("OnEvent", function() indiff() end)

-- location

local SubLoc = CreateFrame("Frame", "Sub Location", Minimap)
SubLoc:SetSize(200, 100)
SubLoc:SetPoint("TOPLEFT", Minimap, "TOPRIGHT", 10, -20)

local SubText = createtext(SubLoc, "OVERLAY", 15, "OUTLINE", "CENTER")
SubText:SetPoint("TOPLEFT", SubLoc, "TOPLEFT", 0, 0)
SubText:SetText(GetSubZoneText())
SubText:Hide()
local SubText2 = createtext(SubLoc, "OVERLAY", 12, "OUTLINE", "CENTER")
SubText2:SetPoint("TOPLEFT", SubLoc, "TOPLEFT", 0, -22)
SubText2:SetText(GetZoneText())
SubText2:Hide()

Minimap:SetScript('OnEnter', function() SubText:Show() SubText2:Show() end)
Minimap:SetScript('OnLeave', function() SubText:Hide() SubText2:Hide() end)

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