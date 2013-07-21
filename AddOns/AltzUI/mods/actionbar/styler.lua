local T, C, L, G = unpack(select(2, ...))

local textures = {
	blank = "Interface\\Buttons\\WHITE8x8",
	normal= "Interface\\AddOns\\AltzUI\\media\\gloss",
	flash = "Interface\\AddOns\\AltzUI\\media\\flash",
	hover = "Interface\\AddOns\\AltzUI\\media\\hover",
	pushed= "Interface\\AddOns\\AltzUI\\media\\pushed",
	checked = "Interface\\AddOns\\AltzUI\\media\\checked",
	equipped= "Interface\\AddOns\\AltzUI\\media\\gloss_grey",
	outer_shadow= "Interface\\AddOns\\AltzUI\\media\\glow",
	}

local color = {
	normal= { r = 0, g = 0, b = 0, },
	equipped= { r = 0, g = 0, b = 0, },
	}

-- glow
local backdrop = {
	bgFile = textures.blank,
	edgeFile = textures.outer_shadow,
	tile = false,
	edgeSize = 3,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

-- border
local backdrop2 = {
	bgFile = textures.blank,
	edgeFile = textures.blank,
	edgeSize = 1,
	insets = {top = 1, left = 1, bottom = 1, right = 1},
}

local function applyBackground(bu)
if bu:GetFrameLevel() < 2 then bu:SetFrameLevel(2) end
	-- glow + background
	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -3, 3)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 3, -3)
	bu.bg:SetFrameLevel(bu:GetFrameLevel()-2)
	bu.bg:SetBackdrop(backdrop)
	bu.bg:SetBackdropColor(0.05, 0.05, 0.05, 0.7)
	bu.bg:SetBackdropBorderColor(0,0,0)
	-- border
	bu.border = CreateFrame("Frame", nil, bu)
	bu.border:SetAllPoints(bu)
	bu.border:SetPoint("TOPLEFT", bu, "TOPLEFT", -1, 1)
	bu.border:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 1, -1)
	bu.border:SetFrameLevel(bu:GetFrameLevel()-1)
	bu.border:SetBackdrop(backdrop2)
	bu.border:SetBackdropColor(0,0,0,0)
	bu.border:SetBackdropBorderColor(0,0,0)
end

--style extraactionbutton
local function styleExtraActionButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ho = _G[name.."HotKey"]
	--remove the style background theme
	bu.style:SetTexture(nil)
	hooksecurefunc(bu.style, "SetTexture", function(self, texture)
		if texture then
			--print("reseting texture: "..texture)
			self:SetTexture(nil)
		end
	end)
	--icon
	bu.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetAllPoints(bu)
	--cooldown
	bu.cooldown:SetAllPoints(bu.icon)
	--hotkey
	ho:Hide()
	--add button normaltexture
	bu:SetNormalTexture(textures.normal)
	local nt = bu:GetNormalTexture()
	nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	nt:SetAllPoints(bu)
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--initial style func
local function styleActionButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local action = bu.action
	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local co= _G[name.."Count"]
	local bo= _G[name.."Border"]
	local ho= _G[name.."HotKey"]
	local cd= _G[name.."Cooldown"]
	local na= _G[name.."Name"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture"]
	local fbg= _G[name.."FloatingBG"]
	local fob = _G[name.."FlyoutBorder"]
	local fobs = _G[name.."FlyoutBorderShadow"]
	if fbg then fbg:Hide() end--floating background
	--flyout border stuff
	if fob then fob:SetTexture(nil) end
	if fobs then fobs:SetTexture(nil) end
	bo:SetTexture(nil) --hide the border (plain ugly, sry blizz)
	--hotkey
	ho:SetFont(G.numFont, aCoreCDB["ActionbarOptions"]["keybindsize"], "OUTLINE")
	ho:ClearAllPoints()
	ho:SetJustifyH("RIGHT")
	ho:SetPoint("LEFT", bu, "TOPLEFT")
	ho:SetPoint("RIGHT", bu, "TOPRIGHT", 2, 2)
	--macroname
	na:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["macronamesize"], "OUTLINE")
	na:ClearAllPoints()
	na:SetJustifyH("LEFT")
	na:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2)
	na:SetPoint("BOTTOMLEFT", bu, "BOTTOMLEFT", -2, -2)
	--count
	co:SetFont(G.numFont, aCoreCDB["ActionbarOptions"]["countsize"], "OUTLINE")
	co:ClearAllPoints()
	co:SetJustifyH("RIGHT")
	co:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2)
	--applying the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)
	if not nt then
		--fix the non existent texture problem (no clue what is causing this)
		nt = bu:GetNormalTexture()
	end
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	--adjust the cooldown frame
	cd:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	--apply the normaltexture
	if action and ( IsEquippedAction(action) ) then
		bu:SetNormalTexture(textures.equipped)
		nt:SetVertexColor(color.equipped.r,color.equipped.g,color.equipped.b,1)
	else
		bu:SetNormalTexture(textures.normal)
		nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	end
	--make the normaltexture match the buttonsize
	nt:SetAllPoints(bu)
	--hook to prevent Blizzard from reseting our colors
	hooksecurefunc(nt, "SetVertexColor", function(nt, r, g, b, a)
		local bu = nt:GetParent()
		local action = bu.action
		--print("bu"..bu:GetName().."R"..r.."G"..g.."B"..b)
		if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
			nt:SetVertexColor(color.equipped.r,color.equipped.g,color.equipped.b, 1)
		elseif r==0.5 and g==0.5 and b==1 then
			nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
		elseif r==1 and g==1 and b==1 then
			nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
		end
	end)
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

