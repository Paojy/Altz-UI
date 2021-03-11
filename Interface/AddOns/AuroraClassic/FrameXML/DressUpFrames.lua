local _, ns = ...
local F, C = unpack(ns)
local r, g, b = C.r, C.g, C.b

tinsert(C.defaultThemes, function()
	-- Dressup Frame

	F.ReskinPortraitFrame(DressUpFrame)
	F.Reskin(DressUpFrameOutfitDropDown.SaveButton)
	F.Reskin(DressUpFrameCancelButton)
	F.Reskin(DressUpFrameResetButton)
	F.StripTextures(DressUpFrameOutfitDropDown)
	F.ReskinDropDown(DressUpFrameOutfitDropDown)
	F.ReskinMinMax(DressUpFrame.MaximizeMinimizeFrame)

	DressUpFrameOutfitDropDown:SetHeight(32)
	DressUpFrameOutfitDropDown.SaveButton:SetPoint("LEFT", DressUpFrameOutfitDropDown, "RIGHT", -13, 2)
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)

	F.ReskinCheck(TransmogAndMountDressupFrame.ShowMountCheckButton)

	-- SideDressUp

	F.StripTextures(SideDressUpFrame, 0)
	F.SetBD(SideDressUpFrame)
	F.Reskin(SideDressUpFrame.ResetButton)
	F.ReskinClose(SideDressUpFrameCloseButton)

	SideDressUpFrame:HookScript("OnShow", function(self)
		SideDressUpFrame:ClearAllPoints()
		SideDressUpFrame:SetPoint("LEFT", self:GetParent(), "RIGHT", 3, 0)
	end)

	-- Outfit frame

	F.StripTextures(WardrobeOutfitFrame)
	F.SetBD(WardrobeOutfitFrame, .7)

	hooksecurefunc(WardrobeOutfitFrame, "Update", function(self)
		for i = 1, C_TransmogCollection.GetNumMaxOutfits() do
			local button = self.Buttons[i]
			if button and button:IsShown() and not button.styled then
				F.ReskinIcon(button.Icon)
				button.Selection:SetColorTexture(1, 1, 1, .25)
				button.Highlight:SetColorTexture(r, g, b, .25)

				button.styled = true
			end
		end
	end)

	F.StripTextures(WardrobeOutfitEditFrame)
	WardrobeOutfitEditFrame.EditBox:DisableDrawLayer("BACKGROUND")
	F.SetBD(WardrobeOutfitEditFrame)
	local bg = F.CreateBDFrame(WardrobeOutfitEditFrame.EditBox, .25, true)
	bg:SetPoint("TOPLEFT", -5, -3)
	bg:SetPoint("BOTTOMRIGHT", 5, 3)
	F.Reskin(WardrobeOutfitEditFrame.AcceptButton)
	F.Reskin(WardrobeOutfitEditFrame.CancelButton)
	F.Reskin(WardrobeOutfitEditFrame.DeleteButton)
end)