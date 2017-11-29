local T, C, L, G = unpack(select(2, ...))

if not aCoreCDB["TooltipOptions"]["showitemID"] or not aCoreCDB["TooltipOptions"]["enabletip"] then return end

local strmatch = string.match
local format = format
local strsplit = strsplit

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: GameTooltip

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local _,itemLink = GameTooltip:GetItem()
	if itemLink ~= nil then
		local itemString = strmatch(itemLink, "item[%-?%d:]+")

		if itemString then
			local _, itemId = strsplit(":", itemString)

			self:AddLine(" ")
			self:AddDoubleLine("ItemID:",format(G.classcolor.."%s|r",itemId))
			self:Show()
		end
	end
end)
