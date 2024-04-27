local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local Update = function(self, event)
	local element = self.TargetArrow

	local isTarget = (self.unit ~= "player" and UnitIsUnit(self.unit, "target"))
	if(isTarget) then
		element:Show()
	else
		element:Hide()
	end
end

local function Path(self, ...)
	return (self.TargetArrow.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.TargetArrow
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\AddOns\AltzUI\media\NeonRedArrow]])
		end

		return true
	end
end

local function Disable(self)
	local element = self.TargetArrow
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
	end
end
 
oUF:AddElement('TargetArrow', Update, Enable, Disable)
