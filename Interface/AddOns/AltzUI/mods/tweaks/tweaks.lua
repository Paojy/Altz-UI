-- Original Author: Weasoug, etc
local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local collect = aCoreCDB.collectgarbage
local acceptres = aCoreCDB.acceptres
local battlegroundres = aCoreCDB.battlegroundres
local hideerrors = aCoreCDB.hideerrors
local acceptfriendlyinvites = aCoreCDB.acceptfriendlyinvites
local autoquests = aCoreCDB.autoquests
local saysapped = aCoreCDB.saysapped
local autoscreenshot = aCoreCDB.autoscreenshot
local camera = aCoreCDB.camera
local autorepair = aCoreCDB.autorepair
local autorepair_guild = aCoreCDB.autorepair_guild
local autosell = aCoreCDB.autosell

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
Auto Screenshot
-------------------------------------------------------------------------------]]
local function TakeScreen(delay, func, ...) 
	local waitTable = {} 
	local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent) 
	waitFrame:SetScript("onUpdate", function (self, elapse) 
		local count = #waitTable 
		local i = 1 
		while (i <= count) do 
			local waitRecord = tremove(waitTable, i) 
			local d = tremove(waitRecord, 1) 
			local f = tremove(waitRecord, 1) 
			local p = tremove(waitRecord, 1) 
			if (d > elapse) then 
				tinsert(waitTable, i, {d-elapse, f, p}) 
				i = i + 1 
			else 
				count = count - 1 
				f(unpack(p)) 
			end 
		end 
	end) 
	tinsert(waitTable, {delay, func, {...} }) 
end
if autoscreenshot then
	eventframe:RegisterEvent('ACHIEVEMENT_EARNED')
	function eventframe:ACHIEVEMENT_EARNED(...)
		TakeScreen(1, Screenshot) 
	end
end
--[[-----------------------------------------------------------------------------
Auto repair and sell grey items
-------------------------------------------------------------------------------]]
local IDs = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do 	
	IDs[slot] = GetInventorySlotInfo(slot .. "Slot")
end

if autorepair or autorepair_guild or autosell then
	eventframe:RegisterEvent('MERCHANT_SHOW')
	function eventframe:MERCHANT_SHOW(...)
		if CanMerchantRepair() and autorepair == true then
			local gearRepaired = true -- to work around bug when there's not enough money in guild bank
			local cost = GetRepairAllCost()
			if cost > 0 and CanGuildBankRepair() and autorepair_guild == true then
				if GetGuildBankWithdrawMoney() > cost then
					RepairAllItems(1)
					for slot, id in pairs(IDs) do
						local dur, maxdur = GetInventoryItemDurability(id)
						if dur and maxdur and dur < maxdur then
							gearRepaired = false
							break
						end
					end
					if gearRepaired then
						print(format(L["RepairCost"].." %.1fg ("..GUILD..")", cost * 0.0001))
					else
						print(L["noguildmoney1"])
					end
				else
					print(L["noguildmoney2"])
				end
			elseif cost > 0 and GetMoney() > cost then
				RepairAllItems()
				print(format(L["RepairCost"].." %.1fg", cost * 0.0001))
			elseif GetMoney() < cost then
				print(L["nomoney"])
			end
		end
		if autosell == true then
			for bag = 0, 4 do
				for slot = 0, GetContainerNumSlots(bag) do
					local link = GetContainerItemLink(bag, slot)
					if link and (select(3, GetItemInfo(link))==0) then
						UseContainerItem(bag, slot)
					end
				end
			end
		end
	end
end
--[[-----------------------------------------------------------------------------
Camera
-------------------------------------------------------------------------------]]
if camera then
	eventframe:RegisterEvent('VARIABLES_LOADED')
	function eventframe:VARIABLES_LOADED()
		SetCVar("cameraDistanceMax", 25)
		SetCVar("cameraDistanceMaxFactor", 2)
		eventframe:UnregisterEvent('VARIABLES_LOADED')
	end
end
--[[-----------------------------------------------------------------------------
Say Sapped
-------------------------------------------------------------------------------]]
if saysapped then
	eventframe:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	function eventframe:COMBAT_LOG_EVENT_UNFILTERED(...)
		if ((select(14,...) == 6770)
		and (select(11,...) == UnitName("player"))
		and (select(4,...) == "SPELL_AURA_APPLIED" or select(4,...) == "SPELL_AURA_REFRESH"))
		then
			SendChatMessage(L["Sapped!"], "SAY")
			DEFAULT_CHAT_FRAME:AddMessage(L["sapped by:"].." "..(select(7,...) or "(unknown)"))
		end
	end
end
--[[-----------------------------------------------------------------------------
Accept Res
-------------------------------------------------------------------------------]]
if acceptres then
	eventframe:RegisterEvent('RESURRECT_REQUEST')
	function eventframe:RESURRECT_REQUEST(name)
		if UnitAffectingCombat('player') then return end
		if IsInGroup() and (UnitAffectingCombat('party1') or UnitAffectingCombat('raid1') or UnitAffectingCombat('raid2')) then return end
		local delay = GetCorpseRecoveryDelay()
		if delay == 0 then
			AcceptResurrect()
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
local eventframe2 = CreateFrame('Frame')
eventframe2:RegisterEvent('PARTY_INVITE_REQUEST')
if acceptfriendlyinvites then
	eventframe2:SetScript('OnEvent', function(self, event, arg1)
		if QueueStatusMinimapButton:IsShown() then return end
        if IsInGroup() then return end
		local accept = false
		for index = 1, GetNumFriends() do
			if GetFriendInfo(index) == arg1 then
				accept = true
				break
			end
		end
		if not accept and IsInGuild() then
			GuildRoster()
			for index = 1, GetNumGuildMembers() do
				if GetGuildRosterInfo(index) == arg1 then
					accept = true
					break
				end
			end
		end
		if not accept then
			for index = 1, BNGetNumFriends() do
				local toonName = select(5, BNGetFriendInfo(index))
				if toonName == arg1 then
					accept = true
					break
				end
			end
		end
		if accept then
			local pop = StaticPopup_Visible('PARTY_INVITE')
			if pop then
				StaticPopup_OnClick(_G[pop], 1)
				return
			end
		end
	end)
end
--[[-----------------------------------------------------------------------------
Automaticly accepts/completes quests -- Author: Nightcracker
-------------------------------------------------------------------------------]]
if autoquests then
	local function MostValueable()
		local bestp, besti = 0
		for i=1,GetNumQuestChoices() do
			local link, _, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
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