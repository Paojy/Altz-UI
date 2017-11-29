-- Range by Tuller, modified by Haleth
local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ActionbarOptions"]["rangecolor"] then return end

local IsUsableAction = IsUsableAction
local IsActionInRange = IsActionInRange
local ActionHasRange = ActionHasRange

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: TOOLTIP_UPDATE_TIME

local EventFrame =  CreateFrame("Frame")

function EventFrame:RangeOnUpdate()
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

	local IsUsable, NotEnoughMana = IsUsableAction(ID)
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
	elseif NotEnoughMana then -- Not enough power
		Icon:SetVertexColor(0.1, 0.3, 1.0)
		NormalTexture:SetVertexColor(0.1, 0.3, 1.0)
	else -- Not usable
		Icon:SetVertexColor(0.3, 0.3, 0.3)
		NormalTexture:SetVertexColor(0.3, 0.3, 0.3)
	end
end

hooksecurefunc("ActionButton_OnUpdate", EventFrame.RangeOnUpdate)
hooksecurefunc("ActionButton_Update", EventFrame.RangeUpdate)
hooksecurefunc("ActionButton_UpdateUsable", EventFrame.RangeUpdate)