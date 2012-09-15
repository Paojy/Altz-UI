
---------------------------------------------------------------
-------------------[[        media        ]]------------------
---------------------------------------------------------------

---------------------------------------------------------------
--------------[[     global frame fuctions    ]]---------------
---------------------------------------------------------------


function createskinpxBD(f)
--[[
	if f.skinpxborder == true then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetBackdrop(frame1pxBD)
    border:SetBackdropColor(0, 0, 0, 0)
    border:SetBackdropBorderColor(0, 0, 0, 1)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.skinpxborder = true
		]]--
end

function createskingrowBD(f)
--[[
	if f.skinborder == true then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -3, 3)
	border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(0, 0, 0, 0.7)
    border:SetBackdropBorderColor(0, 0, 0, 1)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.skinborder = true
	]]--
end

