local T, C, L, G = unpack(select(2, ...))

local textures = {
	blank = "Interface\\Buttons\\WHITE8x8",
	normal= "Interface\\AddOns\\AltzUI\\media\\gloss",
	flash = "Interface\\AddOns\\AltzUI\\media\\flash",
	hover = "Interface\\AddOns\\AltzUI\\media\\hover",
	pushed= "Interface\\AddOns\\AltzUI\\media\\pushed",
	checked = "Interface\\AddOns\\AltzUI\\media\\checked",
	outer_shadow= "Interface\\AddOns\\AltzUI\\media\\glow",
}

local function applyBackground(bu)
	if bu:GetFrameLevel() < 2 then bu:SetFrameLevel(2) end
	bu.bg = CreateFrame("Frame", nil, bu, "BackdropTemplate")
	bu.bg:SetAllPoints(bu)
	bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 2, -2)
	bu.bg:SetFrameLevel(bu:GetFrameLevel()-2)
	bu.bg:SetBackdrop({
		bgFile = textures.blank,
		edgeFile = textures.outer_shadow,
		tile = false,
		edgeSize = 2,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	bu.bg:SetBackdropColor(0.05, 0.05, 0.05, 0.7)
	bu.bg:SetBackdropBorderColor(0,0,0)
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
	nt:SetAllPoints(bu)
	--apply background
	if not bu.bg then applyBackground(bu) end
	bu:SetScript("OnShow", function()
		bu.bg:SetFrameLevel(bu:GetFrameLevel()-1 >= 0 and bu:GetFrameLevel()-1 or 0)
	end)
	bu.rabs_styled = true
end

local function styleExtraActionButton2(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	
	hooksecurefunc(ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(self)
		for spellButton in self.SpellButtonContainer:EnumerateActive() do
			if spellButton and not spellButton.styled then
				spellButton.NormalTexture:SetAllPoints(spellButton)
				spellButton:SetNormalTexture(textures.normal)
				spellButton:SetPushedTexture(textures.pushed) --force it to gain a texture
				spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				spellButton:GetHighlightTexture():SetTexCoord(0.1,0.9,0.1,0.9)
				spellButton.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
				spellButton.Icon:SetAllPoints(spellButton)
				spellButton.Cooldown:SetAllPoints(spellButton.Icon)
				
				if not spellButton.bg then applyBackground(spellButton) end
				spellButton.styled = true
			end
		end
	end)
	
	bu.rabs_styled = true
end

--动作条
local function styleActionButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	local name = bu:GetName()	
	
	-- 主动作条的背景
	if bu.SlotArt then
		bu.SlotArt:SetTexture(nil)
	end
	
	if bu.RightDivider then
		bu.RightDivider:Hide()
	end
	
	--hotkey
	local ho= _G[name.."HotKey"]	
	ho:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["keybindsize"], "OUTLINE")
	ho:ClearAllPoints()
	ho:SetJustifyH("RIGHT")
	ho:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
	ho:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
	
	--macroname
	local na= _G[name.."Name"]	
	na:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["macronamesize"], "OUTLINE")
	na:ClearAllPoints()
	na:SetJustifyH("LEFT")
	na:SetPoint("BOTTOMLEFT", bu, "BOTTOMLEFT", 2, 2)	
	na:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
	
	--count
	local co= _G[name.."Count"]	
	co:SetFont(G.numFont, aCoreCDB["ActionbarOptions"]["countsize"], "OUTLINE")
	co:ClearAllPoints()
	co:SetJustifyH("RIGHT")
	co:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
	
	--applying the textures
	bu.IconMask:Hide()
	local nt= _G[name.."NormalTexture"]	
	nt:SetTexture(textures.normal)
	local bd = _G[name.."Border"]
	bd:SetTexture(textures.pushed)
	
	bu:SetNormalTexture(textures.normal)
	bu:SetHighlightTexture(textures.hover)
	bu.HighlightTexture:SetAllPoints(bu)	
	bu:SetPushedTexture(textures.pushed)
	bu.PushedTexture:SetAllPoints(bu)	
	bu:SetCheckedTexture(textures.checked)
	bu.CheckedTexture:SetAllPoints(bu)	
	if bu:GetChecked() then bu.CheckedTexture:Show() end
	bu.SlotBackground:SetTexture(nil)
	
	--cut the default border of the icons
	local ic= _G[name.."Icon"]	
	ic:SetTexCoord( .1, .9, .1, .9)
	ic:SetPoint("TOPLEFT", bu,"TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu,"BOTTOMRIGHT", 0, 0)
	
	--adjust frame
	local cd= _G[name.."Cooldown"]	
	cd:SetAllPoints(bu)
	cd:SetPoint("TOPLEFT", bu,"TOPLEFT", 0, 0)
	cd:SetPoint("BOTTOMRIGHT", bu,"BOTTOMRIGHT", 0, 0)
	
	--apply background
	if not bu.bg then applyBackground(bu) end
	
	bu.rabs_styled = true
end

--离开载具
local function styleLeaveButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	
	local nt = bu:GetNormalTexture()
	nt:SetTexCoord( .2, .8, .2, .8)
	local pt = bu:GetPushedTexture()
	pt:SetTexCoord( .2, .8, .2, .8)
	
	--apply background
	if not bu.bg then applyBackground(bu) end
	
	bu.rabs_styled = true
end

---------------------------------------
-- INIT
---------------------------------------
local function init()
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		styleActionButton(_G["ActionButton"..i])
		styleActionButton(_G["MultiBarBottomLeftButton"..i])
		styleActionButton(_G["MultiBarBottomRightButton"..i])
		styleActionButton(_G["MultiBarLeftButton"..i])		
		styleActionButton(_G["MultiBarRightButton"..i])
		styleActionButton(_G["MultiBar5Button"..i])
		styleActionButton(_G["MultiBar6Button"..i])
		styleActionButton(_G["MultiBar7Button"..i])
	end
	
	for i = 1, 6 do
		styleActionButton(_G["OverrideActionBarButton"..i])
	end
	
	MainMenuBar.HorizontalDividersPool:ReleaseAll()
	MainMenuBar.VerticalDividersPool:ReleaseAll()
	
	hooksecurefunc(MainMenuBar, "UpdateDividers", function(self)
		self.HorizontalDividersPool:ReleaseAll()
		self.VerticalDividersPool:ReleaseAll()
	end)

	--petbar buttons
	for i=1, NUM_PET_ACTION_SLOTS do
		styleActionButton(_G["PetActionButton"..i])
	end
	
	--style leave button
	styleLeaveButton(OverrideActionBarLeaveFrameLeaveButton)
	styleLeaveButton(MainMenuBarVehicleLeaveButton)
	
	--stance bar
	hooksecurefunc(StanceBar, "Update", function(self)
		if not ActionBarBusy() then
			for i, button in pairs(StanceBar.actionButtons) do
				styleActionButton(button)
			end
		end
	end)
	
	--possess buttons
	for i=1, NUM_POSSESS_SLOTS do
		styleActionButton(_G["PossessButton"..i])
	end
	
	--extraactionbutton
	styleExtraActionButton(ExtraActionButton1)
	styleExtraActionButton2(ZoneAbilityFrame)
	
	--spell flyout
	SpellFlyout.Background.End:SetTexture(nil)
	SpellFlyout.Background.HorizontalMiddle:SetTexture(nil)
	SpellFlyout.Background.VerticalMiddle:SetTexture(nil)
	
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