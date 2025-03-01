local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinPortraitFrame(AddonList)
	B.Reskin(AddonList.EnableAllButton)
	B.Reskin(AddonList.DisableAllButton)
	B.Reskin(AddonList.CancelButton)
	B.Reskin(AddonList.OkayButton)
	B.ReskinCheck(AddonList.ForceLoad)
	B.ReskinDropDown(AddonList.Dropdown)
	B.ReskinTrimScroll(AddonList.ScrollBar)

	AddonList.ForceLoad:SetSize(26, 26)

	local function forceSaturation(self, _, force)
		if force then return end
		self:SetVertexColor(cr, cg, cb)
		self:SetDesaturated(true, true)
	end

	--hooksecurefunc("AddonList_InitButton", function(entry)
	--	if not entry.styled then
	--		B.ReskinCheck(entry.Enabled, true)
	--		B.Reskin(entry.LoadAddonButton)
	--		hooksecurefunc(entry.Enabled:GetCheckedTexture(), "SetDesaturated", forceSaturation)
	--
	--		B.ReplaceIconString(entry.Title)
	--		hooksecurefunc(entry.Title, "SetText", B.ReplaceIconString)
	--
	--		entry.styled = true
	--	end
	--end)
end)