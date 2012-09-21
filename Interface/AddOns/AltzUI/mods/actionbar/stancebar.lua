local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local padding = 4
local buttonssize = aCoreCDB.stancebarbuttonszie
local buttonspace = aCoreCDB.stancebarbuttonspace

-- FUNCTIONS

local num = NUM_STANCE_SLOTS
local num2 = NUM_POSSESS_SLOTS
local buttonList = {}

--make a frame that fits the size of all microbuttons
local frame = CreateFrame("Frame", "Altz_Stancebar", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["Stancebar"]
frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)
frame:SetHeight(buttonssize + 2*padding)
frame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -6, -4)

--STANCE BAR
--move the buttons into position and reparent them
StanceBarFrame:SetParent(frame)
StanceBarFrame:EnableMouse(false)

for i=1, num do
	local button = _G["StanceButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["StanceButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
	end
end

--POSSESS BAR
--move the buttons into position and reparent them
PossessBarFrame:SetParent(frame)
PossessBarFrame:EnableMouse(false)

for i=1, num2 do
	local button = _G["PossessButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	else
		local previous = _G["PossessButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
	end
end

--hide the frame when in a vehicle!
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

--create drag frame and drag functionality
T.CreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp