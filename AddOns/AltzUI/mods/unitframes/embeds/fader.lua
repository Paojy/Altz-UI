local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local function Update(self)
	if not aCoreCDB["UnitframeOptions"]["enablefade"] then return end
	local unit = self.unit

	local _, powerType = UnitPowerType(unit)
	local power = UnitPower(unit)

	if
		(self.FadeCasting and (UnitCastingInfo(unit) or UnitChannelInfo(unit))) or
		(self.FadeCombat and UnitAffectingCombat(unit)) or
		(self.FadeTarget and (unit:find('target') and UnitExists(unit))) or
		(self.FadeTarget and UnitExists(unit .. 'target')) or
		(self.FadeHealth and UnitHealth(unit) < UnitHealthMax(unit)) or
		(self.FadePower and ((powerType == 'RAGE' or powerType == 'RUNIC_POWER') and power > 0)) or
		(self.FadePower and ((powerType ~= 'RAGE' and powerType ~= 'RUNIC_POWER') and power < UnitPowerMax(unit))) or
		(self.FadeHover and GetMouseFocus() == self)
	then
		if(self.FadeInSmooth) then
			T.UIFrameFadeIn(self, self.FadeInSmooth, self:GetAlpha(), self.FadeMaxAlpha or 1)
		else
			self:SetAlpha(self.FadeMaxAlpha or 1)
		end
	else
		if(self.FadeOutSmooth) then
			T.UIFrameFadeOut(self, self.FadeOutSmooth, self:GetAlpha(), self.FadeMinAlpha or 0.3)
		else
			self:SetAlpha(self.FadeMinAlpha or 0.3)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner)
end

local function Enable(self, unit)
	if
		unit == 'player' or
		unit == 'target' or
		unit == 'targettarget' or
		unit == 'focus' or
		unit == 'pet'
	then
		if(self.FadeHover) then
			self:HookScript('OnEnter', Update)
			self:HookScript('OnLeave', Update)
		end
		if(self.FadeCombat) then
			self:RegisterEvent('PLAYER_REGEN_ENABLED', Update)
			self:RegisterEvent('PLAYER_REGEN_DISABLED', Update)
		end
		if(self.FadeTarget) then
			self:HookScript('OnShow', Update)
			self:RegisterEvent('UNIT_TARGET', Update)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', Update)
		end
		if(self.FadeHealth) then
			self:RegisterEvent('UNIT_HEALTH', Update)
			self:RegisterEvent('UNIT_HEALTHMAX', Update)
		end
		if(self.FadePower) then
			self:RegisterEvent('UNIT_POWER', Update)
			self:RegisterEvent('UNIT_POWERMAX', Update)
		end

		if(self.FadeCasting) then
			self:RegisterEvent('UNIT_SPELLCAST_START', Update)
			self:RegisterEvent('UNIT_SPELLCAST_FAILED', Update)
			self:RegisterEvent('UNIT_SPELLCAST_STOP', Update)
			self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update)
		end

		Update(self)

		return true
	end
end

local function Disable(self, unit)
	if
		unit == 'player' or
		unit == 'target' or
		unit == 'targettarget' or
		unit == 'focus' or
		unit == 'pet'
	then
		if(self.FadeCombat) then
			self:UnregisterEvent('PLAYER_REGEN_ENABLED', Update)
			self:UnregisterEvent('PLAYER_REGEN_DISABLED', Update)
		end
		if(self.FadeTarget) then
			self:UnregisterEvent('UNIT_TARGET', Update)
			self:UnregisterEvent('PLAYER_TARGET_CHANGED', Update)
		end
		if(self.FadeHealth) then
			self:UnregisterEvent('UNIT_HEALTH', Update)
			self:UnregisterEvent('UNIT_HEALTHMAX', Update)
		end
		if(self.FadePower) then
			self:UnregisterEvent('UNIT_POWER', Update)
			self:UnregisterEvent('UNIT_POWERMAX', Update)
		end

		if(self.FadeCasting) then
			self:UnregisterEvent('UNIT_SPELLCAST_START', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_FAILED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_STOP', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update)
		end
	end
end

oUF:AddElement('Fader', Path, Enable, Disable)
