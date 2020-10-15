local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()

	F.StripTextures(RaidInfoFrame)
	F.SetBD(RaidInfoFrame)
	F.ReskinCheck(RaidFrameAllAssistCheckButton)
	F.StripTextures(RaidInfoFrame.Header)

	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
	RaidInfoDetailFooter:Hide()
	RaidInfoDetailHeader:Hide()
	RaidInfoDetailCorner:Hide()

	F.Reskin(RaidFrameRaidInfoButton)
	F.Reskin(RaidFrameConvertToRaidButton)
	F.Reskin(RaidInfoExtendButton)
	F.Reskin(RaidInfoCancelButton)
	F.ReskinClose(RaidInfoCloseButton)
	F.ReskinScroll(RaidInfoScrollFrameScrollBar)
	F.ReskinClose(RaidParentFrameCloseButton)

	F.ReskinPortraitFrame(RaidParentFrame)
	RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
end)