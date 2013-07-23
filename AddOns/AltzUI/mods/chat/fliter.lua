local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ChatOptions"]["nogoldseller"] then return end

local Symbols = {" ","`","~","@","#","^","*","=","|"," ","，","。","、","？","！","：","；","’","‘","“","”","【","】","『","』","《","》","<",">","（","）"} 

local fliter = {string.split(" ", aCoreDB["goldkeywordlist"])}
local blacklist = {}
for _, keyword in pairs(fliter) do
	if keyword ~= "" then
		blacklist[keyword] = true
	end
end

function FliterChat(self, event, message, sender, language, channelString, target, flags, _, channelNumber, channelName, _, counter, guid)
	if event == "CHAT_MSG_WHISPER" and flags == "GM" then 
		return
	elseif UnitIsInMyGuild(sender) or UnitInRaid(sender) or UnitInParty(sender) then -- 加上自己
		return
	else
		for index = 1, GetNumFriends() do
			if GetFriendInfo(index) == sender then
				return
			end
		end
		for index = 1, BNGetNumFriends() do
			local toonName = select(5, BNGetFriendInfo(index))
			if toonName == sender then
				return
			end
		end
	end
	
	local msg
	
	for _, symbol in ipairs(Symbols) do
		msg = gsub(message, symbol, "") -- 去除干扰字符
	end
	
	local match = 0

	for keyword, value in pairs(blacklist) do
		if string.match(msg, keyword) then
			match = match +1
		end
	end
	
	if match >= aCoreCDB["ChatOptions"]["goldkeywordnum"] then
		return true
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",FliterChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FliterChat) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FliterChat) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", FliterChat) 