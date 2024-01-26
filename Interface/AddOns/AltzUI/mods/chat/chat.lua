local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local TAB_TEXTURES = {
	"Left",
	"Middle",
	"Right",
	"SelectedLeft",
	"SelectedMiddle",
	"SelectedRight",
	"Glow",
	"HighlightLeft",
	"HighlightMiddle",
	"HighlightRight",
}

local chatwindownum = NUM_CHAT_WINDOWS

local function init()
	for i = 1, chatwindownum do
		-- hide button on the left
		local bf = _G['ChatFrame'..i..'ButtonFrame']
		if bf then 
			bf:Hide() 
			bf:HookScript("OnShow", function(s) s:Hide(); end)
		end
		-- hide things on edit box
		local ebtl = _G['ChatFrame'..i..'EditBoxLeft']
		if ebtl then ebtl:Hide() end
		local ebtm = _G['ChatFrame'..i..'EditBoxMid']
		if ebtm then ebtm:Hide() end
		local ebtr = _G['ChatFrame'..i..'EditBoxRight']
		if ebtr then ebtr:Hide() end
		_G['ChatFrame'..i..'EditBoxLanguage'].Show = _G['ChatFrame'..i..'EditBoxLanguage'].Hide 
		_G['ChatFrame'..i..'EditBoxLanguage']:Hide()
		local tex = ({_G['ChatFrame'..i..'EditBox']:GetRegions()})
		tex[6]:SetAlpha(0)
		tex[7]:SetAlpha(0)
		tex[8]:SetAlpha(0)
		-- make a new backdrop on edit box
		F.SetBD(_G['ChatFrame'..i..'EditBox'])
		-- chat font
		local cf = _G['ChatFrame'..i]
		if cf then 
			cf:SetFont(G.norFont, select(2, cf:GetFont()), "OUTLINE") 
			cf:SetShadowOffset(0,0)
			cf:SetFrameStrata("LOW")
			cf:SetFrameLevel(2)
		end
		-- remove chat frame backdrop
		if not aCoreCDB["ChatOptions"]["showbg"] then
			for g = 1, #CHAT_FRAME_TEXTURES do
				_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
			end
		end
		-- place edit box
		local eb = _G['ChatFrame'..i..'EditBox']
		if eb and cf then
			cf:SetClampedToScreen(false)
			eb:SetAltArrowKeyMode(false)
			eb:ClearAllPoints()
			if i ~= 2 then
				eb:SetPoint("TOPLEFT",cf,"TOPLEFT", 10, 55)
				eb:SetPoint("BOTTOMRIGHT",cf,"TOPRIGHT", -3, 32)
			else
				eb:SetPoint("TOPLEFT",CombatLogQuickButtonFrame_Custom,"TOPLEFT", 10, 52)
				eb:SetPoint("BOTTOMRIGHT",CombatLogQuickButtonFrame_Custom,"TOPRIGHT", -3, 29)	
			end
			eb:Hide()
		end
		-- chat tabs
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
			tab.HighlightLeft:SetTexture(nil)
			tab.HighlightMiddle:SetTexture(nil)
			tab.HighlightRight:SetTexture(nil)
		end
		-- hide scroll bar
		local button = _G['ChatFrame'..i].ScrollToBottomButton
		if button then
			button:SetAlpha(0)
		end
		local thumbtexture = _G['ChatFrame'..i.."ThumbTexture"]
		if thumbtexture then
			thumbtexture:SetTexture(nil)	
		end
	end
end

BNToastFrame:SetClampedToScreen(true)

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
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
			
			for index, value in pairs(TAB_TEXTURES) do
				local texture = _G['ChatFrame'..i..'Tab'..value]
				if texture then
					texture:SetTexture(nil)
				end
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
	if event == "ADDON_LOADED" and arg1 == "Blizzard_CombatLog" then
		--local topbar = _G["CombatLogQuickButtonFrame_Custom"]
		--if not topbar then return end
		--topbar:Hide()
		--topbar:HookScript("OnShow", function(self) topbar:Hide() end)
		--topbar:SetHeight(0)
	elseif event == "PLAYER_LOGIN" then
		--CHAT_FRAME_FADE_OUT_TIME = 1
		--CHAT_TAB_HIDE_DELAY = 1
		CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = aCoreCDB["ChatOptions"]["chattab_fade_maxalpha"]
		CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = aCoreCDB["ChatOptions"]["chattab_fade_minalpha"]
		CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = aCoreCDB["ChatOptions"]["chattab_fade_maxalpha"]
		CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = aCoreCDB["ChatOptions"]["chattab_fade_minalpha"]
		CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = aCoreCDB["ChatOptions"]["chattab_fade_maxalpha"]
		CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = aCoreCDB["ChatOptions"]["chattab_fade_minalpha"]
		
		init()
		FCF_SelectDockFrame(_G['ChatFrame1'])
		FCF_FadeInChatFrame(_G['ChatFrame1'])
	elseif event == "PET_BATTLE_OPENING_START" then
		chatwindownum = 11
		init()
		EventFrame:UnregisterEvent("PET_BATTLE_OPENING_START")
	end
end)

T.CreateSD(GeneralDockManagerOverflowButtonList, 3, 0, 0, 0, 0, -1)

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
QuickJoinToastButton:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 5, 5)
QuickJoinToastButton.SetPoint = function() end
T.FrameFader(QuickJoinToastButton)

ChatAlertFrame:ClearAllPoints()
ChatAlertFrame:SetPoint("BOTTOMLEFT", QuickJoinToastButton, "TOPLEFT", 0, 20)

