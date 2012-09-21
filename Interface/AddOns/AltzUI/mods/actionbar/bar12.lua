local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local buttonssize = aCoreCDB.bar12size
local buttonspace = aCoreCDB.bar12space
local padding = 4
local mouseover = {
	enable= aCoreCDB.bar12mfade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB.bar12fademinaplha},
	}
local eventfader= {
	enable= aCoreCDB.bar12efade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 1.5, alpha = aCoreCDB.bar12fademinaplha},
}

-- FUNCTIONS

local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_Bar1&2", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["Bar1&2"]
frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)
frame:SetHeight(2*buttonssize + buttonspace + 2*padding)
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 15)

--move the buttons into position and reparent them
MainMenuBarArtFrame:SetParent(frame)
MainMenuBarArtFrame:EnableMouse(false)
MultiBarBottomLeft:SetParent(frame)
MultiBarBottomLeft:EnableMouse(false)

for i=1, num do
	local button = _G["ActionButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPLEFT", frame, padding, -padding)
	else
		local previous = _G["ActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
	end
end

for i=1, num do
	local button = _G["MultiBarBottomLeftButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPLEFT", frame, padding, -padding -buttonspace -buttonssize)
	else
		local previous = _G["MultiBarBottomLeftButton"..i-1]
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
