-- Original Author: Weasoug, etc
local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local collect = aCoreCDB["OtherOptions"]["collectgarbage"]
local acceptres = aCoreCDB["OtherOptions"]["acceptres"]
local battlegroundres = aCoreCDB["OtherOptions"]["battlegroundres"]
local hideerrors = aCoreCDB["OtherOptions"]["hideerrors"]
local saysapped = aCoreCDB["OtherOptions"]["saysapped"]
local autoscreenshot = aCoreCDB["OtherOptions"]["autoscreenshot"]
local camera = aCoreCDB["OtherOptions"]["camera"]

local acceptfriendlyinvites = aCoreCDB["OtherOptions"]["acceptfriendlyinvites"]
local autoinvite = aCoreCDB["OtherOptions"]["autoinvite"]
local autoinvitekeywords = aCoreCDB["OtherOptions"]["autoinvitekeywords"]

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	eventframe[event](self, ...)
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
	function eventframe:ACHIEVEMENT_EARNED()
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

eventframe:RegisterEvent('MERCHANT_SHOW')
function eventframe:MERCHANT_SHOW()
	if CanMerchantRepair() and aCoreCDB["ItemOptions"]["autorepair"] then
		local gearRepaired = true -- to work around bug when there's not enough money in guild bank
		local cost = GetRepairAllCost()
		if cost > 0 and CanGuildBankRepair() and aCoreCDB["ItemOptions"]["autorepair_guild"] then
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
					print(format(L["修理花费"].." %.1fg ("..GUILD..")", cost * 0.0001))
				end
			end
		elseif cost > 0 and GetMoney() > cost then
			RepairAllItems()
			print(format(L["修理花费"].." %.1fg", cost * 0.0001))
		end
	end
	if aCoreCDB["ItemOptions"]["autosell"] then
		for bag = 0, 4 do
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link and (select(3, GetItemInfo(link))==0) then
					UseContainerItem(bag, slot)
				end
			end
		end
	end
	if aCoreCDB["ItemOptions"]["autobuy"] then
		for ItemID, Need in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
			local ItemCount = GetItemCount(tonumber(ItemID))
			if ItemCount >= tonumber(Need) then return end -- 足够了
			
			local ItemName = GetItemInfo(tonumber(ItemID))
			local numMerchantItems = GetMerchantNumItems()
			for index = 1, numMerchantItems do
				local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
				if ItemName == name then-- 有卖的嘛？
					local needbuy = tonumber(Need) - ItemCount
					if numAvailable >1 and needbuy > numAvailable then -- 数量够不够
						print(L["货物不足"]..G.classcolor.." "..ItemName.."|r")
					elseif needbuy/quantity*price > GetMoney() then -- 钱够不够
						print(L["钱不够"]..G.classcolor.." "..ItemName.."|r")
					else
						maxStack = GetMerchantItemMaxStack(index)
						while needbuy > maxStack*quantity do
							BuyMerchantItem(index, maxStack)
							print(format(L["购买"], maxStack*quantity, G.classcolor..ItemName.."|r"))
							needbuy = needbuy - maxStack*quantity
						end
						if needbuy > 0 then
							BuyMerchantItem(index, needbuy/quantity)
							print(format(L["购买"], needbuy, G.classcolor..ItemName.."|r"))
						end				
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
			SendChatMessage(L["被闷了"], "SAY")
			DEFAULT_CHAT_FRAME:AddMessage(L["被闷了2"].." "..(select(7,...) or "(unknown)"))
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
		if IsInGroup() then
			if IsInRaid() then
				for i = 1, 39 do
					if UnitAffectingCombat(format('raid%d', i)) then
						return
					end
				end
			else
				for i = 1, 4 do
					if UnitAffectingCombat(format('party%d', i)) then
						return
					end
				end
			end
		end
		
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
if acceptfriendlyinvites then
	eventframe:RegisterEvent('PARTY_INVITE_REQUEST')
	function eventframe:PARTY_INVITE_REQUEST(arg1)
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
	end
end
--[[-----------------------------------------------------------------------------
Key Word Invite
-------------------------------------------------------------------------------]]
if autoinvite then
    eventframe:RegisterEvent("CHAT_MSG_WHISPER")
    eventframe:RegisterEvent("CHAT_MSG_BN_WHISPER")
	local function AutoInvite(event, arg1, arg2, ...)
		local keywords = {string.split(" ", autoinvitekeywords)}
		if (not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
			for _, keyword in pairs(keywords) do
				if keyword == arg1:lower() then
					if event == "CHAT_MSG_WHISPER" then
						InviteUnit(arg2)
					elseif event == "CHAT_MSG_BN_WHISPER" then
						local _, toonName, _, realmName = BNGetToonInfo(select(11, ...))
						InviteUnit(toonName.."-"..realmName)
					end
					return
				end
			end
		end
	end
	function eventframe:CHAT_MSG_WHISPER(arg1, arg2, ...)
		AutoInvite("CHAT_MSG_WHISPER", arg1, arg2, ...)
	end
	function eventframe:CHAT_MSG_BN_WHISPER(arg1, arg2, ...)
		AutoInvite("CHAT_MSG_BN_WHISPER", arg1, arg2, ...)
	end
end