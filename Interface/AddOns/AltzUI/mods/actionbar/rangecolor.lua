-- Range by Tuller, modified by Haleth

hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self)
	if not aCoreCDB["ActionbarOptions"]["rangecolor"] then return end
	
	--print(self:GetName())
	local Icon = self.icon
	local NormalTexture = self.NormalTexture
    local ID = self.action
	
	if not ID then return end

	local IsUsable = IsUsableAction(ID)
	local HasRange = ActionHasRange(ID)
	local InRange = IsActionInRange(ID)

	if IsUsable then -- Usable
		if (HasRange and InRange == false) then -- Out of range
			Icon:SetVertexColor(0.8, 0.1, 0.1)
			if NormalTexture then
				NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
			end
		else -- In range
			Icon:SetVertexColor(1.0, 1.0, 1.0)
			if NormalTexture then
				NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
			end
		end
	else
		--Icon:SetVertexColor(0, 0.5, 1.0)
		--if NormalTexture then
		--	NormalTexture:SetVertexColor(0, 0.5, 1.0)
		--end
	end
end)