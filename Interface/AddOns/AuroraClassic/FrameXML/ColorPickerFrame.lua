local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(ColorPickerFrame.Header)
	ColorPickerFrame.Header:ClearAllPoints()
	ColorPickerFrame.Header:SetPoint("TOP", ColorPickerFrame, 0, 0)
	ColorPickerFrame.Border:Hide()

	F.CreateBD(ColorPickerFrame)
	F.CreateSD(ColorPickerFrame)
	F.Reskin(ColorPickerOkayButton)
	F.Reskin(ColorPickerCancelButton)
	F.ReskinSlider(OpacitySliderFrame, true)
end)