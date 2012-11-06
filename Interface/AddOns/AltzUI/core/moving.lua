local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

-- align
local align = CreateFrame('Frame', nil, UIParent)
align:SetAllPoints(UIParent)
align:Hide()

local width = G.screenwidth/10
if width > 100 then width = G.screenwidth/20 end

local h = math.floor(G.screenheight/width)
local w = math.floor(G.screenwidth/width)

for i = 0, h do
	local line = align:CreateTexture(nil, 'BACKGROUND')
	line:SetTexture(0, 0.8, 1, 0.5)
	line:SetPoint("TOPLEFT", CSG, "TOPLEFT", 0, -width*i)
	line:SetPoint('BOTTOMRIGHT', CSG, 'TOPRIGHT', 0, -width*i - 2)
end

for i = 0, w do
	local line2 = align:CreateTexture(nil, 'BACKGROUND')
	line2:SetTexture(0, 0.8, 1, 0.5)
	line2:SetPoint("TOPLEFT", CSG, "TOPLEFT", width*i, 0)
	line2:SetPoint('BOTTOMRIGHT', CSG, 'BOTTOMLEFT', width*i + 2, 0)
end
--

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
	df:Hide()
	--overlay texture
	local mask = F.CreateBDFrame(df, 0.5)
	F.CreateSD(mask, 2, 0, 0, 0, 1, -1)
	mask.text = T.createtext(df, "OVERLAY", 13, "OUTLINE", "RIGHT")
	mask.text:SetPoint"TOPRIGHT"
	mask.text:SetText(self.movingname)
	--self stuff
	self.dragFrame = df
	self:SetClampedToScreen(clamp or false)
	self:SetMovable(true)
	self:SetUserPlaced(true)
end

local function slashCmdFunction(cmd)
      if cmd:match"unlock" then
        UnlockAllFrames(G.dragFrameList, "|cff00FF00"..L["to unlock"].."|r")
		align:Show()
      elseif cmd:match"lock" then
        LockAllFrames(G.dragFrameList, "|cffFF0000"..L["to lock"].."|r")
		align:Hide()
      elseif cmd:match"reset" then
        ResetAllFramesToDefault(G.dragFrameList, "|cff00FFFF"..L["to reset"].."|r")
		align:Hide()
      else
        print("|cffEEEE00Moving Command List:|r")
        print("|cffFF1493/altz lock|r, "..L["to lock"])
        print("|cffFF1493/altz unlock|r, "..L["to unlock"])
        print("|cffFF1493/altz reset|r, "..L["to reset"])
    end
end

SlashCmdList["altz"] = slashCmdFunction
SLASH_altz1 = "/altz"

-- attach reset position to reset button.
local resetbutton = _G["AltzUIResetButton"]
local resetgui = _G["AltzUI Reset Frame"]

local resetposbutton = CreateFrame("Button", "AltzUIResetPosButton", resetgui, "UIPanelButtonTemplate")
resetposbutton:SetPoint("RIGHT",resetbutton, "LEFT", -10, 0)
resetposbutton:SetSize(150, 25)
resetposbutton:SetText(L["resetallpos"])
F.Reskin(resetposbutton)
resetposbutton:SetScript("OnClick", function()
   ResetAllFramesToDefault(G.dragFrameList, "|cff00FFFF"..L["to reset"].."|r")
end)