local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	B.Reskin(SplashFrame.BottomCloseButton)
	B.ReskinClose(SplashFrame.TopCloseButton, SplashFrame, -18, -18)
	SplashFrame.Label:SetTextColor(1, .8, 0)
end)