-- 'Basic' version of OmniCC
local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ActionbarOptions"]["cooldown"] then return end

local format, floor, GetTime = string.format, math.floor, GetTime
local Multiplier = 0.8

local function GetFormattedTime(s)
	if s>3600 then
		return format("%dh", floor(s/3600 + 0.5)), s % 3600
	elseif s>60 then
		return format("%dm", floor(s/60 + 0.5)), s % 60
	elseif s>8 then
		return floor(s + 0.5), s - floor(s)
	elseif s>3 then
		return format("|cFFEEEE00%d|r", floor(s + 0.5)), s - floor(s)
	else
		return format("|cFFFF2400%.1f|r", s), 0.05
	end
end

local function Timer_OnUpdate(self, elapsed)
	if self.text:IsShown() then
		if self.nextUpdate>0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			local remain = self.duration - (GetTime() - self.start)
			if floor(remain + 0.5) > 0 then
				local time, nextUpdate = GetFormattedTime(remain)
				self.text:SetText(time)
				self.nextUpdate = nextUpdate
			else
				self.text:Hide()
			end
		end
	end
end

local methods = getmetatable(ActionButton1Cooldown).__index
hooksecurefunc(methods, "SetCooldown", function(self, start, duration)
	if self.noshowcd then return end
	if (self:GetWidth() >= 15) and (self:GetHeight() >= 15) then
		if start>0 and duration>2.5 then	
			self.start = start
			self.duration = duration
			self.nextUpdate = 0
	
			if (self:GetWidth() >= 25) and (self:GetHeight() >= 25) then
				if not self.text then
					self.text = T.createnumber(self, "OVERLAY", aCoreCDB["ActionbarOptions"]["cooldownsize"], "OUTLINE", "CENTER")
					self.text:SetTextColor(.4, .95, 1)
					self.text:SetPoint("CENTER", 0, 0)					
				else
					self.text:SetFont(G.numFont, aCoreCDB["ActionbarOptions"]["cooldownsize"], "OUTLINE")
				end
			else
				if not self.text then
					self.text = T.createnumber(self, "OVERLAY", self:GetWidth()*.7+1, "OUTLINE", "CENTER")
					self.text:SetTextColor(.4, .95, 1)
					self.text:SetPoint("CENTER", 0, 0)						
				else
					self.text:SetFont(G.numFont, self:GetWidth()*.7+1, "OUTLINE")
				end
			end
			
			if not self:GetScript("OnUpdate") then
				self:SetScript("OnUpdate", Timer_OnUpdate)
			end
			
			self.text:Show()
			
		elseif self.text then
			self.text:Hide()
		end
	elseif self.text then
		if start>0 and duration>2.5 then
			self.start = start
			self.duration = duration
			self.nextUpdate = 0
			if not self:GetScript("OnUpdate") then
				self:SetScript("OnUpdate", Timer_OnUpdate)
				self.text:Show()
			end
		else
			self.text:Hide()
		end
	end
end)

local hooked = {}
local active = {}

local abEventWatcher = CreateFrame('Frame'); abEventWatcher:Hide()
abEventWatcher:SetScript('OnEvent', function(self, event)
	for cooldown in pairs(active) do
		local button = cooldown:GetParent()
		local start, duration, enable = GetActionCooldown(button.action)
		cooldown:SetCooldown(start, duration)
	end
end)
abEventWatcher:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')

local function cooldown_OnShow(self)
	active[self] = true
    end

local function cooldown_OnHide(self)
	active[self] = nil
end

local function actionButton_Register(frame)
	local cooldown = frame.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript('OnShow', cooldown_OnShow)
		cooldown:HookScript('OnHide', cooldown_OnHide)
		hooked[cooldown] = true
	end
end

for i, frame in pairs(ActionBarButtonEventsFrame.frames) do
	actionButton_Register(frame)
end

hooksecurefunc('ActionBarButtonEventsFrame_RegisterFrame', actionButton_Register)