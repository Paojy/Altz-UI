local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_AlliedRacesUI"] = function()
	local AlliedRacesFrame = AlliedRacesFrame
	F.ReskinPortraitFrame(AlliedRacesFrame)
	select(2, AlliedRacesFrame.ModelFrame:GetRegions()):Hide()

	local scrollFrame = AlliedRacesFrame.RaceInfoFrame.ScrollFrame
	F.ReskinScroll(scrollFrame.ScrollBar)
	scrollFrame.ScrollBar.ScrollUpBorder:Hide()
	scrollFrame.ScrollBar.ScrollDownBorder:Hide()
	AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)
	scrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
	scrollFrame.Child.RacialTraitsLabel:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function()
		local parent = scrollFrame.Child
		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())

			if bu.Icon and not bu.styled then
				select(3, bu:GetRegions()):Hide()
				F.ReskinIcon(bu.Icon)
				bu.Text:SetTextColor(1, 1, 1)

				bu.styled = true
			end
		end
	end)
end