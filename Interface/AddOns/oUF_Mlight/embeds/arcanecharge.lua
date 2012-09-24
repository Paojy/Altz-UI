local addon, ns = ...
if select(2, UnitClass("player")) ~= "MAGE" then return end

local count, maxcount = 0, 6

local Update = function(self, event, unit)
	if self.unit ~= unit then return end

	local element = self.ArcaneCharge
	
	if element.PreUpdate then element:PreUpdate(unit) end
	
	if UnitDebuff("player", GetSpellInfo(36032)) then
		count = select(4, UnitDebuff("player", GetSpellInfo(36032)))
	else
		count = 0
	end

	for index = 1, maxcount do
		if index <= count then
			element[index]:Show()
		else
			element[index]:Hide()
		end
	end

	if element.PostUpdate then return element:PostUpdate(spec) end
end

local Visibility = function(self, event, unit)
	local element = self.ArcaneCharge
	if(GetSpecialization() == 1) then
		element:Show()
	else
		element:Hide()
	end
end

local Path = function(self, ...)
	return (self.ArcaneCharge.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local element = self.ArcaneCharge
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_AURA', Path)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Visibility, true)
		
		return true
	end
end

local Disable = function(self)
	local element = self.ArcaneCharge
	if(element) then
		self:UnregisterEvent('UNIT_AURA', Path)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', Visibility)
	end
end

oUF:AddElement('ArcaneCharge', Path, Enable, Disable)
