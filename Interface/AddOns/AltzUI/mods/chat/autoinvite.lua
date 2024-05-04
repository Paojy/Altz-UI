local T, C, L, G = unpack(select(2, ...))

local BlzGames = {
	["App"]="Battle.Net-Client",
	["D3"]="Diablo 3",
	["Hero"]="Heroes of the Storm",
	["S2"]="Starcarft 2",
	["WoW"]="World of Warcraft",
	["WTCG"]="Hearthstone",
}

local keywords = {}

local function InvitePlayer(name)
	local partyMemberCount = GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME)
	local raidMemberCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
	if raidMemberCount == 0 then			-- Not in raid
		if partyMemberCount == 0 then				-- Solo
			C_PartyInfo.InviteUnit(name)
			return true
		else-- Party
			if not UnitIsGroupLeader("player") then
				return false, L["我不能组人"]
			end
			if partyMemberCount == 4 then	
				C_PartyInfo.ConvertToRaid()
			end
			C_PartyInfo.InviteUnit(name)
			return true
		end
	else
		if raidMemberCount < 40 then
			if not UnitIsGroupAssistant("player") and not UnitIsGroupLeader("player") then
				return false, L["我不能组人"]
			end
			C_PartyInfo.InviteUnit(name)
			return true
		else
			return false, L["团队满了"]
		end
	end
end

local red_str = "|Hgarrmission:altzinvite_addIgnore::%s|h|cFFDC143C[".. IGNORE.."]|r|h"
local my_battle_tag

local accept_invite = function()
    PlaySound(SOUNDKIT.IG_PLAYER_INVITE)
    AcceptGroup()
    StaticPopup_Hide("PARTY_INVITE")
end

local cancel_invite = function(name)
    print(string.format(L["邀请过滤"], name), string.format(red_str, name))
    StaticPopup_Hide("PARTY_INVITE")
    DeclineGroup()
end

local hassameclub = function(guid)
    local clubs =  C_Club.GetSubscribedClubs()
    for i, info in pairs(clubs) do
        local id = info.clubId
        local num = info.memberCount
        for k = 1, num do
            local memberinfo = C_Club.GetMemberInfo(id, k)
            if memberinfo and memberinfo.guid == guid then
                return true
            end      
        end       
    end
end

hooksecurefunc("SetItemRef", function(link, text)
    if link:find("garrmission:altzinvite") then
        local name = string.match(text, "::([^%]]+)%|h|c")
        if string.find(text, "addIgnore") then
            C_FriendList.AddIgnore(name)
        end
    end
end)

local EventFrame = CreateFrame('Frame')
EventFrame:SetScript('OnEvent', function(self, event, arg1, arg2, ...)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		if aCoreCDB["ChatOptions"]["autoinvite"] then
			local success, reason
			for keyword, _ in pairs(keywords) do
				if keyword:lower() == arg1:lower() then
					if event == "CHAT_MSG_WHISPER" then
						success, reason = InvitePlayer(arg2)
						if not success then
							SendChatMessage(L["无法自动邀请进组:"]..reason, "WHISPER", nil, arg2)
						end
					elseif event == "CHAT_MSG_BN_WHISPER" then
						local _, toonName, client, realmName = BNGetToonInfo(select(11, ...))
						if client == "WoW" then
							success, reason = InvitePlayer(toonName.."-"..realmName)
							if not success then
								BNSendWhisper(select(11, ...), L["无法自动邀请进组:"]..reason)
							end
						else
							BNSendWhisper(select(11, ...), L["无法自动邀请进组:"]..string.format(L["客户端错误"], BlzGames[client]))
						end
					end
				end
			end
		end
	elseif event == "PARTY_INVITE_REQUEST" then
		local name = arg1
		local guid = select(5, ...)
        if C_GuildInfo.MemberExistsByName(guid) and aCoreCDB["ChatOptions"]["acceptInvite_guild"] then -- 公会
            accept_invite()
            
        elseif C_FriendList.IsFriend(guid) and aCoreCDB["ChatOptions"]["acceptInvite_friend"] then -- 好友
            accept_invite()
            
        elseif not C_BattleNet.GetAccountInfoByGUID(guid) then
            local info = C_BattleNet.GetAccountInfoByGUID(guid)
            if info.isFriend and aCoreCDB["ChatOptions"]["acceptInvite_friend"] then -- 战网实名好友
                accept_invite()
               
            elseif info.isBattleTagFriend and aCoreCDB["ChatOptions"]["acceptInvite_friend"] then -- 是战网好友
                accept_invite()
               
            elseif hassameclub(guid) and aCoreCDB["ChatOptions"]["acceptInvite_club"] then -- 有共同社区
                accept_invite()
				
            else
				if not my_battle_tag then
					local my_info = C_BattleNet.GetAccountInfoByGUID(UnitGUID("player"))
					my_battle_tag = my_info.battleTag
				end
				if my_battle_tag and info.battleTag == my_battle_tag and aCoreCDB["ChatOptions"]["acceptInvite_account"] then -- 我的角色
					accept_invite()
				end
            end
        elseif aCoreCDB["ChatOptions"]["refuseInvite_stranger"] then
            cancel_invite(name)
			
        end
	end
end)

EventFrame:RegisterEvent("CHAT_MSG_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
EventFrame:RegisterEvent("PARTY_INVITE_REQUEST")

local Update_Invite_Keyword = function()
	local filter = {string.split(" ", aCoreCDB["ChatOptions"]["autoinvitekeywords"])}
	for _, keyword in pairs(filter) do
		if keyword ~= "" then
			keywords[keyword] = true
		end
	end
end
T.Update_Invite_Keyword = T.Update_Invite_Keyword

T.RegisterInitCallback(Update_Invite_Keyword)

