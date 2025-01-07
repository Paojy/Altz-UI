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


local red_str = "|cFFDC143C|Haddon:altz:invite_addIgnore:%s|h[".. IGNORE.."]|h|r"

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

hooksecurefunc("SetItemRef", function(link)
    if link:find("addon:altz:invite_addIgnore") then
        local _, _, _, name = string.split(":", link)
        C_FriendList.AddIgnore(name)
    end
end)

local EventFrame = CreateFrame('Frame')
EventFrame:SetScript('OnEvent', function(self, event, ...)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		local name = ...
		if aCoreCDB["ChatOptions"]["autoinvite"] then
			local success, reason
			for keyword, _ in pairs(keywords) do
				if keyword:lower() == name:lower() then
					if event == "CHAT_MSG_WHISPER" then
						local name = select(2, ...)
						success, reason = InvitePlayer(name)
						if not success then
							SendChatMessage(L["无法自动邀请进组:"]..reason, "WHISPER", nil, name)
						end
					elseif event == "CHAT_MSG_BN_WHISPER" then						
						local senderBnetIDAccount = select(13, ...)
						local _, BNcount = BNGetNumFriends() 
						for i = 1, BNcount do
							if senderBnetIDAccount == C_BattleNet.GetFriendAccountInfo(i)["bnetAccountID"] then
								local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(i)
								for j = 1, numGameAccounts do
									local info = C_BattleNet.GetFriendGameAccountInfo(i, j)
									if info and info.clientProgram == BNET_CLIENT_WOW and info.isInCurrentRegion and info.wowProjectID == WOW_PROJECT_MAINLINE then
										BNInviteFriend(info.gameAccountID)
									end
								end
								break
							end
						end
					end
				end
			end
		end
	elseif event == "PARTY_INVITE_REQUEST" then
		local name, _, _, _, _, _, guid = ...
        if C_GuildInfo.MemberExistsByName(name) and aCoreCDB["ChatOptions"]["acceptInvite_guild"] then -- 公会
            accept_invite()
            
        elseif C_FriendList.IsFriend(guid) and aCoreCDB["ChatOptions"]["acceptInvite_friend"] then -- 好友
            accept_invite()
            
        elseif C_BattleNet.GetAccountInfoByGUID(guid) then
            local info = C_BattleNet.GetAccountInfoByGUID(guid)
            if info.isFriend and aCoreCDB["ChatOptions"]["acceptInvite_friend"] then -- 战网实名好友
                accept_invite()
               
            elseif info.isBattleTagFriend and aCoreCDB["ChatOptions"]["acceptInvite_friend"] then -- 是战网好友
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
		elseif hassameclub(guid) and aCoreCDB["ChatOptions"]["acceptInvite_club"] then -- 有共同社区
            accept_invite()
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
