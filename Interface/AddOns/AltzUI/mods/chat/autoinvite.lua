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
			InviteUnit(name)
			return true
		else-- Party
			if not IsRealPartyLeader() then
				return false, L["我不能组人"]
			end
			if partyMemberCount == 4 then
				if aCoreCDB["OtherOptions"]["autoinviteautoconvert"] then
					C_PartyInfo.ConvertToRaid()
				else
					return false, L["小队满了"]
				end
			end
			InviteUnit(name)
			return true
		end
	else
		if raidMemberCount < 40 then
			if not IsRealRaidLeader() or not IsRaidOfficer() then
				return false, L["我不能组人"]
			end
			InviteUnit(name)
			return true
		else
			return false, L["团队满了"]
		end
	end
end

local EventFrame = CreateFrame('Frame')
EventFrame:SetScript('OnEvent', function(self, event, arg1, arg2, ...)
	if aCoreCDB["OtherOptions"]["autoinvite"] then		
		local success, reason
		for _, keyword in pairs(keywords) do
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
end)

EventFrame:RegisterEvent("CHAT_MSG_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")

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