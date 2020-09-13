local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(AddonList)
	F.Reskin(AddonListEnableAllButton)
	F.Reskin(AddonListDisableAllButton)
	F.Reskin(AddonListCancelButton)
	F.Reskin(AddonListOkayButton)
	F.ReskinCheck(AddonListForceLoad)
	F.ReskinDropDown(AddonCharacterDropDown)
	F.ReskinScroll(AddonListScrollFrameScrollBar)

	AddonListForceLoad:SetSize(26, 26)
	AddonCharacterDropDown:SetWidth(170)

	for i = 1, MAX_ADDONS_DISPLAYED do
		local checkbox = _G["AddonListEntry"..i.."Enabled"]
		F.ReskinCheck(checkbox, true)
		F.Reskin(_G["AddonListEntry"..i.."Load"])
	end

	hooksecurefunc("TriStateCheckbox_SetState", function(_, checkButton)
		if checkButton.forceSaturation then
			local tex = checkButton:GetCheckedTexture()
			if checkButton.state == 2 then
				tex:SetDesaturated(true)
				tex:SetVertexColor(r, g, b)
			elseif checkButton.state == 1 then
				tex:SetVertexColor(1, .8, 0, .8)
			end
		end
	end)
end)