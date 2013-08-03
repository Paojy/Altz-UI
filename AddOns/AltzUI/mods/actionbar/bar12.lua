local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local buttonssize = aCoreCDB["ActionbarOptions"]["bar12size"]
local buttonspace = aCoreCDB["ActionbarOptions"]["bar12space"]
local bar1top = aCoreCDB["ActionbarOptions"]["bar1top"]
local padding = 4
local mouseover = {
	enable= aCoreCDB["ActionbarOptions"]["bar12mfade"],
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB["ActionbarOptions"]["bar12fademinaplha"]},
	}
local eventfader= {
	enable= aCoreCDB["ActionbarOptions"]["bar12efade"],
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 1.5, alpha = aCoreCDB["ActionbarOptions"]["bar12fademinaplha"]},
}

-- FUNCTIONS

local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_Bar1&2", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["主动作条"]
frame.point = {
	healer = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 30},
	dpser = {a1 = "BOTTOM", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 30},
}
T.CreateDragFrame(frame)
frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)
frame:SetHeight(2*buttonssize + buttonspace + 2*padding)

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
		if bar1top then
			button:SetPoint("TOPLEFT", frame, padding, -padding)
		else
			button:SetPoint("BOTTOMLEFT", frame, padding, padding)
		end
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
		if bar1top then
			button:SetPoint("TOPLEFT", frame, padding, -padding -buttonspace -buttonssize)
		else
			button:SetPoint("BOTTOMLEFT", frame, padding, padding +buttonspace +buttonssize)
		end
	else
		local previous = _G["MultiBarBottomLeftButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
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
