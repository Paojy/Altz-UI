-- 'Basic' version of OmniCC
local T, C, L, G = unpack(select(2, ...))

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
		elseif self.Duration then
			local remain = self.Duration - (GetTime() - self.start)
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

local hooked = {}
local active = {}

local function actionButton_Register(frame)
	local cooldown = frame.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript('OnShow', function(self) active[self] = true end)
		cooldown:HookScript('OnHide', function(self) active[self] = nil end)
		hooked[cooldown] = true
	end
end

local Init = function()
	local methods = getmetatable(ActionButton1Cooldown).__index
	hooksecurefunc(methods, "SetCooldown", function(self, start, Duration)
		if self.noshowcd or self:IsForbidden() then
			return
		elseif not aCoreCDB["ActionbarOptions"]["cooldown_wa"] then
			local frameName = self.GetName and self:GetName() or ""
			if strfind(frameName, "WeakAuras") then
				return
			end
		end
		local parent = self:GetParent()
		if parent then
			local parent_name = parent:GetName()
			if parent_name and parent_name:find("CompactRaidFrame") then
				return
			end
		end
		
		if (self:GetWidth() >= 15) and (self:GetHeight() >= 15) then
			local s, d = tonumber(start), tonumber(Duration)
			if s and d then
				if s > 0 and d > 2.5 then	
					self.start = s
					self.Duration = d
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
			end
		elseif self.text then
			if start>0 and Duration>2.5 then
				self.start = start
				self.Duration = Duration
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
	
	for i, frame in pairs(ActionBarButtonEventsFrame.frames) do
		actionButton_Register(frame)
	end

	hooksecurefunc(ActionBarButtonEventsFrame, 'RegisterFrame', actionButton_Register)
end

local EventFrame = CreateFrame('Frame')
EventFrame:SetScript('OnEvent', function(self, event, arg)
	if not aCoreCDB["ActionbarOptions"]["cooldown"] then return end
	if event == 'ACTIONBAR_UPDATE_COOLDOWN' then
		for cooldown in pairs(active) do
			local button = cooldown:GetParent()
			local start, Duration, enable = GetActionCooldown(button.action)
			cooldown:SetCooldown(start, Duration)
		end
	elseif event == "PLAYER_LOGIN" then
		SetCVar("countdownForCooldowns", 0)
	elseif event == "ADDON_LOADED" then
		if arg == "AltzUI" then
			Init()
		end
	end
end)

EventFrame:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
EventFrame:RegisterEvent('PLAYER_LOGIN')
EventFrame:RegisterEvent('ADDON_LOADED')