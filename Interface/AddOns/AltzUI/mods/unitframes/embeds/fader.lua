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

local function IsMouseOver(self)
	local mouseFoci = GetMouseFoci()
	for _, mouseFocus in ipairs(mouseFoci) do
		if mouseFocus == self then
			return true
		end
	end
end

local function Update(self)
	local unit = self.unit
	local fader = self.Fader
	
	local _, powerType = UnitPowerType(unit)
	local power = UnitPower(unit)
	
	if fader and aCoreCDB["UnitframeOptions"]["enablefade"] then
		
		if
			(fader.FadeCasting and (UnitCastingInfo(unit) or UnitChannelInfo(unit))) or
			(fader.FadeCombat and UnitAffectingCombat(unit)) or
			(fader.FadeTarget and (unit:find('target') and UnitExists(unit))) or
			(fader.FadeTarget and UnitExists(unit .. 'target')) or
			(fader.FadeHealth and UnitHealth(unit) < UnitHealthMax(unit)) or
			(fader.FadePower and EmptyPowerType[select(2, UnitPowerType("player"))] and UnitPower("player") > 0) or
			(fader.FadePower and (not EmptyPowerType[select(2, UnitPowerType("player"))]) and UnitPower("player") < UnitPowerMax("player")) or
			(fader.FadeHover and IsMouseOver(self))
		then
			T.UIFrameFadeIn(self, fader.FadeInSmooth, self:GetAlpha(), 1)
		else
			T.UIFrameFadeOut(self, fader.FadeOutSmooth, self:GetAlpha(), aCoreCDB["UnitframeOptions"]["fadingalpha"] or 0.3)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner)
end

local function Enable(self, unit)
	local fader = self.Fader
	if fader then
		fader.__owner = self
		fader.ForceUpdate = ForceUpdate

		if(fader.FadeHover) then
			self:HookScript('OnEnter', Update)
			self:HookScript('OnLeave', Update)
		end

		if(fader.FadeCombat) then
			self:RegisterEvent('PLAYER_REGEN_ENABLED', Update, true)
			self:RegisterEvent('PLAYER_REGEN_DISABLED', Update, true)
		end
		
		if(fader.FadeTarget) then
			self:HookScript('OnShow', Update)
			self:RegisterEvent('UNIT_TARGET', Update, true)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', Update, true)
		end
		
		if(fader.FadeHealth) then
			self:RegisterEvent('UNIT_HEALTH', Update, true)
			self:RegisterEvent('UNIT_MAXHEALTH', Update, true)
		end
		
		if(fader.FadePower) then
			self:RegisterEvent('UNIT_POWER_UPDATE', Update, true)
			self:RegisterEvent('UNIT_MAXPOWER', Update, true)
		end

		if(fader.FadeCasting) then
			self:RegisterEvent('UNIT_SPELLCAST_START', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_FAILED', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_STOP', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update, true)
			--self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_INTERRUPTED', Update, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update, true)
		end
		
		Update(self) -- 进游戏时生效
		
		return true
	end
end

local function Disable(self, unit)
	local fader = self.Fader
	if fader then
		if(fader.FadeCombat) then
			self:UnregisterEvent('PLAYER_REGEN_ENABLED', Update)
			self:UnregisterEvent('PLAYER_REGEN_DISABLED', Update)
		end
		
		if(fader.FadeTarget) then
			self:UnregisterEvent('UNIT_TARGET', Update)
			self:UnregisterEvent('PLAYER_TARGET_CHANGED', Update)
		end
		
		if(fader.FadeHealth) then
			self:UnregisterEvent('UNIT_HEALTH', Update)
			self:UnregisterEvent('UNIT_MAXHEALTH', Update)
		end
		
		if(fader.FadePower) then
			self:UnregisterEvent('UNIT_POWER_UPDATE', Update)
			self:UnregisterEvent('UNIT_MAXPOWER', Update)
		end

		if(fader.FadeCasting) then
			self:UnregisterEvent('UNIT_SPELLCAST_START', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_FAILED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_STOP', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', Update)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Update)
		end
		
		T.UIFrameFadeIn(self, fader.FadeInSmooth, self:GetAlpha(), 1)
	end
end

oUF:AddElement('Fader', nil, Enable, Disable)
