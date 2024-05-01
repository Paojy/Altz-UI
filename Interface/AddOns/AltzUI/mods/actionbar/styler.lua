local T, C, L, G = unpack(select(2, ...))

local Styled_buttons = {}

local textures = {
	normal= "Interface\\AddOns\\AltzUI\\media\\gloss",
	flash = "Interface\\AddOns\\AltzUI\\media\\flash",
	hover = "Interface\\AddOns\\AltzUI\\media\\hover",
	pushed= "Interface\\AddOns\\AltzUI\\media\\pushed",
	checked = "Interface\\AddOns\\AltzUI\\media\\checked",
}

-- 动作条
local function styleActionButton(bu)
	if not bu then return end
	if not bu.rabs_styled then
		if bu.HotKey then
			bu.HotKey:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["keybindsize"], "OUTLINE")
			bu.HotKey:ClearAllPoints()
			bu.HotKey:SetJustifyH("RIGHT")
			bu.HotKey:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
			bu.HotKey:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
		end
		
		if bu.Name then
			bu.Name:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["macronamesize"], "OUTLINE")
			bu.Name:ClearAllPoints()
			bu.Name:SetJustifyH("LEFT")
			bu.Name:SetPoint("BOTTOMLEFT", bu, "BOTTOMLEFT", 2, 2)	
			bu.Name:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
		end

		if bu.Count then
			bu.Count:SetFont(G.numFont, aCoreCDB["ActionbarOptions"]["countsize"], "OUTLINE")
			bu.Count:ClearAllPoints()
			bu.Count:SetJustifyH("RIGHT")
			bu.Count:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
		end
						
		bu.icon:SetTexCoord( .1, .9, .1, .9)
		bu.icon:SetAllPoints(bu)
		
		bu.cooldown:SetAllPoints(bu)
		
		-- 额外动作条的材质
		if bu.style then
			bu.style:SetAlpha(0)
		end
		
		if bu.IconMask then
			bu.IconMask:Hide()
		end
		
		if bu.Border then
			bu.Border:SetTexture(textures.pushed)
		end
		
		if bu.SlotArt then -- 动作条的背景
			bu.SlotArt:SetTexture(nil)
		end
		
		if bu.SlotBackground then -- 动作条的背景
			bu.SlotBackground:SetTexture(nil)
		end
				
		bu.bg = T.createBackdrop(bu, .7, 2)
		if bu:GetFrameLevel() > 0 then
			bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
		end
					
		local highlight = bu:GetHighlightTexture()
		if highlight then
			bu:SetHighlightTexture(textures.hover)
			highlight:SetAllPoints(bu)
		end

		local check = bu:GetCheckedTexture()
		if check then
			bu:SetCheckedTexture(textures.checked)
			check:SetAllPoints(bu)
		end		

		table.insert(Styled_buttons, bu)
		
		bu.rabs_styled = true
	end
	
	local pushed = bu:GetPushedTexture()
	if pushed then
		bu:SetPushedTexture(textures.pushed)
		pushed:SetAllPoints(bu)
	end		

	local normal = bu:GetNormalTexture()
	if normal then
		bu:SetNormalTexture(textures.normal)
		normal:SetAllPoints(bu)
	end
end

--离开载具
local function styleLeaveButton(bu)
	if not bu or (bu and bu.rabs_styled) then return end
	
	bu:GetNormalTexture():SetTexCoord( .2, .8, .2, .8)
	bu:GetPushedTexture():SetTexCoord( .2, .8, .2, .8)

	bu.rabs_styled = true
end

local function UpdateActionbarsFontSize()
	for i, bu in pairs(Styled_buttons) do
		if bu.HotKey then
			bu.HotKey:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["keybindsize"], "OUTLINE")
		end
		if bu.Name then
			bu.Name:SetFont(G.norFont, aCoreCDB["ActionbarOptions"]["macronamesize"], "OUTLINE")
		end
		if bu.Count then
			bu.Count:SetFont(G.numFont, aCoreCDB["ActionbarOptions"]["countsize"], "OUTLINE")
		end
	end
