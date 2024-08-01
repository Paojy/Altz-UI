local T, C, L, G = unpack(select(2, ...))

local chatwindownum = NUM_CHAT_WINDOWS

--====================================================--
--[[              -- 聊天框美化 --                  ]]--
--====================================================--
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

function ChatFrame_OnMouseScroll(self, delta)
	local numScrollMessages = 3
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsAltKeyDown() then
			self:ScrollDown()
		else
			for _ = 1, numScrollMessages do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsAltKeyDown() then
			self:ScrollUp()
		else
			for _ = 1, numScrollMessages do
				self:ScrollUp()
			end
		end
	end
end

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
		
		cf:SetScript('OnMouseWheel', function(self, delta) ChatFrame_OnMouseScroll(self, delta) end)
	end
	
	UpdateChatFrameBg()
end

hooksecurefunc("FCFTab_UpdateColors", function(tab, selected)
	if not tab.skined then
		tab.Text:SetFont(G.norFont, 13, "THINOUTLINE")
		tab.Text:SetShadowOffset(0,0)
		
		tab.Middle:SetTexture(nil)
		tab.Left:SetTexture(nil)
		tab.Right:SetTexture(nil)
		tab.ActiveLeft:SetTexture(nil)
		tab.ActiveMiddle:SetTexture(nil)
		tab.ActiveRight:SetTexture(nil)
		tab.HighlightLeft:SetTexture(nil)
		tab.HighlightMiddle:SetTexture(nil)
		tab.HighlightRight:SetTexture(nil)
		
		tab:HookScript("OnClick", function(self)
			local chat_frame = self:GetParent()
			if chat_frame.editBox then
				chat_frame.editBox:SetAlpha(0)
			end
		end)
		
		tab.skined = true
	end
	
	if ( selected ) then
		tab.Text:SetTextColor(unpack(G.addon_color))
	else
		tab.Text:SetTextColor(1, 1, 1)
	end
end)

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PET_BATTLE_OPENING_START")

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

--====================================================--
--[[       -- 战网讯息和快速加入按钮 --             ]]--
--====================================================--
QuickJoinToastButton:ClearAllPoints()
QuickJoinToastButton:SetPoint("LEFT", ChatFrame1.editBox, "LEFT", 5, 0)
QuickJoinToastButton.SetPoint = function() end

ChatAlertFrame:ClearAllPoints()
ChatAlertFrame:SetPoint("BOTTOMLEFT", QuickJoinToastButton, "TOPLEFT", 0, 20)

BNToastFrame:SetClampedToScreen(true)

T.createBackdrop(GeneralDockManagerOverflowButtonList, .5)
--====================================================--
--[[                -- 复制聊天 --                  ]]--
--====================================================--

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetFrameStrata("DIALOG")
frame:SetPoint("CENTER")
frame:SetSize(700, 400)
frame:Hide()

T.setStripBD(frame)

frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
frame.close:SetPoint("TOPRIGHT", frame)
T.ReskinClose(frame.close)

local copy_box = T.EditboxMultiLine(frame, 640, 380, {"TOPLEFT", 10, -10})

copy_box.button1:Hide()
copy_box.button2:Hide()

copy_box.edit:SetScript("OnEscapePressed", function(self) 
	frame:Hide()
	self:SetText("")
end)

local chatcopy_button = T.ClickTexButton(UIParent, {"LEFT", QuickJoinToastButton, "RIGHT", 0, 0}, [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], nil, 20, L["复制聊天"])

local chat_lines = {}

chatcopy_button:SetScript("OnClick", function()
	if not frame:IsShown() then
		local chatframe = SELECTED_DOCK_FRAME
		chat_lines = table.wipe(chat_lines)
		
		for i = 1, chatframe:GetNumMessages() do
			local message = chatframe:GetMessageInfo(i)
			message = message:gsub("|T[^|]+|t", "") -- 去掉材质
			table.insert(chat_lines, message)
		end

		copy_box.edit:SetText(table.concat(chat_lines, "\n"))
		copy_box:UpdateScrollChildRect()
		
		frame:Show()
		
		copy_box.edit:SetFocus()
	else
		frame:Hide()
	end
end)

T.GroupFader({QuickJoinToastButton, chatcopy_button})