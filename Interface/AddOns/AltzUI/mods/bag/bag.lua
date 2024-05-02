local T, C, L, G = unpack(select(2, ...))

for i = 1, 13 do
	for k = 1, 36 do
		local button = _G["ContainerFrame"..i.."Item"..k]
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