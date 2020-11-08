local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_ObliterumUI"] = function()
	local obliterum = ObliterumForgeFrame

	F.ReskinPortraitFrame(obliterum)
	F.Reskin(obliterum.ObliterateButton)
	F.ReskinIcon(obliterum.ItemSlot.Icon)
end