local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_TorghastLevelPicker"] = function()
	local frame = TorghastLevelPickerFrame

	F.ReskinClose(frame.CloseButton, frame, -60, -60)
	F.Reskin(frame.OpenPortalButton)
	F.ReskinArrow(frame.Pager.PreviousPage, "left")
	F.ReskinArrow(frame.Pager.NextPage, "right")
end