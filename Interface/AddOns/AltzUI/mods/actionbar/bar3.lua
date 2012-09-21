local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local buttonssize = aCoreCDB.bar3size
local buttonspace = aCoreCDB.bar3space
local padding = 4
local layout3x2x2 = aCoreCDB.bar3uselayout322
local space1 = aCoreCDB.space1
local mouseover = {
	enable= aCoreCDB.bar3mfade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB.bar3fademinaplha},
	}
local eventfader= {
	enable= aCoreCDB.bar3efade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 1.5, alpha = aCoreCDB.bar3fademinaplha},
	}

-- FUNCTIONS

local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_Bar3", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["Bar3"]
if layout3x2x2 then
	frame:SetWidth(num/2*buttonssize +(num/2-2)*buttonspace +2*padding +num*aCoreCDB.bar12size +(num-1)*aCoreCDB.bar12space +2*padding +2*space1)
	frame:SetHeight(2*buttonssize + 2*padding + buttonspace)
else
	frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)
	frame:SetHeight(buttonssize + 2*padding)
end
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 15)

--move the buttons into position and reparent them
MultiBarBottomRight:SetParent(frame)
MultiBarBottomRight:EnableMouse(false)

for i=1, num do
	local button = _G["MultiBarBottomRightButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPLEFT", frame, padding, -padding)
	elseif layout3x2x2 and i == 4 then
		button:SetPoint("TOP", "MultiBarBottomRightButton1", "BOTTOM", 0, -buttonspace)
	elseif layout3x2x2 and i == 7 then
		button:SetPoint("TOPRIGHT", frame, -padding -2*buttonssize -2*buttonspace, -padding)
	elseif layout3x2x2 and i == 10 then
		button:SetPoint("TOP", "MultiBarBottomRightButton7", "BOTTOM", 0, -buttonspace)
	else
		local previous = _G["MultiBarBottomRightButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
	end
end

--hide the frame when in a vehicle!
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

--create drag frame and drag functionality
T.CreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

--create the mouseover functionality
if mouseover.enable then
	T.ActionbarFader(frame, buttonList, mouseover.fadeIn, mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end

--create the fade on condition functionality
if eventfader.enable then
	T.ActionbarEventFader(frame, buttonList, eventfader.fadeIn, eventfader.fadeOut) --frame, fadeIn, fadeOut
end