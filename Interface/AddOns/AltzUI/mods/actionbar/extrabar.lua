local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local padding = 10
local buttonssize = aCoreCDB.extrabarbuttonsize

-- FUNCTIONS

local num = 1
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_extrabarbutton", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["extrabarbutton"]
frame:SetWidth(num*buttonssize + 2*padding)
frame:SetHeight(buttonssize + 2*padding)
frame:SetPoint("TOP", UIParent, "CENTER", 0, -200)

--move the buttons into position and reparent them
ExtraActionBarFrame:SetParent(frame)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

--the extra button
local button = ExtraActionButton1
table.insert(buttonList, button) --add the button object to the list
button:SetSize(buttonssize,buttonssize)

--hide the frame when in a vehicle!
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

--create drag frame and drag functionality
T.CreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
