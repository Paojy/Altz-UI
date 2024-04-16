-- Original Author: Weasoug, etc
local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	eventframe[event](self, ...)
end)

--[[-----------------------------------------------------------------------------
Hide Errors
-------------------------------------------------------------------------------]]
T.RegisterInitCallback(function()
	if aCoreCDB["OtherOptions"]["hideerrors"] then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	end
end)

--[[-----------------------------------------------------------------------------
Reload Cmd
-------------------------------------------------------------------------------]]
SLASH_ALTZRL1 = "/rl"
SlashCmdList["ALTZRL"] = ReloadUI

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

eventframe:RegisterEvent('ACHIEVEMENT_EARNED')
function eventframe:ACHIEVEMENT_EARNED()
	if aCoreCDB["OtherOptions"]["autoscreenshot"] then
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
			elseif aCoreCDB["ItemOptions"]["autorepair_guild_auto"] and GetMoney() > cost then
				RepairAllItems()
				print(format(L["修理花费"].." %.1fg", cost * 0.0001))
			end
		elseif cost > 0 and GetMoney() > cost then
			RepairAllItems()
			print(format(L["修理花费"].." %.1fg", cost * 0.0001))
		end
	end
	if aCoreCDB["ItemOptions"]["autosell"] then
		for bag = 0, 4 do
			for slot = 0, C_Container.GetContainerNumSlots(bag) do
				local link = C_Container.GetContainerItemLink(bag, slot)
				local id = C_Container.GetContainerItemID(bag, slot)
				if link and (select(3, GetItemInfo(link))==0) and not greylist[id] then
					C_Container.UseContainerItem(bag, slot)
				end
			end
		end
	end
	if aCoreCDB["ItemOptions"]["autobuy"] then
		for ItemName, Need in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
			local ItemCount = GetItemCount(ItemName)
			if ItemCount < Need then			
				local numMerchantItems = GetMerchantNumItems()
				for index = 1, numMerchantItems do
					local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
					if ItemName == name then-- 有卖的嘛？
						local needbuy = Need - ItemCount
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
end
--[[-----------------------------------------------------------------------------
Accept Res
-------------------------------------------------------------------------------]]
eventframe:RegisterEvent('RESURRECT_REQUEST')
function eventframe:RESURRECT_REQUEST(name)
	if aCoreCDB["OtherOptions"]["acceptres"] then
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
eventframe:RegisterEvent('PLAYER_DEAD')
function eventframe:PLAYER_DEAD()
	if aCoreCDB["OtherOptions"]["battlegroundres"] then
		if ( select(2, GetInstanceInfo()) =='pvp' ) or (GetRealZoneText()=='Wintergrasp') or (GetRealZoneText()=='TolBarad') then
			RepopMe()
		end
	end
end

--[[-----------------------------------------------------------------------------
Hide Errors
-------------------------------------------------------------------------------]]
local allowedErrors = { }
eventframe:RegisterEvent('UI_ERROR_MESSAGE')
function eventframe:UI_ERROR_MESSAGE(message)
	if aCoreCDB["OtherOptions"]["hideerrors"] then
		if allowedErrors[message] then
			UIErrorsFrame:AddMessage(message, 1, .1, .1)
		end
	end
end

--[[-----------------------------------------------------------------------------
Simple Vignette alert
-------------------------------------------------------------------------------]]
local vignettes = {}
eventframe:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
function eventframe:VIGNETTE_MINIMAP_UPDATED(id)
	if aCoreCDB["OtherOptions"]["vignettealert"] then
		if id and not vignettes[id] and not UnitOnTaxi("player") then
			local info = C_VignetteInfo.GetVignetteInfo(id)
			if info then
				RaidNotice_AddMessage(RaidWarningFrame, (info.name or "Unknown").." "..L["出现了！"], ChatTypeInfo["RAID_WARNING"])
				print(info.name,L["出现了！"])
				vignettes[id] = true
			end
		end
	end
end

--[[-----------------------------------------------------------------------------
Flash Taskbar
-------------------------------------------------------------------------------]]
local flashtimer = 0

local function DoFlash()
	if aCoreCDB["OtherOptions"]["flashtaskbar"] then
		if (flashtimer + 5 < GetTime()) then
			FlashClientIcon()
			flashtimer = GetTime()
		end
	end
end

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


--[[-----------------------------------------------------------------------------
Random Pet
-------------------------------------------------------------------------------]]

local function SummonPet(fav)
	if aCoreCDB["OtherOptions"]["autopet"] then
		C_Timer.After(3, function()
			if InCombatLockdown() then return end
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
end

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

--[[-----------------------------------------------------------------------------
LFG Call to Arms rewards

for i = 1, GetNumRandomDungeons() do
  local id, name = GetLFGRandomDungeonInfo(i)
  print(id .. ": " .. name)
end
-------------------------------------------------------------------------------]]

eventframe:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
local LFG_Timer = 0
function eventframe:LFG_UPDATE_RANDOM_INFO()
	if aCoreCDB["OtherOptions"]["LFGRewards"] then
		local eligible, forTank, forHealer, forDamage = GetLFGRoleShortageRewards(2351, LFG_ROLE_SHORTAGE_RARE)
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
				RaidNotice_AddMessage(RaidWarningFrame, format(LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager), ChatTypeInfo["RAID_WARNING"])
				print(format(LFG_CALL_TO_ARMS, tank.." "..healer.." "..damager))
				LFG_Timer = GetTime()
			end
		end
	end
end

--[[-----------------------------------------------------------------------------
LFG Auto Accept Proposal
-------------------------------------------------------------------------------]]
--[[
eventframe:RegisterEvent("LFG_PROPOSAL_SHOW")

function eventframe:LFG_PROPOSAL_SHOW()
	if aCoreCDB["OtherOptions"]["autoacceptproposal"] then
		C_Timer.After(25, function()
			if LFGDungeonReadyDialogEnterDungeonButton:IsShown() then
				PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
			end
		end)
	end
end
]]--