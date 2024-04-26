local T, C, L, G = unpack(select(2, ...))

-- Chat Copy
local lines = {}
local frame = CreateFrame("Frame", "NDuiChatCopy", UIParent)
frame:SetPoint("CENTER")
frame:SetSize(700, 400)
frame:Hide()
frame:SetFrameStrata("DIALOG")

frame.backdrop = T.createBackdrop(frame, .5)
T.setStripeBg(frame.backdrop)

frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
frame.close:SetPoint("TOPRIGHT", frame)
T.ReskinClose(frame.close)

local scrollArea = CreateFrame("ScrollFrame", "ChatCopyScrollFrame", frame, "UIPanelScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)

local editBox = CreateFrame("EditBox", nil, frame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(99999)
editBox:EnableMouse(true)
editBox:SetAutoFocus(false)
editBox:SetFont(G.norFont, 10, "OUTLINE")
editBox:SetWidth(scrollArea:GetWidth())
editBox:SetHeight(270)
editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)
scrollArea:SetScrollChild(editBox)

local function copyFunc(_, btn)
	if not frame:IsShown() then
		local chatframe = SELECTED_DOCK_FRAME
		local _, fontSize = chatframe:GetFont()
		FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
		frame:Show()

		local index = 1
		for i = 1, chatframe:GetNumMessages() do
			local message, r, g, b = chatframe:GetMessageInfo(i)
			r = r or 1
			g = g or 1
			b = b or 1
			message = T.hex_str(message, r, g, b)

			lines[index] = tostring(message)
			index = index + 1
		end

		local lineCt = index - 1
		local text = table.concat(lines, "\n", 1, lineCt)
		FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
		editBox:SetText(text)

		wipe(lines)
	else
		frame:Hide()
	end
end

local copy = CreateFrame("Button", nil, UIParent)
copy:SetPoint("LEFT", QuickJoinToastButton, "RIGHT", 5, 0)
copy:SetSize(20, 20)
copy.Icon = copy:CreateTexture(nil, "ARTWORK")
copy.Icon:SetAllPoints()
copy.Icon:SetTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
T.ReskinButton(copy)
T.FrameFader(copy)

copy:RegisterForClicks("AnyUp")
copy:SetScript("OnClick", copyFunc)

copy:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
	GameTooltip:AddLine(L["复制聊天"], 1, 1, 1)
	GameTooltip:Show() 	
end)
copy:HookScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

T.ReskinScroll(ChatCopyScrollFrameScrollBar)