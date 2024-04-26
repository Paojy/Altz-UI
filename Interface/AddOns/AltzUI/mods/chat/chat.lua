local T, C, L, G = unpack(select(2, ...))

local chatwindownum = NUM_CHAT_WINDOWS

local ChatFrameTexturesDefualt = {}
local function BackupChatFrameBg()
	for i = 1, chatwindownum do
		if not ChatFrameTexturesDefualt[i] then
			ChatFrameTexturesDefualt[i] = {}
		end
		for g = 1, #CHAT_FRAME_TEXTURES do
			ChatFrameTexturesDefualt[i][g] = _G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:GetTexture()
		end
	end
end

local function UpdateChatFrameBg()
	if aCoreCDB["ChatOptions"]["showbg"] then
		for i = 1, chatwindownum do
			for g = 1, #CHAT_FRAME_TEXTURES do
				_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(ChatFrameTexturesDefualt[i][g])
			end
		end
	else
		for i = 1, chatwindownum do
			for g = 1, #CHAT_FRAME_TEXTURES do
				_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
			end
		end
	end
end
T.UpdateChatFrameBg = UpdateChatFrameBg

local function init()
	for i = 1, chatwindownum do
		local cf = _G['ChatFrame'..i]

		-- 隐藏按钮
		local bf = cf.buttonFrame
		if bf then 
			bf:Hide() 
			bf:HookScript("OnShow", function(s) s:Hide(); end)
		end
		
		-- 输入框样式
		local eb = cf.editBox
		
		local ebtl = _G['ChatFrame'..i..'EditBoxLeft']
		if ebtl then ebtl:Hide() end
		local ebtm = _G['ChatFrame'..i..'EditBoxMid']
		if ebtm then ebtm:Hide() end
		local ebtr = _G['ChatFrame'..i..'EditBoxRight']
		if ebtr then ebtr:Hide() end
		
		local language = _G['ChatFrame'..i..'EditBoxLanguage']
		language.Show = language.Hide 
		language:Hide()
		
		local tex = {eb:GetRegions()}
		tex[6]:SetAlpha(0)
		tex[7]:SetAlpha(0)
		tex[8]:SetAlpha(0)
		
		eb.backdrop = T.createBackdrop(eb, .3)
		
		eb:SetScript("OnEditFocusLost", function(self)
			self:SetAlpha(0)
		end)

		-- 输入框位置
		if eb and cf then
			cf:SetClampedToScreen(false)
			eb:SetAltArrowKeyMode(false)
			eb:ClearAllPoints()
			if i ~= 2 then
				eb:SetPoint("TOPLEFT",cf,"TOPLEFT", -2, 55)
				eb:SetPoint("BOTTOMRIGHT",cf,"TOPRIGHT", 14, 32)
			else
				eb:SetPoint("TOPLEFT",CombatLogQuickButtonFrame_Custom,"TOPLEFT", -2, 52)
				eb:SetPoint("BOTTOMRIGHT",CombatLogQuickButtonFrame_Custom,"TOPRIGHT", 6, 29)	
			end
		end
		
		-- 聊天字体
		if cf then 
			cf:SetFont(G.norFont, select(2, cf:GetFont()), "OUTLINE") 
			cf:SetShadowOffset(0,0)
			cf:SetFrameStrata("LOW")
			cf:SetFrameLevel(2)
		end
		
		-- 标签
		local tab = _G['ChatFrame'..i..'Tab']
		if tab then
			tab:GetFontString():SetFont(G.norFont, 13, "THINOUTLINE")
			tab:GetFontString():SetShadowOffset(0,0)
			if i ~= 11 then
				tab.selectedColorTable = { r = G.Ccolor.r, g = G.Ccolor.g, b = G.Ccolor.b };
				tab:SetAlpha(1)
			end
			
			tab.Middle:SetTexture(nil)
			tab.Left:SetTexture(nil)
			tab.Right:SetTexture(nil)
			tab.ActiveLeft:SetTexture(nil)
			tab.ActiveMiddle:SetTexture(nil)
			tab.ActiveRight:SetTexture(nil)
			tab.glow:SetTexture(nil)
			tab.HighlightLeft:SetTexture(nil)
			tab.HighlightMiddle:SetTexture(nil)
			tab.HighlightRight:SetTexture(nil)
			
		end
		tab:HookScript("OnClick", function(self)
			eb:SetAlpha(0)
		end)
	end
	UpdateChatFrameBg()
end

BNToastFrame:SetClampedToScreen(true)

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PET_BATTLE_OPENING_START")

local function SetChatTabs()
	for i = 11, 20 do
		-- chat tabs
		local tab = _G['ChatFrame'..i..'Tab']
		if tab and not tab.skinned then
			tab.skinned = true
			tab:GetFontString():SetFont(G.norFont, 13, "THINOUTLINE")
			tab:GetFontString():SetShadowOffset(0,0)
			if i ~= 11 then
				tab.selectedColorTable = { r = G.Ccolor.r, g = G.Ccolor.g, b = G.Ccolor.b };
				tab:SetAlpha(1)
			end		
			
			tab.Middle:SetTexture(nil)
			tab.Left:SetTexture(nil)
			tab.Right:SetTexture(nil)
			tab.ActiveLeft:SetTexture(nil)
			tab.ActiveMiddle:SetTexture(nil)
			tab.ActiveRight:SetTexture(nil)
			tab.HighlightLeft:SetTexture(nil)
			tab.HighlightMiddle:SetTexture(nil)
			tab.HighlightRight:SetTexture(nil)
		end
	end
end

hooksecurefunc("FCF_OpenTemporaryWindow", SetChatTabs)

EventFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" then
		CHAT_FRAME_FADE_OUT_TIME = 1
		CHAT_TAB_HIDE_DELAY = 1
		CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
		CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = .3
		CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
		CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = .3
		CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
		CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = .3
		
		BackupChatFrameBg()
		init()
	elseif event == "PET_BATTLE_OPENING_START" then
		chatwindownum = 11
		init()
		EventFrame:UnregisterEvent("PET_BATTLE_OPENING_START")
	end
end)

T.createBackdrop(GeneralDockManagerOverflowButtonList, .5)

function FloatingChatFrame_OnMouseScroll(self, delta)
	if ( delta > 0 ) then
		if IsModifierKeyDown() then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	else
		if IsModifierKeyDown() then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end

QuickJoinToastButton:ClearAllPoints()
QuickJoinToastButton:SetPoint("BOTTOMLEFT", ChatFrame1.editBox, "TOPLEFT", 5, 5)
QuickJoinToastButton.SetPoint = function() end
T.FrameFader(QuickJoinToastButton)

ChatAlertFrame:ClearAllPoints()
ChatAlertFrame:SetPoint("BOTTOMLEFT", QuickJoinToastButton, "TOPLEFT", 0, 20)

