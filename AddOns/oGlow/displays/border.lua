local _, ns = ...
local oGlow = ns.oGlow

local argcheck = oGlow.argcheck
local colorTable = ns.colorTable

local createBorder = function(self, point)
	local bc = self.oGlowBorder
	if(not bc) then
		if(not self:IsObjectType'Frame') then
			bc = self:GetParent():CreateTexture(nil, 'BACKGROUND')
		else
			bc = self:CreateTexture(nil, "BACKGROUND")
		end

		bc:SetTexture"Interface\\Buttons\\WHITE8x8"
		--bc:SetBlendMode"ADD"
		--bc:SetAlpha(.8)

		bc:SetPoint("TOPLEFT", point or self, -1, 1)
		bc:SetPoint("BOTTOMRIGHT", point or self, 1, -1)
		self.oGlowBorder = bc
	end

	return bc
end

local borderDisplay = function(frame, color)
	if(color) then
		local bc = createBorder(frame)
		local rgb = colorTable[color]

		if(rgb) then
			bc:SetVertexColor(rgb[1], rgb[2], rgb[3])
			bc:Show()
		end

		return true
	elseif(frame.oGlowBorder) then
		frame.oGlowBorder:Hide()
	end
end

oGlow:RegisterDisplay('Border', borderDisplay)
