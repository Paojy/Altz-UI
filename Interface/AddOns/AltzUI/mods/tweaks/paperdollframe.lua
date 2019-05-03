local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

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
	undress.t:SetText(L["脱装备"])
