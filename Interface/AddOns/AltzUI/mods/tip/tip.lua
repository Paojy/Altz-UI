local T, C, L, G = unpack(select(2, ...))

hooksecurefunc(GameTooltip, "ProcessLines", function(self)
	local tooltip = self or GameTooltip
	local tooltipData = tooltip:GetPrimaryTooltipData()
	if tooltipData then
		if aCoreCDB["OtherOptions"]["combathide"] and InCombatLockdown() then
			 tooltip:Hide()
			 return
		end
		if tooltipData.type == Enum.TooltipDataType.Item then	
			if aCoreCDB["OtherOptions"]["show_itemID"] then
				local itemID = tooltipData.id
				if itemID then
					tooltip:AddLine(" ")
					tooltip:AddDoubleLine(T.color_text(L["物品编号"]), T.hex_str(itemID, 1, 1, 1))
					tooltip:Show()
				end
			end
		elseif (tooltipData.type == Enum.TooltipDataType.Spell or tooltipData.type == Enum.TooltipDataType.UnitAura) then
			if aCoreCDB["OtherOptions"]["show_spellID"] then
				local spellID = tooltipData.id
				if spellID then
					tooltip:AddLine(" ")
					tooltip:AddDoubleLine(T.color_text(L["法术编号"]), T.hex_str(spellID, 1, 1, 1))
					tooltip:Show()
				end
			end
		elseif tooltipData.type == Enum.TooltipDataType.Unit then
			local _, unit = tooltip:GetUnit()
			local r, g, b = T.GetUnitColor(unit)
			
			if UnitIsDeadOrGhost(unit) then
				GameTooltipStatusBar:Hide()
			end
			
			GameTooltipStatusBar:SetStatusBarColor(r, g, b)
		end
		
		for i= 1, tooltip:NumLines() do
			local tiptext_left = _G["GameTooltipTextLeft"..i]
			local tiptext_right = _G["GameTooltipTextRight"..i]
			if tiptext_left then
				tiptext_left:SetFont(G.norFont, 12, "OUTLINE")
			end
			if	tiptext_right then
				tiptext_right:SetFont(G.norFont, 12, "OUTLINE")
			end
		end
	end
end)

-- GameTooltipStatusBar
local function UpdateGameTooltipStatusBar()
	GameTooltipStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
	T.createBackdrop(GameTooltipStatusBar, 1)
	
	GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
		if not value then return end
		local min, max = self:GetMinMaxValues()
		if (value < min) or (value > max) then return end
		local _, unit = GameTooltip:GetUnit()
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			if not self.text then
				self.text = T.createtext(self, "OVERLAY", 12, "OUTLINE", "CENTER")
				self.text:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
			end
			local hp = T.ShortValue(min).." / "..T.ShortValue(max)
			self.text:SetText(hp)
			self.text:Show()
		else
			self.text:Hide()
		end
	end)
end

T.RegisterInitCallback(UpdateGameTooltipStatusBar)