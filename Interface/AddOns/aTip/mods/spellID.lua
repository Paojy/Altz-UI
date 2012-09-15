if not aCoreCDB.showspellID then return end

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format("|cffffffff%s|r",id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link,"^spell:") then
		local id = string.sub(link,7)
		ItemRefTooltip:AddLine(" ")
		ItemRefTooltip:AddDoubleLine("SpellID:",format("|cff70C0F5%s|r",id))
		ItemRefTooltip:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format("|cff70C0F5%s|r",id))
		self:Show()
	end
end)