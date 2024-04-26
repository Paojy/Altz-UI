local T, C, L, G = unpack(select(2, ...))

local E, Z, N
local undress = CreateFrame("Button", "_UndressButton", PaperDollFrame, "UIPanelButtonTemplate")
undress:SetSize(80, 20)
undress:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 0, -5)
undress:SetScript("OnClick", function()
	if InCombatLockdown() then return end
    E = {16,17,1,3,5,6,7,8,9,10}
	Z = {}
	n = Z[1] and #Z+1 or 1
	for i= 0,4 do 
		for j= 1, C_Container.GetContainerNumSlots(i) do 
			if not C_Container.GetContainerItemLink(i,j) and E[n] then 
				Z[n]= {i,j}
				PickupInventoryItem(E[n])
				PickupContainerItem(i,j)
				n= n + 1
			end
		end
	end
end)

T.ReskinButton(undress)
undress.Text:SetText(L["脱装备"])
