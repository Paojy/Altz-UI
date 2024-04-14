local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local TotemBar = CreateFrame("Frame", "AltzUI_TotemBar", UIParent)
TotemBar.movingname = L["图腾条"]
TotemBar.point = {
	healer = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 270},
	dpser = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 270},
}
T.CreateDragFrame(TotemBar) --frame, dragFrameList, inset, clamp

for i=1, MAX_TOTEMS do
	local TotemBu = CreateFrame("Button", TotemBar:GetName().."Totem"..i, TotemBar)
	T.CreateSD(TotemBu, 2, 0, 0, 0, 0, 0)
	TotemBu:Hide()

	TotemBu.iconTexture = TotemBu:CreateTexture(nil, "ARTWORK")
	TotemBu.iconTexture:SetAllPoints()
	TotemBu.iconTexture:SetTexCoord(0.1,0.9,0.1,0.9)

	TotemBu.cooldown = CreateFrame("Cooldown", TotemBu:GetName().."Cooldown", TotemBu, "CooldownFrameTemplate")
	TotemBu.cooldown:SetReverse(true)
	TotemBu.cooldown:SetAllPoints()
	TotemBar[i] = TotemBu
end

local function Update(self)
	local totemName, button, startTime, duration, icon
	for i=1, MAX_TOTEMS do
		local _, class = UnitClass("player")
		local priorities = STANDARD_TOTEM_PRIORITIES
		if (class == "SHAMAN") then
			priorities = SHAMAN_TOTEM_PRIORITIES
		end	
	
		local haveTotem, name, startTime, duration, icon
		local slot
		self.activeTotems = 0
		
		for i=1, MAX_TOTEMS do
			slot = priorities[i]
			haveTotem, name, startTime, duration, icon = GetTotemInfo(slot)
			if ( haveTotem ) then
				TotemBar[i]:Show()
				TotemBar[i].iconTexture:SetTexture(icon)
				CooldownFrame_Set(TotemBar[i].cooldown, startTime, duration, 1)
				self.activeTotems = self.activeTotems + 1
			else
				TotemBar[i]:Hide()
			end
		end
		if ( self.activeTotems > 0 ) then
			self:Show();
		else
			self:Hide();
		end
	end
end

TotemBar:SetScript("OnEvent", function(self)
	Update(self)
end)

T.ApplyTotemsBarSettings = function()
	for i=1, MAX_TOTEMS do
		local button = TotemBar[i]
		local prevButton = TotemBar[i-1]
			
		button:SetSize(aCoreCDB["UnitframeOptions"]["totemsize"], aCoreCDB["UnitframeOptions"]["totemsize"])
		button:ClearAllPoints()
			
		if aCoreCDB["UnitframeOptions"]["growthDirection"] == "HORIZONTAL" and aCoreCDB["UnitframeOptions"]["sortDirection"] == "ASCENDING" then
			if i == 1 then
				button:SetPoint("LEFT", TotemBar, "LEFT", 5, 0)
			elseif prevButton then
				button:SetPoint("LEFT", prevButton, "RIGHT", 5, 0)
			end
		elseif aCoreCDB["UnitframeOptions"]["growthDirection"] == "VERTICAL" and aCoreCDB["UnitframeOptions"]["sortDirection"] == "ASCENDING" then
			if i == 1 then
				button:SetPoint("TOP", TotemBar, "TOP", 0, -5)
			elseif prevButton then
				button:SetPoint("TOP", prevButton, "BOTTOM", 0, -5)
			end
		elseif aCoreCDB["UnitframeOptions"]["growthDirection"] == "HORIZONTAL" and aCoreCDB["UnitframeOptions"]["sortDirection"] == "DESCENDING" then
			if i == 1 then
				button:SetPoint("RIGHT", TotemBar, "RIGHT", -5, 0)
			elseif prevButton then
				button:SetPoint("RIGHT", prevButton, "LEFT", -5, 0)
			end
		else
			if i == 1 then
				button:SetPoint("BOTTOM", TotemBar, "BOTTOM", 0, 5)
			elseif prevButton then
				button:SetPoint("BOTTOM", prevButton, "TOP", 0, 5)
			end
		end
	end
	
	if aCoreCDB["UnitframeOptions"]["growthDirection"] == "HORIZONTAL" then
		TotemBar:SetWidth(aCoreCDB["UnitframeOptions"]["totemsize"]*(MAX_TOTEMS) + 5*(MAX_TOTEMS) + 5)
		TotemBar:SetHeight(aCoreCDB["UnitframeOptions"]["totemsize"] + 5*2)
	else
		TotemBar:SetHeight(aCoreCDB["UnitframeOptions"]["totemsize"]*(MAX_TOTEMS) + 5*(MAX_TOTEMS) + 5)
		TotemBar:SetWidth(aCoreCDB["UnitframeOptions"]["totemsize"] + 5*2)
	end
	
	if aCoreCDB["UnitframeOptions"]["totems"] then
		TotemBar:Show()
		T.RestoreDragFrame(TotemBar)
		TotemBar:RegisterEvent("PLAYER_TOTEM_UPDATE")
		TotemBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	else
		TotemBar:Hide()
		T.ReleaseDragFrame(TotemBar)
		TotemBar:UnregisterAllEvents()
	end
end

T.RegisterInitCallback(T.ApplyTotemsBarSettings)