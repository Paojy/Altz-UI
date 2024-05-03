local T, C, L, G = unpack(select(2, ...))

local glowTex = "Interface\\AddOns\\AltzUI\\media\\glow"
local bgTex = "Interface\\AddOns\\AltzUI\\media\\statusbar"

local function removeStyle(bar)
	local cbb = bar.candyBarBar

	bar.candyBarBackdrop:Hide()
	local height = bar:Get("bigwigs:restoreheight")
	if height then
		bar:SetHeight(height)
	end

	local tex = bar:Get("bigwigs:restoreicon")
	if tex then
		bar:SetIcon(tex)
		bar:Set("bigwigs:restoreicon", nil)
		bar.candyBarIconFrameBackdrop:Hide()
	end

	local timer = bar.candyBarDuration
	timer:ClearAllPoints()
	timer:SetPoint("TOPLEFT", cbb, "TOPLEFT", 2, 0)
	timer:SetPoint("BOTTOMRIGHT", cbb, "BOTTOMRIGHT", -2, 0)
	
	local label = bar.candyBarLabel
	label:ClearAllPoints()
	label:SetPoint("TOPLEFT", cbb, "TOPLEFT", 2, 0)
	label:SetPoint("BOTTOMRIGHT", cbb, "BOTTOMRIGHT", -2, 0)
end

local function styleBar(bar)
	local cbb = bar.candyBarBar

	local height = bar:GetHeight()
	bar:Set("bigwigs:restoreheight", height)
	bar:SetHeight(height)

	local bd = bar.candyBarBackdrop
	T.setBackdrop(bd, .4)
	bd:ClearAllPoints()
	bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
	bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
	bd:Show()

	local tex = bar:GetIcon()
	if tex then
		local icon = bar.candyBarIconFrame
		bar:SetIcon(nil)
		icon:SetTexture(tex)
		icon:Show()
		if bar.iconPosition == "RIGHT" then
			icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
		else
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
		end
		icon:SetSize(height, height)
		bar:Set("bigwigs:restoreicon", tex)

		local iconBd = bar.candyBarIconFrameBackdrop
		T.setBackdrop(iconBd, .4)
		iconBd:ClearAllPoints()
		iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -3, 3)
		iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 3, -3)
		iconBd:Show()
	end
	
	local label = bar.candyBarLabel
	label:SetFont(G.norFont, 12, "OUTLINE")
    label:SetShadowOffset(0, 0)
    label:ClearAllPoints()
    label:SetPoint("LEFT", bar, "LEFT", 4, 0)
    label:SetPoint("RIGHT", bar, "RIGHT", -25, 0)
	
	local timer = bar.candyBarDuration
    timer:SetFont(G.norFont, 12, "OUTLINE")
    timer:SetShadowOffset(0, 0)
    timer:SetJustifyH("RIGHT")
    timer:ClearAllPoints()
    timer:SetPoint("RIGHT", bar, "RIGHT", -4, 0)
	
	bar:SetTexture(bgTex)
end

if BigWigsAPI then
	BigWigsAPI:RegisterBarStyle("AltzUI", {
		apiVersion = 1,
		version = 11,
		barSpacing = 5,
		barHeight = 20,	
		fontSizeNormal = 16,
		fontSizeEmphasized = 16,
		fontOutline = "OUTLINE",
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "AltzUI" end,
	})
end