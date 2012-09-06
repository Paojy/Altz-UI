--Author: Weasoug
local ADDON_NAME, ns = ...
local cfg = ns.cfg

local addonName, eventHandlers = ..., { }

--[[-----------------------------------------------------------------------------
Accept Res
-------------------------------------------------------------------------------]]
if cfg.acceptres then
	eventHandlers['RESURRECT_REQUEST'] = function(name)
		if not (UnitAffectingCombat('player') or UnitAffectingCombat(name)) then
			local delay = GetCorpseRecoveryDelay()
			if delay == 0 then
				AcceptResurrect()
				DoEmote('thank', name)
			else
                local b = CreateFrame("Button")
				local formattedText = b:GetText(b:SetFormattedText("%d |4second:seconds", delay))
				SendChatMessage("Thanks for the rez! I still have "..formattedText.." until I can accept it.", 'WHISPER', nil, name)
			end
		end
	end
end

--[[-----------------------------------------------------------------------------
Battleground Res
-------------------------------------------------------------------------------]]
if cfg.battlegroundres then
	eventHandlers['PLAYER_DEAD'] = function()
			if ( select(2, GetInstanceInfo()) =='pvp' ) or (GetRealZoneText()=='Wintergrasp') or (GetRealZoneText()=='TolBarad') then
			RepopMe()
		end
	end
end

--[[-----------------------------------------------------------------------------
Hide Errors
-------------------------------------------------------------------------------]]
if cfg.hideerrors then
	local allowedErrors = { }

	eventHandlers['UI_ERROR_MESSAGE'] = function(message)
		if allowedErrors[message] then
			UIErrorsFrame:AddMessage(message, 1, .1, .1)
		end
	end

	UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
end

--[[-----------------------------------------------------------------------------
Accept Friendly Invites
-------------------------------------------------------------------------------]]
if cfg.acceptfriendlyinvites then
	eventHandlers['PARTY_INVITE_REQUEST'] = function(name)
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
Autorepair or Autorepairguild / SellJunk
-------------------------------------------------------------------------------]]
if cfg.autorepair or cfg.autorepairguild or cfg.selljunk then
	local handler = ""

	if cfg.selljunk then
		handler = handler .. [[
			local total = 0
			for bag = 0, NUM_BAG_FRAMES do
				for slot = 1, GetContainerNumSlots(bag) do
					local link = GetContainerItemLink(bag, slot)
					if link then
						local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(link)
						local _, itemCount = GetContainerItemInfo(bag, slot)
						if itemRarity == 0 and itemSellPrice ~= 0 then
							total = total + (itemSellPrice * itemCount)
							UseContainerItem(bag, slot)
						end
					end
				end
			end
			if total > 0 then
				print("Sell grey " .. MoneyToString(total))
			end
		]]
	end

	if cfg.autorepairguild then
		handler = handler .. [[
			if CanGuildBankRepair() then
				local cost, canRepair = GetRepairAllCost()
				if canRepair and cost > 0 then
					RepairAllItems(1)
					local newCost = GetRepairAllCost()
					if newCost < cost then
						print("Guild repair used: " .. MoneyToString(cost - newCost))
					end
				end
			end
		]]
	end

	-- Sell first so there is more money for repairs
	if cfg.autorepair then
		handler = handler .. [[
			local cost, canRepair = GetRepairAllCost()
			if canRepair and cost > 0 and cost <= GetMoney() * 0.2 then
				RepairAllItems()
				print("Repair used: " .. MoneyToString(cost))
			end
		]]
	end

	eventHandlers['MERCHANT_SHOW'] = loadstring(([=[
		local cuInd = [[|TInterface\MoneyFrame\UI-CopperIcon:0:1:2:0|t]]
		local agInd = [[|TInterface\MoneyFrame\UI-SilverIcon:0:1:2:0|t ]]
		local auInd = [[|TInterface\MoneyFrame\UI-GoldIcon:0:1:2:0|t ]]

		local function MoneyToString(ammount)
			local cu = ammount %% 100
			ammount = floor(ammount / 100)
			local ag, au = ammount %% 100, floor(ammount / 100)
			if au > 0 then
				return au .. auInd .. ag .. agInd .. cu .. cuInd
			elseif ag > 0 then
				return ag .. agInd .. cu .. cuInd
			end
			return cu .. cuInd
		end

		local function Handler(...)
			%s
		end

		return Handler
	]=]):format(handler))()
