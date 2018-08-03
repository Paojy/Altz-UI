local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

--CHAT_FRAME_FADE_OUT_TIME = 1
--CHAT_TAB_HIDE_DELAY = 1
--CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
--CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
--CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.5
--CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
--CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
--CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0

--for i = 1, 23 do
--	CHAT_FONT_HEIGHTS[i] = i+7
--end

local _G = _G

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
		tex[6]:SetAlpha(0) tex[7]:SetAlpha(0) tex[8]:SetAlpha(0) tex[9]:SetAlpha(0) tex[10]:SetAlpha(0)
		-- make a new backdrop on edit box
		F.SetBD(_G['ChatFrame'..i..'EditBox'])
		-- control the aplha
		_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
		_G['ChatFrame'..i..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
		-- chat font
		local cf = _G['ChatFrame'..i]
		if cf then 
			cf:SetFont(STANDARD_TEXT_FONT, select(2, cf:GetFont()), "THINOUTLINE") 
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
			eb:SetPoint("TOPLEFT",cf,"TOPLEFT", 10, 55)
			eb:SetPoint("BOTTOMRIGHT",cf,"TOPRIGHT", -3, 32)
			eb:Hide()
		end
		-- chat tabs
		local tab = _G['ChatFrame'..i..'Tab']
		if tab then
			tab:GetFontString():SetFont(STANDARD_TEXT_FONT, 13, "THINOUTLINE")
			tab:GetFontString():SetShadowOffset(0,0)
			if i ~= 11 then
			tab.selectedColorTable = { r = G.Ccolor.r, g = G.Ccolor.g, b = G.Ccolor.b };
			tab:SetAlpha(1)
			end
		end
		-- hide tab texture
		for index, value in pairs(TAB_TEXTURES) do
			local texture = _G['ChatFrame'..i..'Tab'..value]
			texture:SetTexture(nil)
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

ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide 
ChatFrameMenuButton:Hide()
QuickJoinToastButton.Show = QuickJoinToastButton.Hide 
QuickJoinToastButton:Hide()
BNToastFrame:SetClampedToScreen(true)

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PET_BATTLE_OPENING_START")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_CombatLog" then
		--local topbar = _G["CombatLogQuickButtonFrame_Custom"]
		--if not topbar then return end
		--topbar:Hide()
		--topbar:HookScript("OnShow", function(self) topbar:Hide() end)
		--topbar:SetHeight(0)
	elseif event == "PLAYER_LOGIN" then
		init()
	elseif event == "PET_BATTLE_OPENING_START" then
		chatwindownum = 11
		init()
		EventFrame:UnregisterEvent("PET_BATTLE_OPENING_START")
	end
end)

F.CreateBD(GeneralDockManagerOverflowButtonList, 0.7)
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