local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

if not aCoreCDB["UnitframeOptions"]["totems"] then return end

local TotemBar = CreateFrame("Frame", "AltzUI_TotemBar", UIParent)
TotemBar.movingname = L["图腾条"]
TotemBar.point = {
	healer = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 5, y = 223},
	dpser = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 5, y = 223},
}
T.CreateDragFrame(TotemBar) --frame, dragFrameList, inset, clamp

for i=1, MAX_TOTEMS do
	local TotemBu = CreateFrame("Button", TotemBar:GetName().."Totem"..i, TotemBar)
	TotemBu:SetID(i)
	T.CreateSD(TotemBu, 2, 0, 0, 0, 0, -1)
	TotemBu:Hide()

	TotemBu.holder = CreateFrame("Frame", nil, TotemBu)
	TotemBu.holder:SetAlpha(0)
	TotemBu.holder:SetAllPoints()

	TotemBu.iconTexture = TotemBu:CreateTexture(nil, "ARTWORK")
	TotemBu.iconTexture:SetAllPoints()
	TotemBu.iconTexture:SetTexCoord(0.1,0.9,0.1,0.9)

	TotemBu.cooldown = CreateFrame("Cooldown", TotemBu:GetName().."Cooldown", TotemBu, "CooldownFrameTemplate")
	TotemBu.cooldown:SetReverse(true)
	TotemBu.cooldown:SetAllPoints()
	TotemBar[i] = TotemBu
	
end

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

TotemBar:SetScript("OnEvent", function()
	local totemName, button, startTime, duration, icon
	for i=1, MAX_TOTEMS do
		button = _G["TotemFrameTotem"..i];
		haveTotem, totemName, startTime, duration, icon = GetTotemInfo(button.slot)
		
		if button:IsShown() then
			TotemBar[i]:Show()
			TotemBar[i].iconTexture:SetTexture(icon)
			CooldownFrame_Set(TotemBar[i].cooldown, startTime, duration, 1)

			button:ClearAllPoints();
			button:SetParent(TotemBar[i].holder);
			button:SetAllPoints(TotemBar[i].holder);
		else
			TotemBar[i]:Hide()
		end
	end
end)

TotemBar:RegisterEvent("PLAYER_TOTEM_UPDATE")
TotemBar:RegisterEvent("PLAYER_ENTERING_WORLD")