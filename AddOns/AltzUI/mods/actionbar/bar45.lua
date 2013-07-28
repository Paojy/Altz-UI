local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local buttonssize = aCoreCDB["ActionbarOptions"]["bar45size"]
local buttonspace = aCoreCDB["ActionbarOptions"]["bar45space"]
local padding = 4
local mouseover = {
	enable= aCoreCDB["ActionbarOptions"]["bar45mfade"],
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB["ActionbarOptions"]["bar45fademinaplha"]},
	}
local eventfader= {
	enable= aCoreCDB["ActionbarOptions"]["bar45efade"],
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 1.5, alpha = aCoreCDB["ActionbarOptions"]["bar45fademinaplha"]},
	}

-- FUNCTIONS

local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_Bar4&5", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["右侧额外动作条"]
frame.point = {
	healer = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -20, y = 195},
	dpser = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -20, y = 195},
}
T.CreateDragFrame(frame)
frame:SetWidth(2*buttonssize + (2-1)*buttonspace + 2*padding)
frame:SetHeight(num*buttonssize + (num-1)*buttonspace + 2*padding)

--move the buttons into position and reparent them
MultiBarRight:SetParent(frame)
MultiBarRight:EnableMouse(false)
MultiBarLeft:SetParent(frame)
MultiBarLeft:EnableMouse(false)

for i=1, num do
	local button = _G["MultiBarRightButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPRIGHT", frame, -padding, -padding)
	else
		local previous = _G["MultiBarRightButton"..i-1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -buttonspace)
	end
end

for i=1, num do
	local button = _G["MultiBarLeftButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPRIGHT", frame, -(padding+buttonspace+buttonssize), -padding)
	else
		local previous = _G["MultiBarLeftButton"..i-1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -buttonspace)
	end
end

--hide the frame when in a vehicle!
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

--create the mouseover functionality
if mouseover.enable then
	T.ActionbarFader(frame, buttonList, mouseover.fadeIn, mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end

--create the fade on condition functionality
if eventfader.enable then
	T.ActionbarEventFader(frame, buttonList, eventfader.fadeIn, eventfader.fadeOut) --frame, fadeIn, fadeOut
end