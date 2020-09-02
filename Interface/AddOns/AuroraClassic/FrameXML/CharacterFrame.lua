local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(CharacterFrame)
	F.StripTextures(CharacterFrameInsetRight)

	for i = 1, 3 do
		F.ReskinTab(_G["CharacterFrameTab"..i])
	end

	CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	CharacterModelFrame:DisableDrawLayer("BORDER")
	CharacterModelFrame:DisableDrawLayer("OVERLAY")

	-- [[ Item buttons ]]

	local function colourPopout(self)
		local aR, aG, aB
		local glow = self:GetParent().IconBorder

		if glow:IsShown() then
			aR, aG, aB = glow:GetVertexColor()
		else
			aR, aG, aB = r, g, b
		end

		self.arrow:SetVertexColor(aR, aG, aB)
	end

	local function clearPopout(self)
		self.arrow:SetVertexColor(1, 1, 1)
	end

	local function UpdateAzeriteItem(self)
		if not self.styled then
			self.AzeriteTexture:SetAlpha(0)
			self.RankFrame.Texture:SetTexture("")
			self.RankFrame.Label:ClearAllPoints()
			self.RankFrame.Label:SetPoint("TOPLEFT", self, 2, -1)
			self.RankFrame.Label:SetTextColor(1, .5, 0)

			self.styled = true
		end
	end

	local function UpdateAzeriteEmpoweredItem(self)
		self.AzeriteTexture:SetAtlas("AzeriteIconFrame")
		self.AzeriteTexture:SetInside()
		self.AzeriteTexture:SetDrawLayer("BORDER", 1)
	end

	local function UpdateCorruption(self)
		local itemLink = GetInventoryItemLink("player", self:GetID())
		self.IconOverlay:SetShown(itemLink and IsCorruptedItem(itemLink))
	end

	local function UpdateHighlight(self)
		local highlight = self:GetHighlightTexture()
		highlight:SetColorTexture(1, 1, 1, .25)
		highlight:SetInside()
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local cooldown = _G["Character"..slots[i].."SlotCooldown"]

		F.StripTextures(slot)
		slot.icon:SetTexCoord(.08, .92, .08, .92)
		slot.icon:SetInside()
		slot.bg = F.CreateBDFrame(slot.icon, .25)
		cooldown:SetInside()

		slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")
		slot.CorruptedHighlightTexture:SetAtlas("Nzoth-charactersheet-item-glow")
		slot.IconOverlay:SetAtlas("Nzoth-inventory-icon")
		slot.IconOverlay:SetInside()
		F.HookIconBorderColor(slot.IconBorder)

		local popout = slot.popoutButton
		popout:SetNormalTexture("")
		popout:SetHighlightTexture("")

		local arrow = popout:CreateTexture(nil, "OVERLAY")
		arrow:SetSize(14, 14)
		if slot.verticalFlyout then
			F.SetupArrow(arrow, "down")
			arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			F.SetupArrow(arrow, "right")
			arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end
		popout.arrow = arrow

		popout:HookScript("OnEnter", clearPopout)
		popout:HookScript("OnLeave", colourPopout)

		hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
		hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		-- also fires for bag slots, we don't want that
		if button.popoutButton then
			button.icon:SetShown(GetInventoryItemTexture("player", button:GetID()) ~= nil)
			colourPopout(button.popoutButton)
		end
		UpdateCorruption(button)
		UpdateHighlight(button)
	end)

	-- [[ Stats pane ]]

	local pane = CharacterStatsPane
	pane.ClassBackground:Hide()
	pane.ItemLevelFrame.Corruption:SetPoint("RIGHT", 22, -8)

	local categories = {pane.ItemLevelCategory, pane.AttributesCategory, pane.EnhancementsCategory}
	for _, category in pairs(categories) do
		category.Background:Hide()
		category.Title:SetTextColor(r, g, b)
		local line = category:CreateTexture(nil, "ARTWORK")
		line:SetSize(180, C.mult)
		line:SetPoint("BOTTOM", 0, 5)
		line:SetColorTexture(1, 1, 1, .25)
	end

	-- [[ Sidebar tabs ]]

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if i == 1 then
			for i = 1, 4 do
				local region = select(i, tab:GetRegions())
				region:SetTexCoord(.16, .86, .16, .86)
				region.SetTexCoord = F.dummy
			end
		end

		tab.bg = F.CreateBDFrame(tab)
		tab.bg:SetPoint("TOPLEFT", 2, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", 0, -2)

		tab.Icon:SetInside(tab.bg)
		tab.Hider:SetInside(tab.bg)
		tab.Highlight:SetInside(tab.bg)
		tab.Highlight:SetColorTexture(1, 1, 1, .25)
		tab.Hider:SetColorTexture(.3, .3, .3, .4)
		tab.TabBg:SetAlpha(0)
	end

	-- [[ Equipment manager ]]

	F.StripTextures(GearManagerDialogPopup.BorderBox)
	GearManagerDialogPopup.BG:Hide()
	F.CreateBD(GearManagerDialogPopup)
	F.CreateSD(GearManagerDialogPopup)
	GearManagerDialogPopup:SetHeight(525)
	F.StripTextures(GearManagerDialogPopupScrollFrame)
	F.ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	F.Reskin(GearManagerDialogPopupOkay)
	F.Reskin(GearManagerDialogPopupCancel)
	F.ReskinInput(GearManagerDialogPopupEditBox)
	F.ReskinScroll(PaperDollTitlesPaneScrollBar)
	F.ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)
	F.StripTextures(PaperDollSidebarTabs)
	F.Reskin(PaperDollEquipmentManagerPaneEquipSet)
	F.Reskin(PaperDollEquipmentManagerPaneSaveSet)

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local bu = _G["GearManagerDialogPopupButton"..i]
		local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

		bu:SetCheckedTexture(C.media.checked)
		select(2, bu:GetRegions()):Hide()
		local hl = bu:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetAllPoints(ic)

		ic:SetInside()
		ic:SetTexCoord(.08, .92, .08, .92)
		F.CreateBD(bu, .25)
	end

	for _, bu in pairs(PaperDollEquipmentManagerPane.buttons) do
		F.HideObject(bu.Stripe)
		bu.BgTop:SetTexture("")
		bu.BgMiddle:SetTexture("")
		bu.BgBottom:SetTexture("")
		F.ReskinIcon(bu.icon)

		bu.HighlightBar:SetColorTexture(1, 1, 1, .25)
		bu.HighlightBar:SetDrawLayer("BACKGROUND")
		bu.SelectedBar:SetColorTexture(r, g, b, .25)
		bu.SelectedBar:SetDrawLayer("BACKGROUND")
	end

	local titles = false
	hooksecurefunc("PaperDollTitlesPane_Update", function()
		if titles == false then
			for i = 1, 17 do
				_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
			end
			titles = true
		end
	end)

	PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
	GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 1, 0)
end)