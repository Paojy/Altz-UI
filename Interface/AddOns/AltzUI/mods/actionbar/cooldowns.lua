-- 'Basic' version of OmniCC
local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB.cooldown then return end

local function CreateFS(parent, size, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont(G.numFont, size, "OUTLINE")
    f:SetShadowColor(0, 0, 0, 0)
    if(justify) then f:SetJustifyH(justify) end
    return f
end

local format, floor, GetTime = string.format, math.floor, GetTime
local Multiplier = 0.8

local function GetFormattedTime(s)
	if s>3600 then
		return format("%dh", floor(s/3600 + 0.5)), s % 3600
	elseif s>60 then
		return format("%dm", floor(s/60 + 0.5)), s % 60
	end
	return floor(s + 0.5), s - floor(s)
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
	if start>0 and duration>2.5 then
		if self.noshowcd then return end
		
		self.start = start
		self.duration = duration
		self.nextUpdate = 0

		if not self.text then
			self.text = T.createnumber(self, "OVERLAY", 15, "OUTLINE", "CENTER")
			self.text:SetTextColor(.4, .95, 1)
			self.text:SetPoint("CENTER", 0, 0)
			self:SetScript("OnUpdate", Timer_OnUpdate)
		end

		self.text:Show()
	elseif self.text then
		self.text:Hide()
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