end

--[[-----------------------------------------------------------------------------
Fatigue Warner
-------------------------------------------------------------------------------]]
if cfg.fatiguewarner then
function FatigueWarner_OnUpdate(self) 
	local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(1) 
	if timer == "EXHAUSTION" then 
-- You can change the sounds by deleting the -- in Front of those PlaySoundFile, so that only one will not have the -- in front of it.
              --PlaySoundFile("Sound\\Creature\\ShadeOfAran\\AranAggro01.wav" , "Master")					
              --PlaySoundFile("Sound\\Creature\\ElderIronbranch\\UR_Ironbranch_Aggro01.wav", "Master")	
                PlaySoundFile("Sound\\Creature\\XT002Deconstructor\\UR_XT002_Special01.wav", "Master")
              --PlaySoundFile("Sound\\Creature\\Hodir\\UR_Hodir_Aggro01.wav", "Master")
	end 
	self:SetScript("OnUpdate", nil) 
end 
 
function FatigueWarner_OnEvent(self) 
	self:SetScript("OnUpdate", FatigueWarner_OnUpdate) 
end 
	  
-- Sinnlos; strip bringt ja irgendwie nichts fiel mir dann auf :>
function FatigueWarner_Strip()
	local FatigueWarner_StripTable = {16, 17, 18, 5, 7, 1, 3, 10, 8, 6, 9}
	local start = 1
	local finish = table.getn(FatigueWarner_StripTable)

	for bag = 0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			if not GetContainerItemLink(bag, slot) then
				for i = start, finish do
					if GetInventoryItemLink("player", FatigueWarner_StripTable[i]) then
						PickupInventoryItem(FatigueWarner_StripTable[i])
						PickupContainerItem(bag, slot)
						start = i + 1
						break
					end
				end
			end
		end
	end
end

local FatigueWarnerFrame = CreateFrame("frame")
FatigueWarnerFrame:RegisterEvent("MIRROR_TIMER_START")
FatigueWarnerFrame:RegisterEvent("MIRROR_TIMER_STOP")
FatigueWarnerFrame:SetScript("OnEvent", FatigueWarner_OnEvent)
end

--[[-----------------------------------------------------------------------------
Interrupted msg
-------------------------------------------------------------------------------]]
if cfg.interruptedmsg then
eventHandlers['COMBAT_LOG_EVENT_UNFILTERED'] = function(...)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16 = ...

	if arg2 ~= "SPELL_INTERRUPT" or arg5 ~= UnitName("player") then
		return
	end

        local channel = IsInRaid() and "RAID" or IsInGroup() and "PARTY"

	if channel then
		SendChatMessage(GetSpellLink(arg12).." Interrupted "..GetSpellLink(arg15), channel)
	end
    end
end

--[[-----------------------------------------------------------------------------
Initialize
-------------------------------------------------------------------------------]]
if next(eventHandlers) then
	local frame = CreateFrame('Frame')
	frame:Hide()

	for event, handler in pairs(eventHandlers) do
		frame[event] = handler
		frame:RegisterEvent(event)
		eventHandlers[event] = nil
	end

	frame:SetScript('OnEvent', function(self, event, ...)
		self[event](...)
	end)
end

--[[-----------------------------------------------------------------------------
Automaticly accepts/completes quests -- Author: Nightcracker
-------------------------------------------------------------------------------]]
if cfg.autoquests then
local f = CreateFrame("Frame")

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

f:SetScript("OnEvent", function(self, event, ...)
    if (event == "QUEST_DETAIL") then
		AcceptQuest()
		CompleteQuest()
	elseif (event == "QUEST_COMPLETE") then
		if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
			GetQuestReward()
		else
			MostValueable()
		end
    elseif (event == "QUEST_ACCEPT_CONFIRM") then
		ConfirmAcceptQuest()
	end
end)
f:RegisterEvent("QUEST_ACCEPT_CONFIRM")    
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("QUEST_COMPLETE")

---
QuestInfoDescriptionText.SetAlphaGradient=function() 
return false end

end
--[[-----------------------------------------------------------------------------
Reload Cmd
-------------------------------------------------------------------------------]]
_G['SLASH_' .. addonName .. 'ReloadUI1'] = strlower("/rl")
SlashCmdList[addonName .. 'ReloadUI'] = ReloadUI