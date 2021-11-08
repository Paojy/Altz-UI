local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	local styled

	InterfaceOptionsFrame:HookScript("OnShow", function()
		if styled then return end

		F.StripTextures(InterfaceOptionsFrameTab1)
		F.StripTextures(InterfaceOptionsFrameTab2)
		F.StripTextures(InterfaceOptionsFrameCategories)
		F.StripTextures(InterfaceOptionsFramePanelContainer)
		F.StripTextures(InterfaceOptionsFrameAddOns)

		F.SetBD(InterfaceOptionsFrame)
		InterfaceOptionsFrame.Border:Hide()
		F.StripTextures(InterfaceOptionsFrame.Header)
		InterfaceOptionsFrame.Header:ClearAllPoints()
		InterfaceOptionsFrame.Header:SetPoint("TOP", InterfaceOptionsFrame, 0, 0)

		F.Reskin(InterfaceOptionsFrameDefaults)
		F.Reskin(InterfaceOptionsFrameOkay)
		F.Reskin(InterfaceOptionsFrameCancel)

		if CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG then
			CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()
		end

		local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
		line:SetSize(C.mult, 546)
		line:SetPoint("LEFT", 205, 10)
		line:SetColorTexture(1, 1, 1, .25)

		local interfacePanels = {
			"InterfaceOptionsControlsPanel",
			"InterfaceOptionsCombatPanel",
			"InterfaceOptionsDisplayPanel",
			"InterfaceOptionsSocialPanel",
			"InterfaceOptionsActionBarsPanel",
			"InterfaceOptionsNamesPanel",
			"InterfaceOptionsNamesPanelFriendly",
			"InterfaceOptionsNamesPanelEnemy",
			"InterfaceOptionsNamesPanelUnitNameplates",
			"InterfaceOptionsCameraPanel",
			"InterfaceOptionsMousePanel",
			"InterfaceOptionsAccessibilityPanel",
			"InterfaceOptionsColorblindPanel",
			"CompactUnitFrameProfiles",
			"CompactUnitFrameProfilesGeneralOptionsFrame",
		}
		for _, name in pairs(interfacePanels) do
			local frame = _G[name]
			if frame then
				for i = 1, frame:GetNumChildren() do
					local child = select(i, frame:GetChildren())
					if child:IsObjectType("CheckButton") then
						F.ReskinCheck(child)
					elseif child:IsObjectType("Button") then
						F.Reskin(child)
					elseif child:IsObjectType("Slider") then
						F.ReskinSlider(child)
					elseif child:IsObjectType("Frame") and child.Left and child.Middle and child.Right then
						F.ReskinDropDown(child)
					end
				end
			end
		end

		styled = true
	end)

	hooksecurefunc("InterfaceOptions_AddCategory", function()
		for i = 1, #INTERFACEOPTIONS_ADDONCATEGORIES do
			local bu = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
			if bu and not bu.styled then
				F.ReskinCollapse(bu)
				bu:GetPushedTexture():SetAlpha(0)

				bu.styled = true
			end
		end
	end)
end)