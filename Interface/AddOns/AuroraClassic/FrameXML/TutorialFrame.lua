local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	F.SetBD(TutorialFrame)

	TutorialFrameBackground:Hide()
	TutorialFrameBackground.Show = F.Dummy
	TutorialFrame:DisableDrawLayer("BORDER")

	F.Reskin(TutorialFrameOkayButton, true)
	F.ReskinClose(TutorialFrameCloseButton)
	F.ReskinArrow(TutorialFramePrevButton, "left")
	F.ReskinArrow(TutorialFrameNextButton, "right")

	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)

	TutorialFramePrevButton:SetScript("OnEnter", nil)
	TutorialFrameNextButton:SetScript("OnEnter", nil)
	TutorialFrameOkayButton.__bg:SetBackdropColor(0, 0, 0, .25)
	TutorialFramePrevButton.__bg:SetBackdropColor(0, 0, 0, .25)
	TutorialFrameNextButton.__bg:SetBackdropColor(0, 0, 0, .25)
end)