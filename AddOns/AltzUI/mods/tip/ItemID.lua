local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

if not aCoreCDB["TooltipOptions"]["showitemID"] or not aCoreCDB["TooltipOptions"]["enabletip"] then return end

GameTooltip:HookScript("OnTooltipSetItem", function(self,...)
	itemName,itemLink = GameTooltip:GetItem()
	if itemLink ~= nil then
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, 
		jewelId4, suffixId, uniqueId, linkLevel, reforgeId = strsplit(":", itemString)
		
		self:AddLine(" ")
		self:AddDoubleLine("ItemID:",format(G.classcolor.."%s|r",itemId))
		self:Show()
	end
end)
