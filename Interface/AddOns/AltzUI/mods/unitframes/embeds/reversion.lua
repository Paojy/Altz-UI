local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local last_time
local update_gap = 0.5
local PlayerGUID = UnitGUID("player")

local data = {}
local value_data = {}

local CLEU_events = {
	["SWING_DAMAGE"] = true,
	["RANGE_DAMAGE"] = true,
	["SPELL_DAMAGE"] = true,
	["SPELL_PERIODIC_DAMAGE"] = true,
	["ENVIRONMENTAL_DAMAGE"] = true,
}

local function UpdateTotalValue(GUID)
	if data[GUID] then
		local cur_time = GetTime()
		
		if not value_data[GUID] then
			value_data[GUID] = 0
		end
		
		for i, info in pairs(data[GUID]) do
			if cur_time - info.ts >= 5 then
				if info.counted then
					value_data[GUID] = value_data[GUID] - info.value
				end
				table.remove(data[GUID], i)
			else
				if not info.counted then
					info.counted = true
					value_data[GUID] = value_data[GUID] + info.value
				end
			end
		end
	end
end

local function ShouldApplyAura(unit)
	local remain
	local exp_time = select(6, T.FindAuraBySpellID(366155, unit, "HELPFUL"))
	if exp_time then
		remain = exp_time - GetTime()	
	end
	if not remain or remain < 5 then
		return true
	end
end

local function UpdateValue(element)
	local value = value_data[element.unitGUID]
	if value and value > 0 and ShouldApplyAura(element.__owner.unit) then
		element:SetValue(value*0.15)
	else
		element:SetValue(0)
	end
end

local function Update(self, event, unit, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then		
		local _, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, arg12, arg13, arg14, arg15 = CombatLogGetCurrentEventInfo()
		
		if destGUID == self.ReversionBar.unitGUID then			
			if CLEU_events[eventType] then
				local amount
				if eventType == "SWING_DAMAGE" then
					amount = arg12
				elseif eventType == "RANGE_DAMAGE" then
					amount = arg15
				elseif eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
					amount = arg15
				elseif eventType == "ENVIRONMENTAL_DAMAGE" then
					amount = arg13
				end
				
				if not data[destGUID] then
					data[destGUID] = {}
				end
				
				table.insert(data[destGUID], {ts = GetTime(), value = amount})
			end
		end
	elseif event == "UNIT_MAXHEALTH" then
		if unit == self.unit then
			local element = self.ReversionBar
			local maxHealth = UnitHealthMax(unit)
			if maxHealth and maxHealth > 0 then
				element:SetMinMaxValues(0, maxHealth)
			end
		end
	else
		local element = self.ReversionBar
		local maxHealth = UnitHealthMax(self.unit)
		if maxHealth and maxHealth > 0 then
			element:SetMinMaxValues(0, maxHealth)
		end	
		element.unitGUID = UnitGUID(self.unit)
		UpdateValue(element)
	end
end

local function Path(self, ...)
	return (self.ReversionBar.Override or Update) (self, ...)
end

local Visibility = function(self, event, unit)
	local element = self.ReversionBar
	if self:IsElementEnabled('ReversionBar') and IsPlayerSpell(378196) then
		if (not element:IsShown()) then
			element:Show()
			element.t = update_gap
			element:SetScript("OnUpdate", function(s, e)
				s.t = s.t + e
				if s.t > update_gap then
					UpdateTotalValue(s.unitGUID)
					UpdateValue(s)
					s.t = 0
				end
			end)
			self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', Path, true)
			self:RegisterEvent('UNIT_MAXHEALTH', Path)
		end
		
		return Path(self, event, unit)
	else
		if element:IsShown() then
			element:Hide()
			element:SetScript("OnUpdate", nil)
			self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', Path)
			self:UnregisterEvent('UNIT_MAXHEALTH', Path)	
		end
	end
end

local VisibilityPath = function(self, ...)
	return (self.ReversionBar.OverrideVisibility or Visibility)(self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local element = self.ReversionBar
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		
		self:RegisterEvent('SPELLS_CHANGED', VisibilityPath, true)
		
		if(element:IsObjectType'StatusBar' and not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end
		
		element:ForceUpdate()
		
		return true
	end
end

local Disable = function(self)
	local element = self.ReversionBar
	if(element) then
		self:UnregisterEvent('SPELLS_CHANGED', VisibilityPath)
		
		element:ForceUpdate()
	end
end

oUF:AddElement('ReversionBar', VisibilityPath, Enable, Disable)
