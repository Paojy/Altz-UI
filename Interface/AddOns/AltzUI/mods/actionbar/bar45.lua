local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local growUp = aCoreCDB["ActionbarOptions"]["growup"]
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
	
local Horizontalbar45 = aCoreCDB["ActionbarOptions"]["Horizontalbar45"]
local layout6x4 = aCoreCDB["ActionbarOptions"]["bar45uselayout64"]
-- FUNCTIONS

local num = NUM_ACTIONBAR_BUTTONS
local buttonList = {}

--create the frame to hold the buttons
local frame = CreateFrame("Frame", "Altz_Bar4&5", UIParent, "SecureHandlerStateTemplate")
frame.movingname = L["右侧额外动作条"]
frame.point = {
	healer = {a1 = "RIGHT", parent = "UIParent", a2 = "RIGHT", x = -14, y = 0},
	dpser = {a1 = "RIGHT", parent = "UIParent", a2 = "RIGHT", x = -14, y = 0},
}
T.CreateDragFrame(frame)

--move the buttons into position and reparent them
MultiBarRight:SetParent(frame)
MultiBarRight:EnableMouse(false)
MultiBarLeft:SetParent(frame)
MultiBarLeft:EnableMouse(false)

if Horizontalbar45 then
	if layout6x4 then
		frame:SetWidth(6*buttonssize + (6-1)*buttonspace + 2*padding)
		frame:SetHeight(4*buttonssize + (4-1)*buttonspace + 2*padding)

		for i=1, num do
			local button = _G["MultiBarRightButton"..i]
			table.insert(buttonList, button) --add the button object to the list
			button:SetSize(buttonssize, buttonssize)
			button:ClearAllPoints()
			if growUp then
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", frame, padding, padding)
				elseif  i == 7 then
					button:SetPoint("BOTTOMLEFT", "MultiBarRightButton1", "TOPLEFT", 0, buttonspace)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			else
				if i == 1 then
					button:SetPoint("TOPLEFT", frame, padding, -padding)
				elseif  i == 7 then
					button:SetPoint("TOPLEFT", "MultiBarRightButton1", "BOTTOMLEFT", 0, -buttonspace)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			end
		end
		
		for i=1, num do
			local button = _G["MultiBarLeftButton"..i]
			table.insert(buttonList, button) --add the button object to the list
			button:SetSize(buttonssize, buttonssize)
			button:ClearAllPoints()
			if growUp then
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", "MultiBarRightButton7", "TOPLEFT", 0, buttonspace)
				elseif  i == 7 then
					button:SetPoint("BOTTOMLEFT", "MultiBarLeftButton1", "TOPLEFT", 0, buttonspace)
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			else
				if i == 1 then
					button:SetPoint("TOPLEFT", "MultiBarRightButton7", "BOTTOMLEFT", 0, -buttonspace)
				elseif  i == 7 then
					button:SetPoint("TOPLEFT", "MultiBarLeftButton1", "BOTTOMLEFT", 0, -buttonspace)
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			end
		end
	else
		frame:SetHeight(2*buttonssize + (2-1)*buttonspace + 2*padding)
		frame:SetWidth(num*buttonssize + (num-1)*buttonspace + 2*padding)

		for i=1, num do
			local button = _G["MultiBarRightButton"..i]
			table.insert(buttonList, button) --add the button object to the list
			button:SetSize(buttonssize, buttonssize)
			button:ClearAllPoints()
			if growUp then
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", frame, padding, padding)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			else
				if i == 1 then
					button:SetPoint("TOPLEFT", frame, padding, -padding)
				else
					local previous = _G["MultiBarRightButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			end
		end

		for i=1, num do
			local button = _G["MultiBarLeftButton"..i]
			table.insert(buttonList, button) --add the button object to the list
			button:SetSize(buttonssize, buttonssize)
			button:ClearAllPoints()
			if growUp then
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", frame, padding, (padding+buttonspace+buttonssize))
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			else
				if i == 1 then
					button:SetPoint("TOPLEFT", frame, padding, -(padding+buttonspace+buttonssize))
				else
					local previous = _G["MultiBarLeftButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", buttonspace, 0)
				end
			end
		end
	end
elseif layout6x4 then
		frame:SetWidth(4*buttonssize + (4-1)*buttonspace + 2*padding)
		frame:SetHeight(6*buttonssize + (6-1)*buttonspace + 2*padding)
			
		for i=1, num do
			local button = _G["MultiBarRightButton"..i]
			table.insert(buttonList, button) --add the button object to the list
			button:SetSize(buttonssize, buttonssize)
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("TOPLEFT", frame, padding, -padding)
			elseif i == 7 then
				button:SetPoint("TOPLEFT", "MultiBarRightButton1", "TOPRIGHT", buttonspace, 0)
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
				button:SetPoint("TOPLEFT", "MultiBarRightButton7", "TOPRIGHT", buttonspace, 0)
			elseif i == 7 then
				button:SetPoint("TOPLEFT", "MultiBarLeftButton1", "TOPRIGHT", buttonspace, 0)
			else
				local previous = _G["MultiBarLeftButton"..i-1]
				button:SetPoint("TOP", previous, "BOTTOM", 0, -buttonspace)
			end
		end
else
		frame:SetWidth(2*buttonssize + (2-1)*buttonspace + 2*padding)
		frame:SetHeight(num*buttonssize + (num-1)*buttonspace + 2*padding)

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