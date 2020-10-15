local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	local cr, cg, cb = C.r, C.g, C.b

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

	hooksecurefunc("AddonList_Update", function()
		for i = 1, MAX_ADDONS_DISPLAYED do
			local entry = _G["AddonListEntry"..i]
			if entry and entry:IsShown() then
				local checkbox = _G["AddonListEntry"..i.."Enabled"]
				if checkbox.forceSaturation then
					local tex = checkbox:GetCheckedTexture()
					if checkbox.state == 2 then
						tex:SetDesaturated(true)
						tex:SetVertexColor(cr, cg, cb)
					elseif checkbox.state == 1 then
						tex:SetVertexColor(1, .8, 0, .8)
					end
				end
			end
		end
	end)
end)