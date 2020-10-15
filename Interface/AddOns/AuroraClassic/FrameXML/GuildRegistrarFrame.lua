local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()

	GuildRegistrarFrameEditBox:SetHeight(20)
	AvailableServicesText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetShadowColor(0, 0, 0)

	F.ReskinPortraitFrame(GuildRegistrarFrame)
	GuildRegistrarFrameEditBox:DisableDrawLayer("BACKGROUND")
	F.CreateBDFrame(GuildRegistrarFrameEditBox, .25)
	F.Reskin(GuildRegistrarFrameGoodbyeButton)
	F.Reskin(GuildRegistrarFramePurchaseButton)
	F.Reskin(GuildRegistrarFrameCancelButton)
end)