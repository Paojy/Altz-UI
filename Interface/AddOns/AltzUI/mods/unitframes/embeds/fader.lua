local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local EmptyPowerType = {
	["RAGE"] = true,
	["RUNIC_POWER"] = true, 
	["LUNAR_POWER"] = true, 
	["MAELSTROM"] = true, 
	["INSANITY"] = true, 
	["FURY"] = true, 
	["PAIN"] = true,
}

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
		(self.FadePower and EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") > 0) or
		(self.FadePower and (not EmptyPowerType[select(2, UnitPowerType("player"))]) and UnitPower("player") < UnitPowerMax("player")) or
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
			self:RegisterEvent('PLAYER_REGEN_ENABLED', Update, true)
			self:RegisterEvent('PLAYER_REGEN_DISABLED', Update, true)
		end
		if(self.FadeTarget) then
			self:HookScript('OnShow', Update)
			self:RegisterEvent('UNIT_TARGET', Update, true)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', Update, true)
		end
		if(self.FadeHealth) then
			self:RegisterEvent('UNIT_HEALTH', Update, true)
			self:RegisterEvent('UNIT_MAXHEALTH', Update, true)
		end
		if(self.FadePower) then
			self:RegisterEvent('UNIT_POWER_UPDATE', Update, true)
			self:RegisterEvent('UNIT_MAXPOWER', Update, true)
		end

		if(self.FadeCasting) then
			self:RegisterEvent('UNIT_SPELLCAST_START', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_FAILED', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_STOP', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update, true)
			--self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update, true)
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
			self:UnregisterEvent('UNIT_MAXHEALTH', Update)
		end
		if(self.FadePower) then
			self:UnregisterEvent('UNIT_POWER_UPDATE', Update)
			self:UnregisterEvent('UNIT_MAXPOWER', Update)
		end

		if(self.FadeCasting) then
			self:UnregisterEvent('UNIT_SPELLCAST_START', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_FAILED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_STOP', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update)
			--self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update)
		end
	end
end

oUF:AddElement('Fader', Path, Enable, Disable)
