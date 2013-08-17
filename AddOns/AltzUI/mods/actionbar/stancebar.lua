local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local padding = 4
local buttonssize = aCoreCDB["ActionbarOptions"]["stancebarbuttonszie"]
local buttonspace = aCoreCDB["ActionbarOptions"]["stancebarbuttonspace"]
local anchor = aCoreCDB["ActionbarOptions"]["stancebarinneranchor"]
local mouseover = {
	enable= aCoreCDB["ActionbarOptions"]["stancebarmfade"],
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB["ActionbarOptions"]["stancebarfademinaplha"]},
	}
	
-- FUNCTIONS

local num = NUM_STANCE_SLOTS
local num2 = NUM_POSSESS_SLOTS
local buttonList = {}

--make a frame that fits the size of all microbuttons
local frame = CreateFrame("Frame", "Altz_Stancebar", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["姿态/形态条"]
frame.point = {
		healer = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -14, y = 15},
		dpser = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -14, y = 15},
	}
T.CreateDragFrame(frame)
frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)
frame:SetHeight(buttonssize + 2*padding)

--STANCE BAR
--move the buttons into position and reparent them
StanceBarFrame:SetParent(frame)
StanceBarFrame:EnableMouse(false)

for i=1, num do
	local button = _G["StanceButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(buttonssize, buttonssize)
	button:ClearAllPoints()
	if anchor == "LEFT" then
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, padding, padding)
		else
			local previous = _G["StanceButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
		end
	else
		if i == 1 then
			button:SetPoint("BOTTOMRIGHT", frame, -padding, padding)
		else
			local previous = _G["StanceButton"..i-1]
			button:SetPoint("RIGHT", previous, "LEFT", -buttonspace, 0)
		end
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
		button:SetPoint("BOTTOMRIGHT", frame, -padding, padding)
	else
		local previous = _G["PossessButton"..i-1]
		button:SetPoint("RIGHT", previous, "LEFT", -buttonspace, 0)
	end
end

--hide the frame when in a vehicle!
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

--create the mouseover functionality
if mouseover.enable then
	T.ActionbarFader(frame, buttonList, mouseover.fadeIn, mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
end