local function styleLeaveButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--style pet buttons
local function stylePetButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture2"]
	nt:SetAllPoints(bu)
	--applying color
	nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	--setting the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)
	hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
		--make sure the normaltexture stays the way we want it
		if texture and texture ~= textures.normal then
			self:SetNormalTexture(textures.normal)
		end
	end)
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--style stance buttons
local function styleStanceButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture2"]
	nt:SetAllPoints(bu)
	--applying color
	nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	--setting the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

--style possess buttons
local function stylePossessButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture"]
	nt:SetAllPoints(bu)
	--applying color
	nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	--setting the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)
	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu.rabs_styled = true
end

---------------------------------------
-- INIT
---------------------------------------

local function init()
	--style the actionbar buttons
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		styleActionButton(_G["ActionButton"..i])
		styleActionButton(_G["MultiBarBottomLeftButton"..i])
		styleActionButton(_G["MultiBarBottomRightButton"..i])
		styleActionButton(_G["MultiBarRightButton"..i])
		styleActionButton(_G["MultiBarLeftButton"..i])
	end
	for i = 1, 6 do
		styleActionButton(_G["OverrideActionBarButton"..i])
	end
	--style leave button
	styleLeaveButton(OverrideActionBarLeaveFrameLeaveButton)
	--petbar buttons
	for i=1, NUM_PET_ACTION_SLOTS do
	stylePetButton(_G["PetActionButton"..i])
	end
	--stancebar buttons
	for i=1, NUM_STANCE_SLOTS do
		styleStanceButton(_G["StanceButton"..i])
	end
	--possess buttons
	for i=1, NUM_POSSESS_SLOTS do
		stylePossessButton(_G["PossessButton"..i])
	end
	--extraactionbutton1
	styleExtraActionButton(ExtraActionButton1)
	--spell flyout
	SpellFlyoutBackgroundEnd:SetTexture(nil)
	SpellFlyoutHorizontalBackground:SetTexture(nil)
	SpellFlyoutVerticalBackground:SetTexture(nil)
	local function checkForFlyoutButtons(self)
		local NUM_FLYOUT_BUTTONS = 10
		for i = 1, NUM_FLYOUT_BUTTONS do
			styleActionButton(_G["SpellFlyoutButton"..i])
		end
	end
	SpellFlyout:HookScript("OnShow",checkForFlyoutButtons)
end

-- CALL
local a = CreateFrame("Frame")
a:RegisterEvent("PLAYER_LOGIN")
a:SetScript("OnEvent", init)