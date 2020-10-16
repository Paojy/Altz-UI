-- Range by Tuller, modified by Haleth
local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ActionbarOptions"]["rangecolor"] then return end

local _G = _G
local EventFrame =  CreateFrame("Frame")
local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local ActionHasRange = ActionHasRange
local HasAction = HasAction

function EventFrame:RangeOnUpdate(elapsed)
	if (not self.rangeTimer) then
		return
	end

	if ( self.rangeTimer == TOOLTIP_UPDATE_TIME ) then
		EventFrame.RangeUpdate(self)
	end
end

function EventFrame:RangeUpdate()
	--print(self:GetName())
	local Icon = self.icon
	local NormalTexture = self.NormalTexture
    local ID = self.action
	
	if not ID then return end

	local IsUsable = IsUsableAction(ID)
	local HasRange = ActionHasRange(ID)
	local InRange = IsActionInRange(ID)

	if IsUsable then -- Usable
		if (HasRange and InRange == false) then -- Out of range
			Icon:SetVertexColor(0.8, 0.1, 0.1)
			NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
		else -- In range
			Icon:SetVertexColor(1.0, 1.0, 1.0)
			NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end

hooksecurefunc("ActionButton_UpdateRangeIndicator", EventFrame.RangeUpdate)