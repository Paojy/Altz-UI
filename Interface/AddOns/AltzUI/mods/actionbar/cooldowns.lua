-- 'Basic' version of OmniCC
local T, C, L, G = unpack(select(2, ...))

local format, floor, GetTime = string.format, math.floor, GetTime
local cd_frames = {}

--====================================================--
--[[                    -- API --                   ]]--
--====================================================--

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
		elseif self.duration then
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

local function UpdateTextAlpha(cd)
	if aCoreCDB["ActionbarOptions"]["cooldown_number"] then
		local frameName = cd.GetName and cd:GetName() or ""
		if strfind(frameName, "WeakAuras") and not aCoreCDB["ActionbarOptions"]["cooldown_number_wa"] then
			cd.text:SetAlpha(0)
		else
			cd.text:SetAlpha(1)
		end
	else
		cd.text:SetAlpha(0)
	end
end

T.CooldownNumber_Edit = function()
	for k, cd in pairs(cd_frames) do
		UpdateTextAlpha(cd)
		
		local fontsize = min(aCoreCDB["ActionbarOptions"]["cooldownsize"], cd:GetWidth()*.9, cd:GetHeight()*.9)
		cd.text:SetFont(G.numFont, fontsize, "OUTLINE")
	end
end

--====================================================--
--[[                 -- Update --                   ]]--
--====================================================--
local hooked = {}
local active = {}

local EventFrame = CreateFrame('Frame')
EventFrame:SetScript('OnEvent', function(self, event)	
	if event == 'ACTIONBAR_UPDATE_COOLDOWN' then
		for cooldown in pairs(active) do
			local button = cooldown:GetParent()
			local start, dur, enable = GetActionCooldown(button.action)
			cooldown:SetCooldown(start, dur)
		end
	elseif event == "PLAYER_LOGIN" then
		SetCVar("countdownForCooldowns", 0)
	end
end)

EventFrame:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
EventFrame:RegisterEvent('PLAYER_LOGIN')

local function actionButton_Register(frame)
	local cooldown = frame.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript('OnShow', function(self) active[self] = true end)
		cooldown:HookScript('OnHide', function(self) active[self] = nil end)
		hooked[cooldown] = true
	end
end

T.RegisterInitCallback(function()
	local methods = getmetatable(ActionButton1Cooldown).__index
	
	hooksecurefunc(methods, "SetCooldown", function(self, start, dur)

		if self.noshowcd or self:IsForbidden() then
			return
		elseif self:GetParent() then
			local parent_name = self:GetParent():GetName()
			if parent_name and parent_name:find("CompactRaidFrame") then -- 暴雪团队框架上的图标不加冷却时间	
				return
			end
		end
		
		-- 添加时间
		if self:GetWidth() >= 10 and self:GetHeight() >= 10 then
			local s, d = tonumber(start), tonumber(dur)
			if s and d then
				if s > 0 and d > 2.5 then -- CD > 2.5 显示
					self.start = s
					self.duration = d
					self.nextUpdate = 0		
					if not self.text then
						local fontsize = min(aCoreCDB["ActionbarOptions"]["cooldownsize"], self:GetWidth()*.9, self:GetHeight()*.9)
						self.text = T.createnumber(self, "OVERLAY", fontsize, "OUTLINE", "CENTER")
						self.text:SetTextColor(.4, .95, 1)
						self.text:SetPoint("CENTER")
						table.insert(cd_frames, self)
					end
					
					if not self:GetScript("OnUpdate") then
						self:SetScript("OnUpdate", Timer_OnUpdate)
					end		
					
					UpdateTextAlpha(self)

					self.text:Show()
				
				elseif self.text then -- 无CD或GCD 隐藏
				
					self.text:Hide()
					
				end
			end
		end
	end)
	
	for i, frame in pairs(ActionBarButtonEventsFrame.frames) do
		actionButton_Register(frame)
	end

	hooksecurefunc(ActionBarButtonEventsFrame, 'RegisterFrame', actionButton_Register)
end)

