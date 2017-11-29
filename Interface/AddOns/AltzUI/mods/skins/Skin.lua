local NAME, addon = ...

local f = CreateFrame("Frame")
local function registerBWStyle()
    if not BigWigs or not aCoreCDB["SkinOptions"]["setBW"] then return end
    local bars = BigWigs:GetPlugin("Bars", true)
    if not bars then return end
    local fontName, fontSize, fontArgs = AltzUISkinFont:GetFont()

    -- based on MonoUI style
    local backdropBorder = {
        bgFile = [[Interface\AddOns\AltzUI\media\statusbar]],
        edgeFile = [[Interface\AddOns\AltzUI\media\glow]],
        tile = false, tileSize = 0, edgeSize = 2,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    }

    local function styleBar(bar)
        --print("styleBar", bar)
        bar:SetHeight(20)
        bar.candyBarBackground:Hide()

        local bd = bar.candyBarBackdrop
        bd:SetBackdrop(backdropBorder)
        bd:SetBackdropColor(0, 0, 0, 0.5)
        bd:SetBackdropBorderColor(0, 0, 0, 1)

        bd:ClearAllPoints()
        bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
        bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
        bd:Show()

        if bars.db.profile.icon then
            local icon = bar.candyBarIconFrame
            local tex = icon.icon
            bar:SetIcon(nil)
            icon:SetTexture(tex)
            icon:ClearAllPoints()
            icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -4, 0)
            icon:SetSize(24, 24)
            icon:Show() -- XXX temp
            bar:Set("bigwigs:restoreIcon", tex)

            local iconBd = bar.candyBarIconFrameBackdrop
            iconBd:SetBackdrop(backdropBorder)
            iconBd:SetBackdropColor(0, 0, 0, 0.5)
            iconBd:SetBackdropBorderColor(0, 0, 0, 1)

            iconBd:ClearAllPoints()
            iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
            iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
            iconBd:Show()
        end

        local label = bar.candyBarLabel
        local font = label:GetFontObject() or {label:GetFont()}
        bar:Set("bigwigs:restoreFont", font)
        local shadow = {label:GetShadowOffset()}
        bar:Set("bigwigs:restoreShadow", shadow)

        label:SetFont(fontName, fontSize, fontArgs)
        label:SetShadowOffset(0, 0)
        label:SetJustifyH("LEFT")
        label:SetJustifyV("BOTTOM")
        label:ClearAllPoints()
        label:SetPoint("LEFT", bar, "LEFT", 4, 0)
        label:SetPoint("RIGHT", bar, "RIGHT", -25, 0)

        local timer = bar.candyBarDuration
        timer:SetFont(fontName, fontSize, fontArgs)
        timer:SetShadowOffset(0, 0)
        timer:SetJustifyH("RIGHT")
        timer:ClearAllPoints()
        timer:SetPoint("RIGHT", bar, "RIGHT", -4, 0)

        bar:SetTexture([[Interface\AddOns\AltzUI\media\statusbar]])
    end

    local function removeStyle(bar)
        bar:SetHeight(14)
        bar.candyBarBackdrop:Hide()
        bar.candyBarBackground:Show()

        local tex = bar:Get("bigwigs:restoreIcon")
        if tex then
            local icon = bar.candyBarIconFrame
            icon:ClearAllPoints()
            icon:SetPoint("TOPLEFT")
            icon:SetPoint("BOTTOMLEFT")
            bar:SetIcon(tex)

            bar.candyBarIconFrameBackdrop:Hide()
        end

        local shadow = bar:Get("bigwigs:restoreShadow")
        local label = bar.candyBarLabel
        label:SetShadowOffset(shadow[1], shadow[2])
        label:ClearAllPoints()
        label:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
        label:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)

        local timer = bar.candyBarDuration
        timer:SetShadowOffset(shadow[1], shadow[2])
        timer:ClearAllPoints()
        timer:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

        local font = bar:Get("bigwigs:restoreFont")
        if type(font) == "table" and font[1] then
            label:SetFont(font[1], floor(font[2] + 0.5), font[3])
            timer:SetFont(font[1], floor(font[2] + 0.5), font[3])
        else
            label:SetFontObject(font)
            timer:SetFontObject(font)
        end
    end

    bars:RegisterBarStyle("AltzUI", {
        apiVersion = 1,
        version = 1,
        GetSpacing = function(bar) return 8 end,
        ApplyStyle = styleBar,
        BarStopped = removeStyle,
        GetStyleName = function() return "AltzUI" end,
    })
end

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
