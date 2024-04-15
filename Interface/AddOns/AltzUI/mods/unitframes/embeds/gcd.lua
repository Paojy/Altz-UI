local T, C, L, G = unpack(select(2, ...))
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
	
	local gcd = self.GCD
	
	if gcd then
		local start, dur = GetSpellCooldown(spellid)

		if (not start) then return end
		if (not dur) then dur = 0 end

		if dur == 0 then
			gcd:Hide() 
		else
			gcd.starttime = start
			gcd.duration = dur
			gcd:Show()
		end
	end
end

local Enable = function(self)
	local gcd = self.GCD
	if gcd then	
		gcd:SetMinMaxValues(0, 1)
		gcd:SetValue(0)
		gcd:Hide()
		gcd.starttime = 0
		gcd.duration = 0
	
		self:HookScript("OnEnter", function(self) self.showgcd = true end)
		self:HookScript("OnLeave", function(self) self.showgcd = false end)

		self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update, true)
		gcd:SetScript('OnHide', OnHideGCD)
		gcd:SetScript('OnShow', OnShowGCD)
		gcdisshown = nil
		
		return true
	end
end


local function Disable(self)
	local gcd = self.GCD
	if gcd then
		self:UnregisterEvent('ACTIONBAR_UPDATE_COOLDOWN', Update)
		
		gcd:Hide()
	end
end

oUF:AddElement('GCD', Update, Enable, Disable)