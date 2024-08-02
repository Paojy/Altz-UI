-- Original Author: Weasoug, etc
local T, C, L, G = unpack(select(2, ...))

local eventframe = CreateFrame('Frame')
eventframe:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

--[[-----------------------------------------------------------------------------
Reload Cmd
-------------------------------------------------------------------------------]]
SLASH_ALTZRL1 = "/rl"
SlashCmdList["ALTZRL"] = ReloadUI

--[[-----------------------------------------------------------------------------
Auto Screenshot
-------------------------------------------------------------------------------]]
eventframe:RegisterEvent('ACHIEVEMENT_EARNED')
function eventframe:ACHIEVEMENT_EARNED()
	if aCoreCDB["OtherOptions"]["autoscreenshot"] then
		C_Timer.After(1, function()
			Screenshot()
		end)
	end
end
--[[-----------------------------------------------------------------------------
Auto repair and sell grey items
-------------------------------------------------------------------------------]]
local ignored_grey_items = {
	
}

eventframe:RegisterEvent('MERCHANT_SHOW')
function eventframe:MERCHANT_SHOW()
	if CanMerchantRepair() and aCoreCDB["ItemOptions"]["autorepair"] then
		local gearRepaired = true -- to work around bug when there's not enough money in guild bank
		local cost = GetRepairAllCost()
		if cost > 0 and CanGuildBankRepair() and aCoreCDB["ItemOptions"]["autorepair_guild"] then
			if GetGuildBankWithdrawMoney() > cost then
				RepairAllItems(true)
				for slot, id in pairs(G.SLOTS) do
					local dur, maxdur = GetInventoryItemDurability(id)
					if dur and maxdur and dur < maxdur then
						gearRepaired = false
						break
					end
				end
				if gearRepaired then
					print(format(L["修理花费"].." %.1fg ("..GUILD..")", cost * 0.0001))
				end
			elseif GetMoney() > cost then
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
				if link and (select(3, GetItemInfo(link)) == 0) and not ignored_grey_items[id] then
					C_Container.UseContainerItem(bag, slot)
				end
			end
		end
	end
	if aCoreCDB["ItemOptions"]["autobuy"] then
		for itemID, Need in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do
			local ItemCount = GetItemCount(itemID)
			local ItemName = GetItemInfo(itemID)
			if ItemCount < Need then			
				local numMerchantItems = GetMerchantNumItems()
				for index = 1, numMerchantItems do
					local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
					if ItemName == name then-- 有卖的嘛？
						local maxbuy = GetMerchantItemMaxStack(index)
						local needbuy = Need - ItemCount
						local afford_num = floor(GetMoney()/price*quantity)
						local supplied_num = quantity*numAvailable
						local result, reason
						
						if maxbuy < needbuy then
							reason = string.format(L["每次最多购买"], maxbuy, T.color_text(ItemName))
						else
							reason = ""
						end
						
						if numAvailable > 1 then -- 有限数量的商品
							result = min(maxbuy, needbuy, afford_num, supplied_num)
						else
							result = min(maxbuy, needbuy, afford_num)
						end
						
						BuyMerchantItem(index, result)
						print(string.format(L["购买"], result, T.color_text(ItemName), reason))
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
function eventframe:RESURRECT_REQUEST()
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
隐藏错误提示
-------------------------------------------------------------------------------]]
T.EnableErrorMsg = function()
	if aCoreCDB["OtherOptions"]["hideerrors"] then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end

T.RegisterInitCallback(T.EnableErrorMsg)

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

