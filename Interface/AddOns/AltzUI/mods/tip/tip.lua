local T, C, L, G = unpack(select(2, ...))

local EnumItem = Enum.TooltipDataType.Item
local EnumSpell = Enum.TooltipDataType.Spell
local EnumAura = Enum.TooltipDataType.UnitAura
local EnumUnit = Enum.TooltipDataType.Unit

hooksecurefunc(GameTooltip, "ProcessInfo", function(self)
	if aCoreCDB["OtherOptions"]["combat_hide"] and InCombatLockdown() then
		self:Hide()
	end
end)

hooksecurefunc(GameTooltip, "ProcessLines", function(self)
	local tooltipData = self:GetPrimaryTooltipData()
	if tooltipData then
		if tooltipData.type == EnumItem then	
			if aCoreCDB["OtherOptions"]["show_itemID"] then
				local itemID = tooltipData.id
				if itemID then
					self:AddLine(" ")
					self:AddDoubleLine(T.color_text(L["物品编号"]), T.hex_str(itemID, 1, 1, 1))
					self:Show()
				end
			end
		elseif (tooltipData.type == EnumSpell or tooltipData.type == EnumAura) then
			if aCoreCDB["OtherOptions"]["show_spellID"] then
				local spellID = tooltipData.id
				if spellID then
					self:AddLine(" ")
					self:AddDoubleLine(T.color_text(L["法术编号"]), T.hex_str(spellID, 1, 1, 1))
					self:Show()
				end
			end
		elseif tooltipData.type == EnumUnit then
			local _, unit = self:GetUnit()
			if unit then				
				if UnitIsDeadOrGhost(unit) then
					GameTooltipStatusBar:Hide()
				else			
					local r, g, b = T.GetUnitColor(unit)
					if r and g and b then
						GameTooltipStatusBar:SetStatusBarColor(r, g, b)
					end
				end
			end
		end
	end
end)

local styled_lines = {}

hooksecurefunc(GameTooltip, "AddLine", function(self)
	for i= 1, self:NumLines() do
		if not styled_lines[i] then
			local tiptext_left = _G["GameTooltipTextLeft"..i]
			local tiptext_right = _G["GameTooltipTextRight"..i]
			if tiptext_left then
				tiptext_left:SetFont(G.norFont, 12, "OUTLINE")
			end
			if	tiptext_right then
				tiptext_right:SetFont(G.norFont, 12, "OUTLINE")
			end
			styled_lines[i] = true
		end
	end
end)

-- GameTooltipStatusBar
local function UpdateGameTooltipStatusBar()
	GameTooltipStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
	T.createBackdrop(GameTooltipStatusBar, 1)
	
	GameTooltipStatusBar.text = T.createtext(GameTooltipStatusBar, "OVERLAY", 12, "OUTLINE", "CENTER")
	GameTooltipStatusBar.text:SetPoint("BOTTOM", GameTooltipStatusBar, "BOTTOM", 0, 0)

	GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
		if not value then return end
		local min, max = self:GetMinMaxValues()
		if (value < min) or (value > max) then return end
		local _, unit = GameTooltip:GetUnit()
		
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			local hp = T.ShortValue(min).." / "..T.ShortValue(max)
			self.text:SetText(hp)
			self.text:Show()
		else
			self.text:Hide()
		end
	end)
end

local function UpdateTooltipAnchor()
	hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
		if aCoreCDB["OtherOptions"]["anchor_cursor"] then
			self:SetOwner(parent, "ANCHOR_CURSOR") 
		end
	end)
end

T.RegisterInitCallback(function()
	UpdateGameTooltipStatusBar()
	UpdateTooltipAnchor()
end)