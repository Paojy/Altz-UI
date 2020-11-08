local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_NewPlayerExperienceGuide"] = function()
	local GuideFrame = GuideFrame

	F.ReskinPortraitFrame(GuideFrame)
	GuideFrame.Title:SetTextColor(1, .8, 0)
	GuideFrame.ScrollFrame.Child.Text:SetTextColor(1, 1, 1)
	F.ReskinScroll(GuideFrame.ScrollFrame.ScrollBar)
	F.Reskin(GuideFrame.ScrollFrame.ConfirmationButton)
end