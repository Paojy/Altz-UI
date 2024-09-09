local T, C, L, G = unpack(select(2, ...))

local cd_frames = {}

--====================================================--
--[[                    -- API --                   ]]--
--====================================================--
local function AdjustFontStringSize(frame)
	local w, h = frame:GetSize(false)
	local fontsize
	if w > 0 and h > 0 then
		fontsize = min(aCoreCDB["ActionbarOptions"]["cooldownsize"], w*.6, h*.6)
	else
		fontsize = aCoreCDB["ActionbarOptions"]["cooldownsize"]
	end
	frame.altz_text:SetFont(G.numFont, fontsize, "OUTLINE")
end

local function AdjustFontStringColor(frame)
	frame.altz_text:SetTextColor(.4, .95, 1)
end

T.CooldownNumber_Edit = function()
	for k, cd in pairs(cd_frames) do
		AdjustFontStringSize(cd)
		AdjustFontStringColor(cd)		
	end
end

--====================================================--
--[[                 -- Update --                   ]]--
--====================================================--
T.RegisterInitCallback(function()
	local methods = getmetatable(ActionButton1Cooldown).__index
		
	hooksecurefunc(methods, "SetCooldown", function(self, start, dur)		
		if self:IsForbidden() then return end
		
		if not self.cooldown_added then
			for i = 1, self:GetNumRegions() do
				local obj = select(i, self:GetRegions())
				if obj:GetObjectType() == "FontString" then
					self.altz_text = obj
					AdjustFontStringSize(self)
					AdjustFontStringColor(self)
					table.insert(cd_frames, self)
					break
				end
			end
			self.cooldown_added = true
		end
	end)
end)

