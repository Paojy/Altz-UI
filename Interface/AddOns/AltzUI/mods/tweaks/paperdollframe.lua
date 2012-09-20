local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

if aCoreCDB.helmcloakbuttons then
	local helm = CreateFrame("CheckButton", "_HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
	helm:SetSize(22, 22)
	helm:SetPoint("BOTTOMLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 5, 0)
	helm:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(helm, "ANCHOR_RIGHT", 0, 0)
		GameTooltip:AddLine(SHOW_HELM)
		GameTooltip:Show() 
	end)
	helm:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	helm:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
	helm:SetScript("OnEvent", function() helm:SetChecked(ShowingHelm()) end)
	
	helm:RegisterEvent("UNIT_MODEL_CHANGED")
	helm:SetToplevel(true)
	F.ReskinCheck(helm)
	
	local cloak = CreateFrame("CheckButton", "_CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
	cloak:SetSize(22, 22)
	cloak:SetPoint("BOTTOMLEFT", CharacterBackSlot, "BOTTOMRIGHT", 5, 0)
	cloak:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(cloak, "ANCHOR_RIGHT", 0, 0)
		GameTooltip:AddLine(SHOW_CLOAK)
		GameTooltip:Show() 
	end)
	cloak:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	cloak:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
	cloak:SetScript("OnEvent", function() cloak:SetChecked(ShowingCloak()) end)
	cloak:RegisterEvent("UNIT_MODEL_CHANGED")
	cloak:SetToplevel(true)

	helm:SetChecked(ShowingHelm())
	cloak:SetChecked(ShowingCloak())
	helm:SetFrameLevel(31)
	cloak:SetFrameLevel(31)
	F.ReskinCheck(cloak)
end

if aCoreCDB.undressbutton then
    local E, Z, N
	local undress = CreateFrame("Button", "_UndressButton", PaperDollFrame, "UIPanelButtonTemplate")
	undress:SetSize(80, 20)
	undress:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 0, -5)
	undress:SetScript("OnClick", function()
	    E = {16,17,1,3,5,6,7,8,9,10}
		Z = {}
		n = Z[1] and #Z+1 or 1
		for i= 0,4 do 
			for j= 1, GetContainerNumSlots(i) do 
				if not GetContainerItemLink(i,j) and E[n] then 
					Z[n]= {i,j}
					PickupInventoryItem(E[n])
					PickupContainerItem(i,j)
					n= n + 1
				end
			end
		end
	end)
	F.Reskin(undress)
	undress.t = T.createtext(undress, "OVERLAY", 12, "OUTLINE", "CENTER")
	undress.t:SetPoint("CENTER")
	undress.t:SetText(L["undress"])
end