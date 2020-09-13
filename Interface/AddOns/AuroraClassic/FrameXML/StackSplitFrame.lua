local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local StackSplitFrame = StackSplitFrame

	F.StripTextures(StackSplitFrame)
	F.CreateBD(StackSplitFrame)
	F.CreateSD(StackSplitFrame)
	F.Reskin(StackSplitFrame.OkayButton)
	F.Reskin(StackSplitFrame.CancelButton)
	F.ReskinArrow(StackSplitFrame.LeftButton, "left")
	F.ReskinArrow(StackSplitFrame.RightButton, "right")
end)