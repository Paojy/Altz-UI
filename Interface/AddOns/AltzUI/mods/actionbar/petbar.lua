local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local scale = aCoreCDB.petbarscale
local petbuttonssize = 33
local buttonspace = aCoreCDB.petbuttonspace
local padding = 4
local uselayout5x2 = aCoreCDB.petbaruselayout5x2
local mouseover = {
	enable= aCoreCDB.petbarmfade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 0.4, alpha = aCoreCDB.petbarfademinaplha},
	}
local eventfader= {
	enable= aCoreCDB.petbarefade,
	fadeIn= {time = 0.4, alpha = 1},
	fadeOut = {time = 1.5, alpha = aCoreCDB.petbarfademinaplha},
	}

-- FUNCTIONS

local num = NUM_PET_ACTION_SLOTS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_Petbar", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["Petbar"]
if not uselayout5x2 then
	frame:SetWidth(num*petbuttonssize + (num-1)*buttonspace + 2*padding)
	frame:SetHeight(petbuttonssize + 2*padding)
else
	frame:SetWidth(num/2*petbuttonssize + (num/2-1)*buttonspace + 2*padding)
	frame:SetHeight(2*petbuttonssize + buttonspace + 2*padding)
end
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 115)
frame:SetScale(scale)

--move the buttons into position and reparent them
PetActionBarFrame:SetParent(frame)
PetActionBarFrame:EnableMouse(false)

for i=1, num do
	local button = _G["PetActionButton"..i]
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(petbuttonssize, petbuttonssize)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("TOPLEFT", frame, padding, -padding)
	elseif uselayout5x2 and i == 6 then
		button:SetPoint("TOP", "PetActionButton1", "BOTTOM", 0, -buttonspace)
	else
		local previous = _G["PetActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
	end
	--cooldown fix
	local cd = _G["PetActionButton"..i.."Cooldown"]
	cd:SetAllPoints(button)
end

--hide the frame when in a vehicle!
RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; [@pet,exists,nodead] show; hide")

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