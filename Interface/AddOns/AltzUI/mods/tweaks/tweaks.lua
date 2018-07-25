-- Original Author: Weasoug, etc
local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local collect = aCoreCDB["OtherOptions"]["collectgarbage"]
local acceptres = aCoreCDB["OtherOptions"]["acceptres"]
local battlegroundres = aCoreCDB["OtherOptions"]["battlegroundres"]
local hideerrors = aCoreCDB["OtherOptions"]["hideerrors"]
local saysapped = aCoreCDB["OtherOptions"]["saysapped"]
local autoscreenshot = aCoreCDB["OtherOptions"]["autoscreenshot"]
local acceptfriendlyinvites = aCoreCDB["OtherOptions"]["acceptfriendlyinvites"]
local autoinvite = aCoreCDB["OtherOptions"]["autoinvite"]
local vignettealert = aCoreCDB["OtherOptions"]["vignettealert"]
local flashtaskbar = aCoreCDB["OtherOptions"]["flashtaskbar"]
local autopet = aCoreCDB["OtherOptions"]["autopet"]
local LFGRewards = aCoreCDB["OtherOptions"]["LFGRewards"]
local autoacceptproposal = aCoreCDB["OtherOptions"]["autoacceptproposal"]
local croods = aCoreCDB["OtherOptions"]["worldmapcoords"]

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

local greylist = {
	[129158] = true,
}
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
				local id = GetContainerItemID(bag, slot)
				if link and (select(3, GetItemInfo(link))==0) and not greylist[id] then
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
					elseif needbuy > 0 then
						BuyMerchantItem(index, needbuy)
						print(format(L["购买"], needbuy, G.classcolor..ItemName.."|r"))
					end
				end
			end
		end
	end
end
--[[-----------------------------------------------------------------------------
Say Sapped
-------------------------------------------------------------------------------]]
if saysapped then
	eventframe:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	function eventframe:COMBAT_LOG_EVENT_UNFILTERED()
		local timestamp, etype, hideCaster,
        sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = CombatLogGetCurrentEventInfo()
		if (etype == "SPELL_AURA_APPLIED" or etype == "SPELL_AURA_REFRESH") and destName == G.PlayerName and spellID == 6770 then
			SendChatMessage(L["被闷了"], "SAY")
			DEFAULT_CHAT_FRAME:AddMessage(L["被闷了2"].." ".. sourceName or "(unknown)")
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
			StaticPopup_Hide("RESURRECT") 
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
local BlzGames = {
	["App"]="Battle.Net-Client",
	["D3"]="Diablo 3",
	["Hero"]="Heroes of the Storm",
	["S2"]="Starcarft 2",
	["WoW"]="World of Warcraft",
	["WTCG"]="Hearthstone",
}

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
					ConvertToRaid()
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

local errAlreadyInGroup = string.gsub(ERR_ALREADY_IN_GROUP_S, "%%s", "(%%a*)")
if autoinvite then
    eventframe:RegisterEvent("CHAT_MSG_WHISPER")
    eventframe:RegisterEvent("CHAT_MSG_BN_WHISPER")
	local function AutoInvite(event, arg1, arg2, ...)
		local keywords = {string.split(" ", aCoreCDB["OtherOptions"]["autoinvitekeywords"])}
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
	function eventframe:CHAT_MSG_WHISPER(arg1, arg2, ...)
		AutoInvite("CHAT_MSG_WHISPER", arg1, arg2, ...)
	end
	function eventframe:CHAT_MSG_BN_WHISPER(arg1, arg2, ...)
		AutoInvite("CHAT_MSG_BN_WHISPER", arg1, arg2, ...)
	end
end

--[[-----------------------------------------------------------------------------
Simple Vignette alert
-------------------------------------------------------------------------------]]
local vignettes = {}

if vignettealert then
	eventframe:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	function eventframe:VIGNETTE_MINIMAP_UPDATED(id)
		if id and not vignettes[id] then
			local info = C_VignetteInfo.GetVignetteInfo(id)
			PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
			RaidNotice_AddMessage(RaidWarningFrame, (info.name or "Unknown").." "..L["出现了！"], ChatTypeInfo["RAID_WARNING"])
			print(info.name,L["出现了！"])
			vignettes[id] = true
		end
	end
end


--[[-----------------------------------------------------------------------------
Flash Taskbar
-------------------------------------------------------------------------------]]
local flashtimer = 0

local function DoFlash()
	if (flashtimer + 5 < GetTime()) then
		FlashClientIcon()
		flashtimer = GetTime()
	end
end

