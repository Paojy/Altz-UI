local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local padding = 10
local buttonssize = aCoreCDB.leave_vehiclebuttonsize

-- FUNCTIONS

local num = 1
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_leave_vehicle", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["leave_vehicle"]
frame:SetWidth(num*buttonssize + 2*padding)
frame:SetHeight(buttonssize + 2*padding)
frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 280, 20)

--the button
local button = CreateFrame("BUTTON", "rABS_LeaveVehicleButton", frame, "SecureHandlerClickTemplate, SecureHandlerStateTemplate");
table.insert(buttonList, button) --add the button object to the list
button:SetSize(buttonssize, buttonssize)
button:SetPoint("BOTTOMLEFT", frame, padding, padding)
button:RegisterForClicks("AnyUp")
button:SetScript("OnClick", function(self) VehicleExit() end)

button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
local nt = button:GetNormalTexture()
local pu = button:GetPushedTexture()
local hi = button:GetHighlightTexture()
nt:SetTexCoord(0.0859375,0.1679688,0.359375,0.4414063)
pu:SetTexCoord(0.001953125,0.08398438,0.359375,0.4414063)
hi:SetTexCoord(0.6152344,0.6972656,0.359375,0.4414063)
hi:SetBlendMode("ADD")

--[possessbar][overridebar]
--the button will spawn if a vehicle exists, but no vehicle ui is in place (the vehicle ui has its own exit button)
--RegisterStateDriver(frame, "visibility", "[vehicleui][petbattle] hide; [@vehicle,exists] show; hide")
RegisterStateDriver(button, "visibility", "[vehicleui][petbattle] hide; [@vehicle,exists] show; hide")

--create drag frame and drag functionality
T.CreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp