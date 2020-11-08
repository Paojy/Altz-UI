local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_FlightMap"] = function()
	F.ReskinPortraitFrame(FlightMapFrame)
	FlightMapFrameBg:Hide()
	FlightMapFrame.ScrollContainer.Child.TiledBackground:Hide()
end