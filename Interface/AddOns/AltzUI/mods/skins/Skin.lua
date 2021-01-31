local NAME, addon = ...

local glowTex = "Interface\\AddOns\\AltzUI\\media\\glow"
local bgTex = "Interface\\AddOns\\AltzUI\\media\\statusbar"

local backdropBorder = {
	bgFile = bgTex,
	edgeFile = glowTex,
	tile = false, tileSize = 0, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local floor = floor
local fontName, fontSize, fontArgs = AltzUISkinFont:GetFont()

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
	bd:SetBackdrop(backdropBorder)
	bd:SetBackdropColor(0, 0, 0, .4)
	bd:SetBackdropBorderColor(0, 0, 0, 1)
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
		icon:SetSize(height+2, height+2)
		bar:Set("bigwigs:restoreicon", tex)

		local iconBd = bar.candyBarIconFrameBackdrop
		iconBd:SetBackdrop(backdropBorder)
		iconBd:SetBackdropColor(.15, .15, .15, .4)
		iconBd:SetBackdropBorderColor(0, 0, 0, 1)
		iconBd:ClearAllPoints()
		iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -3, 3)
		iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 3, -3)
		iconBd:Show()
	end
	
	local label = bar.candyBarLabel
	label:SetFont(fontName, fontSize, fontArgs)
    label:SetShadowOffset(0, 0)
    label:ClearAllPoints()
    label:SetPoint("LEFT", bar, "LEFT", 4, 0)
    label:SetPoint("RIGHT", bar, "RIGHT", -25, 0)
	
	local timer = bar.candyBarDuration
    timer:SetFont(fontName, fontSize, fontArgs)
    timer:SetShadowOffset(0, 0)
    timer:SetJustifyH("RIGHT")
    timer:ClearAllPoints()
    timer:SetPoint("RIGHT", bar, "RIGHT", -4, 0)
	
	bar:SetTexture(bgTex)
end

BigWigsAPI:RegisterBarStyle("AltzUI", {
	apiVersion = 1,
	version = 11,
	barSpacing = 24,
	barHeight = 24,	
	fontSizeNormal = 22,
	fontSizeEmphasized = 22,
	fontOutline = "OUTLINE",
	ApplyStyle = styleBar,
	BarStopped = removeStyle,
	GetStyleName = function() return "AltzUI" end,
})


local f = CreateFrame("Frame")

local function registerDBMStyle()
    if not DBM or not aCoreCDB["SkinOptions"]["setDBM"] then return end
    local skin = DBT:RegisterSkin("AltzUI")

    skin.defaults = {
        Skin = "AltzUI",
        Template = "AltzUISkinTimerTemplate",
        Texture = "Interface\\Buttons\\WHITE8x8",
        FillUpBars = false,
        IconLocked = false,

        Font = "", --If this has any set font it will override the XML font template, so it needs to be blank.
        FontSize = 14,
		IconLeft = true,
		IconRight = false,	

		Height = 20,
		Width = 183,
		Scale = 1,
		BarXOffset = 0,
		BarYOffset = 3,
	
		HugeScale = 1,
		HugeWidth = 200,
		HugeBarXOffset = 0,
		HugeBarYOffset = 3,
    }
	
    if DBM.Bars.options.Texture:find("DBM") then
        DBM.Bars.options.Texture = skin.defaults.Texture
    end

    if DBM.Bars.options.Template ~= skin.defaults.Template then
        --only set the skin if it isn't already set.
       DBM.Bars:SetSkin("AltzUI")
	end
end

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ADDON_LOADED")
local reason

f:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		if IsAddOnLoaded("DBM-Core") then
			registerDBMStyle()
		end
	elseif event == "ADDON_LOADED" then
		if not reason then reason = (select(6, GetAddOnInfo("BigWigs_Plugins"))) end
		if (reason == "MISSING" and addon == "BigWigs") or addon == "BigWigs_Plugins" then
			registerBWStyle()
		end
	end
end)
