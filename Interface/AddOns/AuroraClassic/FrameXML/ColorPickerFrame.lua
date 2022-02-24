local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()

	F.StripTextures(ColorPickerFrame.Header)
	ColorPickerFrame.Header:ClearAllPoints()
	ColorPickerFrame.Header:SetPoint("TOP", ColorPickerFrame, 0, 10)
	ColorPickerFrame.Border:Hide()

	F.SetBD(ColorPickerFrame)
	F.Reskin(ColorPickerOkayButton)
	F.Reskin(ColorPickerCancelButton)
	F.ReskinSlider(OpacitySliderFrame, true)

	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 6)
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 6)
end)