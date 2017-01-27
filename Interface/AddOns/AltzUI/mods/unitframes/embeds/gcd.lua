﻿local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local GetTime = GetTime
local GetSpellCooldown = GetSpellCooldown
local gcdisshown

local spellid = 61304

local OnUpdateGCD = function(self)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
	else
		self:SetValue(perc)
	end
end

local OnHideGCD = function(self)
 	self:SetScript('OnUpdate', nil)
	gcdisshown = nil
end

local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
	gcdisshown = 1
end

local Update = function(self, event, unit)

	if not self.showgcd or gcdisshown then return end
	
	if self.GCD then
		local start, dur = GetSpellCooldown(spellid)

		if (not start) then return end
		if (not dur) then dur = 0 end

		if dur == 0 then
			self.GCD:Hide() 
		else
			self.GCD.starttime = start
			self.GCD.duration = dur
			self.GCD:Show()
		end
	end
end

local Enable = function(self)
	if (self.GCD) then
		self.GCD:SetMinMaxValues(0, 1)
		self.GCD:SetValue(0)
		self.GCD:Hide()
		self.GCD.starttime = 0
		self.GCD.duration = 0
	
		self:HookScript("OnEnter", function(self) self.showgcd = true end)
		self:HookScript("OnLeave", function(self) self.showgcd = false end)

		self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update)
		self.GCD:SetScript('OnHide', OnHideGCD)
		self.GCD:SetScript('OnShow', OnShowGCD)
		gcdisshown = nil
	end
end

local Disable = function(self)
	if (self.GCD) then
		self:UnregisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
		self.GCD:Hide()  
	end
end

oUF:AddElement('GCD', Update, Enable, Disable)