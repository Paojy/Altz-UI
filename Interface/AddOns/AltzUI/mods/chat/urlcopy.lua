local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ChatOptions"]["copychat"] then return end

local _AddMessage = ChatFrame1.AddMessage
local _SetItemRef = SetItemRef
local blacklist = {
  [ChatFrame2] = true,
}

-- Short tabs
CHAT_SAY_GET                  = "s %s: "
CHAT_YELL_GET                 = "y %s: "
CHAT_WHISPER_GET              = "> %s "
CHAT_WHISPER_INFORM_GET       = "< %s "
CHAT_BN_WHISPER_GET           = "> %s "
CHAT_BN_WHISPER_INFORM_GET    = "< %s "
CHAT_BATTLEGROUND_GET         = "b %s: "
CHAT_BATTLEGROUND_LEADER_GET  = "B %s: "
CHAT_GUILD_GET                = "g %s: "
CHAT_OFFICER_GET              = "o %s: "
CHAT_PARTY_GET                = "p %s: "
CHAT_PARTY_LEADER_GET         = "P %s: "
CHAT_PARTY_GUIDE_GET          = "PG %s: "
CHAT_RAID_GET                 = "r %s: "
CHAT_RAID_LEADER_GET          = "R %s: "
CHAT_RAID_WARNING_GET         = "RW %s: "
CHAT_INSTANCE_CHAT_GET        = "i %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "I %s: "
YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

-- Loot
LOOT_ITEM                     = "%s: + %s|Hitem :%d :%d :%d :%d|h[%s]|h%s"

local chatEvents = {
	"CHAT_MSG_CHANNEL_JOIN",
	"CHAT_MSG_CHANNEL_LEAVE",
	"CHAT_MSG_CHANNEL_NOTICE",
	"CHAT_MSG_CHANNEL_NOTICE_USER",
	"CHAT_MSG_CHANNEL_LIST"
}

local ts = G.classcolor..'|HyCopy|h%s|h|r %s'
local AddMessage = function(self, text, ...)
  if(type(text) == 'string') then
    if showtime then
      text = format(ts, date'%H:%M', text)  --text = format(ts, date'%H:%M:%S', text)
    end
  end

  return _AddMessage(self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
  local cf = _G['ChatFrame'..i]
  if(not blacklist[cf]) then
    cf.AddMessage = AddMessage
  end
end

local MouseIsOver = function(frame)
  local s = frame:GetParent():GetEffectiveScale()
  local x, y = GetCursorPosition()
  x = x / s
  y = y / s

  local left = frame:GetLeft()
  local right = frame:GetRight()
  local top = frame:GetTop()
  local bottom = frame:GetBottom()

  if(not left) then
    return
  end

  if((x > left and x < right) and (y > bottom and y < top)) then
    return 1
  else
    return
  end
end

local borderManipulation = function(...)
  for l = 1, select('#', ...) do
    local obj = select(l, ...)
    if(obj:GetObjectType() == 'FontString' and MouseIsOver(obj)) then
       return obj:GetText()
    end
  end
end

local eb = ChatFrame1EditBox
SetItemRef = function(link, text, button, ...)
  if(link:sub(1, 5) ~= 'yCopy') then return _SetItemRef(link, text, button, ...) end

  local text = borderManipulation(SELECTED_CHAT_FRAME.FontStringContainer:GetRegions())
  if(text) then
    text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
    text = text:gsub('|H.-|h(.-)|h', '%1')

    eb:Insert(text)
    eb:Show()
    eb:HighlightText()
    eb:SetFocus()
  end
end
