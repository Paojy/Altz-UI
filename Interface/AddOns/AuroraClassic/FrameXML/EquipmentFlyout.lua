local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	EquipmentFlyoutFrameHighlight:Hide()

	local border = F.CreateBDFrame(EquipmentFlyoutFrame, 0)
	border:SetBackdropBorderColor(1, 1, 1)
	border:SetPoint("TOPLEFT", 2, -2)
	border:SetPoint("BOTTOMRIGHT", -2, 2)

	local navFrame = EquipmentFlyoutFrame.NavigationFrame

	EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
	EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
	Test2:Hide() -- wat

	navFrame:SetWidth(204)
	navFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 1, 0)

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local button = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]

		button.icon:SetTexCoord(.08, .92, .08, .92)
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button.bg = F.CreateBDFrame(button)
		F.HookIconBorderColor(button.IconBorder)

		if not button.Eye then
			button.Eye = button:CreateTexture()
			button.Eye:SetAtlas("Nzoth-inventory-icon")
			button.Eye:SetInside()
		end
	end)

	local function UpdateCorruption(button, location)
		local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
		if voidStorage then
			button.Eye:Hide()
			return
		end

		local itemLink
		if bags then
			itemLink = GetContainerItemLink(bag, slot)
		else
			itemLink = GetInventoryItemLink("player", slot)
		end
		button.Eye:SetShown(itemLink and IsCorruptedItem(itemLink))
	end

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		local border = button.IconBorder
		if not location or not border then return end

		if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
			border:Hide()
		else
			border:Show()
		end

		UpdateCorruption(button, location)
	end)

	local function reskinButtonFrame()
		local frame = EquipmentFlyoutFrame.buttonFrame
		if not frame.bg then
			frame.bg = F.SetBD(EquipmentFlyoutFrame.buttonFrame)
		end
		frame:SetWidth(frame:GetWidth()+3)
	end
	hooksecurefunc("EquipmentFlyout_UpdateItems", reskinButtonFrame)

	local navigationFrame = EquipmentFlyoutFrame.NavigationFrame
	F.SetBD(navigationFrame)
	navigationFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 0, -3)
	navigationFrame:SetPoint("TOPRIGHT", EquipmentFlyoutFrameButtons, "BOTTOMRIGHT", 0, -3)
	F.ReskinArrow(navigationFrame.PrevButton, "left")
	F.ReskinArrow(navigationFrame.NextButton, "right")
end)