end
T.UpdateActionbarsFontSize = UpdateActionbarsFontSize
--====================================================--
--[[                  -- Init --                    ]]--
--====================================================--
T.RegisterInitCallback(function()
	for i = 1, 12 do
		local bu = _G["ActionButton"..i]
		hooksecurefunc(bu, "UpdateButtonArt", function(self)
			styleActionButton(bu)
		end)
	end
	
	-- 动作条(8)1-12,OverrideActionBar1~6,ExtraActionButton1,MultiCastActionButton1-12	
	for i, bu in pairs(ActionBarButtonEventsFrame.frames) do
		styleActionButton(bu)
	end
	
	-- 宠物动作条
	for i, bu in pairs(PetActionBar.actionButtons) do
		styleActionButton(bu)
	end
	
	-- 心控动作条
	for i, bu in pairs(PossessActionBar.actionButtons) do
		styleActionButton(bu)
	end
	
	-- 姿态条
	for i, bu in pairs(StanceBar.actionButtons) do
		styleActionButton(bu)
	end

	-- 弹出的动作条按钮
	SpellFlyout.Background.End:SetTexture(nil)
	SpellFlyout.Background.HorizontalMiddle:SetTexture(nil)
	SpellFlyout.Background.VerticalMiddle:SetTexture(nil)
	
	SpellFlyout:HookScript("OnShow", function(self)
		local i = 1
		while _G["SpellFlyoutButton"..i] do
			local bu = _G["SpellFlyoutButton"..i]
			styleActionButton(bu)
			i = i + 1
		end
	end)
	
	styleLeaveButton(OverrideActionBarLeaveFrameLeaveButton)
	styleLeaveButton(MainMenuBarVehicleLeaveButton)	
end)

-- 禁止创建竖线
MainMenuBar.UpdateDividers = nil
MainMenuBar.HorizontalDividersPool:ReleaseAll();
MainMenuBar.VerticalDividersPool:ReleaseAll();

--====================================================--
--[[                 -- Fader --                    ]]--
--====================================================--
local actionbars = {
	"MainMenuBar",
	"MultiBarBottomLeft",
	"MultiBarBottomRight",
	"MultiBarLeft",
	"MultiBarRight",
	"MultiBar5",
	"MultiBar6",
	"MultiBar7",
}

local ApplyActionbarFadeAlpha = function()	
	for i, name in pairs(actionbars) do
		local frame = _G[name]
		if aCoreCDB["ActionbarOptions"]["fadingalpha_type"] == "uf" then
			frame.fadeOut_alpha = aCoreCDB["UnitframeOptions"]["fadingalpha"]
		else
			frame.fadeOut_alpha = aCoreCDB["ActionbarOptions"]["fadingalpha"]
		end
		if aCoreCDB["ActionbarOptions"]["enablefade"] then
			frame:SetAlpha(frame.fadeOut_alpha)
		end
	end
end
T.ApplyActionbarFadeAlpha = ApplyActionbarFadeAlpha

local ApplyActionbarFadeEnable = function()
	for i, name in pairs(actionbars) do
		local frame = _G[name]	
		if aCoreCDB["ActionbarOptions"]["enablefade"] then
			frame.enable_fade = true
			T.RegisterEventFade(frame)
			
			T.UIFrameFadeOut(frame, .4, frame:GetAlpha(), frame.fadeOut_alpha)
		else
			frame.enable_fade = false
			T.UnregisterEventFade(frame)
			
			T.UIFrameFadeIn(frame, .4, frame:GetAlpha(), 1)					
		end		
	end
end
T.ApplyActionbarFadeEnable = ApplyActionbarFadeEnable

T.RegisterInitCallback(function()
	local fade_actionbars = {}
	for i, name in pairs(actionbars) do
		table.insert(fade_actionbars, _G[name])
	end	
	T.ActionbarFader(fade_actionbars)
	
	ApplyActionbarFadeAlpha()
	ApplyActionbarFadeEnable()
end)