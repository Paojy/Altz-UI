local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	TaxiFrame:DisableDrawLayer("BORDER")
	TaxiFrame:DisableDrawLayer("OVERLAY")
	TaxiFrame.Bg:Hide()
	TaxiFrame.TitleBg:Hide()
	TaxiFrame.TopTileStreaks:Hide()

	F.SetBD(TaxiFrame, nil, 3, -23, -5, 3)
	F.ReskinClose(TaxiFrame.CloseButton, TaxiRouteMap)
end)