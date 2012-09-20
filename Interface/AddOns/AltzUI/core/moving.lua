local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local function GetPoint(self)
	local point = {}
	point.a1, point.af, point.a2, point.x, point.y = self:GetPoint()
	if point.af and point.af:GetName() then
		point.af = point.af:GetName()
	end
	return point
end

local function ResetToPoint(self, point)
	if InCombatLockdown() then return end
	self:ClearAllPoints()
	if point.af and point.a2 then
		self:SetPoint(point.a1 or "CENTER", point.af, point.a2, point.x or 0, point.y or 0)
	elseif point.af then
		self:SetPoint(point.a1 or "CENTER", point.af, point.x or 0, point.y or 0)
	else
		self:SetPoint(point.a1 or "CENTER", point.x or 0, point.y or 0)
	end
end

local function ResetToDefaultPoint(self)
	if InCombatLockdown() then return end
	ResetToPoint(self, self.defaultPoint)
end

local function UnlockFrame(self)
	if not self:IsUserPlaced() then return end
	if not self:IsShown() then
		self.visibilityState = false
		if not InCombatLockdown() then --impossible for protected frames
			self:Show()
		end
	else
		self.visibilityState = true
	end
	self.opacityValue = self:GetAlpha()
	self:SetAlpha(1)
	self.dragFrame:Show()
end

local function LockFrame(self)
	if not self:IsUserPlaced() then return end
	self.dragFrame:Hide()
	if self.opacityValue then
		self:SetAlpha(self.opacityValue)
	end
	if not self.visibilityState then
		if not InCombatLockdown() then --impossible for protected frames
			self:Hide()
		end
	end
end

local function UnlockAllFrames(dragFrameList, txt)
	if not dragFrameList then return end
	if txt then print(txt) end
	for _, frame in pairs(dragFrameList) do
		UnlockFrame(frame)
	end
end

local function LockAllFrames(dragFrameList,txt)
	if not dragFrameList then return end
	if txt then print(txt) end
	for _, frame in pairs(dragFrameList) do
		LockFrame(frame)
	end
end

local function ResetAllFramesToDefault(dragFrameList,txt)
	if not dragFrameList then return end
	if txt then print(txt) end
	for _, frame in pairs(dragFrameList) do
		ResetToDefaultPoint(frame)
	end
end

function T.CreateDragFrame(self, dragFrameList, inset, clamp)
	if not self or not dragFrameList then return end
	--save the default position for later
	self.defaultPoint = GetPoint(self)
	table.insert(dragFrameList, self) --add frame object to the list
	--anchor a dragable frame on self
	local df = CreateFrame("Frame",nil,self)
	df:SetAllPoints(self)
	df:SetFrameStrata("HIGH")
	df:SetHitRectInsets(inset or 0,inset or 0,inset or 0,inset or 0)
	df:EnableMouse(true)
	df:RegisterForDrag("LeftButton")
	df:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	df:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
	df:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(self:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
		GameTooltip:Show()
	end)
	df:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
	df:Hide()
	--overlay texture
	F.SetBD(df)
	--self stuff
	self.dragFrame = df
	self:SetClampedToScreen(clamp or false)
	self:SetMovable(true)
	self:SetUserPlaced(true)
end

local function slashCmdFunction(cmd)
      if cmd:match"unlock" then
        UnlockAllFrames(G.dragFrameList, "Frames unlocked")
      elseif cmd:match"lock" then
        LockAllFrames(G.dragFrameList, "Frames locked")
      elseif cmd:match"reset" then
        ResetAllFramesToDefault(G.dragFrameList, "Frames reseted")
      else
        print("|cffE066FFMoving Command List:|r")
        print("|cffE066FF/altz lock|r, to lock all frames")
        print("|cffE066FF/altz unlock|r, to unlock all frames")
        print("|cffE066FF/altz reset|r, to reset all frames")
    end
end

SlashCmdList["altz"] = slashCmdFunction
SLASH_altz1 = "/altz"