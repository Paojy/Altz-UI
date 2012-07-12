local ADDON_NAME, ns = ...
local cfg = ns.cfg

local Ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

Minimap:SetParent(UIParent)
Minimap:ClearAllPoints()
Minimap:SetFrameStrata("MEDIUM")
Minimap:SetSize(120, 120)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
createpxBD(Minimap, 0, 1)
Minimap.pxborder:SetFrameLevel(3)
creategrowBD(Minimap, 0, 0, 0, 0, 1)
Minimap.border:SetFrameLevel(2)
Minimap.border:ClearAllPoints()
Minimap.border:SetPoint("TOPLEFT", -4, 4)
Minimap.border:SetPoint("BOTTOMRIGHT", 4, -4)
	
local PMinimap = createtex(Minimap, "World\\GENERIC\\ACTIVEDOODADS\\INSTANCEPORTAL\\GENERICGLOW2.BLP", "ADD")
PMinimap:ClearAllPoints()
PMinimap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -90, 90)
PMinimap:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 90, -90)
PMinimap:SetVertexColor(Ccolor.r, Ccolor.g, Ccolor.b)
PMinimap:SetDrawLayer("BACKGROUND")

function fixTooltip(self)
	if self ~= MiniMapMailFrame then
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
	end
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint('TOPLEFT', Minimap, 'TOPRIGHT', 2, 0)
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
MiniMapMailFrame:SetPoint(unpack(cfg.mailposition))
MiniMapMailFrame:HookScript('OnEnter', fixTooltip)
MiniMapMailIcon:SetTexture('Interface\\Minimap\\TRACKING\\Mailbox')
MiniMapMailIcon:SetAllPoints(MiniMapMailFrame)
MiniMapMailBorder:Hide()

-- queuestatus
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -2,2)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusFrame:SetClampedToScreen(true)

--InstanceDifficulty
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetScale(.5)
GuildInstanceDifficulty:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 1)
GuildInstanceDifficulty:SetFrameStrata("HIGH")

MiniMapInstanceDifficulty:Hide()
local id = CreateFrame("Frame", nil, Minimap)
id:SetPoint("TOPLEFT")
id:SetSize(25, 25)
local idtext = createtext(id, 14, "THINOUTLINE", true)
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
SubLoc:SetAllPoints()
local SubText = createtext(SubLoc, 15, "OUTLINE", false)
SubText:SetPoint("CENTER", SubLoc, "CENTER", 0,13)
SubText:SetText(GetSubZoneText())
SubText:Hide()
local SubText2 = createtext(SubLoc, 11, "OUTLINE", false)
SubText2:SetPoint("CENTER", SubLoc, "CENTER", 0,-8)
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
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, Minimap, (Minimap:GetWidth()+2), (Minimap:GetHeight()))
		GameTooltip:Hide()
	else
		Minimap_OnClick(self)
	end
end)

function GetMinimapShape() return 'SQUARE' end