local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local padding = 4
local buttonssize = 35
local buttonspace = 4
-- FUNCTIONS

local num = NUM_ACTIONBAR_BUTTONS --there seems to be no MAX_OVERRIDE_NUM or the like
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_OverrideBar", UIParent, "SecureHandlerStateTemplate")
frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)
frame:SetHeight(buttonssize + 2*padding)
frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -140, 30)

--move the buttons into position and reparent them
OverrideActionBar:SetParent(frame)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil) --remove the onshow script

local leaveButtonPlaced = false

for i=1, num do
	local button =_G["OverrideActionBarButton"..i]
	if not button and not leaveButtonPlaced then
		button = OverrideActionBar.LeaveButton --the magic 7th button
		leaveButtonPlaced = true
	end
	if not button then
		break
	end
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["OverrideActionBarButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
	end
end

--show/hide the frame on a given state driver
RegisterStateDriver(frame, "visibility", "[petbattle] hide; [overridebar][vehicleui] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[petbattle] hide; [overridebar][vehicleui] show; hide")