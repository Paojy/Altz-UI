local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

if not aCoreCDB["TooltipOptions"]["showspellID"] or not aCoreCDB["TooltipOptions"]["enabletip"] then return end

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format(G.classcolor.."%s|r",id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format(G.classcolor.."%s|r",id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format(G.classcolor.."%s|r",id))
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link,"^spell:") then
		local id = string.sub(link,7)
		ItemRefTooltip:AddLine(" ")
		ItemRefTooltip:AddDoubleLine("SpellID:",format(G.classcolor.."%s|r",id))
		ItemRefTooltip:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local name = self:GetOwner():GetName()
	if name and name:match("PlayerTalentFrameTalentsTalentRow%dTalent%d") then return end
	local id = select(3,self:GetSpell())
	if id then
		self:AddLine(" ")
		self:AddDoubleLine("SpellID:",format(G.classcolor.."%s|r",id))
		self:Show()
	end
end)
