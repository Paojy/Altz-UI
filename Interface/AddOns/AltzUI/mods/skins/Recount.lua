local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
if not IsAddOnLoaded("Recount") or not aCoreCDB["SkinOptions"]["setRecount"] then return end

local _G = _G
local Recount = _G["Recount"]

local function skinit(window)
	F.SetBD(window, 0, -12, 0, 0) 
	window:SetBackdropBorderColor(0, 0, 0, 0)
	window:SetBackdropColor(0, 0, 0, 0)
	
	F.ReskinClose(window.CloseButton)
	window.CloseButton:ClearAllPoints()
	window.CloseButton:SetPoint("TOPRIGHT",window,"TOPRIGHT", -4, 10)
	window.CloseButton:SetSize(14, 14)
end

Recount.CreateFrame_ = Recount.CreateFrame
function Recount:CreateFrame(Name, Title, Height, Width, ShowFunc, HideFunc)
	local frame = self:CreateFrame_(Name, Title, Height, Width, ShowFunc, HideFunc)
	skinit(frame)
	return frame
end

Recount.ShowReport_ = Recount.ShowReport
function Recount:ShowReport(Title,ReportFunc)
	self:ShowReport_(Title,ReportFunc)
	if not _G["Recount_ReportWindow"].skined then
	F.ReskinSlider(_G["Recount_ReportWindow"].slider)
	F.Reskin(_G["Recount_ReportWindow"].ReportButton)
	_G["Recount_ReportWindow"].skined = true
	end

end

windows = {
Recount.MainWindow,
Recount.DetailWindow,
	}

local function skinbutton(button, text, ...)
	button:ClearAllPoints()
	button:SetPoint(...)
	button:SetSize(14, 14)	
	F.Reskin(button)

	button.text = T.createtext(button, "OVERALY", 11, "OUTLINE", "RIGHT")
	button.text:SetAllPoints()
	button.text:SetText(text)
end

for i = 1, #windows do
	skinit(windows[i])
	
	windows[i].RightButton:ClearAllPoints()
	windows[i].RightButton:SetPoint("RIGHT", windows[i].CloseButton,"LEFT", -5, 0)	
	windows[i].LeftButton:ClearAllPoints()
	windows[i].LeftButton:SetPoint("RIGHT", windows[i].RightButton,"LEFT", -5, 0)
	
	F.ReskinArrow(windows[i].RightButton, "right")
	F.ReskinArrow(windows[i].LeftButton, "left")
	
	windows[i].RightButton:SetSize(14, 14)
	windows[i].LeftButton:SetSize(14, 14)
	
	if windows[i] == Recount.MainWindow then
		skinbutton(windows[i].ResetButton, "D", "RIGHT", windows[i].LeftButton,"LEFT", -5, 0)	
		skinbutton(windows[i].FileButton, "F", "RIGHT", windows[i].ResetButton,"LEFT", -5, 0)
		skinbutton(windows[i].ConfigButton, "C", "RIGHT", windows[i].FileButton,"LEFT", -5, 0)
		skinbutton(windows[i].ReportButton, "R", "RIGHT", windows[i].ConfigButton,"LEFT", -5, 0)
	else
		skinbutton(windows[i].ReportButton, "R", "RIGHT", windows[i].LeftButton,"LEFT", -5, 0)
		skinbutton(windows[i].SummaryButton, "S", "RIGHT", windows[i].ReportButton,"LEFT", -5, 0)
	end
end