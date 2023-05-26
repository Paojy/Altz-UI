local T, C, L, G = unpack(select(2, ...))

local MAX_CONTAINER_ITEMS = 36

for i = 1, 13 do
	local frameName = "ContainerFrame"..i
	
	for k = 1, MAX_CONTAINER_ITEMS do
		local button = _G[frameName.."Item"..k]
		button.emptyBackgroundTexture = G.media.blank
		hooksecurefunc(button, "SetItemButtonTexture", function(self, texture)
			local icon = self.Icon or self.icon or _G[self:GetName().."IconTexture"]
			if not texture then
				icon:SetAlpha(.05)
			else
				icon:SetAlpha(1)
			end
		end)
	end
end