local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	F.ReskinPortraitFrame(TabardFrame)
	TabardFrameMoneyInset:Hide()
	TabardFrameMoneyBg:Hide()
	F.CreateBDFrame(TabardFrameCostFrame, .25)
	F.Reskin(TabardFrameAcceptButton)
	F.Reskin(TabardFrameCancelButton)
	F.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
	F.ReskinArrow(TabardCharacterModelRotateRightButton, "right")
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

	TabardFrameCustomizationBorder:Hide()
	for i = 1, 5 do
		F.StripTextures(_G["TabardFrameCustomization"..i])
		F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
		F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
	end
end)