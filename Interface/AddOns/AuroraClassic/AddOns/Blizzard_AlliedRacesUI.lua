local _, ns = ...
local B, C, L, DB = unpack(ns)

C.themes["Blizzard_AlliedRacesUI"] = function()
	local AlliedRacesFrame = AlliedRacesFrame
	B.ReskinPortraitFrame(AlliedRacesFrame)
	select(2, AlliedRacesFrame.ModelScene:GetRegions()):Hide()

	local scrollFrame = AlliedRacesFrame.RaceInfoFrame.ScrollFrame
	B.ReskinTrimScroll(scrollFrame.ScrollBar)
	AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)
	scrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
	scrollFrame.Child.RacialTraitsLabel:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function()
		local parent = scrollFrame.Child
		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())

			if bu.Icon and not bu.styled then
				select(3, bu:GetRegions()):Hide()
				B.ReskinIcon(bu.Icon)
				bu.Text:SetTextColor(1, 1, 1)

				bu.styled = true
			end
		end
	end)
end