local T, C, L, G = unpack(select(2, ...))
local Symbols = {" ","`","~","@","#","^","*","=","|"," ","，","。","、","？","！","：","；","’","‘","“","”","【","】","『","』","《","》","<",">","（","）"} 

local blacklist = {}
local recent_msg = {}
local index = 1

local function IsFriend(name)
	for i = 1, C_FriendList.GetNumFriends() do
		if C_FriendList.GetFriendInfoByIndex(i) == name then
			return true
		end
	end
	for i = 1, BNGetNumFriends() do
		local account_num = C_BattleNet.GetFriendNumGameAccounts(i)
		for j = 1, account_num do
			local toonName = select(4, C_BattleNet.GetFriendGameAccountInfo(i, j))
			if toonName == name then
				return true
			end
		end
	end
end

local function FilterChat(self, event, message, author, language, channelString, target, flags, _, channelNumber, channelName, _, counter, guid)
	if not aCoreCDB["ChatOptions"]["nogoldseller"] then return end
	local sender = string.split("-", author)
	
	if event == "CHAT_MSG_WHISPER" and flags == "GM" then 
		return
	elseif UnitIsInMyGuild(sender) or UnitInRaid(sender) or UnitInParty(sender) or UnitIsUnit(sender, "player") then
		return
	elseif IsFriend(sender) then
		return
	end
	
	-- 过滤重复信息
	
	for i = 1, 4 do
		if recent_msg[i] and recent_msg[i]["sender"] == sender and recent_msg[i]["msg"] == message then
			return true
		end
	end
	
	if index == 5 then
		index = 1
	end
	
	if not recent_msg[index] then
		recent_msg[index] = {}
	end
	
	recent_msg[index]["sender"] = sender
	recent_msg[index]["msg"] = message
	
	index = index + 1
	
	-- 过滤关键词
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

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",FilterChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FilterChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FilterChat) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", FilterChat)

local Update_Chat_Filter = function()
	local filter = {string.split(" ", aCoreCDB["ChatOptions"]["goldkeywordlist"])}
	for _, keyword in pairs(filter) do
		if keyword ~= "" then
			blacklist[keyword] = true
		end
	end
end
T.Update_Chat_Filter = Update_Chat_Filter

T.RegisterInitCallback(Update_Chat_Filter)