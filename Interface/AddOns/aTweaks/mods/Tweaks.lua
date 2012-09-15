-- Original Author: Weasoug, etc
local addon, ns = ...
local L = ns.L

local collect = aCoreCDB.collectgarbage
local acceptres = aCoreCDB.acceptres
local battlegroundres = aCoreCDB.battlegroundres
local hideerrors = aCoreCDB.hideerrors
local acceptfriendlyinvites = aCoreCDB.acceptfriendlyinvites
local autoquests = aCoreCDB.autoquests

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	self[event](...)
end)

--[[-----------------------------------------------------------------------------
Reload Cmd
-------------------------------------------------------------------------------]]
SLASH_ALTZRL1 = "/rl"
SlashCmdList["ALTZRL"] = ReloadUI
--[[-----------------------------------------------------------------------------
Collect Garbage
-------------------------------------------------------------------------------]]
if collect then
	local eventcount = 0 
	local a = CreateFrame("Frame") 
	a:RegisterAllEvents() 
	a:SetScript("OnEvent", function(self, event) 
		eventcount = eventcount + 1 
		if InCombatLockdown() then return end 
		if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" then 
			collectgarbage("collect") 
			eventcount = 0
		end 
	end)
end
--[[-----------------------------------------------------------------------------
Accept Res
-------------------------------------------------------------------------------]]
if acceptres then
	eventframe:RegisterEvent('RESURRECT_REQUEST')
	function eventframe:RESURRECT_REQUEST(name)
		if not UnitAffectingCombat('player') or UnitAffectingCombat(name) then
			local delay = GetCorpseRecoveryDelay()
			if delay == 0 then
				AcceptResurrect()
				DoEmote('thank', name)
			else
                local b = CreateFrame("Button")
				local formattedText = b:GetText(b:SetFormattedText("%d |4second:seconds", delay))
				SendChatMessage(L["Thanks for the rez! I still have"].." "..formattedText.." "..L["until I can accept it."], 'WHISPER', nil, name)
			end
		end
	end
end
--[[-----------------------------------------------------------------------------
Battleground Res
-------------------------------------------------------------------------------]]
if battlegroundres then
	eventframe:RegisterEvent('PLAYER_DEAD')
	function eventframe:PLAYER_DEAD()
			if ( select(2, GetInstanceInfo()) =='pvp' ) or (GetRealZoneText()=='Wintergrasp') or (GetRealZoneText()=='TolBarad') then
			RepopMe()
		end
	end
end
--[[-----------------------------------------------------------------------------
Hide Errors
-------------------------------------------------------------------------------]]
if hideerrors then
	local allowedErrors = { }
	
	eventframe:RegisterEvent('UI_ERROR_MESSAGE')
	function eventframe:UI_ERROR_MESSAGE(message)
		if allowedErrors[message] then
			UIErrorsFrame:AddMessage(message, 1, .1, .1)
		end
	end

	UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
end
--[[-----------------------------------------------------------------------------
Accept Friendly Invites
-------------------------------------------------------------------------------]]
if acceptfriendlyinvites then
	eventframe:RegisterEvent('PARTY_INVITE_REQUEST')
	function eventframe:PARTY_INVITE_REQUEST(name)
		local accept
		ShowFriends()
		for index = 1, GetNumFriends() do
			if GetFriendInfo(index) == name then
				accept = true
				break
			end
		end
		if not accept and IsInGuild() then
			GuildRoster()
			for index = 1, GetNumGuildMembers() do
				if GetGuildRosterInfo(index) == name then
					accept = true
					break
				end
			end
		end
		if not accept then
			for index = 1, BNGetNumFriends() do
				local _, _, _, toonName = BNGetFriendInfo(index)
				if toonName == name then
					accept = true
					break
				end
			end
		end
		if accept then
			name = StaticPopup_Visible('PARTY_INVITE')
			if name then
				StaticPopup_OnClick(_G[name], 1)
				return
			end
		else
			SendWho('n-"' .. name .. '"')
		end
	end
end
--[[-----------------------------------------------------------------------------
Automaticly accepts/completes quests -- Author: Nightcracker
-------------------------------------------------------------------------------]]
if autoquests then
	local function MostValueable()
		local bestp, besti = 0
		for i=1,GetNumQuestChoices() do
			local link, name, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
			local price = link and select(11, GetItemInfo(link))
			if not price then
				return
			elseif (price * (qty or 1)) > bestp then
				bestp, besti = (price * (qty or 1)), i
			end
		end
		if besti then
			local btn = _G["QuestInfoItem"..besti]
			if (btn.type == "choice") then
				btn:GetScript("OnClick")(btn)
			end
		end
	end
	
	eventframe:RegisterEvent("QUEST_DETAIL")
	eventframe:RegisterEvent("QUEST_COMPLETE")
	eventframe:RegisterEvent("QUEST_ACCEPT_CONFIRM")
	
	function eventframe:QUEST_DETAIL() AcceptQuest() CompleteQuest() end
	function eventframe:QUEST_COMPLETE() 
		if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
			GetQuestReward()
		else
			MostValueable()
		end
	end
	function eventframe:QUEST_ACCEPT_CONFIRM() ConfirmAcceptQuest() end
	
	QuestInfoDescriptionText.SetAlphaGradient=function() return false end
end