if flashtaskbar then
	local DF = _G ["DetailsFramework"]
	if DF then
		hooksecurefunc ("LFGDungeonReadyStatus_ResetReadyStates", function()
			DoFlash()
		end)

		hooksecurefunc ("PVPReadyDialog_Display", function()
			DoFlash()
		end)
		
		eventframe:RegisterEvent("READY_CHECK")
		eventframe:RegisterEvent("CHAT_MSG_ADDON")

		function eventframe:READY_CHECK()
			DoFlash()
		end
		
		function eventframe:CHAT_MSG_ADDON(prefix, msg)
			if prefix == "BigWigs" and msg:find("BWPull") then
				DoFlash()
			elseif prefix == "D4" and msg:find("PT") then
				DoFlash()
			end		
		end
	end
end

--[[-----------------------------------------------------------------------------
Random Pet
-------------------------------------------------------------------------------]]

local function SummonPet(fav)
	C_Timer.After(3, function() 
		local active = C_PetJournal.GetSummonedPetGUID()
		if not active and not UnitOnTaxi("player") then		
			if fav then
				C_PetJournal.SummonRandomPet(false)
			else
				C_PetJournal.SummonRandomPet(true)
			end
		end		
	end)
end

if autopet then
	eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventframe:RegisterEvent("PLAYER_CONTROL_GAINED")
	eventframe:RegisterEvent("UNIT_EXITED_VEHICLE")
	eventframe:RegisterEvent("PLAYER_ALIVE")

	function eventframe:PLAYER_ENTERING_WORLD()
		SummonPet()
	end

	function eventframe:PLAYER_CONTROL_GAINED()
		SummonPet()
	end

	function eventframe:UNIT_EXITED_VEHICLE()
		SummonPet()
	end

	function eventframe:PLAYER_ALIVE()
		SummonPet()
	end
end

--[[-----------------------------------------------------------------------------
LFG Call to Arms rewards
-------------------------------------------------------------------------------]]

--744 Random Timewalker Dungeon 
--788 Random Warlords of Draenor Dungeon 
--789 Random Warlords of Draenor Heroic 

if LFGRewards then
	eventframe:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
end

local LFG_Timer = 0

function eventframe:LFG_UPDATE_RANDOM_INFO()
	local eligible, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(1046, LFG_ROLE_SHORTAGE_RARE)
	local IsTank, IsHealer, IsDamage = C_LFGList.GetAvailableRoles()
	
	local ingroup, tank, healer, damager, result
	
	tank = IsTank and forTank and "|cff00B2EE"..TANK.."|r" or ""
	healer = IsHealer and forHealer and "|cff00EE00"..HEALER.."|r" or ""
	damager = IsDamage and forDamage and "|cff00EE00"..DAMAGER.."|r" or ""
	
	if IsInGroup(LE_PARTY_CATEGORY) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		ingroup = true
	end
	
	if ((IsTank and forTank) or (IsHealer and forHealer) or (IsDamage and forDamage)) and not ingroup then
		if  GetTime() - LFG_Timer > 20 then -- 不要刷屏！
			PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
			RaidNotice_AddMessage(RaidWarningFrame, format(LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), ChatTypeInfo["RAID_WARNING"])
			print(format(LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager))
			LFG_Timer = GetTime()
		end
	end
end

--[[-----------------------------------------------------------------------------
LFG Auto Accept Proposal
-------------------------------------------------------------------------------]]
--[[
if croods then
	WorldMapFrameCloseButton.coordText = WorldMapFrameCloseButton:CreateFontString(nil, "OVERLAY", "GameFontGreen") 
	WorldMapFrameCloseButton.coordText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer.Child, "BOTTOM", 0, 6)

	WorldMapFrameCloseButton:HookScript("OnUpdate", function(self)
	    if select(2, GetInstanceInfo()) == "none" then
		   local map = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player")
		   local px, py = map.x, map.y
		   local x, y = GetCursorPosition() 
		   local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetEffectiveScale() 
		   local centerX, centerY = self:GetCenter() 
		   x, y = (x/scale - (centerX - (width/2))) / width, (centerY + (height/2) - y/scale) / height 
		   if px == 0 and py == 0 and (x > 1 or y > 1 or x < 0 or y < 0) then 
			  self.coordText:SetText("") 
		   elseif px == 0 and py == 0 then 
			  self.coordText:SetText(format(L["光标"].." %d, %d", x*100, y*100)) 
		   elseif x > 1 or y > 1 or x < 0 or y < 0 then 
			  self.coordText:SetText(format(L["当前"].." %d, %d", px*100, py*100)) 
		   else 
			  self.coordText:SetText(format(L["当前"].." %d, %d   "..L["光标"].." %d, %d", px*100, py*100, x*100, y*100)) 
		   end
	    end
	end) 
end]]--
--[[-----------------------------------------------------------------------------
LFG Auto Accept Proposal
-------------------------------------------------------------------------------]]
--[[
if autoacceptproposal then
	eventframe:RegisterEvent("LFG_PROPOSAL_SHOW")
end

function eventframe:LFG_PROPOSAL_SHOW()
	C_Timer.After(25, function()
		if LFGDungeonReadyDialogEnterDungeonButton:IsShown() then
			PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
		end
	end)
end
]]--