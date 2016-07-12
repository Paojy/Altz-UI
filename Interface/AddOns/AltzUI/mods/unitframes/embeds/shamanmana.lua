if(select(2, UnitClass('player')) ~= 'SHAMAN') then return end

local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local function Update(self, event, unit, powertype)
	if(unit ~= 'player' or (powertype and powertype ~= 'MANA')) then return end

	local shamanmana = self.ShamanMana
	if(shamanmana.PreUpdate) then shamanmana:PreUpdate(unit) end

	-- Hide the bar if the active power type is mana.
	if(UnitPowerType('player') == SPELL_POWER_MANA) then
		return shamanmana:Hide()
	else
		shamanmana:Show()
	end

	local min, max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
	shamanmana:SetMinMaxValues(0, max)
	shamanmana:SetValue(min)

	local r, g, b, t
	
	t = self.colors.power['MANA']
	
	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		shamanmana:SetStatusBarColor(r, g, b)

		local bg = shamanmana.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(shamanmana.PostUpdate) then
		return shamanmana:PostUpdate(unit, min, max)
	end
end

local function Path(self, ...)
	return (self.ShamanMana.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local shamanmana = self.ShamanMana
	if(shamanmana and unit == 'player') then
		shamanmana.__owner = self
		shamanmana.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)

		self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
		self:RegisterEvent('UNIT_MAXPOWER', Path)

		if(shamanmana:IsObjectType'StatusBar' and not shamanmana:GetStatusBarTexture()) then
			shamanmana:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end

		return true
	end
end

local Disable = function(self)
	local shamanmana = self.ShamanMana
	if(shamanmana) then

		self:UnregisterEvent('UNIT_POWER', Path)

		self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
		self:UnregisterEvent('UNIT_MAXPOWER', Path)
	end
end

oUF:AddElement('ShamanMana', Path, Enable, Disable)
