local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_BarbershopUI"] = function()
	local frame = BarberShopFrame

	F.Reskin(frame.AcceptButton)
	F.Reskin(frame.CancelButton)
	F.Reskin(frame.ResetButton)
end

local function ReskinCustomizeButton(button)
	F.Reskin(button)
	button.__bg:SetInside(nil, 3, 3)
end

local function ReskinCustomizeTooltip(tooltip)
	if F.ReskinTooltip then F.ReskinTooltip(tooltip) end
	tooltip:SetScale(UIParent:GetScale())
end

C.themes["Blizzard_CharacterCustomize"] = function()
	local frame = CharCustomizeFrame

	ReskinCustomizeButton(frame.SmallButtons.ResetCameraButton)
	ReskinCustomizeButton(frame.SmallButtons.ZoomOutButton)
	ReskinCustomizeButton(frame.SmallButtons.ZoomInButton)
	ReskinCustomizeButton(frame.SmallButtons.RotateLeftButton)
	ReskinCustomizeButton(frame.SmallButtons.RotateRightButton)

	hooksecurefunc(frame, "SetSelectedCatgory", function(self)
		for button in self.selectionPopoutPool:EnumerateActive() do
			if not button.styled then
				F.ReskinArrow(button.DecrementButton, "left")
				F.ReskinArrow(button.IncrementButton, "right")

				local popoutButton = button.SelectionPopoutButton
				popoutButton.HighlightTexture:SetAlpha(0)
				popoutButton.NormalTexture:SetAlpha(0)
				ReskinCustomizeButton(popoutButton)
				F.StripTextures(popoutButton.Popout)
				local bg = F.SetBD(popoutButton.Popout, 1)
				bg:SetFrameLevel(popoutButton.Popout:GetFrameLevel())

				button.styled = true
			end
		end

		local optionPool = self.pools:GetPool("CharCustomizeOptionCheckButtonTemplate")
		for button in optionPool:EnumerateActive() do
			if not button.styled then
				F.ReskinCheck(button.Button)
				button.styled = true
			end
		end
	end)

	ReskinCustomizeTooltip(CharCustomizeTooltip)
	ReskinCustomizeTooltip(CharCustomizeNoHeaderTooltip)
end