local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local function Update(self, event, unit, powertype)
	if(unit ~= 'player' or (powertype and powertype ~= 'MANA')) then return end

	local dpsmana = self.Dpsmana
	if(dpsmana.PreUpdate) then dpsmana:PreUpdate(unit) end

	-- Hide the bar if the active power type is mana.
	if(UnitPowerType('player') == Enum.PowerType.Mana) then
		return dpsmana:Hide()
	else
		dpsmana:Show()
	end

	local min, max = UnitPower('player', Enum.PowerType.Mana), UnitPowerMax('player', Enum.PowerType.Mana)
	dpsmana:SetMinMaxValues(0, max)
	dpsmana:SetValue(min)

	local r, g, b, t
	
	t = self.colors.power['MANA']
	
	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		dpsmana:SetStatusBarColor(r, g, b)

		local bg = dpsmana.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(dpsmana.PostUpdate) then
		return dpsmana:PostUpdate(unit, min, max)
	end
end

local function Path(self, ...)
	return (self.Dpsmana.Override or Update) (self, ...)
end

local Visibility = function(self, event, unit)
	local spec = GetSpecialization()
	if UnitHasVehiclePlayerFrameUI('player') or (G.myClass == "SHAMAN" and spec == 3) or (G.myClass == "PRIEST" and spec ~= 3) then
		if self.Dpsmana:IsShown() then
			self.Dpsmana:Hide()
			self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
			self:UnregisterEvent('UNIT_MAXPOWER', Path)	
		end
	else
		if(not self.Dpsmana:IsShown()) then
			self.Dpsmana:Show()
			self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
			self:RegisterEvent('UNIT_MAXPOWER', Path)
		end

		return Path(self, event, unit)
	end
end

local VisibilityPath = function(self, ...)
	return (self.Dpsmana.OverrideVisibility or Visibility)(self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local dpsmana = self.Dpsmana
	if(dpsmana and unit == 'player') then
		dpsmana.__owner = self
		dpsmana.ForceUpdate = ForceUpdate
		dpsmana:Hide()
		
		self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath)

		if(dpsmana:IsObjectType'StatusBar' and not dpsmana:GetStatusBarTexture()) then
			dpsmana:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end

		return true
	end
end

local Disable = function(self)
	local dpsmana = self.Dpsmana
	if(dpsmana) then	
		self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', VisibilityPath)
	end
end

oUF:AddElement('Dpsmana', VisibilityPath, Enable, Disable)
