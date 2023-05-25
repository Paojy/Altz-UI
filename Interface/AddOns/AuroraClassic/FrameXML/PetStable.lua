local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	if DB.MyClass ~= "HUNTER" then return end

	PetStableBottomInset:Hide()
	PetStableLeftInset:Hide()
	PetStableModelShadow:Hide()
	PetStableModelRotateLeftButton:Hide()
	PetStableModelRotateRightButton:Hide()
	PetStableFrameModelBg:Hide()
	PetStablePrevPageButtonIcon:SetTexture("")
	PetStableNextPageButtonIcon:SetTexture("")

	B.ReskinPortraitFrame(PetStableFrame)
	B.ReskinArrow(PetStablePrevPageButton, "left")
	B.ReskinArrow(PetStableNextPageButton, "right")
	B.ReskinIcon(PetStableSelectedPetIcon)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		local bu = _G["PetStableActivePet"..i]
		bu.Background:Hide()
		bu.Border:Hide()
		bu:SetNormalTexture(0)
		bu:SetPushedTexture(0)
		bu.Checked:SetTexture(DB.pushedTex)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(unpack(DB.TexCoord))
		B.CreateBDFrame(bu, .25)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		local bu = _G["PetStableStabledPet"..i]
		bu:SetNormalTexture(0)
		bu:SetPushedTexture(0)
		bu.Checked:SetTexture(DB.pushedTex)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:DisableDrawLayer("BACKGROUND")

		_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(unpack(DB.TexCoord))
		B.CreateBDFrame(bu, .25)
	end
end)