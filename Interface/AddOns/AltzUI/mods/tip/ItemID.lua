local T, C, L, G = unpack(select(2, ...))

if not aCoreCDB["TooltipOptions"]["showitemID"] or not aCoreCDB["TooltipOptions"]["enabletip"] then return end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	itemName,itemLink = GameTooltip:GetItem()
	if itemLink ~= nil then
		local itemString = string.match(itemLink, "item[%-?%d:]+")

		if itemString then
			local _, itemId = strsplit(":", itemString)

			self:AddLine(" ")
			self:AddDoubleLine("ItemID:",format(G.classcolor.."%s|r",itemId))
			self:Show()
		end
	end
end)