local function SummonPet()
	if aCoreCDB["OtherOptions"]["autopet"] then
		C_Timer.After(3, function()
			if InCombatLockdown() then return end
			local has_pet = C_PetJournal.GetSummonedPetGUID()
			if not has_pet and not UnitOnTaxi("player") then
				if C_PetJournal.HasFavoritePets() and aCoreCDB["OtherOptions"]["autopet_favorite"] then
					C_PetJournal.SummonRandomPet(true)
				else
					C_PetJournal.SummonRandomPet(false)
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
随机奖励

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

--[[-----------------------------------------------------------------------------
shift+click 设置焦点
-------------------------------------------------------------------------------]]
local modifier = "shift" --- "shift" "alt" "ctrl"
local mouseButton = "1" --- 1 = leftbutton, 2 = tightbutton, 3 = middle button(mouse wheel)

T.RegisterInitCallback(function()
	-- Keybinding override so that models can be shift/alt/ctrl+clicked 
	local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate") 
	f:SetAttribute("type1", "macro") 
	f:SetAttribute("macrotext", "/focus mouseover")
	SetOverrideBindingClick(f, true, modifier.."-BUTTON"..mouseButton, "FocuserButton")
	f:RegisterForClicks("LeftButtonUp", "LeftButtonDown")
	
	--	f:RegisterForClicks("LeftButtonUp") -- /dump SetCVar("ActionButtonUseKeyDown",1) 冲突
	--	f:RegisterForClicks("LeftButtonDown") -- /dump SetCVar("ActionButtonUseKeyDown",0) 冲突
end)

--[[-----------------------------------------------------------------------------
/hb 按键绑定
-------------------------------------------------------------------------------]]

SlashCmdList.MOUSEOVERBIND = function()
	EditModeManagerFrame:ClearSelectedSystem();
	EditModeManagerFrame:SetEditModeLockState("hideSelections");
	HideUIPanel(EditModeManagerFrame);
	QuickKeybindFrame:Show()
end

SLASH_MOUSEOVERBIND1 = "/hb"

T.RegisterInitCallback(function()
	QuickKeybindFrame:HookScript("OnHide", function()
		HideUIPanel(SettingsPanel)
	end)
	SettingsPanel:HookScript("OnHide", function()
		HideUIPanel(GameMenuFrame)
	end)
end)

--[[-----------------------------------------------------------------------------
快速删除宏
-------------------------------------------------------------------------------]]

eventframe:RegisterEvent("ADDON_LOADED")
function eventframe:ADDON_LOADED(arg1)
	if arg1 == "Blizzard_MacroUI" then
		MacroFrame:SetHeight(MacroFrame:GetHeight()+15)
		MacroFrameCharLimitText:ClearAllPoints()
		MacroFrameCharLimitText:SetPoint("BOTTOMRIGHT", MacroExitButton, "TOPRIGHT", 0, 10)
		
		local bu = CreateFrame("CheckButton", G.uiname.."Quick Delete Macro Button", MacroFrame, "UICheckButtonTemplate")
		bu:SetPoint("BOTTOMLEFT", MacroDeleteButton, "TOPLEFT", -3, 0)
		T.ReskinCheck(bu)
		
		bu.Text:SetText(L["快速删除"])	
		bu:SetScript("OnClick", function() end)
		
		MacroDeleteButton:HookScript("OnClick", function()
			if bu:GetChecked() then
				StaticPopup_Hide("CONFIRM_DELETE_SELECTED_MACRO")
				MacroFrame:DeleteMacro()
			end
		end)
	end
end

--[[-----------------------------------------------------------------------------
快速脱装备
-------------------------------------------------------------------------------]]
local EquipmentSlots = {16,17,1,3,5,6,7,8,9,10}

local undress = CreateFrame("Button", "_UndressButton", PaperDollFrame, "UIPanelButtonTemplate")
undress:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 0, -5)
undress:SetSize(80, 20)
undress.Text:SetText(L["脱装备"])
T.ReskinButton(undress)

undress:SetScript("OnClick", function()
	if InCombatLockdown() then return end

	local n = 1
	for i= 0,4 do 
		for j= 1, C_Container.GetContainerNumSlots(i) do 
			if not C_Container.GetContainerItemLink(i,j) and EquipmentSlots[n] then 
				PickupInventoryItem(EquipmentSlots[n])
				C_Container.PickupContainerItem(i,j)
				n= n + 1
			end
		end
	end
end)


